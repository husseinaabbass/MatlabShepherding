function influence=DecayedInfluence(distance,minimumDistance,maximumDistance)
alpha = 3;
I1 = find(distance < minimumDistance);
I2 = find(distance > maximumDistance);
distance(I1) = minimumDistance;
distance(I2) = maximumDistance;
distance = (distance - minimumDistance)/(maximumDistance- minimumDistance);
influence= (exp(alpha * distance) - 1)  / (exp(alpha) - 1);
end