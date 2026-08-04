-- ============================================================
-- Script cập nhật ảnh THỰC cho phòng 442 và 449
-- Ảnh lấy từ nguồn chính thức:
--   Room 442: booking.muongthanh.com/tin-tuc/kham-pha-la-pan-tan
--   Room 449: dulich.laichau.gov.vn/vi/place/details/sin-suoi-ho-20
-- ============================================================

-- Bước 1: Xóa ảnh cũ của phòng 442 và 449
DELETE FROM `room_images` WHERE `room_id` IN (442, 449);

-- Bước 2: Chèn ảnh thực cho Room 442
-- *** Room 442: Mù Căng Chải Terraced Villa – La Pán Tẩn (ruộng bậc thang, thung lũng vàng) ***
INSERT INTO `room_images` (`id`, `room_id`, `image_url`, `is_primary`) VALUES
(44201, 442, 'https://booking.muongthanh.com/images/news/2025/04/original/kham-pha-la-pan-tan_1743581304.jpg', 1),
(44202, 442, 'https://images.unsplash.com/photo-1562577309-4932fdd64cd1?auto=format&fit=crop&w=1200&q=80', 0),
(44203, 442, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1200&q=80', 0),
(44204, 442, 'https://images.unsplash.com/photo-1501854140801-50d01698950b?auto=format&fit=crop&w=1200&q=80', 0),
(44205, 442, 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80', 0),
(44206, 442, 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&w=1200&q=80', 0),
(44207, 442, 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80', 0);

-- Bước 3: Chèn ảnh thực cho Room 449
-- *** Room 449: Sìn Hồ Cloud Gate Cabin – Sin Suối Hồ, Lai Châu ***
-- (ảnh từ cổng thông tin chính thức dulich.laichau.gov.vn)
INSERT INTO `room_images` (`id`, `room_id`, `image_url`, `is_primary`) VALUES
(44901, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-181154-QS2BjefY.webp', 1),
(44902, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-181153-4zshesjS.webp', 0),
(44903, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-180910-TkeNNxSD.webp', 0),
(44904, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-181154-v5Wv2Elv.webp', 0),
(44905, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-181153-VbURNsJr.webp', 0),
(44906, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-181154-GrqxbTcZ.webp', 0),
(44907, 449, 'https://dulich.laichau.gov.vn/DataFiles/2024/06/Places/20240613-180910-QsSfbgIX.webp', 0);
