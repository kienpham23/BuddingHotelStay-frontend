import fs from 'fs';

const controllerPath = 'D:\\DATN\\hotel-booking\\src\\main\\java\\com\\hotelbooking\\controller\\BookingController.java';
const servicePath = 'D:\\DATN\\hotel-booking\\src\\main\\java\\com\\hotelbooking\\service\\BookingService.java';

// 1. Chỉnh sửa BookingController.java
console.log('Đang sửa BookingController.java...');
let controllerContent = fs.readFileSync(controllerPath, 'utf8');

controllerContent = controllerContent.replace(
  /@PatchMapping\("\/\{id\}\/cancel"\)\s*@PreAuthorize\("hasRole\('CUSTOMER'\)"\)/g,
  `@PatchMapping("/{id}/cancel")\n    @PreAuthorize("hasRole('CUSTOMER') or hasRole('ADMIN')")`
);

fs.writeFileSync(controllerPath, controllerContent, 'utf8');
console.log('🎉 Sửa BookingController.java thành công!');

// 2. Chỉnh sửa BookingService.java
console.log('Đang sửa BookingService.java...');
let serviceContent = fs.readFileSync(servicePath, 'utf8');

// Bổ sung điều kiện loại trừ cho ADMIN trong kiểm tra chủ đơn đặt phòng bằng RegExp
serviceContent = serviceContent.replace(
  /if\s*\(\s*!booking\.getUser\(\)\.getId\(\)\.equals\(\s*customer\.getId\(\)\s*\)\s*\)\s*\{/g,
  `if (!booking.getUser().getId().equals(customer.getId()) && customer.getRole() != User.Role.ADMIN) {`
);

// Bổ sung điều kiện loại trừ cho ADMIN trong kiểm tra giới hạn 24h bằng RegExp
serviceContent = serviceContent.replace(
  /if\s*\(\s*booking\.getStatus\(\)\s*==\s*Booking\.Status\.CONFIRMED\s*\)\s*\{/g,
  `if (booking.getStatus() == Booking.Status.CONFIRMED && customer.getRole() != User.Role.ADMIN) {`
);

fs.writeFileSync(servicePath, serviceContent, 'utf8');
console.log('🎉 Sửa BookingService.java thành công!');
