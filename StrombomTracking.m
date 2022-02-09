function Output = StrombomTracking(SheepDogVehicleSpeedLimit, TargetX, TargetY, Xold, Yold, SheepDogDirectionXold, SheepDogDirectionYold, MinX, MinY, MaxX, MaxY,SheepDogVelocity, SafetyDistance,maximumDistance)
%Author: Hussein Abbass
%LastModified: 07-Aug-2020
%Explanation: This function implements the very basic strombom movement
%algorithm. It does not take into account the vehicle model and modulation
%of speed

DirectionX = TargetX  - Xold;
DirectionY = TargetY  - Yold;

Distance = hypot(DirectionX,DirectionY);
Speed = min(Distance,SheepDogVehicleSpeedLimit)';
SheepDogDirectionX = DirectionX / Distance;
SheepDogDirectionY = DirectionY / Distance;

ModualtedSheepDogVelocity=Speed;

DirectionX = ModualtedSheepDogVelocity * SheepDogDirectionX;
DirectionY = ModualtedSheepDogVelocity * SheepDogDirectionY;

Xnew = Xold + DirectionX;
Ynew = Yold + DirectionY;

if Xnew < MinX
    Xnew = MinX;
end
if Xnew > MaxX
    Xnew = MaxX;
end

if Ynew < MinY
    Ynew = MinY;
end
if Ynew > MaxY
    Ynew = MaxY;
end
Output = [Xnew,Ynew,SheepDogDirectionX,SheepDogDirectionY];