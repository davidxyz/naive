function [ countOfTrainingHamFiles,countOfTrainingSpamFiles,hamMap,spamMap,hamWordCounter,spamWordCounter ] = trainClassifier( trainingHam,trainingSpam )
%TRAINCLASSIFIER when give folders for training data for spam and ham class
%this function returns necessary training variables inorder to use the
%naive bayes Classifier algorithm
if nargin==0
    trainingHam = 'training/ham/';
    %error handling
    if ~isdir(trainingHam)
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', trainingHam);
        uiwait(warndlg(errorMessage));
        return;
    end
    trainingSpam = 'training/spam/';
    %error handling
    if ~isdir(trainingSpam)
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', trainingSpam);
        uiwait(warndlg(errorMessage));
        return;
    end
end
%training:
%compute the training ham email files so that the naive Bayes algorithm can
%read it
trainingHamFiles = dir(trainingHam);
countOfTrainingHamFiles=0;
hamMap=containers.Map();
hamWordCounter=0;
%loop through all files of the training/ham directory
for k = 1:length(trainingHamFiles)
  filename = strcat(trainingHam,trainingHamFiles(k).name);
  if exist(filename,'file')==2
    countOfTrainingHamFiles=countOfTrainingHamFiles+1;
    fileText=lower(fileread(filename));
    A = regexpi(fileText,'\w');
    stringBuffer='';
    stringIndexTracker=0;
    %loop through all words of text
    for indexOfWord=1:length(A)
        if A(indexOfWord)==stringIndexTracker+1
            stringBuffer =strcat(stringBuffer,fileText(A(indexOfWord)));
            stringIndexTracker=stringIndexTracker+1;
            %execute only at the end of the text
            if indexOfWord==length(A)
                %count how many times we find a distinct word in a ham email
                if isKey(hamMap,stringBuffer)
                    count=hamMap(stringBuffer);
                    hamMap(stringBuffer)=count+1;
                else
                    hamMap(stringBuffer)=1;
                end
                hamWordCounter=hamWordCounter+1;
            end
        else
            %count how many times we find a distinct word in a ham email
            if isKey(hamMap,stringBuffer)
                count=hamMap(stringBuffer);
                hamMap(stringBuffer)=count+1;
            else
                hamMap(stringBuffer)=1;
            end
            hamWordCounter=hamWordCounter+1;
            stringIndexTracker=A(indexOfWord);
            stringBuffer =fileText(A(indexOfWord));
        end
    end
  end
end
%compute the training spam email files so that the naive Bayes algorithm can
%read it
trainingSpamFiles = dir(trainingSpam);
countOfTrainingSpamFiles=0;
spamMap=containers.Map();
spamWordCounter=0;
%loop through all files of the training/ham directory
for k = 1:length(trainingSpamFiles)
  filename = strcat(trainingSpam,trainingSpamFiles(k).name);
  if exist(filename,'file')==2
    countOfTrainingSpamFiles=countOfTrainingSpamFiles+1;
    fileText=lower(fileread(filename));
    A = regexpi(fileText,'\w');
    stringBuffer='';
    stringIndexTracker=0;
    %loop through all words of text
    for indexOfWord=1:length(A)
        if A(indexOfWord)==stringIndexTracker+1
            stringBuffer =strcat(stringBuffer,fileText(A(indexOfWord)));
            stringIndexTracker=stringIndexTracker+1;
            %execute at the end of the text
            if indexOfWord==length(A)
                %count how many times we find a distinct word in a spam email
                if isKey(spamMap,stringBuffer)
                    count=spamMap(stringBuffer);
                    spamMap(stringBuffer)=count+1;
                else
                    spamMap(stringBuffer)=1;
                end
                spamWordCounter=spamWordCounter+1;
            end
        else
            %count how many times we find a distinct word in a spam email
            if isKey(spamMap,stringBuffer)
                count=spamMap(stringBuffer);
                spamMap(stringBuffer)=count+1;
            else
                spamMap(stringBuffer)=1;
            end
            spamWordCounter=spamWordCounter+1;
            stringIndexTracker=A(indexOfWord);
            stringBuffer =fileText(A(indexOfWord));
        end
    end
  end
end
%remove the subject found in every email
spamWordCounter=spamWordCounter-spamMap('subject');
remove(spamMap,'subject');

hamWordCounter=hamWordCounter-hamMap('subject');
remove(hamMap,'subject');
%save data since computation takess a while
save('trainingData','hamMap','spamMap','hamWordCounter','spamWordCounter','countOfTrainingHamFiles','countOfTrainingSpamFiles');
end

