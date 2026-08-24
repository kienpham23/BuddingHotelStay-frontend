/**
 * SCRIPT KIỂM THỬ KHÓA BỊ QUAN CHỐNG DOUBLE BOOKING (CONCURRENT BOOKING TEST)
 * 
 * Hướng dẫn sử dụng:
 * 1. Đăng nhập vào ứng dụng Web của bạn bằng tài khoản Khách hàng (Customer).
 * 2. Lấy mã JWT Token từ tab Network hoặc Application (localStorage: token).
 * 3. Thay thế TOKEN, ROOM_ID, CHECK_IN, CHECK_OUT bên dưới.
 * 4. Chạy script này bằng lệnh: node scratch_lock_test.js
 */

import http from 'http';

// --- THAY THẾ THÔNG TIN CỦA BẠN TẠI ĐÂY ---
const TOKEN = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJraWVuMDkwNTIzQGdtYWlsLmNvbSIsImlhdCI6MTc4NzQxOTYxMSwiZXhwIjoxNzg3NTA2MDExfQ.MkDCD5uSfoaR_DPN306e_-8C2fcHNHXFBkFHynenLOqtkWIRwUfacsBsVbHhDappaUR5QH8_t2vDjGHLLjOv6w';
const ROOM_ID = 4; // Thay bằng ID phòng trống muốn test
const CHECK_IN = '2026-09-05'; // Chọn ngày trống
const CHECK_OUT = '2026-09-06';
// ------------------------------------------

const makeRequest = (reqId) => {
  return new Promise((resolve) => {
    const postData = JSON.stringify({
      roomId: ROOM_ID,
      checkIn: CHECK_IN,
      checkOut: CHECK_OUT,
      numGuests: 2,
      note: 'Test concurrent booking request #' + reqId,
      paymentMethod: 'CASH',
      promoCode: null
    });

    const options = {
      hostname: 'localhost',
      port: 8088,
      path: '/api/bookings',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
        'Authorization': `Bearer ${TOKEN}`
      }
    };

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => { body += chunk; });
      res.on('end', () => {
        resolve({
          reqId,
          statusCode: res.statusCode,
          body: body.trim()
        });
      });
    });

    req.on('error', (err) => {
      resolve({
        reqId,
        statusCode: 0,
        body: 'Connection Error: ' + err.message
      });
    });

    req.write(postData);
    req.end();
  });
};

const runTest = async () => {
  if (TOKEN === 'DÁN_TOKEN_JWT_CỦA_BẠN_VÀO_ĐÂY') {
    console.error('❌ Vui lòng mở file và dán JWT Token của bạn vào biến TOKEN trước khi chạy.');
    process.exit(1);
  }

  const concurrentRequests = 100; // Gửi 100 yêu cầu cùng lúc
  console.log(`🚀 Bắt đầu gửi đồng thời ${concurrentRequests} yêu cầu đặt phòng (Room ID: ${ROOM_ID}) từ ngày ${CHECK_IN} đến ${CHECK_OUT}...`);

  // Sử dụng Promise.all để gửi tất cả request tại cùng một thời điểm
  const promises = Array.from({ length: concurrentRequests }, (_, i) => makeRequest(i + 1));
  const results = await Promise.all(promises);

  console.log('\n--- KẾT QUẢ KIỂM THỬ ---');
  let successCount = 0;
  let failCount = 0;

  results.forEach((res) => {
    const isSuccess = res.statusCode === 200 || res.statusCode === 201;
    if (isSuccess) {
      successCount++;
      console.log(`✅ Request #${res.reqId}: THÀNH CÔNG (Status: ${res.statusCode}) -> Đã tạo đơn hàng.`);
    } else {
      failCount++;
      console.log(`❌ Request #${res.reqId}: THẤT BẠI (Status: ${res.statusCode}) -> Lỗi: ${res.body}`);
    }
  });

  console.log('\n========================');
  console.log(`Tổng kết: ${successCount} thành công, ${failCount} thất bại.`);

  if (successCount === 1) {
    console.log('\n🎉 KẾT LUẬN: KHÓA BỊ QUAN (PESSIMISTIC LOCK) HOẠT ĐỘNG HOÀN HẢO!');
    console.log(`Chỉ có duy nhất 1 yêu cầu đặt phòng thành công, ${concurrentRequests - 1} yêu cầu còn lại bị chặn và báo lỗi trùng lịch đặt phòng một cách an toàn.`);
  } else if (successCount > 1) {
    console.log('\n⚠️ CẢNH BÁO: PHÁT HIỆN LỖI DOUBLE BOOKING!');
    console.log(`Có ${successCount} đơn hàng cùng được tạo thành công cho một phòng nghỉ tại cùng một thời điểm. Bạn cần kiểm tra lại cơ chế @Lock ở backend.`);
  } else {
    console.log('\nLưu ý: Tất cả các yêu cầu đều thất bại. Hãy kiểm tra xem token của bạn có hợp lệ không và phòng nghỉ có sẵn sàng cho ngày này không.');
  }
};

runTest();
