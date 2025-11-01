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

resolution = 1;
%Ta khảo sát từ t = 0 đến khi hết nhiên liệu
t = 0:resolution:duration;

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

v_peak = v_t(end);
h_peak = h_t(end);
eq = h_peak + v_peak*x - 1/2*g*x^2 == 0;

S = round(solve(eq),2);
S = S(S>0);
S = S(1);

%Ta khảo sát thêm phần từ duration đến 0
t_empty = duration+resolution:resolution:duration + S;
a = [a, -g*ones(1, length(t_empty))];

v_t = [v_t, v_peak - g*(t_empty - duration)];
h_t = [h_t, h_peak + v_peak*(t_empty - duration) - 1/2*g*(t_empty - duration).^2];
t = [t, t_empty];

figure(1)
plot(t, a, 'w');
xlabel('Thời gian');
ylabel('Gia tốc');

figure(2) 
plot(t, v_t, 'g');
xlabel('Thời gian');
ylabel('Vận tốc');

figure(3)
plot(t, h_t, 'r');
xlabel('Thời gian');
ylabel('Độ cao');