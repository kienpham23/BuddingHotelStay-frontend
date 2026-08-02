-- SQL Script: Thêm dữ liệu giả lập cho Users (Khách hàng), Bookings (Đã thanh toán), Payments và Reviews (từ xấu đến tốt)
-- Database Dialect: MySQL / MariaDB (hoặc tương thích PostgreSQL)

-- 1. THÊM NGƯỜI DÙNG MỚI (Vai trò: CUSTOMER)
-- Password hash tương ứng với mật khẩu: 'password123' (sử dụng bcrypt hash chuẩn)
INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone`, `role`, `avatar_url`, `is_active`, `commission_rate`, `created_at`, `updated_at`) VALUES
(1001, 'nguyen.an@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Nguyễn Văn An', '0912345678', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=An', 1, NULL, NOW(), NOW()),
(1002, 'tran.binh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Trần Thị Bình', '0923456789', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Binh', 1, NULL, NOW(), NOW()),
(1003, 'le.cuong@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Lê Hoàng Cường', '0934567890', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Cuong', 1, NULL, NOW(), NOW()),
(1004, 'pham.dung@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Phạm Hồng Dung', '0945678901', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Dung', 1, NULL, NOW(), NOW()),
(1005, 'hoang.em@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Hoàng Giang Em', '0956789012', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Em', 1, NULL, NOW(), NOW()),
(1006, 'vu.phong@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Vũ Lâm Phong', '0967890123', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Phong', 1, NULL, NOW(), NOW()),
(1007, 'ngo.huong@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Ngô Mai Hương', '0978901234', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Huong', 1, NULL, NOW(), NOW()),
(1008, 'do.khanh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Đỗ Quốc Khánh', '0989012345', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Khanh', 1, NULL, NOW(), NOW()),
(1009, 'bui.lan@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Bùi Thị Lan', '0990123456', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Lan', 1, NULL, NOW(), NOW()),
(1010, 'dang.minh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Đặng Nhật Minh', '0901234567', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Minh', 1, NULL, NOW(), NOW());

-- 2. THÊM ĐƠN ĐẶT PHÒNG (Bookings)
-- Trạng thái: 'COMPLETED' (Đã hoàn thành lưu trú) hoặc 'CONFIRMED' (Đã xác nhận thanh toán thành công)
-- Giả sử hệ thống đang vận hành các phòng có ID từ 1 đến 6
INSERT INTO `bookings` (`id`, `user_id`, `room_id`, `check_in`, `check_out`, `num_guests`, `total_price`, `status`, `note`, `commission_amount`, `host_earning`, `is_commission_billed`, `discount_amount`, `original_price`, `promo_code`, `created_at`, `updated_at`) VALUES
-- Phòng ID 1
(5001, 1001, 1, '2026-07-01', '2026-07-03', 2, 2400000.00, 'COMPLETED', 'Không có yêu cầu gì đặc biệt.', 240000.00, 2160000.00, 0, 0.00, 2400000.00, NULL, NOW(), NOW()),
(5002, 1002, 1, '2026-07-05', '2026-07-06', 1, 1200000.00, 'COMPLETED', 'Cần phòng yên tĩnh.', 120000.00, 1080000.00, 0, 100000.00, 1300000.00, 'DISCOUNT100', NOW(), NOW()),
-- Phòng ID 2
(5003, 1003, 2, '2026-07-10', '2026-07-14', 3, 6000000.00, 'COMPLETED', 'Check-in muộn lúc 8h tối.', 600000.00, 5400000.00, 0, 0.00, 6000000.00, NULL, NOW(), NOW()),
(5004, 1004, 2, '2026-07-16', '2026-07-18', 2, 3000000.00, 'COMPLETED', NULL, 300000.00, 2700000.00, 0, 0.00, 3000000.00, NULL, NOW(), NOW()),
-- Phòng ID 3
(5005, 1005, 3, '2026-07-02', '2026-07-05', 2, 4500000.00, 'COMPLETED', 'Yêu cầu phòng hướng biển.', 450000.00, 4050000.00, 0, 0.00, 4500000.00, NULL, NOW(), NOW()),
(5006, 1006, 3, '2026-07-08', '2026-07-10', 4, 3000000.00, 'COMPLETED', 'Cần thêm 1 chăn ấm.', 300000.00, 2700000.00, 0, 200000.00, 3200000.00, 'PROMO200', NOW(), NOW()),
-- Phòng ID 4
(5007, 1007, 4, '2026-07-12', '2026-07-15', 2, 5400000.00, 'COMPLETED', NULL, 540000.00, 4860000.00, 0, 0.00, 5400000.00, NULL, NOW(), NOW()),
(5008, 1008, 4, '2026-07-20', '2026-07-21', 1, 1800000.00, 'COMPLETED', 'Đi công tác.', 180000.00, 1620000.00, 0, 0.00, 1800000.00, NULL, NOW(), NOW()),
-- Phòng ID 5
(5009, 1009, 5, '2026-07-04', '2026-07-08', 2, 8000000.00, 'COMPLETED', 'Kỷ niệm ngày cưới.', 800000.00, 7200000.00, 0, 0.00, 8000000.00, NULL, NOW(), NOW()),
(5010, 1010, 5, '2026-07-15', '2026-07-17', 2, 4000000.00, 'COMPLETED', NULL, 400000.00, 3600000.00, 0, 0.00, 4000000.00, NULL, NOW(), NOW()),
-- Phòng ID 6
(5011, 1001, 6, '2026-07-22', '2026-07-25', 3, 9000000.00, 'COMPLETED', NULL, 900000.00, 8100000.00, 0, 500000.00, 9500000.00, 'VIP500', NOW(), NOW()),
(5012, 1002, 6, '2026-07-27', '2026-07-29', 2, 6000000.00, 'COMPLETED', 'Check-out muộn.', 600000.00, 5400000.00, 0, 0.00, 6000000.00, NULL, NOW(), NOW()),
-- Các đơn đặt phòng tương lai đang ở trạng thái CONFIRMED (đã thanh toán thành công)
(5013, 1003, 1, '2026-08-10', '2026-08-12', 2, 2400000.00, 'CONFIRMED', NULL, 240000.00, 2160000.00, 0, 0.00, 2400000.00, NULL, NOW(), NOW()),
(5014, 1004, 2, '2026-08-15', '2026-08-18', 2, 4500000.00, 'CONFIRMED', 'Xin tầng cao.', 450000.00, 4050000.00, 0, 0.00, 4500000.00, NULL, NOW(), NOW()),
(5015, 1005, 3, '2026-08-20', '2026-08-22', 2, 3000000.00, 'CONFIRMED', NULL, 300000.00, 2700000.00, 0, 0.00, 3000000.00, NULL, NOW(), NOW()),
(5016, 1006, 4, '2026-08-25', '2026-08-28', 3, 5400000.00, 'CONFIRMED', NULL, 540000.00, 4860000.00, 0, 0.00, 5400000.00, NULL, NOW(), NOW());

-- 3. THÊM GIAO DỊCH THANH TOÁN THÀNH CÔNG (Payments)
-- Đồng bộ hoàn toàn với các đơn hàng ở trên
INSERT INTO `payments` (`id`, `booking_id`, `amount`, `method`, `status`, `transaction_id`, `paid_at`, `created_at`) VALUES
(5001, 5001, 2400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5001_89234', '2026-06-30 14:22:10', NOW()),
(5002, 5002, 1200000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5002_74312', '2026-07-04 09:15:30', NOW()),
(5003, 5003, 6000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5003_10293', '2026-07-09 18:45:00', NOW()),
(5004, 5004, 3000000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5004_38472', '2026-07-15 21:30:15', NOW()),
(5005, 5005, 4500000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5005_94827', '2026-07-01 11:05:40', NOW()),
(5006, 5006, 3000000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5006_29847', '2026-07-07 16:40:00', NOW()),
(5007, 5007, 5400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5007_12384', '2026-07-11 08:50:22', NOW()),
(5008, 5008, 1800000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5008_48293', '2026-07-19 13:12:05', NOW()),
(5009, 5009, 8000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5009_98374', '2026-07-03 17:00:00', NOW()),
(5010, 5010, 4000000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5010_10928', '2026-07-14 22:15:35', NOW()),
(5011, 5011, 9000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5011_38472', '2026-07-21 10:30:45', NOW()),
(5012, 5012, 6000000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5012_74829', '2026-07-26 15:45:10', NOW()),
(5013, 5013, 2400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5013_83921', NOW(), NOW()),
(5014, 5014, 4500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5014_91028', NOW(), NOW()),
(5015, 5015, 3000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_5015_23910', NOW(), NOW()),
(5016, 5016, 5400000.00, 'MOMO', 'SUCCESS', 'TXN_MM_5016_74839', NOW(), NOW());

-- 4. THÊM ĐÁNH GIÁ (Reviews)
-- Đánh giá phong phú từ Xấu (1 sao), Trung bình (3 sao), Tốt (4 sao) đến Xuất sắc (5 sao)
INSERT INTO `reviews` (`id`, `user_id`, `room_id`, `rating`, `comment`, `created_at`) VALUES
-- Phòng ID 1: 1 Đánh giá Xấu (2 sao), 1 Đánh giá Tốt (4 sao)
(8001, 1001, 1, 2, 'Phòng hơi cũ kỹ, máy lạnh kêu rất to suốt đêm làm tôi mất ngủ. Dịch vụ vệ sinh cũng chưa được tốt.', '2026-07-04 10:00:00'),
(8002, 1002, 1, 4, 'Chất lượng phòng khá ổn trong tầm giá. Vị trí trung tâm thuận tiện đi lại, nhân viên nhiệt tình hỗ trợ.', '2026-07-07 11:30:00'),

-- Phòng ID 2: 1 Đánh giá Rất Tốt (5 sao), 1 Đánh giá Trung Bình (3 sao)
(8003, 1003, 2, 5, 'Phòng siêu đẹp và sạch sẽ! Trang thiết bị hiện đại đầy đủ. View thành phố cực xịn sò, rất đáng tiền!', '2026-07-15 09:00:00'),
(8004, 1004, 2, 3, 'Phòng rộng nhưng cách âm hơi kém, nghe rõ tiếng ồn ngoài hành lang. Bữa sáng phục vụ hơi nghèo nàn.', '2026-07-19 14:20:00'),

-- Phòng ID 3: 1 Đánh giá Rất Xấu (1 sao), 1 Đánh giá Rất Tốt (5 sao)
(8005, 1005, 3, 1, 'Trải nghiệm tồi tệ! Nước nóng bị hỏng không tắm được, phòng ẩm mốc và nhân viên thái độ rất thờ ơ.', '2026-07-06 08:15:00'),
(8006, 1006, 3, 5, 'Phòng sạch tinh tươm, view biển ngắm hoàng hôn tuyệt đẹp. Nhân viên phục vụ chu đáo, nhiệt tình 10/10.', '2026-07-11 10:45:00'),

-- Phòng ID 4: 2 Đánh giá Tốt (4 sao)
(8007, 1007, 4, 4, 'Khách sạn có không gian thoáng mát, nhiều cây xanh. Phòng sạch sẽ, hồ bơi ngoài trời rất đẹp.', '2026-07-16 16:30:00'),
(8008, 1008, 4, 4, 'Vị trí đắc địa gần bãi biển. Phòng nghỉ thoải mái, đầy đủ tiện nghi cơ bản. Sẽ quay lại nếu có dịp.', '2026-07-22 09:10:00'),

-- Phòng ID 5: 1 Đánh giá Rất Tốt (5 sao), 1 Đánh giá Trung Bình (3 sao)
(8009, 1009, 5, 5, 'Gia đình tôi đã có một kỳ nghỉ vô cùng thoải mái ở đây. Chủ nhà rất hiếu khách và hỗ trợ tận tình.', '2026-07-09 15:00:00'),
(8010, 1010, 5, 3, 'Nội thất phòng đã hơi xuống cấp so với ảnh mô tả. Tuy nhiên thái độ phục vụ tốt đã bù đắp phần nào.', '2026-07-18 11:00:00'),

-- Phòng ID 6: 1 Đánh giá Tệ (2 sao), 1 Đánh giá Rất Tốt (5 sao)
(8011, 1001, 6, 2, 'Wifi phòng chập chờn không làm việc được. Nhà vệ sinh thỉnh thoảng có mùi hôi khó chịu.', '2026-07-26 13:40:00'),
(8012, 1002, 6, 5, 'Biệt thự sang trọng, đầy đủ tiện ích gia đình cần. Sát biển và hồ bơi riêng sạch sẽ. Cực kỳ hài lòng.', '2026-07-30 18:25:00');

-- 5. THÊM PHÒNG MỚI VỚI MÔ TẢ CHI TIẾT VÀ 5 ẢNH (At least 5 room images)
-- Thêm 1 tài khoản Chủ nhà (Host) mới để gán quyền sở hữu phòng
INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone`, `role`, `avatar_url`, `is_active`, `commission_rate`, `created_at`, `updated_at`) VALUES
(99, 'host.premium@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Lê Hữu Phước (Host Premium)', '0909999888', 'HOST', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Phuoc', 1, 10.00, NOW(), NOW());

-- Thêm phòng mới với ID 7, mô tả cực kỳ chi tiết
INSERT INTO `rooms` (`id`, `host_id`, `room_type_id`, `name`, `description`, `address`, `city`, `price_per_night`, `max_guests`, `status`) VALUES
(7, 99, 1, 'Penthouse Sky Villa Vũng Tàu - Hồ Bơi Vô Cực Sát Biển', 'Chào mừng bạn đến với Penthouse Sky Villa đẳng cấp 5 sao tại trung tâm Bãi Sau, Vũng Tàu. Căn hộ Penthouse có diện tích rộng rãi lên tới 250m2 với thiết kế kính tràn viền nguyên khối mang lại tầm nhìn toàn cảnh 360 độ ngắm trọn vẹn vịnh biển lộng gió. Sky Villa sở hữu 3 phòng ngủ sang trọng khép kín với giường King-size êm ái, phòng khách siêu rộng thiết kế theo phong cách Indochine hiện đại kết hợp cổ điển, và điểm nhấn đắt giá nhất chính là hồ bơi vô cực ngoài trời riêng ngoài ban công lộng gió hướng thẳng ra biển khơi. Tiện nghi đi kèm đẳng cấp hoàng gia bao gồm: Bếp nấu ăn đầy đủ thiết bị cao cấp (bếp từ, lò nướng, tủ lạnh side-by-side), dàn âm thanh loa Bose karaoke gia đình chuyên nghiệp, bàn bida giải trí cao cấp, bồn tắm sục Jacuzzi massage trong phòng master, và hệ thống nhà thông minh smart-home. Đây chính là nơi lưu trú lý tưởng và thượng lưu nhất cho kỳ nghỉ dưỡng của nhóm bạn hoặc các thành viên trong gia đình thân yêu của bạn.', '122 Thùy Vân, Phường 2', 'Vũng Tàu', 4500000.00, 8, 'ACTIVE');

-- Thêm 5 ảnh thực tế chất lượng cao cho phòng ID 7 (1 ảnh chính và 4 ảnh phụ)
INSERT INTO `room_images` (`id`, `room_id`, `image_url`, `is_primary`) VALUES
(701, 7, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1), -- Ảnh chính: View hồ bơi/phòng khách
(702, 7, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0), -- Ảnh 2: Phòng ngủ master sang trọng
(703, 7, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0), -- Ảnh 3: Phòng khách và ban công hướng biển
(704, 7, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0), -- Ảnh 4: Nhà tắm lớn có bồn sục Jacuzzi
(705, 7, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0); -- Ảnh 5: Khu vực nhà bếp và phòng ăn
