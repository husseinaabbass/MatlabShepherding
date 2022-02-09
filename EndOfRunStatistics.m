
function Output = EndOfRunStatistics(MinX,MaxX,MinY,MaxY,NumberOfSheep,NumberOfSteps,SheepX, SheepY, SheepDogX, SheepDogY)
Width = MaxX - MinX;
Height = MaxY - MinY;
StatisticsMatrix = zeros(Width,Height,1);

for i = 1 : NumberOfSheep
    for j = 1 : NumberOfSteps
        SX = int64(SheepX(i,j));
        SY = int64(SheepY(i,j));
        SX = max(MinX+1,min(MaxX,int64(SX)));
        SY = max(MinY+1,min(MaxY,int64(SY)));
        StatisticsMatrix(SX,SY) = StatisticsMatrix(SX,SY) + 1.0;
    end
end
Output = StatisticsMatrix;