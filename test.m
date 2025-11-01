clc, clearvars, close all

m0 = input('Nhập khối lượng ban đầu của tên lửa (kg): '); %Dương
m_fuel = input('Nhập khối lượng ban đầu của nhiên liệu: '); %Dương
m_rocket = m0 - m_fuel;
h0 = input('Nhập vị trí ban đầu của tên lửa (m): '); %Dương
dm_dt = input('Nhập tốc độ đốt nhiên liệu (kg/s): '); %Âm
v_air = input('Nhập vận tốc đẩy khí (m/s): '); %Dương (có dấu - trong ct)

%Hằng số rơi tự do
g = 9.81;

%Hằng số hấp dẫn
G = 6.67e-11;

%Khối lượng Trái Đất
M = 5.97e24;

%Bán kính Trái Đất
R = 6.371e6;

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

%Vận tốc thoát ly theo độ cao
v_escape = sqrt((2*G*M)./(R+h_t));

%Tìm index mà tại đó vận tốc đạt vận tốc thoát ly, chỉ lấy 1 giá trị đầu
%tiên
escapeIndex = find(v_t > v_escape, 1);

%Nếu tồn tại es
if ~isempty(escapeIndex)
    %Đổi lại từ ma trận sang số nguyên
    escapeIndex = escapeIndex(1);
    %Xóa toàn bộ ma trận từ mục escapeIndex để tính lại
    a(:, escapeIndex:end) = [];
    %Đặt mốc thời gian khảo sát từ escapeIndex đến hết của t
    t_escape = t(:, escapeIndex:end);
    %Thêm vào đuôi của nó phần duration + 100 để khảo sát sau hết nhiên
    %liệu
    t_empty = duration+0.01:0.01:duration+1000;
    %Xóa mốc thời gian cũ
    t(:, escapeIndex:end) = [];
    %Tạo mốc thời gian liên tục mới
    T = [t, t_escape, t_empty];
    m_escape = m0 + dm_dt*t_escape;
    %Tạo phần khối lượng mới
    %m_empty = (m0 - m_fuel)*ones((100-duration)/0.01 + 1);
    a_escape = -v_air*dm_dt./m_escape;
    %Gia tốc khi hết nhiên liệu, đồng thời không còn chịu lực hút là 0, tạo
    %một ma trận 0 có kích thước tương đương với ma trận thời gian
    a_empty = zeros(1, length(t_empty));    
    a = [a, -v_air*dm_dt./m_escape, a_empty];
    v_t = cumtrapz(T, a);
    h_t = cumtrapz(T, v_t);
%Nếu không tồn tại es, tức là tên lửa sẽ bị đẩy xuống lại, mệt quá :(((
else
    %Code
end

figure(1)
plot(T, a, 'w');
xlabel('Thời gian')
ylabel('Gia tốc')

figure(2) 
plot(T, v_t, 'g');
xlabel('Thời gian')
ylabel('Vận tốc')

figure(3)
plot(T, h_t, 'r');
xlabel('Thời gian')
ylabel('Độ cao')