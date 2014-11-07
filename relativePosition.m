function upToLine = relativePosition(lineEquations,data, step)
for pt=2:2:size(data,2)
  for ln=1:size(lineEquations,1)
    upToLine(ln,pt/2)= data(step,pt) > (lineEquations(ln,1) * data(step,pt-1) + lineEquations(ln,2)) ;
    end
end