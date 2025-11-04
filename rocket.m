clc; clearvars; close all;

g = 9.81;

% hInit = input('hInit: ');
% mRocket = input('mRocket: ');
% mFuel = input('mFuel: ');
% negFuel = input('negFuel: ');
% vPropulsion = input('vPropulsion: ');

hInit = 0;
mRocket = 550000;
mFuel = 500000;
negFuel = 250;
vPropulsion = 3500;

tUp = 0:1:(mFuel/negFuel);
hUp = hInit + vPropulsion .* tUp ...
            - vPropulsion .* (mRocket / negFuel - tUp) ...
           .* log(mRocket ./ (mRocket - negFuel .* tUp)) ...
            - 0.5 * g .* tUp.^2;
vUp = vPropulsion ...
   .* log(mRocket ./ (mRocket - negFuel .* tUp)) ...
    - g .* tUp;
aUp = (vPropulsion * negFuel) ./ (mRocket - negFuel .* tUp) - g;

coeff = roots([- 0.5 * g, vUp(end), hUp(end)]);
coeff = ceil(coeff(coeff > 0));

tDown = (tUp(end) + 1):1:(numel(vUp) + coeff - 2);
hDown = hUp(end) + vUp(end) .* [1:1:numel(tDown)] - 0.5 .* g .* [1:1:numel(tDown)] .^ 2;
hDown = hDown(hDown > 0);
vDown = vUp(end) - g .* [1:1:numel(tDown)];
aDown = -g * ones(size(tDown));

tTotal = [tUp, tDown];
hTotal = [hUp, hDown];
vTotal = [vUp, vDown];
aTotal = [aUp, aDown];

if hUp(2) < 0
    hTotal(:) = 0;
    vTotal(:) = 0;
    aTotal(:) = -g;
end;
    
figure(1);
plot(tTotal, hTotal, 'r');
grid on;

figure(2);
plot(tTotal, hTotal, 'g');
grid on;

figure(3);
plot(tTotal, aTotal, 'b');
grid on;