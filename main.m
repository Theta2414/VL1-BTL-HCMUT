clc, clearvars, close all

m0 = input('Nhap khoi luong ban dau cua ten lua (kg): '); %Duong
m_fuel = input('Nhap khoi luong ban dau cua nhien lieu (kg): '); %Duong
m_rocket = m0 - m_fuel;
h0 = input('Nhap vi tri ban dau cua ten lua (m): '); %Duong
dm_dt = input('Nhap toc do dot nhien lieu (kg/s): '); %Am
v_air = input('Nhap van toc day khi (m/s): '); %Duong

%Hang so roi tu do
g = 9.81;

%Tim t khi ten lua het nhien lieu
duration = -m_fuel/dm_dt;

cycle = 1;

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

%Ham tinh tich phan tich luy
v_t = cumtrapz(t, a);
h_t = cumtrapz(t, v_t) + h0;

if sum(a) ~= 0
    v_peak = v_t(end);
    h_peak = h_t(end);
    
    S = roots([-0.5*g, v_peak, h_peak]);
    S = S(S>0);
    
    %Ta kh?o sát thêm ph?n t? duration ??n 0
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

figure(1)
plot(t, a, 'b');
title('GIA TOC THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('GIA TOC $(m/s^2)$', 'Interpreter', 'latex');
grid on;

figure(2)
plot(t, v_t, 'g');
title('VAN TOC THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('VAN TOC $(m/s)$', 'Interpreter', 'latex');
grid on;

figure(3)
plot(t, h_t, 'r');
title('DO CAO THEO THOI GIAN', 'Interpreter', 'latex');
xlabel('THOI GIAN $(s)$', 'Interpreter', 'latex');
ylabel('DO CAO $(m)$', 'Interpreter', 'latex');
grid on;