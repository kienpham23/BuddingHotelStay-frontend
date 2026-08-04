/**
 * Script tạo file Excel mẫu dữ liệu import phòng (room_import_sample.xlsx)
 * Chạy: node generate_room_import.js
 * Yêu cầu: npm install xlsx
 */

const XLSX = require('xlsx')

// ==============================
// DỮ LIỆU MẪU 10 PHÒNG
// ==============================
const sampleRooms = [
  {
    name: 'Phòng đơn view biển Đà Nẵng',
    roomTypeName: 'Phòng đơn',
    city: 'Đà Nẵng',
    address: '12 Võ Nguyên Giáp, Mỹ An, Ngũ Hành Sơn',
    pricePerNight: 850000,
    maxGuests: 2,
    description: 'Phòng đơn thoáng mát, view biển trực tiếp, đầy đủ tiện nghi cơ bản. Gần biển Mỹ Khê chỉ 50m.',
    amenities: 'WiFi miễn phí, Điều hòa, TV màn hình phẳng, Tủ lạnh, Bồn tắm',
    imageUrl1: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=800',
    imageUrl3: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800'
  },
  {
    name: 'Phòng Deluxe Biển Mỹ Khê',
    roomTypeName: 'Deluxe',
    city: 'Đà Nẵng',
    address: '45 Trường Sa, Hòa Hải, Ngũ Hành Sơn',
    pricePerNight: 1500000,
    maxGuests: 3,
    description: 'Phòng Deluxe sang trọng với ban công nhìn thẳng ra biển Mỹ Khê. Thiết kế hiện đại, đồ nội thất cao cấp.',
    amenities: 'WiFi miễn phí, Điều hòa, TV 50 inch, Tủ lạnh, Bồn tắm, Ban công view biển, Minibar',
    imageUrl1: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
    imageUrl3: ''
  },
  {
    name: 'Nhà nguyên căn Hội An phố cổ',
    roomTypeName: 'Nhà nguyên căn',
    city: 'Hội An',
    address: '78 Nguyễn Thái Học, Phường Minh An',
    pricePerNight: 2200000,
    maxGuests: 6,
    description: 'Nhà nguyên căn 3 phòng ngủ nằm ngay phố cổ Hội An, thiết kế truyền thống Việt Nam kết hợp tiện nghi hiện đại.',
    amenities: 'WiFi miễn phí, Điều hòa, Bếp đầy đủ, Máy giặt, Sân vườn riêng, Chỗ đỗ xe, TV',
    imageUrl1: 'https://images.unsplash.com/photo-1549294413-26f195200c16?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=800',
    imageUrl3: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800'
  },
  {
    name: 'Căn hộ studio Hà Nội trung tâm',
    roomTypeName: 'Standard',
    city: 'Hà Nội',
    address: '15 Lý Thường Kiệt, Hoàn Kiếm',
    pricePerNight: 700000,
    maxGuests: 2,
    description: 'Studio hiện đại, sạch sẽ, ngay trung tâm Hà Nội. Gần hồ Hoàn Kiếm, phố cổ và nhiều nhà hàng nổi tiếng.',
    amenities: 'WiFi miễn phí, Điều hòa, TV, Tủ lạnh, Ấm đun nước, Bàn làm việc',
    imageUrl1: 'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800',
    imageUrl2: '',
    imageUrl3: ''
  },
  {
    name: 'Villa ven hồ Đà Lạt',
    roomTypeName: 'Villa',
    city: 'Đà Lạt',
    address: '123 Hồ Xuân Hương, Phường 1',
    pricePerNight: 3500000,
    maxGuests: 8,
    description: 'Villa 4 phòng ngủ view hồ Xuân Hương tuyệt đẹp. Có hồ bơi riêng, sân vườn rộng, phù hợp cho gia đình hoặc nhóm bạn.',
    amenities: 'WiFi miễn phí, Điều hòa, Hồ bơi riêng, Bếp đầy đủ, BBQ, Chỗ đỗ xe, Máy giặt, Smart TV',
    imageUrl1: 'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1416331108676-a22ccb276e35?w=800',
    imageUrl3: 'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=800'
  },
  {
    name: 'Phòng Family Nha Trang',
    roomTypeName: 'Family Room',
    city: 'Nha Trang',
    address: '88 Trần Phú, Vĩnh Nguyên',
    pricePerNight: 1800000,
    maxGuests: 5,
    description: 'Phòng gia đình rộng rãi, 2 giường đôi + 1 giường đơn, nhìn ra biển Nha Trang. Tầng 8, view tuyệt đẹp.',
    amenities: 'WiFi miễn phí, Điều hòa, TV, Tủ lạnh, Minibar, View biển, Ban công',
    imageUrl1: 'https://images.unsplash.com/photo-1591088398332-8596b4c8c4d2?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
    imageUrl3: ''
  },
  {
    name: 'Penthouse Sài Gòn Sky View',
    roomTypeName: 'Penthouse',
    city: 'Hồ Chí Minh',
    address: '1 Lê Duẩn, Bến Nghé, Quận 1',
    pricePerNight: 5500000,
    maxGuests: 4,
    description: 'Penthouse tầng thượng cao cấp nhất, view toàn cảnh TP.HCM. 2 phòng ngủ, phòng khách rộng, bếp riêng.',
    amenities: 'WiFi tốc độ cao, Điều hòa trung tâm, Smart TV 65 inch, Bếp đầy đủ, Máy giặt sấy, Sân thượng riêng, Hầm để xe',
    imageUrl1: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
    imageUrl3: 'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800'
  },
  {
    name: 'Nhà nguyên căn Ngô Yên Tĩnh HN',
    roomTypeName: 'Nhà nguyên căn',
    city: 'Hà Nội',
    address: '29 Ngô Yên Tĩnh, Cầu Giấy',
    pricePerNight: 2900000,
    maxGuests: 6,
    description: 'Nhà nguyên căn 4 tầng, 3 phòng ngủ, gần Keangnam và nhiều trung tâm thương mại. Thiết kế hiện đại, mới xây.',
    amenities: 'WiFi miễn phí, Điều hòa, Bếp đầy đủ, Máy giặt, Chỗ đỗ xe, Smart TV, Camera an ninh',
    imageUrl1: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    imageUrl3: ''
  },
  {
    name: 'Phòng Deluxe Hồ Chí Minh Q1',
    roomTypeName: 'Deluxe',
    city: 'Hồ Chí Minh',
    address: '200 Nguyễn Thị Minh Khai, Quận 3',
    pricePerNight: 1200000,
    maxGuests: 2,
    description: 'Phòng Deluxe tiện nghi tại trung tâm Quận 3, gần nhiều nhà hàng, café và điểm vui chơi. Tầng cao thoáng mát.',
    amenities: 'WiFi miễn phí, Điều hòa, TV màn hình phẳng, Tủ lạnh, Bồn tắm, Dịch vụ dọn phòng hàng ngày',
    imageUrl1: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800',
    imageUrl2: '',
    imageUrl3: ''
  },
  {
    name: 'Căn hộ Standard Đà Lạt ngàn hoa',
    roomTypeName: 'Standard',
    city: 'Đà Lạt',
    address: '56 Phan Đình Phùng, Phường 2',
    pricePerNight: 650000,
    maxGuests: 2,
    description: 'Căn hộ nhỏ gọn, ấm áp giữa thành phố ngàn hoa. Trang bị lò sưởi, chăn ấm, phù hợp mùa lạnh Đà Lạt.',
    amenities: 'WiFi miễn phí, Điều hòa + Lò sưởi, TV, Tủ lạnh, Ấm đun nước, Chăn ấm',
    imageUrl1: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
    imageUrl2: 'https://images.unsplash.com/photo-1587985064135-0366536eab42?w=800',
    imageUrl3: ''
  }
]

// ==============================
// TẠO WORKBOOK
// ==============================
const wb = XLSX.utils.book_new()

// ---- SHEET 1: Dữ liệu mẫu ----
const headerLabels = [
  'Tên phòng *',
  'Loại phòng *',
  'Thành phố *',
  'Địa chỉ *',
  'Giá/đêm (VNĐ) *',
  'Sức chứa tối đa *',
  'Mô tả phòng',
  'Tiện ích (cách nhau bởi dấu phẩy)',
  'URL Ảnh 1',
  'URL Ảnh 2',
  'URL Ảnh 3'
]

const rows = [
  headerLabels,
  ...sampleRooms.map(r => [
    r.name,
    r.roomTypeName,
    r.city,
    r.address,
    r.pricePerNight,
    r.maxGuests,
    r.description,
    r.amenities,
    r.imageUrl1,
    r.imageUrl2,
    r.imageUrl3
  ])
]

const ws = XLSX.utils.aoa_to_sheet(rows)

ws['!cols'] = [
  { wch: 35 }, // name
  { wch: 18 }, // roomTypeName
  { wch: 15 }, // city
  { wch: 45 }, // address
  { wch: 18 }, // pricePerNight
  { wch: 14 }, // maxGuests
  { wch: 55 }, // description
  { wch: 50 }, // amenities
  { wch: 65 }, // imageUrl1
  { wch: 65 }, // imageUrl2
  { wch: 65 }  // imageUrl3
]

XLSX.utils.book_append_sheet(wb, ws, 'Danh sách phòng mẫu')

// ---- SHEET 2: Hướng dẫn ----
const guideRows = [
  ['📋 HƯỚNG DẪN NHẬP DỮ LIỆU PHÒNG NGHỈ (CÓ ẢNH)'],
  [''],
  ['Trường', 'Bắt buộc', 'Mô tả', 'Ví dụ'],
  ['name', 'Có', 'Tên phòng nghỉ (tối đa 200 ký tự)', 'Phòng đơn view biển Đà Nẵng'],
  ['roomTypeName', 'Có', 'Loại phòng: Phòng đơn | Deluxe | Family Room | Villa | Standard | Penthouse | Nhà nguyên căn', 'Deluxe'],
  ['city', 'Có', 'Thành phố: Đà Nẵng | Hà Nội | Hồ Chí Minh | Hội An | Nha Trang | Đà Lạt | Huế | Cần Thơ', 'Đà Nẵng'],
  ['address', 'Có', 'Địa chỉ đầy đủ (số nhà, đường, phường/xã, quận/huyện)', '12 Võ Nguyên Giáp, Mỹ An, Ngũ Hành Sơn'],
  ['pricePerNight', 'Có', 'Giá mỗi đêm tính bằng VNĐ (số nguyên, tối thiểu 100000)', '850000'],
  ['maxGuests', 'Có', 'Sức chứa tối đa (số nguyên từ 1-20)', '2'],
  ['description', 'Không', 'Mô tả chi tiết về phòng (tối đa 2000 ký tự)', 'Phòng đơn thoáng mát, view biển...'],
  ['amenities', 'Không', 'Danh sách tiện ích, cách nhau bởi dấu phẩy', 'WiFi miễn phí, Điều hòa, TV, Tủ lạnh'],
  ['imageUrl1', 'Không', 'URL ảnh thứ 1 — đây sẽ là ảnh đại diện (ảnh chính) của phòng', 'https://example.com/room1.jpg'],
  ['imageUrl2', 'Không', 'URL ảnh thứ 2', 'https://example.com/room2.jpg'],
  ['imageUrl3', 'Không', 'URL ảnh thứ 3', 'https://example.com/room3.jpg'],
  [''],
  ['📸 HƯỚNG DẪN URL ẢNH:'],
  ['- URL ảnh phải là đường dẫn công khai (public), có thể truy cập trực tiếp từ Internet.'],
  ['- Hỗ trợ: Cloudinary, Google Drive (link chia sẻ trực tiếp), Imgur, Unsplash, hosting cá nhân.'],
  ['- Định dạng ảnh hỗ trợ: .jpg, .jpeg, .png, .webp'],
  ['- Ảnh imageUrl1 sẽ được đặt làm ảnh đại diện (primary) cho phòng.'],
  ['- Nếu để trống ô URL ảnh, ảnh mặc định sẽ được dùng tạm.'],
  [''],
  ['⚠️ LƯU Ý CHUNG:'],
  ['- Dòng đầu tiên là tiêu đề cột, KHÔNG được xóa.'],
  ['- Các trường có dấu * là bắt buộc.'],
  ['- Sau khi import, phòng ở trạng thái CHỜ DUYỆT (PENDING) và cần Admin phê duyệt.'],
  ['- Mỗi lần import tối đa 50 phòng.'],
  ['- File phải định dạng .xlsx (Excel 2007 trở lên).']
]

const wsGuide = XLSX.utils.aoa_to_sheet(guideRows)
wsGuide['!cols'] = [
  { wch: 14 },
  { wch: 10 },
  { wch: 75 },
  { wch: 55 }
]
XLSX.utils.book_append_sheet(wb, wsGuide, 'Hướng dẫn')

// Xuất file
const outputPath = 'room_import_sample.xlsx'
XLSX.writeFile(wb, outputPath)
console.log(`✅ Đã tạo file: ${outputPath}`)
console.log(`   Cột dữ liệu: name, roomTypeName, city, address, pricePerNight, maxGuests, description, amenities, imageUrl1, imageUrl2, imageUrl3`)
console.log(`   Sheet 1: 10 phòng mẫu với URLs ảnh`)
console.log(`   Sheet 2: Hướng dẫn chi tiết`)
