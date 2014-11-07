function [org, trn, org_ax, trn_ax] = plotScenes(person, time, steps, env, data)
        
    env.point = [data(time,person*2-1) data(time,person*2)];
	
	if (time + steps < size(data,1))
		env.output = [data(time+steps,person*2-1) data(time+steps,person*2)];
	else
		env.output = [data(size(data,1),person*2-1) data(size(data,1),person*2)];
	end

	env.closest = closestLinePoints(env.point, env.lines, env.units);

	org = figure;
	org_ax = plotEnv(env);

	transformed = transformPoints(env);
    
    trn = figure;
	trn_ax = plotEnv(transformed);

end
