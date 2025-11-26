% rocket - Compute motion of a rocket using the Verlet method
clear all;      % Clear memory
help rocket;    % Print header

%@ Initialize variables (e.g., mass, burn rate, exhaust velocity)
y = 0;            % Initial position (m)
mass = 2.5e6;     % Initial mass of the rocket (kg)
dm_dt = -1.6e4;   % Burn rate (kg/s)
gravity = 9.81;   % Gravitational acceleration (m/s^2)
ExhaustU = input('Enter exhaust velocity (m/s): ');
FinalT = input('Enter final time (s): ');
dt = 0.5;         % Time increment (s)
NSteps = FinalT/dt;  % Number of steps

%@ Do the first step using the Euler method 
a = -dm_dt*ExhaustU/mass - gravity;  % Acceleration
yNew = y + dt*a;           % Compute the new height (Euler)
yOld = y;      % Current position becomes old position
y = yNew;      % New position becomes current position
mass = mass + dt*dm_dt;   % Compute new mass
tPlot(1) = dt;            % Record time
yPlot(1) = y;             % Record height

%@ Do the rest of the steps using the Verlet method
for iStep=2:NSteps

  %@ Compute the new height using Verlet
  a = -dm_dt*ExhaustU/mass - gravity;  % Acceleration
  yNew = 2*y - yOld + dt^2*a;     
  yOld = y;      % Current position becomes old position
  y = yNew;      % New position becomes current position
  
  %@ Compute the new mass
  mass = mass + dt*dm_dt;   
  
  %@ Record time and height for plotting
  tPlot(iStep) = iStep*dt;      % Record time
  yPlot(iStep) = y;             % Record height
  
end

%@ Plot the position versus time 
clf;  figure(gcf);    % Clear figure; bring figure window forward
plot(tPlot,yPlot);    % Plot height versus time
xlabel('Time (s)');  ylabel('Height (m)');
