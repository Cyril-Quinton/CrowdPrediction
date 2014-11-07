load 'dataset_final_assignment.mat';

end_time = size(data,1);
number_of_agents = size(data,2)/2;

max_x = 600;
max_y = 800;



% pre-process data (mirror all people over y-axis, !only if not already done!)
if data(1,2) > max_y/2
  for i = 1:end_time
    for a = 1:size(data(1,:),2)/2
      data(i,2*a) = max_y-data(i,2*a);
    end
  end
end



% relevant points (e.g. corners of buildings)
% NOTE: "max_y" operation was added, because image needs to be y-mirrorred
points = [546.8, max_y-478.0;
          507.5, max_y-330.6;
          240.6, max_y-218.6;
          184.7, max_y-331.3];



% sources of panic (e.g. shouting individual)
source = [542.0, max_y-439.0];

      

% solid lines that cannot be passed (buildings, fences, ...)
% NOTE: some lines have been made longer than represented in the data
lines = [321.2, max_y-314.5, 240.0, 300.0;          % was 321.2, max_y-314.5, 286.1, max_y-396.9;
         321.2, max_y-314.5, 275.5, max_y-292.0;
         383.0, max_y-336.4, 342.0, 300.0;          % was 383.0, max_y-336.4, 365.2, max_y-407.2
         383.0, max_y-336.4, 600.0, 358.0;          % was 383.0, max_y-336.4, 431.2, max_y-359.6
         385.3, max_y-321.6, 448.0, max_y-347.4;
         448.0, max_y-347.4, 449.0, max_y-313.9;
         449.0, max_y-313.9, 390.5, max_y-292.0;
         390.5, max_y-292.0, 385.3, max_y-321.6];
 lin=lines;



%%%%%%%%%%%%%%%%%%%%%%

%%% Pre-processing %%%

%%%%%%%%%%%%%%%%%%%%%%


% calculate slopes, bases and unit vectors of solid lines
for l = 1:size(lines, 1)
	slopes(l) = (lines(l, 4) - lines(l, 2)) / (lines(l, 3) - lines(l, 1));
	bases(l) = lines(l, 2) - slopes(l) * lines(l, 1);

	units(l,:) = [1/sqrt(slopes(l)^2+1) (slopes(l)/sqrt(slopes(l)^2+1))];

	% shift left point to the begining of the vector
	if (lines(l,1) > lines(l,3))
		lines(l,:) = [lines(l,3:4) lines(l,1:2)];
	end
end



% Circle coordinates
center = [386.9 max_y-208.9];
radius = sqrt((center(1)-374.3)^2+(center(2)-(max_y-257.2))^2);
circle = [center radius];

% Wrapper for the variables
env.source = source;
env.points = points;
env.lines = lines;
env.units = units;
env.circle = circle;
