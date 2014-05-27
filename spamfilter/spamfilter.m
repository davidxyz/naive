%testing
%naive Bayes classifier algorithm that uses laplace smoothing in order to
%determine if an email is spam or not based on the words of said email.
%load training data since data training takes a while to compute
load('trainingData','hamMap','spamMap','hamWordCounter','spamWordCounter','countOfTrainingHamFiles','countOfTrainingSpamFiles');
while 1<4 % infinite while loop
    answer=input('-q or quit to quit. Give either Directory of emails(-d dir/of/emails/) or an email(-e subject:did you enjoy yesterday night:)\n leaving the directory value blank or will make the program use its own testing directories: ','s');
    %try catch block to see if the user gives us a malformed answer
    try
        %email option
    if strcmp(answer(1:2),'-e')
        A = regexpi(answer(4:(length(answer)-1)),'\w');
        stringBuffer='';
        stringIndexTracker=0;
        %initialize probability variables with prior probability
        hamProbability=log(countOfTrainingHamFiles/(countOfTrainingSpamFiles+countOfTrainingHamFiles));
        spamProbability=log(countOfTrainingSpamFiles/(countOfTrainingSpamFiles+countOfTrainingHamFiles));
        %loop through all words of the text
        for indexOfWord=1:length(A)
            if A(indexOfWord)==stringIndexTracker+1
                stringBuffer =strcat(stringBuffer,fileText(A(indexOfWord)));
                stringIndexTracker=stringIndexTracker+1;
                %calculate naiveBayes but only execute when we reach end of
                %the url
                if indexOfWord==length(A)
                    if isKey(hamMap,stringBuffer)
                        count=hamMap(stringBuffer);
                        hamProbability=hamProbability+log((count+1)/(hamWordCounter+vocabulary));
                    else
                        hamProbability=hamProbability+log(1/(hamWordCounter+vocabulary));
                    end
                    if isKey(spamMap,stringBuffer)
                        count=spamMap(stringBuffer);
                        spamProbability=hamProbability+log((count+1)/(spamWordCounter+vocabulary));
                    else
                        spamProbability=spamProbability+log(1/(spamWordCounter+vocabulary));
                    end
                end
            else
                %calculate naiveBayes
                if isKey(hamMap,stringBuffer)
                    count=hamMap(stringBuffer);
                    hamProbability=hamProbability+log((count+1)/(hamWordCounter+vocabulary));
                else
                    hamProbability=hamProbability+log(1/(hamWordCounter+vocabulary));
                end
                if isKey(spamMap,stringBuffer)
                    count=spamMap(stringBuffer);
                    spamProbability=spamProbability+log((count+1)/(spamWordCounter+vocabulary));
                else
                    spamProbability=spamProbability+log(1/(spamWordCounter+vocabulary));
                end
                stringIndexTracker=A(indexOfWord);
                stringBuffer =fileText(A(indexOfWord));
            end
        end
        %determine its accuracy
        if hamProbability>spamProbability
            disp('this email is not spam')
        else
            disp('this email is spam')
        end
        sprintf('\n');
        %directory option
    elseif strcmp(answer(1:2),'-d')
        testingHam = 'testing/ham/';%testing directory
        %if empty supply own testing directories
        if length(answer)<=4
            testingham=answer(4:(length(answer)-1));
            
        elseif not(isdir(answer(4:(length(answer)-1))))
            fprintf('\n');
            disp(strcat(answer(4:(length(answer)-1)),'not a valid directory.'));
            continue
        end
        testingHamFiles = dir(testingHam);
        countOfTestingHamFiles=0;
        vocabulary=length(union(keys(hamMap),keys(spamMap)));%all the words that the naive bayes classifer knows
        %loop through all files in the testing directory
        for k = 1:length(testingHamFiles)
            filename = strcat(testingHam,testingHamFiles(k).name);
            if exist(filename,'file')==2
                countOfTestingHamFiles=countOfTestingHamFiles+1;
                fileText=lower(fileread(filename));
                A = regexpi(fileText,'\w');
                stringBuffer='';
                stringIndexTracker=0;
                %initialize probability variables with prior probability
                hamProbability=log(countOfTrainingHamFiles/(countOfTrainingSpamFiles+countOfTrainingHamFiles));
                spamProbability=log(countOfTrainingSpamFiles/(countOfTrainingSpamFiles+countOfTrainingHamFiles));
                %loop through all words of the text
                for indexOfWord=1:length(A)
                    if A(indexOfWord)==stringIndexTracker+1
                        stringBuffer =strcat(stringBuffer,fileText(A(indexOfWord)));
                        stringIndexTracker=stringIndexTracker+1;
                        %calculate naiveBayes but only execute when we
                        %reach the end of the text
                        if indexOfWord==length(A)
                            if isKey(hamMap,stringBuffer)
                                count=hamMap(stringBuffer);
                                hamProbability=hamProbability+log((count+1)/(hamWordCounter+vocabulary));
                            else
                                hamProbability=hamProbability+log(1/(hamWordCounter+vocabulary));
                            end
                            if isKey(spamMap,stringBuffer)
                                count=spamMap(stringBuffer);
                                spamProbability=hamProbability+log((count+1)/(spamWordCounter+vocabulary));
                            else
                                spamProbability=spamProbability+log(1/(spamWordCounter+vocabulary));
                            end
                        end
                    else
                        %calculate naiveBayes
                        if isKey(hamMap,stringBuffer)
                            count=hamMap(stringBuffer);
                            hamProbability=hamProbability+log((count+1)/(hamWordCounter+vocabulary));
                        else
                            hamProbability=hamProbability+log(1/(hamWordCounter+vocabulary));
                        end
                        if isKey(spamMap,stringBuffer)
                            count=spamMap(stringBuffer);
                            spamProbability=spamProbability+log((count+1)/(spamWordCounter+vocabulary));
                        else
                            spamProbability=spamProbability+log(1/(spamWordCounter+vocabulary));
                        end
                        stringIndexTracker=A(indexOfWord);
                        stringBuffer =fileText(A(indexOfWord));
                    end
                end
                %determine its accuracy
                if hamProbability>spamProbability
                    strcat(filename,' is not spam')
                else
                    strcat(filename,' is spam')
                end
            end
        end
        fprintf('\n');
        %quit
    elseif strcmp(answer(1:2),'-q') | strcmp(answer(1:4),'quit')
        break
    else
        fprintf('\n');
        disp('Option not supported. Please use either -d for directory, -e a single email, or -q to quit');
    end
    catch err
        fprintf('\n');
        disp('Option not supported. Please use either -d for directory, -e a single email, or -q to quit');
    end
end
