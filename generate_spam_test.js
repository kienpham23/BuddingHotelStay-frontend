import fs from 'fs';
import { execSync } from 'child_process';

console.log('Đang kiểm tra thư viện xlsx...');
try {
  // Thử import xlsx
  await import('xlsx');
} catch (e) {
  console.log('Không tìm thấy thư viện xlsx. Đang cài đặt tạm thời...');
  execSync('npm install --no-save xlsx', { stdio: 'inherit' });
}

// Import xlsx sau khi đã chắc chắn được cài đặt
const XLSX = await import('xlsx');

// Tiêu đề các cột theo đúng thứ tự backend mong đợi:
// index 0: name
// index 1: city
// index 2: address
// index 3: roomTypeName
// index 4: pricePerNight
// index 5: maxGuests
const headers = [
  'name', 'city', 'address', 'roomTypeName',
  'pricePerNight', 'maxGuests', 'description', 'amenities',
  'imageUrl1', 'imageUrl2', 'imageUrl3',
  'latitude', 'longitude'
];

// Tạo dữ liệu mẫu
// Phòng B cách phòng A chỉ khoảng 1 mét (vĩ độ lệch 0.000009 độ)
// Khoảng cách này dưới 20m và sẽ kích hoạt lỗi chống spam của hệ thống khi host import
const data = [
  headers,
  [
    'Phòng A - Test Chống Spam', 
    'Hà Nội', 
    '12 Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội',
    'Standard', 
    1000000, 
    2, 
    'Phòng test chống spam - Tọa độ gốc',
    'WiFi, Điều hòa',
    '', '', '',
    '21.02851100', 
    '105.80481700'
  ],
  [
    'Phòng B - Trùng Tọa Độ (<20m)', 
    'Hà Nội', 
    '14 Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội',
    'Standard', 
    1200000, 
    2, 
    'Phòng test chống spam - Tọa độ rất gần phòng A (lệch khoảng 1m)',
    'WiFi, Điều hòa',
    '', '', '',
    '21.02852000', 
    '105.80481700'
  ]
];

// Tạo workbook và sheet
const wb = XLSX.utils.book_new();
const ws = XLSX.utils.aoa_to_sheet(data);

// Cấu hình chiều rộng cột cho đẹp
ws['!cols'] = [30, 15, 12, 40, 15, 12, 45, 25, 15, 15, 15, 15, 15].map(w => ({ wch: w }));

XLSX.utils.book_append_sheet(wb, ws, 'Danh sách phòng');

// Ghi ra file
const filename = 'spam_test_rooms_v2.xlsx';
XLSX.writeFile(wb, filename);

console.log(`\n🎉 Đã tạo thành công file test tại: c:\\Users\\USER\\hotel-booking-fe\\${filename}`);
console.log('Bạn có thể chọn file này trong chức năng "Nhập danh sách phòng từ Excel" ở trang quản lý của Host.');
console.log('Kết quả mong đợi: Phòng A được thêm/xác nhận thành công, nhưng Phòng B sẽ báo lỗi vĩ độ/kinh độ quá gần (< 20 mét).');
