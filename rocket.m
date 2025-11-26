clc; clearvars; close all;

g = 9.81;

% Cac thong so su dung cho bai toan (LUON DUONG!)
hInit       = input('Do cao ban dau h0 (m): ');
mRocket     = input('Tong khoi luong ban dau cua ten lua m0 (kg): ');
% Tong khoi luong ten lua luon lon hon khoi luong nhien lieu luc dau!
mFuel       = input('Khoi luong nhien lieu ban dau (kg): ');
negFuel     = input('Toc do tieu thu nhien lieu dm/dt (kg/s): ');
vPropulsion = input('Toc do day khi v (m/s): ');

% Ket qua tinh duoc khi ten lua con nhien lieu
tUp = 0:1:(mFuel/negFuel);

%Kiểm tra xem tên lửa đủ gia tốc ban đầu để bay lên không
aTest = (vPropulsion * negFuel) ./ (mRocket - negFuel .* tUp(1)) - g;

% Kiem tra ten lua co thuc su bay khong
if aTest < 0
    %takeoff = false;
    error("Tên lửa không đủ lực đẩy ban đầu để bay lên");
else
    takeoff = true;

    aUp = (vPropulsion * negFuel) ./ (mRocket - negFuel .* tUp) - g;

    vUp = vPropulsion ...
        .* log(mRocket ./ (mRocket - negFuel .* tUp)) ...
        - g .* tUp;

    hUp = hInit + vPropulsion .* tUp ...
            - vPropulsion .* (mRocket / negFuel - tUp) ...
           .* log(mRocket ./ (mRocket - negFuel .* tUp)) ...
            - 0.5 * g .* tUp.^2;
    
    % Nghiem duong cua phuong trinh bac 2 de tim thoi gian roi cua ten lua
    coeff = roots([- 0.5 * g, vUp(end), hUp(end)]);
    coeff = ceil(coeff(coeff > 0));

    % Ket qua tinh duoc khi ten lua het nhien lieu
    %tDown = (tUp(end) + 1):1:(numel(tUp) + 1 + )
    tDown = linspace(tUp(end) + 1, tUp(end) + 1 + coeff, coeff + 1);

    %Khi tên lửa rơi xuống, tính từ mốc 0
    tDownRelative = 0:1:coeff;
    hDown = hUp(end) + vUp(end) .* tDownRelative - 0.5 .*g .* tDownRelative .^2;
    vDown = vUp(end) - g .* tDownRelative;
    aDown = -g * ones(size(tDownRelative));

    % Tong hop cac ket qua
    tTotal = [tUp, tDown];
    hTotal = [hUp, hDown];
    vTotal = [vUp, vDown];
    aTotal = [aUp, aDown];
end

% Ve do thi bieu dien ket qua da tinh duoc
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