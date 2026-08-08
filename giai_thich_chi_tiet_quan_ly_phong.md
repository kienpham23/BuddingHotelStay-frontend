# Tài Liệu Giải Thích Chi Tiết Giao Diện & Logic Quản Lý Phòng Nghỉ (Host Room Management)

Tài liệu này giải thích chi tiết cấu trúc giao diện (Frontend) và các xử lý nghiệp vụ (Backend) liên quan đến chức năng **Quản lý phòng nghỉ của Host** trong ứng dụng HotelStay.

---

## PHẦN 1: GIẢI THÍCH CHI TIẾT CÁC ĐOẠN GIAO DIỆN (FRONTEND - UI)

Giao diện quản lý phòng nghỉ của Host nằm trong file [HostRoomsView.vue](file:///c:/Users/USER/hotel-booking-fe/src/views/HostRoomsView.vue) và component [RoomCardGrid.vue](file:///c:/Users/USER/hotel-booking-fe/src/components/host/room-tab/RoomCardGrid.vue). Giao diện bao gồm các khối chính sau:

### 1.1. Khối Sidebar & Top Header (Bảng Điều Hướng & Thanh Trực Quan)
- **Vị trí:** [HostRoomsView.vue](file:///c:/Users/USER/hotel-booking-fe/src/views/HostRoomsView.vue#L4120-L4180) (CSS định dạng sidebar, các nút chọn tab, logo, nút Đăng xuất).
- **Chức năng:** Giúp Host điều hướng nhanh giữa các chức năng: Bảng điều khiển (Dashboard), Quản lý phòng (Rooms), Quản lý đơn đặt (Bookings), Quản lý doanh thu (Revenue), và Đồng bộ file Excel (Excel Data Sync).

### 1.2. Khối Danh Sách Phòng Dạng Lưới (Rooms Grid UI)
- **Vị trí:** [RoomCardGrid.vue](file:///c:/Users/USER/hotel-booking-fe/src/components/host/room-tab/RoomCardGrid.vue#L10-L48)
- **Chức năng:** Hiển thị danh sách các phòng nghỉ hiện có của Host.
- **Chi tiết giao diện:**
  - **Hình ảnh xem trước:** Lấy ảnh đầu tiên của phòng hoặc ảnh mặc định từ Unsplash *(dòng 13)*.
  - **Badge Trạng thái:** Hiển thị `PENDING` (Chờ duyệt) hoặc `ACTIVE` (Hoạt động) *(dòng 15 - 17)*.
  - **Thông tin cơ bản:** Tên phòng, địa chỉ bản đồ, số khách tối đa và điểm đánh giá trung bình *(dòng 20 - 25)*.
  - **Các nút chức năng:** Chỉnh sửa (`Edit`), Xem lịch đặt phòng (`Calendar`), Xóa phòng (`Delete`) *(dòng 41 - 45)*.

### 1.3. Khối Bản Đồ Định Vị (Map Geocoding UI)
- **Vị trí:** [HostRoomsView.vue](file:///c:/Users/USER/hotel-booking-fe/src/views/HostRoomsView.vue#L1359-L1385)
- **Chức năng:** Hiển thị bản đồ Leaflet Map dựa trên OpenStreetMap giúp định vị tọa độ địa lý (Lat, Lng) của phòng nghỉ.
- **Chi tiết giao diện:**
  - **Nút suggetion vị trí:** Nút "🔍 Cập nhật vị trí bản đồ theo địa chỉ mới" chỉ hiển thị khi đã nhập địa chỉ chữ. Khi nhấn, bản đồ sẽ tự động tìm kiếm vị trí và di chuyển tâm bản đồ tới vị trí đó *(dòng 1363 - 1371)*.
  - **Bản đồ trực quan (`#host-map`):** Nơi hiển thị bản đồ và điểm ghim (Marker) có thể kéo thả để cập nhật tọa độ *(dòng 1374)*.
  - **Hiển thị tọa độ:** Ô hiển thị giá trị Vĩ độ (Lat) và Kinh độ (Lng) cập nhật thời gian thực dạng số thập phân *(dòng 1381 - 1384)*.

---

## PHẦN 2: XỬ LÝ CHỨC NĂNG Ở FRONTEND (FE LOGIC)

Toàn bộ các logic xử lý nghiệp vụ, gọi API và lắng nghe sự kiện trên bản đồ được lập trình ở phần `<script setup>` trong file [HostRoomsView.vue](file:///c:/Users/USER/hotel-booking-fe/src/views/HostRoomsView.vue):

### 2.1. Đọc Danh Sách Phòng (READ)
- **Mục đích:** Tải toàn bộ danh sách phòng của Host đang đăng nhập từ API backend.
- **Mã nguồn:**
```javascript
// // ĐỌC DANH SÁCH PHÒNG
const fetchRooms = async () => {
  try {
    const res = await axios.get('/rooms/host')
    rooms.value = res.data
  } catch (err) {
    console.error('Lỗi lấy danh sách phòng:', err)
  }
}
```

### 2.2. Tìm Vị Trí Theo Địa Chỉ Chữ (GEOCODING)
- **Mục đích:** Sử dụng công cụ Nominatim của OpenStreetMap để chuyển đổi địa chỉ thành tọa độ Lat/Lng và cập nhật lên bản đồ.
- **Mã nguồn (Dòng 2772 - 2804):**
```javascript
// // ĐỊNH VỊ BẢN ĐỒ (GEOCODING)
const suggestLocationByAddress = async () => {
  if (!roomForm.value.address) return
  geocodingLoading.value = true
  try {
    // Ghép địa chỉ và thành phố để kết quả tìm kiếm chính xác hơn
    const query = `${roomForm.value.address}, ${roomForm.value.city || ''}`
    const res = await axios.get(`https://nominatim.openstreetmap.org/search`, {
      params: {
        q: query,
        format: 'json',
        limit: 1 // Chỉ lấy kết quả có độ khớp cao nhất
      }
    })
    if (res.data && res.data.length > 0) {
      const first = res.data[0]
      const lat = parseFloat(first.lat)
      const lng = parseFloat(first.lon)
      
      // Gán tọa độ mới vào form
      roomForm.value.latitude = lat
      roomForm.value.longitude = lng
      
      // Di chuyển ghim (marker) và tâm bản đồ tới vị trí mới tìm thấy
      if (leafletMap && mapMarker) {
        const latLng = [lat, lng]
        mapMarker.setLatLng(latLng)
        leafletMap.setView(latLng, 16) // Zoom cận cảnh mức độ 16
      }
    } else {
      alert(locale.value === 'vi' ? 'Không tìm thấy vị trí tương ứng với địa chỉ này.' : 'Could not find location for this address.')
    }
  } catch (err) {
    console.error('Geocoding error:', err)
  } finally {
    geocodingLoading.value = false
  }
}
```

### 2.3. Lắng nghe Sự kiện Kéo Thả Marker và Click Bản Đồ (MAP INTERACTION)
- **Mục đích:** Khi Host click vào bản đồ hoặc kéo thả ghim, FE tự động cập nhật lại tọa độ Lat/Lng trong form.
- **Mã nguồn (Dòng 2750 - 2761):**
```javascript
// // CẬP NHẬT TỌA ĐỘ KHI KÉO THẢ GHIM
mapMarker.on('dragend', () => {
  const latLng = mapMarker.getLatLng()
  roomForm.value.latitude = latLng.lat
  roomForm.value.longitude = latLng.lng
})

// // CẬP NHẬT TỌA ĐỘ KHI CLICK LÊN BẢN ĐỒ
leafletMap.on('click', (e) => {
  const latLng = e.latlng
  mapMarker.setLatLng(latLng)
  roomForm.value.latitude = latLng.lat
  roomForm.value.longitude = latLng.lng
})
```

### 2.4. Lưu Thông Tin Phòng (CREATE / UPDATE)
- **Mục đích:** Gửi dữ liệu phòng mới hoặc thông tin chỉnh sửa lên backend.
- **Mã nguồn (Dòng 2807+):**
```javascript
// // LƯU PHÒNG NGHỈ (CREATE / UPDATE)
const saveRoom = async () => {
  // Logic kiểm tra ảnh
  if (!isEditMode.value && selectedNewFiles.value.length === 0) {
    toastStore.warning('Vui lòng chọn ít nhất một hình ảnh cho phòng nghỉ.')
    return
  }
  
  try {
    let savedRoomId;
    if (isEditMode.value) {
      // 1. Nếu ở chế độ Edit, gọi API PUT để CẬP NHẬT
      const res = await axios.put(`/rooms/${roomForm.value.id}`, roomForm.value)
      savedRoomId = res.data.id
    } else {
      // 2. Nếu ở chế độ thêm mới, gọi API POST để THÊM MỚI
      const res = await axios.post('/rooms', roomForm.value)
      savedRoomId = res.data.id
    }
    
    // Gửi ảnh mới lên (nếu có)
    if (selectedNewFiles.value.length > 0) {
      await uploadRoomImages(savedRoomId)
    }
    
    toastStore.success(isEditMode.value ? 'Cập nhật phòng thành công!' : 'Tạo phòng mới thành công! Chờ Admin duyệt.')
    closeModal()
    fetchRooms() // Tải lại danh sách phòng mới
  } catch (err) {
    toastStore.error(err.response?.data?.message || 'Có lỗi xảy ra!')
  }
}
```

---

## PHẦN 3: XỬ LÝ CHỨC NĂNG Ở BACKEND (BE LOGIC)

Phần Backend sử dụng kiến trúc Spring Boot: Controller tiếp nhận request, Service thực thi logic nghiệp vụ và Repository thao tác với Database.

### 3.1. REST Controller: [RoomController.java](file:///d:/DATN/hotel-booking/src/main/java/com/hotelbooking/controller/RoomController.java)

Lớp Controller chịu trách nhiệm định nghĩa các Endpoint API tiếp nhận request từ Frontend:

```java
@RestController
@RequestMapping("/api/rooms")
@RequiredArgsConstructor
public class RoomController {

    private final RoomService roomService;

    // // TÌM KIẾM / ĐỌC DANH SÁCH (Tìm kiếm cho Khách hàng ở Trang chủ)
    @GetMapping
    public ResponseEntity<Page<RoomResponse>> searchRooms(...) {
        return ResponseEntity.ok(roomService.searchRooms(...));
    }

    // // TÌM KIẾM / ĐỌC DANH SÁCH (Lấy danh sách phòng thuộc quyền sở hữu của Host đăng nhập)
    @GetMapping("/host")
    @PreAuthorize("hasRole('HOST') or hasRole('ADMIN')")
    public ResponseEntity<List<RoomResponse>> getMyRooms() {
        return ResponseEntity.ok(roomService.getMyRooms());
    }

    // // THÊM MỚI PHÒNG NGHỈ
    @PostMapping
    @PreAuthorize("hasRole('HOST') or hasRole('ADMIN')")
    public ResponseEntity<RoomResponse> create(@Valid @RequestBody RoomRequest request) {
        return ResponseEntity.ok(roomService.createRoom(request));
    }

    // // CẬP NHẬT PHÒNG NGHỈ
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('HOST') or hasRole('ADMIN')")
    public ResponseEntity<RoomResponse> update(@PathVariable Long id, @Valid @RequestBody RoomRequest request) {
        return ResponseEntity.ok(roomService.updateRoom(id, request));
    }

    // // XÓA PHÒNG NGHỈ
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('HOST') or hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        roomService.deleteRoom(id);
        return ResponseEntity.noContent().build();
    }
}
```

### 3.2. Service Logic: [RoomService.java](file:///d:/DATN/hotel-booking/src/main/java/com/hotelbooking/service/RoomService.java)

Lớp Service chứa các logic nghiệp vụ kiểm tra điều kiện dữ liệu trước khi lưu vào Database:

#### A. Hàm Đọc Danh Sách Phòng của Host (Dòng 49 - 63)
```java
// // TÌM KIẾM / ĐỌC DANH SÁCH PHÒNG CỦA HOST
public List<RoomResponse> getMyRooms() {
    User host = getCurrentUser(); // Lấy thông tin Host từ JWT Token

    // Tìm kiếm phòng và tính điểm đánh giá trung bình cùng lúc bằng 1 câu truy vấn JOIN
    List<Object[]> rows = roomRepository.findByHostIdWithRating(host.getId());
    
    // Gom nhóm tất cả hình ảnh của phòng để tránh lỗi N+1 Query
    Map<Long, List<String>> imageMap = buildImageMap(rows.stream().map(r -> (Room) r[0]).toList());

    return rows.stream()
            .map(row -> {
                Room room = (Room) row[0];
                Double avgRating = row[1] != null ? ((Number) row[1]).doubleValue() : 0.0;
                List<String> imageUrls = imageMap.getOrDefault(room.getId(), List.of());
                return toResponseWithRating(room, avgRating, imageUrls);
            })
            .toList();
}
```

#### B. Hàm Thêm Mới Phòng (Dòng 65 - 91)
```java
// // THÊM MỚI PHÒNG NGHỈ
public RoomResponse createRoom(RoomRequest request) {
    User host = getCurrentUser();

    // Tìm kiếm hoặc tạo mới Loại phòng (RoomType)
    RoomType roomType = roomTypeRepository.findByNameIgnoreCase(request.getRoomTypeName())
            .orElseGet(() -> {
                RoomType newType = new RoomType();
                newType.setName(request.getRoomTypeName());
                return roomTypeRepository.save(newType);
            });

    // Xây dựng đối tượng thực thể Room
    Room room = Room.builder()
            .host(host)
            .roomType(roomType)
            .name(request.getName())
            .description(request.getDescription())
            .address(request.getAddress())
            .city(request.getCity())
            .pricePerNight(request.getPricePerNight())
            .maxGuests(request.getMaxGuests())
            .amenities(request.getAmenities())
            .status(Room.Status.PENDING) // Phòng mới tạo mặc định ở trạng thái Chờ duyệt
            .build();

    // Kiểm tra tính hợp lệ của tọa độ bản đồ & khoảng cách an toàn (Dưới 20m)
    validateAndSetCoordinates(room, request.getLatitude(), request.getLongitude(), host.getId(), null);

    return toResponse(roomRepository.save(room));
}
```

#### C. Hàm Cập Nhật Phòng (Dòng 161 - 189)
```java
// // CẬP NHẬT PHÒNG NGHỈ
public RoomResponse updateRoom(Long id, RoomRequest request) {
    User host = getCurrentUser();
    Room room = roomRepository.findByIdWithDetails(id)
            .orElseThrow(() -> new RuntimeException("Room not found"));

    // Kiểm tra quyền: Chỉ chủ sở hữu phòng (Host của phòng này) mới có quyền cập nhật
    if (!room.getHost().getId().equals(host.getId())) {
        throw new RuntimeException("Không có quyền sửa phòng này");
    }

    // Lấy thông tin RoomType mới/cũ
    RoomType roomType = roomTypeRepository.findByNameIgnoreCase(request.getRoomTypeName())
            .orElseGet(() -> {
                RoomType newType = new RoomType();
                newType.setName(request.getRoomTypeName());
                return roomTypeRepository.save(newType);
            });

    // Cập nhật thông tin
    room.setName(request.getName());
    room.setDescription(request.getDescription());
    room.setAddress(request.getAddress());
    room.setCity(request.getCity());
    room.setPricePerNight(request.getPricePerNight());
    room.setMaxGuests(request.getMaxGuests());
    room.setRoomType(roomType);
    room.setAmenities(request.getAmenities());

    // Cập nhật và kiểm tra lại vị trí tọa độ bản đồ
    validateAndSetCoordinates(room, request.getLatitude(), request.getLongitude(), host.getId(), room.getId());

    return toResponse(roomRepository.save(room));
}
```

#### D. Hàm Xóa Phòng (Dòng 191 - 202)
```java
// // XÓA PHÒNG NGHỈ
public void deleteRoom(Long id) {
    User host = getCurrentUser();
    Room room = roomRepository.findByIdWithDetails(id)
            .orElseThrow(() -> new RuntimeException("Room not found"));

    // Chỉ chủ phòng mới được phép xóa
    if (!room.getHost().getId().equals(host.getId())) {
        throw new RuntimeException("Không có quyền xóa phòng này");
    }

    roomRepository.delete(room);
}
```

#### E. Thuật Toán Kiểm Tra Vị Trí & Bounding Box Khoảng Cách (Dòng 252 - 309)
- **Mục đích:** Tránh trường hợp một Host tạo quá nhiều phòng ảo trùng tọa độ hoặc quá gần nhau (dưới 20m). Sử dụng thuật toán **Haversine** để tính khoảng cách theo đường cong Trái Đất.
- **Mã nguồn:**
```java
// // KIỂM TRA TỌA ĐỘ VÀ KHOẢNG CÁCH
private void validateAndSetCoordinates(Room room, BigDecimal lat, BigDecimal lng, Long hostId, Long excludeRoomId) {
    // 1. Kiểm tra tọa độ trống
    if (lat == null || lng == null) {
        throw new RuntimeException("Tọa độ của phòng nghỉ không được để trống.");
    }

    // 2. Kiểm tra giới hạn tọa độ địa lý thực tế
    if (lat.compareTo(new BigDecimal("-90")) < 0 || lat.compareTo(new BigDecimal("90")) > 0) {
        throw new RuntimeException("Tọa độ không hợp lệ.");
    }
    if (lng.compareTo(new BigDecimal("-180")) < 0 || lng.compareTo(new BigDecimal("180")) > 0) {
        throw new RuntimeException("Tọa độ không hợp lệ.");
    }

    // Làm tròn tọa độ tới tối đa 8 chữ số thập phân
    BigDecimal roundedLat = lat.setScale(8, java.math.RoundingMode.HALF_UP);
    BigDecimal roundedLng = lng.setScale(8, java.math.RoundingMode.HALF_UP);
    room.setLatitude(roundedLat);
    room.setLongitude(roundedLng);

    // 3. Sử dụng Bounding Box hạn chế vùng tìm kiếm bán kính khoảng 50m quanh phòng mới để tối ưu hiệu năng truy vấn
    BigDecimal delta = new BigDecimal("0.0005");
    BigDecimal minLat = roundedLat.subtract(delta);
    BigDecimal maxLat = roundedLat.add(delta);
    BigDecimal minLng = roundedLng.subtract(delta);
    BigDecimal maxLng = roundedLng.add(delta);

    // Lấy toàn bộ phòng của host này nằm trong khu vực bounding box
    List<Room> nearbyRooms = roomRepository.findRoomsByHostInBoundingBox(hostId, minLat, maxLat, minLng, maxLng);

    double lat1 = roundedLat.doubleValue();
    double lon1 = roundedLng.doubleValue();

    for (Room r : nearbyRooms) {
        // Bỏ qua chính nó khi sửa phòng
        if (excludeRoomId != null && r.getId().equals(excludeRoomId)) {
            continue;
        }
        if (r.getLatitude() == null || r.getLongitude() == null) {
            continue;
        }
        double lat2 = r.getLatitude().doubleValue();
        double lon2 = r.getLongitude().doubleValue();

        // Thuật toán Haversine tính khoảng cách theo mét
        double earthRadius = 6371000; // Bán kính trái đất bằng mét
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = earthRadius * c;

        // Nếu khoảng cách giữa hai phòng dưới 20 mét thì báo lỗi
        if (distance < 20.0) {
            throw new RuntimeException("Đã tồn tại phòng khác trong phạm vi dưới 20 mét thuộc quyền sở hữu của bạn. Vui lòng kiểm tra lại vị trí hoặc liên hệ quản trị viên nếu đây là trường hợp đặc biệt.");
        }
    }
}
```
