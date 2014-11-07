function [transformed] = transformPoints(env)
    
    point = env.point;
    source = env.source;
    points = env.points;
    lines = env.lines;
    closest = env.closest;
    circle = env.circle;
    output = env.output;
    
    
    refPoint = source-point;
    
    length = sqrt(refPoint(1)^2 + refPoint(2)^2);
    sin_ = refPoint(2) / length;
    cos_ = refPoint(1) / length;
    
    rotationMatrix = [	cos_ sin_;
        -sin_ cos_];
    
    transformed.point = [0 0];
    transformed.source = rotate(source-point);
    transformed.points = rotate(shift(points));
    lineStarts = rotate(shift(lines(:, 1:2)));
    lineEnds = rotate(shift(lines(:, 3:4)));
    transformed.lines = [lineStarts lineEnds];
    transformed.closest = rotate(shift(closest));
    transformed.circle = [rotate(circle(1:2)-point) circle(3)];
    
    % This is the vector that the person will follow when
    % the source of the panic is on the right hand side.
    transformed.output = rotate(output-point);
    
    function [res] = shift(pnts)
        res = zeros(size(pnts,1),2);
        for i = 1:size(pnts)
            res(i,:) = pnts(i,:) - point;
        end
    end
    
    function [res] = rotate(pnts)
        res = zeros(size(pnts,1),2);
        for i = 1:size(pnts)
            res(i,:) = (rotationMatrix*pnts(i,:)')';
        end
    end
    
end
