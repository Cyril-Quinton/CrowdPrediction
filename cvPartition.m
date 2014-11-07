function [CVP] = cvPartition(X, T, nFolds)
    CVP(nFolds) = struct;
    Indexes = crossvalind('Kfold', size(X,1), nFolds);
    for i=1:nFolds
        TrainIndexes = find(Indexes~=i);
        TestIndexes = find(Indexes==i);
        CVP(i).XTrain = X(TrainIndexes,:);
        CVP(i).TTrain = T(TrainIndexes,:);
        CVP(i).XTest = X(TestIndexes,:);
        CVP(i).TTest = T(TestIndexes,:);
    end
end

