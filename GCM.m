function Target = GCM(NumberOfSheep, Iteration, SheepX, SheepY)
%Author: Hussein Abbass
%LastModified: 07-Aug-2020
%Explanation: This function calculates the global centre of mass for alist
%of sheep
GCMX = SheepX(1,Iteration);
GCMY = SheepY(1,Iteration);

for i = 2 : NumberOfSheep
    GCMX = GCMX + SheepX(i,Iteration);
    GCMY = GCMY + SheepY(i,Iteration);
end
Target = [GCMX/NumberOfSheep,GCMY/NumberOfSheep];
