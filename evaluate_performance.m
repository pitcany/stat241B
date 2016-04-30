function [confmat,accuracy] = evaluate_performance(classifier,test_data,num_classes)

if (num_classes == 3)
    actual=test_data(:,'FTR').FTR;
elseif (num_classes == 2)
    actual=test_data(:,'AwayWins').AwayWins;
elseif (num_classes == 1)
    actual=test_data(:,'HomeWins').HomeWins;
end

predicted=classifier.predictFcn(test_data);
%tells us the f1-score and the overall performance of our classifier
confmat=confusionmat(actual,predicted);
correct=sum(diag(confmat));
total=sum(confmat(:));
accuracy=correct/total;

precision = diag(confmat)./sum(confmat,2);
recall = diag(confmat)./sum(confmat,1)';
f1Scores = 2*(precision.*recall)./(precision+recall);