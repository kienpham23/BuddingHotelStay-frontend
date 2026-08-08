# Hướng Dẫn Chi Tiết Luồng Logic Hủy Đặt Phòng (Booking Cancellation)

Tài liệu này giải thích chi tiết toàn bộ mã nguồn của cả **Frontend (Vue 3)** và **Backend (Spring Boot)** xử lý nghiệp vụ **Hủy đặt phòng và Hoàn tiền** theo sơ đồ thiết kế trong file `huong_dan_ve_bieu_do.md` (Biểu đồ 3.7).

---

## 1. TỔNG QUAN LUỒNG NGHIỆP VỤ

1. **Khách hàng (Customer)** xem danh sách đơn đã đặt ở giao diện Frontend và click vào nút **Yêu cầu hủy đặt phòng**.
2. **Frontend** kiểm tra điều kiện hủy cơ bản (nếu ở trạng thái `CONFIRMED` thì phải trước giờ nhận phòng 24 tiếng). Nếu thỏa mãn, hiển thị popup xác nhận.
3. Khi xác nhận, Frontend gọi API: `PATCH /api/bookings/{id}/cancel`.
4. **Backend (Spring Boot API)** tiếp nhận yêu cầu, thực hiện kiểm tra quyền sở hữu đơn hàng và kiểm tra điều kiện hủy (không cho phép hủy trễ hạn - dưới 24h đối với đơn đã xác nhận).
5. **Backend** cập nhật trạng thái đơn đặt phòng (`Booking`) thành `CANCELLED`.
6. **Backend** cập nhật trạng thái thanh toán (`Payment`) sang `FAILED` (nếu còn `PENDING`) hoặc sang `REFUNDED` (nếu giao dịch trước đó đã thanh toán thành công `SUCCESS`).
7. Trả kết quả thành công về **Frontend** để cập nhật trạng thái UI và hiển thị thông báo.

---

## 2. FRONTEND (VUE 3)

Mã nguồn Frontend xử lý giao diện hủy đặt phòng nằm tại các file chính sau:

### 2.1. File Giao diện & Xử lý sự kiện: [MyBookingsView.vue](file:///c:/Users/USER/hotel-booking-fe/src/views/MyBookingsView.vue)

Trong file này, logic được chia làm 3 phần chính:

#### A. Điều kiện hiển thị nút hủy phòng (Template & Script)
- Nút hủy phòng chỉ hiển thị khi hàm `canCancelBooking(booking)` trả về `true`.
- **Đoạn mã kiểm tra điều kiện (Dòng 803 - 813):**
```javascript
const canCancelBooking = (booking) => {
  if (booking.status === 'PENDING') return true
  if (booking.status === 'CONFIRMED') {
    if (!booking.checkIn) return false
    const checkInDateTime = new Date(`${booking.checkIn}T14:00:00`)
    const now = new Date()
    const diffHours = (checkInDateTime - now) / (1000 * 60 * 60)
    return diffHours >= 24 // Phải trước 24 tiếng so với giờ nhận phòng (mặc định 14:00)
  }
  return false
}
```
- **Đoạn mã hiển thị nút trên giao diện (Dòng 145 - 154):**
```html
<!-- Nút hủy đặt phòng hiển thị khi canCancelBooking trả về true -->
<button
  v-if="canCancelBooking(booking)"
  class="btn-cancel-booking"
  @click="confirmCancel(booking)"
  :disabled="cancellingId === booking.id"
>
  <span v-if="cancellingId !== booking.id">{{ $t('booking.cancel_request') }}</span>
  <span v-else class="spinner-small"></span>
</button>
```

#### B. Modal Xác nhận Hủy đặt phòng (Dòng 270 - 282)
- Khi click nút hủy, hàm `confirmCancel(booking)` lưu thông tin đơn được chọn và đổi trạng thái hiển thị modal thành `true`.
```html
<div class="modal-backdrop" v-if="showCancelModal">
  <div class="confirm-modal">
    <h3>{{ locale === 'vi' ? 'Xác nhận hủy đặt phòng?' : 'Confirm cancellation?' }}</h3>
    <p>
      {{ locale === 'vi' ? 'Hành động hủy phòng' : 'Cancellation of room' }} 
      <strong>#{{ selectedBooking?.id }}</strong> 
      {{ locale === 'vi' ? 'tại' : 'at' }} 
      <strong>{{ selectedBooking?.roomName }}</strong> 
      {{ locale === 'vi' ? 'là không thể khôi phục. Bạn có chắc chắn muốn tiếp tục?' : 'is irreversible. Are you sure you want to proceed?' }}
    </p>
    <div class="modal-actions">
      <button class="btn-modal-cancel" @click="showCancelModal = false">{{ locale === 'vi' ? 'Đóng' : 'Close' }}</button>
      <button class="btn-modal-confirm" @click="executeCancel" :disabled="cancelLoading">
        <span v-if="!cancelLoading">{{ locale === 'vi' ? 'Xác nhận hủy phòng' : 'Confirm cancellation' }}</span>
        <span v-else class="spinner-small"></span>
      </button>
    </div>
  </div>
</div>
```

#### C. Gọi API gửi yêu cầu hủy và cập nhật UI (Dòng 820 - 842)
- Khi khách hàng click **Xác nhận hủy phòng** trong modal, hàm `executeCancel()` sẽ được gọi:
```javascript
const executeCancel = async () => {
  if (!selectedBooking.value) return
  cancelLoading.value = true
  cancellingId.value = selectedBooking.value.id
  try {
    // 1. Gửi request PATCH lên backend để cập nhật trạng thái hủy
    await axios.patch(`/bookings/${selectedBooking.value.id}/cancel`)
    
    // 2. Cập nhật trực tiếp danh sách bookings trên UI local thành CANCELLED
    const idx = bookings.value.findIndex(b => b.id === selectedBooking.value.id)
    if (idx !== -1) {
      bookings.value[idx].status = 'CANCELLED'
    }
    // 3. Hiển thị thông báo toast thành công và đóng modal
    toastStore.success(t('booking.success_cancel'))
    showCancelModal.value = false
  } catch (err) {
    console.error('Hủy đặt phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || t('booking.fail_cancel'))
  } finally {
    cancelLoading.value = false
    cancellingId.value = null
    selectedBooking.value = null
  }
}
```

### 2.2. File cấu hình axios gọi API: [axios.js](file:///c:/Users/USER/hotel-booking-fe/src/api/axios.js)
- Axios tự động thêm token JWT của người dùng vào HTTP Headers và ánh xạ base URL:
```javascript
const instance = axios.create({
    baseURL: `${import.meta.env.VITE_API_BASE_URL || 'http://localhost:8088'}/api`,
    timeout: 10000,
})
```

---

## 3. BACKEND (SPRING BOOT)

Mã nguồn Backend xử lý nghiệp vụ này nằm tại các file chính sau:

### 3.1. File RestController: [BookingController.java](file:///d:/DATN/hotel-booking/src/main/java/com/hotelbooking/controller/BookingController.java)
- Nơi tiếp nhận HTTP Request từ Client gọi lên:
```java
@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {
    
    private final BookingService bookingService;

    // Định nghĩa endpoint PATCH /api/bookings/{id}/cancel
    @PatchMapping("/{id}/cancel")
    @PreAuthorize("hasRole('CUSTOMER')") // Chỉ tài khoản có role CUSTOMER mới có quyền gọi API này
    public ResponseEntity<BookingResponse> cancel(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.cancelBooking(id));
    }
}
```

### 3.2. File Nghiệp vụ (Service): [BookingService.java](file:///d:/DATN/hotel-booking/src/main/java/com/hotelbooking/service/BookingService.java)
- Hàm `cancelBooking(Long id)` thực hiện toàn bộ nghiệp vụ kiểm tra nghiệp vụ và lưu thay đổi vào cơ sở dữ liệu:
```java
// CUSTOMER hủy đơn đặt phòng
@org.springframework.transaction.annotation.Transactional
public BookingResponse cancelBooking(Long id) {
    // 1. Lấy thông tin tài khoản hiện tại đang đăng nhập
    User customer = getCurrentUser();
    
    // 2. Kiểm tra đơn đặt phòng có tồn tại không
    Booking booking = bookingRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Booking không tồn tại"));

    // 3. Xác thực quyền sở hữu đơn đặt phòng của Customer
    if (!booking.getUser().getId().equals(customer.getId())) {
        throw new RuntimeException("Không có quyền hủy đơn này");
    }
    
    // 4. Chỉ cho phép hủy khi trạng thái là PENDING (đang chờ) hoặc CONFIRMED (đã xác nhận)
    if (booking.getStatus() != Booking.Status.PENDING && booking.getStatus() != Booking.Status.CONFIRMED) {
        throw new RuntimeException("Chỉ có thể hủy đơn đang chờ xác nhận hoặc đã xác nhận");
    }

    // 5. Nếu đơn đã CONFIRMED, chỉ cho phép hủy trước 24 giờ nhận phòng (Giờ check-in mặc định là 14:00 ngày nhận phòng)
    if (booking.getStatus() == Booking.Status.CONFIRMED) {
        java.time.LocalDateTime checkInDateTime = booking.getCheckIn().atTime(14, 0);
        if (java.time.LocalDateTime.now().isAfter(checkInDateTime.minusHours(24))) {
            throw new RuntimeException("Chỉ được phép hủy phòng trước 24 giờ so với giờ nhận phòng (14:00 ngày nhận phòng)");
        }
    }

    // 6. Cập nhật trạng thái đơn đặt phòng thành CANCELLED
    booking.setStatus(Booking.Status.CANCELLED);
    
    // 7. Cập nhật trạng thái thanh toán tương ứng sang FAILED nếu còn PENDING, hoặc REFUNDED nếu đã thanh toán thành công
    paymentRepository.findByBookingId(id).ifPresent(p -> {
        if (p.getStatus() == com.hotelbooking.entity.Payment.Status.PENDING) {
            p.setStatus(com.hotelbooking.entity.Payment.Status.FAILED);
            paymentRepository.save(p);
        } else if (p.getStatus() == com.hotelbooking.entity.Payment.Status.SUCCESS) {
            p.setStatus(com.hotelbooking.entity.Payment.Status.REFUNDED);
            paymentRepository.save(p);
        }
    });
    
    // 8. Lưu thay đổi vào Database và trả dữ liệu về dạng DTO Response
    return toResponse(bookingRepository.save(booking));
}
```

### 3.3. File Tự động hủy đơn hàng (Scheduler): [BookingScheduler.java](file:///d:/DATN/hotel-booking/src/main/java/com/hotelbooking/service/BookingScheduler.java)
- Ngoài chức năng Khách hàng tự hủy trên UI, hệ thống còn chạy một **Scheduler chạy ngầm** (BookingScheduler) để tự động quét cơ sở dữ liệu và hủy bỏ các đơn quá hạn thanh toán/xác nhận:
- **Nguyên lý hoạt động:**
  - Định kỳ (ví dụ mỗi phút), scheduler quét danh sách các đơn hàng ở trạng thái `PENDING`.
  - Nếu đơn hàng quá hạn thanh toán Momo/VNPay hoặc quá hạn xác nhận từ phía Host, Scheduler sẽ tự động chuyển đổi trạng thái của Booking sang `CANCELLED`.

---

## 4. CƠ SỞ DỮ LIỆU LIÊN QUAN (DATABASE ENTITIES)

### 4.1. Thực thể Booking: [Booking.java](file:///d:/DATN/hotel-booking/src/main/java/com/hotelbooking/entity/Booking.java)
- Quản lý trạng thái đơn hàng thông qua Enum `Status`:
```java
public class Booking {
    // ...
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status = Status.PENDING;

    public enum Status {
        PENDING, CONFIRMED, CANCELLED, COMPLETED
    }
}
```

### 4.2. Thực thể Thanh Toán: `Payment.java`
- Quản lý giao dịch thanh toán liên kết với Booking, chứa các trạng thái như `PENDING`, `SUCCESS`, `FAILED`.

---

## TÓM TẮT SỰ KHÁC BIỆT GIỮA SƠ ĐỒ VÀ MÃ NGUỒN THỰC TẾ
- **Sơ đồ thiết kế (PlantUML):** Mô phỏng luồng hoàn trả tiền giao dịch từ Payment Gateway (VNPay/Momo) tự động.
- **Mã nguồn thực tế:** Xử lý cập nhật trạng thái đơn thành `CANCELLED` trong cơ sở dữ liệu và đánh dấu giao dịch thanh toán Pending thành `FAILED`. Việc xử lý hoàn trả tiền qua VNPay/Momo thực tế thường cần thông qua dashboard quản trị của VNPAY/MoMo Merchant hoặc API Refund (chưa được tích hợp trực tiếp tự động trong mã nguồn Spring Boot hiện tại vì lí do bảo mật test-key).
