# HƯỚNG DẪN TRẢ LỜI 3 CÂU HỎI LỚN TRONG ĐỒ ÁN TỐT NGHIỆP
*(Áp dụng cho Đề tài: Hệ thống Đặt phòng Khách sạn - Hotel Booking System)*

Để đạt kết quả cao nhất trước Hội đồng chấm Đồ án tốt nghiệp (DATN), bạn cần nắm vững và trình bày trôi chảy 3 trục nội dung cốt lõi dưới đây. Tài liệu này hướng dẫn chi tiết cách ánh xạ dự án **Hotel Booking (Vue 3 + Spring Boot)** của bạn vào khung lý thuyết này.

---

## CÂU HỎI 1: LÀM GÌ? (WHAT)
*Nhiệm vụ được giao hoặc bài toán thực tế tự xác định cần phải giải quyết.*

### 1. Ý nghĩa & Bối cảnh đề tài
* **Bối cảnh:** Ngành du lịch và lưu trú trực tuyến đang phát triển mạnh mẽ. Nhu cầu kết nối trực tiếp giữa người dùng cần thuê phòng và chủ cơ sở lưu trú (homestay, khách sạn nhỏ) mà không qua các đại lý trung gian truyền thống đắt đỏ.
* **Mục tiêu:** Xây dựng một nền tảng Web đặt phòng khách sạn (Hotel Booking) cho phép tối ưu hóa quy trình tìm kiếm, đặt phòng và quản lý dòng tiền của các bên tham gia.

### 2. Các đối tượng tương tác (Actors) & Phân hệ chức năng
Đồ án giải quyết bài toán quản lý cho **4 nhóm đối tượng** chính với các chức năng tương ứng:
1. **Khách vãng lai (Guest):** Tìm kiếm phòng theo địa điểm/ngày/số khách; Xem thông tin chi tiết phòng và vị trí trực quan trên bản đồ trực tuyến.
2. **Khách hàng (Customer):** Thực hiện đặt phòng nhanh chóng; Áp dụng mã giảm giá; Thanh toán trực tuyến an toàn; Quản lý lịch sử đặt phòng; Đánh giá chất lượng dịch vụ (1-5 sao).
3. **Chủ phòng (Host):** Đăng phòng thủ công hoặc nhập hàng loạt từ Excel; Xác định vị trí địa lý phòng nghỉ; Quản lý đơn đặt phòng từ khách; Theo dõi báo cáo doanh thu thực nhận sau khi trừ chiết khấu.
4. **Quản trị viên (Admin):** Duyệt phòng đăng mới; Quản lý tài khoản người dùng; Cấu hình mã khuyến mãi toàn hệ thống; Thống kê doanh thu tổng và hoa hồng thu được.

> [!NOTE]
> Để hiểu rõ hơn về phân hệ chức năng này, bạn có thể tham khảo [Biểu đồ Use Case tổng quan](file:///c:/Users/USER/hotel-booking-fe/huong_dan_ve_bieu_do.md#L26-L84).

---

## CÂU HỎI 2: LÀM NHƯ THẾ NÀO? (HOW)
*Phân tích hệ thống hiện tại, đề xuất phương án và thiết kế chi tiết.*

### 1. Phân tích & Đánh giá các hệ thống tương tự
Khi viết báo cáo, bạn cần so sánh sản phẩm của mình với các "ông lớn" trên thị trường để tìm ra điểm tối ưu:
* **Airbnb:** Mạnh về kết nối homestay cá nhân, bản đồ trực quan, nhưng phí dịch vụ cao đối với cả chủ và khách.
* **Booking.com:** Mạnh về quy trình đặt phòng khách sạn chuyên nghiệp, bộ lọc tìm kiếm chi tiết, nhưng giao diện phức tạp và thiếu tính năng nhập dữ liệu hàng loạt tiện lợi cho chủ phòng nhỏ.
* **Giải pháp của bạn (Đề xuất):** Một hệ thống kết hợp (Hybrid) tối giản, tích hợp bản đồ số (OpenStreetMap), cơ chế chống trùng vị trí địa lý thông minh, hỗ trợ chủ phòng tải phòng nhanh qua file Excel, và cổng thanh toán nội địa VNPAY phổ biến tại Việt Nam.

### 2. Ghi chép Tài liệu & Công nghệ tham khảo
Hệ thống sử dụng các công nghệ hiện đại, ổn định và có tính ứng dụng thực tế cao:
* **Frontend:** Vue 3 (Composition API) cho giao diện phản hồi nhanh; Pinia quản lý trạng thái; Tailwind CSS / Vanilla CSS cho giao diện thẩm mỹ; Leaflet.js cho bản đồ số trực tuyến.
* **Backend:** Spring Boot (Java) xây dựng theo kiến trúc RESTful API; Spring Security + JWT phục vụ phân quyền; Hibernate/JPA tương tác cơ sở dữ liệu.
* **Database:** MySQL lưu trữ dữ liệu quan hệ, được chuẩn hóa để đảm bảo toàn vẹn dữ liệu.
* **Tích hợp bên thứ ba:**
  * **VNPAY API:** Xử lý thanh toán trực tuyến bảo mật qua ngân hàng nội địa.
  * **Apache POI:** Đọc/ghi tệp Excel phục vụ tính năng import hàng loạt phòng nghỉ của Chủ phòng.
  * **OSM Nominatim API:** Tự động Geocoding (chuyển địa chỉ chữ thành tọa độ Lat/Long).

### 3. Thiết kế Chi tiết Hệ thống (UML)
Khi bảo vệ, bạn cần giải thích rõ cấu trúc và luồng hoạt động thông qua các biểu đồ:
* **Luồng đặt phòng chi tiết:** Mô tả qua [Sơ đồ quy trình đặt phòng](file:///c:/Users/USER/hotel-booking-fe/so_do_quy_trinh_dat_phong.md) để chỉ ra các bước từ tìm kiếm đến thanh toán thành công.
* **Luồng xử lý nghiệp vụ:** Tham khảo các [Biểu đồ hoạt động nghiệp vụ](file:///c:/Users/USER/hotel-booking-fe/huong_dan_ve_bieu_do.md#L206-L290) để nắm rõ cách xử lý thanh toán, đăng phòng và hủy phòng hoàn tiền.
* **Tương tác giữa các thành phần (Sequence Diagram):** Nắm chắc thứ tự gọi API từ Client lên Server và truy vấn Database qua các kịch bản cụ thể:
  * [Xác thực người dùng](file:///c:/Users/USER/hotel-booking-fe/huong_dan_ve_bieu_do.md#L298-L332)
  * [Đặt phòng & Thanh toán VNPAY](file:///c:/Users/USER/hotel-booking-fe/huong_dan_ve_bieu_do.md#L334-L387)
  * [Chủ phòng import Excel](file:///c:/Users/USER/hotel-booking-fe/huong_dan_ve_bieu_do.md#L641-L699)
* **Cơ cấu dữ liệu:** Nắm vững cấu trúc cơ sở dữ liệu và mối quan hệ thực thể thông qua [Biểu đồ lớp (Class Diagram)](file:///c:/Users/USER/hotel-booking-fe/huong_dan_ve_bieu_do.md#L742-L800).

---

## CÂU HỎI 3: KẾT QUẢ RA SAO? (RESULT)
*Các sản phẩm thực tế, đánh giá, so sánh và định hướng khắc phục.*

### 1. Các kết quả đã đạt được (Deliverables)
* **Phần mềm hoạt động thực tế:**
  * Giao diện người dùng (Frontend) mượt mà, hỗ trợ responsive hoàn toàn trên cả thiết bị di động và máy tính.
  * Hệ thống RESTful API (Backend) chạy ổn định, xử lý logic thanh toán VNPAY IPN bảo mật (tránh lỗi double-payment).
* **Cơ sở dữ liệu hoàn chỉnh:** Các bảng (User, Room, Booking, Payment, Review, Promotion) được thiết kế tối ưu, có thiết lập khóa ngoại và chỉ mục (Index) hỗ trợ truy vấn tìm kiếm nhanh.
* **Tính năng đặc thù nổi bật:**
  * Thuật toán Haversine đo khoảng cách tọa độ để ngăn chặn chủ phòng đăng phòng trùng lặp trong phạm vi 20m.
  * Cơ chế khóa phòng tạm thời (`SELECT ... FOR UPDATE` trong DB) giúp phòng tránh lỗi Overbooking (nhiều khách đặt cùng một phòng vào cùng một thời điểm).

### 2. Đánh giá & So sánh với Mục tiêu ban đầu
* **Ưu điểm:**
  * Đã giải quyết triệt để quy trình khép kín: Tìm kiếm -> Đặt phòng -> Thanh toán trực tuyến -> Xác nhận đơn -> Xem thống kê.
  * Tính năng nhập phòng từ Excel giúp tối ưu hiệu suất vận hành của Chủ phòng.
  * Tích hợp bản đồ số thực tế giúp tăng trải nghiệm người dùng so với các đồ án chỉ nhập địa chỉ dạng text thông thường.
* **Nhược điểm / Hạn chế:**
  * Hiện tại hệ thống tự động Geocoding qua OSM Nominatim có giới hạn tần suất yêu cầu (rate limit 1 request/giây), có thể bị chậm nếu import file Excel chứa hàng trăm phòng cùng lúc.
  * Chưa hỗ trợ cơ chế gợi ý phòng thông minh dựa trên lịch sử tìm kiếm và sở thích của khách hàng.

### 3. Phương hướng khắc phục và phát triển tương lai
* Tích hợp thêm các dịch vụ bản đồ thương mại (Mapbox / Google Maps API) để tăng tốc độ Geocoding và tính năng gợi ý địa chỉ tự động (Autocomplete).
* Phát triển thêm module AI Recommendation Engine sử dụng Python/Flask để gợi ý các phòng phù hợp với hành vi người dùng.
* Nâng cấp bảo mật hệ thống bằng cách áp dụng giao thức HTTPS toàn diện và cơ chế xác thực hai lớp (2FA).

---

## 💡 LỜI KHUYÊN KHI TRẢ LỜI TRƯỚC HỘI ĐỒNG (DEFENSE TIPS)
1. **Rõ ràng và mạch lạc:** Tránh nói lan man về code. Thay vào đó, hãy tập trung giải thích **Logic nghiệp vụ** (Business Logic) và **Kiến trúc hệ thống** (System Architecture).
2. **Làm nổi bật thế mạnh:** Nhấn mạnh các tính năng khó như **Thanh toán VNPAY IPN**, **Chống trùng tọa độ Haversine 20m**, **Giải quyết tranh chấp đặt phòng (Locking - FOR UPDATE)**. Đây là những điểm cộng rất lớn giúp nâng điểm đồ án của bạn.
3. **Thẳng thắn nhìn nhận hạn chế:** Khi bị hỏi về lỗi hoặc điểm chưa tốt, đừng phủ nhận. Hãy trả lời theo hướng: *"Dạ em đã nhận ra hạn chế này ở khía cạnh X, và hướng khắc phục của em trong tương lai là áp dụng giải pháp Y để xử lý..."*. Hội đồng sẽ đánh giá rất cao tinh thần cầu thị của bạn.
