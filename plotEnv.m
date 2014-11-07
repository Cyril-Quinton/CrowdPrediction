function [ax] = plotEnv(env)
    
    point = env.point;
    source = env.source;
    points = env.points;
    lines = env.lines;
    closest = env.closest;
    circle = env.circle;
    output = env.output;
    
    
    clf;
    hold on;
    grid on;
    set(gcf, 'Position', [265 5 750 1000])
    set(gca,'DataAspectRatio',[1 1 1]);
    
    
    
    % draw lines
    for l = 1:size(lines, 1)
        line([lines(l,1) lines(l,3)],[lines(l,2) lines(l,4)],'LineWidth', 1, 'Color','k');
        line([point(1) closest(l,1)],[point(2) closest(l,2)],'LineStyle','--', 'Color','g');
    end
    
    
    
    % draw environmental objects (circle)
    radius = circle(3);
    t=(0:50)*2*pi/50;
    x=radius*cos(t)+circle(1);
    y=radius*sin(t)+circle(2);
    plot(x,y,'Color',[0 0 0]);
    
    
    
    % draw relevant points
    for i = 1:size(points, 1)
        plot(points(i,1),points(i,2),'k.','MarkerSize',20);
    end
    
    
    
    % draw source
    plot(source(1),source(2),'r.','MarkerSize',20);
    
    
    
    % draw point
    plot(point(1),point(2),'b.','MarkerSize',15);
    
    
    
    % draw output
    plot(output(1),output(2),'g.','MarkerSize',10);
    
    ax = gca;
end
