close all;
clc;
workspace;

%% Run Parameters 
PauseLength = 0.0;
NumberOfSheep = 20;
NumberOfSteps = 630 + 20 * NumberOfSheep;
SheepInitialCentreOfMass = [50 50];
SheepInitialRadius = 20;
SheepDogInitialOffsetFromSheepLocation = 20;
SheepVehicleSpeedLimit = 1.5;
SheepDogVehicleSpeedLimit = 2.0;
MaximumSafetyDistance = 0;
SheepDogBehaviourIndex = 9;
SheepBehaviourIndex = 4;
TargetSelectionIndex = 4;
DrivingCollectingPointsSafetyDistance = 1;

MinX = 0;
MaxX = 50;
MinY = 0;
MaxY = 50;
Boundary = [MinX,MaxX,MinY,MaxY];

CollisionRange = 0.4; %MaxX / 40.0;
CohesionRange = 30; %MaxX / 10.0;
AlignmentRange = MaxX / 10.0;
InfluenceRange = 65; MaxX / 10.0; 
Ranges = [CohesionRange,AlignmentRange,CollisionRange,InfluenceRange];

WeightCollision = 2.0;
WeightCohesion = 1.05;
WeightAlignment = 0.0;
InfluenceOfDogWeight = 1.0;
WeightOfInertia = 0.5;
Weights = [WeightCohesion,WeightCollision,WeightAlignment,InfluenceOfDogWeight,WeightOfInertia];

GoalX = 10;
GoalY = 10;
GoalRadius = round(sqrt(NumberOfSheep),0);
Goal = [GoalX,GoalY,GoalRadius];
%% Implemented Sheepdog Behaviours
switch SheepDogBehaviourIndex
    case 9
            % Approaching the nearest neighbor 
            SheepDogBehaviorType = 'Strombom'; 
end
%% Sheep Behaviour
switch SheepBehaviourIndex
     case 4
        MotionType = 'flocking';
end
%% Target Selection Method
switch TargetSelectionIndex
    case 4
            TargetSelectionMethod = 'StrombomSelection';
end
%% Main Function Call
MultiSheepSingleSheepdog(NumberOfSteps,Goal,Ranges,Weights,Boundary,MotionType,NumberOfSheep,SheepVehicleSpeedLimit,SheepDogVehicleSpeedLimit,SheepDogBehaviorType,TargetSelectionMethod,MaximumSafetyDistance,DrivingCollectingPointsSafetyDistance,SheepDogInitialOffsetFromSheepLocation,PauseLength);