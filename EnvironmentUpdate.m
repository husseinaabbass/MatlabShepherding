%Author: Hussein Abbass
%LastModified: 21-Jul-2020
%Explanation: This is the main function updating gents' positions in the
%discrete simulation environment

function Output = EnvironmentUpdate(MinX,MaxX,MinY,MaxY,OldPositionX, OldPositionY, NewPositionX, NewPositionY, Environment)
OldSX = max(MinX+1,min(MaxX,int64(OldPositionX)));
OldSY = max(MinY+1,min(MaxY,int64(OldPositionY)));
NewSX = max(MinX+1,min(MaxX,int64(NewPositionX)));
NewSY = max(MinY+1,min(MaxY,int64(NewPositionY)));

Environment(OldSX,OldSY) = Environment(OldSX,OldSY) - 1.0;
Environment(NewSX,NewSY) = Environment(NewSX,NewSY) + 1.0;
Output = Environment;