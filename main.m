clc, clearvars, close all
syms x;

m0 = input('Nhập khối lượng ban đầu của tên lửa (kg): '); %Dương
m_fuel = input('Nhập khối lượng ban đầu của nhiên liệu: '); %Dương
m_rocket = m0 - m_fuel;
h0 = input('Nhập vị trí ban đầu của tên lửa (m): '); %Dương
dm_dt = input('Nhập tốc độ đốt nhiên liệu (kg/s): '); %Âm
v_air = input('Nhập vận tốc đẩy khí (m/s): '); %Dương (có dấu - trong ct)

%Hằng số rơi tự do
g = 9.81;

%Tìm t khi tên lửa hết nhiên liệu
duration = -m_fuel/dm_dt;

%Chu kì
cycle = 0.01;
%Ta khảo sát từ t = 0 đến khi hết nhiên liệu
t = 0:cycle:duration;

%Khối lượng tên lửa theo thời gian là
m = m0 + dm_dt*t;

%Hàm tính gia tốc tới khi hết nhiên liệu
a = -v_air*(dm_dt./m) - g;

%Kiểm tra nếu gia tốc < 0 và ở trên mặt đất thì tên lửa đứng yên do có lực
%nâng
for i=1:length(a)
    if (a(i) < 0)
        a(i) = 0;
    elseif a(i) > 0
        break;
    end
end

%Hàm tính tích phân tích lũy
v_t = cumtrapz(t, a);
h_t = cumtrapz(t, v_t) + h0;

%Nếu tên lửa bay lên được, nó sẽ rớt xuống được
if sum(a) ~= 0
    v_peak = v_t(end);
    h_peak = h_t(end);
    eq = h_peak + v_peak*x - 1/2*g*x^2 == 0;
    
    %Solve sẽ trả về kiểu dữ liệu sym, phải đổi sang double
    S = round(solve(eq),2);
    S = S(S>0);
    S = double(S(1));
    %Ta khảo sát thêm phần từ duration đến 0
    t_empty = (duration):cycle:(duration + S);
    a_empty = -g*ones(1, length(t_empty));
    a = [a, a_empty];
    
    t_empty_0 = (t_empty - duration);
    
    v_t_empty = v_peak - g*t_empty_0;
    v_t = [v_t, v_t_empty];

    h_t_empty = h_peak + v_peak*t_empty_0 - 1/2*g*t_empty_0.^2;
    h_t = [h_t, h_t_empty];
    t = [t, t_empty];
end

%Tìm gia tốc lớn nhất, lưu lại index, đó là điểm hết nhiên liệu
a_max = max(a);

t_fuel_end = (find(t >= duration, 1, "first"));
t_fuel_end = t_fuel_end(1);
%Lưu lại các giá trị mà tại đó nó hết nhiên liệu
a_fuel_end = a(t_fuel_end);
v_fuel_end = v_t(t_fuel_end);
h_fuel_end = h_t(t_fuel_end);

figure(1)
plot(t, a, 'w');
hold on; % Giữ đồ thị
%Đánh dấu điểm hết nhiên liệu
plot(t(t_fuel_end), a_max, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
hold off; % Trả lại
xlabel('Thời gian');
ylabel('Gia tốc');
legend('Gia tốc', 'Hết nhiên liệu', 'Location', 'best'); % Thêm chú thích

[v_max, t_v_max] = max(v_t);
figure(2) 
plot(t, v_t, 'g');
hold on;
%Đánh dấu điểm hết nhiên liệu
plot(t(t_fuel_end), v_fuel_end, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
%Đánh dấu điểm bắt đầu rơi (đỉnh quỹ đạo, v~0)
legend('Vận tốc', 'hết nhiên liệu');
hold off;
xlabel('Thời gian');
ylabel('Vận tốc');

[h_max, t_h_max] = max(h_t);

t_h_ground = length(h_t);
h_ground = h_t(end);
figure(3)
plot(t, h_t, 'r');
hold on;
%Đánh dấu điểm hết nhiên liệu
plot(t(t_fuel_end), h_fuel_end, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
%Đánh dấu điểm bắt đầu rơi (đỉnh quỹ đạo), chỉ vẽ nếu tên lửa bay lên được
if sum(a) ~= 0
    plot(t(t_h_max), h_max, 'bs', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
end
%Đánh dấu điểm chạm đất, chỉ vẽ nếu tên lửa bay lên đc
if sum(a) ~= 0
    plot(t(t_h_ground), h_ground, 'kd', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
    % Tạo chú thích
    if ~isnan(t_h_max)
        legend('Độ cao', 'Hết nhiên liệu', 'Đỉnh quỹ đạo', 'Chạm đất', 'Location', 'best');
    else
        legend('Độ cao', 'Hết nhiên liệu', 'Chạm đất', 'Location', 'best');
    end
else
    legend('Độ cao', 'Hết nhiên liệu', 'Location', 'best');
end
%axis([0 1 0 1]);
hold off;
xlabel('Thời gian');
ylabel('Độ cao');