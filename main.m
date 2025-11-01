clc, clearvars, close all

m0 = input("Nhập khối lượng ban đầu của tên lửa (kg): "); %Dương
m_fuel = input("Nhập khối lượng ban đầu của nhiên liệu: "); %Dương
m_rocket = m0 - m_fuel;
h0 = input("Nhập vị trí ban đầu của tên lửa (m): "); %Dương
dm_dt = input("Nhập tốc độ đốt nhiên liệu (kg/s): "); %Âm
v_air = input("Nhập vận tốc đẩy khí (m/s): "); %Dương (có dấu - trong ct)

%Hằng số rơi tự do
g = 9.81;

%Tìm t khi tên lửa hết nhiên liệu
duration = -m_fuel/dm_dt;

%Ta khảo sát từ t = 0 đến khi hết nhiên liệu
t = 0:0.01:duration;

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

%Xác định vận tốc tại thời điểm cuối cùng:
v_end = v_t(end);

%Hết nhiên liệu
%Phải kiểm tra vận tốc cuối có lớn hơn 11200 không
%Nếu lớn hơn thì Trái Đất không còn tác dụng lực lên tên lửa
%Code

figure(1)
plot(t, a, "w");
xlabel("Thời gian")
ylabel("Gia tốc")

figure(2) 
plot(t, v_t, "g");
xlabel("Thời gian")
ylabel("Vận tốc")

figure(3)
plot(t, h_t, "r");
xlabel("Thời gian")
ylabel("Độ cao")