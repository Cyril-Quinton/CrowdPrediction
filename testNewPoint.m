function [correctPoint,squareSize] = testNewPoint(x,y,data,parentPointIndex,squareSize,upToLine,lineEquations)
  correctPoint=true;
  for pt=2:2:size(data,2) % verify if the new point is not in a other major point area
      if (pt~=parentPointIndex) 
	sz=squareSize(pt/2);
	if (x>data(1,pt-1) - sz & x < data(1,pt-1) + sz)
	  if (y > data(1,pt) - sz & y < data(1,pt) + sz)
	     correctPoint=false;
	     return
	  end
	end
      end
  end
  for ln=1:8			%verify if the new point verify the line constraints
    if upToLine(ln,parentPointIndex/2) ~= (y>lineEquations(ln,1)*x+lineEquations(ln,2))
	correctPoint=false;
	return
    end
  end
  rd=max(abs(x-data(1,parentPointIndex-1)),abs(y-data(1,parentPointIndex)));
  if rd > squareSize(parentPointIndex/2)
      squareSize(parentPointIndex/2)=rd;
  end
end