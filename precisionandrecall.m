%calculate precision and recall

precision_adaboost = diag(confmat_adaboost)./sum(confmat_adaboost,2);
recall_adaboost = diag(confmat_adaboost)./sum(confmat_adaboost,1)';
precision_coarsegaussiansvm = diag(confmat_coarsegaussiansvm)./sum(confmat_coarsegaussiansvm,2);
recall_coarsegaussiansvm = diag(confmat_coarsegaussiansvm)./sum(confmat_coarsegaussiansvm,1)';
precision_gaussiansvm = diag(confmat_gaussiansvm)./sum(confmat_gaussiansvm,2);
recall_gaussiansvm = diag(confmat_gaussiansvm)./sum(confmat_gaussiansvm,1)';
precision_linearsvm = diag(confmat_linearsvm)./sum(confmat_linearsvm,2);
recall_linearsvm = diag(confmat_linearsvm)./sum(confmat_linearsvm,1)';
precision_gaussiansvm_ova = diag(confmat_gaussiansvm_ova)./sum(confmat_gaussiansvm_ova,2);
recall_gaussiansvm_ova = diag(confmat_gaussiansvm_ova)./sum(confmat_gaussiansvm_ova,1)';
precision_linearsvm_ova = diag(confmat_linearsvm)./sum(confmat_linearsvm,2);
recall_linearsvm_ova = diag(confmat_linearsvm_ova)./sum(confmat_linearsvm_ova,1)';
