clc, clearvars, close all

% --- 1. Nhập liệu và Tham số Ban đầu ---
disp('--- Mô Phỏng Chuyến Bay Của Tên Lửa ---');
% Khối lượng ban đầu của tên lửa (cấu trúc + nhiên liệu)
m0 = input("Nhập khối lượng ban đầu của tên lửa (kg): "); 
m_fuel = input("Nhập khối lượng ban đầu của nhiên liệu (kg): ");
m_rocket = m0 - m_fuel; % Khối lượng cấu trúc tên lửa
h0 = input("Nhập vị trí ban đầu của tên lửa (m): ");
% Tốc độ đốt nhiên liệu (kg/s). Đưa ra giá trị dương, code tự đổi dấu âm.
dm_dt_in = input("Nhập tốc độ đốt nhiên liệu (kg/s) [Giá trị dương]: "); 
dm_dt = -abs(dm_dt_in); % Tốc độ giảm khối lượng, luôn âm
v_air = input("Nhập vận tốc đẩy khí (m/s) [Giá trị dương]: ");

% Hằng số vật lý
g = 9.81; % Hằng số rơi tự do (m/s^2)
v_escape = 11200; % Vận tốc thoát ly của Trái Đất (m/s)

% --- 2. Giai đoạn 1: Đốt nhiên liệu ---
duration = -m_fuel/dm_dt; % Thời gian đốt nhiên liệu
dt = 0.01; % Bước thời gian cố định
t_burn = 0:dt:duration;

m_t = m0 + dm_dt*t_burn; % Khối lượng thay đổi theo thời gian
% Phương trình cơ bản: F_thrust = -v_air * dm_dt; a = F/m - g
a_t = -v_air*(dm_dt./m_t) - g; 

% Xử lý điều kiện tên lửa đứng yên trên bệ phóng (Gia tốc < 0 và ở mặt đất)
a_t_corrected = a_t;
for i=1:length(a_t_corrected)
    % Chỉ thay đổi khi a < 0
    if a_t_corrected(i) < 0
        a_t_corrected(i) = 0;
    % Thoát vòng lặp ngay khi a > 0 để tên lửa bắt đầu bay lên
    elseif a_t_corrected(i) > 0 
        break;
    end
end
a_t = a_t_corrected;

% Tích phân vận tốc và độ cao (Sử dụng cumtrapz cho độ chính xác)
v_t = cumtrapz(t_burn, a_t);
h_t = cumtrapz(t_burn, v_t) + h0;

v_end = v_t(end); % Vận tốc tại thời điểm hết nhiên liệu
h_end = h_t(end); % Độ cao tại thời điểm hết nhiên liệu

% --- 3. Giai đoạn 2: Sau khi hết nhiên liệu (Bay quán tính) ---

if v_end > v_escape
    % Trường hợp A: Đạt vận tốc thoát ly (Thoát khỏi lực hấp dẫn chính)
    disp(['*** Tên lửa đã đạt vận tốc thoát ly (', num2str(v_end), ' m/s > ', num2str(v_escape), ' m/s). Thoát khỏi lực hấp dẫn chính. ***']);
    
    % Mô hình hóa thêm một khoảng thời gian bay thoát ly
    t_beyond = duration + [dt:dt:1000]; % Bay thêm 1000s
    
    a_beyond = zeros(size(t_beyond)); % Gia tốc ~ 0 
    v_beyond = v_end * ones(size(t_beyond)); % Vận tốc duy trì v_end
    h_beyond = h_end + v_end * (t_beyond - duration); % Độ cao tăng tuyến tính
    
    % Gộp các mảng
    t_full = [t_burn(1:end-1), t_beyond];
    a_full = [a_t(1:end-1), a_beyond];
    v_full = [v_t(1:end-1), v_beyond];
    h_full = [h_t(1:end-1), h_beyond];
    
else
    % Trường hợp B: Bay quán tính dưới tác dụng của trọng lực
disp(['*** Tên lửa không đạt vận tốc thoát ly (', num2str(v_end), ' m/s <= ', num2str(v_escape), ' m/s). Tên lửa bay theo quán tính. ***']);
    
    % Tính toán thời gian chạm đất (Sử dụng phương trình bậc hai: -0.5*g*t^2 + v_end*t + h_end = 0)
    a_quad = -0.5 * g;
    b_quad = v_end;
    c_quad = h_end;
    delta = b_quad^2 - 4 * a_quad * c_quad;
    
    if delta >= 0
        % Chỉ lấy nghiệm dương (thời gian) và lớn nhất (thời gian chạm đất)
        t_impact_sol1 = (-b_quad + sqrt(delta)) / (2 * a_quad);
        t_impact_sol2 = (-b_quad - sqrt(delta)) / (2 * a_quad);
        dt_impact = max(t_impact_sol1, t_impact_sol2);
        
        % Đảm bảo dt_impact là giá trị dương
        if dt_impact < 0
            % Nếu tên lửa đang bay lên và không chạm đất trong tương lai gần (ví dụ: đang lên)
            t_impact = duration + 500; % Mô phỏng thêm 500s 
            disp('Lưu ý: Không tìm thấy thời gian chạm đất dương hợp lệ. Mô phỏng thêm 500s.');
        else
            t_impact = duration + dt_impact;
        end
        
        t_post_burn = duration:dt:t_impact;
        dt_post_burn = t_post_burn - duration; 
        
        a_post = -g * ones(size(t_post_burn));
        v_post = v_end - g * dt_post_burn;
        h_post = h_end + v_end * dt_post_burn - 0.5 * g * dt_post_burn.^2;
        
        % Gộp các mảng
        t_full = [t_burn(1:end-1), t_post_burn];
        a_full = [a_t(1:end-1), a_post];
        v_full = [v_t(1:end-1), v_post];
        h_full = [h_t(1:end-1), h_post];
        h_full(end) = 0; % Đảm bảo độ cao cuối cùng là 0
        
    else
        % Trường hợp hiếm: Delta < 0 (không chạm đất) - Giữ nguyên mảng burn
        disp('Cảnh báo: Lỗi tính toán phương trình bậc hai, không tìm thấy thời điểm chạm đất.');
        t_full = t_burn; a_full = a_t; v_full = v_t; h_full = h_t;
    end
end

% --- 4. Vẽ Đồ Thị ---

set(0,'defaulttextinterpreter','latex') % Thiết lập mặc định sử dụng LaTeX

% Đồ thị Gia tốc
figure(1)
plot(t_full, a_full, "LineWidth", 2, "Color", 'k'); % SỬA LỖI: Dùng 'k' (đen)
xlabel("Thời gian ($s$)")
ylabel("Gia tốc ($m/s^2$)")
title("Gia tốc của tên lửa theo thời gian")
grid on;
hold on;
plot(duration, a_t(end), 'ro', 'MarkerFaceColor', 'r');
text(duration, a_t(end), ' Hết NL', 'VerticalAlignment','bottom', 'HorizontalAlignment','left');

% Đồ thị Vận tốc
figure(2) 
plot(t_full, v_full, "LineWidth", 2, "Color", [0 0.7 0]); % Tăng cường màu xanh
xlabel("Thời gian ($s$)")
ylabel("Vận tốc ($m/s$)")
title("Vận tốc của tên lửa theo thời gian")
grid on;
hold on;
plot(duration, v_end, 'ro', 'MarkerFaceColor', 'r');
text(duration, v_end, ' Hết NL', 'VerticalAlignment','bottom', 'HorizontalAlignment','left');
plot([0 t_full(end)], [v_escape v_escape], 'b--', 'LineWidth', 1); % Vẽ vận tốc thoát ly
text(t_full(end), v_escape, ' $v_{escape}$', 'VerticalAlignment','bottom', 'HorizontalAlignment','right', 'Color', 'b');

% Đồ thị Độ cao
figure(3)
plot(t_full, h_full, "LineWidth", 2, "Color", [0.9 0 0]); % Tăng cường màu đỏ
xlabel("Thời gian ($s$)")
ylabel("Độ cao ($m$)")
title("Độ cao của tên lửa theo thời gian")
grid on;
hold on;
plot(duration, h_end, 'ro', 'MarkerFaceColor', 'r');
text(duration, h_end, ' Hết NL', 'VerticalAlignment','top', 'HorizontalAlignment','left');

% Kết thúc
disp('--- Mô phỏng hoàn tất. Đồ thị đã được vẽ. ---');