function Flag = FormEquation(x,y,gx,gy,testx,testy)
format long
VectorGCMToGoal = [gx gy] - [x y];
Constant = VectorGCMToGoal(1) * x + VectorGCMToGoal(2) * y;

DistanceToGoal  = VectorGCMToGoal(1) * gx       + VectorGCMToGoal(2) * gy;
DistanceToGCM   = VectorGCMToGoal(1) * x        + VectorGCMToGoal(2) * y;
DistanceToAgent = VectorGCMToGoal(1) * testx    + VectorGCMToGoal(2) * testy;
Flag = 1;
if (DistanceToAgent >= DistanceToGCM) && (DistanceToGoal >= DistanceToGCM)
    if (DistanceToAgent <= DistanceToGoal) 
        Flag = 0;
    end
end
if (DistanceToAgent <= DistanceToGCM) && (DistanceToGoal <= DistanceToGCM)
    if (DistanceToAgent >= DistanceToGoal) 
        Flag = 0;
    end    
end
