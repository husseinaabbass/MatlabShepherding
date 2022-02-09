function Output = TargetSelection(SelectionMethod,NumberOfSheep, Iteration, SheepX, SheepY, SheepDogX, SheepDogY,Goal,CollisionRange,DrivingCollectingPointsSafetyDistance)
Output = [-10,-10];
if strcmp(SelectionMethod,'StrombomSelection')
    %Driving and Collecting Points
    
    CurrentGCM = GCM(NumberOfSheep, Iteration, SheepX, SheepY);
    %Output = AreSheepClustered(NumberOfSheep, Iteration, SheepX, SheepY, CurrentGCM(1), CurrentGCM(1),CollisionRange);
    Output = AreSheepClusteredUpdatedForFurthestSheepFromGoal(NumberOfSheep, Iteration, SheepX, SheepY, CurrentGCM(1), CurrentGCM(2),Goal,CollisionRange);
    NeighbourhoodRange = Output(1);
    Clustered = Output(2);
    FurthestSheepDistance = Output(3);
    FurthestSheepIndex = Output(4);
    
    if (Clustered == true)
        dx = (CurrentGCM(1) - Goal(1));
        dy = (CurrentGCM(2) - Goal(2));
        NormalisedValue = hypot(dx,dy);
        DrivingPointX = CurrentGCM(1) + (DrivingCollectingPointsSafetyDistance + NeighbourhoodRange) *  dx / NormalisedValue;
        DrivingPointY = CurrentGCM(2) + (DrivingCollectingPointsSafetyDistance + NeighbourhoodRange) *  dy / NormalisedValue;
        Output = [DrivingPointX,DrivingPointY,1];
    else
        dx = (SheepX(FurthestSheepIndex,Iteration) - CurrentGCM(1));
        dy = (SheepY(FurthestSheepIndex,Iteration) - CurrentGCM(2));
        NormalisedValue = hypot(dx,dy);
        CollectingPointX = SheepX(FurthestSheepIndex,Iteration) + (DrivingCollectingPointsSafetyDistance + CollisionRange) *  dx / NormalisedValue;
        CollectingPointY = SheepY(FurthestSheepIndex,Iteration) + (DrivingCollectingPointsSafetyDistance + CollisionRange) *  dy / NormalisedValue;
        Output = [CollectingPointX,CollectingPointY,0];
    end
end

