five_weights = exp(1:5)/sum(exp(1:5));
%seven_weights = exp(1:7)/sum(exp(1:7));
train_feature_table = features_train(train,5,five_weights);
test_feature_table = features_test(test,5,five_weights);
%train_feature_table = features_train(train,7,seven_weights);
%test_feature_table = features_test(test,7,seven_weights);
[confmat_linearsvm_ova,accuracy_linearsvm_ova]=evaluate_performance(linearSVM_ova,test_feature_table,3);
[confmat_linearsvm,accuracy_linearsvm]=evaluate_performance(linearSVM,test_feature_table,3);
[confmat_gaussiansvm,accuracy_gaussiansvm]=evaluate_performance(GaussianSVM,test_feature_table,3);
[confmat_gaussiansvm_ova,accuracy_gaussiansvm_ova]=evaluate_performance(GaussianSVM_ova,test_feature_table,3);
[confmat_coarsegaussiansvm,accuracy_coarsegaussiansvm]=evaluate_performance(CoarseGaussianSVM,test_feature_table,3);
%[confmat_quadraticsvm,accuracy_quadraticsvm]=evaluate_performance(QuadraticSVM,test_feature_table,3);
[confmat_adaboost,accuracy_adaboost]=evaluate_performance(Adaboost,test_feature_table,3);