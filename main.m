clc, clearvars, close all

m0 = input('Nhap khoi luong ban dau cua ten lua (kg): '); %Duong
m_fuel = input('Nhap khoi luong ban dau cua nhien lieu: '); %Duong
m_rocket = m0 - m_fuel;
h0 = input('Nhap vi tri ban dau cua ten lua (m): '); %Duong
dm_dt = input('Nhap toc do dot nhien lieu (kg/s): '); %Am
v_air = input('Nhap van toc day khi (m/s): '); %Duong

%Hang so roi tu do
g = 9.81;

%Tim t khi ten lua het nhien lieu
duration = -m_fuel/dm_dt;

%Ta khao sat tu t = 0 den khi het nhien lieu
t = 0:0.01:duration;

%Khoi luong ten lua theo thoi gian la 
m = m0 + dm_dt*t;

%Ham tinh gia toc toi khi het nhien lieu
a = -v_air*(dm_dt./m) - g;

%Kiem tra neu a < 0 va h = 0 thi ten lua dung yen
for i=1:length(a)
    if (a(i) < 0)
        a(i) = 0;
    elseif a(i) > 0
        break;
    end
end

%

%Ham tinh tich phan tich luy
v_t = cumtrapz(t, a);
h_t = cumtrapz(t, v_t) + h0;

figure(1)
plot(t, a, 'b');
xlabel('Thoi gian');
ylabel('Gia toc');

figure(2) 
plot(t, v_t, 'g');
xlabel('Thoi gian');
ylabel('Van toc');

figure(3)
plot(t, h_t, 'r');
xlabel('Thoi gian');
ylabel('Do cao');