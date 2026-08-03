<template>
  <div class="min-h-screen" style="background:#f8f9fc">
    <!-- HEADER -->
    <header class="header">
      <div class="container">
        <div class="header-left">
          <RouterLink to="/" class="logo">
            <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
              <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="logo-word building">Building</span>
            <span class="logo-word hotel">Hotel</span>
            <span class="logo-word stay">Stay</span>
          </RouterLink>
        </div>
        <div class="header-right">
          <!-- Language Selector in header -->
          <div class="header-lang-selector-dropdown">
            <button type="button" class="lang-dropdown-btn">
              <span class="flag-icon">
                <svg v-if="locale === 'vi'" viewBox="0 0 30 20" width="18" height="12">
                  <rect width="30" height="20" fill="#da251d"/>
                  <polygon points="15,4 16.2,8.2 20.6,8.2 17.1,10.8 18.4,15 15,12.4 11.6,15 12.9,10.8 9.4,8.2 13.8,8.2" fill="#ffff00"/>
                </svg>
                <svg v-else viewBox="0 0 74 39" width="18" height="9.5">
                  <rect width="74" height="39" fill="#bb133e"/>
                  <path d="M0,3 H74 M0,9 H74 M0,15 H74 M0,21 H74 M0,27 H74 M0,33 H74" stroke="#fff" stroke-width="3"/>
                  <rect width="30" height="21" fill="#002147"/>
                  <circle cx="6" cy="5" r="1" fill="#fff"/>
                  <circle cx="15" cy="5" r="1" fill="#fff"/>
                  <circle cx="24" cy="5" r="1" fill="#fff"/>
                  <circle cx="10.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="19.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="6" cy="16" r="1" fill="#fff"/>
                  <circle cx="15" cy="16" r="1" fill="#fff"/>
                  <circle cx="24" cy="16" r="1" fill="#fff"/>
                </svg>
              </span>
              <span class="lang-text-active">{{ locale === 'vi' ? 'Tiếng Việt' : 'English' }}</span>
              <span class="dropdown-chevron">▼</span>
            </button>
            <div class="lang-dropdown-menu">
              <button type="button" class="lang-dropdown-item" :class="{ active: locale === 'vi' }" @click="changeLanguage('vi')">
                <svg viewBox="0 0 30 20" width="16" height="10.7" style="margin-right: 8px;">
                  <rect width="30" height="20" fill="#da251d"/>
                  <polygon points="15,4 16.2,8.2 20.6,8.2 17.1,10.8 18.4,15 15,12.4 11.6,15 12.9,10.8 9.4,8.2 13.8,8.2" fill="#ffff00"/>
                </svg>
                Tiếng Việt
              </button>
              <button type="button" class="lang-dropdown-item" :class="{ active: locale === 'en' }" @click="changeLanguage('en')">
                <svg viewBox="0 0 74 39" width="16" height="8.4" style="margin-right: 8px;">
                  <rect width="74" height="39" fill="#bb133e"/>
                  <path d="M0,3 H74 M0,9 H74 M0,15 H74 M0,21 H74 M0,27 H74 M0,33 H74" stroke="#fff" stroke-width="3"/>
                  <rect width="30" height="21" fill="#002147"/>
                  <circle cx="6" cy="5" r="1" fill="#fff"/>
                  <circle cx="15" cy="5" r="1" fill="#fff"/>
                  <circle cx="24" cy="5" r="1" fill="#fff"/>
                  <circle cx="10.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="19.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="6" cy="16" r="1" fill="#fff"/>
                  <circle cx="15" cy="16" r="1" fill="#fff"/>
                  <circle cx="24" cy="16" r="1" fill="#fff"/>
                </svg>
                English
              </button>
            </div>
          </div>

          <RouterLink to="/" class="btn-back">
            {{ $t('nav.back_home') }}
          </RouterLink>
          <span class="user-name" v-if="authStore.isLoggedIn" @click="openProfileModal" style="cursor: pointer; font-weight: 600; color: #1e3a8a; text-decoration: underline; text-underline-offset: 3px; display: inline-flex; align-items: center; gap: 4px; margin-right: 8px;">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            {{ authStore.user?.fullName }}
          </span>
          <button class="btn-outline" @click="handleLogout">{{ $t('nav.logout') }}</button>
        </div>
      </div>
    </header>

    <main class="container main-content">
      <div class="page-header">
        <h1>{{ $t('booking.title') }}</h1>
        <p>{{ $t('booking.sub') }}</p>
      </div>

      <!-- TABS -->
      <div class="tabs-container">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          class="tab-btn"
          :class="{ active: activeTab === tab.id }"
          @click="activeTab = tab.id"
        >
          {{ tab.name }}
          <span class="tab-count">{{ getCountByStatus(tab.statusList) }}</span>
        </button>
      </div>

      <!-- LIST OF BOOKINGS -->
      <div class="bookings-list" v-if="activeTab !== 'vouchers' && filteredBookings.length > 0">
        <div
          v-for="booking in paginatedBookings"
          :key="booking.id"
          class="booking-card"
        >
          <div class="booking-img-wrap">
            <img :src="booking.roomImage" :alt="booking.roomName" />
            <span class="status-badge" :class="booking.status.toLowerCase()">
              {{ getStatusLabel(booking.status) }}
            </span>
          </div>

          <div class="booking-details">
            <span class="booking-id-tag">{{ $t('booking.id') }}: #{{ booking.id }}</span>
            <h3>{{ booking.roomName }}</h3>
            <p class="addr-text"><MapPin :size="14" /> {{ booking.address }}, {{ booking.city }}</p>

            <div class="booking-info-row">
              <div class="info-block">
                <span class="label"><Calendar :size="14" /> {{ $t('search.check_in').toUpperCase() }}</span>
                <span class="value">{{ formatDate(booking.checkIn) }}</span>
              </div>
              <div class="arrow-icon">→</div>
              <div class="info-block">
                <span class="label"><Calendar :size="14" /> {{ $t('search.check_out').toUpperCase() }}</span>
                <span class="value">{{ formatDate(booking.checkOut) }}</span>
              </div>
              <div class="info-block guests">
                <span class="label"><Users :size="14" /> {{ $t('booking.guests') }}</span>
                <span class="value">{{ booking.guestName }}</span>
              </div>
            </div>

            <div class="booking-footer">
              <div class="price-section">
                <span class="label">{{ $t('booking.total_price') }}</span>
                <span class="price-val">{{ formatPrice(booking.totalPrice) }}</span>
              </div>
              <div class="actions-section">
                <!-- Cancel button only if status is PENDING -->
                <button
                  v-if="booking.status === 'PENDING'"
                  class="btn-cancel-booking"
                  @click="confirmCancel(booking)"
                  :disabled="cancellingId === booking.id"
                >
                  <span v-if="cancellingId !== booking.id">{{ $t('booking.cancel_request') }}</span>
                  <span v-else class="spinner-small"></span>
                </button>

                <!-- Continue payment button: for PENDING/CONFIRMED + not paid -->
                <button
                  v-if="(booking.status === 'PENDING' || booking.status === 'CONFIRMED') && !booking.paid"
                  class="btn-continue-pay"
                  @click="continuePayment(booking)"
                >
                  {{ locale === 'vi' ? 'Tiếp tục thanh toán' : 'Continue payment' }}
                </button>

                <!-- Review button if status is COMPLETED -->
                <button
                  v-if="booking.status === 'COMPLETED'"
                  :class="booking.hasReview ? 'btn-view-review' : 'btn-write-review'"
                  @click="openReviewModal(booking)"
                >
                  <Star :size="14" :fill="booking.hasReview ? 'currentColor' : 'none'" style="margin-right: 0.25rem;" />
                  {{ booking.hasReview ? (locale === 'vi' ? 'Xem đánh giá của bạn' : 'View your review') : (locale === 'vi' ? 'Đánh giá chỗ nghỉ' : 'Rate this property') }}
                </button>

                <button class="btn-view-receipt" @click="viewReceipt(booking)">
                  {{ locale === 'vi' ? 'Xem chi tiết hóa đơn' : 'View invoice details' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- VOUCHERS LIST (my-wallet) -->
      <div class="vouchers-list" v-else-if="activeTab === 'vouchers' && myVouchers.length > 0">
        <div class="voucher-wallet-grid">
          <div
            v-for="voucher in myVouchers"
            :key="voucher.userPromotionId || voucher.code"
            class="my-voucher-card"
          >
            <!-- Left: Ticket Value Badge -->
            <div class="mvc-left">
              <span class="mvc-val-num">
                {{ voucher.discountType === 'PERCENT' ? `${voucher.discountValue}%` : formatPriceShort(voucher.discountValue) }}
              </span>
              <span class="mvc-val-lbl">{{ locale === 'vi' ? 'GIẢM GIÁ' : 'DISCOUNT' }}</span>
              
              <div class="mvc-circle-t"></div>
              <div class="mvc-circle-b"></div>
            </div>

            <!-- Right: Content -->
            <div class="mvc-right">
              <div class="mvc-top">
                <span class="mvc-code-pill">{{ voucher.code }}</span>
                <span class="mvc-expiry-badge" :class="getExpiryBadgeClass(voucher.endDate)">
                  {{ getExpiryBadgeText(voucher.endDate) }}
                </span>
              </div>
              <h3 class="mvc-title">{{ voucher.description }}</h3>
              <p class="mvc-min-order">{{ locale === 'vi' ? 'Đơn tối thiểu' : 'Min spend' }}: <strong>{{ formatPrice(voucher.minOrderAmount || 0) }}</strong></p>
              
              <div class="mvc-footer">
                <span class="mvc-hsd">{{ locale === 'vi' ? 'Hạn sử dụng' : 'Expiry date' }}: {{ formatDateShort(voucher.endDate) }}</span>
                <RouterLink to="/" class="btn-mvc-use">{{ locale === 'vi' ? 'Dùng ngay' : 'Use now' }}</RouterLink>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- PAGINATION (Only for bookings) -->
      <div class="pagination-bar" v-if="activeTab !== 'vouchers' && totalPages > 1">
        <button class="pg-btn" :disabled="currentPage === 1" @click="currentPage = 1" title="Trang đầu">
          «
        </button>
        <button class="pg-btn" :disabled="currentPage === 1" @click="currentPage--" title="Trang trước">
          ‹
        </button>

        <template v-for="p in pageNumbers" :key="p">
          <span v-if="p === '...'" class="pg-ellipsis">…</span>
          <button
            v-else
            class="pg-btn"
            :class="{ active: p === currentPage }"
            @click="currentPage = p"
          >{{ p }}</button>
        </template>

        <button class="pg-btn" :disabled="currentPage === totalPages" @click="currentPage++" title="Trang sau">
          ›
        </button>
        <button class="pg-btn" :disabled="currentPage === totalPages" @click="currentPage = totalPages" title="Trang cuối">
          »
        </button>

        <span class="pg-info">{{ locale === 'vi' ? 'Trang' : 'Page' }} {{ currentPage }} / {{ totalPages }} · {{ filteredBookings.length }} {{ locale === 'vi' ? 'đơn' : 'bookings' }}</span>
      </div>

      <!-- NO BOOKINGS -->
      <div class="empty-state" v-else-if="activeTab !== 'vouchers' && filteredBookings.length === 0">
        <div class="empty-icon"><FileText :size="48" /></div>
        <h3>{{ locale === 'vi' ? 'Không tìm thấy đơn đặt phòng nào' : 'No bookings found' }}</h3>
        <p>{{ locale === 'vi' ? 'Bạn không có đơn đặt phòng nào thuộc danh mục này.' : 'You have no bookings under this category.' }}</p>
        <RouterLink to="/" class="btn-discover">{{ locale === 'vi' ? 'Khám phá phòng ngay' : 'Discover rooms now' }}</RouterLink>
      </div>

      <!-- NO VOUCHERS -->
      <div class="empty-state" v-else-if="activeTab === 'vouchers' && myVouchers.length === 0">
        <div class="empty-icon"><Tag :size="48" style="color: #64748b;" /></div>
        <h3>{{ locale === 'vi' ? 'Ví voucher trống' : 'Voucher wallet is empty' }}</h3>
        <p>{{ locale === 'vi' ? 'Bạn chưa lưu mã khuyến mãi nào vào ví cá nhân.' : 'You have not saved any vouchers to your wallet.' }}</p>
        <RouterLink to="/" class="btn-discover">{{ locale === 'vi' ? 'Săn voucher ngay' : 'Find vouchers now' }}</RouterLink>
      </div>
    </main>

    <!-- CANCEL CONFIRMATION MODAL -->
    <div class="modal-backdrop" v-if="showCancelModal">
      <div class="confirm-modal">
        <h3>{{ locale === 'vi' ? 'Xác nhận hủy đặt phòng?' : 'Confirm cancellation?' }}</h3>
        <p>{{ locale === 'vi' ? 'Hành động hủy phòng' : 'Cancellation of room' }} <strong>#{{ selectedBooking?.id }}</strong> {{ locale === 'vi' ? 'tại' : 'at' }} <strong>{{ selectedBooking?.roomName }}</strong> {{ locale === 'vi' ? 'là không thể khôi phục. Bạn có chắc chắn muốn tiếp tục?' : 'is irreversible. Are you sure you want to proceed?' }}</p>
        <div class="modal-actions">
          <button class="btn-modal-cancel" @click="showCancelModal = false">{{ locale === 'vi' ? 'Đóng' : 'Close' }}</button>
          <button class="btn-modal-confirm" @click="executeCancel" :disabled="cancelLoading">
            <span v-if="!cancelLoading">{{ locale === 'vi' ? 'Xác nhận hủy phòng' : 'Confirm cancellation' }}</span>
            <span v-else class="spinner-small"></span>
          </button>
        </div>
      </div>
    </div>

    <!-- DETAIL RECEIPT MODAL -->
    <div class="modal-backdrop" v-if="showReceiptModal && receiptBooking">
      <div class="receipt-modal">
        <div class="receipt-header">
          <h2>{{ locale === 'vi' ? 'Chi tiết biên nhận đặt phòng' : 'Booking Receipt Details' }}</h2>
          <button class="btn-close-modal" @click="showReceiptModal = false">×</button>
        </div>
        <div class="receipt-body">
          <div class="receipt-top-row">
            <div>
              <p class="receipt-id">{{ locale === 'vi' ? 'HÓA ĐƠN' : 'INVOICE' }} #{{ receiptBooking.id }}</p>
              <p class="receipt-date">{{ locale === 'vi' ? 'Ngày tạo' : 'Created date' }}: {{ formatDateTime(receiptBooking.createdAt) }}</p>
            </div>
            <span class="status-badge" :class="receiptBooking.status.toLowerCase()">
              {{ getStatusLabel(receiptBooking.status) }}
            </span>
          </div>

          <div class="receipt-section">
            <h4>{{ locale === 'vi' ? 'Thông tin chỗ nghỉ' : 'Property Information' }}</h4>
            <p class="property-title">{{ receiptBooking.roomName }}</p>
            <p class="property-addr">{{ receiptBooking.address }}, {{ receiptBooking.city }}</p>
          </div>

          <div class="receipt-section grid-2">
            <div>
              <h4>{{ locale === 'vi' ? 'Nhận phòng (Check-in)' : 'Check-in' }}</h4>
              <p class="receipt-val">{{ formatDate(receiptBooking.checkIn) }}</p>
              <small>{{ locale === 'vi' ? 'Sau 14:00' : 'After 14:00' }}</small>
            </div>
            <div>
              <h4>{{ locale === 'vi' ? 'Trả phòng (Check-out)' : 'Check-out' }}</h4>
              <p class="receipt-val">{{ formatDate(receiptBooking.checkOut) }}</p>
              <small>{{ locale === 'vi' ? 'Trước 12:00' : 'Before 12:00' }}</small>
            </div>
          </div>

          <div class="receipt-section">
            <h4>{{ locale === 'vi' ? 'Thông tin khách hàng' : 'Customer Information' }}</h4>
            <p>{{ locale === 'vi' ? 'Khách hàng' : 'Customer' }}: <strong>{{ receiptBooking.guestName }}</strong></p>
            <p>Email: <strong>{{ receiptBooking.guestEmail }}</strong></p>
            <p>{{ locale === 'vi' ? 'Số điện thoại' : 'Phone' }}: <strong>{{ receiptBooking.guestPhone }}</strong></p>
          </div>

          <div class="receipt-section billing">
            <h4>{{ locale === 'vi' ? 'Chi tiết thanh toán' : 'Payment Details' }}</h4>
            <div class="billing-row">
              <span>{{ locale === 'vi' ? 'Đơn giá phòng' : 'Room rate' }}</span>
              <span>{{ locale === 'vi' ? 'Đã bao gồm trong tổng thanh toán' : 'Included in total' }}</span>
            </div>
            <div class="billing-row total">
              <span>{{ locale === 'vi' ? 'Tổng chi phí đã thanh toán' : 'Total cost paid' }}</span>
              <span class="total-val">{{ formatPrice(receiptBooking.totalPrice) }}</span>
            </div>
          </div>
        </div>
        <div class="receipt-footer-btn">
          <button @click="showReceiptModal = false" class="btn-receipt-close">{{ locale === 'vi' ? 'Đóng' : 'Close' }}</button>
        </div>
      </div>
    </div>

    <!-- REVIEW MODAL -->
    <div class="modal-backdrop" v-if="showReviewModal && reviewBooking">
      <div class="review-modal">
        <div class="modal-header">
          <h2>{{ isReadOnlyReview ? (locale === 'vi' ? 'Đánh giá của bạn' : 'Your review') : (locale === 'vi' ? 'Đánh giá phòng nghỉ' : 'Rate this room') }}</h2>
          <button class="btn-close-modal" @click="closeReviewModal">×</button>
        </div>
        <div class="modal-body">
          <!-- Room Preview -->
          <div class="modal-room-preview">
            <img :src="reviewBooking.roomImage" :alt="reviewBooking.roomName" class="preview-img" />
            <div class="preview-details">
              <span class="preview-id">{{ locale === 'vi' ? 'Đặt phòng' : 'Booking' }} #{{ reviewBooking.id }}</span>
              <h3 class="preview-name">{{ reviewBooking.roomName }}</h3>
              <p class="preview-dates">
                <Calendar :size="12" style="margin-right: 0.25rem; flex-shrink: 0;" />
                {{ formatDate(reviewBooking.checkIn) }} - {{ formatDate(reviewBooking.checkOut) }}
              </p>
            </div>
          </div>
          
          <!-- Stars selector -->
          <div class="stars-selector-group">
            <label class="section-label">{{ locale === 'vi' ? 'Đánh giá của bạn' : 'Your rating' }}</label>
            <div class="stars-row-interactive">
              <div class="stars-list" :style="isReadOnlyReview ? 'pointer-events: none;' : ''">
                <Star 
                  v-for="star in 5" 
                  :key="star" 
                  :size="38" 
                  class="star-item-interactive"
                  :class="{ 'filled': star <= (hoverRating || reviewForm.rating) }"
                  @mouseenter="isReadOnlyReview ? null : hoverRating = star"
                  @mouseleave="isReadOnlyReview ? null : hoverRating = 0"
                  @click="isReadOnlyReview ? null : reviewForm.rating = star"
                  fill="currentColor"
                />
              </div>
              <div 
                class="rating-badge" 
                :class="'rating-' + (hoverRating || reviewForm.rating)"
                v-if="hoverRating || reviewForm.rating"
              >
                <span class="badge-emoji">{{ getRatingEmoji(hoverRating || reviewForm.rating) }}</span>
                <span class="badge-text">{{ getRatingLabel(hoverRating || reviewForm.rating) }}</span>
              </div>
            </div>
          </div>

          <!-- Comment textarea -->
          <div class="form-group comment-input-group">
            <div class="label-row">
              <label class="section-label">{{ locale === 'vi' ? 'Nhận xét của bạn' : 'Your comment' }}</label>
              <span v-if="!isReadOnlyReview" class="char-count" :class="{ 'max-reached': reviewForm.comment.length >= 500 }">
                {{ reviewForm.comment.length }}/500
              </span>
            </div>
            <textarea 
              v-model="reviewForm.comment" 
              :placeholder="locale === 'vi' ? 'Chia sẻ trải nghiệm thực tế của bạn về phòng nghỉ này (vị trí, sự phục vụ, độ sạch sẽ, tiện nghi...)' : 'Share your real experience about this room (location, service, cleanliness, amenities...)'" 
              rows="4"
              maxlength="500"
              required
              :readonly="isReadOnlyReview"
            ></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn-review-cancel" @click="closeReviewModal">{{ locale === 'vi' ? 'Đóng' : 'Close' }}</button>
          <button 
            v-if="!isReadOnlyReview"
            type="button" 
            class="btn-review-submit" 
            @click="submitReview" 
            :disabled="reviewLoading || !reviewForm.rating || !reviewForm.comment.trim()"
          >
            <span v-if="!reviewLoading">{{ locale === 'vi' ? 'Gửi đánh giá' : 'Submit review' }}</span>
            <span v-else class="spinner-loader"></span>
          </button>
        </div>
      </div>
    </div>
    <!-- PROFILE SETTINGS MODAL -->
    <div class="modal-backdrop" v-if="showProfileModal" style="z-index: 1200; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; padding: 20px;">
      <div style="background: white; border-radius: 20px; max-width: 600px; width: 100%; max-height: 90vh; overflow-y: auto; padding: 28px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04); border: 1px solid #f1f5f9; display: flex; flex-direction: column; gap: 24px; position: relative; font-family: inherit;">
        <!-- Close button -->
        <button type="button" @click="showProfileModal = false" style="position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #94a3b8; font-weight: 300; transition: color 0.2s;" onmouseover="this.style.color='#0f172a'" onmouseout="this.style.color='#94a3b8'">×</button>
        
        <div>
          <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin: 0 0 4px 0; display: flex; align-items: center; gap: 8px;">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #2563eb;">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            {{ locale === 'vi' ? 'Hồ sơ cá nhân' : 'Personal Profile' }}
          </h3>
          <p style="font-size: 0.85rem; color: #64748b; margin: 0;">{{ locale === 'vi' ? 'Quản lý thông tin cá nhân và tài khoản của bạn.' : 'Manage your personal profile and account settings.' }}</p>
        </div>

        <!-- Personal Info Form -->
        <form @submit.prevent="handleUpdateProfile" style="display: flex; flex-direction: column; gap: 16px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px; text-align: left;">
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Họ và tên' : 'Full Name' }}</label>
              <input type="text" v-model="profileForm.fullName" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
            </div>
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">Email</label>
              <input type="email" :value="profileForm.email" disabled style="padding: 10px 12px; border-radius: 8px; border: 1px solid #e2e8f0; background: #f8fafc; color: #94a3b8; font-size: 0.9rem;" />
            </div>
          </div>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Số điện thoại' : 'Phone Number' }}</label>
              <input type="text" v-model="profileForm.phone" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" />
            </div>
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Ảnh đại diện (URL)' : 'Avatar URL' }}</label>
              <input type="text" v-model="profileForm.avatarUrl" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" />
            </div>
          </div>
          <button type="submit" :disabled="updatingProfile" style="width: fit-content; align-self: flex-end; padding: 10px 24px; border-radius: 8px; border: none; background: #2563eb; color: white; font-weight: 700; cursor: pointer; transition: opacity 0.2s;">
            <span v-if="updatingProfile">{{ locale === 'vi' ? 'Đang lưu...' : 'Saving...' }}</span>
            <span v-else>{{ locale === 'vi' ? 'Lưu thay đổi' : 'Save Changes' }}</span>
          </button>
        </form>

        <!-- Change Password Form -->
        <form @submit.prevent="handleUpdatePassword" style="display: flex; flex-direction: column; gap: 16px; text-align: left;">
          <h4 style="font-size: 0.95rem; font-weight: 800; color: #0f172a; margin: 0; display: flex; align-items: center; gap: 6px;">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #ef4444;">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg>
            {{ locale === 'vi' ? 'Đổi mật khẩu tài khoản' : 'Change Account Password' }}
          </h4>
          <div style="display: flex; flex-direction: column; gap: 6px;">
            <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Mật khẩu hiện tại' : 'Current Password' }}</label>
            <input type="password" v-model="passwordForm.oldPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
          </div>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Mật khẩu mới' : 'New Password' }}</label>
              <input type="password" v-model="passwordForm.newPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
            </div>
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Xác nhận mật khẩu mới' : 'Confirm New Password' }}</label>
              <input type="password" v-model="passwordForm.confirmPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
            </div>
          </div>
          <button type="submit" :disabled="updatingPassword" style="width: fit-content; align-self: flex-end; padding: 10px 24px; border-radius: 8px; border: none; background: #ef4444; color: white; font-weight: 700; cursor: pointer; transition: opacity 0.2s;">
            <span v-if="updatingPassword">{{ locale === 'vi' ? 'Đang cập nhật...' : 'Updating...' }}</span>
            <span v-else>{{ locale === 'vi' ? 'Đổi mật khẩu' : 'Update Password' }}</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useToastStore } from '../stores/toast'
import { useI18n } from 'vue-i18n'
import axios from '../api/axios'
import { MapPin, Calendar, Users, FileText, Star, Tag } from 'lucide-vue-next'
import { getProfile, updateProfile, changePassword } from '../api/users'

const router = useRouter()
const authStore = useAuthStore()
const toastStore = useToastStore()
const { t, locale } = useI18n()

// Profile settings variables
const showProfileModal = ref(false)
const profileForm = ref({
  fullName: '',
  email: '',
  phone: '',
  avatarUrl: ''
})
const updatingProfile = ref(false)

const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})
const updatingPassword = ref(false)

const openProfileModal = async () => {
  showProfileModal.value = true
  await fetchUserProfile()
}

const fetchUserProfile = async () => {
  try {
    const res = await getProfile()
    profileForm.value.fullName = res.data.fullName || ''
    profileForm.value.email = res.data.email || ''
    profileForm.value.phone = res.data.phone || ''
    profileForm.value.avatarUrl = res.data.avatarUrl || ''

    if (authStore.user) {
      authStore.user.fullName = res.data.fullName
      localStorage.setItem('user', JSON.stringify(authStore.user))
    }
  } catch (err) {
    console.error('Lỗi khi tải thông tin cá nhân:', err)
  }
}

const handleUpdateProfile = async () => {
  updatingProfile.value = true
  try {
    const res = await updateProfile({
      fullName: profileForm.value.fullName,
      phone: profileForm.value.phone,
      avatarUrl: profileForm.value.avatarUrl
    })
    toastStore.success(locale.value === 'vi' ? 'Cập nhật thông tin thành công!' : 'Profile updated successfully!')
    if (authStore.user) {
      authStore.user.fullName = res.data.fullName
      localStorage.setItem('user', JSON.stringify(authStore.user))
    }
  } catch (err) {
    console.error('Lỗi khi cập nhật thông tin:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Cập nhật thông tin thất bại!' : 'Failed to update profile!'))
  } finally {
    updatingProfile.value = false
  }
}

const handleUpdatePassword = async () => {
  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    toastStore.error(locale.value === 'vi' ? 'Mật khẩu xác nhận không khớp!' : 'Confirm password does not match!')
    return
  }
  updatingPassword.value = true
  try {
    await changePassword({
      oldPassword: passwordForm.value.oldPassword,
      newPassword: passwordForm.value.newPassword
    })
    toastStore.success(locale.value === 'vi' ? 'Đổi mật khẩu thành công!' : 'Password updated successfully!')
    passwordForm.value.oldPassword = ''
    passwordForm.value.newPassword = ''
    passwordForm.value.confirmPassword = ''
  } catch (err) {
    console.error('Lỗi khi đổi mật khẩu:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Đổi mật khẩu thất bại!' : 'Failed to change password!'))
  } finally {
    updatingPassword.value = false
  }
}

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const bookings = ref([])
const myVouchers = ref([])
const vouchersLoading = ref(false)
const activeTab = ref('upcoming')
const cancellingId = ref(null)
const momoLoadingId = ref(null)

// Pagination
const currentPage = ref(1)
const PAGE_SIZE = 5

const showCancelModal = ref(false)
const selectedBooking = ref(null)
const cancelLoading = ref(false)

const showReceiptModal = ref(false)
const receiptBooking = ref(null)

// Review States
const showReviewModal = ref(false)
const reviewBooking = ref(null)
const hoverRating = ref(0)
const reviewLoading = ref(false)
const reviewForm = ref({
  rating: 5,
  comment: ''
})

const tabs = computed(() => [
  { id: 'upcoming',  name: t('booking.active'), statusList: ['PENDING', 'CONFIRMED'] },
  { id: 'completed', name: t('booking.history'), statusList: ['COMPLETED'] },
  { id: 'cancelled', name: t('booking.cancelled'), statusList: ['CANCELLED'] },
  { id: 'vouchers', name: t('booking.vouchers'), statusList: [] }
])

// Reset page when switching tabs
watch(activeTab, () => { currentPage.value = 1 })

const getCountByStatus = (statusList) => {
  if (!statusList || statusList.length === 0) {
    return myVouchers.value.length
  }
  return bookings.value.filter(b => statusList.includes(b.status)).length
}

const filteredBookings = computed(() => {
  const currentTab = tabs.value.find(t => t.id === activeTab.value)
  if (!currentTab) return []
  return bookings.value.filter(b => currentTab.statusList.includes(b.status))
})

const totalPages = computed(() => Math.ceil(filteredBookings.value.length / PAGE_SIZE))

const paginatedBookings = computed(() => {
  const start = (currentPage.value - 1) * PAGE_SIZE
  return filteredBookings.value.slice(start, start + PAGE_SIZE)
})

const pageNumbers = computed(() => {
  const total = totalPages.value
  const cur = currentPage.value
  const pages = []
  if (total <= 7) {
    for (let i = 1; i <= total; i++) pages.push(i)
    return pages
  }
  pages.push(1)
  if (cur > 3) pages.push('...')
  const start = Math.max(2, cur - 1)
  const end = Math.min(total - 1, cur + 1)
  for (let i = start; i <= end; i++) pages.push(i)
  if (cur < total - 2) pages.push('...')
  pages.push(total)
  return pages
})

const getStatusLabel = (status) => {
  switch (status) {
    case 'PENDING': return locale.value === 'vi' ? 'Chờ xác nhận' : 'Pending'
    case 'CONFIRMED': return locale.value === 'vi' ? 'Đã xác nhận' : 'Confirmed'
    case 'COMPLETED': return locale.value === 'vi' ? 'Đã hoàn thành' : 'Completed'
    case 'CANCELLED': return locale.value === 'vi' ? 'Đã hủy bỏ' : 'Cancelled'
    default: return status
  }
}

const continuePayment = (booking) => {
  const checkInDate = new Date(booking.checkIn)
  const checkOutDate = new Date(booking.checkOut)
  const diffTime = Math.abs(checkOutDate - checkInDate)
  const nights = Math.max(1, Math.ceil(diffTime / (1000 * 60 * 60 * 24)))
  const pricePerNight = Math.round(booking.totalPrice / nights)

  router.push({
    path: '/payment',
    query: {
      bookingId: booking.id,
      roomId: booking.roomId,
      roomName: booking.roomName,
      roomType: 'Deluxe',
      city: booking.city,
      image: booking.roomImage || '',
      rating: 4.8,
      price: pricePerNight,
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      guests: booking.numGuests || 1,
      nights: nights,
    }
  })
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  return d.toLocaleDateString(locale.value === 'vi' ? 'vi-VN' : 'en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })
}

const formatDateTime = (dateTimeStr) => {
  if (!dateTimeStr) return ''
  const d = new Date(dateTimeStr)
  return d.toLocaleString(locale.value === 'vi' ? 'vi-VN' : 'en-US')
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
}

const fetchBookings = async () => {
  try {
    const res = await axios.get('/bookings/my')
    bookings.value = res.data
  } catch (err) {
    console.error('Lấy danh sách đặt phòng thất bại:', err)
  }
}

const fetchMyVouchers = async () => {
  vouchersLoading.value = true
  try {
    const res = await axios.get('/promotions/my-wallet')
    myVouchers.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Lấy danh sách ví voucher thất bại:', err)
  } finally {
    vouchersLoading.value = false
  }
}

const getDaysRemaining = (endDateStr) => {
  if (!endDateStr) return 999
  const end = new Date(endDateStr)
  const today = new Date()
  end.setHours(0,0,0,0)
  today.setHours(0,0,0,0)
  const diffTime = end.getTime() - today.getTime()
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24))
}

const getExpiryBadgeClass = (endDateStr) => {
  const days = getDaysRemaining(endDateStr)
  if (days < 0) return 'expired'
  if (days <= 3) return 'near-expiry'
  return 'active-expiry'
}

const getExpiryBadgeText = (endDateStr) => {
  const days = getDaysRemaining(endDateStr)
  if (days < 0) return t('deals.expired')
  if (days === 0) return t('deals.expiry_today')
  if (days === 1) return locale.value === 'vi' ? 'Còn 1 ngày' : '1 day left'
  if (days <= 3) return locale.value === 'vi' ? `Sắp hết hạn (Còn ${days} ngày)` : `Expiring soon (${days} days left)`
  return locale.value === 'vi' ? `Còn ${days} ngày` : `${days} days left`
}

const formatDateShort = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  const day = String(d.getDate()).padStart(2, '0')
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const year = d.getFullYear()
  return `${day}/${month}/${year}`
}

const formatPriceShort = (val) => {
  if (!val) return '0'
  if (val >= 1000000) {
    return (val / 1000000).toFixed(0) + 'Tr'
  }
  if (val >= 1000) {
    return (val / 1000).toFixed(0) + 'K'
  }
  return val + 'đ'
}

const confirmCancel = (booking) => {
  selectedBooking.value = booking
  showCancelModal.value = true
}

const executeCancel = async () => {
  if (!selectedBooking.value) return
  cancelLoading.value = true
  cancellingId.value = selectedBooking.value.id
  try {
    await axios.patch(`/bookings/${selectedBooking.value.id}/cancel`)
    
    // Update local booking status
    const idx = bookings.value.findIndex(b => b.id === selectedBooking.value.id)
    if (idx !== -1) {
      bookings.value[idx].status = 'CANCELLED'
    }
    toastStore.success(t('booking.success_cancel'))
    showCancelModal.value = false
  } catch (err) {
    console.error('Hủy đặt phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || t('booking.fail_cancel'))
  } finally {
    cancelLoading.value = false
    cancellingId.value = null
    selectedBooking.value = null
  }
}

const viewReceipt = (booking) => {
  receiptBooking.value = booking
  showReceiptModal.value = true
}

const isReadOnlyReview = ref(false)

const openReviewModal = async (booking) => {
  reviewBooking.value = booking
  hoverRating.value = 0
  
  if (booking.hasReview) {
    isReadOnlyReview.value = true
    reviewLoading.value = true
    showReviewModal.value = true
    try {
      const roomId = booking.roomId || booking.room?.id || booking.room
      const res = await axios.get(`/reviews/room/${roomId}/my`)
      reviewForm.value = {
        rating: res.data.rating || 5,
        comment: res.data.comment || ''
      }
    } catch (err) {
      console.error('Lấy thông tin đánh giá thất bại:', err)
      toastStore.error('Không thể tải thông tin đánh giá.')
      showReviewModal.value = false
    } finally {
      reviewLoading.value = false
    }
  } else {
    isReadOnlyReview.value = false
    reviewForm.value = {
      rating: 5,
      comment: ''
    }
    showReviewModal.value = true
  }
}

const closeReviewModal = () => {
  showReviewModal.value = false
  reviewBooking.value = null
}

const getRatingLabel = (rating) => {
  switch (rating) {
    case 1: return 'Rất tệ'
    case 2: return 'Tệ'
    case 3: return 'Bình thường'
    case 4: return 'Tốt'
    case 5: return 'Rất tuyệt vời!'
    default: return 'Chọn số sao'
  }
}

const getRatingEmoji = (rating) => {
  switch (rating) {
    case 1: return '😠'
    case 2: return '🙁'
    case 3: return '😐'
    case 4: return '🙂'
    case 5: return '😍'
    default: return ''
  }
}

const submitReview = async () => {
  if (!reviewForm.value.rating) {
    toastStore.warning('Vui lòng chọn số sao đánh giá.')
    return
  }
  if (!reviewForm.value.comment.trim()) {
    toastStore.warning('Vui lòng nhập bình luận đánh giá.')
    return
  }

  reviewLoading.value = true
  const roomId = reviewBooking.value.roomId || reviewBooking.value.room?.id || reviewBooking.value.room
  
  const payload = {
    roomId: roomId,
    rating: reviewForm.value.rating,
    comment: reviewForm.value.comment.trim()
  }

  try {
    await axios.post('/reviews', payload)
    toastStore.success('Cảm ơn bạn đã gửi đánh giá!')
    
    if (reviewBooking.value) {
      reviewBooking.value.hasReview = true
    }
    
    closeReviewModal()
  } catch (err) {
    console.error('Gửi đánh giá thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại.')
  } finally {
    reviewLoading.value = false
  }
}

const handleLogout = () => {
  authStore.logout()
  router.push('/')
}

onMounted(() => {
  if (!authStore.isLoggedIn) {
    router.push('/login')
  } else if (authStore.role !== 'CUSTOMER') {
    router.push('/')
  } else {
    fetchBookings()
    fetchMyVouchers()
    fetchUserProfile()
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; background: #f8f9fc; color: #1e293b; }
.container { max-width: 1000px; margin: 0 auto; padding: 0 1.5rem; }
.min-h-screen { min-height: 100vh; display: flex; flex-direction: column; font-family: 'Inter', sans-serif; }

/* HEADER */
.header {
  background: white; border-bottom: 1px solid #e2e8f0;
  position: sticky; top: 0; z-index: 50; padding: 0.9rem 0;
}
.header .container { display: flex; justify-content: space-between; align-items: center; }
.logo { font-size: 1.4rem; font-weight: 800; letter-spacing: -0.05em; color: #1a6cf7; text-decoration: none; }
.logo-red { color: #ff567d; }
.header-right { display: flex; align-items: center; gap: 1rem; }
.btn-back { font-size: 0.875rem; font-weight: 600; color: #64748b; text-decoration: none; transition: color 0.2s; }
.btn-back:hover { color: #1a6cf7; }
.user-name { font-size: 0.875rem; font-weight: 600; color: #1e293b; }
.btn-outline {
  padding: 0.45rem 1.1rem; border-radius: 999px; font-size: 0.85rem; font-weight: 600;
  border: 1.5px solid #1a6cf7; color: #1a6cf7; background: transparent;
  cursor: pointer; text-decoration: none; transition: all 0.2s;
}
.btn-outline:hover { background: #1a6cf7; color: white; }

/* MAIN CONTENT */
.main-content { padding-top: 3rem; padding-bottom: 5rem; }
.page-header { margin-bottom: 2rem; }
.page-header h1 { font-size: 2rem; font-weight: 800; color: #0f172a; margin-bottom: 0.4rem; letter-spacing: -0.02em; }
.page-header p { color: #64748b; font-size: 0.95rem; }

/* TABS */
.tabs-container { display: flex; gap: 0.5rem; border-bottom: 2px solid #e2e8f0; margin-bottom: 2rem; overflow-x: auto; }
.tab-btn {
  background: none; border: none; padding: 0.9rem 1.25rem; font-size: 0.95rem; font-weight: 600;
  color: #64748b; cursor: pointer; transition: all 0.2s; border-bottom: 2px solid transparent;
  margin-bottom: -2px; white-space: nowrap; display: flex; align-items: center; gap: 0.5rem;
  font-family: 'Inter', sans-serif;
}
.tab-btn.active { color: #1a6cf7; border-bottom-color: #1a6cf7; }
.tab-count { background: #f1f5f9; color: #475569; font-size: 0.75rem; font-weight: 700; padding: 0.1rem 0.5rem; border-radius: 999px; }
.tab-btn.active .tab-count { background: #eff6ff; color: #1a6cf7; }

/* BOOKINGS LIST */
.bookings-list { display: flex; flex-direction: column; gap: 1.5rem; }
.booking-card { display: flex; background: white; border: 1px solid #e2e8f0; border-radius: 18px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }

.booking-img-wrap { width: 220px; position: relative; flex-shrink: 0; background: #e0e7ff; }
.booking-img-wrap img { width: 100%; height: 100%; object-fit: cover; }
.status-badge {
  position: absolute; top: 0.75rem; left: 0.75rem; font-size: 0.7rem; font-weight: 800;
  padding: 0.25rem 0.6rem; border-radius: 999px; text-transform: uppercase; letter-spacing: 0.03em;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
.status-badge.pending { background: #fffbeb; color: #d97706; }
.status-badge.confirmed { background: #eff6ff; color: #1a6cf7; }
.status-badge.completed { background: #ecfdf5; color: #059669; }
.status-badge.cancelled { background: #fef2f2; color: #dc2626; }

.booking-details { padding: 1.5rem; flex: 1; display: flex; flex-direction: column; }
.booking-id-tag { font-size: 0.75rem; font-weight: 700; color: #94a3b8; letter-spacing: 0.05em; text-transform: uppercase; margin-bottom: 0.25rem; }
.booking-details h3 { font-size: 1.15rem; font-weight: 800; color: #0f172a; margin-bottom: 0.25rem; }
.addr-text { display: flex; align-items: center; gap: 0.25rem; font-size: 0.85rem; color: #64748b; margin-bottom: 1.25rem; }

.booking-info-row {
  display: flex; align-items: center; background: #f8fafc; border-radius: 12px;
  padding: 0.9rem 1.25rem; gap: 1rem; border: 1px solid #f1f5f9; margin-bottom: 1.5rem;
}
.info-block { display: flex; flex-direction: column; gap: 0.2rem; }
.info-block .label { font-size: 0.65rem; font-weight: 800; color: #94a3b8; display: flex; align-items: center; gap: 0.25rem; }
.info-block .value { font-size: 0.85rem; font-weight: 700; color: #1e293b; }
.arrow-icon { font-size: 1.2rem; color: #cbd5e1; }
.info-block.guests { margin-left: auto; border-left: 1px solid #e2e8f0; padding-left: 1.5rem; }

.booking-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
  flex-wrap: wrap;
  gap: 1rem;
}
.price-section { display: flex; flex-direction: column; }
.price-section .label { font-size: 0.75rem; font-weight: 600; color: #64748b; }
.price-section .price-val { font-size: 1.25rem; font-weight: 800; color: #1a6cf7; }
.actions-section {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
  align-items: center;
}

.btn-cancel-booking {
  background: white; border: 1.5px solid #ef4444; color: #ef4444;
  padding: 0 1rem; border-radius: 8px; font-size: 0.8rem; font-weight: 700;
  cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
  display: inline-flex; align-items: center; justify-content: center;
  height: 34px;
  white-space: nowrap;
  flex-shrink: 0;
}
.btn-cancel-booking:hover:not(:disabled) { background: #fef2f2; transform: translateY(-1px); }
.btn-cancel-booking:disabled { opacity: 0.6; cursor: not-allowed; }

.btn-view-receipt {
  background: #f1f5f9; border: none; color: #475569;
  padding: 0 1rem; border-radius: 8px; font-size: 0.8rem; font-weight: 700;
  cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
  display: inline-flex; align-items: center; justify-content: center;
  height: 34px;
  white-space: nowrap;
  flex-shrink: 0;
}
.btn-view-receipt:hover { background: #e2e8f0; color: #1e293b; transform: translateY(-1px); }

.spinner-small { width: 16px; height: 16px; border: 2px solid rgba(239,68,68,0.4); border-top-color: #ef4444; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }
.spinner-momo { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.4); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }
@keyframes spin { to { transform: rotate(360deg); } }

/* Continue payment button */
.btn-continue-pay {
  background: #1a6cf7;
  color: white;
  border: none;
  padding: 0 1rem;
  border-radius: 8px;
  font-size: 0.8rem;
  font-weight: 700;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  box-shadow: 0 4px 12px rgba(26, 108, 247, 0.15);
  font-family: 'Inter', sans-serif;
  height: 34px;
  white-space: nowrap;
  flex-shrink: 0;
}
.btn-continue-pay:hover {
  background: #1558d6;
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(26, 108, 247, 0.25);
}

/* EMPTY STATE */
.empty-state { text-align: center; padding: 4rem 2rem; background: white; border: 1px solid #e2e8f0; border-radius: 18px; }
.empty-icon { color: #94a3b8; margin-bottom: 1rem; }
.empty-state h3 { font-size: 1.2rem; font-weight: 700; color: #1e293b; margin-bottom: 0.5rem; }
.empty-state p { font-size: 0.9rem; color: #64748b; margin-bottom: 1.5rem; }
.btn-discover {
  display: inline-block; background: #1a6cf7; color: white; text-decoration: none;
  padding: 0.75rem 1.5rem; border-radius: 10px; font-weight: 700; font-size: 0.9rem;
  box-shadow: 0 4px 12px rgba(26,108,247,0.25); transition: background 0.2s;
}
.btn-discover:hover { background: #1558d6; }

/* MODALS */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
  backdrop-filter: blur(8px);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  animation: fadeIn 0.2s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
.confirm-modal { background: white; border-radius: 18px; padding: 2rem; width: 100%; max-width: 440px; box-shadow: 0 20px 40px rgba(0,0,0,0.15); animation: pop 0.25s ease-out; }
@keyframes pop { from { transform: scale(0.95); opacity: 0; } to { transform: scale(1); opacity: 1; } }
.confirm-modal h3 { font-size: 1.2rem; font-weight: 800; color: #0f172a; margin-bottom: 0.75rem; }
.confirm-modal p { font-size: 0.9rem; color: #475569; line-height: 1.5; margin-bottom: 1.5rem; }
.modal-actions { display: flex; gap: 0.75rem; justify-content: flex-end; }
.btn-modal-cancel { background: #f1f5f9; border: none; color: #475569; padding: 0.6rem 1.2rem; border-radius: 8px; font-size: 0.85rem; font-weight: 700; cursor: pointer; }
.btn-modal-confirm { background: #ef4444; border: none; color: white; padding: 0.6rem 1.2rem; border-radius: 8px; font-size: 0.85rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.4rem; }

/* RECEIPT MODAL */
.receipt-modal { background: white; border-radius: 20px; width: 100%; max-width: 520px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 25px 50px rgba(0,0,0,0.15); animation: pop 0.25s ease-out; }
.receipt-header { display: flex; justify-content: space-between; align-items: center; padding: 1.25rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
.receipt-header h2 { font-size: 1.2rem; font-weight: 800; color: #0f172a; }
.btn-close-modal { background: none; border: none; font-size: 1.75rem; cursor: pointer; color: #94a3b8; transition: color 0.2s; }
.btn-close-modal:hover { color: #1e293b; }

.receipt-body { padding: 1.5rem; overflow-y: auto; max-height: 70vh; display: flex; flex-direction: column; gap: 1.25rem; }
.receipt-top-row { display: flex; justify-content: space-between; align-items: flex-start; }
.receipt-id { font-size: 0.75rem; font-weight: 800; color: #94a3b8; }
.receipt-date { font-size: 0.75rem; color: #64748b; margin-top: 0.1rem; }

.receipt-section { border-bottom: 1px dashed #e2e8f0; padding-bottom: 1rem; }
.receipt-section:last-child { border-bottom: none; }
.receipt-section h4 { font-size: 0.75rem; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem; }
.property-title { font-weight: 700; font-size: 0.95rem; color: #0f172a; }
.property-addr { font-size: 0.8rem; color: #64748b; margin-top: 0.1rem; }

.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
.receipt-val { font-size: 0.9rem; font-weight: 700; color: #1e293b; }
.receipt-section small { font-size: 0.75rem; color: #94a3b8; }

.billing { padding-bottom: 0; }
.billing-row { display: flex; justify-content: space-between; font-size: 0.85rem; color: #475569; margin-bottom: 0.4rem; }
.billing-row.total { border-top: 1px solid #e2e8f0; padding-top: 0.75rem; margin-top: 0.5rem; }
.billing-row.total span { font-weight: 800; color: #0f172a; font-size: 0.95rem; }
.billing-row .total-val { font-size: 1.2rem; color: #ff567d; font-weight: 800; }

.receipt-footer-btn { background: #f8fafc; padding: 1rem 1.5rem; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end; }
.btn-receipt-close { background: #1a6cf7; color: white; border: none; padding: 0.6rem 1.5rem; border-radius: 8px; font-weight: 700; font-size: 0.9rem; cursor: pointer; font-family: 'Inter', sans-serif; }
.btn-receipt-close:hover { background: #1558d6; }

/* PAGINATION */
.pagination-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  margin-top: 2rem;
  flex-wrap: wrap;
}
.pg-btn {
  min-width: 38px;
  height: 38px;
  padding: 0 0.6rem;
  border-radius: 10px;
  border: 1.5px solid #e2e8f0;
  background: white;
  color: #475569;
  font-size: 0.875rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  transition: all 0.18s;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
}
.pg-btn:hover:not(:disabled) {
  border-color: #1a6cf7;
  color: #1a6cf7;
  background: #eff6ff;
}
.pg-btn.active {
  background: linear-gradient(135deg, #1a6cf7, #5392f9);
  border-color: #1a6cf7;
  color: white;
  box-shadow: 0 4px 12px rgba(26,108,247,0.3);
  transform: translateY(-1px);
}
.pg-btn:disabled {
  opacity: 0.38;
  cursor: not-allowed;
}
.pg-ellipsis {
  font-size: 0.875rem;
  color: #94a3b8;
  padding: 0 0.15rem;
  user-select: none;
}
.pg-info {
  font-size: 0.78rem;
  font-weight: 600;
  color: #94a3b8;
  margin-left: 0.5rem;
  white-space: nowrap;
}

@media (max-width: 768px) {
  .booking-card { flex-direction: column; }
  .booking-img-wrap { width: 100%; height: 160px; }
  .booking-info-row { flex-direction: column; align-items: flex-start; gap: 0.6rem; }
  .info-block.guests { border-left: none; padding-left: 0; margin-left: 0; }
  .arrow-icon { display: none; }
  .booking-footer { flex-direction: column; align-items: stretch; gap: 1rem; }
  .actions-section { flex-direction: column; }
}

/* Premium Review Styles */
.btn-write-review {
  background: #ffb703;
  color: #0f172a;
  border: none;
  padding: 0.55rem 1.25rem;
  border-radius: 10px;
  font-size: 0.8rem;
  font-weight: 700;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 10px rgba(255, 183, 3, 0.25);
  font-family: 'Inter', sans-serif;
  white-space: nowrap;
  flex-shrink: 0;
}

.btn-write-review:hover {
  background: #ffa200;
  transform: translateY(-1.5px);
  box-shadow: 0 6px 14px rgba(255, 183, 3, 0.35);
}

.review-modal {
  background: #ffffff;
  border-radius: 24px;
  width: 100%;
  max-width: 520px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04), 0 0 0 1px rgba(0, 0, 0, 0.05);
  animation: modalScaleIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  text-align: left;
}

@keyframes modalScaleIn {
  from {
    transform: scale(0.92) translateY(12px);
    opacity: 0;
  }
  to {
    transform: scale(1) translateY(0);
    opacity: 1;
  }
}

.review-modal .modal-header {
  padding: 1.5rem 1.75rem;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.review-modal .modal-header h2 {
  font-size: 1.25rem;
  font-weight: 800;
  color: #0f172a;
  background: linear-gradient(135deg, #1e293b, #0f172a);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0;
}

.review-modal .modal-body {
  padding: 1.75rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

/* Room Preview style */
.modal-room-preview {
  display: flex;
  gap: 1rem;
  background: #f8fafc;
  padding: 1rem;
  border-radius: 16px;
  border: 1px solid #e2e8f0;
}

.modal-room-preview .preview-img {
  width: 80px;
  height: 80px;
  border-radius: 12px;
  object-fit: cover;
  flex-shrink: 0;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.modal-room-preview .preview-details {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.modal-room-preview .preview-id {
  font-size: 0.72rem;
  font-weight: 700;
  color: #94a3b8;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.15rem;
}

.modal-room-preview .preview-name {
  font-size: 0.95rem;
  font-weight: 800;
  color: #1e293b;
  margin-bottom: 0.25rem;
  line-height: 1.3;
}

.modal-room-preview .preview-dates {
  font-size: 0.78rem;
  color: #64748b;
  display: flex;
  align-items: center;
}

/* Section label styling */
.section-label {
  font-size: 0.75rem;
  font-weight: 800;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.35rem;
  display: block;
}

/* Star selector interactive container */
.stars-selector-group {
  display: flex;
  flex-direction: column;
}

.stars-row-interactive {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fafbfc;
  padding: 0.85rem 1.25rem;
  border-radius: 16px;
  border: 1px dashed #cbd5e1;
  transition: all 0.2s ease;
}

.stars-row-interactive:hover {
  border-color: #94a3b8;
  background: #f8fafc;
}

.stars-list {
  display: flex;
  gap: 0.4rem;
}

.star-item-interactive {
  color: #e2e8f0;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.star-item-interactive:hover {
  color: #ffc107;
  transform: scale(1.25);
}

.star-item-interactive.filled {
  color: #ffb703;
  filter: drop-shadow(0 0 3px rgba(251, 191, 36, 0.4));
}

.star-item-interactive.filled:hover {
  transform: scale(1.25);
  color: #ffa200;
  filter: drop-shadow(0 0 6px rgba(251, 191, 36, 0.6));
}

/* Dynamic badges based on rating */
.rating-badge {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.35rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.82rem;
  font-weight: 800;
  transition: all 0.3s ease;
  animation: badgePop 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
}

@keyframes badgePop {
  from { transform: scale(0.85); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

.rating-badge.rating-1 {
  background: #fef2f2;
  color: #ef4444;
  border: 1px solid #fecaca;
}

.rating-badge.rating-2 {
  background: #fff7ed;
  color: #f97316;
  border: 1px solid #ffedd5;
}

.rating-badge.rating-3 {
  background: #fffbeb;
  color: #d97706;
  border: 1px solid #fef3c7;
}

.rating-badge.rating-4 {
  background: #f0fdf4;
  color: #16a34a;
  border: 1px solid #bbf7d0;
}

.rating-badge.rating-5 {
  background: #eff6ff;
  color: #1d4ed8;
  border: 1px solid #bfdbfe;
}

/* Comment inputs with counter */
.comment-input-group {
  display: flex;
  flex-direction: column;
}

.comment-input-group .label-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.35rem;
}

.comment-input-group .char-count {
  font-size: 0.72rem;
  font-weight: 600;
  color: #94a3b8;
}

.comment-input-group .char-count.max-reached {
  color: #ef4444;
  font-weight: 700;
}

.comment-input-group textarea {
  width: 100%;
  padding: 0.9rem 1.1rem;
  border-radius: 16px;
  border: 1.5px solid #e2e8f0;
  font-size: 0.88rem;
  font-weight: 600;
  color: #1e293b;
  outline: none;
  background: #fafbfc;
  transition: all 0.25s ease;
  font-family: 'Inter', sans-serif;
  resize: none;
}

.comment-input-group textarea:focus {
  border-color: #1a6cf7;
  background: #ffffff;
  box-shadow: 0 0 0 4px rgba(26, 108, 247, 0.12);
}

.comment-input-group textarea::placeholder {
  color: #94a3b8;
  font-weight: 500;
}

/* Modal Footer Action buttons styling */
.review-modal .modal-footer {
  padding: 1.25rem 1.75rem;
  border-top: 1px solid #f1f5f9;
  background: #fafbfc;
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
}

.btn-review-cancel {
  background: #ffffff;
  color: #475569;
  border: 1.5px solid #e2e8f0;
  padding: 0.65rem 1.25rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease;
  font-family: 'Inter', sans-serif;
}

.btn-review-cancel:hover {
  background: #f8fafc;
  border-color: #cbd5e1;
  color: #1e293b;
}

.btn-review-submit {
  background: linear-gradient(135deg, #1a6cf7, #0052cc);
  color: #ffffff;
  border: none;
  padding: 0.65rem 1.5rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: 'Inter', sans-serif;
  box-shadow: 0 4px 12px rgba(26, 108, 247, 0.2);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 120px;
}

.btn-review-submit:hover:not(:disabled) {
  background: linear-gradient(135deg, #1558d6, #0043a4);
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(26, 108, 247, 0.3);
}

.btn-review-submit:active:not(:disabled) {
  transform: translateY(0);
}

.btn-review-submit:disabled {
  background: #cbd5e1;
  color: #94a3b8;
  cursor: not-allowed;
  box-shadow: none;
}

/* Spinner loader inside buttons */
.spinner-loader {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
  display: inline-block;
}

/* MY VOUCHERS LIST STYLES */
.vouchers-list {
  margin-top: 1.5rem;
}
.voucher-wallet-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
  gap: 1.25rem;
}

.my-voucher-card {
  display: flex;
  background: #ffffff;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  border: 1px solid #e2e8f0;
  transition: all 0.25s ease;
  height: 140px;
  font-family: 'Inter', sans-serif;
}
.my-voucher-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 22px rgba(0, 0, 0, 0.1);
  border-color: #cbd5e1;
}

/* Left ticket badge */
.mvc-left {
  width: 120px;
  background: linear-gradient(135deg, #1a6cf7, #0052cc);
  color: #ffffff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  border-right: 1.5px dashed #cbd5e1;
  padding: 10px;
  flex-shrink: 0;
}
.mvc-val-num {
  font-size: 1.8rem;
  font-weight: 800;
  line-height: 1.1;
  text-align: center;
}
.mvc-val-lbl {
  font-size: 0.7rem;
  font-weight: 700;
  opacity: 0.9;
  letter-spacing: 0.5px;
  margin-top: 4px;
}
.mvc-circle-t, .mvc-circle-b {
  width: 12px;
  height: 12px;
  background: #f8f9fc; /* matches page background */
  border-radius: 50%;
  position: absolute;
  left: 114px;
  z-index: 5;
}
.mvc-circle-t { top: -6px; }
.mvc-circle-b { bottom: -6px; }

/* Right content details */
.mvc-right {
  flex: 1;
  padding: 1rem 1.25rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}
.mvc-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
}
.mvc-code-pill {
  background: #f1f5f9;
  color: #334155;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 6px;
  font-size: 0.75rem;
  text-transform: uppercase;
}
.mvc-expiry-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 6px;
}
.mvc-expiry-badge.near-expiry {
  background: #fef2f2;
  color: #ef4444;
}
.mvc-expiry-badge.expired {
  background: #f1f5f9;
  color: #64748b;
}
.mvc-expiry-badge.active-expiry {
  background: #f0fdf4;
  color: #16a34a;
}

.mvc-title {
  font-size: 0.95rem;
  font-weight: 700;
  color: #0f172a;
  margin: 6px 0 2px;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.mvc-min-order {
  font-size: 0.75rem;
  color: #64748b;
  margin-bottom: auto;
}
.mvc-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 6px;
  border-top: 1px solid #f1f5f9;
}
.mvc-hsd {
  font-size: 0.72rem;
  color: #64748b;
}
.btn-mvc-use {
  color: #1a6cf7;
  text-decoration: none;
  font-size: 0.8rem;
  font-weight: 700;
  transition: color 0.15s ease;
}
.btn-mvc-use:hover {
  color: #0043a4;
  text-decoration: underline;
}

@media (max-width: 768px) {
  .voucher-wallet-grid {
    grid-template-columns: 1fr;
  }
  .my-voucher-card {
    height: auto;
    min-height: 130px;
  }
  
  /* Header responsive */
  .header-lang-selector-dropdown { display: none !important; }
  .logo { font-size: 1.15rem; }
  .btn-back { font-size: 0.8rem; }
  .btn-outline { padding: 0.4rem 0.8rem; font-size: 0.8rem; }
}
.btn-view-review {
  display: flex;
  align-items: center;
  padding: 8px 14px;
  background: #f1f5f9;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  color: #475569;
  font-size: 13.5px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
  flex-shrink: 0;
}
.btn-view-review:hover {
  background: #e2e8f0;
  color: #0f172a;
}

.header-lang-selector {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: rgba(241, 245, 249, 0.85);
  padding: 4px 8px;
  border-radius: 20px;
  border: 1px solid rgba(226, 232, 240, 0.8);
  margin-right: 12px;
  align-self: center;
}

.lang-btn-header {
  background: none;
  border: none;
  font-size: 11px;
  font-weight: 700;
  color: #64748b;
  cursor: pointer;
  padding: 2px 6px;
  border-radius: 12px;
  transition: all 0.2s ease;
}

.lang-btn-header:hover {
  color: #0f172a;
}

.lang-btn-header.active {
  color: #ffffff;
  background: #3b82f6;
}

.lang-divider-header {
  font-size: 10px;
  color: #cbd5e1;
}
</style>