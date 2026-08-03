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

-- 7. THÊM 25 KHÁCH HÀNG MỚI (Vai trò: CUSTOMER, IDs 1101-1125)
INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone`, `role`, `avatar_url`, `is_active`, `commission_rate`, `created_at`, `updated_at`) VALUES
(1101, 'nguyen.bao@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Nguyễn Quốc Bảo', '0912111222', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bao', 1, NULL, NOW(), NOW()),
(1102, 'tran.chi@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Trần Khánh Chi', '0922222333', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Chi', 1, NULL, NOW(), NOW()),
(1103, 'pham.dat@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Phạm Tiến Đạt', '0932333444', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Dat', 1, NULL, NOW(), NOW()),
(1104, 'le.giang@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Lê Hương Giang', '0942444555', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Giang', 1, NULL, NOW(), NOW()),
(1105, 'hoang.hai@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Hoàng Thanh Hải', '0952555666', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Hai', 1, NULL, NOW(), NOW()),
(1106, 'vu.khanh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Vũ Nam Khánh', '0962666777', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=VKhanh', 1, NULL, NOW(), NOW()),
(1107, 'ngo.linh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Ngô Mỹ Linh', '0972777888', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Linh', 1, NULL, NOW(), NOW()),
(1108, 'do.manh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Đỗ Đức Mạnh', '0982888999', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Manh', 1, NULL, NOW(), NOW()),
(1109, 'bui.ngoc@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Bùi Bảo Ngọc', '0992999000', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Ngoc', 1, NULL, NOW(), NOW()),
(1110, 'dang.phuc@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Đặng Hồng Phúc', '0902111333', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Phuc', 1, NULL, NOW(), NOW()),
(1111, 'nguyen.quynh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Nguyễn Diễm Quỳnh', '0912222444', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Quynh', 1, NULL, NOW(), NOW()),
(1112, 'tran.son@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Trần Thanh Sơn', '0922333555', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Son', 1, NULL, NOW(), NOW()),
(1113, 'le.trang@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Lê Huyền Trang', '0932444666', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Trang', 1, NULL, NOW(), NOW()),
(1114, 'pham.uy@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Phạm Quốc Uy', '0942555777', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Uy', 1, NULL, NOW(), NOW()),
(1115, 'hoang.viet@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Hoàng Quốc Việt', '0952666888', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Viet', 1, NULL, NOW(), NOW()),
(1116, 'vu.xuan@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Vũ Thanh Xuân', '0962777999', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Xuan', 1, NULL, NOW(), NOW()),
(1117, 'ngo.yen@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Ngô Hoàng Yến', '0972888000', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Yen', 1, NULL, NOW(), NOW()),
(1118, 'do.anh@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Đỗ Minh Anh', '0982999111', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=DAnh', 1, NULL, NOW(), NOW()),
(1119, 'bui.bach@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Bùi Gia Bạch', '0992111222', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bach', 1, NULL, NOW(), NOW()),
(1120, 'dang.cat@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Đặng Khả Cát', '0902222555', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Cat', 1, NULL, NOW(), NOW()),
(1121, 'nguyen.duy@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Nguyễn Đức Duy', '0912333666', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Duy', 1, NULL, NOW(), NOW()),
(1122, 'tran.hoa@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Trần Quỳnh Hoa', '0922444777', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Hoa', 1, NULL, NOW(), NOW()),
(1123, 'le.long@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Lê Bảo Long', '0932555888', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Long', 1, NULL, NOW(), NOW()),
(1124, 'pham.my@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Phạm Trúc Vy', '0942666999', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=My', 1, NULL, NOW(), NOW()),
(1125, 'hoang.nam@example.com', '$2a$10$wRdfp9wT0wKpyL2j5j1zKuqVf2h3Yy1a7p1zKuqVf2h3Yy1a7p1zK', 'Hoàng Phương Nam', '0952777000', 'CUSTOMER', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Nam', 1, NULL, NOW(), NOW());

-- 8. THÊM 40 PHÒNG MỚI (IDs 401-440) VỚI CÁC THÔNG TIN VÀ MÔ TẢ CHI TIẾT
INSERT INTO `rooms` (`id`, `host_id`, `room_type_id`, `name`, `description`, `address`, `city`, `price_per_night`, `max_guests`, `status`) VALUES
-- Hà Nội
(401, 101, 11, 'Premium King Suite view Phố Cổ Hà Nội', 'Trải nghiệm kỳ nghỉ hoàn hảo tại trung tâm thủ đô. Suite Premium sở hữu phòng ngủ lớn rộng rãi với giường King cao cấp, khu vực tiếp khách biệt lập và phòng tắm đá cẩm thạch sang trọng. Ban công hướng ra những mái ngói cổ kính rêu phong.', '32 Hàng Bông, Hoàn Kiếm', 'Hà Nội', 1800000.00, 2, 'ACTIVE'),
(402, 101, 3, 'Studio Căn hộ Gác Mái Phố Đường Tàu', 'Căn hộ Studio nhỏ xinh đầy sáng tạo trên tầng gác mái. Không gian đậm phong cách Loft, được trang bị nội thất gỗ ấm cúng và cửa sổ mái lớn ngắm sao trời lung linh về đêm.', '15 Tống Duy Tân, Hoàn Kiếm', 'Hà Nội', 750000.00, 2, 'ACTIVE'),
(403, 101, 12, 'Presidential Penthouse View Toàn Cảnh Hồ Tây', 'Đỉnh cao của sự sang trọng rộng tới 180m2 tại bán đảo Quảng An. Căn Penthouse thiết kế kính panorama đón gió hồ Tây, có quầy bar mini riêng, phòng xông hơi ướt và quản gia riêng.', '88 Xuân Diệu, Tây Hồ', 'Hà Nội', 8500000.00, 4, 'ACTIVE'),
(404, 101, 5, 'Lakefront Garden Villa Sóc Sơn', 'Biệt thự sân vườn biệt lập nằm ven hồ nước mát trong lành giữa rừng thông Sóc Sơn. Thiết kế tối giản gần gũi thiên nhiên, hồ bơi nước tràn, sân cỏ rộng lớn thích hợp tổ chức BBQ ngoài trời.', 'Khu đồi thông, Sóc Sơn', 'Hà Nội', 4200000.00, 10, 'ACTIVE'),
-- Hồ Chí Minh
(405, 102, 11, 'Executive Suite View Sông Sài Gòn Hoa Lệ', 'Executive Suite mang vẻ đẹp hiện đại, ngắm trọn vẹn khúc sông Sài Gòn hiền hòa và cầu Ba Son rực rỡ sắc màu về đêm. Tiện ích hiện đại cao cấp, bồn tắm nằm rộng và sofa thư giãn.', '15 Tôn Đức Thắng, Quận 1', 'Hồ Chí Minh', 2800000.00, 2, 'ACTIVE'),
(406, 102, 3, 'Studio Industrial Loft Central Quận 3', 'Căn hộ Studio gạch trần đậm chất nghệ thuật, phù hợp với các bạn trẻ năng động. Vị trí đắc địa ngay trung tâm quận 3 lịch sử, di chuyển nhanh chóng đến mọi điểm vui chơi.', '145 Điện Biên Phủ, Quận 3', 'Hồ Chí Minh', 850000.00, 2, 'ACTIVE'),
(407, 102, 12, 'Grand Duplex Suite Vinhomes Golden River', 'Căn hộ thông tầng Duplex siêu rộng với thiết kế nội thất nhập khẩu từ Ý. Thiết kế mở phóng tầm mắt ngắm cảnh đô thị nhộn nhịp ban ngày và lung linh rực rỡ sắc màu ban đêm.', '2 Tôn Đức Thắng, Bến Nghé, Quận 1', 'Hồ Chí Minh', 5500000.00, 4, 'ACTIVE'),
(408, 102, 5, 'Green Oasis Villa Sân Vườn Thảo Điền', 'Biệt thự nghỉ dưỡng yên bình như một ốc đảo xanh giữa lòng Thảo Điền. Hồ bơi riêng muối điện phân, sân vườn tràn ngập hoa lá chim muông và bếp nướng BBQ cao cấp ngoài trời.', '32 Xuân Thủy, Thảo Điền, Quận 2', 'Hồ Chí Minh', 6500000.00, 8, 'ACTIVE'),
-- Đà Nẵng
(409, 103, 11, 'Deluxe Seafront Suite Bãi Tắm Phạm Văn Đồng', 'Thức dậy đón bình minh trên biển Mỹ Khê ngay từ chiếc giường ngủ êm ái. Phòng Deluxe có thiết kế mở ngập tràn ánh nắng tự nhiên, ban công rộng lộng gió mát rượi.', '120 Võ Nguyên Giáp, Sơn Trà', 'Đà Nẵng', 1600000.00, 2, 'ACTIVE'),
(410, 103, 5, 'Ocean Villa Private Pool Sát Biển Non Nước', 'Villa độc bản nằm trong resort đẳng cấp 5 sao. Chỉ vài bước chân là bạn chạm đến làn nước biển xanh mát. Hồ bơi riêng tư tuyệt đối, phòng khách mở thoáng đãng đẳng cấp.', 'Đường Trường Sa, Ngũ Hành Sơn', 'Đà Nẵng', 9000000.00, 6, 'ACTIVE'),
(411, 103, 12, 'Penthouse Riverview ngắm Cầu sông Hàn', 'Căn hộ Penthouse cực đỉnh nhìn ra sông Hàn thơ mộng. Bạn có thể thưởng ngoạn trọn vẹn cảnh cầu Rồng phun lửa hay các lễ hội pháo hoa quốc tế từ ban công căn hộ siêu rộng.', '182 Bạch Đằng, Hải Châu', 'Đà Nẵng', 3500000.00, 4, 'ACTIVE'),
(412, 103, 3, 'Studio Căn hộ biển An Thượng Phố Tây', 'Căn hộ studio mang đậm phong cách Boho trẻ trung nằm trong khu phố Tây An Thượng nhộn nhịp. Thích hợp cho du khách nghỉ dưỡng dài ngày kết hợp làm việc từ xa.', '15 Hoàng Kế Viêm, Ngũ Hành Sơn', 'Đà Nẵng', 650000.00, 2, 'ACTIVE'),
-- Phú Quốc
(413, 102, 5, 'Bungalow Gỗ Bên Bờ Biển Bãi Ông Lang', 'Bungalow gỗ ấm cúng nằm dưới rặng dừa xanh ngát tại Bãi Ông Lang hoang sơ. Không gian tĩnh lặng, không tiếng ồn đô thị, lý tưởng để đọc sách và ngắm hoàng hôn đỏ rực.', 'Bãi Ông Lang, Cửa Dương', 'Phú Quốc', 1400000.00, 2, 'ACTIVE'),
(414, 102, 12, 'Beachfront Pool Villa Sunset Sanato', 'Biệt thự sát biển lộng lẫy ngắm hoàng hôn Phú Quốc đẹp nhất. Thiết kế phong cách nhiệt đới Tropical, phòng ngủ rộng mở view trực diện biển khơi bao la và hồ bơi vô cực.', 'Dương Tơ, Bãi Trường', 'Phú Quốc', 7500000.00, 6, 'ACTIVE'),
(415, 102, 11, 'Superior Ocean View Grand World', 'Phòng Superior tiện nghi tọa lạc ngay trong thành phố không ngủ Grand World sầm uất. Chỉ vài phút đi bộ ra hồ nhạc nước và các nhà hàng ẩm thực phong phú.', 'Khu phố Địa Trung Hải, Gành Dầu', 'Phú Quốc', 950000.00, 2, 'ACTIVE'),
(416, 102, 1, 'Standard Room sát biển Sunset Town', 'Căn phòng tiêu chuẩn ấm cúng, thiết kế Địa Trung Hải nổi bật, giá cả phải chăng cho các bạn du lịch tự túc muốn ngắm Cầu Hôn lãng mạn bên bờ Nam đảo.', 'Thị trấn Hoàng Hôn, An Thới', 'Phú Quốc', 600000.00, 2, 'ACTIVE'),
-- Nha Trang
(417, 103, 11, 'Deluxe Beachfront Suite Mường Thanh Trần Phú', 'Nằm ở tầng cao hướng biển lộng gió trên con đường Trần Phú sầm uất nhất Nha Trang. Trang thiết bị hiện đại, phòng khách và phòng ngủ riêng biệt, bồn tắm sục sang chảnh.', '60 Trần Phú, Lộc Thọ', 'Nha Trang', 1500000.00, 2, 'ACTIVE'),
(418, 103, 5, 'Imperial Villa Private Hill An Viên', 'Tọa lạc trên đồi An Viên biệt lập nhìn thẳng ra vịnh Nha Trang lộng gió. Villa mang phong cách hoàng gia tân cổ điển, nội thất đắt giá, hồ bơi tràn viền và sân vườn ngập hoa.', 'Khu biệt thự An Viên, Vĩnh Nguyên', 'Nha Trang', 7000000.00, 8, 'ACTIVE'),
(419, 103, 3, 'Studio Room sát biển Hòn Chồng', 'Căn hộ Studio nhỏ xinh ngắm cảnh biển Hòn Chồng thơ mộng. Gần trường đại học nên khu vực xung quanh có rất nhiều quán cafe đẹp và đồ ăn vặt hải sản phong phú giá rẻ.', 'Đường Phạm Văn Đồng, Vĩnh Phước', 'Nha Trang', 550000.00, 2, 'ACTIVE'),
(420, 103, 12, 'Executive Suite Panorama Central Nha Trang', 'Căn hộ Suite sang trọng sở hữu tầm nhìn 360 độ ôm trọn bãi biển Nha Trang và quảng trường 2/4 trung tâm. Thiết kế kính cong độc đáo đón ánh bình minh tuyệt mỹ.', '2 Nguyễn Thị Minh Khai', 'Nha Trang', 2100000.00, 2, 'ACTIVE'),
-- Đà Lạt
(421, 104, 4, 'Homestay Nhà Gỗ Bên Suối sương mù', 'Căn nhà nguyên căn lãng mạn nằm bên cạnh con suối nhỏ rì rào giữa rừng thông Đà Lạt. Không gian mộc mạc yên bình, sương mù ngập tràn ban sáng tạo cảm giác thơ mộng.', 'Đường Khe Sanh, Phường 10', 'Đà Lạt', 1200000.00, 4, 'ACTIVE'),
(422, 104, 5, 'Swiss Bel Villa Đồi Thông Tuyền Lâm', 'Biệt thự mang đậm phong cách kiến trúc Thụy Sĩ sang trọng ẩn mình bên hồ Tuyền Lâm lộng gió. Không gian yên tĩnh tuyệt đối, sân vườn rộng, có lò sưởi ấm cúng cho đêm lạnh.', 'Khu du lịch Hồ Tuyền Lâm', 'Đà Lạt', 4800000.00, 8, 'ACTIVE'),
(423, 104, 3, 'Studio Attic Room Giếng Trời ngắm sao', 'Căn hộ gác mái nhỏ xinh ngập tràn ánh nắng ban ngày và ngắm trọn bầu trời sao lãng mạn ban đêm qua ô kính giếng trời rộng mở. Rất thích hợp cho các chuyến đi đôi lãng mạn.', 'Triệu Việt Vương, Phường 4', 'Đà Lạt', 750000.00, 2, 'ACTIVE'),
(424, 104, 12, 'Grand Suite Heritage Biệt Điện Trần Lệ Xuân', 'Sở hữu không gian nghỉ dưỡng cổ kính đậm chất hoài niệm thời kỳ Pháp thuộc. Nội thất gỗ lim sang trọng, vườn hồng rực rỡ bao quanh và tầm nhìn ngắm đỉnh Langbiang hùng vĩ.', 'Yết Kiêu, Phường 5', 'Đà Lạt', 2300000.00, 2, 'ACTIVE'),
-- Vũng Tàu
(425, 99, 11, 'Deluxe Room View Trực Diện Biển Bãi Sau', 'Tận hưởng gió đại dương mát rượi từ ban công phòng Deluxe Bãi Sau. Thiết kế phòng tông màu xanh ngọc bích mát mẻ, giường King êm ái đem lại giấc ngủ thư giãn tuyệt đối.', '125 Thùy Vân, Phường 2', 'Vũng Tàu', 1100000.00, 2, 'ACTIVE'),
(426, 99, 5, 'Luxury Villa Sapphire Hồ Bơi Sát Biển Long Cung', 'Biệt thự nghỉ dưỡng cao cấp có hồ bơi muối biển tràn bờ riêng. Villa rộng lớn 400m2 thiết kế mở đón gió biển rì rào, phòng karaoke gia đình hiện đại và bếp nướng BBQ.', 'Đường D5, Phường 10', 'Vũng Tàu', 6200000.00, 10, 'ACTIVE'),
(427, 99, 3, 'Studio Bãi Trước View Cáp Treo Hồ Mây', 'Căn hộ Studio nhỏ gọn tiện nghi ngắm trọn cảnh biển Bãi Trước và cabin cáp treo Hồ Mây lướt đi trên nền trời hoàng hôn. Rất thuận tiện để đi dạo ngắm biển buổi tối.', '4 Trần Phú, Phường 1', 'Vũng Tàu', 700000.00, 2, 'ACTIVE'),
(428, 99, 12, 'Penthouse Duplex Royal View Ngọn Hải Đăng', 'Căn hộ thông tầng Penthouse đẳng cấp hoàng gia trên đỉnh đồi. Ngắm nhìn trọn vẹn phố biển Vũng Tàu lung linh ánh đèn và ngọn Hải Đăng cổ kính uy nghiêm lộng gió.', 'Đường Hải Đăng, Phường 2', 'Vũng Tàu', 4000000.00, 4, 'ACTIVE'),
-- Sa Pa
(429, 104, 4, 'Homestay Bungalow Bản Cát Cát view Fansipan', 'Bungalow xinh xắn làm bằng tre nứa và gỗ tự nhiên tọa lạc ngay thung lũng Mường Hoa thơ mộng. Tầm nhìn thẳng ra đỉnh Fansipan quanh năm mây phủ trắng xóa.', 'Bản Cát Cát, Sa Pa', 'Lào Cai', 950000.00, 2, 'ACTIVE'),
(430, 104, 12, 'Grand Suite Cloud View Thung Lũng Mường Hoa', 'Trải nghiệm cảm giác săn mây ngay trước ban công phòng ngủ Suite. Thiết kế đậm chất văn hóa Tây Bắc kết hợp sự tiện nghi sang trọng tiêu chuẩn resort 5 sao.', 'Đường Mường Hoa, Sa Pa', 'Lào Cai', 2600000.00, 2, 'ACTIVE'),
-- Ninh Bình
(431, 101, 4, 'Homestay Bungalow ven sông Ngô Đồng Tam Cốc', 'Căn nhà nguyên căn lợp mái lá truyền thống thanh bình nép mình bên dòng sông Ngô Đồng uốn lượn. Bao quanh bởi các dãy núi đá vôi kỳ vĩ và những cánh đồng lúa chín vàng.', 'Khu du lịch Tam Cốc, Hoa Lư', 'Ninh Bình', 800000.00, 2, 'ACTIVE'),
(432, 101, 5, 'Tràng An Valley Lakeview Villa', 'Biệt thự nghỉ dưỡng sang trọng có hồ bơi ngoài trời nhìn ra mặt hồ tĩnh lặng yên bình bên trong thung lũng Tràng An. Không khí trong lành, có xe đạp miễn phí dạo quanh.', 'Tràng An, Trường Yên, Hoa Lư', 'Ninh Bình', 3200000.00, 6, 'ACTIVE'),
-- Hạ Long
(433, 101, 11, 'Deluxe Room View Vịnh Hạ Long kỳ vị', 'Phòng Deluxe sang trọng sở hữu cửa sổ kính lớn nhìn ra hàng ngàn đảo đá vôi nhô lên giữa vịnh Hạ Long kỳ vĩ. Đầy đủ tiện nghi cao cấp, bể bơi vô cực chung của tòa nhà.', 'Đường Hạ Long, Bãi Cháy', 'Quảng Ninh', 1400000.00, 2, 'ACTIVE'),
(434, 101, 5, 'Luxury Sea View Villa Tuần Châu', 'Biệt thự villa hiện đại 3 tầng tọa lạc trên đảo ngọc Tuần Châu. Sân vườn hướng biển lộng gió, hồ bơi riêng, phòng xông hơi khô hiện đại đem lại kỳ nghỉ dưỡng đẳng cấp.', 'Bán đảo Tuần Châu, Hạ Long', 'Quảng Ninh', 5800000.00, 10, 'ACTIVE'),
-- Thêm các phòng khác
(435, 101, 11, 'Phòng Superior Classic Phố Cổ Hà Nội', 'Phòng Superior classic nhỏ gọn nhưng tiện nghi, trang trí trang nhã phong cách Đông Dương. Nằm trong con ngõ nhỏ yên tĩnh tránh xa tiếng còi xe trung tâm Phố Cổ.', '18 Ngõ Huyện, Hoàn Kiếm', 'Hà Nội', 550000.00, 2, 'ACTIVE'),
(436, 102, 11, 'Deluxe Room Central Park Landmark 3', 'Phòng Deluxe hiện đại tiện nghi nằm trong khu đô thị Vinhomes Central Park. Khách thuê được hưởng trọn vẹn hồ bơi nội khu xanh mát và công viên ven sông rộng lớn.', '208 Nguyễn Hữu Cảnh, Bình Thạnh', 'Hồ Chí Minh', 1200000.00, 2, 'ACTIVE'),
(437, 103, 11, 'Premium Room View Sông Hàn Cầu Rồng', 'Phòng Premium hiện đại nằm bên bờ Đông sông Hàn, ban công rộng ngắm cầu Rồng và phố Bạch Đằng rực rỡ ánh đèn về đêm. Đầy đủ tivi thông minh, máy pha cafe.', 'Ngô Quyền, Sơn Trà', 'Đà Nẵng', 900000.00, 2, 'ACTIVE'),
(438, 102, 11, 'Deluxe Garden View Sunset Town Phú Quốc', 'Phòng Deluxe ấm cúng ngắm cảnh nội khu vườn cây xanh mát tại thị trấn hoàng hôn Sun Premier Land. Rất gần ga cáp treo Hòn Thơm và quảng trường nhạc nước.', 'Thị trấn Hoàng Hôn, An Thới', 'Phú Quốc', 1000000.00, 2, 'ACTIVE'),
(439, 104, 11, 'Premium Room View Rừng Thông Đà Lạt', 'Phòng nghỉ dưỡng yên bình với ban công ngắm những hàng thông xanh rì trong nắng. Tiện nghi sưởi ấm, chăn nệm ấm áp cho những ngày Đà Lạt chuyển mùa se lạnh.', 'Đường 3/4, Phường 3', 'Đà Lạt', 850000.00, 2, 'ACTIVE'),
(440, 99, 11, 'Superior Room View Biển Bãi Sau Vũng Tàu', 'Phòng Superior view xéo hướng biển Bãi Sau lộng gió. Phòng sạch sẽ ngăn nắp, đầy đủ trà, nước suối miễn phí hằng ngày. Nhân viên lễ tân hỗ trợ nhiệt tình 24/7.', '108 Thùy Vân, Phường 2', 'Vũng Tàu', 800000.00, 2, 'ACTIVE');

-- 9. THÊM ÍT NHẤT 5 ẢNH CHO MỖI PHÒNG NGHỈ MỚI (IDs từ 40101 đến 44005)
INSERT INTO `room_images` (`id`, `room_id`, `image_url`, `is_primary`) VALUES
-- Room 401
(40101, 401, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(40102, 401, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40103, 401, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40104, 401, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40105, 401, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 402
(40201, 402, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(40202, 402, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(40203, 402, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(40204, 402, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(40205, 402, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 403
(40301, 403, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(40302, 403, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40303, 403, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40304, 403, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40305, 403, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 404
(40401, 404, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(40402, 404, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40403, 404, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40404, 404, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40405, 404, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 405
(40501, 405, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(40502, 405, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40503, 405, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40504, 405, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40505, 405, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 406
(40601, 406, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(40602, 406, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(40603, 406, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(40604, 406, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(40605, 406, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 407
(40701, 407, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(40702, 407, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40703, 407, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40704, 407, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40705, 407, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 408
(40801, 408, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(40802, 408, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40803, 408, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40804, 408, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40805, 408, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 409
(40901, 409, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(40902, 409, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(40903, 409, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(40904, 409, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(40905, 409, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 410
(41001, 410, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(41002, 410, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(41003, 410, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(41004, 410, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(41005, 410, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 411
(41101, 411, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(41102, 411, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41103, 411, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41104, 411, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41105, 411, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 412
(41201, 412, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(41202, 412, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41203, 412, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41204, 412, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41205, 412, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 413
(41301, 413, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(41302, 413, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41303, 413, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41304, 413, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41305, 413, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 414
(41401, 414, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(41402, 414, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(41403, 414, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(41404, 414, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(41405, 414, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 415
(41501, 415, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(41502, 415, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41503, 415, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41504, 415, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41505, 415, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 416
(41601, 416, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(41602, 416, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41603, 416, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41604, 416, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41605, 416, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 417
(41701, 417, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(41702, 417, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41703, 417, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41704, 417, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41705, 417, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 418
(41801, 418, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(41802, 418, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(41803, 418, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(41804, 418, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(41805, 418, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 419
(41901, 419, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(41902, 419, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(41903, 419, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(41904, 419, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(41905, 419, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 420
(42001, 420, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(42002, 420, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42003, 420, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42004, 420, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42005, 420, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 421
(42101, 421, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(42102, 421, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42103, 421, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42104, 421, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42105, 421, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 422
(42201, 422, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(42202, 422, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(42203, 422, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(42204, 422, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(42205, 422, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 423
(42301, 423, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(42302, 423, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42303, 423, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42304, 423, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42305, 423, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 424
(42401, 424, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(42402, 424, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42403, 424, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42404, 424, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42405, 424, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 425
(42501, 425, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(42502, 425, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42503, 425, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42504, 425, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42505, 425, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 426
(42601, 426, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(42602, 426, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(42603, 426, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(42604, 426, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(42605, 426, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 427
(42701, 427, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(42702, 427, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42703, 427, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42704, 427, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42705, 427, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 428
(42801, 428, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(42802, 428, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42803, 428, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42804, 428, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42805, 428, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 429
(42901, 429, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(42902, 429, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(42903, 429, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(42904, 429, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(42905, 429, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 430
(43001, 430, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(43002, 430, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(43003, 430, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(43004, 430, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(43005, 430, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 431
(43101, 431, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(43102, 431, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43103, 431, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43104, 431, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43105, 431, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 432
(43201, 432, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(43202, 432, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43203, 432, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43204, 432, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43205, 432, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 433
(43301, 433, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(43302, 433, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43303, 433, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43304, 433, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43305, 433, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 434
(43401, 434, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(43402, 434, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(43403, 434, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(43404, 434, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(43405, 434, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 435
(43501, 435, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(43502, 435, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43503, 435, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43504, 435, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43505, 435, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 436
(43601, 436, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(43602, 436, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43603, 436, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43604, 436, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43605, 436, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 437
(43701, 437, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 1),
(43702, 437, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43703, 437, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43704, 437, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43705, 437, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 438
(43801, 438, 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 1),
(43802, 438, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', 0),
(43803, 438, 'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', 0),
(43804, 438, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 0),
(43805, 438, 'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 439
(43901, 439, 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 1),
(43902, 439, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(43903, 439, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(43904, 439, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(43905, 439, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0),
-- Room 440
(44001, 440, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 1),
(44002, 440, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', 0),
(44003, 440, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', 0),
(44004, 440, 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=1200&q=80', 0),
(44005, 440, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=80', 0);

-- 10. THÊM 30 ĐƠN ĐẶT PHÒNG KHÁCH HÀNG MỚI (Bookings, IDs 15001-15030, trạng thái COMPLETED)
INSERT INTO `bookings` (`id`, `user_id`, `room_id`, `check_in`, `check_out`, `num_guests`, `total_price`, `status`, `note`, `commission_amount`, `host_earning`, `is_commission_billed`, `discount_amount`, `original_price`, `promo_code`, `created_at`, `updated_at`) VALUES
(15001, 1101, 401, '2026-07-02', '2026-07-05', 2, 5400000.00, 'COMPLETED', NULL, 540000.00, 4860000.00, 0, 0.00, 5400000.00, NULL, NOW(), NOW()),
(15002, 1102, 402, '2026-07-04', '2026-07-06', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, NOW(), NOW()),
(15003, 1103, 405, '2026-07-05', '2026-07-07', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, NOW(), NOW()),
(15004, 1104, 406, '2026-07-06', '2026-07-09', 2, 2550000.00, 'COMPLETED', NULL, 255000.00, 2295000.00, 0, 0.00, 2550000.00, NULL, NOW(), NOW()),
(15005, 1105, 409, '2026-07-10', '2026-07-12', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, NOW(), NOW()),
(15006, 1106, 412, '2026-07-11', '2026-07-13', 2, 1300000.00, 'COMPLETED', NULL, 130000.00, 1170000.00, 0, 0.00, 1300000.00, NULL, NOW(), NOW()),
(15007, 1107, 413, '2026-07-12', '2026-07-15', 2, 4200000.00, 'COMPLETED', NULL, 420000.00, 3780000.00, 0, 0.00, 4200000.00, NULL, NOW(), NOW()),
(15008, 1108, 415, '2026-07-14', '2026-07-16', 2, 1900000.00, 'COMPLETED', NULL, 190000.00, 1710000.00, 0, 0.00, 1900000.00, NULL, NOW(), NOW()),
(15009, 1109, 417, '2026-07-15', '2026-07-17', 2, 3000000.00, 'COMPLETED', NULL, 300000.00, 2700000.00, 0, 0.00, 3000000.00, NULL, NOW(), NOW()),
(15010, 1110, 419, '2026-07-16', '2026-07-18', 2, 1100000.00, 'COMPLETED', NULL, 110000.00, 990000.00, 0, 0.00, 1100000.00, NULL, NOW(), NOW()),
(15011, 1111, 421, '2026-07-17', '2026-07-19', 2, 2400000.00, 'COMPLETED', NULL, 240000.00, 2160000.00, 0, 0.00, 2400000.00, NULL, NOW(), NOW()),
(15012, 1112, 423, '2026-07-18', '2026-07-20', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, NOW(), NOW()),
(15013, 1113, 425, '2026-07-20', '2026-07-22', 2, 2200000.00, 'COMPLETED', NULL, 220000.00, 1980000.00, 0, 0.00, 2200000.00, NULL, NOW(), NOW()),
(15014, 1114, 427, '2026-07-21', '2026-07-23', 2, 1400000.00, 'COMPLETED', NULL, 140000.00, 1260000.00, 0, 0.00, 1400000.00, NULL, NOW(), NOW()),
(15015, 1115, 429, '2026-07-22', '2026-07-24', 2, 1900000.00, 'COMPLETED', NULL, 190000.00, 1710000.00, 0, 0.00, 1900000.00, NULL, NOW(), NOW()),
(15016, 1116, 431, '2026-07-24', '2026-07-26', 2, 1600000.00, 'COMPLETED', NULL, 160000.00, 1440000.00, 0, 0.00, 1600000.00, NULL, NOW(), NOW()),
(15017, 1117, 433, '2026-07-25', '2026-07-27', 2, 2800000.00, 'COMPLETED', NULL, 280000.00, 2520000.00, 0, 0.00, 2800000.00, NULL, NOW(), NOW()),
(15018, 1118, 435, '2026-07-26', '2026-07-28', 2, 1100000.00, 'COMPLETED', NULL, 110000.00, 990000.00, 0, 0.00, 1100000.00, NULL, NOW(), NOW()),
(15019, 1119, 436, '2026-07-27', '2026-07-29', 2, 2400000.00, 'COMPLETED', NULL, 240000.00, 2160000.00, 0, 0.00, 2400000.00, NULL, NOW(), NOW()),
(15020, 1120, 437, '2026-07-28', '2026-07-30', 2, 1800000.00, 'COMPLETED', NULL, 180000.00, 1620000.00, 0, 0.00, 1800000.00, NULL, NOW(), NOW()),
(15021, 1121, 438, '2026-07-29', '2026-07-31', 2, 2000000.00, 'COMPLETED', NULL, 200000.00, 1800000.00, 0, 0.00, 2000000.00, NULL, NOW(), NOW()),
(15022, 1122, 439, '2026-07-30', '2026-08-01', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, NOW(), NOW()),
(15023, 1123, 440, '2026-07-31', '2026-08-02', 2, 1600000.00, 'COMPLETED', NULL, 160000.00, 1440000.00, 0, 0.00, 1600000.00, NULL, NOW(), NOW()),
(15024, 1124, 401, '2026-07-15', '2026-07-17', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, NOW(), NOW()),
(15025, 1125, 405, '2026-07-20', '2026-07-22', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, NOW(), NOW()),
(15026, 1101, 409, '2026-07-22', '2026-07-24', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, NOW(), NOW()),
(15027, 1102, 413, '2026-07-25', '2026-07-28', 2, 4200000.00, 'COMPLETED', NULL, 420000.00, 3780000.00, 0, 0.00, 4200000.00, NULL, NOW(), NOW()),
(15028, 1103, 417, '2026-07-27', '2026-07-29', 2, 3000000.00, 'COMPLETED', NULL, 300000.00, 2700000.00, 0, 0.00, 3000000.00, NULL, NOW(), NOW()),
(15029, 1104, 425, '2026-07-28', '2026-07-30', 2, 2200000.00, 'COMPLETED', NULL, 220000.00, 1980000.00, 0, 0.00, 2200000.00, NULL, NOW(), NOW()),
(15030, 1105, 429, '2026-07-29', '2026-07-31', 2, 1900000.00, 'COMPLETED', NULL, 190000.00, 1710000.00, 0, 0.00, 1900000.00, NULL, NOW(), NOW());

-- 11. THÊM 30 GIAO DỊCH THANH TOÁN (Payments, IDs 15001-15030, SUCCESS)
INSERT INTO `payments` (`id`, `booking_id`, `amount`, `method`, `status`, `transaction_id`, `paid_at`, `created_at`) VALUES
(15001, 15001, 5400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15001_84920', NOW(), NOW()),
(15002, 15002, 1500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15002_29402', NOW(), NOW()),
(15003, 15003, 5600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15003_10398', NOW(), NOW()),
(15004, 15004, 2550000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15004_39201', NOW(), NOW()),
(15005, 15005, 3200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15005_93018', NOW(), NOW()),
(15006, 15006, 1300000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15006_49204', NOW(), NOW()),
(15007, 15007, 4200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15007_19382', NOW(), NOW()),
(15008, 15008, 1900000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15008_59281', NOW(), NOW()),
(15009, 15009, 3000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15009_02941', NOW(), NOW()),
(15010, 15010, 1100000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15010_10394', NOW(), NOW()),
(15011, 15011, 2400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15011_93821', NOW(), NOW()),
(15012, 15012, 1500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15012_49201', NOW(), NOW()),
(15013, 15013, 2200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15013_83921', NOW(), NOW()),
(15014, 15014, 1400000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15014_29301', NOW(), NOW()),
(15015, 15015, 1900000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15015_93810', NOW(), NOW()),
(15016, 15016, 1600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15016_39201', NOW(), NOW()),
(15017, 15017, 2800000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15017_49102', NOW(), NOW()),
(15018, 15018, 1100000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15018_10293', NOW(), NOW()),
(15019, 15019, 2400000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15019_83910', NOW(), NOW()),
(15020, 15020, 1800000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15020_39401', NOW(), NOW()),
(15021, 15021, 2000000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15021_28491', NOW(), NOW()),
(15022, 15022, 1700000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15022_19382', NOW(), NOW()),
(15023, 15023, 1600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15023_49301', NOW(), NOW()),
(15024, 15024, 3600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15024_29103', NOW(), NOW()),
(15025, 15025, 5600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15025_93810', NOW(), NOW()),
(15026, 15026, 3200000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15026_84910', NOW(), NOW()),
(15027, 15027, 4200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15027_10928', NOW(), NOW()),
(15028, 15028, 3000000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15028_38472', NOW(), NOW()),
(15029, 15029, 2200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_15029_94827', NOW(), NOW()),
(15030, 15030, 1900000.00, 'MOMO', 'SUCCESS', 'TXN_MM_15030_29847', NOW(), NOW());

-- 12. THÊM 30 ĐÁNH GIÁ PHÒNG TƯƠNG ỨNG (Reviews, IDs 20001-20030)
INSERT INTO `reviews` (`id`, `user_id`, `room_id`, `rating`, `comment`, `created_at`) VALUES
(20001, 1101, 401, 5, 'Phòng suite cực kỳ sang trọng và rộng rãi. View ngắm trọn vẹn khu phố cổ nhộn nhịp rất đẹp.', '2026-07-06 09:00:00'),
(20002, 1102, 402, 4, 'Không gian gác mái nhỏ xinh và lãng mạn. Rất phù hợp cho các cặp đôi du lịch ngắn ngày.', '2026-07-07 10:15:00'),
(20003, 1103, 405, 5, 'View sông Sài Gòn và cầu Ba Son ban đêm đẹp xuất sắc. Giường ngủ êm ái, bồn tắm rộng rãi.', '2026-07-08 14:00:00'),
(20004, 1104, 406, 4, 'Phong cách mộc mạc gạch trần vintage rất có gu. Vị trí thuận tiện di chuyển trong trung tâm.', '2026-07-10 11:20:00'),
(20005, 1105, 409, 5, 'Đón bình minh ngay tại ban công hướng biển Mỹ Khê tuyệt vời. Phòng ốc cực kỳ sạch sẽ.', '2026-07-13 09:30:00'),
(20006, 1106, 412, 4, 'Căn studio nằm ngay khu phố Tây An Thượng rất nhộn nhịp, nhiều quán ăn ngon xung quanh.', '2026-07-14 15:45:00'),
(20007, 1107, 413, 5, 'Bungalow gỗ gần gũi thiên nhiên dưới rặng dừa xanh mát. Nghe sóng biển rì rào thư thái.', '2026-07-16 10:00:00'),
(20008, 1108, 415, 3, 'Gần khu Grand World nên tối hơi ồn ào nhẹ, tuy nhiên phòng rất tiện nghi đầy đủ đồ dùng.', '2026-07-17 11:30:00'),
(20009, 1109, 417, 5, 'Tọa lạc ngay mặt đường Trần Phú lộng gió. Phòng khách riêng biệt, bồn tắm sục cực phê.', '2026-07-18 16:15:00'),
(20010, 1110, 419, 4, 'Nằm gần khu Hòn Chồng nhiều hải sản ngon bổ rẻ. Chủ nhà hướng dẫn địa điểm ăn uống nhiệt tình.', '2026-07-19 09:20:00'),
(20011, 1111, 421, 5, 'Ngôi nhà gỗ thông mộc mạc bên suối chảy róc rách thơ mộng vô cùng. Trải nghiệm tuyệt vời.', '2026-07-20 14:00:00'),
(20012, 1112, 423, 4, 'Không gian áp mái nhỏ nhắn dễ thương, ngắm sao qua cửa kính rất lãng mạn.', '2026-07-21 08:30:00'),
(20013, 1113, 425, 5, 'Ban công nhìn thẳng ra biển Bãi Sau lộng gió. Phòng ốc gọn gàng ngăn nắp tiêu chuẩn 5 sao.', '2026-07-23 10:10:00'),
(20014, 1114, 427, 4, 'Studio gần bến tàu cánh ngầm tiện lợi di chuyển. Phòng ấm cúng đầy đủ dụng cụ nấu nướng.', '2026-07-24 15:00:00'),
(20015, 1115, 429, 5, 'Bungalow nhìn ra thung lũng lúa xanh mướt ngắm mây núi Fansipan rất hùng vĩ.', '2026-07-25 09:40:00'),
(20016, 1116, 431, 4, 'Nằm sát bên bến thuyền Tam Cốc, xung quanh cảnh sắc đồng lúa núi đá vôi rất đẹp mắt.', '2026-07-27 11:20:00'),
(20017, 1117, 433, 5, 'View ôm trọn vịnh Hạ Long kỳ vĩ từ tầng cao cực kỳ đắt giá. Bể bơi vô cực đẹp xuất sắc.', '2026-07-28 10:05:00'),
(20018, 1118, 435, 4, 'Nằm trong ngõ nhỏ Phố Cổ tránh được tiếng ồn, đi bộ ra hồ Hoàn Kiếm rất gần.', '2026-07-29 14:15:00'),
(20019, 1119, 436, 5, 'Căn hộ chung cư cao cấp đầy đủ tiện ích công viên và hồ bơi sang chảnh.', '2026-07-30 09:30:00'),
(20020, 1120, 437, 5, 'Ngắm trọn vẹn màn cầu Rồng phun lửa trực tiếp từ ban công căn hộ. Đáng tiền!', '2026-07-31 16:45:00'),
(20021, 1121, 438, 4, 'Phong cách thiết kế Địa Trung Hải màu sắc nổi bật. Gần quảng trường nhạc nước vui nhộn.', '2026-08-01 10:20:00'),
(20022, 1122, 439, 5, 'View rừng thông xanh mướt mát mẻ, lò sưởi ấm cúng cho buổi tối lạnh.', '2026-08-02 09:15:00'),
(20023, 1123, 440, 4, 'Đối diện biển Bãi Sau đi bộ qua đường tắm biển rất nhanh. Nhân viên dọn phòng thân thiện.', '2026-08-03 11:00:00'),
(20024, 1124, 401, 5, 'Lần thứ hai quay lại đây. Chất lượng phục vụ vẫn rất đỉnh cao và phòng ốc sạch sẽ.', '2026-07-18 10:30:00'),
(20025, 1125, 405, 5, 'Căn suite đẳng cấp nhìn ra sông Sài Gòn lấp lánh ánh đèn. Rất thích hợp nghỉ dưỡng.', '2026-07-23 15:40:00'),
(20026, 1101, 409, 4, 'Bãi biển trước mặt rất rộng cát trắng mịn, thích hợp tắm biển buổi sáng sớm.', '2026-07-25 09:10:00'),
(20027, 1102, 413, 5, 'Bungalow gỗ xinh xắn trong vườn dừa yên bình. Đón hoàng hôn đẹp rực rỡ.', '2026-07-29 11:05:00'),
(20028, 1103, 417, 5, 'Bồn tắm sục massage ngắm nhìn vịnh biển Nha Trang thơ mộng rất thoải mái.', '2026-07-30 14:00:00'),
(20029, 1104, 425, 4, 'Trải nghiệm tuyệt vời tại Bãi Sau Vũng Tàu. Sẽ tiếp tục lựa chọn nơi này.', '2026-08-01 09:30:00'),
(20030, 1105, 429, 5, 'Điểm săn mây lý tưởng nhìn thẳng ra đỉnh Fansipan. Sẽ giới thiệu cho bạn bè.', '2026-08-02 10:20:00');

-- 13. THÊM 30 ĐƠN ĐẶT PHÒNG GIẢ LẬP CHO CÁC THÁNG TRƯỚC (Tháng 1 -> Tháng 6 năm 2026, mỗi tháng 5 đơn)
-- Trạng thái: 'COMPLETED'. Dùng dữ liệu Khách hàng (1101-1125) và Phòng (401-409) có sẵn trong file này.
INSERT INTO `bookings` (`id`, `user_id`, `room_id`, `check_in`, `check_out`, `num_guests`, `total_price`, `status`, `note`, `commission_amount`, `host_earning`, `is_commission_billed`, `discount_amount`, `original_price`, `promo_code`, `created_at`, `updated_at`) VALUES
-- Tháng 1/2026
(30001, 1106, 401, '2026-01-05', '2026-01-07', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, '2026-01-01 10:00:00', '2026-01-07 12:00:00'),
(30002, 1107, 402, '2026-01-10', '2026-01-12', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-01-05 10:00:00', '2026-01-12 12:00:00'),
(30003, 1108, 405, '2026-01-15', '2026-01-17', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, '2026-01-10 10:00:00', '2026-01-17 12:00:00'),
(30004, 1109, 406, '2026-01-20', '2026-01-22', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, '2026-01-15 10:00:00', '2026-01-22 12:00:00'),
(30005, 1110, 409, '2026-01-25', '2026-01-27', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, '2026-01-20 10:00:00', '2026-01-27 12:00:00'),
-- Tháng 2/2026
(30006, 1111, 401, '2026-02-05', '2026-02-07', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, '2026-02-01 10:00:00', '2026-02-07 12:00:00'),
(30007, 1112, 402, '2026-02-10', '2026-02-12', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-02-05 10:00:00', '2026-02-12 12:00:00'),
(30008, 1113, 405, '2026-02-15', '2026-02-17', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, '2026-02-10 10:00:00', '2026-02-17 12:00:00'),
(30009, 1114, 406, '2026-02-20', '2026-02-22', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, '2026-02-15 10:00:00', '2026-02-22 12:00:00'),
(30010, 1115, 409, '2026-02-25', '2026-02-27', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, '2026-02-20 10:00:00', '2026-02-27 12:00:00'),
-- Tháng 3/2026
(30011, 1116, 401, '2026-03-05', '2026-03-07', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, '2026-03-01 10:00:00', '2026-03-07 12:00:00'),
(30012, 1117, 402, '2026-03-10', '2026-03-12', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-03-05 10:00:00', '2026-03-12 12:00:00'),
(30013, 1118, 405, '2026-03-15', '2026-03-17', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, '2026-03-10 10:00:00', '2026-03-17 12:00:00'),
(30014, 1119, 406, '2026-03-20', '2026-03-22', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, '2026-03-15 10:00:00', '2026-03-22 12:00:00'),
(30015, 1120, 409, '2026-03-25', '2026-03-27', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, '2026-03-20 10:00:00', '2026-03-27 12:00:00'),
-- Tháng 4/2026
(30016, 1121, 401, '2026-04-05', '2026-04-07', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, '2026-04-01 10:00:00', '2026-04-07 12:00:00'),
(30017, 1122, 402, '2026-04-10', '2026-04-12', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-04-05 10:00:00', '2026-04-12 12:00:00'),
(30018, 1123, 405, '2026-04-15', '2026-04-17', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, '2026-04-10 10:00:00', '2026-04-17 12:00:00'),
(30019, 1124, 406, '2026-04-20', '2026-04-22', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, '2026-04-15 10:00:00', '2026-04-22 12:00:00'),
(30020, 1125, 409, '2026-04-25', '2026-04-27', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, '2026-04-20 10:00:00', '2026-04-27 12:00:00'),
-- Tháng 5/2026
(30021, 1101, 402, '2026-05-05', '2026-05-07', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-05-01 10:00:00', '2026-05-07 12:00:00'),
(30022, 1102, 405, '2026-05-10', '2026-05-12', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, '2026-05-05 10:00:00', '2026-05-12 12:00:00'),
(30023, 1103, 406, '2026-05-15', '2026-05-17', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, '2026-05-10 10:00:00', '2026-05-17 12:00:00'),
(30024, 1104, 409, '2026-05-20', '2026-05-22', 2, 3200000.00, 'COMPLETED', NULL, 320000.00, 2880000.00, 0, 0.00, 3200000.00, NULL, '2026-05-15 10:00:00', '2026-05-22 12:00:00'),
(30025, 1105, 401, '2026-05-25', '2026-05-27', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, '2026-05-20 10:00:00', '2026-05-27 12:00:00'),
-- Tháng 6/2026
(30026, 1106, 402, '2026-06-05', '2026-06-07', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-06-01 10:00:00', '2026-06-07 12:00:00'),
(30027, 1107, 405, '2026-06-10', '2026-06-12', 2, 5600000.00, 'COMPLETED', NULL, 560000.00, 5040000.00, 0, 0.00, 5600000.00, NULL, '2026-06-05 10:00:00', '2026-06-12 12:00:00'),
(30028, 1108, 406, '2026-06-15', '2026-06-17', 2, 1700000.00, 'COMPLETED', NULL, 170000.00, 1530000.00, 0, 0.00, 1700000.00, NULL, '2026-06-10 10:00:00', '2026-06-17 12:00:00'),
(30029, 1109, 401, '2026-06-20', '2026-06-22', 2, 3600000.00, 'COMPLETED', NULL, 360000.00, 3240000.00, 0, 0.00, 3600000.00, NULL, '2026-06-15 10:00:00', '2026-06-22 12:00:00'),
(30030, 1110, 402, '2026-06-25', '2026-06-27', 2, 1500000.00, 'COMPLETED', NULL, 150000.00, 1350000.00, 0, 0.00, 1500000.00, NULL, '2026-06-20 10:00:00', '2026-06-27 12:00:00');

-- 14. THÊM 30 THANH TOÁN THÀNH CÔNG CHO CÁC ĐƠN ĐẶT PHÒNG TRÊN (Payments, IDs 30001-30030)
INSERT INTO `payments` (`id`, `booking_id`, `amount`, `method`, `status`, `transaction_id`, `paid_at`, `created_at`) VALUES
(30001, 30001, 3600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30001_MOCK', '2026-01-05 12:05:00', NOW()),
(30002, 30002, 1500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30002_MOCK', '2026-01-10 12:05:00', NOW()),
(30003, 30003, 5600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30003_MOCK', '2026-01-15 12:05:00', NOW()),
(30004, 30004, 1700000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30004_MOCK', '2026-01-20 12:05:00', NOW()),
(30005, 30005, 3200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30005_MOCK', '2026-01-25 12:05:00', NOW()),
(30006, 30006, 3600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30006_MOCK', '2026-02-05 12:05:00', NOW()),
(30007, 30007, 1500000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30007_MOCK', '2026-02-10 12:05:00', NOW()),
(30008, 30008, 5600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30008_MOCK', '2026-02-15 12:05:00', NOW()),
(30009, 30009, 1700000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30009_MOCK', '2026-02-20 12:05:00', NOW()),
(30010, 30010, 3200000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30010_MOCK', '2026-02-25 12:05:00', NOW()),
(30011, 30011, 3600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30011_MOCK', '2026-03-05 12:05:00', NOW()),
(30012, 30012, 1500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30012_MOCK', '2026-03-10 12:05:00', NOW()),
(30013, 30013, 5600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30013_MOCK', '2026-03-15 12:05:00', NOW()),
(30014, 30014, 1700000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30014_MOCK', '2026-03-20 12:05:00', NOW()),
(30015, 30015, 3200000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30015_MOCK', '2026-03-25 12:05:00', NOW()),
(30016, 30016, 3600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30016_MOCK', '2026-04-05 12:05:00', NOW()),
(30017, 30017, 1500000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30017_MOCK', '2026-04-10 12:05:00', NOW()),
(30018, 30018, 5600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30018_MOCK', '2026-04-15 12:05:00', NOW()),
(30019, 30019, 1700000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30019_MOCK', '2026-04-20 12:05:00', NOW()),
(30020, 30020, 3200000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30020_MOCK', '2026-04-25 12:05:00', NOW()),
(30021, 30021, 1500000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30021_MOCK', '2026-05-05 12:05:00', NOW()),
(30022, 30022, 5600000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30022_MOCK', '2026-05-10 12:05:00', NOW()),
(30023, 30023, 1700000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30023_MOCK', '2026-05-15 12:05:00', NOW()),
(30024, 30024, 3200000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30024_MOCK', '2026-05-20 12:05:00', NOW()),
(30025, 30025, 3600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30025_MOCK', '2026-05-25 12:05:00', NOW()),
(30026, 30026, 1500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30026_MOCK', '2026-06-05 12:05:00', NOW()),
(30027, 30027, 5600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30027_MOCK', '2026-06-10 12:05:00', NOW()),
(30028, 30028, 1700000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30028_MOCK', '2026-06-15 12:05:00', NOW()),
(30029, 30029, 3600000.00, 'VNPAY', 'SUCCESS', 'TXN_VNP_30029_MOCK', '2026-06-20 12:05:00', NOW()),
(30030, 30030, 1500000.00, 'MOMO', 'SUCCESS', 'TXN_MM_30030_MOCK', '2026-06-25 12:05:00', NOW());

-- 15. THÊM 30 ĐÁNH GIÁ PHÒNG TƯƠNG ỨNG (Reviews, IDs 30001-30030, Điểm đánh giá từ 1 đến 5 sao tăng dần mỗi tháng)
INSERT INTO `reviews` (`id`, `user_id`, `room_id`, `rating`, `comment`, `created_at`) VALUES
-- Tháng 1/2026
(30001, 1106, 401, 1, 'Phòng cách âm rất tệ, tiếng xe chạy dưới đường ồn ào không ngủ được.', '2026-01-07 14:00:00'),
(30002, 1107, 402, 2, 'Diện tích phòng hơi chật, không thoải mái như mô tả.', '2026-01-12 14:00:00'),
(30003, 1108, 405, 3, 'Chất lượng trung bình, bồn tắm hơi bẩn khi tôi nhận phòng.', '2026-01-17 14:00:00'),
(30004, 1109, 406, 4, 'Phòng decor dễ thương, sạch sẽ và thoáng đãng.', '2026-01-22 14:00:00'),
(30005, 1110, 409, 5, 'Rất tuyệt vời! Đón bình minh cực đẹp từ ban công, dịch vụ tốt.', '2026-01-27 14:00:00'),
-- Tháng 2/2026
(30006, 1111, 401, 1, 'Hỏng máy nước nóng không tắm được trong thời tiết lạnh.', '2026-02-07 14:00:00'),
(30007, 1112, 402, 2, 'Chăn ga gối đệm có mùi ẩm mốc khó chịu.', '2026-02-12 14:00:00'),
(30008, 1113, 405, 3, 'Giá hơi đắt so với dịch vụ nhận lại, phòng tương đối rộng.', '2026-02-17 14:00:00'),
(30009, 1114, 406, 4, 'Nội thất còn mới, chủ nhà hỗ trợ check-in muộn nhiệt tình.', '2026-02-22 14:00:00'),
(30010, 1115, 409, 5, 'Quá hoàn hảo cho kỳ nghỉ dưỡng. Không gian sạch sẽ và thoải mái.', '2026-02-27 14:00:00'),
-- Tháng 3/2026
(30011, 1116, 401, 1, 'Điều hòa rò rỉ nước xuống sàn gỗ suốt đêm.', '2026-03-07 14:00:00'),
(30012, 1117, 402, 2, 'Wifi phòng chập chờn liên tục không làm việc được.', '2026-03-12 14:00:00'),
(30013, 1118, 405, 3, 'Không gian tạm ổn, tuy nhiên tivi bị hỏng điều khiển.', '2026-03-17 14:00:00'),
(30014, 1119, 406, 4, 'Phòng ốc thoáng, sạch mát, thiết kế phong cách vintage xinh xắn.', '2026-03-22 14:00:00'),
(30015, 1120, 409, 5, 'Bãi biển rất gần, view hướng ra vịnh cực đẹp. Đáng tiền!', '2026-03-27 14:00:00'),
-- Tháng 4/2026
(30016, 1121, 401, 1, 'Mùi cống nhà vệ sinh bốc lên rất khó chịu.', '2026-04-07 14:00:00'),
(30017, 1122, 402, 2, 'Ánh sáng phòng hơi tối, không thích hợp làm việc.', '2026-04-12 14:00:00'),
(30018, 1123, 405, 3, 'Phòng tắm rộng nhưng nước chảy hơi yếu.', '2026-04-17 14:00:00'),
(30019, 1124, 406, 4, 'Chỗ ở sạch sẽ, vị trí trung tâm tiện di chuyển.', '2026-04-22 14:00:00'),
(30020, 1125, 409, 5, 'Biển xanh cát trắng ngay trước mắt, phục vụ chu đáo tận tình.', '2026-04-27 14:00:00'),
-- Tháng 5/2026
(30021, 1101, 402, 1, 'Hàng xóm làm ồn karaoke suốt đêm không nghỉ.', '2026-05-07 14:00:00'),
(30022, 1102, 405, 2, 'Khóa cửa phòng bị kẹt khó mở, yêu cầu sửa đổi.', '2026-05-12 14:00:00'),
(30023, 1103, 406, 3, 'Chất lượng phòng ở mức khá, không khí xung quanh trong lành.', '2026-05-17 14:00:00'),
(30024, 1104, 409, 4, 'Bể bơi của khu rất sạch, phòng ngủ thoáng đãng view đẹp.', '2026-05-22 14:00:00'),
(30025, 1105, 401, 5, 'Mọi thứ đều hoàn hảo từ giấc ngủ đến cách phục vụ của host.', '2026-05-27 14:00:00'),
-- Tháng 6/2026
(30026, 1106, 402, 1, 'Phòng nhiều muỗi và côn trùng bay vào do cửa ban công hở.', '2026-06-07 14:00:00'),
(30027, 1107, 405, 2, 'Nước ấm dùng được một lúc là hết, phòng tắm hơi trơn trượt.', '2026-06-12 14:00:00'),
(30028, 1108, 406, 3, 'Tạm được, phòng đầy đủ vật dụng nấu ăn cơ bản.', '2026-06-17 14:00:00'),
(30029, 1109, 401, 4, 'Rất sạch sẽ ngăn nắp, drap giường trắng tinh tươm thơm tho.', '2026-06-22 14:00:00'),
(30030, 1110, 402, 5, 'Giá hợp túi tiền, phòng nhỏ xinh ấm cúng và đầy đủ tiện nghi.', '2026-06-27 14:00:00');

