function [bestNet, E] = train(CVP, HIDDENS, LEARNING_RATES)
    options = foptions;
    options(1) = 0;
    E = zeros(numel(HIDDENS), numel(LEARNING_RATES))-1;
    bestNet = struct;
    for h = 1:numel(HIDDENS)
        for l = 1:numel(LEARNING_RATES)
            options(18) = LEARNING_RATES(l);
            [net, E(h,l)] = crossVal(CVP, HIDDENS(h), options);
            if (E(h,l) == min(min(E(E~=-1))))
                bestNet = net; 
            end
        end
    end
end


function [net, rmse] = crossVal(CVP, nHidden, options)
    folds = 10;
    nIn = size(CVP(1).XTrain,2);
    nOut = size(CVP(1).TTrain,2);
	E = zeros(1, folds);
    
	for i=1:folds 
    
		net = rbf(nIn, nHidden, nOut, 'gaussian');
        net = rbftrain(net, options, CVP(i).XTrain, CVP(i).TTrain);
        E(i) = rbferr(net, CVP(i).XTest, CVP(i).TTest);
        
        %net = mlp(nIn, nHidden, nOut, 'linear');
		%net = netopt(net, options, CVP(i).XTrain, CVP(i).TTrain, 'graddesc')
		%E(i) = mlperr(net, CVP(i).XTest, CVP(i).TTest)
    end
	rmse = sqrt(sum(E)/10);
end