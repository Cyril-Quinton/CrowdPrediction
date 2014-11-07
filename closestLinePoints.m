function [closest] = closestLinePoints(p, lines, units)
    for l = 1:size(lines, 1)
        u = units(l,:);
        a = lines(l,1:2);
        b = lines(l,3:4);
        projection = ((a-p)*u')*u;
        c = a-projection;
        if (c(1) < a(1))
            c = a;
        else
            if (c(1) > b(1))
                c = b;
            end
        end
        closest(l,:) = c;
    end
end
