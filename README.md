# Bài 4. Xác định phương trình chuyển động của tên lửa

## 1. Yêu cầu

Tên lửa dịch chuyển bằng dòng khí đẩy từ đuôi. Dòng khí đẩy này sinh ra bằng các phản ứng đốt cháy nhiên liệu chứa trong tên lửa nên khối lượng của nó giảm dần theo thời gian.

Giải phương trình định luật II Newton cho tên lửa. Với $m$ là khối lượng của tên lửa, $v'$ là vận tốc của dòng khí thoát ra.

Giải phương trình này ta xác định được gia tốc của tên lửa từ đó ta suy ra phương trình chuyển động của nó.

Bài tập này yêu cầu sinh viên sử dụng Matlab hoặc Python để biểu diễn bằng đồ thị phương trình chuyển động của tên lửa $y(t)$.

## 2. Điều kiện

1.  Sinh viên cần có kiến thức về lập trình cơ bản trong MATLAB hoặc Python.
2.  Tìm hiểu các lệnh Matlab hoặc Python liên quan symbolic và đồ họa.

> **Giải pháp này được thực hiện bằng MATLAB.**

## 3. Hướng dẫn sử dụng

1.  Mở file script MATLAB (`.m`).
2.  Nhấn "Run" trong thanh công cụ của MATLAB.
3.  Nhập các giá trị đầu vào theo yêu cầu trong cửa sổ Command Window:
    * **`Nhập khối lượng ban đầu của tên lửa (kg)`**: (Giá trị dương, ví dụ: 1000)
    * **`Nhập khối lượng ban đầu của nhiên liệu (kg)`**: (Giá trị dương, ví dụ: 800)
    * **`Nhập vị trí ban đầu của tên lửa (m)`**: (Giá trị dương hoặc bằng 0, ví dụ: 0)
    * **`Nhập tốc độ đốt nhiên liệu (kg/s)`**: (Giá trị **âm**, ví dụ: -10)
    * **`Nhập vận tốc đẩy khí (m/s)`**: (Giá trị dương, ví dụ: 2500)
4.  Chương trình sẽ tự động tính toán và hiển thị 3 cửa sổ đồ thị.