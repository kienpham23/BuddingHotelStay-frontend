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

-- 6. THÊM 20 PHÒNG MỚI (IDs 301-320) VỚI HOST VÀ 5 ẢNH MỖI PHÒNG, ĐÃ THANH TOÁN THÀNH CÔNG VÀ ĐÁNH GIÁ (25 ĐƠN)
-- Thêm các tài khoản Chủ nhà (Hosts) mới
INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone`, `role`, `avatar_url`, `is_active`, `commission_rate`, `created_at`, `updated_at`) VALUES
(101, 'host.hanoi@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Nguyễn Tiến Dũng (Host Hà Nội)', '0911222333', 'HOST', 'https://api.dicebear.com/7.x/avataaars/svg?seed=DungHost', 1, 10.00, NOW(), NOW()),
(102, 'host.saigon@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Trần Hữu Nam (Host Sài Gòn)', '0922333444', 'HOST', 'https://api.dicebear.com/7.x/avataaars/svg?seed=NamHost', 1, 12.00, NOW(), NOW()),
(103, 'host.danang@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Phan Minh Tuấn (Host Đà Nẵng)', '0933444555', 'HOST', 'https://api.dicebear.com/7.x/avataaars/svg?seed=TuanHost', 1, 10.00, NOW(), NOW()),
(104, 'host.dalat@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Vũ Thảo Vy (Host Đà Lạt)', '0944555666', 'HOST', 'https://api.dicebear.com/7.x/avataaars/svg?seed=VyHost', 1, 11.00, NOW(), NOW());

-- Thêm 20 phòng mới với mô tả chi tiết phong phú
INSERT INTO `rooms` (`id`, `host_id`, `room_type_id`, `name`, `description`, `address`, `city`, `price_per_night`, `max_guests`, `status`) VALUES
(301, 101, 9, 'Phòng Cozy Standard Cổ Điển Hà Nội', 'Phòng nghỉ Standard ấm cúng, thiết kế đậm chất vintage Hà Nội xưa với nội thất gỗ tự nhiên. Phù hợp cho những ai tìm kiếm sự yên tĩnh tại trung tâm Phố Cổ. Đầy đủ tiện nghi cơ bản như điều hòa nhiệt độ, wifi tốc độ cao, và mini bar.', '45 Hàng Bè, Hoàn Kiếm', 'Hà Nội', 400000.00, 2, 'ACTIVE'),
(302, 101, 11, 'Deluxe Room View Hồ Tây Lãng Mạn', 'Căn phòng Deluxe sang trọng sở hữu ban công lớn hướng thẳng ra cảnh hoàng hôn Hồ Tây thơ mộng. Phòng tắm vách kính hiện đại, giường đôi êm ái cùng hệ thống đèn thông minh tạo cảm giác lãng mạn cho các cặp đôi.', '10 Xuân Diệu, Tây Hồ', 'Hà Nội', 900000.00, 2, 'ACTIVE'),
(303, 101, 12, 'Family Suite Phố Cổ Gần Hồ Gươm', 'Căn hộ Family Suite rộng rãi gồm 2 phòng ngủ kết nối, có bếp nấu ăn gia đình tiện nghi. Vị trí đắc địa, chỉ mất 3 phút đi bộ ra Hồ Gươm, Nhà Hát Lớn và các điểm ẩm thực phố cổ nổi tiếng.', '12 Đinh Liệt, Hoàn Kiếm', 'Hà Nội', 1500000.00, 5, 'ACTIVE'),
(304, 102, 12, 'Landmark 81 High-floor Luxury Penthouse', 'Trải nghiệm đỉnh cao thượng lưu tại căn hộ Penthouse tầng cao Landmark 81. Thiết kế kính panorama tràn viền mang lại tầm nhìn vô cực ngắm toàn cảnh sông Sài Gòn lộng lẫy về đêm. Trang thiết bị hiện đại tiêu chuẩn châu Âu.', '208 Nguyễn Hữu Cảnh, Bình Thạnh', 'Hồ Chí Minh', 6000000.00, 4, 'ACTIVE'),
(305, 102, 3, 'Studio Bến Thành Central Retro Room', 'Căn hộ Studio nhỏ xinh trang trí theo phong cách Retro Sài Gòn thập niên 90 độc đáo. Nằm ngay cạnh chợ Bến Thành, vô cùng tiện lợi cho du khách khám phá cuộc sống đô thị sôi động ban đêm.', '88 Lê Lợi, Quận 1', 'Hồ Chí Minh', 650000.00, 2, 'ACTIVE'),
(306, 102, 5, 'Biệt Thự Sân Vườn Thảo Điền Quận 2', 'Biệt thự villa sang trọng có sân vườn rộng rãi và hồ bơi ngoài trời xanh mát tọa lạc tại khu nhà giàu Thảo Điền. Không gian yên tĩnh biệt lập lý tưởng cho các buổi họp mặt gia đình cuối tuần hoặc nghỉ dưỡng dài ngày.', '15 Đường số 4, Thảo Điền', 'Hồ Chí Minh', 5000000.00, 10, 'ACTIVE'),
(307, 103, 11, 'Deluxe Ocean View Bãi Biển Mỹ Khê', 'Căn phòng Deluxe ngập tràn ánh nắng tự nhiên với cửa sổ kính rộng mở ra vịnh biển Mỹ Khê Đà Nẵng tuyệt đẹp. Tiện nghi cao cấp, giường đệm cao su êm ái đảm bảo giấc ngủ sâu thư giãn.', '230 Võ Nguyên Giáp, Sơn Trà', 'Đà Nẵng', 1100000.00, 2, 'ACTIVE'),
(308, 103, 5, 'Luxury Beachfront Villa Resort Đà Nẵng', 'Villa nghỉ dưỡng đẳng cấp nằm sát bờ cát trắng Bãi biển Non Nước. Biệt thự sở hữu hồ bơi vô cực riêng, phòng khách mở thoáng đãng đón gió biển và dịch vụ quản gia cao cấp sẵn sàng phục vụ 24/7.', 'Trường Sa, Hòa Hải, Ngũ Hành Sơn', 'Đà Nẵng', 8000000.00, 8, 'ACTIVE'),
(309, 102, 4, 'Sunset Sanato Bungalow Sát Biển Phú Quốc', 'Bungalow gỗ mộc mạc nằm ngay bờ biển Sunset Sanato - nơi ngắm hoàng hôn đẹp nhất đảo ngọc Phú Quốc. Chỉ vài bước chân là bạn có thể hòa mình vào làn nước biển trong vắt.', 'Bãi Trường, Dương Tơ', 'Phú Quốc', 1800000.00, 3, 'ACTIVE'),
(310, 102, 11, 'Deluxe King Bed Vinpearl Phú Quốc', 'Phòng nghỉ Deluxe tiêu chuẩn 5 sao nằm trong tổ hợp nghỉ dưỡng Vinpearl Phú Quốc. Hưởng trọn vẹn các tiện ích bể bơi khổng lồ, bãi biển riêng và khoảng cách cực gần tới VinWonders.', 'Gành Dầu', 'Phú Quốc', 2200000.00, 2, 'ACTIVE'),
(311, 103, 11, 'Ocean Front Deluxe Trần Phú Nha Trang', 'Căn hộ Deluxe view trực diện biển trên đường Trần Phú sầm uất. Thiết kế hiện đại, ban công lộng gió ngắm toàn cảnh vịnh Nha Trang xanh biếc. Rất gần các nhà hàng hải sản nổi tiếng.', '60 Trần Phú', 'Nha Trang', 1200000.00, 2, 'ACTIVE'),
(312, 103, 5, 'Villa Đồi An Viên View Trọn Vịnh Nha Trang', 'Biệt thự tọa lạc trên đồi An Viên yên bình, có kiến trúc hiện đại tối giản với hồ bơi tràn viền hướng ra biển Nha Trang cực đẹp. Thích hợp tổ chức tiệc BBQ ngoài trời lãng mạn.', 'Khu đô thị An Viên', 'Nha Trang', 5500000.00, 8, 'ACTIVE'),
(313, 104, 4, 'Homestay Nhà Gỗ Thông View Thung Lũng', 'Căn nhà nguyên căn làm hoàn toàn bằng gỗ thông mộc mạc, nép mình bên sườn đồi Đà Lạt thơ mộng. Ban công rộng đón sương mù mỗi sớm mai ngắm trọn thung lũng đèn lung linh về đêm.', '31 Hùng Vương, Phường 11', 'Đà Lạt', 1300000.00, 6, 'ACTIVE'),
(314, 104, 5, 'Biệt Thự Pháp Cổ Giữa Rừng Thông Đà Lạt', 'Biệt thự cổ từ thời Pháp được trùng tu giữ nguyên nét kiến trúc cổ kính độc đáo. Nằm ẩn mình giữa rừng thông già xanh mát, mang lại không gian nghỉ dưỡng tĩnh lặng và mát mẻ quanh năm.', 'Trần Hưng Đạo, Phường 10', 'Đà Lạt', 4500000.00, 8, 'ACTIVE'),
(315, 99, 11, 'Deluxe View Biển Bãi Trước Vũng Tàu', 'Phòng Deluxe sang trọng tọa lạc tại Bãi Trước lộng gió, đối diện công viên bờ biển mát mẻ. Không gian phòng thiết kế mở đón nhận luồng gió mát tự nhiên từ đại dương.', '25 Trần Phú, Phường 1', 'Vũng Tàu', 950000.00, 2, 'ACTIVE'),
(316, 99, 5, 'Villa Hồ Bơi Aria Long Cung Vũng Tàu', 'Biệt thự nghỉ dưỡng cao cấp nằm trong resort Aria sát biển Chí Linh. Villa có hồ bơi riêng biệt lập sạch sẽ, phòng karaoke gia đình cực vui và phòng ngủ rộng rãi thoáng đãng.', 'Đường D5, Khu Aria Resort', 'Vũng Tàu', 5800000.00, 12, 'ACTIVE'),
(317, 103, 12, 'Sky Penthouse View Cầu Rồng Sông Hàn', 'Căn hộ thông tầng Penthouse siêu rộng nằm bên bờ sông Hàn. Ngắm trọn vẹn màn trình diễn phun lửa cầu Rồng vào cuối tuần từ độ cao lý tưởng. Nội thất cao cấp chuẩn chỉnh.', 'Trần Hưng Đạo, An Hải Tây', 'Đà Nẵng', 3800000.00, 4, 'ACTIVE'),
(318, 104, 3, 'Phòng Áp Mái Studio Lãng Mạn Đà Lạt', 'Phòng studio áp mái nhỏ xinh phong cách Bắc Âu tối giản. Không gian lãng mạn có bồn tắm gỗ ngắm mây trời đồi núi thông qua ô kính giếng trời tràn ngập ánh sáng.', 'Khởi Nghĩa Bắc Sơn, Phường 10', 'Đà Lạt', 700000.00, 2, 'ACTIVE'),
(319, 102, 12, 'Luxury Suite View Kênh Nhiêu Lộc Quận 1', 'Căn hộ Suite cao cấp ngay trung tâm thành phố. View nhìn ra hàng cây xanh mát dọc bờ kênh Nhiêu Lộc thơ mộng. Giao thông thuận tiện kết nối mọi điểm ăn chơi.', 'Hoàng Sa, Đa Kao, Quận 1', 'Hồ Chí Minh', 1400000.00, 2, 'ACTIVE'),
(320, 102, 3, 'Căn Hộ Địa Trung Hải Sun Grand City', 'Căn hộ nguyên căn mang phong cách kiến trúc Địa Trung Hải rực rỡ sắc màu bên bờ Nam đảo Phú Quốc. Gần ga cáp treo Hòn Thơm và Cầu Hôn nổi tiếng.', 'An Thới', 'Phú Quốc', 2000000.00, 4, 'ACTIVE');

-- Thêm ít nhất 5 ảnh cho mỗi phòng nghỉ mới (Sử dụng ID 30101-32005 để tránh trùng lặp)
INSERT INTO `room_images` (`id`, `room_id`, `image_url`, `is_primary`) VALUES
-- Room 301
(30101, 301, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(30102, 301, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(30103, 301, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(30104, 301, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(30105, 301, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 302
(30201, 302, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 1),
(30202, 302, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(30203, 302, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 0),
(30204, 302, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(30205, 302, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 303
(30301, 303, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(30302, 303, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(30303, 303, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(30304, 303, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(30305, 303, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 304
(30401, 304, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(30402, 304, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(30403, 304, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(30404, 304, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(30405, 304, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 305
(30501, 305, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(30502, 305, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(30503, 305, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(30504, 305, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(30505, 305, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 306
(30601, 306, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 1),
(30602, 306, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
(30603, 306, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(30604, 306, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(30605, 306, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 307
(30701, 307, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 1),
(30702, 307, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(30703, 307, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 0),
(30704, 307, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(30705, 307, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 308
(30801, 308, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(30802, 308, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(30803, 308, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(30804, 308, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(30805, 308, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 309
(30901, 309, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(30902, 309, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(30903, 309, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(30904, 309, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(30905, 309, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 310
(31001, 310, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 1),
(31002, 310, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(31003, 310, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 0),
(31004, 310, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(31005, 310, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 311
(31101, 311, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 1),
(31102, 311, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(31103, 311, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 0),
(31104, 311, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(31105, 311, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 312
(31201, 312, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(31202, 312, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(31203, 312, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(31204, 312, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(31205, 312, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 313
(31301, 313, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(31302, 313, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(31303, 313, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(31304, 313, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(31305, 313, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 314
(31401, 314, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(31402, 314, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(31403, 314, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(31404, 314, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(31405, 314, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 315
(31501, 315, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 1),
(31502, 315, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(31503, 315, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 0),
(31504, 315, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(31505, 315, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 316
(31601, 316, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 1),
(31602, 316, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
(31603, 316, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(31604, 316, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(31605, 316, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 317
(31701, 317, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(31702, 317, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(31703, 317, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(31704, 317, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(31705, 317, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 318
(31801, 318, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(31802, 318, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(31803, 318, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(31804, 318, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(31805, 318, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 319
(31901, 319, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 1),
(31902, 319, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(31903, 319, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 0),
(31904, 319, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(31905, 319, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 320
(32001, 320, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(32002, 320, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(32003, 320, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(32004, 320, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(32005, 320, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0);

-- Thêm 25 đơn đặt phòng cho các phòng mới (sử dụng booking IDs 7001-7025)
INSERT INTO `bookings` (`id`, `user_id`, `room_id`, `check_in`, `check_out`, `num_guests`, `total_price`, `status`, `note`, `commission_amount`, `host_earning`, `is_commission_billed`, `discount_amount`, `original_price`, `promo_code`, `created_at`, `updated_at`) VALUES
(7001, 1001, 301, '2026-07-02', '2026-07-04', 2, 800000.00, 'COMPLETED', NULL, 80000.00, 720000.00, 0, 0.00, 800000.00, NULL, NOW(), NOW()),
(7002, 1002, 302, '2026-07-03', '2026-07-06', 2, 2700000.00, 'COMPLETED', NULL, 270000.00, 2430000.00, 0, 0.00, 2700000.00, NULL, NOW(), NOW()),
(7003, 1003, 303, '2026-07-05', '2026-07-08', 4, 4500000.00, 'COMPLETED', NULL, 450000.00, 4050000.00, 0, 0.00, 4500000.00, NULL, NOW(), NOW()),
(7004, 1004, 304, '2026-07-10', '2026-07-12', 3, 12000000.00, 'COMPLETED', NULL, 1200000.00, 10800000.00, 0, 0.00, 12000000.00, NULL, NOW(), NOW()),
(7005, 1005, 305, '2026-07-12', '2026-07-15', 2, 1950000.00, 'COMPLETED', NULL, 195000.00, 1755000.00, 0, 0.00, 1950000.00, NULL, NOW(), NOW()),
(7006, 1006, 306, '2026-07-15', '2026-07-17', 6, 10000000.00, 'COMPLETED', NULL, 1000000.00, 9000000.00, 0, 0.00, 10000000.00, NULL, NOW(), NOW()),
(7007, 1007, 307, '2026-07-18', '2026-07-20', 2, 2200000.00, 'COMPLETED', NULL, 220000.00, 1980000.00, 0, 0.00, 2200000.00, NULL, NOW(), NOW()),
(7008, 1008, 308, '2026-07-20', '2026-07-22', 4, 16000000.00, 'COMPLETED', NULL, 1600000.00, 14400000.00, 0, 0.00, 16000000.00, NULL, NOW(), NOW()),
(7009, 1009, 309, '2026-07-22', '2026-07-25', 2, 5400000.00, 'COMPLETED', NULL, 540000.00, 4860000.00, 0, 0.00, 5400000.00, NULL, NOW(), NOW()),
(7010, 1010, 310, '2026-07-25', '2026-07-27', 2, 4400000.00, 'COMPLETED', NULL, 440000.00, 3960000.00, 0, 0.00, 4400000.00, NULL, NOW(), NOW()),
(7011, 1001, 311, '2026-07-27', '2026-07-29', 2, 2400000.00, 'COMPLETED', NULL, 240000.00, 2160000.00, 0, 0.00, 2400000.00, NULL, NOW(), NOW()),
(7012, 1002, 312, '2026-07-28', '2026-07-30', 5, 11000000.00, 'COMPLETED', NULL, 1100000.00, 9900000.00, 0, 0.00, 11000000.00, NULL, NOW(), NOW()),
(7013, 1003, 313, '2026-07-29', '2026-08-01', 3, 3900000.00, 'COMPLETED', NULL, 390000.00, 3510000.00, 0, 0.00, 3900000.00, NULL, NOW(), NOW()),
(7014, 1004, 314, '2026-08-01', '2026-08-03', 6, 9000000.00, 'COMPLETED', NULL, 90000.00, 810000.00, 0, 0.00, 900000.00, NULL, NOW(), NOW()),
(7015, 1005, 315, '2026-07-02', '2026-07-04', 2, 1900000.00, 'COMPLETED', NULL, 190000.00, 1710000.00, 0, 0.00, 1900000.00, NULL, NOW(), NOW()),
(7016, 1006, 316, '2026-07-04', '2026-07-06', 8, 11600000.00, 'COMPLETED', NULL, 1160000.00, 10440000.00, 0, 0.00, 11600000.00, NULL, NOW(), NOW()),
(7017, 1007, 317, '2026-07-07', '2026-07-09', 2, 7600000.00, 'COMPLETED', NULL, 760000.00, 6840000.00, 0, 0.00, 7600000.00, NULL, NOW(), NOW()),
(7018, 1008, 318, '2026-07-08', '2026-07-10', 1, 1400000.00, 'COMPLETED', NULL, 140000.00, 1260000.00, 0, 0.00, 1400000.00, NULL, NOW(), NOW()),
(7019, 1009, 319, '2026-07-11', '2026-07-13', 2, 2800000.00, 'COMPLETED', NULL, 280000.00, 2520000.00, 0, 0.00, 2800000.00, NULL, NOW(), NOW()),
(7020, 1010, 320, '2026-07-14', '2026-07-17', 2, 6000000.00, 'COMPLETED', NULL, 600000.00, 5400000.00, 0, 0.00, 6000000.00, NULL, NOW(), NOW()),
(7021, 1001, 301, '2026-07-10', '2026-07-12', 2, 800000.00, 'COMPLETED', NULL, 80000.00, 720000.00, 0, 0.00, 800000.00, NULL, NOW(), NOW()),
(7022, 1002, 302, '2026-07-12', '2026-07-14', 2, 1800000.00, 'COMPLETED', NULL, 180000.00, 1620000.00, 0, 0.00, 1800000.00, NULL, NOW(), NOW()),
(7023, 1003, 304, '2026-07-20', '2026-07-22', 4, 12000000.00, 'COMPLETED', NULL, 1200000.00, 10800000.00, 0, 0.00, 12000000.00, NULL, NOW(), NOW()),
(7024, 1004, 308, '2026-07-25', '2026-07-28', 5, 24000000.00, 'COMPLETED', NULL, 2400000.00, 21600000.00, 0, 0.00, 24000000.00, NULL, NOW(), NOW()),
(7025, 1005, 314, '2026-07-28', '2026-07-31', 4, 13500000.00, 'COMPLETED', NULL, 1350000.00, 12150000.00, 0, 0.00, 13500000.00, NULL, NOW(), NOW());

-- Thêm 25 thanh toán thành công tương ứng (sử dụng payment IDs 7001-7025)
INSERT INTO `payments` (`id`, `booking_id`, `amount`, `method`, `status`, `transaction_id`, `paid_at`, `created_at`) VALUES
(7001, 7001, 800000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7001_83920', NOW(), NOW()),
(7002, 7002, 2700000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7002_29402', NOW(), NOW()),
(7003, 7003, 4500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7003_10398', NOW(), NOW()),
(7004, 7004, 12000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7004_39201', NOW(), NOW()),
(7005, 7005, 1950000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7005_93018', NOW(), NOW()),
(7006, 7006, 10000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7006_49204', NOW(), NOW()),
(7007, 7007, 2200000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7007_19382', NOW(), NOW()),
(7008, 7008, 16000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7008_59281', NOW(), NOW()),
(7009, 7009, 5400000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7009_02941', NOW(), NOW()),
(7010, 7010, 4400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7010_10394', NOW(), NOW()),
(7011, 7011, 2400000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7011_93821', NOW(), NOW()),
(7012, 7012, 11000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7012_49201', NOW(), NOW()),
(7013, 7013, 3900000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7013_83921', NOW(), NOW()),
(7014, 7014, 9000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7014_29301', NOW(), NOW()),
(7015, 7015, 1900000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7015_93810', NOW(), NOW()),
(7016, 7016, 11600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7016_39201', NOW(), NOW()),
(7017, 7017, 7600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7017_49102', NOW(), NOW()),
(7018, 7018, 1400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7018_10293', NOW(), NOW()),
(7019, 7019, 2800000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7019_83910', NOW(), NOW()),
(7020, 7020, 6000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7020_39401', NOW(), NOW()),
(7021, 7021, 800000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7021_28491', NOW(), NOW()),
(7022, 7022, 1800000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7022_19382', NOW(), NOW()),
(7023, 7023, 12000000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7023_49301', NOW(), NOW()),
(7024, 7024, 24000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_7024_29103', NOW(), NOW()),
(7025, 7025, 13500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_7025_93810', NOW(), NOW());

-- Thêm 25 đánh giá tương ứng cho các đơn đặt trên (sử dụng review IDs 10001-10025)
INSERT INTO `reviews` (`id`, `user_id`, `room_id`, `rating`, `comment`, `created_at`) VALUES
(10001, 1001, 301, 4, 'Phòng sạch sẽ, gọn gàng, phong cách cổ điển rất thú vị. Nhân viên vô cùng nhiệt tình hỗ trợ dắt xe.', '2026-07-05 09:00:00'),
(10002, 1002, 302, 5, 'View Hồ Tây siêu rộng ngắm hoàng hôn đỉnh chóp luôn! Phòng tắm kính sạch bong kin kít, lãng mạn.', '2026-07-07 10:30:00'),
(10003, 1003, 303, 5, 'Vị trí đắc địa ngay phố cổ, đi bộ ra hồ Hoàn Kiếm rất gần. Căn suite rộng rãi phù hợp gia đình tôi.', '2026-07-09 14:15:00'),
(10004, 1004, 304, 5, 'Căn hộ Penthouse Landmark 81 cực kỳ sang trọng! View 360 độ từ trên cao nhìn xuống đẹp nghẹt thở.', '2026-07-13 11:00:00'),
(10005, 1005, 305, 3, 'Vị trí gần chợ Bến Thành nên tối hơi ồn ào tí. Phòng trang trí retro dễ thương chụp ảnh rất xinh.', '2026-07-16 15:30:00'),
(10006, 1006, 306, 5, 'Biệt thự Thảo Điền tuyệt vời cho kỳ nghỉ gia đình. Hồ bơi riêng sạch sẽ và bếp đầy đủ đồ nấu ăn BBQ.', '2026-07-18 10:00:00'),
(10007, 1007, 307, 4, 'Phòng ngủ view biển Mỹ Khê tuyệt đẹp, sáng thức dậy đón bình minh rất thích. Có đầy đủ trà cà phê.', '2026-07-21 09:45:00'),
(10008, 1008, 308, 5, 'Resort biệt thự sát biển đỉnh cao ở Đà Nẵng. Dịch vụ quản gia cực kỳ chuyên nghiệp và chu đáo vô cùng.', '2026-07-23 16:20:00'),
(10009, 1009, 309, 5, 'Ngắm hoàng hôn Phú Quốc ngay trước cửa bungalow. Không gian mộc mạc thư thái lý tưởng.', '2026-07-26 08:30:00'),
(10010, 1010, 310, 4, 'Hưởng trọn tiện ích Vinpearl Phú Quốc. Phòng nghỉ rộng rãi, dịch vụ xe điện trung chuyển chu đáo.', '2026-07-28 11:15:00'),
(10011, 1001, 311, 5, 'Phòng view trực diện biển Trần Phú Nha Trang quá đẹp. Đi tắm biển chỉ cần băng qua đường.', '2026-07-30 09:00:00'),
(10012, 1002, 312, 5, 'Biệt thự An Viên Nha Trang rất sang trọng, bếp đầy đủ tiện nghi, view trọn vịnh biển lộng gió.', '2026-08-01 10:30:00'),
(10013, 1003, 313, 4, 'Căn nhà gỗ thông thơm phức, sương mù ngập tràn buổi sáng. View thung lũng đèn lung linh về đêm.', '2026-08-02 09:10:00'),
(10014, 1004, 314, 5, 'Biệt thự Pháp cổ vô cùng lãng mạn, nằm ẩn mình trong rừng thông yên tĩnh. Rất thích hợp nghỉ dưỡng.', '2026-08-04 14:00:00'),
(10015, 1005, 315, 4, 'Phòng Deluxe rộng và sạch, đối diện biển Bãi Trước gió mát rười rượi suốt ngày.', '2026-07-05 11:20:00'),
(10016, 1006, 316, 5, 'Biệt thự Aria Vũng Tàu hồ bơi rộng riêng tư, tổ chức tiệc BBQ hải sản cực kỳ thích luôn.', '2026-07-07 10:10:00'),
(10017, 1007, 317, 5, 'Ngắm cầu Rồng phun lửa trực tiếp từ ban công căn penthouse sông Hàn quá đã! Không gian hiện đại.', '2026-07-10 15:40:00'),
(10018, 1008, 318, 4, 'Phòng áp mái có giếng trời mộng mơ. Bồn tắm gỗ thông tắm thảo dược thư giãn rất tốt.', '2026-07-11 09:30:00'),
(10019, 1009, 319, 4, 'Căn hộ Suite view kênh Nhiêu Lộc xanh mát, quận 1 di chuyển đi đâu cũng gần và nhanh chóng.', '2026-07-14 11:50:00'),
(10020, 1010, 320, 5, 'Phong cách Địa Trung Hải đầy màu sắc nổi bật. Gần cầu Hôn và ga cáp treo cực kỳ thuận tiện.', '2026-07-18 10:20:00'),
(10021, 1006, 301, 5, 'Quay lại đây lần 2 vẫn rất ưng ý. Dịch vụ dọn phòng hàng ngày sạch sẽ, chủ nhà thân thiện.', '2026-07-13 14:00:00'),
(10022, 1007, 302, 4, 'Phòng ốc ổn định, view đẹp. Sẽ tiếp tục lựa chọn cho kỳ công tác tiếp theo.', '2026-07-15 08:30:00'),
(10023, 1003, 304, 5, 'Gia đình tôi đã có trải nghiệm đáng nhớ tại Landmark 81. Phòng cực kỳ đẳng cấp xứng đáng 5 sao.', '2026-07-23 09:40:00'),
(10024, 1004, 308, 5, 'Trải nghiệm đỉnh cao nghỉ dưỡng biển tại resort Đà Nẵng. Không có điểm gì để chê.', '2026-07-29 11:20:00'),
(10025, 1005, 314, 5, 'Biệt thự Pháp cổ tuyệt đẹp. Không khí trong lành mát lạnh của rừng thông vô cùng thư giãn.', '2026-08-01 15:00:00');
