clc; clearvars; close all;

g = 9.81;

%Các thông số sử dụng trong bài toán (Luôn dương)
hInit       = input('Do cao ban dau h0 (m): ');
mRocket     = input('Tong khoi luong ban dau cua ten lua m0 (kg): ');
%Tổng khối lượng tên lửa luôn lớn hơn khối lượng nhiên liệu
mFuel       = input('Khoi luong nhien lieu ban dau (kg): ');
negFuel     = input('Toc do tieu thu nhien lieu dm/dt (kg/s): ');
vPropulsion = input('Toc do day khi v (m/s): ');
alpha       = input('Góc tạo bởi tên lửa và phương thẳng đứng: ');

%Kết quả tính được khi tên lửa còn nhiên liệu
tUp = 0:1:(mFuel/negFuel);

%Kiểm tra xem tên lửa đủ gia tốc ban đầu để bay lên không
aTest = (vPropulsion * negFuel) * cosd(alpha) ./ (mRocket - negFuel .* tUp(1)) - g;

%Kiểm tra tên lửa có bay lên được không
if aTest < 0
    %takeoff = false;
    error("Tên lửa không đủ lực đẩy ban đầu để bay lên");
else
    takeoff = true;

    axUp = vPropulsion * negFuel * sind(alpha) ./ (mRocket - negFuel * tUp);
    ayUp = (vPropulsion * negFuel) * cosd(alpha) ./ (mRocket - negFuel .* tUp) - g;

    vxUp = vPropulsion * log(mRocket ./ (mRocket - negFuel * tUp)) * sind(alpha);
    vyUp = vPropulsion ...
        .* log(mRocket ./ (mRocket - negFuel .* tUp)) * cosd(alpha) ...
        - g .* tUp;
    
    dUp = vPropulsion .* tUp * sind(alpha) ...
        - vPropulsion .* (mRocket / negFuel - tUp) ...
        .* log(mRocket ./ (mRocket - negFuel .* tUp)) * sind(alpha);
    hUp = hInit + vPropulsion .* tUp * cosd(alpha) ...
            - vPropulsion .* (mRocket / negFuel - tUp) ...
           .* log(mRocket ./ (mRocket - negFuel .* tUp)) * cosd(alpha) ...
            - 0.5 * g .* tUp.^2;
    
    % Nghiem duong cua phuong trinh bac 2 de tim thoi gian roi cua ten lua
    coeff = roots([- 0.5 * g, vyUp(end), hUp(end)]);
    coeff = ceil(coeff(coeff > 0));

    % Ket qua tinh duoc khi ten lua het nhien lieu
    %tDown = (tUp(end) + 1):1:(numel(tUp) + 1 + )
    tDown = linspace(tUp(end) + 1, tUp(end) + 1 + coeff, coeff + 1);

    %Khi tên lửa rơi xuống, tính từ mốc 0
    tDownRelative = 0:1:coeff;

    vyDown = vyUp(end) - g .* tDownRelative;
    vxDown = vxUp(end) * ones(size(tDownRelative));

    ayDown = -g * ones(size(tDownRelative));
    axDown = zeros(size(tDownRelative));

    hDown = hUp(end) + vyUp(end) .* tDownRelative - 0.5 .*g .* tDownRelative .^2;
    dDown = vxDown .* tDownRelative + dUp(end);

    % Tong hop cac ket qua
    tTotal = [tUp, tDown];
    hTotal = [hUp, hDown];
    vxTotal = [vxUp, vxDown];
    vyTotal = [vyUp, vyDown];
    ayTotal = [ayUp, ayDown];
    dTotal = [dUp, dDown];
end

% Ve do thi bieu dien ket qua da tinh duoc
figure(1)
plot(tTotal, ayTotal, 'b');
title('GIA TOC THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('GIA TOC $(m/s^2)$', 'Interpreter', 'latex');
grid on;

figure(2)
plot(tTotal, vyTotal, 'g');
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

figure(4)
plot(dTotal, hTotal, 'r');
title('TOA DO THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('X $(Do doi)$', 'Interpreter', 'latex');
ylabel('Y $(m)$', 'Interpreter', 'latex');
grid on;