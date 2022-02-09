function Output = FlockingStatistics(Ranges,SheepID,SheepX,SheepY,VelocityX,VelocityY,NumberOfSheep,Iteration);
%Author: Hussein Abbass
%LastModified: 26-Jul-2020
%Explanation: This function implements the sheep alignment behaviour, whereby
%a sheep seeks the average velocity of the flock

CohesionRange  = Ranges(1);
AlignmentRange  = Ranges(2);
CollisionRange  = Ranges(3);

GCMAlignmentDirectionX=0;
GCMAlignmentDirectionY=0;
GCMDirectionX=0;
GCMDirectionY=0;
RepulsionX  = 0;
RepulsionY  = 0;
        
NumberOfCohesion = 0;
NumberOfAllignment = 0;
NumberOfRepulsion = 0;

%Calculating the distance from the sheep of interest and the rest of the
%flock
DiffX = SheepX(SheepID,Iteration) - SheepX(:,Iteration);
DiffY = SheepY(SheepID,Iteration) - SheepY(:,Iteration);
Distances = hypot(DiffX,DiffY);

%Calculating the local centre of mass for all sheep within the cohesion
%range of that sheep and the direction between the sheep of interest and
%the global centre of mass of the sheep in its neighbourhood 
CohesionIndices = find(Distances<CohesionRange);
NumberOfCohesion = sum(Distances<CohesionRange) - 1;
if NumberOfCohesion > 0
    GCMDirectionX = (sum(SheepX(CohesionIndices,Iteration)) -  SheepX(SheepID,Iteration)) / NumberOfCohesion;
    GCMDirectionY = (sum(SheepY(CohesionIndices,Iteration)) -  SheepY(SheepID,Iteration)) / NumberOfCohesion;
    GCMDirectionX = GCMDirectionX -  SheepX(SheepID,Iteration);
    GCMDirectionY = GCMDirectionY -  SheepY(SheepID,Iteration);
end

%Calculating the average alignment vector then calculating the alignment
%vector between the velocity of the sheep of interest and the average
%direction of the sheep in its neighbourhood   
AlignmentIndices = find(Distances<AlignmentRange);
NumberOfAllignment = sum(Distances<AlignmentRange) - 1;
if NumberOfAllignment > 0
    GCMAlignmentDirectionX = (sum(VelocityX(AlignmentIndices,Iteration)) -  VelocityX(SheepID,Iteration) ) / NumberOfAllignment;
    GCMAlignmentDirectionY = (sum(VelocityY(AlignmentIndices,Iteration)) -  VelocityY(SheepID,Iteration) ) / NumberOfAllignment;
    GCMAlignmentDirectionX = GCMAlignmentDirectionX -  VelocityX(SheepID,Iteration);
    GCMAlignmentDirectionY = GCMAlignmentDirectionY -  VelocityY(SheepID,Iteration);
end

%Calculating the average directions for collision avoidance
RepulsionIndices = find(Distances<CollisionRange);
NumberOfRepulsion = sum(Distances<CollisionRange) - 1;
if NumberOfRepulsion > 0
    RepulsionX = (sum(SheepX(SheepID,Iteration) - SheepX(RepulsionIndices,Iteration)) ) / NumberOfRepulsion;
    RepulsionY = (sum(SheepY(SheepID,Iteration) - SheepY(RepulsionIndices,Iteration)) ) / NumberOfRepulsion;
end

%Normalising all force vectors
AlignmentVectorMagnitude    = hypot(GCMAlignmentDirectionX,GCMAlignmentDirectionY);
%if AlignmentVectorMagnitude > 0
    GCMAlignmentDirectionX  = GCMAlignmentDirectionX/(0.01+AlignmentVectorMagnitude);
    GCMAlignmentDirectionY  = GCMAlignmentDirectionY/(0.01+AlignmentVectorMagnitude);
%end

GCMVectorMagnitude          = hypot(GCMDirectionX,GCMDirectionY);
%if GCMVectorMagnitude > 0
    GCMDirectionX  = GCMDirectionX/(0.01+GCMVectorMagnitude);
    GCMDirectionY  = GCMDirectionY/(0.01+GCMVectorMagnitude);
%end

RepulsionMagnitude          = hypot(RepulsionX,RepulsionY);
%if RepulsionMagnitude > 0
    RepulsionX  = RepulsionX/(0.01+RepulsionMagnitude);
    RepulsionY  = RepulsionY/(0.01+RepulsionMagnitude);
%end

Output = [GCMAlignmentDirectionX,GCMAlignmentDirectionY,AlignmentVectorMagnitude,GCMDirectionX,GCMDirectionY,GCMVectorMagnitude,RepulsionX,RepulsionY,RepulsionMagnitude];
