function Output = sheepflocking(SheepDogX,SheepDogY,Ranges,Weights,Boundary,SheepX,SheepY,VelocityX,VelocityY,SheepID,Iteration,NumberOfSheep,SheepVehicleSpeedLimit);
%Author: Hussein Abbass
%LastModified: 26-Jul-2020
%Explanation: This function implements sheep flocking

%%
MinX = Boundary(1);
MaxX = Boundary(2);
MinY = Boundary(3);
MaxY = Boundary(4);

WeightCohesion  = Weights(1);
WeightCollision = Weights(2);
WeightAlignment = Weights(3);
InfluenceOfDogWeight = Weights(4);
WeightOfInertia = Weights(5);
InfluenceRange = Ranges(4);
%%


ClosestSheepIndex = 0;
ClosestSheepDistance = 1e+50;

Output = FlockingStatistics(Ranges,SheepID,SheepX,SheepY,VelocityX,VelocityY,NumberOfSheep,Iteration);
GCMAlignmentDirectionX      = Output(1);
GCMAlignmentDirectionY      = Output(2);
AlignmentVectorMagnitude    = Output(3);
GCMDirectionX               = Output(4);
GCMDirectionY               = Output(5);
GCMVectorMagnitude          = Output(6);
CollisionX                  = Output(7);
CollisionY                  = Output(8);
RepulsionMagnitude          = Output(9);

% if (Iteration > 1)
%     OldVelocityX = VelocityX(SheepID,Iteration-1);
%     OldVelocityY = VelocityY(SheepID,Iteration-1);
% else
    OldVelocityX = VelocityX(SheepID,Iteration);
    OldVelocityY = VelocityY(SheepID,Iteration);
% end

CurrentPosition = [SheepX(SheepID,Iteration) SheepY(SheepID,Iteration)];
VelocityRequiredX =  WeightOfInertia*OldVelocityX + WeightCohesion * GCMDirectionX + WeightAlignment * GCMAlignmentDirectionX + WeightCollision * CollisionX;
VelocityRequiredY =  WeightOfInertia*OldVelocityY + WeightCohesion * GCMDirectionY + WeightAlignment * GCMAlignmentDirectionY + WeightCollision * CollisionY;


%We added two parameters to this function
%SheepDogX, SheepDogY. We will use both of them below to calculate
%direction to the dog and updated VelocityRequiredX and VelocityRequiredY
%with this direction as well as InfluenceRange and InfluenceOfDogWeight,
%representing the range a dog has an influence on a sheep and the weight of
%that influence
DirectionToDogX =  CurrentPosition(1) - SheepDogX;
DirectionToDogY =  CurrentPosition(2) - SheepDogY;
DirectionToDogMagnitude = hypot(DirectionToDogX,DirectionToDogY);
DirectionToDogX = DirectionToDogX / DirectionToDogMagnitude;
DirectionToDogY = DirectionToDogY / DirectionToDogMagnitude;
if DirectionToDogMagnitude < InfluenceRange
    VelocityRequiredX = VelocityRequiredX + InfluenceOfDogWeight * DirectionToDogX;
    VelocityRequiredY = VelocityRequiredY + InfluenceOfDogWeight * DirectionToDogY;
end

if hypot(VelocityRequiredX,VelocityRequiredY) < 0.02 
    VelocityRequiredX = rand()/2;
    VelocityRequiredY = rand()/2;
end
    
    
XNew = CurrentPosition(1) + VelocityRequiredX;
YNew = CurrentPosition(2) + VelocityRequiredY;

if XNew < MinX
    VelocityRequiredX = 0.0 - VelocityRequiredX;
end
if XNew > MaxX
    VelocityRequiredX = 0.0 - VelocityRequiredX;
end
if YNew < MinY
    VelocityRequiredY = 0.0 - VelocityRequiredY;
end
if YNew > MaxY
    VelocityRequiredY = 0.0 - VelocityRequiredY;
end

VelocityCurrent = [VelocityRequiredX VelocityRequiredY];
Output=sheepvehiclemodel(CurrentPosition, SheepVehicleSpeedLimit, VelocityCurrent, [VelocityRequiredX VelocityRequiredY], [VelocityCurrent(1) 0; 0 VelocityCurrent(2)]);
SheepDirectionX = Output(1,1);
SheepDirectionY = Output(1,2);
Xnew = Output(2,1);
Ynew = Output(2,2);
%OrientationNew = [Output(3,1) Output(3,1); Output(4,1) Output(4,1)];

Output = [Xnew,Ynew,SheepDirectionX,SheepDirectionY];
