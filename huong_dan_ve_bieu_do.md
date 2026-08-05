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
Guest --> UC_Search

Customer --> UC_Book
Customer --> UC_ManageBooking
Customer --> UC_Cancel
Customer --> UC_Review

UC_Pay ..> UC_Book : <<extend>>

Host --> UC_RegRoom
Host --> UC_ManageRoom
Host --> UC_ManageHostBooking
Host --> UC_HostRevenue

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
Chủ nhà gửi đăng ký thông tin phòng mới lên hệ thống. Hệ thống hỗ trợ chọn vị trí trên bản đồ Leaflet; nếu chủ phòng chưa chọn thủ công, hệ thống tự động Geocoding từ địa chỉ nhập vào, kiểm tra trùng tọa độ trong phạm vi 20m cùng chủ trước khi lưu. Sau đó hệ thống chờ kiểm duyệt và hiển thị công khai khi được phê duyệt.

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
actor "Khách hàng" as User
participant "Giao diện Đăng nhập" as GUI
participant ": Tài khoản" as Account

User -> GUI : Nhập thông tin đăng nhập (Email, mật khẩu)
activate GUI

GUI -> Account : Kiểm tra thông tin đăng nhập
activate Account
Account -> Account : Xác thực thông tin
Account --> GUI : Kết quả xác thực
deactivate Account

alt Xác thực thành công
    GUI --> User : Đăng nhập thành công, hiển thị trang cá nhân
else Thông tin sai / Mật khẩu sai
    GUI --> User : Hiển thị thông báo lỗi đăng nhập
end
deactivate GUI
@enduml
```

### Biểu đồ 3.2: Đặt phòng và Thanh toán trực tuyến
```plantuml
@startuml
autonumber
actor "Khách hàng" as Customer
participant "Giao diện Đặt phòng" as GUI
participant ": Phòng" as Room
participant ": Khuyến mãi" as Promo
participant ": Đơn đặt phòng" as Booking
participant ": Thanh toán" as Payment

Customer -> GUI : Gửi yêu cầu đặt phòng (mã phòng, ngày đặt, số khách, mã khuyến mãi)
activate GUI

GUI -> Room : Kiểm tra tình trạng phòng trống
activate Room
Room --> GUI : Trả về tình trạng phòng trống khả dụng
deactivate Room

GUI -> Promo : Áp dụng mã khuyến mãi
activate Promo
Promo --> GUI : Trả về số tiền giảm giá
deactivate Promo

GUI -> Booking : Khởi tạo đơn đặt phòng mới (Chờ thanh toán)
activate Booking
Booking --> GUI : Trả về đơn đặt phòng mới
deactivate Booking

GUI -> Payment : Thực hiện giao dịch thanh toán
activate Payment

Payment -> Customer : Yêu cầu xác nhận thanh toán
Customer -> Payment : Xác nhận thanh toán

Payment -> Payment : Xử lý thanh toán thành công

Payment --> GUI : Trả về kết quả thanh toán thành công
deactivate Payment

GUI -> Booking : Cập nhật trạng thái đơn sang Đã xác nhận
activate Booking
Booking --> GUI : Xác nhận cập nhật thành công
deactivate Booking

GUI --> Customer : Hiển thị thông báo đặt phòng thành công
deactivate GUI
@enduml
```

### Biểu đồ 3.3: Chủ phòng cập nhật thông tin phòng nghỉ
```plantuml
@startuml
autonumber
actor "Chủ phòng" as Host
participant "Giao diện Chủ phòng" as GUI
participant ": Phòng" as Room

Host -> GUI : Chỉnh sửa phòng nghỉ (Giá phòng, tiện ích...)
activate GUI

GUI -> Room : Lấy thông tin phòng nghỉ
activate Room
Room --> GUI : Trả về thông tin phòng nghỉ
deactivate Room

GUI -> Room : Cập nhật thông tin phòng mới & Chuyển trạng thái chờ duyệt
activate Room
Room --> GUI : Xác nhận cập nhật thành công
deactivate Room

GUI --> Host : Hiển thị thông báo cập nhật thành công
deactivate GUI
@enduml
```

### Biểu đồ 3.4: Quản trị viên duyệt yêu cầu đăng phòng
```plantuml
@startuml
autonumber
actor "Quản trị viên" as Admin
participant "Giao diện Quản trị" as GUI
participant ": Phòng" as Room

Admin -> GUI : Chọn duyệt yêu cầu đăng phòng nghỉ
activate GUI

GUI -> Room : Cập nhật trạng thái phòng thành Đang hoạt động
activate Room
Room --> GUI : Xác nhận cập nhật trạng thái thành công
deactivate Room

GUI --> Admin : Hiển thị danh sách phòng sau khi cập nhật
deactivate GUI
@enduml
```

### Biểu đồ 3.5: Xem thống kê & báo cáo doanh thu
```plantuml
@startuml
autonumber
actor "Người dùng" as User
participant "Giao diện Thống kê" as GUI
participant ": Đơn đặt phòng" as Booking

User -> GUI : Chọn thời gian thống kê & yêu cầu xem báo cáo
activate GUI

GUI -> Booking : Yêu cầu thống kê doanh thu
activate Booking
Booking -> Booking : Tính toán và tổng hợp dữ liệu doanh thu
Booking --> GUI : Kết quả thống kê doanh thu
deactivate Booking

GUI --> User : Hiển thị báo cáo doanh thu trực quan
deactivate GUI
@enduml
```

### Biểu đồ 3.6: Tìm kiếm và xem chi tiết phòng nghỉ
```plantuml
@startuml
autonumber
actor "Khách hàng" as Customer
participant "Giao diện Tìm kiếm" as GUI
participant ": Phòng" as Room
participant ": Đánh giá" as Review

Customer -> GUI : Nhập bộ lọc tìm kiếm và nhấn Tìm kiếm
activate GUI

GUI -> Room : Tìm kiếm phòng nghỉ còn trống theo bộ lọc
activate Room
Room --> GUI : Trả về danh sách phòng nghỉ phù hợp
deactivate Room

GUI --> Customer : Hiển thị danh sách phòng khả dụng
deactivate GUI

Customer -> GUI : Chọn xem chi tiết một phòng nghỉ cụ thể
activate GUI

GUI -> Room : Lấy thông tin chi tiết phòng nghỉ
activate Room
Room --> GUI : Trả về thông tin phòng chi tiết
deactivate Room

GUI -> Review : Lấy danh sách nhận xét đánh giá của khách hàng khác
activate Review
Review --> GUI : Trả về danh sách nhận xét đánh giá
deactivate Review

GUI --> Customer : Hiển thị trang chi tiết phòng và các đánh giá
deactivate GUI
@enduml
```

### Biểu đồ 3.7: Hủy đặt phòng và Hoàn tiền
```plantuml
@startuml
autonumber
actor "Khách hàng" as Customer
participant "Giao diện Đặt phòng" as GUI
participant ": Đơn đặt phòng" as Booking
participant "Cổng thanh toán" as PaymentGateway

Customer -> GUI : Yêu cầu hủy đặt phòng đã đặt
activate GUI

GUI -> Booking : Lấy thông tin đơn đặt phòng
activate Booking
Booking --> GUI : Trả về thông tin đơn đặt phòng
deactivate Booking

GUI -> Booking : Kiểm tra điều kiện hủy phòng
activate Booking
Booking --> GUI : Kết quả kiểm tra điều kiện hủy (Đủ điều kiện hoàn tiền / Hủy trễ)
deactivate Booking

alt Đủ điều kiện hủy và được hoàn tiền
    GUI -> Booking : Đổi trạng thái đơn sang Đã hủy & ghi nhận hoàn tiền
    activate Booking
    Booking --> GUI : Xác nhận cập nhật thành công
    deactivate Booking
    
    GUI -> PaymentGateway : Gửi yêu cầu hoàn tiền giao dịch sang Cổng thanh toán
    activate PaymentGateway
    PaymentGateway --> GUI : Xác nhận hoàn tiền thành công
    deactivate PaymentGateway
    
    GUI --> Customer : Hiển thị thông báo hủy và hoàn tiền thành công
else Hủy trễ (không được hoàn tiền theo quy định)
    GUI -> Booking : Đổi trạng thái đơn sang Đã hủy (giữ nguyên thanh toán)
    activate Booking
    Booking --> GUI : Xác nhận cập nhật thành công
    deactivate Booking
    
    GUI --> Customer : Hiển thị thông báo hủy đơn đặt phòng thành công (không hoàn tiền)
end
deactivate GUI
@enduml
```

### Biểu đồ 3.8: Đánh giá chất lượng phòng nghỉ
```plantuml
@startuml
autonumber
actor "Khách hàng" as Customer
participant "Giao diện Đặt phòng" as GUI
participant ": Đơn đặt phòng" as Booking
participant ": Đánh giá" as Review
participant ": Phòng" as Room

Customer -> GUI : Chọn viết đánh giá (Nhập số sao, nhận xét)
activate GUI

GUI -> Booking : Kiểm tra điều kiện đơn đặt phòng
activate Booking
Booking --> GUI : Xác nhận đơn hàng hợp lệ (đã hoàn tất chuyến đi)
deactivate Booking

GUI -> Review : Lưu thông tin đánh giá nhận xét mới
activate Review
Review --> GUI : Xác nhận lưu đánh giá thành công
deactivate Review

GUI -> Room : Tính toán và cập nhật số sao đánh giá trung bình mới
activate Room
Room --> GUI : Xác nhận cập nhật thành công
deactivate Room

GUI --> Customer : Hiển thị thông báo đăng nhận xét đánh giá thành công
deactivate GUI
@enduml
```

### Biểu đồ 3.9: Chủ phòng đăng thông tin phòng & tải ảnh (có chọn vị trí bản đồ)
```plantuml
@startuml
autonumber
actor "Chủ phòng" as Host
participant "Giao diện Chủ phòng" as GUI
participant ": Bản đồ / Geocoding" as Map
participant ": Phòng" as Room
participant ": Ảnh phòng" as Image

Host -> GUI : Điền thông tin phòng mới, chọn vị trí trên bản đồ (kéo Marker)
activate GUI

alt Chưa chọn vị trí thủ công
    GUI -> Map : Gọi Geocoding (Nominatim) để lấy tọa độ từ địa chỉ
    activate Map
    Map --> GUI : Trả về latitude, longitude
    deactivate Map
end

GUI -> GUI : Kiểm tra tọa độ hợp lệ & không trùng phòng cùng Host (<20m)

Host -> GUI : Gửi thông tin phòng mới và danh sách hình ảnh
GUI -> Room : Khởi tạo phòng nghỉ mới (Chờ duyệt) với latitude, longitude
activate Room

Room -> Image : Lưu trữ các hình ảnh mô tả phòng nghỉ
activate Image
Image --> Room : Xác nhận lưu ảnh thành công
deactivate Image

Room --> GUI : Trả về thông tin phòng đã tạo
deactivate Room

GUI --> Host : Hiển thị thông báo đăng phòng thành công, đang chờ kiểm duyệt
deactivate GUI
@enduml
```

### Biểu đồ 3.11: Chủ phòng nhập hàng loạt phòng từ file Excel
```plantuml
@startuml
autonumber
actor "Chủ phòng" as Host
participant "Giao diện Import Excel" as GUI
participant ": Geocoding (Nominatim)" as Geocoding
participant ": Phòng" as Room

Host -> GUI : Tải lên file Excel danh sách phòng
activate GUI

GUI -> GUI : Đọc từng dòng dữ liệu phòng từ file

loop Với mỗi dòng trong file
    alt Dòng có tọa độ (latitude, longitude)
        GUI -> GUI : Sử dụng tọa độ từ file trực tiếp
    else Dòng không có tọa độ
        GUI -> Geocoding : Gọi Geocoding từ địa chỉ (rate limit: 1 req/giây)
        activate Geocoding
        Geocoding --> GUI : Trả về tọa độ hoặc lỗi
        deactivate Geocoding
    end
    GUI -> Room : Kiểm tra trùng tọa độ (<20m cùng Host) & lưu phòng hợp lệ
    activate Room
    Room --> GUI : Xác nhận lưu thành công hoặc lỗi chi tiết
    deactivate Room
end

GUI --> Host : Báo cáo kết quả:\nSố dòng thành công / Số dòng lỗi (kèm lý do chi tiết)
deactivate GUI
@enduml
```

### Biểu đồ 3.10: Quản trị viên quản lý chương trình khuyến mãi
```plantuml
@startuml
autonumber
actor "Quản trị viên" as Admin
participant "Giao diện Quản trị" as GUI
participant ": Chương trình khuyến mãi" as Promo

Admin -> GUI : Nhập mã, giá trị giảm và nhấn Tạo khuyến mãi
activate GUI

GUI -> Promo : Lưu thông tin chương trình khuyến mãi mới
activate Promo
Promo --> GUI : Trả về thông tin chương trình khuyến mãi mới tạo
deactivate Promo

GUI --> Admin : Hiển thị danh sách khuyến mãi mới
deactivate GUI

Admin -> GUI : Nhấp bật hoặc tắt hoạt động của chương trình khuyến mãi
activate GUI

GUI -> Promo : Thay đổi trạng thái hoạt động của chương trình khuyến mãi
activate Promo
Promo --> GUI : Trả về kết quả cập nhật trạng thái
deactivate Promo

GUI --> Admin : Hiển thị danh sách khuyến mãi sau khi cập nhật
deactivate GUI

Admin -> GUI : Yêu cầu xóa chương trình khuyến mãi khỏi hệ thống
activate GUI

GUI -> Promo : Xóa chương trình khuyến mãi khỏi hệ thống dữ liệu
activate Promo
Promo --> GUI : Xác nhận đã xóa chương trình khuyến mãi thành công
deactivate Promo

GUI --> Admin : Hiển thị danh sách khuyến mãi sau khi xóa
deactivate GUI
@enduml
```

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

' --- Mối quan hệ giữa các lớp ---
NguoiDung "1" --> "0..*" PhongNghi : "sở hữu"
NguoiDung "1" --> "0..*" DonDatPhong : "đặt"
NguoiDung "1" --> "0..*" DanhGia : "đánh giá"
NguoiDung "1" --> "0..*" HoaDonHoaHong : "được lập cho"
NguoiDung "1" --> "0..*" KhuyenMaiNguoiDung : "sở hữu"
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

users ||--o{ rooms : "owns"
users ||--o{ bookings : "makes"
users ||--o{ reviews : "writes"
users ||--o{ commission_invoices : "billed_for"
users ||--o{ user_promotions : "owns_promo"
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
start
:Truy cập Trang chủ;
:Nhập địa điểm, Ngày nhận/trả phòng, Số khách;
:Nhấn Tìm kiếm;
:Hiển thị danh sách phòng thỏa mãn;
repeat
    if (Lọc phòng tiện ích/giá?) then (Có)
        :Cập nhật bộ lọc;
        :Hiển thị danh sách phòng thỏa mãn;
    else (Không)
    endif
    :Chọn phòng phù hợp;
    :Xem chi tiết phòng & Xem đánh giá;
    if (Nhấn Đặt phòng?) then (Không)
        stop
    else (Có)
    endif
    repeat
        if (Khách hàng đã đăng nhập?) then (Chưa đăng nhập)
            :Chuyển hướng trang Đăng nhập/Đăng ký;
        else (Đã đăng nhập)
        endif
    backward :Đăng nhập;
    repeat while (Chưa đăng nhập?) is (Đúng)
    :Trang thông tin đặt phòng, điền ghi chú & áp dụng mã khuyến mãi;
    :Chọn phương thức thanh toán qua Cổng thanh toán;
    :Hệ thống kiểm tra & Khóa phòng nghỉ tạm thời (Chờ thanh toán);
    :Chuyển hướng sang Cổng thanh toán;
    if (Giao dịch thanh toán thành công?) then (Không)
        :Báo lỗi đặt phòng - Giải phóng phòng nghỉ;
    else (Có)
        :Cập nhật Đơn đặt phòng thành Đã xác nhận\nGhi nhận thanh toán thành công;
        :Gửi thông báo cho Chủ phòng & Khách hàng;
        stop
    endif
repeat while (Quay lại danh sách?)
stop
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
  Tỷ lệ phương thức đăng phòng của Chủ nhà
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
