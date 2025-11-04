clc; clearvars; close all;

g = 9.81;

% Các thông s? s? d?ng cho bài toán (LUÔN D??NG!)
hInit       = input('Do cao ban dau h0 (m): ');
mRocket     = input('Tong khoi luong ban dau cua ten lua m0 (kg): ');
% T?ng kh?i l??ng tên l?a luôn l?n h?n kh?i l??ng nhiên li?u lúc ban ??u!
mFuel       = input('Khoi luong nhien lieu ban dau (kg): ');
negFuel     = input('Toc do tieu thu nhien lieu dm/dt (kg/s): ');
vPropulsion = input('Toc do day khi v (m/s): ');

% K?t qu? tính ???c khi tên l?a khi còn nhiên li?u
tUp = 0:1:(mFuel/negFuel);
hUp = hInit + vPropulsion .* tUp ...
            - vPropulsion .* (mRocket / negFuel - tUp) ...
           .* log(mRocket ./ (mRocket - negFuel .* tUp)) ...
            - 0.5 * g .* tUp.^2;
vUp = vPropulsion ...
   .* log(mRocket ./ (mRocket - negFuel .* tUp)) ...
    - g .* tUp;
aUp = (vPropulsion * negFuel) ./ (mRocket - negFuel .* tUp) - g;

% Nghi?m d??ng c?a ph??ng trình b?c 2 tìm th?i gian r?i c?a tên l?a
coeff = roots([- 0.5 * g, vUp(end), hUp(end)]);
coeff = ceil(coeff(coeff > 0));

% K?t qu? tính ???c khi tên l?a khi h?t nhiên li?u
tDown = (tUp(end) + 1):1:(numel(vUp) + coeff - 2);
hDown = hUp(end) + vUp(end) .* (1:1:length(tDown)) - 0.5 .* g .* (1:1:length(tDown)) .^ 2;
vDown = vUp(end) - g .* (1:1:length(tDown));
aDown = -g * ones(size(tDown));

% T?ng h?p các k?t qu?
tTotal = [tUp, tDown];
hTotal = [hUp, hDown];
vTotal = [vUp, vDown];
aTotal = [aUp, aDown];

% Ki?m tra tên l?a có th?c s? bay không
if hUp(2) < 0
    hTotal(:) = 0;
    vTotal(:) = 0;
    aTotal(:) = 0;
end;
    
% V? ?? th? bi?u di?n k?t qu? ?ã tính ???c
figure(1)
plot(tTotal, aTotal, 'b');
title('GIA TOC THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('GIA TOC $(m/s^2)$', 'Interpreter', 'latex');
grid on;

figure(2)
plot(tTotal, vTotal, 'g');
title('VAN TOC THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('VAN TOC $(m/s)$', 'Interpreter', 'latex');
grid on;

figure(3)
plot(tTotal, hTotal, 'r');
title('DO CAO THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('DO CAO $(m)$', 'Interpreter', 'latex');
grid on;