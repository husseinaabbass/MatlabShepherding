function Output = SheepAtGoal(NumberOfSheep, Iteration, SheepX, SheepY, Goal)

X = SheepX(:,Iteration) - Goal(1);
Y = SheepY(:,Iteration) - Goal(2);
Distances = hypot(X,Y);
NumberOfSheepAtGoal = sum(Distances<Goal(3));
Output = false;
if (NumberOfSheepAtGoal == NumberOfSheep)
    Output = true;
end

