clc; clearvars; close all;

g = 9.81;

%Các thông số sử dụng trong bài toán (Luôn dương)
hInit       = input('Độ cao ban đầu h0 (m): ');
mRocket     = input('Tổng khối lượng ban đầu của tên lửa m0 (kg): ');
%Tổng khối lượng tên lửa luôn lớn hơn khối lượng nhiên liệu
mFuel       = input('Khối lượng nhiên liệu ban đầu (kg): ');
negFuel     = input('Tốc độ tiêu thụ nhiên liệu dm/dt (kg/s): ');
vPropulsion = input('Tốc độ đẩy khí (m/s): ');
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
    
    % Tìm nghiệm dương của phương trình bậc 2 để tìm thời gian rơi
    coeff = roots([- 0.5 * g, vyUp(end), hUp(end)]);
    coeff = ceil(coeff(coeff > 0));

    % Kết quả tính được khi tên lửa hết nhiên liệu
    %tDown = (tUp(end) + 1):1:(numel(tUp) + 1 + )
    tDown = linspace(tUp(end) + 1, tUp(end) + 1 + coeff, coeff + 1);

    %Khi tên lửa rơi xuống, tính từ mốc 0
    tDownRelative = 0:1:coeff;

    vyDown  = vyUp(end) - g .n* tDownRelative;
    vxDown  = vxUp(end) * ones(size(tDownRelative));

    ayDown  = -g * ones(size(tDownRelative));
    axDown  = zeros(size(tDownRelative));

    hDown   = hUp(end) + vyUp(end) .* tDownRelative - 0.5 .*g .* tDownRelative .^2;
    dDown   = vxDown .* tDownRelative + dUp(end);

    %Tổng hợp kết quả
    tTotal  = [tUp, tDown];
    hTotal  = [hUp, hDown];
    vxTotal = [vxUp, vxDown];
    vyTotal = [vyUp, vyDown];
    ayTotal = [ayUp, ayDown];
    dTotal  = [dUp, dDown];
end

%Vẽ đồ thị
figure(1)
plot(tTotal, ayTotal, 'b');
title('Đồ thị gia tốc theo thời gian', 'Interpreter', 'latex');
xlabel('Thời gian $(s)$', 'Interpreter', 'latex');
ylabel('Gia tốc $(m/s^2)$', 'Interpreter', 'latex');
grid on;

figure(2)
plot(tTotal, vyTotal, 'g');
title('Đồ thị vận tốc theo thời gian', 'Interpreter', 'latex');
xlabel('Thời gian $(s)$', 'Interpreter', 'latex');
ylabel('Vận tốc $(m/s)$', 'Interpreter', 'latex');
grid on;

figure(3)
plot(tTotal, hTotal, 'r');
title('Đồ thị độ cao theo thời gian', 'Interpreter', 'latex');
xlabel('Thời gian $(s)$', 'Interpreter', 'latex');
ylabel('Độ cao $(m)$', 'Interpreter', 'latex');
grid on;

figure(4)
plot(dTotal, hTotal, 'r');
title('Đồ thị tọa độ theo thời gian', 'Interpreter', 'latex');
xlabel('X $(m)$', 'Interpreter', 'latex');
ylabel('Y $(m)$', 'Interpreter', 'latex');
grid on;