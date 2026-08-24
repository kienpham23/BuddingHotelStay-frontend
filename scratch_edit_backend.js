import fs from 'fs';

const filePath = 'D:\\DATN\\hotel-booking\\src\\main\\java\\com\\hotelbooking\\service\\BookingService.java';

console.log('Đang đọc file BookingService.java...');
let content = fs.readFileSync(filePath, 'utf8');

// Thay thế @org.springframework.transaction.annotation.Transactional
// cho hàm createBooking và hostBlockDates thành phiên bản có isolation = READ_COMMITTED
console.log('Đang chỉnh sửa Transactional isolation...');

// Chỉnh sửa cho createBooking
content = content.replace(
  `    @org.springframework.transaction.annotation.Transactional\r\n    public BookingResponse createBooking`,
  `    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.READ_COMMITTED)\r\n    public BookingResponse createBooking`
);
content = content.replace(
  `    @org.springframework.transaction.annotation.Transactional\n    public BookingResponse createBooking`,
  `    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.READ_COMMITTED)\n    public BookingResponse createBooking`
);

// Chỉnh sửa cho hostBlockDates
content = content.replace(
  `    @org.springframework.transaction.annotation.Transactional\r\n    public BookingResponse hostBlockDates`,
  `    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.READ_COMMITTED)\r\n    public BookingResponse hostBlockDates`
);
content = content.replace(
  `    @org.springframework.transaction.annotation.Transactional\n    public BookingResponse hostBlockDates`,
  `    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.READ_COMMITTED)\n    public BookingResponse hostBlockDates`
);

fs.writeFileSync(filePath, content, 'utf8');
console.log('🎉 Đã chỉnh sửa thành công BookingService.java!');
