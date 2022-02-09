function Target = AreSheepClusteredUpdatedForFurthestSheepFromGoal(NumberOfSheep, Iteration, SheepX, SheepY, GCMX, GCMY, Goal, CollisionRange)
%Author: Hussein Abbass
%LastModified: 07-Aug-2020
%Explanation: This function checks if the sheep are clusterd, and if not,
%it finds the furthest sheep from the centroid of the cluster

NeighbourhoodRange = CollisionRange * sqrt(2 * NumberOfSheep);

Clustered = false;
FurthestSheepDistance = 0;
FurthestSheepIndex = 0;

X = SheepX(:,Iteration) - GCMX;
Y = SheepY(:,Iteration) - GCMY;
Distances = hypot(X,Y);
NumbersWithinCluster = sum(Distances<=NeighbourhoodRange);

if NumbersWithinCluster == NumberOfSheep
    Clustered = true;
else
    FurthestSheepDistance = 0;
    FurthestSheepIndex = 0;
    for i = 1 : NumberOfSheep
        Value = FormEquation(GCMX,GCMY,Goal(1),Goal(2),SheepX(i,Iteration),SheepY(i,Iteration));
        if Value == 1
            Distance = hypot((SheepX(i,Iteration)-GCMX),(SheepY(i,Iteration)-GCMY));
            if Distance > FurthestSheepDistance
                FurthestSheepDistance = Distance;
                FurthestSheepIndex = i;
            end
        end
    end
    if FurthestSheepDistance <= NeighbourhoodRange
        Clustered = true;
    end
end

Target = [NeighbourhoodRange,Clustered,FurthestSheepDistance,FurthestSheepIndex];
