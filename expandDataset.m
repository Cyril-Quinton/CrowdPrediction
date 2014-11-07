function data=expandDataset(data,lines)
NB_NEW_POINT_PER_POINT=20;
SIGMA=3;
%calculate each line equation
lineEquations=zeros(size(lines,1),2);        
for i=1:size(lines,1)
  a=(lines(i,4)-lines(i,2))/(lines(i,3)-lines(i,1));
  b=lines(i,2)-(a*lines(i,1));
  lineEquations(i,1)=a;
  lineEquations(i,2)=b;
end



%specify in the matrix upToLine the relative position of points with lines. 
upToLine=zeros(size(lines,1),35);
upToLine = relativePosition(lineEquations,data, 1);

squareSize=zeros(1,35);
newPoints=zeros(47,NB_NEW_POINT_PER_POINT*5*35);
newPointIndex=5;

% Creating new points at step one
for i=1:NB_NEW_POINT_PER_POINT
  for parentPointIndex=2:2:size(data,2)		
    correctPoint=false;
    while correctPoint==false
      correctPoint=true;
      x=normrnd(data(1,parentPointIndex-1),SIGMA);	% generating a x and y coordinate around the parent point
      y=normrnd(data(1,parentPointIndex),SIGMA);	% with a gaussian distribution
      [correctPoint,squareSize]=testNewPoint(x,y,data,parentPointIndex,squareSize,upToLine,lineEquations); % verifie if the new point respects the line constraints
													   % and the 'square' constraints
    end
    newPoints(1,newPointIndex-4)=x;
    newPoints(1,newPointIndex-3)=y;
    newPoints(1,newPointIndex-2)=int8(parentPointIndex/2); 	% parent point
    newPoints(1,newPointIndex-1)=x-data(1,parentPointIndex-1); %distance from parent point on x axis
    newPoints(1,newPointIndex)=y-data(1,parentPointIndex);	%distance from parent point on y axis	
    newPointIndex=newPointIndex+5;
  end
end


% extending the newPoints dataset untill the last step
for step=2:size(data,1)
  for parentPointIndex=2:2:size(data,2)     
      for newPointIndex=5:5:size(newPoints,2)
	if newPoints(1,newPointIndex-2)== parentPointIndex/2
	  x=data(step,parentPointIndex-1)+newPoints(1,newPointIndex-1);
	  y=data(step,parentPointIndex)+newPoints(1,newPointIndex);
	  newPoints(step,newPointIndex-4)=x;
	  newPoints(step,newPointIndex-3)=y;
	  upToLine = relativePosition(lineEquations,data, step);
	  [correctPoint,squareSize]=testNewPoint(x,y,data,parentPointIndex,squareSize,upToLine,lineEquations);
	  if correctPoint==false 
	    newPoints(1,newPointIndex-2)=0;  %discard the point from the dataset if it doesn't respect the constraints
	  end
	end
      end
    end
  end
  
 % add new points to the original dataset
for newPointIndex=5:5:size(newPoints,2)
  if newPoints(1,newPointIndex-2) ~= 0
    data(:,size(data,2)+1:size(data,2)+2)=newPoints(:,newPointIndex-4:newPointIndex-3);
  end
end
end
	    