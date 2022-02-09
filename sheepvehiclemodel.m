function Output=sheepvehiclemodel(Position, MaximumSpeed, VelocityCurrent, VelocityRequired, Orientation)

%Information Needed
MaximumForce = 1.0;
Mass = 1.0;
Epsilon = 0.00001;

%Calculating steering direction from orientation
SteeringDirection = VelocityRequired - VelocityCurrent;

% Truncating the steering force to ensure it does not exceed maximum force
SteeringForce = hypot(SteeringDirection(1),SteeringDirection(2));
if SteeringForce ==  0
    SteeringForce = Epsilon;
end
SteeringDirection = SteeringDirection ./ SteeringForce;
SteeringDirection = SteeringDirection .* min(SteeringForce,MaximumForce);

%Calculating acceleration needed to achieve steering force
AccelerationDesired = SteeringDirection ./ Mass;

%Calculating velocity without exceeding maximum speed
VelocityDesired = VelocityCurrent + AccelerationDesired;
SpeedDesired = hypot(VelocityDesired(1),VelocityDesired(2));
if SpeedDesired ==  0
    SpeedDesired = Epsilon;
end
Direction = VelocityDesired / SpeedDesired;
VelocityNew = Direction * min(SpeedDesired,MaximumSpeed);

%Updating vehicle position
PositionNew = Position + VelocityNew;

%Updating vehicle orientation
SpeedNew = hypot(VelocityNew(1),VelocityNew(2));
if SpeedNew ==  0
    SpeedNew = Epsilon;
end
SinTheta = VelocityNew(2) / SpeedNew;
CosTheta = VelocityNew(1) / SpeedNew;
OrientationNew = [CosTheta -SinTheta; SinTheta CosTheta] * Orientation;

Output = [VelocityNew; PositionNew; OrientationNew];
end