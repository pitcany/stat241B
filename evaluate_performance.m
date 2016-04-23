function [f1Scores,accuracy] = evaluate_performance(classifier,test_data)

actual=test_data(:,'HomeWins').HomeWins;
predicted=classifier.predictFcn(test_data);
%tells us the f1-score and the overall performance of our classifier
confmat=confusionmat(actual,predicted);
correct=confmat(1,1)+confmat(2,2);
total=sum(confmat(:));
accuracy=correct/total;

precision = diag(confmat)./sum(confmat,2);
recall = diag(confmat)./sum(confmat,1)';
f1Scores = 2*(precision.*recall)./(precision+recall);