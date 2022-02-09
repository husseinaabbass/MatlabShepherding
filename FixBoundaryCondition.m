function Output = FixBoundaryCondition(MinX,MaxX,MinY,MaxY,PositionX,PositionY)
%LastModified: 22-Feb-2020
%Explanation: This function implements a randomwalk in a bounded 2D with
%wrapping around when the particle leaves the boundaries

if PositionX < MinX 
    PositionX = MinX+1;
end
if PositionY < MinY 
    PositionY = MinY+1;
end
if PositionX > MaxX 
    PositionX = MaxX-1;
end
if PositionY > MaxY 
    PositionY = MaxY-1;
end
Output = [PositionX,PositionY];