# HƯỚNG DẪN CHI TIẾT VẼ BẢN VẼ & BIỂU ĐỒ ĐỒ ÁN HOTEL BOOKING
*(Hệ thống Đặt phòng Khách sạn - Góc nhìn Phân tích Nghiệp vụ)*

Tài liệu này hướng dẫn chi tiết cách thiết kế và vẽ **9 nhóm biểu đồ phân tích nghiệp vụ** cho đồ án tốt nghiệp của bạn bằng ngôn ngữ **PlantUML**. Tất cả các biểu đồ tập trung vào luồng nghiệp vụ và tương tác của người dùng với hệ thống, mô tả hệ thống làm gì (what the system does) và không phụ thuộc vào công nghệ hay framework cụ thể.

---

## 1. Use Case Diagram (Biểu đồ ca sử dụng nghiệp vụ)

Biểu đồ này chỉ ra mối quan hệ giữa các tác nhân (Actors) và các chức năng nghiệp vụ (Use Cases) của hệ thống.

### Tác nhân (Actors)
1. **Khách vãng lai**: Người dùng chưa đăng nhập hệ thống.
2. **Khách hàng**: Người dùng đã đăng nhập tài khoản để thực hiện các chức năng giao dịch đặt phòng.
3. **Chủ phòng**: Người đăng thông tin phòng, quản lý phòng, quản lý đơn đặt phòng và xem báo cáo doanh thu.
4. **Quản trị viên**: Người quản lý toàn bộ hệ thống, duyệt yêu cầu đăng phòng, quản lý chương trình khuyến mãi, thống kê doanh thu và hoa hồng.

### Mối quan hệ nghiệp vụ
- Khách hàng thừa kế các quyền của Khách vãng lai.
- Ca sử dụng `Thanh toán trực tuyến` **<<extend>>** (mở rộng) cho ca sử dụng `Đặt phòng` (do người dùng có thể lựa chọn thanh toán trực tuyến hoặc thanh toán tại khách sạn).
- Ràng buộc đăng nhập: Việc bắt buộc đăng nhập trước khi thực hiện các chức năng như Đặt phòng, Đánh giá phòng,... sẽ được mô tả trong phần đặc tả chi tiết của Use Case, không vẽ liên kết `<<include>>` trong sơ đồ để tránh làm rối biểu đồ.

### Biểu đồ Use Case (PlantUML)

```plantuml
@startuml
skinparam linetype ortho
left to right direction

actor "Khách vãng lai" as Guest
actor "Khách hàng" as Customer
actor "Chủ phòng" as Host
actor "Quản trị viên" as Admin

Customer -|> Guest

rectangle "Hệ thống Đặt phòng Khách sạn" {
    usecase "Đăng ký / Đăng nhập tài khoản" as UC_Auth
    usecase "Tìm kiếm & Xem phòng" as UC_Search
    usecase "Xem vị trí phòng trên bản đồ" as UC_ViewMap
    usecase "Đặt phòng" as UC_Book
    usecase "Thanh toán trực tuyến" as UC_Pay
    usecase "Quản lý đặt phòng" as UC_ManageBooking
    usecase "Hủy đặt phòng" as UC_Cancel
    usecase "Đánh giá phòng" as UC_Review
    usecase "Đăng thông tin phòng" as UC_RegRoom
    usecase "Chọn vị trí trên bản đồ" as UC_MapPick
    usecase "Nhập hàng loạt qua Excel" as UC_ImportExcel
    usecase "Quản lý phòng" as UC_ManageRoom
    usecase "Quản lý đơn đặt phòng" as UC_ManageHostBooking
    usecase "Lọc đơn sắp diễn ra" as UC_UpcomingFilter
    usecase "Xem báo cáo doanh thu" as UC_HostRevenue
    usecase "Quản lý người dùng" as UC_ManageUser
    usecase "Duyệt yêu cầu đăng phòng" as UC_ApproveRoom
    usecase "Quản lý chương trình khuyến mãi" as UC_ManagePromo
    usecase "Thống kê doanh thu và hoa hồng" as UC_AdminRevenue
}

Guest --> UC_Auth
Guest --> UC_Search
Customer --> UC_Book
Customer --> UC_ManageBooking
Customer --> UC_Cancel
Customer --> UC_Review
Customer --> UC_ViewMap

UC_Pay ..> UC_Book : <<extend>>
UC_ViewMap ..> UC_Search : <<extend>>
UC_MapPick ..> UC_RegRoom : <<include>>
UC_ImportExcel ..> UC_RegRoom : <<extend>>
UC_UpcomingFilter ..> UC_ManageHostBooking : <<extend>>

Host --> UC_RegRoom
Host --> UC_ManageRoom
Host --> UC_ManageHostBooking
Host --> UC_HostRevenue
Host --> UC_ImportExcel

Admin --> UC_ManageUser
Admin --> UC_ApproveRoom
Admin --> UC_ManagePromo
Admin --> UC_AdminRevenue
@enduml
```

### Biểu đồ Use Case chi tiết cho từng tác nhân (PlantUML)

Để báo cáo chi tiết và dễ theo dõi hơn, dưới đây là các biểu đồ ca sử dụng tách riêng cho từng tác nhân trong hệ thống.

#### 1.1. Tác nhân Khách vãng lai (Guest)
Khách vãng lai là người dùng chưa đăng nhập, chỉ có thể thực hiện tìm kiếm phòng nghỉ và đăng ký/đăng nhập tài khoản.

```plantuml
@startuml
skinparam linetype ortho
left to right direction
skinparam packageStyle rectangle
skinparam shadowing false

actor "Khách vãng lai" as Guest

rectangle "Hệ thống Đặt phòng Khách sạn" {
    usecase "Đăng ký / Đăng nhập tài khoản" as UC_Auth
    usecase "Tìm kiếm & Xem phòng" as UC_Search
}

Guest --> UC_Auth
Guest --> UC_Search
@enduml
```

#### 1.2. Tác nhân Khách hàng (Customer)
Khách hàng thừa kế các quyền của Khách vãng lai, đồng thời trực tiếp thực hiện các ca sử dụng giao dịch cốt lõi gồm: Đặt phòng, Quản lý đặt phòng, Hủy đặt phòng, Đánh giá phòng. Ca sử dụng Thanh toán trực tuyến đóng vai trò mở rộng cho Đặt phòng.

```plantuml
@startuml
skinparam linetype ortho
left to right direction
skinparam packageStyle rectangle
skinparam shadowing false

actor "Khách vãng lai" as Guest
actor "Khách hàng" as Customer

Customer -|> Guest

rectangle "Hệ thống Đặt phòng Khách sạn" {
    usecase "Đặt phòng" as UC_Book
    usecase "Thanh toán trực tuyến" as UC_Pay
    usecase "Quản lý đặt phòng" as UC_ManageBooking
    usecase "Hủy đặt phòng" as UC_Cancel
    usecase "Đánh giá phòng" as UC_Review
}

Customer --> UC_Book
Customer --> UC_ManageBooking
Customer --> UC_Cancel
Customer --> UC_Review

UC_Pay ..> UC_Book : <<extend>>
@enduml
```

#### 1.3. Tác nhân Chủ phòng (Host)
Chủ phòng trực tiếp thực hiện các ca sử dụng quản trị phòng nghỉ của mình trên hệ thống bao gồm: Đăng thông tin phòng (có chọn vị trí bản đồ), Nhập hàng loạt qua Excel, Quản lý phòng, Quản lý đơn đặt phòng (bao gồm lọc đơn sắp diễn ra), và Xem báo cáo doanh thu.

```plantuml
@startuml
skinparam linetype ortho
left to right direction
skinparam packageStyle rectangle
skinparam shadowing false

actor "Chủ phòng" as Host

rectangle "Hệ thống Đặt phòng Khách sạn" {
    usecase "Đăng thông tin phòng" as UC_RegRoom
    usecase "Chọn vị trí trên bản đồ" as UC_MapPick
    usecase "Nhập hàng loạt qua Excel" as UC_ImportExcel
    usecase "Quản lý phòng" as UC_ManageRoom
    usecase "Quản lý đơn đặt phòng" as UC_ManageHostBooking
    usecase "Lọc đơn sắp diễn ra" as UC_UpcomingFilter
    usecase "Xem báo cáo doanh thu" as UC_HostRevenue
}

Host --> UC_RegRoom
Host --> UC_ImportExcel
Host --> UC_ManageRoom
Host --> UC_ManageHostBooking
Host --> UC_HostRevenue

UC_MapPick ..> UC_RegRoom : <<include>>
UC_ImportExcel ..> UC_RegRoom : <<extend>>
UC_UpcomingFilter ..> UC_ManageHostBooking : <<extend>>
@enduml
```

#### 1.4. Tác nhân Quản trị viên (Admin)
Quản trị viên quản lý toàn bộ hệ thống độc lập, chịu trách nhiệm duyệt yêu cầu đăng phòng, quản lý người dùng, quản lý chương trình khuyến mãi, thống kê doanh thu và hoa hồng.

```plantuml
@startuml
skinparam linetype ortho
left to right direction
skinparam packageStyle rectangle
skinparam shadowing false

actor "Quản trị viên" as Admin

rectangle "Hệ thống Đặt phòng Khách sạn" {
    usecase "Quản lý người dùng" as UC_ManageUser
    usecase "Duyệt yêu cầu đăng phòng" as UC_ApproveRoom
    usecase "Quản lý chương trình khuyến mãi" as UC_ManagePromo
    usecase "Thống kê doanh thu và hoa hồng" as UC_AdminRevenue
}

Admin --> UC_ManageUser
Admin --> UC_ApproveRoom
Admin --> UC_ManagePromo
Admin --> UC_AdminRevenue
@enduml
```

---

## 2. Activity Diagram (Biểu đồ hoạt động nghiệp vụ - 3 Biểu đồ)

Mô tả luồng xử lý các nghiệp vụ cốt lõi của hệ thống dưới góc nhìn các hành động thực tế.

### Biểu đồ 2.1: Nghiệp vụ Đặt phòng & Thanh toán trực tuyến
Mô tả quá trình khách hàng đặt phòng, hệ thống xử lý tính toán chi phí, giữ phòng tạm thời, kết nối cổng thanh toán trực tuyến và ghi nhận giao dịch thành công.

```plantuml
@startuml
start
:Khách chọn phòng & Ngày đặt;
:Hệ thống kiểm tra phòng trống;
if (Phòng trống?) then (đã có khách đặt trùng ngày)
    :Báo lỗi phòng không khả dụng;
    stop
else (phòng còn trống)
    :Tạo yêu cầu đặt phòng (Chờ thanh toán)\n(Tính toán giá gốc, số tiền giảm giá, tổng thanh toán);
    :Hệ thống tạo yêu cầu thanh toán trực tuyến;
    :Thực hiện thanh toán trực tuyến;
    :Khách xác nhận thanh toán;
    if (Thanh toán thành công?) then (Có)
        :Cập nhật đơn đặt phòng sang Đã xác nhận\nGhi nhận thanh toán thành công\nÁp dụng khuyến mãi\nTự động tính hoa hồng dịch vụ & doanh thu thực nhận chủ phòng;
        :Hiển thị thông báo đặt phòng thành công;
    else (Hủy giao dịch hoặc lỗi xác thực)
        :Hủy yêu cầu đặt phòng;
        :Báo lỗi thanh toán thất bại;
    fi
endif
stop
@enduml
```

### Biểu đồ 2.2: Nghiệp vụ Đăng thông tin phòng & Duyệt yêu cầu đăng phòng của Quản trị viên
Chủ phòng gửi đăng ký thông tin phòng mới lên hệ thống. Hệ thống hỗ trợ chọn vị trí trên bản đồ Leaflet; nếu chủ phòng chưa chọn thủ công, hệ thống tự động Geocoding từ địa chỉ nhập vào, kiểm tra trùng tọa độ trong phạm vi 20m cùng chủ trước khi lưu. Sau đó hệ thống chờ kiểm duyệt và hiển thị công khai khi được phê duyệt.

```plantuml
@startuml
start
:Chủ phòng điền thông tin phòng nghỉ\n(Hình ảnh, giá cả, loại phòng, tiện ích, chọn ảnh chính);
:Chọn vị trí phòng trên bản đồ (kéo Marker hoặc gợi ý theo địa chỉ);
if (Đã chọn vị trí thủ công trên bản đồ?) then (Chưa)
    :Hệ thống tự động Geocoding địa chỉ\n(OpenStreetMap Nominatim, rate limit 1 req/giây);
    if (Geocoding trả về tọa độ?) then (Không)
        :Từ chối lưu — Yêu cầu chủ phòng chọn vị trí;
        stop
    else (Có)
    endif
else (Đã chọn)
endif
:Hệ thống kiểm tra trùng tọa độ trong phạm vi 20m (Haversine)\nchỉ so sánh với các phòng cùng chủ sở hữu;
if (Phòng trùng tọa độ?) then (Có)
    :Từ chối lưu — Báo lỗi phòng đã tồn tại;
    stop
else (Không)
endif
:Lưu tọa độ (latitude, longitude) cùng thông tin phòng\nTrạng thái: Chờ duyệt;
:Thông báo có phòng cần duyệt đến Quản trị viên;
:Quản trị viên kiểm tra thông tin phòng đăng ký;
if (Thông tin hợp lệ?) then (Có)
    :Cập nhật trạng thái phòng thành Đang hoạt động;
    :Phòng xuất hiện công khai trên trang chủ;
else (Phòng giả, vi phạm chính sách)
    :Cập nhật trạng thái phòng thành Từ chối\nGửi thông báo và lý do từ chối cho chủ phòng;
endif
stop
@enduml
```

### Biểu đồ 2.3: Nghiệp vụ Hủy đặt phòng & Hoàn tiền
Khách hàng yêu cầu hủy đơn hàng, hệ thống kiểm tra thời gian theo quy định để đưa ra quyết định hoàn trả tiền.

```plantuml
@startuml
start
:Khách yêu cầu hủy đặt phòng đã đặt;
:So sánh ngày hiện tại với ngày nhận phòng;
if (Trước ngày nhận phòng > 2 ngày (Chính sách hủy hoàn tiền)?) then (Đúng)
    :Đổi trạng thái đơn đặt phòng sang Đã hủy\nGhi nhận hoàn tiền và gửi yêu cầu sang Cổng thanh toán;
else (Hủy trễ sát giờ)
    :Đổi trạng thái đơn đặt phòng sang Đã hủy\nKhông thực hiện hoàn tiền theo chính sách;
endif
:Gửi thông báo hủy thành công cho Khách hàng & Chủ phòng;
stop
@enduml
```

---

## 3. Sequence Diagram (Biểu đồ trình tự nghiệp vụ - 10 Biểu đồ)

Biểu đồ trình tự mô tả cách các tác nhân (Actors) tương tác với Màn hình Giao diện (Boundaries) và các Thực thể nghiệp vụ (Entities) để hoàn tất quy trình hệ thống.

### Biểu đồ 3.1: Xác thực người dùng (Đăng nhập tài khoản)
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Người dùng\n(Guest/Customer/Host/Admin)" as User
participant "Vue/Pinia\n(Frontend)" as Vue
participant "AuthController\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

User -> Vue : Nhập email & mật khẩu và nhấn Đăng nhập
activate Vue
Vue -> API : HTTP POST /api/auth/login (email, password)
activate API
API -> DB : SELECT * FROM users WHERE email = ?
activate DB
DB --> API : Thông tin tài khoản (đã băm mật khẩu)
deactivate DB
API -> API : Khớp mật khẩu bằng BCrypt & sinh JWT token
alt Xác thực thành công
    API --> Vue : HTTP 200 OK (JWT Token & thông tin user)
    Vue -> Vue : Lưu token vào localStorage & cập nhật authStore
    Vue --> User : Đăng nhập thành công, chuyển hướng trang
else Xác thực thất bại
    API --> Vue : HTTP 401 Unauthorized (Error Message)
    deactivate API
    Vue --> User : Hiển thị thông báo tài khoản/mật khẩu sai
end
deactivate Vue
@enduml
```

### Biểu đồ 3.2: Đặt phòng và Thanh toán trực tuyến
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Khách hàng" as Customer
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB
actor "Cổng VNPAY" as VNPAY

Customer -> Vue : Điền thông tin đặt phòng, mã voucher và nhấn Đặt phòng
activate Vue
Vue -> API : HTTP POST /api/bookings (đăng nhập JWT)
activate API
API -> DB : Khóa phòng (FOR UPDATE), tính giảm giá & lưu Booking, Payment (PENDING)
activate DB
DB --> API : Đơn hàng khởi tạo thành công
deactivate DB
API --> Vue : HTTP 201 Created (Booking DTO)
deactivate API

Vue -> API : HTTP POST /api/payment/vnpay/create?bookingId=...
activate API
API -> API : Tạo mã giao dịch & ký HMAC-SHA512
API --> Vue : HTTP 200 OK (Link thanh toán vnpayUrl)
deactivate API

Vue --> Customer : Chuyển hướng trình duyệt sang cổng VNPAY
deactivate Vue

Customer -> VNPAY : Xác nhận thanh toán (OTP / QR Code)
activate VNPAY
VNPAY -> VNPAY : Giao dịch thành công
VNPAY -> API : HTTP GET /api/payment/vnpay/ipn (Server-to-Server)
activate API
API -> DB : Cập nhật Payment -> SUCCESS, Booking -> CONFIRMED
activate DB
DB --> API : Lưu thay đổi thành công
deactivate DB
API --> VNPAY : RspCode "00" (Xác nhận thành công)
deactivate API

VNPAY --> Customer : Chuyển hướng về Vue callback URL
deactivate VNPAY
activate Vue
Vue --> Customer : Hiển thị màn hình thông báo đặt phòng thành công!
deactivate Vue
@enduml
```

### Biểu đồ 3.3: Chủ phòng cập nhật thông tin phòng nghỉ
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Chủ phòng" as Host
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

Host -> Vue : Nhập thông tin phòng nghỉ thay đổi và nhấn Lưu
activate Vue
Vue -> API : HTTP PUT /api/rooms/{id} (đăng nhập JWT)
activate API
API -> DB : SELECT * FROM rooms WHERE id = ? (Kiểm tra sở hữu)
activate DB
DB --> API : Trả về thông tin phòng
deactivate DB
API -> DB : Cập nhật phòng và đổi status sang 'PENDING' (chờ duyệt lại)
activate DB
DB --> API : Lưu thành công
deactivate DB
API --> Vue : HTTP 200 OK (Room Response DTO)
deactivate API
Vue --> Host : Hiển thị thông báo "Cập nhật thành công, chờ Admin phê duyệt"
deactivate Vue
@enduml
```

### Biểu đồ 3.4: Quản trị viên duyệt yêu cầu đăng phòng
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Quản trị viên" as Admin
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

Admin -> Vue : Nhấn nút "Duyệt phòng" trong danh sách phòng chờ
activate Vue
Vue -> API : HTTP PATCH /api/admin/rooms/{id}/approve (đăng nhập JWT)
activate API
API -> DB : UPDATE rooms SET status = 'ACTIVE' WHERE id = ?
activate DB
DB --> API : Cập nhật thành công
deactivate DB
API --> Vue : HTTP 200 OK (Room Response DTO)
deactivate API
Vue --> Admin : Cập nhật danh sách phòng, báo duyệt thành công
deactivate Vue
@enduml
```

### Biểu đồ 3.5: Xem thống kê & báo cáo doanh thu
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Chủ phòng / Admin" as User
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

User -> Vue : Chọn khoảng thời gian và nhấn Xem thống kê
activate Vue
Vue -> API : HTTP GET /api/revenue?startDate=...&endDate=...
activate API
API -> DB : SELECT bookings WHERE status = 'COMPLETED'
activate DB
DB --> API : Danh sách đơn đặt phòng đã hoàn thành
deactivate DB
API -> API : Tính toán doanh thu, hoa hồng, công nợ
API --> Vue : HTTP 200 OK (Revenue Stats Response)
deactivate API
Vue --> User : Vẽ biểu đồ doanh thu bằng Chart.js / ApexCharts
deactivate Vue
@enduml
```

### Biểu đồ 3.6: Tìm kiếm và xem chi tiết phòng nghỉ
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Khách vãng lai / Khách hàng" as Customer
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

Customer -> Vue : Nhập bộ lọc tìm kiếm và nhấn Tìm kiếm
activate Vue
Vue -> API : HTTP GET /api/rooms?city=...&checkIn=...&checkOut=...
activate API
API -> DB : Tìm kiếm phòng trống (JOIN FETCH roomType, images, host)
activate DB
DB --> API : Danh sách phòng trống thỏa mãn
deactivate DB
API --> Vue : HTTP 200 OK (Danh sách phòng)
deactivate API
Vue --> Customer : Hiển thị danh sách các phòng nghỉ kèm ảnh đại diện & giá
deactivate Vue

Customer -> Vue : Click chọn phòng nghỉ cụ thể để xem chi tiết
activate Vue
Vue -> API : HTTP GET /api/rooms/{id} (Chi tiết phòng & Review)
activate API
API -> DB : SELECT * FROM rooms r LEFT JOIN reviews v ... WHERE id = ?
activate DB
DB --> API : Chi tiết phòng nghỉ & danh sách các đánh giá
deactivate DB
API --> Vue : HTTP 200 OK (Chi tiết phòng & Review DTO)
deactivate API
Vue --> Customer : Hiển thị trang chi tiết phòng kèm bản đồ, ảnh và đánh giá
deactivate Vue
@enduml
```

### Biểu đồ 3.7: Hủy đặt phòng
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Khách hàng" as Customer
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

Customer -> Vue : Click nút "Hủy phòng" trong danh sách phòng đã đặt
activate Vue
Vue -> API : HTTP PATCH /api/bookings/{id}/cancel (đăng nhập JWT)
activate API
API -> DB : SELECT * FROM bookings WHERE id = ? (Kiểm tra sở hữu)
activate DB
DB --> API : Trả về thông tin đơn đặt phòng
deactivate DB
API -> API : Kiểm tra điều kiện thời gian hủy (Trước check-in >= 24h)

alt Đủ điều kiện hủy (Thành công)
    API -> DB : Đổi Booking -> CANCELLED, Payment -> REFUNDED (hoặc FAILED)
    activate DB
    DB --> API : Lưu thành công
    deactivate DB
    API --> Vue : HTTP 200 OK (Hủy thành công)
    Vue --> Customer : Thông báo hủy thành công, hoàn tiền (nếu đã thanh toán online)
else Quá hạn hủy (Thất bại)
    API --> Vue : HTTP 400 Bad Request (Error: Hủy trễ hạn)
    deactivate API
    Vue --> Customer : Thông báo lỗi: "Không được hủy phòng trước giờ nhận phòng dưới 24h"
end
deactivate Vue
@enduml
```

### Biểu đồ 3.8: Đánh giá chất lượng phòng nghỉ
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Khách hàng" as Customer
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

Customer -> Vue : Chọn đơn hàng hoàn tất, nhập số sao (1-5), nhận xét và gửi
activate Vue
Vue -> API : HTTP POST /api/reviews (đăng nhập JWT)
activate API
API -> DB : Kiểm tra đơn đặt phòng status = 'COMPLETED'
activate DB
DB --> API : Đơn đặt phòng hợp lệ
deactivate DB
API -> DB : Lưu đánh giá mới vào reviews
activate DB
DB --> API : Lưu đánh giá thành công
deactivate DB
API -> DB : Tính trung bình điểm số và cập nhật avg_rating của phòng
activate DB
DB --> API : Cập nhật thành công
deactivate DB
API --> Vue : HTTP 201 Created (Review DTO)
deactivate API
Vue --> Customer : Hiển thị thông báo đăng nhận xét đánh giá thành công!
deactivate Vue
@enduml
```

### Biểu đồ 3.9: Chủ phòng đăng phòng mới
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10

actor "Chủ phòng" as Host
participant "Vue\n(Frontend)" as Vue
participant "Backend API\n(Spring Boot)" as API
database "Database\n(MySQL)" as DB

Host -> Vue : Điền thông tin phòng nghỉ, chọn tọa độ bản đồ & chọn tải ảnh và Lưu
activate Vue
Vue -> API : HTTP POST /api/rooms (đăng nhập JWT)
activate API
API -> DB : Lưu thông tin phòng nghỉ mới với status = 'PENDING'
activate DB
DB --> API : Lưu thành công (Trả về createdRoomId)
deactivate DB
API --> Vue : HTTP 201 Created (Room DTO chứa createdRoomId)
deactivate API

alt Nếu chủ phòng chọn tải ảnh lên từ thiết bị
    Vue -> API : HTTP POST /api/images/rooms/{createdRoomId}/upload (Multipart FormData)
    activate API
    API -> API : Lưu trữ tệp ảnh vật lý vào thư mục cục bộ của máy chủ
    API -> DB : Lưu danh sách đường dẫn ảnh vào bảng room_images
    activate DB
    DB --> API : Lưu thành công
    deactivate DB
    API --> Vue : HTTP 200 OK (Upload thành công)
    deactivate API
end
Vue --> Host : Hiển thị thông báo "Đăng phòng thành công! Đang chờ Admin kiểm duyệt."
deactivate Vue
@enduml
```

### Biểu đồ 3.11: Chủ phòng nhập hàng loạt phòng từ file Excel
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10
actor "Chủ phòng" as Host
participant "Vue (Giao diện)" as Vue
participant "ExcelController" as Controller
participant "ExcelService" as Service
participant "RoomRepository" as RoomRepo
participant "GeocodingService" as GeoSvc
database "Database (MySQL)" as DB

Host -> Vue : Tải tệp tin Excel lên hệ thống
activate Vue
Vue -> Controller : HTTP POST /api/excel/rooms/import (Multipart File, đăng nhập JWT)
activate Controller
Controller -> Service : importRoomsFromExcel(file, hostId)
activate Service

Service -> Service : Đọc dữ liệu từ file Excel (Apache POI)
loop Với mỗi dòng dữ liệu phòng
    alt Dòng không có tọa độ vĩ độ/kinh độ
        Service -> GeoSvc : getCoordinatesFromAddress(address)
        activate GeoSvc
        GeoSvc --> Service : Trả về latitude, longitude
        deactivate GeoSvc
    end
    Service -> RoomRepo : checkDuplicateRoom(hostId, latitude, longitude)
    activate RoomRepo
    RoomRepo -> DB : SELECT COUNT(*) FROM rooms WHERE host_id = ? AND latitude = ? AND longitude = ?
    activate DB
    DB --> RoomRepo : Trả về số lượng phòng trùng vị trí
    deactivate DB
    RoomRepo --> Service : count
    deactivate RoomRepo

    alt Hợp lệ (không trùng lặp vị trí)
        Service -> RoomRepo : save(room) (status = 'PENDING')
        activate RoomRepo
        RoomRepo -> DB : INSERT INTO rooms ...
        activate DB
        DB --> RoomRepo : Lưu thành công
        deactivate DB
        deactivate RoomRepo
    end
end

Service --> Controller : Kết quả import (số dòng thành công, số dòng lỗi)
deactivate Service
Controller --> Vue : HTTP 200 OK (ExcelImportResult DTO)
deactivate Controller
Vue --> Host : Hiển thị bảng tổng kết kết quả nhập dữ liệu (thành công/lỗi chi tiết)
deactivate Vue
@enduml
```

### Biểu đồ 3.10: Quản trị viên quản lý chương trình khuyến mãi
```plantuml
@startuml
autonumber
skinparam DefaultFontSize 14
skinparam MaxMessageSize 120
skinparam ParticipantPadding 10
skinparam BoxPadding 10
actor "Quản trị viên" as Admin
participant "Vue (Giao diện)" as Vue
participant "PromotionController" as Controller
participant "PromotionService" as Service
participant "PromotionRepository" as Repo
database "Database (MySQL)" as DB

Admin -> Vue : Nhập mã khuyến mãi, phần trăm giảm giá, thời hạn và bấm Tạo
activate Vue
Vue -> Controller : HTTP POST /api/promotions (đăng nhập JWT)
activate Controller
Controller -> Service : createPromotion(request)
activate Service

Service -> Repo : save(promotion)
activate Repo
Repo -> DB : INSERT INTO promotions (code, discount_type, discount_value, active, ...) VALUES ...
activate DB
DB --> Repo : Lưu thành công
deactivate DB
Repo --> Service : Saved Promotion
deactivate Repo

Service --> Controller : PromotionResponse DTO
deactivate Service
Controller --> Vue : HTTP 201 Created (Promotion DTO)
deactivate Controller
Vue --> Admin : Cập nhật lại danh sách khuyến mãi, thông báo tạo thành công!
deactivate Vue
@enduml

---

## 4. Class Diagram (Biểu đồ lớp phân tích)

Biểu đồ lớp biểu diễn các đối tượng nghiệp vụ (Domain Entities) trong hệ thống, các thuộc tính nghiệp vụ và mối tương quan logic giữa các lớp.

### Biểu đồ lớp (PlantUML)

```plantuml
@startuml
skinparam monochrome true
skinparam linetype ortho
skinparam packageStyle rectangle
skinparam shadowing false
hide circle

class NguoiDung {
    - id : Long
    - hoTen : String
    - email : String
    - matKhau : String
    - soDienThoai : String
    - vaiTro : String
    - anhDaiDien : String
    - trangThaiHoatDong : Boolean
    - tyLeHoaHong : Double
}

class PhongNghi {
    - id : Long
    - tenPhong : String
    - moTa : String
    - diaChi : String
    - thanhPho : String
    - giaMoiDem : Double
    - soKhachToiDa : Integer
    - trangThaiPhieuDuyet : String
    - viDo : DECIMAL(10,8)
    - kinhDo : DECIMAL(11,8)
}

class LoaiPhong {
    - id : Integer
    - tenLoaiPhong : String
}

class AnhPhong {
    - id : Long
    - duongDanAnh : String
    - laAnhChinh : Boolean
}

class DonDatPhong {
    - id : Long
    - maDatPhong : String
    - ngayDat : Date
    - ngayNhanPhong : Date
    - ngayTraPhong : Date
    - soLuongKhach : Integer
    - tongTienThanhToan : Double
    - phuongThucThanhToan : String
    - trangThaiDonHang : String
    - ghiChu : String
    - tienHoaHongSan : Double
    - tienThucNhanChuNha : Double
    - daThanhToanHoaHong : Boolean
    - soTienKhuyenMai : Double
    - giaGoc : Double
    - maKhuyenMaiApDung : String
}

class GiaoDichThanhToan {
    - id : Long
    - soTien : Double
    - phuongThucThanhToan : String
    - trangThaiThanhToan : String
    - maGiaoDichNgoai : String
    - thoiGianThanhToan : DateTime
}

class DanhGia {
    - id : Long
    - soSaoDanhGia : Integer
    - noiDungNhanXet : String
    - thoiGianDanhGia : DateTime
}

class ChuongTrinhKhuyenMai {
    - id : Long
    - trangThaiKichHoat : Boolean
    - maKhuyenMai : String
    - moTa : String
    - loaiKhuyenMai : String
    - giaTriGiam : Double
    - ngayBatDau : Date
    - ngayKetThuc : Date
    - soTienToiThieuDeApDung : Double
    - soTienGiamToiDa : Double
    - gioiHanLuotDung : Integer
    - soLuotDaDung : Integer
}

class KhuyenMaiNguoiDung {
    - id : Long
    - thoiGianNhan : DateTime
    - daSuDung : Boolean
    - thoiGianSuDung : DateTime
}

class HoaDonHoaHong {
    - id : Long
    - soTienHoaHong : Double
    - ngayBatDauChuKy : Date
    - ngayKetThucChuKy : Date
    - hanThanhToan : Date
    - ngayThanhToan : Date
    - trangThaiHoaDon : String
    - maGiaoDichThanhToan : String
}

class CauHinhHeThong {
    - id : Long
    - tyLeHoaHongMacDinh : Double
}

class YeuCauRutTien {
    - id : Long
    - soTien : Double
    - tenNganHang : String
    - soTaiKhoan : String
    - chuTaiKhoan : String
    - trangThaiRutTien : String
    - ghiChu : String
    - thoiGianTao : DateTime
    - thoiGianCapNhat : DateTime
}

' --- Mối quan hệ giữa các lớp ---
NguoiDung "1" --> "0..*" PhongNghi : "sở hữu"
NguoiDung "1" --> "0..*" DonDatPhong : "đặt"
NguoiDung "1" --> "0..*" DanhGia : "đánh giá"
NguoiDung "1" --> "0..*" HoaDonHoaHong : "được lập cho"
NguoiDung "1" --> "0..*" KhuyenMaiNguoiDung : "sở hữu"
NguoiDung "1" --> "0..*" YeuCauRutTien : "yêu cầu rút tiền"
LoaiPhong "1" --> "0..*" PhongNghi : "phân loại"
PhongNghi "1" --> "0..*" AnhPhong : "hình ảnh mô tả"
PhongNghi "1" --> "0..*" DonDatPhong : "được đặt"
PhongNghi "1" --> "0..*" DanhGia : "được đánh giá"
DonDatPhong "1" -- "1" GiaoDichThanhToan : "thanh toán"
DonDatPhong "1" --> "0..*" KhuyenMaiNguoiDung : "áp dụng"
ChuongTrinhKhuyenMai "1" --> "0..*" KhuyenMaiNguoiDung : "phân phối"
@enduml
```

---

## 5. ERD (Entity-Relationship Diagram - Sơ đồ thực tế quan hệ)

Sơ đồ cơ sở dữ liệu mô tả cấu trúc vật lý của các bảng để lưu trữ dữ liệu trong hệ thống, tập trung vào thuộc tính dữ liệu nghiệp vụ và các liên kết khóa ngoại.

### Biểu đồ ERD (PlantUML)

```plantuml
@startuml
!theme plain
skinparam linetype ortho

entity "users" {
    * id : BIGINT <<PK>>
    --
    * email : VARCHAR(150) <<UK>>
    * password : VARCHAR(255)
    * full_name : VARCHAR(100)
    phone : VARCHAR(20)
    role : VARCHAR(50)
    avatar_url : VARCHAR(500)
    is_active : TINYINT(1)
    commission_rate : DECIMAL(5,2)
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "rooms" {
    * id : BIGINT <<PK>>
    --
    * host_id : BIGINT <<FK>>
    * room_type_id : INT <<FK>>
    * name : VARCHAR(200)
    description : TEXT
    address : VARCHAR(300)
    city : VARCHAR(100)
    price_per_night : DECIMAL(12,2)
    max_guests : INT
    status : VARCHAR(50)
    latitude : DECIMAL(10,8)
    longitude : DECIMAL(11,8)
}

entity "room_types" {
    * id : INT <<PK>>
    --
    * name : VARCHAR(100)
}

entity "room_images" {
    * id : BIGINT <<PK>>
    --
    * room_id : BIGINT <<FK>>
    * image_url : VARCHAR(500)
    is_primary : TINYINT(1)
}

entity "bookings" {
    * id : BIGINT <<PK>>
    --
    * user_id : BIGINT <<FK>>
    * room_id : BIGINT <<FK>>
    check_in : DATE
    check_out : DATE
    num_guests : INT
    total_price : DECIMAL(12,2)
    status : VARCHAR(50)
    note : TEXT
    commission_amount : DECIMAL(12,2)
    host_earning : DECIMAL(12,2)
    is_commission_billed : BIT(1)
    discount_amount : DECIMAL(12,2)
    original_price : DECIMAL(12,2)
    promo_code : VARCHAR(255)
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "payments" {
    * id : BIGINT <<PK>>
    --
    * booking_id : BIGINT <<FK>>
    amount : DECIMAL(12,2)
    method : VARCHAR(50)
    status : VARCHAR(50)
    transaction_id : VARCHAR(200)
    paid_at : TIMESTAMP
    created_at : TIMESTAMP
}

entity "reviews" {
    * id : BIGINT <<PK>>
    --
    * user_id : BIGINT <<FK>>
    * room_id : BIGINT <<FK>>
    rating : INT
    comment : TEXT
    created_at : TIMESTAMP
}

entity "promotions" {
    * id : BIGINT <<PK>>
    --
    * code : VARCHAR(50) <<UK>>
    active : BIT(1)
    description : VARCHAR(200)
    discount_type : VARCHAR(50)
    discount_value : DECIMAL(12,2)
    start_date : DATE
    end_date : DATE
    min_order_amount : DECIMAL(12,2)
    max_discount_amount : DECIMAL(12,2)
    usage_limit : INT
    used_count : INT
    created_at : TIMESTAMP
}

entity "user_promotions" {
    * id : BIGINT <<PK>>
    --
    * user_id : BIGINT <<FK>>
    * promotion_id : BIGINT <<FK>>
    booking_id : BIGINT <<FK>>
    claimed_at : DATETIME(6)
    used : BIT(1)
    used_at : DATETIME(6)
}

entity "commission_invoices" {
    * id : BIGINT <<PK>>
    --
    * host_id : BIGINT <<FK>>
    amount : DECIMAL(12,2)
    billing_period_start : DATE
    billing_period_end : DATE
    due_date : DATE
    paid_at : DATETIME(6)
    status : VARCHAR(50)
    transaction_id : VARCHAR(200)
    created_at : DATETIME(6)
}

entity "system_config" {
    * id : BIGINT <<PK>>
    --
    default_commission_rate : DECIMAL(5,2)
}

entity "payout_requests" {
    * id : BIGINT <<PK>>
    --
    * host_id : BIGINT <<FK>>
    amount : DECIMAL(12,2)
    bank_name : VARCHAR(100)
    account_number : VARCHAR(50)
    account_holder : VARCHAR(150)
    status : VARCHAR(50)
    note : TEXT
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

users ||--o{ rooms : "owns"
users ||--o{ bookings : "makes"
users ||--o{ reviews : "writes"
users ||--o{ commission_invoices : "billed_for"
users ||--o{ user_promotions : "owns_promo"
users ||--o{ payout_requests : "requests_payout"
room_types ||--o{ rooms : "categorizes"
rooms ||--o{ room_images : "contains"
rooms ||--o{ bookings : "is_booked_in"
rooms ||--o{ reviews : "receives"
bookings ||--|| payments : "has_payment"
bookings ||--o{ user_promotions : "applied_in"
promotions ||--o{ user_promotions : "distributed_as"
@enduml
```

---

## 6. Deployment Diagram (Biểu đồ triển khai logic)

Biểu đồ triển khai mô tả cách phân bổ các thành phần lô-gíc của hệ thống trên môi trường máy chủ và thiết bị người dùng.

### Biểu đồ triển khai (PlantUML)

```plantuml
@startuml
skinparam linetype ortho

node "Thiết bị người dùng (Client Node)" {
    node "Trình duyệt Web (Browser)" {
        component "Ứng dụng Giao diện (Client Application)" as ClientApp
    }
}

node "Máy chủ ứng dụng (Application Server)" {
    component "Bộ phận định tuyến và bảo mật (Web/Proxy Server)" as WebServer
    node "Môi trường thực thi ứng dụng" {
        component "Bộ xử lý Nghiệp vụ hệ thống (Backend Logic)" as BackendService
    }
}

node "Máy chủ Cơ sở dữ liệu (Database Server)" {
    database "Hệ quản trị Cơ sở dữ liệu quan hệ" {
        component "Cơ sở dữ liệu Đặt phòng khách sạn" as DB
    }
}

node "Hệ thống dịch vụ bên ngoài" {
    component "Cổng thanh toán trực tuyến" as PaymentGateway
}

ClientApp --> WebServer : Kết nối qua Giao thức mạng an toàn (Secure Network Connection)
ClientApp --> PaymentGateway : Chuyển hướng giao dịch thanh toán
WebServer --> BackendService : Chuyển tiếp yêu cầu xử lý
BackendService --> DB : Truy xuất và cập nhật dữ liệu
BackendService --> PaymentGateway : Đối chiếu kết quả giao dịch
@enduml
```

---

## 7. Architecture Diagram (Sơ đồ kiến trúc logic phân tầng)

Sơ đồ thể hiện sự phân chia các lớp kiến trúc logic đảm nhận các vai trò khác nhau trong hệ thống (Layered Architecture).

### Biểu đồ kiến trúc (PlantUML)

```plantuml
@startuml
skinparam linetype ortho

package "Tầng Giao diện người dùng (Presentation Layer)" {
    [Thành phần hiển thị giao diện] as UI
    [Quản lý trạng thái dữ liệu giao diện] as State
    [Điều hướng màn hình] as Nav
    [Thành phần gửi yêu cầu hệ thống] as Client
    
    UI --> State
    UI --> Nav
    UI --> Client
}

package "Tầng Kiểm soát bảo mật (Security Layer)" {
    [Kiểm soát quyền truy cập] as Cors
    [Xác thực thông tin người dùng] as Auth
}

package "Tầng Xử lý Nghiệp vụ (Business Logic Layer)" {
    [Điều phối yêu cầu] as Coordinator
    [Chuyển đổi dữ liệu nghiệp vụ] as DTO
    [Xử lý nghiệp vụ lõi] as CoreBusiness
    [Thành phần truy xuất dữ liệu] as DataAccess
    
    Coordinator --> DTO
    Coordinator --> CoreBusiness
    CoreBusiness --> DataAccess
}

database "Tầng Lưu trữ Dữ liệu" {
    [Cơ sở dữ liệu hệ thống] as SystemDB
}

Client --> Cors : 1. Gửi yêu cầu dịch vụ
Cors --> Auth
Auth --> Coordinator : 2. Chuyển tiếp yêu cầu đã xác thực
DataAccess --> SystemDB : 3. Truy vấn dữ liệu lưu trữ
SystemDB --> DataAccess : 4. Trả về kết quả truy vấn
DataAccess --> CoreBusiness
CoreBusiness --> Coordinator
Coordinator --> Client : 5. Trả về kết quả xử lý nghiệp vụ
@enduml
```

---

## 8. Flowchart các chức năng chính (Sơ đồ luồng)

Mô tả luồng người dùng di chuyển từ trang chủ tìm kiếm đến khi hoàn tất thanh toán phòng nghỉ.

### Sơ đồ luồng (PlantUML)

```plantuml
@startuml
' Cấu hình giao diện đen trắng (monochrome), không đổ bóng
skinparam monochrome true
skinparam shadowing false
skinparam defaultFontName "Arial"
skinparam defaultFontSize 12

skinparam activity {
  BackgroundColor White
  BorderColor Black
  ArrowColor Black
}

|Khách hàng|
start
:Truy cập Trang chủ;
:Nhập địa điểm, ngày nhận/trả phòng, số khách;
:Nhấn Tìm kiếm;
repeat
  :Hiển thị danh sách phòng phù hợp;
  backward:Áp dụng bộ lọc\n(giá, tiện nghi, loại phòng);
repeat while (Có lọc thêm?) is (Có) not (Không)

:Chọn phòng, xem chi tiết và đánh giá;

if (Nhấn Đặt phòng?) then (Có)
  if (Đã đăng nhập?) then (Chưa)
    :Chuyển hướng trang Đăng nhập / Đăng ký\n(Sau khi đăng nhập xong quay lại);
  else (Đã đăng nhập)
  endif
  
  :Điền ghi chú, áp dụng mã khuyến mãi (nếu có);
  :Chọn phương thức thanh toán;
  
  |Hệ thống|
  :Hệ thống tạo đơn đặt phòng\n(trạng thái PENDING);
  :Chuyển hướng sang\ncổng thanh toán VNPAY;
  
  |Cổng thanh toán VNPAY|
  if (Thanh toán thành công?) then (Có)
    |Hệ thống|
    :Cập nhật đơn đặt phòng sang CONFIRMED,\nghi nhận thanh toán thành công;
    :Gửi thông báo cho Chủ phòng và Khách hàng;
    
    |Khách hàng|
    :Kết thúc\n(Đặt phòng thành công);
    stop
  else (Không)
    |Hệ thống|
    :Báo lỗi thanh toán,\ngiữ nguyên trạng thái PENDING;
    
    |Khách hàng|
    :Kết thúc\n(Hủy xem phòng);
    stop
  endif
else (Không)
  |Khách hàng|
  :Kết thúc\n(Hủy xem phòng);
  stop
endif
@enduml
```

---

## 9. Biểu đồ thống kê kết quả trong báo cáo (Charts - PlantUML)

Dưới đây là các biểu đồ thống kê kết quả mô tả dưới dạng thiết kế PlantUML Salt để mô phỏng hiển thị trên báo cáo hoặc giao diện.

### 9.1. Biểu đồ 1: Thống kê doanh thu & Thực nhận Host 12 tháng (Năm 2026)
```plantuml
@startsalt
{
  Thống kê doanh thu & Thực nhận theo tháng năm 2026 (Triệu VNĐ)
  --
  Tháng | Tổng doanh thu khách trả | Thực nhận Host (đã trừ 10% phí)
  Tháng 1  | 120 Triệu | 108 Triệu
  Tháng 2  | 115 Triệu | 103 Triệu
  Tháng 3  | 130 Triệu | 117 Triệu
  Tháng 4  |  95 Triệu |  85 Triệu
  Tháng 5  | 140 Triệu | 126 Triệu
  Tháng 6  | 110 Triệu |  99 Triệu
  Tháng 7  |  85 Triệu |  76 Triệu
  Tháng 8  | 125 Triệu | 112 Triệu
  Tháng 9  | 100 Triệu |  90 Triệu
  Tháng 10 | 135 Triệu | 121 Triệu
  Tháng 11 | 145 Triệu | 130 Triệu
  Tháng 12 | 150 Triệu | 135 Triệu
}
@endsalt
```

### 9.2. Biểu đồ 2: Tỷ lệ trạng thái đơn đặt phòng
```plantuml
@startsalt
{
  Tỷ lệ đơn đặt phòng theo trạng thái
  --
  * CONFIRMED / COMPLETED (Thành công) | [====================] 72%
  * CANCELLED (Khách hủy)             | [=====] 20%
  * PENDING (Chờ thanh toán)          | [==] 8%
}
@endsalt
```

### 9.3. Biểu đồ 3: Top 5 phòng có doanh thu cao nhất
```plantuml
@startsalt
{
  Top 5 phòng nghỉ có doanh thu cao nhất năm 2026
  --
  1. Presidential Suite | [========================] 240 Triệu VNĐ
  2. Deluxe Ocean View  | [==================] 185 Triệu VNĐ
  3. Executive Suite    | [===============] 150 Triệu VNĐ
  4. Family Bungalow    | [============] 120 Triệu VNĐ
  5. Superior Garden    | [=========] 95 Triệu VNĐ
}
@endsalt
```

### 9.4. Biểu đồ 4: Tỷ lệ phòng có cập nhật vị trí GPS
```plantuml
@startsalt
{
  Tỷ lệ phòng có tọa độ GPS được cập nhật
  --
  * Có vị trí (locationAvailable = true)  | [================] 65%
  * Chưa có vị trí (chờ host cập nhật)   | [========] 35%
}
@endsalt
```

### 9.5. Biểu đồ 5: Phương thức Import phòng của Host
```plantuml
@startsalt
{
  Tỷ lệ phương thức đăng phòng của Chủ phòng
  --
  * Đăng thủ công qua Form     | [==================] 74%
  * Nhập hàng loạt qua Excel  | [======] 26%
}
@endsalt
```

---

## HƯỚNG DẪN CÁCH VẼ LÊN WORD / DRAW.IO / SLIDE
1. **Để xuất ảnh sơ đồ nhanh**: Bạn hãy truy cập vào trang [PlantText UML Editor](https://www.planttext.com/) hoặc [PlantUML Live Editor](http://www.plantuml.com/plantuml), sao chép mã PlantUML ở các mục trên dán vào khung soạn thảo. Trang web sẽ tự động render ra hình ảnh cực kỳ sắc nét để bạn có thể tải về dạng PNG/SVG chèn vào báo cáo.
2. **Để vẽ tùy chỉnh trên Draw.io**: 
   - Mở [Draw.io](https://app.diagrams.net/).
   - Bạn có thể chọn menu `Arrange` -> `Insert` -> `Advanced` -> `PlantUML...` và dán mã nguồn PlantUML ở trên để draw.io tự vẽ sơ đồ thành các khối có thể chỉnh sửa thủ công.
3. **Thư viện đề xuất trên Vue.js 3**: Nếu giảng viên yêu cầu hiển thị biểu đồ thống kê trực tiếp trên giao diện Admin/Host, hãy cài đặt và sử dụng thư viện **ApexCharts** (`vue3-apexcharts`) or **Chart.js** (`vue-chartjs`). Chúng rất dễ bind data từ API JSON trả về từ Controller.
