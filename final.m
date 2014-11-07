function final
    loadEnv;
    
    HIDDENS = 1:1:4;
    LEARNING_RATES = 0.01:0.01:0.5;
    data = expandDataset(data, lin);
    
    
    % create inputs and outputs
    for time=1:end_time-1
        for a = 1:number_of_agents
            env.point = [data(time,(2*a)-1) data(time, 2*a)];
            env.output = [data(time+1,(2*a)-1) data(time+1, 2*a)];
            env.closest = closestLinePoints(env.point, env.lines, env.units);
            
            transformed = transformPoints(env);

            row = (time-1) * number_of_agents + a;
            inputs(row,:) = inputvector(transformed, time);
            outputs(row,:) = transformed.output;
            % For inputs without rotation we need to add extra values
            inputs_org(row,:) = [inputvector(env, time) env.source(2) env.point];
            outputs_org(row,:) = [env.output env.source(2) env.point];
        end
    end

    
    
    


    %
    % Train and evaluate networks
    %
    
    % Train network with rotation and closest points on lines as inputs
    tic;
    CVP = cvPartition(inputs(:,1:end-numel(env.closest)), outputs, 10);
    [bestNet_lines, E_lines] = train(CVP, HIDDENS, LEARNING_RATES);
    time_lines = toc;
    
    % Train network with rotation and lines as inputs
    tic;
    CVP = cvPartition(inputs(:,numel(env.lines)+1:end), outputs, 10);
    [bestNet_closest, E_closest] = train(CVP, HIDDENS, LEARNING_RATES);
    time_closest = toc;

    % Train network without rotation and with closest points on lines as inputs
    tic;
    CVP = cvPartition(inputs_org(:,1:end-numel(env.closest)), outputs_org, 10);
    [bestNet_lines_org, E_lines_org] = train(CVP, HIDDENS, LEARNING_RATES);
    time_lines_org = toc;
    
    % Train network without rotation and with lines as inputs
    tic;
    CVP = cvPartition(inputs_org(:,numel(env.lines)+1:end), outputs_org, 10);
    [bestNet_closest_org, E_closest_org] = train(CVP, HIDDENS, LEARNING_RATES);
    time_closest_org = toc;
    
    
    
            %
            % Plot the results
            %
   
    
        % Plot results with rotation 
    
    % Results when using lines in input
    [errors, lrIdx] = min(E_lines, [], 2);
    f1 = figure;
    plot(HIDDENS, errors);
    title('Errors with lines as inputs using rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Root MSE');
    print(f1, 'errors_by_hidden_lines_rot.png', '-dpng');
    
    f2 = figure;
    plot(HIDDENS, LEARNING_RATES(lrIdx));
    title('Best learning rates with lines as inputs using rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Best Learning rate');
    print(f2, 'lr_by_hidden_lines_rot.png', '-dpng');
    
    
    % Results when using closest points in lines in input 
    [errors, lrIdx] = min(E_closest, [], 2);
    f4 = figure;
    plot(HIDDENS, errors);
    title('Errors with closest points on lines as inputs using rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Root MSE');
    print(f4, 'errors_by_hidden_closest_rot.png', '-dpng');
    
    f5 = figure;
    plot(HIDDENS, LEARNING_RATES(lrIdx));
    title('Best learning rates with closest points on lines as inputs using rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Best Learning rate');
    print(f5, 'lr_by_hidden_closest_rot.png', '-dpng');
    
   

        % Plot results without rotation 
    
    % Results when using lines in input
    [errors, lrIdx] = min(E_lines_org, [], 2);
    f7 = figure;
    plot(HIDDENS, errors);
    title('Errors with lines as inputs without rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Root MSE');
    print(f7, 'errors_by_hidden_lines_org.png', '-dpng');
    
    f8 = figure;
    plot(HIDDENS, LEARNING_RATES(lrIdx));
    title('Best learning rates with lines as inputs without rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Best Learning rate');
    print(f8, 'lr_by_hidden_lines_org.png', '-dpng');
    
    
    
    % Results when using closest points in lines in input 
    [errors, lrIdx] = min(E_closest_org, [], 2);
    f10 = figure;
    plot(HIDDENS, errors);
    title('Errors with closest points on lines as inputs without rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Root MSE');
    print(f10, 'errors_by_hidden_closest_org.png', '-dpng');
    
    f11 = figure;
    plot(HIDDENS, LEARNING_RATES(lrIdx));
    title('Best learning rates with closest points on lines as inputs without rotation' );
    xlabel('Number of hidden neurons');
    ylabel('Best Learning rate');
    print(f11, 'lr_by_hidden_closest_org.png', '-dpng');

    
    
        % Plot the scenery with original data and with best nets   
    
    [f13, f14, f13_ax, f14_ax] = plotScenes(27,1,47,env,data);
    title(f13_ax, 'Scene with person 27 before rotation');
    print(f13, 'person_27_org.png', '-dpng');
    title(f14_ax, 'Scene with person 27 after rotation');
    print(f14, 'person_27_rot.png', '-dpng');
    
    
        % Plot the influence of rotation and input type
    
    %Plot all networks
    f15 = figure;
    bar([min(min(E_lines_org)) 
        min(min(E_lines)) 
        min(min(E_closest_org)) 
        min(min(E_closest))]);
    title('Influence of input type and the use of rotation on the error')
    set(gca,'XTickLabel',{'lines', 'lines with rotation', 'points on lines', 'points on lines with rotation'})
    ylabel('Root MSE');
    print(f15, 'rotation_and_inputs.png', '-dpng');
    
    %Plot networks with rotation
    f16 = figure;
    bar([min(min(E_lines)) 
        min(min(E_closest))]);
    title('Influence of input type on error when using rotation')
    set(gca,'XTickLabel',{'lines with rotation', 'points on lines with rotation'})
    ylabel('Root MSE');
    print(f16, 'rotation.png', '-dpng');
    
        %Plot the time for each network
    
    f17 = figure;
    bar([time_lines_org 
        time_lines 
        time_closest_org 
        time_closest]);
    title('Time to train the network')
    set(gca,'XTickLabel',{'lines', 'lines with rotation', 'points on lines', 'points on lines with rotation'})
    ylabel('Seconds');
    print(f17, 'times.png', '-dpng');
        

    
    close all;
end

function [vec] = inputvector(e, time)
        s = e.source(1); % we only need the x value = distance
        p = reshape(e.points', [], 1);
        l = reshape(e.lines', [], 1);
        cl = reshape(e.closest', [], 1);
        c = e.circle(1:2)'; 
        % The order of l and cl is important when we want to reduce inputs
        vec = [l; s; p; time; c; cl]';
end