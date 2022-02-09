function MultiSheepSingleSheepdog(NumberOfSteps,Goal,Ranges,Weights,Boundary,MotionType,NumberOfSheep,SheepVehicleSpeedLimit,SheepDogVehicleSpeedLimit,SheepDogBehaviorType,TargetSelectionMethod,MaximumSafetyDistance,DrivingCollectingPointsSafetyDistance,SheepDogInitialOffsetFromSheepLocation,PauseLength)
format long g;
format compact;
fontSize = 12;

MinX = Boundary(1);
MaxX = Boundary(2);
MinY = Boundary(3);
MaxY = Boundary(4);

CohesionRange  = Ranges(1);
AlignmentRange  = Ranges(2);
CollisionRange  = Ranges(3);

%% Update 1: Code to create a data structure suitable for a discrete
%environment to hold number of agent in each cell in the environment

Environment = zeros((MaxX - MinX),(MaxY - MinY),1);
%%
%% Update 1: Validating that the Environment variable includes all sheep by displaying its total on the screen
sum(sum(Environment(:,:)))
%%
SheepDogVelocity = 100;

n=1;
SheepX = (MaxX - MinX) / 2 + sign(rand()/2.0 - 1) * rand(NumberOfSheep,NumberOfSteps) * (MaxX - MinX) / 10;
SheepY = (MaxY - MinY) / 2 + sign(rand()/2.0 - 1) * rand(NumberOfSheep,NumberOfSteps) * (MaxX - MinX) / 10;
VelocityX = 0.5 + rand(NumberOfSheep,NumberOfSteps)/2.0;
VelocityY = 0.5 + rand(NumberOfSheep,NumberOfSteps)/2.0;

if strcmp(SheepDogBehaviorType,'Strombom')
    StartSheepDogX = max(SheepX(:,1)) + SheepDogInitialOffsetFromSheepLocation;
    StartSheepDogY = max(SheepY(:,1)) + SheepDogInitialOffsetFromSheepLocation;
    SheepDogX(n) = StartSheepDogX;
    SheepDogY(n) = StartSheepDogY;
    SheepDogDirectionX(n+1) = 0;
    SheepDogDirectionY(n+1) = 0;
    SafetyDistance = 4;
end
%% Update 1: Code to count number of agents in each cell in the discrete environment
for i = 1 : NumberOfSheep
    SX = int64(SheepX(i,1));
    SY = int64(SheepY(i,1));
    Environment(SX,SY) = Environment(SX,SY) + 1.0;
end
%%
MyVideoTitle = ['SheepBehaviour=',MotionType,'-NumberOfSheep',int2str(NumberOfSheep),'-SheepDogBehaviour=',SheepDogBehaviorType,'-TargetSelection',TargetSelectionMethod,'.avi'];
MyVideo = VideoWriter(MyVideoTitle);
open(MyVideo);

MyImageTitle = ['SheepBehaviour_',MotionType,'_NumberOfSheep',int2str(NumberOfSheep),'-NumberOfSteps=',int2str(NumberOfSteps),'_SheepDogBehaviour=',SheepDogBehaviorType,'_TargetSelection',TargetSelectionMethod];

MyTitle = ['SheepBehaviour = ',MotionType,' - NumberOfSheep ',int2str(NumberOfSheep),' - SheepDogBehaviour = ',SheepDogBehaviorType,' - TargetSelection ',TargetSelectionMethod];

figure()
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 20;
hold on;
for i = 1 : NumberOfSheep
    lnh1(i) = plot(SheepX(i,n), SheepY(i,n), 'ro','MarkerFaceColor','k');
end

lnh2 = plot(StartSheepDogX(n), StartSheepDogY(n), 'ko','MarkerFaceColor','r');
lnh3 = quiver(StartSheepDogX(n),StartSheepDogY(n),1,1,0,'MaxHeadSize',2,'color','g');
lnh4 = plot(0,0,'gp', 'MarkerFaceColor','green', 'MarkerSize',10);


Theta = 0:pi/50:2*pi;
xunit = Goal(3) * cos(Theta) + Goal(1);
yunit = Goal(3) * sin(Theta) + Goal(2);
lnh5 = plot(xunit, yunit,'r');

axis([MinX MaxY MinY MaxY]);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0.05, 1, 0.95]);
title(MyTitle,'FontSize',fontSize);
set(gca,'nextplot','replacechildren');

frame = getframe(gcf);
writeVideo(MyVideo,frame);

AllSheepAtGoal = false;
EndSimulation = true;
while EndSimulation
    title([MyTitle,int2str(n)],'FontSize',fontSize);
    %sum(sum(Environment))
    for i = 1 : NumberOfSheep
        if strcmp(MotionType,'flocking')
            NewLocation = sheepflocking(SheepDogX(n), SheepDogY(n),Ranges,Weights,Boundary,SheepX,SheepY,VelocityX,VelocityY,i,n,NumberOfSheep,SheepVehicleSpeedLimit);
        end
        
        MNewLocation = FixBoundaryCondition(MinX,MaxX,MinY,MaxY,NewLocation(1),NewLocation(2));
        %% Update 1: Updating sheep location in the environment and validating that it is always producing the right output
        Environment = EnvironmentUpdate(MinX,MaxX,MinY,MaxY,SheepX(i,n),SheepY(i,n),MNewLocation(1),MNewLocation(2),Environment);
        %%
        
        SheepX(i,n+1) = MNewLocation(1);
        SheepY(i,n+1) = MNewLocation(2);
        
        VelocityX(i,n+1) = NewLocation(3);
        VelocityY(i,n+1) = NewLocation(4);
        line([SheepX(i,n) SheepX(i,n+1)], [SheepY(i,n) SheepY(i,n+1)], 'Color',[0 0 0]+0.9, 'LineWidth', 1);
        set(lnh1(i),'XData',[SheepX(i,n+1)],'YData',[SheepY(i,n+1)]);
    end
	if strcmp(SheepDogBehaviorType,'Strombom')
        Target = TargetSelection(TargetSelectionMethod,NumberOfSheep, n, SheepX, SheepY, SheepDogX(n), SheepDogY(n),Goal,CollisionRange,DrivingCollectingPointsSafetyDistance);
        SheepDogOutput = StrombomTracking(SheepDogVehicleSpeedLimit, Target(1), Target(2), SheepDogX(n), SheepDogY(n), SheepDogDirectionX(n), SheepDogDirectionY(n), MinX, MinY, MaxX, MaxY,SheepDogVelocity, SafetyDistance,MaximumSafetyDistance);
    end  
    SheepDogX(n+1) = SheepDogOutput(1);
    SheepDogY(n+1) = SheepDogOutput(2);
    SheepDogDirectionX(n+1) = SheepDogOutput(3);
    SheepDogDirectionY(n+1) = SheepDogOutput(4);
    
    if (Target(3) == 0)
        set(lnh4,'XData',[Target(1)],'YData',[Target(2)],'MarkerFaceColor','green','Color','green');
    else
        set(lnh4,'XData',[Target(1)],'YData',[Target(2)],'MarkerFaceColor','red','Color','red');
    end
    line([SheepDogX(n) SheepDogX(n+1)], [SheepDogY(n) SheepDogY(n+1)], 'Color',[0.1 0 0]+0.9, 'LineWidth', 1);
    set(lnh2,'XData',[SheepDogX(n+1)],'YData',[SheepDogY(n+1)]);
    set(lnh3,'XData',[SheepDogX(n+1)],'YData',[SheepDogY(n+1)],'UData',[6*SheepDogDirectionX(n)],'VData',[6*SheepDogDirectionY(n)]);
    n = n + 1;
    uistack(lnh1,'top');
    uistack(lnh2,'top');
    uistack(lnh3,'top');
    %pause(PauseLength);
    frame = getframe(gcf);
    writeVideo(MyVideo,frame);
        AllSheepAtGoal = SheepAtGoal(NumberOfSheep, n, SheepX, SheepY, Goal);
    if ((n >= NumberOfSteps) || AllSheepAtGoal)
        EndSimulation = false;
    end
end

close(MyVideo);
Output = EndOfRunStatistics(MinX,MaxX,MinY,MaxY,NumberOfSheep,NumberOfSteps,SheepX, SheepY, SheepDogX, SheepDogY);
figure;
surf(Output);
colormap(spring);
set(gcf, 'Position', get(0, 'Screensize'));
title(['Distribution of Sheep Coverage (Number of Nonempty Cells = ',int2str(nnz(Output)),' out of a total of ',int2str((MaxX-MinX)*(MaxY-MinY)),')']);
print(MyImageTitle,'-djpeg');


%% Update 1: Visualising and printing the final environment
figure;
surf(Environment);
colormap(spring);
set(gcf, 'Position', get(0, 'Screensize'));
title(['Final Position of Sheep in the Environment']);
MyImageTitle1 = ['SheepPosition_',MotionType,'_NumberOfSheep',int2str(NumberOfSheep),'-NumberOfSteps=',int2str(NumberOfSteps),'_SheepDogBehaviour=',SheepDogBehaviorType,'_TargetSelection',TargetSelectionMethod];
print(MyImageTitle1,'-djpeg');
