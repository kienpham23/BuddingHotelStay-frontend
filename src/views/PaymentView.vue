<template>
  <div class="pay-page">

    <!-- ===== HEADER ===== -->
    <header class="pay-header">
      <div class="pay-header-inner">
        <RouterLink to="/" class="logo">
          <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
            <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="logo-word building">Building</span>
          <span class="logo-word hotel">Hotel</span>
        </RouterLink>

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

        <div class="header-steps">
          <div v-for="(s, i) in steps" :key="i"
               class="step-wrap"
               :class="{ active: currentStep >= i+1, done: currentStep > i+1 }">
            <div class="step-circle">
              <CheckCircle v-if="currentStep > i+1" :size="16" />
              <span v-else>{{ i+1 }}</span>
            </div>
            <span class="step-label">{{ s }}</span>
            <div v-if="i < steps.length-1" class="step-connector" :class="{ filled: currentStep > i+1 }"></div>
          </div>
        </div>

        <RouterLink to="/bookings" class="hdr-back">
          <ChevronLeft :size="15" /> {{ $t('nav.my_bookings') }}
        </RouterLink>
      </div>
    </header>

    <!-- ===== BODY ===== -->
    <div class="pay-body">

      <!-- LEFT -->
      <div class="pay-left">

        <!-- STEP 1: Thông tin khách -->
        <transition name="slide" mode="out-in">
        <div v-if="currentStep === 1" key="s1">
          <div class="scard">
            <div class="scard-title">
              <User :size="20" class="ico-blue" />
              <h2>{{ $t('payment.contact_info') }}</h2>
            </div>

            <div class="fgrid-2">
              <div class="fgroup" :class="{ ferr: err.firstName }">
                <label>{{ locale === 'vi' ? 'Họ' : 'First Name' }} *</label>
                <input v-model="form.firstName" :placeholder="locale === 'vi' ? 'Nguyễn' : 'John'" />
                <span class="emsg" v-if="err.firstName">{{ err.firstName }}</span>
              </div>
              <div class="fgroup" :class="{ ferr: err.lastName }">
                <label>{{ locale === 'vi' ? 'Tên' : 'Last Name' }} *</label>
                <input v-model="form.lastName" :placeholder="locale === 'vi' ? 'Văn An' : 'Doe'" />
                <span class="emsg" v-if="err.lastName">{{ err.lastName }}</span>
              </div>
            </div>

            <div class="fgrid-2">
              <div class="fgroup" :class="{ ferr: err.email }">
                <label>Email *</label>
                <div class="inp-wrap">
                  <Mail :size="15" class="inp-ico" />
                  <input v-model="form.email" type="email" placeholder="email@example.com" />
                </div>
                <span class="emsg" v-if="err.email">{{ err.email }}</span>
              </div>
              <div class="fgroup" :class="{ ferr: err.phone }">
                <label>{{ locale === 'vi' ? 'Số điện thoại' : 'Phone number' }} *</label>
                <div class="inp-wrap">
                  <Phone :size="15" class="inp-ico" />
                  <input v-model="form.phone" type="tel" placeholder="09xx xxx xxx" />
                </div>
                <span class="emsg" v-if="err.phone">{{ err.phone }}</span>
              </div>
            </div>

            <div class="fgroup">
              <label>{{ locale === 'vi' ? 'Quốc gia' : 'Country' }}</label>
              <div class="inp-wrap">
                <Globe :size="15" class="inp-ico" />
                <select v-model="form.country">
                  <option value="VN">🇻🇳 {{ locale === 'vi' ? 'Việt Nam' : 'Vietnam' }}</option>
                  <option value="US">🇺🇸 {{ locale === 'vi' ? 'Hoa Kỳ' : 'United States' }}</option>
                  <option value="JP">🇯🇵 {{ locale === 'vi' ? 'Nhật Bản' : 'Japan' }}</option>
                  <option value="KR">🇰🇷 {{ locale === 'vi' ? 'Hàn Quốc' : 'South Korea' }}</option>
                  <option value="SG">🇸🇬 Singapore</option>
                  <option value="TH">🇹🇭 {{ locale === 'vi' ? 'Thái Lan' : 'Thailand' }}</option>
                </select>
              </div>
            </div>

            <div class="fgroup">
              <label>{{ locale === 'vi' ? 'Giờ check-in dự kiến' : 'Estimated Check-in Time' }}</label>
              <div class="inp-wrap">
                <Clock :size="15" class="inp-ico" />
                <select v-model="form.arrivalTime">
                  <option value="">{{ locale === 'vi' ? 'Chưa xác định' : 'Not determined' }}</option>
                  <option value="06:00-10:00">06:00 – 10:00</option>
                  <option value="10:00-14:00">10:00 – 14:00</option>
                  <option value="14:00-18:00">14:00 – 18:00</option>
                  <option value="18:00-22:00">18:00 – 22:00</option>
                  <option value="22:00-00:00">22:00 – 00:00</option>
                </select>
              </div>
            </div>

            <div class="fgroup">
              <label>{{ locale === 'vi' ? 'Yêu cầu đặc biệt bổ sung' : 'Additional special requests' }}</label>
              <div class="special-requests-grid">
                <label class="req-item">
                  <input type="checkbox" value="Phòng không hút thuốc" v-model="form.specialRequests" />
                  <span>{{ locale === 'vi' ? 'Phòng không hút thuốc' : 'Non-smoking room' }}</span>
                </label>
                <label class="req-item">
                  <input type="checkbox" value="Nhận phòng sớm" v-model="form.specialRequests" />
                  <span>{{ locale === 'vi' ? 'Nhận phòng sớm' : 'Early check-in' }}</span>
                </label>
                <label class="req-item">
                  <input type="checkbox" value="Giường phụ" v-model="form.specialRequests" />
                  <span>{{ locale === 'vi' ? 'Giường phụ (Extra bed)' : 'Extra bed' }}</span>
                </label>
                <label class="req-item">
                  <input type="checkbox" value="Đưa đón sân bay" v-model="form.specialRequests" />
                  <span>{{ locale === 'vi' ? 'Đưa đón sân bay' : 'Airport shuttle' }}</span>
                </label>
                <label class="req-item">
                  <input type="checkbox" value="Tầng cao / Hướng đẹp" v-model="form.specialRequests" />
                  <span>{{ locale === 'vi' ? 'Tầng cao / Hướng đẹp' : 'High floor / Nice view' }}</span>
                </label>
              </div>
            </div>

            <div class="fgroup">
              <label>{{ locale === 'vi' ? 'Ghi chú đặc biệt khác' : 'Other special requests' }} <span class="opt">({{ locale === 'vi' ? 'không bắt buộc' : 'optional' }})</span></label>
              <textarea v-model="form.note" rows="3"
                :placeholder="locale === 'vi' ? 'Ví dụ: nhận phòng sớm, giường đôi, tầng cao...' : 'E.g. early check-in, double bed, high floor...'"></textarea>
            </div>
          </div>

          <!-- Chính sách -->
          <div class="policy-strip">
            <div class="ps-item">
              <ShieldCheck :size="17" class="ico-green" />
              <div>
                <strong>{{ locale === 'vi' ? 'Hủy miễn phí trước 24h' : 'Free cancellation before 24h' }}</strong>
                <p>{{ locale === 'vi' ? 'Hoàn 100% nếu hủy trước 24h check-in.' : '100% refund if cancelled before 24h check-in.' }}</p>
              </div>
            </div>
            <div class="ps-item">
              <Zap :size="17" class="ico-yellow" />
              <div>
                <strong>{{ locale === 'vi' ? 'Xác nhận tức thì' : 'Instant confirmation' }}</strong>
                <p>{{ locale === 'vi' ? 'Email xác nhận gửi trong vòng 5 phút.' : 'Confirmation email sent within 5 minutes.' }}</p>
              </div>
            </div>
            <div class="ps-item">
              <Lock :size="17" class="ico-blue" />
              <div>
                <strong>{{ locale === 'vi' ? 'Thanh toán bảo mật' : 'Secure payment' }}</strong>
                <p>{{ locale === 'vi' ? 'SSL 256-bit, không lưu thông tin thẻ.' : 'SSL 256-bit, credit card info is not stored.' }}</p>
              </div>
            </div>
          </div>

          <button class="btn-primary w-full" @click="goStep2">
            {{ locale === 'vi' ? 'Tiếp theo: Chọn phương thức thanh toán' : 'Next: Select Payment Method' }} <ArrowRight :size="17" />
          </button>
        </div>
        </transition>

        <!-- STEP 2: Phương thức thanh toán -->
        <transition name="slide" mode="out-in">
        <div v-if="currentStep === 2" key="s2">
          <div class="scard">
            <div class="scard-title">
              <CreditCard :size="20" class="ico-blue" />
              <h2>{{ $t('payment.payment_method') }}</h2>
            </div>

            <div class="method-list">
              <!-- VNPay QR -->
              <div class="method-item" :class="{ selected: payMethod === 'vnpay' }" @click="payMethod = 'vnpay'">
                <div class="radio-ring" :class="{ active: payMethod === 'vnpay' }">
                  <div v-if="payMethod === 'vnpay'" class="radio-dot"></div>
                </div>
                <div class="method-body">
                  <div class="method-name">
                    VNPay QR
                    <span class="badge-rec">{{ locale === 'vi' ? 'Khuyến nghị' : 'Recommended' }}</span>
                  </div>
                  <div class="method-sub">{{ locale === 'vi' ? 'Quét QR bằng app ngân hàng / ví điện tử' : 'Scan QR code with banking app / e-wallet' }}</div>
                </div>
                <span class="vnpay-badge">VNPay</span>
              </div>

              <!-- ATM / Internet Banking -->
              <div class="method-item" :class="{ selected: payMethod === 'vnpay_atm' }" @click="payMethod = 'vnpay_atm'">
                <div class="radio-ring" :class="{ active: payMethod === 'vnpay_atm' }">
                  <div v-if="payMethod === 'vnpay_atm'" class="radio-dot"></div>
                </div>
                <div class="method-body">
                  <div class="method-name">{{ locale === 'vi' ? 'Thẻ ATM / Internet Banking' : 'ATM Card / Internet Banking' }}</div>
                  <div class="method-sub">{{ locale === 'vi' ? 'Thanh toán qua VNPay với thẻ nội địa hoặc quốc tế' : 'Pay via VNPay with local or international cards' }}</div>
                </div>
                <div class="method-logos">
                  <img src="https://cdn.jsdelivr.net/gh/datatrans/payment-logos/assets/cards/visa.svg" alt="Visa" />
                  <img src="https://cdn.jsdelivr.net/gh/datatrans/payment-logos/assets/cards/mastercard.svg" alt="MC" />
                </div>
              </div>

              <!-- Ẩn phương thức MoMo do chưa cấu hình key chạy thật
              <div class="method-item" :class="{ selected: payMethod === 'momo' }" @click="payMethod = 'momo'">
                <div class="radio-ring" :class="{ active: payMethod === 'momo' }">
                  <div v-if="payMethod === 'momo'" class="radio-dot"></div>
                </div>
                <div class="method-body">
                  <div class="method-name">{{ locale === 'vi' ? 'Ví MoMo' : 'MoMo Wallet' }}</div>
                  <div class="method-sub">{{ locale === 'vi' ? 'Quét QR hoặc nhập SĐT MoMo để thanh toán nhanh' : 'Scan QR or enter MoMo phone number to pay fast' }}</div>
                </div>
                <img src="https://static.mservice.io/img/logo-momo.png" alt="MoMo" class="momo-badge-img" />
              </div>
              -->

              <!-- Tại khách sạn -->
              <div class="method-item" :class="{ selected: payMethod === 'onsite' }" @click="payMethod = 'onsite'">
                <div class="radio-ring" :class="{ active: payMethod === 'onsite' }">
                  <div v-if="payMethod === 'onsite'" class="radio-dot"></div>
                </div>
                <div class="method-body">
                  <div class="method-name">{{ locale === 'vi' ? 'Thanh toán tại khách sạn' : 'Pay at property' }}</div>
                  <div class="method-sub">{{ locale === 'vi' ? 'Trả tiền mặt hoặc thẻ khi check-in' : 'Pay with cash or card upon check-in' }}</div>
                </div>
                <Banknote :size="26" class="ico-green" />
              </div>
            </div>

            <!-- VNPay info box -->
            <transition name="expand">
            <div v-if="payMethod === 'vnpay' || payMethod === 'vnpay_atm'" class="vnpay-info-box">
              <div class="vib-top">
                <QrCode :size="38" class="ico-blue" style="flex-shrink:0" />
                <div>
                  <p class="vib-title">{{ locale === 'vi' ? 'Thanh toán qua cổng VNPay' : 'Pay via VNPay gateway' }}</p>
                  <p class="vib-desc">{{ locale === 'vi' ? 'Bạn sẽ được chuyển hướng đến trang thanh toán an toàn của VNPay sau khi xác nhận. Sau khi hoàn tất, hệ thống tự động cập nhật trạng thái đơn hàng.' : 'You will be redirected to VNPay secure payment page after confirmation. Once completed, the system automatically updates the booking status.' }}</p>
                </div>
              </div>
              <div class="vib-steps">
                <div class="vib-step"><span>1</span> {{ locale === 'vi' ? 'Bấm "Thanh toán qua VNPay"' : 'Click "Pay with VNPay"' }}</div>
                <div class="vib-step"><span>2</span> {{ locale === 'vi' ? 'Chuyển hướng đến cổng VNPay' : 'Redirect to VNPay' }}</div>
                <div class="vib-step"><span>3</span> {{ locale === 'vi' ? 'Quét QR hoặc nhập thẻ' : 'Scan QR or enter card details' }}</div>
                <div class="vib-step"><span>4</span> {{ locale === 'vi' ? 'Xác nhận đặt phòng tự động' : 'Automatic booking confirmation' }}</div>
              </div>
            </div>
            </transition>

            <!-- MoMo info box -->
            <transition name="expand">
            <div v-if="payMethod === 'momo'" class="momo-info-box">
              <div class="vib-top">
                <img src="https://static.mservice.io/img/logo-momo.png" alt="MoMo" style="width:38px;height:38px;border-radius:10px;object-fit:contain;flex-shrink:0" />
                <div>
                  <p class="momo-title">{{ locale === 'vi' ? 'Thanh toán qua ví MoMo' : 'Pay via MoMo wallet' }}</p>
                  <p class="momo-desc">{{ locale === 'vi' ? 'Bạn sẽ được chuyển hướng đến cổng thanh toán MoMo. Sau khi hoàn tất, hệ thống tự động cập nhật trạng thái đơn hàng.' : 'You will be redirected to MoMo gateway. Once completed, the system automatically updates the booking status.' }}</p>
                </div>
              </div>
              <div class="vib-steps">
                <div class="vib-step momo-step"><span class="momo-num">1</span> {{ locale === 'vi' ? 'Bấm "Thanh toán qua MoMo"' : 'Click "Pay with MoMo"' }}</div>
                <div class="vib-step momo-step"><span class="momo-num">2</span> {{ locale === 'vi' ? 'Chuyển hướng đến MoMo' : 'Redirect to MoMo' }}</div>
                <div class="vib-step momo-step"><span class="momo-num">3</span> {{ locale === 'vi' ? 'Quét QR hoặc nhập SĐT' : 'Scan QR or enter phone number' }}</div>
                <div class="vib-step momo-step"><span class="momo-num">4</span> {{ locale === 'vi' ? 'Xác nhận đặt phòng tự động' : 'Automatic booking confirmation' }}</div>
              </div>
            </div>
            </transition>

            <!-- Onsite info -->
            <transition name="expand">
            <div v-if="payMethod === 'onsite'" class="info-banner">
              <Info :size="16" class="ico-blue" style="flex-shrink:0" />
              <p>{{ locale === 'vi' ? 'Bạn sẽ thanh toán tại lễ tân khi check-in. Vui lòng mang theo CMND/CCCD hoặc hộ chiếu hợp lệ.' : 'You will pay at the reception upon check-in. Please bring valid ID or passport.' }}</p>
            </div>
            </transition>
          </div>

          <!-- Onsite: xác nhận thông tin + agree -->
          <transition name="expand">
          <div v-if="payMethod === 'onsite'" class="scard">
            <div class="scard-title"><FileText :size="18" class="ico-blue" /><h2>{{ locale === 'vi' ? 'Xác nhận thông tin' : 'Confirm Information' }}</h2></div>
            <div class="review-row-sm"><span>{{ locale === 'vi' ? 'Họ tên' : 'Full Name' }}</span><strong>{{ form.firstName }} {{ form.lastName }}</strong></div>
            <div class="review-row-sm"><span>Email</span><strong>{{ form.email }}</strong></div>
            <div class="review-row-sm"><span>{{ locale === 'vi' ? 'Điện thoại' : 'Phone' }}</span><strong>{{ form.phone }}</strong></div>
            <label class="agree-label">
              <input type="checkbox" v-model="form.agreed" />
              <span class="chkbox"></span>
              {{ locale === 'vi' ? 'Tôi đồng ý với' : 'I agree to the' }} <a href="#" class="link-blue">{{ locale === 'vi' ? 'Điều khoản dịch vụ' : 'Terms of Service' }}</a> {{ locale === 'vi' ? 'và' : 'and' }} <a href="#" class="link-blue">{{ locale === 'vi' ? 'Chính sách bảo mật' : 'Privacy Policy' }}</a>
            </label>
            <span class="emsg" v-if="err.agreed">{{ err.agreed }}</span>
          </div>
          </transition>

          <div class="step-nav">
            <button class="btn-ghost" @click="currentStep = 1">
              <ChevronLeft :size="16" /> {{ locale === 'vi' ? 'Quay lại' : 'Back' }}
            </button>

            <button v-if="payMethod === 'vnpay' || payMethod === 'vnpay_atm'"
              id="btn-pay-vnpay"
              class="btn-vnpay" @click="handleVNPayRedirect" :disabled="paying">
              <template v-if="!paying">
                <ExternalLink :size="16" /> {{ locale === 'vi' ? 'Thanh toán qua VNPay' : 'Pay with VNPay' }}
              </template>
              <span v-else class="spin"></span>
            </button>

            <button v-if="payMethod === 'momo'"
              id="btn-pay-momo"
              class="btn-momo" @click="handleMoMoRedirect" :disabled="paying">
              <template v-if="!paying">
                <img src="https://static.mservice.io/img/logo-momo.png" alt="MoMo" style="width:18px;height:18px;border-radius:4px;object-fit:contain" />
                {{ locale === 'vi' ? 'Thanh toán qua MoMo' : 'Pay with MoMo' }}
              </template>
              <span v-else class="spin"></span>
            </button>

            <button v-if="payMethod === 'onsite'"
              id="btn-pay-onsite"
              class="btn-confirm" @click="handleOnsiteConfirm" :disabled="paying">
              <template v-if="!paying">
                <Lock :size="16" /> {{ locale === 'vi' ? 'Xác nhận đặt phòng' : 'Confirm booking' }}
              </template>
              <span v-else class="spin"></span>
            </button>
          </div>

          <div v-if="err.submit" class="err-banner">
            <AlertCircle :size="16" /> {{ err.submit }}
          </div>
        </div>
        </transition>

      </div><!-- /pay-left -->

      <!-- RIGHT: Order Summary -->
      <div class="pay-right">
        <div class="summary-card">
          <h3 class="sum-title">{{ $t('payment.room_brief') }}</h3>

          <div class="room-prev">
            <div class="rthumb">
              <img :src="booking.image || 'https://images.unsplash.com/photo-1611891487122-2075b96244e1?q=80&w=400&auto=format&fit=crop'" alt="Room" />
              <span class="rthumb-badge">{{ booking.roomType }}</span>
            </div>
            <div class="rinfo">
              <h4>{{ booking.roomName }}</h4>
              <p><MapPin :size="11" /> {{ booking.city }}</p>
              <div class="stars">
                <Star v-for="i in 5" :key="i" :size="11" fill="#ffb703" color="#ffb703" />
                <span>{{ booking.rating }}</span>
              </div>
            </div>
          </div>

          <div class="divider"></div>

          <div class="date-grid">
            <div class="dblock">
              <div class="dlabel"><Calendar :size="12" /> {{ $t('search.check_in').toUpperCase() }}</div>
              <div class="dval">{{ fmt(booking.checkIn) }}</div>
              <div class="dtime">{{ locale === 'vi' ? 'Từ 14:00' : 'After 14:00' }}</div>
            </div>
            <div class="nights-pill">{{ booking.nights }} {{ $t('detail.nights', { count: booking.nights }) }}</div>
            <div class="dblock">
              <div class="dlabel"><Calendar :size="12" /> {{ $t('search.check_out').toUpperCase() }}</div>
              <div class="dval">{{ fmt(booking.checkOut) }}</div>
              <div class="dtime">{{ locale === 'vi' ? 'Trước 12:00' : 'Before 12:00' }}</div>
            </div>
          </div>

          <div class="divider"></div>
          <div class="guest-row"><Users :size="13" class="ico-blue" /> <span>{{ booking.guests }} {{ locale === 'vi' ? 'khách' : 'guests' }} · 1 {{ $t('search.rooms').toLowerCase() }}</span></div>
          <div class="divider"></div>

          <div class="breakdown">
            <div class="bline">
              <span>{{ fmtPrice(booking.pricePerNight) }} × {{ booking.nights }} {{ $t('detail.nights', { count: booking.nights }) }}</span>
              <span>{{ fmtPrice(booking.pricePerNight * booking.nights) }}</span>
            </div>
            <div class="bline" v-if="promoApplied">
              <span class="promo-green">{{ locale === 'vi' ? 'Mã giảm giá' : 'Promo discount' }} ({{ promoCode }})</span>
              <span class="promo-green">-{{ fmtPrice(promoSaving) }}</span>
            </div>
            <div class="bline">
              <span>{{ locale === 'vi' ? 'Thuế VAT & phí dịch vụ (8%)' : 'VAT Tax & service fee (8%)' }}</span>
              <span>{{ fmtPrice(taxAmt) }}</span>
            </div>
          </div>

          <div class="total-box">
            <div>
              <div class="total-label">{{ $t('payment.total') }}</div>
              <div class="total-note">{{ $t('detail.total_desc') }}</div>
            </div>
            <div class="total-amt">{{ fmtPrice(totalAmt) }}</div>
          </div>

          <div class="divider"></div>

          <div class="trust-list">
            <div class="titem"><ShieldCheck :size="13" class="ico-green" /> {{ locale === 'vi' ? 'Thanh toán bảo mật SSL' : 'SSL Secure Payment' }}</div>
            <div class="titem"><RefreshCw :size="13" class="ico-blue" /> {{ locale === 'vi' ? 'Hủy miễn phí 24h' : 'Free Cancellation 24h' }}</div>
            <div class="titem"><Zap :size="13" class="ico-yellow" /> {{ locale === 'vi' ? 'Xác nhận tức thì' : 'Instant Confirmation' }}</div>
          </div>

          <div class="divider"></div>

          <!-- Promo Area: Select Button or Applied Box -->
          <div v-if="!promoApplied" class="promo-area">
            <button class="btn-select-promo-trigger" @click="openPromoModal" type="button">
              <Tag :size="16" />
              <span>{{ $t('payment.select_promo') }}</span>
            </button>
            <span class="emsg" v-if="promoErr">{{ promoErr }}</span>
          </div>
          <div class="promo-applied-box">
            <div class="pab-left">
              <Tag :size="16" class="ico-green" />
              <div class="pab-info">
                <span class="pab-code">{{ promoCode }}</span>
                <span class="pab-desc">{{ locale === 'vi' ? 'Đã giảm' : 'Discounted' }} -{{ fmtPrice(promoSaving) }}</span>
              </div>
            </div>
            <div class="pab-actions">
              <button class="btn-change-promo" @click="openPromoModal" type="button">{{ locale === 'vi' ? 'Đổi mã' : 'Change' }}</button>
              <button class="btn-remove-promo" @click="removePromo" type="button">✕</button>
            </div>
          </div>
        </div>
      </div>

    </div><!-- /pay-body -->

    <!-- ===== PROMO SELECTION MODAL ===== -->
    <Transition name="fade">
      <div class="modal-backdrop" v-if="showPromoModal" @click.self="showPromoModal = false">
        <div class="promo-select-modal">
          <div class="ps-modal-header">
            <h3>{{ locale === 'vi' ? 'Voucher của bạn' : 'Your Vouchers' }}</h3>
            <button class="btn-close-modal-promo" @click="showPromoModal = false" type="button">×</button>
          </div>

          <div class="ps-modal-error" v-if="promoErr" style="background:#fef2f2; color:#ef4444; padding:8px 16px; font-size:0.8rem; font-weight:600; border-bottom:1px solid #fee2e2;">
            {{ promoErr }}
          </div>

          <!-- Loading state -->
          <div class="ps-modal-loading" v-if="promosLoading">
            <div class="spinner-promo"></div>
            <p>{{ locale === 'vi' ? 'Đang tìm kiếm mã giảm giá khả dụng...' : 'Searching for available discount codes...' }}</p>
          </div>

          <!-- Promo list -->
          <div class="ps-modal-body" v-else>
            <div class="promo-cards-list" v-if="availablePromos.length > 0">
              <div
                v-for="p in availablePromos"
                :key="p.code"
                class="voucher-card"
                :class="{
                  'voucher-disabled': baseAmt < p.minOrderAmount,
                  'voucher-selected': selectedPromoCode === p.code
                }"
              >
                <!-- Left: Ticket Badge -->
                <div class="vc-badge">
                  <span class="vc-badge-value">
                    {{ p.discountType === 'PERCENT' ? `${p.discountValue}%` : formatDiscountShort(p.discountValue) }}
                  </span>
                  <span class="vc-badge-label">{{ locale === 'vi' ? 'GIẢM' : 'OFF' }}</span>
                  <div class="vc-badge-cutout-top"></div>
                  <div class="vc-badge-cutout-bottom"></div>
                </div>

                <!-- Right: Content -->
                <div class="vc-content">
                  <div class="vc-header">
                    <span class="vc-code">{{ p.code }}</span>
                    <span class="vc-selected-tag" v-if="selectedPromoCode === p.code">{{ locale === 'vi' ? 'Đang chọn' : 'Selected' }}</span>
                  </div>
                  <p class="vc-desc">{{ p.description }}</p>

                  <div class="vc-meta">
                    <span class="vc-cond">{{ locale === 'vi' ? 'Đơn tối thiểu' : 'Min spend' }}: {{ fmtPrice(p.minOrderAmount || 0) }}</span>
                    <span class="vc-date">{{ locale === 'vi' ? 'HSD' : 'Expiry' }}: {{ fmtDate(p.endDate) }}</span>
                  </div>

                  <!-- Action / Warn -->
                  <div class="vc-action-row">
                    <div class="vc-error-msg" v-if="baseAmt < p.minOrderAmount">
                      {{ locale === 'vi' ? 'Đơn hiện tại chưa đủ điều kiện (Thiếu' : 'Order not eligible yet (Need' }} {{ fmtPrice(p.minOrderAmount - baseAmt) }})
                    </div>
                    <div class="vc-success-msg" v-else-if="selectedPromoCode === p.code">
                      {{ locale === 'vi' ? 'Mã đã được áp dụng' : 'Code applied' }}
                    </div>
                    <div class="vc-btn-wrap" v-else>
                      <button
                        class="btn-apply-voucher"
                        @click="selectPromo(p)"
                        :disabled="baseAmt < p.minOrderAmount || applyingPromo"
                        type="button"
                      >
                        {{ locale === 'vi' ? 'Áp dụng' : 'Apply' }}
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="promo-empty-state" v-else>
              <Tag :size="32" class="color-gray" />
              <p>{{ locale === 'vi' ? 'Hiện không có mã khuyến mãi nào khả dụng cho bạn.' : 'Currently no promotions are available for you.' }}</p>
            </div>
          </div>
        </div>
      </div>
    </Transition>

    <!-- SUCCESS OVERLAY (onsite only) -->
    <transition name="fade">
    <div class="overlay" v-if="success">
      <div class="success-modal">
        <div class="sc-anim">
          <div class="sc-circle">
            <svg viewBox="0 0 52 52" class="chk-svg">
              <circle cx="26" cy="26" r="25" fill="none" class="chk-bg"/>
              <path fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8" class="chk-path"/>
            </svg>
          </div>
          <div class="confetti-ring">
            <div v-for="n in 12" :key="n" class="cdot" :style="cdotStyle(n)"></div>
          </div>
        </div>

        <h2>{{ locale === 'vi' ? 'Đặt phòng thành công! 🎉' : 'Booking Successful! 🎉' }}</h2>
        <p>{{ locale === 'vi' ? 'Cảm ơn' : 'Thank you' }} <strong>{{ form.firstName }} {{ form.lastName }}</strong>! {{ locale === 'vi' ? 'Xác nhận đã gửi đến' : 'Confirmation sent to' }} <strong>{{ form.email }}</strong></p>

        <div class="ref-box">
          <div class="ref-top">
            <span class="ref-lbl">{{ $t('booking.id') }}</span>
            <span class="ref-code">#HS{{ bookingRef }}</span>
          </div>
          <div class="ref-detail">
            <div class="ref-row"><MapPin :size="12"/> {{ booking.roomName }}, {{ booking.city }}</div>
            <div class="ref-row"><Calendar :size="12"/> {{ fmt(booking.checkIn) }} → {{ fmt(booking.checkOut) }}</div>
            <div class="ref-row"><Users :size="12"/> {{ booking.guests }} {{ locale === 'vi' ? 'khách' : 'guests' }}</div>
            <div class="ref-row ref-total">
              <span>{{ $t('payment.total') }}:</span>
              <strong class="ico-blue">{{ fmtPrice(totalAmt) }}</strong>
            </div>
          </div>
        </div>

        <div class="sc-btns">
          <RouterLink to="/bookings" class="btn-primary">
            <FileText :size="15"/> {{ $t('nav.my_bookings') }}
          </RouterLink>
          <RouterLink to="/" class="btn-ghost">{{ $t('nav.back_home') }}</RouterLink>
        </div>
      </div>
    </div>
    </transition>

  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useI18n } from 'vue-i18n'
import axiosInst from '../api/axios'
import { createVNPayUrl, createMoMoUrl } from '../api/payment'
import {
  User, Mail, Phone, Globe, Clock, Lock, Info, AlertCircle,
  ArrowRight, ChevronLeft, ExternalLink,
  CreditCard, Banknote, QrCode, CheckCircle,
  ShieldCheck, Zap, MapPin, Calendar, Users, Star,
  Tag, RefreshCw, FileText
} from 'lucide-vue-next'

const route  = useRoute()
const router = useRouter()
const auth   = useAuthStore()
const { t, locale } = useI18n()

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

// ─── Steps
const steps = computed(() => [
  locale.value === 'vi' ? 'Thông tin khách' : 'Guest Details',
  locale.value === 'vi' ? 'Phương thức thanh toán' : 'Payment Method'
])
const currentStep = ref(1)

// ─── Booking info từ query params
const booking = ref({
  bookingId:     route.query.bookingId    ? Number(route.query.bookingId)    : null,
  roomId:        route.query.roomId       ? Number(route.query.roomId)       : null,
  roomName:      route.query.roomName     || 'Phòng nghỉ',
  roomType:      route.query.roomType     || 'Deluxe',
  city:          route.query.city         || '',
  image:         route.query.image        || '',
  rating:        parseFloat(route.query.rating)  || 4.8,
  pricePerNight: parseInt(route.query.price)     || 0,
  checkIn:       route.query.checkIn      || '',
  checkOut:      route.query.checkOut     || '',
  guests:        parseInt(route.query.guests)    || 1,
  nights:        parseInt(route.query.nights)    || 1,
})

// ─── Form
const form = ref({
  firstName: '', lastName: '', email: '', phone: '',
  country: 'VN', arrivalTime: '', note: '', agreed: false,
  specialRequests: [],
})

onMounted(() => {
  if (!auth.isLoggedIn) { router.push('/'); return }
  const fn = (auth.user?.fullName || '').trim()
  const parts = fn.split(' ')
  form.value.lastName  = parts.pop() || ''
  form.value.firstName = parts.join(' ')
  form.value.email     = auth.user?.email || ''
  form.value.phone     = auth.user?.phone || ''
  fetchAvailablePromos()
})

// ─── Payment state
const payMethod  = ref('vnpay')
const paying     = ref(false)
const success    = ref(false)
const bookingRef = ref('')
const err        = ref({})

// ─── Promo Selection Modal State
const showPromoModal = ref(false)

const openPromoModal = () => {
  showPromoModal.value = true
  promoErr.value = ''
  fetchAvailablePromos()
}

// ─── Promo — available list
const availablePromos   = ref([])
const promosLoading     = ref(false)
const selectedPromoCode = ref('')

const fetchAvailablePromos = async () => {
  promosLoading.value = true
  try {
    const res = await axiosInst.get('/promotions/my-wallet')
    const list = res.data || []
    availablePromos.value = list.filter(p => !p.used)
  } catch (err) {
    console.error('Lỗi khi lấy danh sách ví voucher:', err)
    availablePromos.value = []
  } finally {
    promosLoading.value = false
  }
}

// ─── Promo — apply
const promoCode     = ref('')
const promoErr      = ref('')
const promoApplied  = ref(false)
const promoDiscount = ref(0)
const applyingPromo = ref(false)

const applyPromo = async () => {
  promoErr.value = ''
  if (!promoCode.value.trim()) {
    promoErr.value = locale.value === 'vi' ? 'Vui lòng nhập mã giảm giá' : 'Please enter discount code'
    return
  }
  applyingPromo.value = true
  try {
    const res = await axiosInst.post('/promotions/apply', {
      code: promoCode.value.trim().toUpperCase(),
      orderAmount: baseAmt.value
    })
    promoApplied.value  = true
    promoDiscount.value = res.data.discountAmount
    promoCode.value     = res.data.code
    selectedPromoCode.value = res.data.code
  } catch (e) {
    promoErr.value      = e.response?.data?.message || (locale.value === 'vi' ? 'Mã khuyến mãi không hợp lệ' : 'Invalid discount code')
    promoApplied.value  = false
    promoDiscount.value = 0
    selectedPromoCode.value = ''
  } finally {
    applyingPromo.value = false
  }
}

// Click a promo card → auto fill + apply
const selectPromo = async (promo) => {
  if (baseAmt.value < promo.minOrderAmount) return
  promoCode.value = promo.code
  selectedPromoCode.value = promo.code
  await applyPromo()
  if (promoApplied.value) {
    showPromoModal.value = false
  }
}

const removePromo = () => {
  promoApplied.value  = false
  promoCode.value     = ''
  promoDiscount.value = 0
  selectedPromoCode.value = ''
}

// Short format for discount value
const formatDiscountShort = (val) => {
  if (!val) return '0'
  if (val >= 1000000) {
    return (val / 1000000).toFixed(0) + 'Tr'
  }
  if (val >= 1000) {
    return (val / 1000).toFixed(0) + 'K'
  }
  return val + 'đ'
}

// Format date helper
const fmtDate = (d) => {
  if (!d) return '--/--/----'
  const dateObj = new Date(d)
  if (isNaN(dateObj.getTime())) return d
  return dateObj.toLocaleDateString(locale.value === 'vi' ? 'vi-VN' : 'en-US', {
    day: '2-digit', month: '2-digit', year: 'numeric'
  })
}

// ─── Price
const baseAmt     = computed(() => booking.value.pricePerNight * booking.value.nights)
const promoSaving = computed(() => promoApplied.value ? promoDiscount.value : 0)
const taxAmt      = computed(() => Math.round((baseAmt.value - promoSaving.value) * 0.08))
const totalAmt    = computed(() => baseAmt.value - promoSaving.value + taxAmt.value)

// ─── Formatters
const fmtPrice = (n) =>
  new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(n)
const fmt = (d) => {
  if (!d) return '--'
  return new Date(d).toLocaleDateString(locale.value === 'vi' ? 'vi-VN' : 'en-US', {
    weekday: 'short', day: '2-digit', month: '2-digit', year: 'numeric'
  })
}

// ─── Validation
const validateStep1 = () => {
  const e = {}
  if (!form.value.firstName.trim()) e.firstName = locale.value === 'vi' ? 'Vui lòng nhập họ' : 'Please enter first name'
  if (!form.value.lastName.trim())  e.lastName  = locale.value === 'vi' ? 'Vui lòng nhập tên' : 'Please enter last name'
  if (!form.value.email.trim())     e.email     = locale.value === 'vi' ? 'Vui lòng nhập email' : 'Please enter email'
  else if (!/^[^@]+@[^@]+\.[^@]+$/.test(form.value.email)) e.email = locale.value === 'vi' ? 'Email không hợp lệ' : 'Invalid email'
  if (!form.value.phone.trim())     e.phone     = locale.value === 'vi' ? 'Vui lòng nhập số điện thoại' : 'Please enter phone number'
  err.value = e
  return !Object.keys(e).length
}

const goStep2 = () => { if (validateStep1()) currentStep.value = 2 }

// ─── Tạo booking nếu chưa có
const ensureBooking = async () => {
  if (booking.value.bookingId) return booking.value.bookingId
  
  // Kiểm tra xem khách hàng đã có đơn đặt phòng PENDING nào khớp hay chưa để tránh lỗi trùng lặp phòng
  try {
    const myBookingsRes = await axiosInst.get('/bookings/my')
    const existingPending = (myBookingsRes.data || []).find(b => {
      const isPending = b.status === 'PENDING'
      const isSameRoom = Number(b.roomId) === Number(booking.value.roomId)
      
      const bCheckIn = b.checkIn ? b.checkIn.split('T')[0] : ''
      const reqCheckIn = booking.value.checkIn ? booking.value.checkIn.split('T')[0] : ''
      
      const bCheckOut = b.checkOut ? b.checkOut.split('T')[0] : ''
      const reqCheckOut = booking.value.checkOut ? booking.value.checkOut.split('T')[0] : ''
      
      return isPending && isSameRoom && bCheckIn === reqCheckIn && bCheckOut === reqCheckOut
    })
    
    if (existingPending) {
      console.log('Tái sử dụng đơn đặt phòng PENDING trùng khớp:', existingPending.id)
      booking.value.bookingId = existingPending.id
      return existingPending.id
    }
  } catch (err) {
    console.warn('Lấy danh sách đơn đặt phòng trước đó thất bại:', err)
  }
  
  let method = 'CASH'
  if (payMethod.value === 'momo') {
    method = 'MOMO'
  } else if (payMethod.value === 'vnpay' || payMethod.value === 'vnpay_atm') {
    method = 'VNPAY'
  }

  let finalNote = form.value.note
  if (form.value.specialRequests && form.value.specialRequests.length > 0) {
    const prefixes = locale.value === 'vi' ? 'Yêu cầu thêm: ' : 'Special requests: '
    finalNote = `${prefixes}${form.value.specialRequests.join(', ')}. ${finalNote ? ('\n' + finalNote) : ''}`
  }

  const res = await axiosInst.post('/bookings', {
    roomId:        booking.value.roomId,
    checkIn:       booking.value.checkIn,
    checkOut:      booking.value.checkOut,
    numGuests:     booking.value.guests,
    note:          finalNote,
    paymentMethod: method,
    promoCode:     selectedPromoCode.value || null,
  })
  const id = res.data?.id || res.data?.bookingId
  booking.value.bookingId = id
  return id
}

// ─── VNPay: tạo booking → lấy URL → redirect
const handleVNPayRedirect = async () => {
  if (!validateStep1()) { currentStep.value = 1; return }
  paying.value = true
  err.value = {}
  try {
    const bookingId = await ensureBooking()
    const { data }  = await createVNPayUrl(bookingId, locale.value)
    if (data?.paymentUrl) {
      window.location.href = data.paymentUrl
    } else {
      err.value.submit = locale.value === 'vi' ? 'Không lấy được đường link thanh toán. Vui lòng thử lại.' : 'Failed to retrieve VNPay link. Please try again.'
    }
  } catch (e) {
    err.value.submit = e.response?.data?.message || (locale.value === 'vi' ? 'Lỗi kết nối. Vui lòng thử lại.' : 'Connection error. Please try again.')
  } finally {
    paying.value = false
  }
}

// ─── MoMo: tạo booking → lấy URL → redirect
const handleMoMoRedirect = async () => {
  if (!validateStep1()) { currentStep.value = 1; return }
  paying.value = true
  err.value = {}
  try {
    const bookingId = await ensureBooking()
    const { data }  = await createMoMoUrl(bookingId)
    if (data?.paymentUrl) {
      window.location.href = data.paymentUrl
    } else {
      err.value.submit = locale.value === 'vi' ? 'Không lấy được đường link thanh toán MoMo. Vui lòng thử lại.' : 'Failed to retrieve MoMo payment link. Please try again.'
    }
  } catch (e) {
    err.value.submit = e.response?.data?.message || (locale.value === 'vi' ? 'Lỗi kết nối. Vui lòng thử lại.' : 'Connection error. Please try again.')
  } finally {
    paying.value = false
  }
}

// ─── Onsite: tạo booking → hiện success
const handleOnsiteConfirm = async () => {
  if (!validateStep1()) { currentStep.value = 1; return }
  if (!form.value.agreed) { err.value = { agreed: locale.value === 'vi' ? 'Bạn cần đồng ý với điều khoản' : 'You must agree to the terms' }; return }
  paying.value = true
  err.value = {}
  try {
    await ensureBooking()
    await new Promise(r => setTimeout(r, 800))
    bookingRef.value = String(Math.floor(Math.random() * 900000 + 100000))
    success.value = true
  } catch (e) {
    err.value.submit = e.response?.data?.message || (locale.value === 'vi' ? 'Có lỗi xảy ra. Vui lòng thử lại.' : 'An error occurred. Please try again.')
  } finally {
    paying.value = false
  }
}

// ─── Confetti
const cdotStyle = (i) => {
  const colors = ['#5392f9','#ff567d','#ffb703','#34d399','#a78bfa','#f97316']
  const a = (i / 12) * 2 * Math.PI
  const r = 65 + (i % 3) * 15
  return {
    background: colors[i % colors.length],
    left: `calc(50% + ${Math.cos(a) * r}px)`,
    top:  `calc(50% + ${Math.sin(a) * r}px)`,
    animationDelay: `${i * 0.04}s`,
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}

.pay-page{font-family:'Inter',sans-serif;background:#f2f4f9;min-height:100vh;color:#1e2130}

/* HEADER */
.pay-header{background:#fff;border-bottom:1px solid #e5e7eb;position:sticky;top:0;z-index:50;box-shadow:0 2px 12px rgba(0,0,0,.05)}
.pay-header-inner{max-width:1160px;margin:0 auto;padding:.85rem 1.5rem;display:flex;align-items:center;justify-content:space-between;gap:1rem}
.logo{font-size:1.4rem;font-weight:800;color:#5392f9;text-decoration:none;letter-spacing:-.05em}
.logo-red{color:#ff567d}
.hdr-back{display:flex;align-items:center;gap:.3rem;font-size:.82rem;font-weight:600;color:#6b7280;text-decoration:none;transition:color .2s;white-space:nowrap}
.hdr-back:hover{color:#5392f9}

/* Steps */
.header-steps{display:flex;align-items:center;flex:1;justify-content:center;gap:0;max-width:480px}
.step-wrap{display:flex;align-items:center;gap:.45rem}
.step-circle{width:30px;height:30px;border-radius:50%;background:#e5e7eb;color:#9ca3af;display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:700;transition:all .3s;flex-shrink:0}
.step-wrap.active .step-circle{background:#5392f9;color:#fff;box-shadow:0 0 0 4px rgba(83,146,249,.2)}
.step-wrap.done .step-circle{background:#10b981;color:#fff}
.step-label{font-size:.78rem;font-weight:600;color:#9ca3af;transition:color .3s;white-space:nowrap}
.step-wrap.active .step-label{color:#5392f9}
.step-wrap.done .step-label{color:#10b981}
.step-connector{width:50px;height:2px;background:#e5e7eb;margin:0 .7rem;transition:background .3s}
.step-connector.filled{background:#10b981}

/* BODY */
.pay-body{max-width:1160px;margin:0 auto;padding:2rem 1.5rem;display:grid;grid-template-columns:1fr 360px;gap:2rem;align-items:start}

/* SECTION CARD */
.scard{background:#fff;border-radius:20px;padding:1.75rem;box-shadow:0 4px 24px rgba(0,0,0,.06);border:1px solid #e5e7eb;margin-bottom:1.25rem}
.scard-title{display:flex;align-items:center;gap:.65rem;margin-bottom:1.5rem}
.scard-title h2{font-size:1.1rem;font-weight:700}

/* FORM */
.fgrid-2{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
.fgroup{display:flex;flex-direction:column;gap:.35rem;margin-bottom:.9rem}
.fgroup:last-child{margin-bottom:0}
.fgroup label{font-size:.72rem;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.05em}
.opt{font-size:.68rem;text-transform:none;letter-spacing:0;font-weight:400;color:#9ca3af}
.fgroup input,.fgroup select,.fgroup textarea{width:100%;padding:.65rem .95rem;border:1.5px solid #e5e7eb;border-radius:11px;font-size:.875rem;font-weight:500;color:#1e2130;font-family:'Inter',sans-serif;background:#f9fafb;outline:none;transition:all .2s}
.fgroup input:focus,.fgroup select:focus,.fgroup textarea:focus{border-color:#5392f9;background:#fff;box-shadow:0 0 0 3px rgba(83,146,249,.1)}
.fgroup.ferr input,.fgroup.ferr select{border-color:#ef4444;background:#fff5f5}
.fgroup textarea{resize:vertical;min-height:75px}
.inp-wrap{position:relative}
.inp-wrap input,.inp-wrap select{padding-left:2.2rem}
.inp-ico{position:absolute;left:.7rem;top:50%;transform:translateY(-50%);color:#9ca3af;pointer-events:none}
.emsg{font-size:.72rem;color:#ef4444;font-weight:600}

/* POLICY STRIP */
.policy-strip{background:#fff;border-radius:18px;border:1px solid #e5e7eb;padding:1.25rem 1.5rem;display:flex;flex-direction:column;gap:.9rem;box-shadow:0 4px 16px rgba(0,0,0,.05);margin-bottom:1.25rem}
.ps-item{display:flex;gap:.85rem;align-items:flex-start}
.ps-item strong{font-size:.875rem;font-weight:700;color:#1e2130;display:block;margin-bottom:.15rem}
.ps-item p{font-size:.78rem;color:#6b7280;line-height:1.5}

/* PAYMENT METHODS */
.method-list{display:flex;flex-direction:column;gap:.75rem;margin-bottom:1.25rem}
.method-item{display:flex;align-items:center;gap:.9rem;padding:.9rem 1.1rem;border-radius:14px;border:2px solid #e5e7eb;cursor:pointer;transition:all .2s;background:#f9fafb}
.method-item:hover{border-color:rgba(83,146,249,.5);background:#fff}
.method-item.selected{border-color:#5392f9;background:rgba(83,146,249,.04)}
.radio-ring{width:20px;height:20px;border-radius:50%;border:2px solid #d1d5db;flex-shrink:0;display:flex;align-items:center;justify-content:center;transition:border-color .2s}
.radio-ring.active{border-color:#5392f9}
.radio-dot{width:10px;height:10px;border-radius:50%;background:#5392f9}
.method-body{flex:1}
.method-name{font-size:.875rem;font-weight:700;color:#1e2130;display:flex;align-items:center;gap:.5rem}
.method-sub{font-size:.75rem;color:#6b7280;margin-top:.15rem}
.badge-rec{font-size:.65rem;font-weight:800;background:#dbeafe;color:#1d4ed8;padding:.2rem .55rem;border-radius:999px;letter-spacing:.03em}
.method-logos{display:flex;gap:.4rem;align-items:center}
.method-logos img{height:20px;object-fit:contain}
.vnpay-badge{background:linear-gradient(135deg,#003087,#0066cc);color:#fff;font-size:.7rem;font-weight:800;padding:.3rem .8rem;border-radius:7px;letter-spacing:.05em}

/* VNPAY INFO BOX */
.vnpay-info-box{background:linear-gradient(135deg,#eff6ff,#f0f9ff);border:1px solid #bfdbfe;border-radius:14px;padding:1.1rem 1.25rem;margin-bottom:.5rem}
.vib-top{display:flex;gap:1rem;align-items:flex-start;margin-bottom:.85rem}
.vib-title{font-size:.9rem;font-weight:700;color:#1e40af;margin-bottom:.25rem}
.vib-desc{font-size:.78rem;color:#3b82f6;line-height:1.6}
.vib-steps{display:grid;grid-template-columns:1fr 1fr;gap:.5rem}
.vib-step{display:flex;align-items:center;gap:.5rem;font-size:.76rem;font-weight:600;color:#1d4ed8}
.vib-step span{width:20px;height:20px;border-radius:50%;background:#3b82f6;color:#fff;display:flex;align-items:center;justify-content:center;font-size:.68rem;font-weight:800;flex-shrink:0}

/* INFO BANNER */
.info-banner{display:flex;gap:.7rem;align-items:flex-start;background:#eff6ff;border:1px solid #bfdbfe;border-radius:12px;padding:.9rem 1.1rem;font-size:.82rem;color:#1e40af;line-height:1.6;margin-bottom:.5rem}

/* REVIEW ROWS */
.review-row-sm{display:flex;justify-content:space-between;padding:.4rem 0;border-bottom:1px solid #f3f4f6;font-size:.85rem}
.review-row-sm span{color:#6b7280}
.review-row-sm strong{color:#1e2130}

/* AGREE */
.agree-label{display:flex;align-items:flex-start;gap:.6rem;font-size:.82rem;font-weight:500;color:#6b7280;cursor:pointer;user-select:none;margin-top:1rem;line-height:1.6}
.agree-label input{display:none}
.chkbox{width:18px;height:18px;border:2px solid #d1d5db;border-radius:5px;flex-shrink:0;background:#fff;position:relative;transition:all .2s}
.agree-label input:checked ~ .chkbox{background:#5392f9;border-color:#5392f9}
.agree-label input:checked ~ .chkbox::after{content:'';position:absolute;left:4px;top:1px;width:6px;height:10px;border:solid #fff;border-width:0 2px 2px 0;transform:rotate(45deg)}
.link-blue{color:#5392f9;text-decoration:none}
.link-blue:hover{text-decoration:underline}

/* BUTTONS */
.btn-primary{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;padding:.95rem 2rem;border-radius:13px;background:linear-gradient(135deg,#5392f9,#7c3aed);color:#fff;border:none;font-size:.95rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;box-shadow:0 6px 20px rgba(83,146,249,.35);transition:all .2s;text-decoration:none}
.btn-primary:hover{transform:translateY(-2px);box-shadow:0 10px 28px rgba(83,146,249,.45)}
.w-full{width:100%}

.btn-vnpay{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;flex:1;padding:.95rem 2rem;border-radius:13px;background:linear-gradient(135deg,#003087,#0066cc);color:#fff;border:none;font-size:.95rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;box-shadow:0 6px 20px rgba(0,87,168,.35);transition:all .2s}
.btn-vnpay:hover{transform:translateY(-2px);box-shadow:0 10px 28px rgba(0,87,168,.45)}
.btn-vnpay:disabled{opacity:.65;cursor:not-allowed;transform:none}

.btn-momo{display:inline-flex;align-items:center;justify-content:center;gap:.6rem;flex:1;padding:.95rem 2rem;border-radius:13px;background:linear-gradient(135deg,#a8269a,#d03cb2);color:#fff;border:none;font-size:.95rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;box-shadow:0 6px 20px rgba(168,38,154,.35);transition:all .2s}
.btn-momo:hover{transform:translateY(-2px);box-shadow:0 10px 28px rgba(168,38,154,.45)}
.btn-momo:disabled{opacity:.65;cursor:not-allowed;transform:none}

.momo-badge-img{width:36px;height:36px;border-radius:8px;object-fit:contain;flex-shrink:0}

/* MOMO INFO BOX */
.momo-info-box{background:linear-gradient(135deg,#fdf2fb,#fce7f9);border:1px solid #f0abde;border-radius:14px;padding:1.1rem 1.25rem;margin-bottom:.5rem}
.momo-title{font-size:.9rem;font-weight:700;color:#a8269a;margin-bottom:.25rem}
.momo-desc{font-size:.78rem;color:#c0399b;line-height:1.6}
.momo-step{color:#a8269a !important}
.momo-num{background:#a8269a !important}

.btn-confirm{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;flex:1;padding:.95rem 2rem;border-radius:13px;background:linear-gradient(135deg,#059669,#10b981);color:#fff;border:none;font-size:.95rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;box-shadow:0 6px 20px rgba(16,185,129,.35);transition:all .2s}
.btn-confirm:hover{transform:translateY(-2px)}
.btn-confirm:disabled{opacity:.65;cursor:not-allowed;transform:none}

.btn-ghost{display:inline-flex;align-items:center;gap:.35rem;padding:.95rem 1.4rem;border-radius:13px;background:#fff;color:#6b7280;border:1.5px solid #e5e7eb;font-size:.875rem;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;text-decoration:none}
.btn-ghost:hover{border-color:#5392f9;color:#5392f9}

.step-nav{display:flex;gap:1rem;align-items:stretch;margin-top:0}
.spin{width:20px;height:20px;border:2.5px solid rgba(255,255,255,.4);border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}

.err-banner{display:flex;align-items:center;gap:.6rem;background:#fef2f2;border:1px solid #fecaca;border-radius:10px;padding:.75rem 1rem;margin-top:.75rem;font-size:.82rem;font-weight:600;color:#dc2626}

/* ORDER SUMMARY */
.summary-card{background:#fff;border-radius:22px;border:1px solid #e5e7eb;box-shadow:0 8px 32px rgba(0,0,0,.08);padding:1.5rem;position:sticky;top:85px}
.sum-title{font-size:1rem;font-weight:800;margin-bottom:1.1rem}
.room-prev{display:flex;gap:.9rem;margin-bottom:1.1rem}
.rthumb{width:84px;height:66px;border-radius:11px;overflow:hidden;flex-shrink:0;position:relative}
.rthumb img{width:100%;height:100%;object-fit:cover}
.rthumb-badge{position:absolute;bottom:3px;left:3px;background:rgba(0,0,0,.7);color:#fff;font-size:.58rem;font-weight:800;padding:.2rem .45rem;border-radius:4px;text-transform:uppercase}
.rinfo{flex:1;min-width:0}
.rinfo h4{font-size:.85rem;font-weight:700;margin-bottom:.25rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.rinfo p{font-size:.72rem;color:#6b7280;display:flex;align-items:center;gap:.25rem;margin-bottom:.25rem}
.stars{display:flex;align-items:center;gap:.15rem}
.stars span{font-size:.72rem;font-weight:700;margin-left:.2rem}

.divider{height:1px;background:#f3f4f6;margin:.85rem 0}
.date-grid{display:grid;grid-template-columns:1fr auto 1fr;gap:.4rem;align-items:center}
.dblock{display:flex;flex-direction:column;gap:.1rem}
.dlabel{font-size:.62rem;font-weight:800;color:#9ca3af;text-transform:uppercase;letter-spacing:.05em;display:flex;align-items:center;gap:.3rem}
.dval{font-size:.82rem;font-weight:700}
.dtime{font-size:.65rem;color:#9ca3af}
.nights-pill{background:#5392f9;color:#fff;font-size:.7rem;font-weight:800;padding:.3rem .65rem;border-radius:999px;white-space:nowrap;text-align:center}
.guest-row{display:flex;align-items:center;gap:.45rem;font-size:.82rem;font-weight:600}

.breakdown{display:flex;flex-direction:column;gap:.5rem;margin-bottom:.5rem}
.bline{display:flex;justify-content:space-between;font-size:.82rem;color:#6b7280}
.promo-green{color:#10b981}

.total-box{display:flex;justify-content:space-between;align-items:center;background:linear-gradient(135deg,#eff6ff,#f0fdf4);border-radius:13px;padding:.9rem 1.1rem}
.total-label{font-size:.82rem;font-weight:800}
.total-note{font-size:.65rem;color:#9ca3af;margin-top:.1rem}
.total-amt{font-size:1.2rem;font-weight:800;color:#5392f9}

.trust-list{display:flex;flex-direction:column;gap:.4rem}
.titem{display:flex;align-items:center;gap:.45rem;font-size:.75rem;font-weight:600;color:#6b7280}

/* Promo Selection Trigger Button */
.btn-select-promo-trigger {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  border: 1.5px dashed #5392f9;
  background: rgba(83, 146, 249, 0.05);
  color: #5392f9;
  border-radius: 12px;
  font-size: 0.875rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  font-family: 'Inter', sans-serif;
}
.btn-select-promo-trigger:hover {
  background: rgba(83, 146, 249, 0.1);
  transform: translateY(-1px);
}

/* Applied Promo Indicator Box */
.promo-applied-box {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(16, 185, 129, 0.06);
  border: 1.5px solid #10b981;
  border-radius: 12px;
  padding: 0.75rem 1rem;
  margin-top: 0.5rem;
}
.pab-left {
  display: flex;
  align-items: center;
  gap: 0.6rem;
}
.pab-info {
  display: flex;
  flex-direction: column;
}
.pab-code {
  font-family: 'Courier New', monospace;
  font-size: 0.85rem;
  font-weight: 800;
  color: #065f46;
}
.pab-desc {
  font-size: 0.75rem;
  color: #10b981;
  font-weight: 600;
}
.pab-actions {
  display: flex;
  align-items: center;
  gap: 0.65rem;
}
.btn-change-promo {
  background: #5392f9;
  color: #fff;
  border: none;
  border-radius: 6px;
  padding: 0.3rem 0.65rem;
  font-size: 0.75rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  transition: opacity 0.2s;
}
.btn-change-promo:hover {
  opacity: 0.9;
}
.btn-remove-promo {
  background: none;
  border: none;
  color: #6b7280;
  font-size: 0.85rem;
  cursor: pointer;
  padding: 0.2rem;
  transition: color 0.2s;
}
.btn-remove-promo:hover {
  color: #ff567d;
}

/* Modal Backdrop */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

/* Promo Selection Modal */
.promo-select-modal {
  background: #fff;
  border-radius: 22px;
  width: 100%;
  max-width: 520px;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 30px 80px rgba(0,0,0,0.2);
  animation: modalSlideUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  overflow: hidden;
}
@keyframes modalSlideUp {
  from { transform: translateY(30px) scale(0.95); opacity: 0; }
  to { transform: translateY(0) scale(1); opacity: 1; }
}

.ps-modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #f3f4f6;
  flex-shrink: 0;
}
.ps-modal-header h3 {
  font-size: 1.05rem;
  font-weight: 800;
  color: #1e2130;
}
.btn-close-modal-promo {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  border: 1px solid #e5e7eb;
  background: #fff;
  cursor: pointer;
  font-size: 0.85rem;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}
.btn-close-modal-promo:hover {
  background: #f9fafb;
  color: #1e2130;
}

.ps-modal-body {
  padding: 1.25rem 1.5rem;
  overflow-y: auto;
  flex: 1;
}

.ps-modal-loading {
  padding: 4rem 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  color: #6b7280;
  text-align: center;
}
.spinner-promo {
  width: 32px;
  height: 32px;
  border: 3px solid #e5e7eb;
  border-top-color: #5392f9;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

/* Voucher Cards styling */
.promo-cards-list {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}
.voucher-card {
  display: flex;
  background: #fff;
  border: 2px dashed #e5e7eb;
  border-radius: 14px;
  overflow: hidden;
  transition: all 0.2s;
  position: relative;
}
.voucher-card:hover:not(.voucher-disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.06);
  border-color: #5392f9;
}
.voucher-selected {
  border-color: #5392f9 !important;
  border-style: solid !important;
  background: rgba(83, 146, 249, 0.01);
}

/* Ticket cutout badge side */
.vc-badge {
  background: #5392f9;
  color: #fff;
  padding: 1.25rem 0.85rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-width: 90px;
  max-width: 90px;
  position: relative;
  text-align: center;
  flex-shrink: 0;
}
.vc-badge-value {
  font-size: 1.25rem;
  font-weight: 800;
  line-height: 1.1;
  letter-spacing: -0.02em;
}
.vc-badge-label {
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  margin-top: 0.15rem;
  opacity: 0.9;
}
.vc-badge-cutout-top,
.vc-badge-cutout-bottom {
  position: absolute;
  width: 12px;
  height: 12px;
  background: #fff;
  border-radius: 50%;
  right: -6px;
  z-index: 2;
}
.vc-badge-cutout-top { top: -6px; }
.vc-badge-cutout-bottom { bottom: -6px; }

/* Voucher Details side */
.vc-content {
  flex: 1;
  padding: 0.95rem 1.1rem;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.vc-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
  margin-bottom: 0.25rem;
}
.vc-code {
  font-family: 'Courier New', monospace;
  font-size: 0.82rem;
  font-weight: 800;
  color: #3b4fd1;
  letter-spacing: 0.04em;
}
.vc-selected-tag {
  font-size: 0.65rem;
  font-weight: 800;
  background: rgba(16, 185, 129, 0.1);
  color: #10b981;
  padding: 0.15rem 0.5rem;
  border-radius: 99px;
}
.vc-desc {
  font-size: 0.78rem;
  color: #374151;
  font-weight: 500;
  line-height: 1.35;
  margin-bottom: 0.5rem;
}
.vc-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem;
  font-size: 0.68rem;
  color: #6b7280;
  margin-bottom: 0.75rem;
}
.vc-cond { font-weight: 600; }
.vc-date { font-weight: 500; }

.vc-action-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: auto;
  border-top: 1px solid #f3f4f6;
  padding-top: 0.65rem;
  gap: 0.5rem;
}

.vc-error-msg {
  font-size: 0.7rem;
  color: #ff567d;
  font-weight: 600;
}
.vc-success-msg {
  font-size: 0.7rem;
  color: #10b981;
  font-weight: 700;
}
.vc-btn-wrap {
  margin-left: auto;
}

.btn-apply-voucher {
  background: #10b981;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 0.35rem 0.95rem;
  font-size: 0.78rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  transition: opacity 0.2s;
}
.btn-apply-voucher:hover:not(:disabled) {
  opacity: 0.9;
}
.btn-apply-voucher:disabled {
  background: #e5e7eb;
  color: #9ca3af;
  cursor: not-allowed;
}

/* Ineligible Voucher disabled layout */
.voucher-disabled {
  opacity: 0.7;
  background: #fbfbfb;
}
.voucher-disabled .vc-badge {
  background: #9ca3af !important;
}
.voucher-disabled .vc-code {
  color: #6b7280;
}

/* Empty State */
.promo-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 1.5rem;
  color: #9ca3af;
  text-align: center;
  gap: 0.5rem;
}
.promo-empty-state p {
  font-size: 0.8rem;
  font-weight: 500;
}



/* COLORS */
.ico-blue{color:#5392f9}
.ico-green{color:#10b981}
.ico-yellow{color:#ffb703}

/* SUCCESS OVERLAY */
.overlay{position:fixed;inset:0;z-index:200;background:rgba(0,0,0,.6);backdrop-filter:blur(8px);display:flex;align-items:center;justify-content:center;padding:1rem}
.success-modal{background:#fff;border-radius:26px;padding:2.75rem 2.25rem;max-width:460px;width:100%;text-align:center;box-shadow:0 40px 100px rgba(0,0,0,.3);animation:modIn .5s cubic-bezier(.34,1.56,.64,1)}
@keyframes modIn{from{transform:scale(.7) translateY(40px);opacity:0}to{transform:scale(1) translateY(0);opacity:1}}
.sc-anim{position:relative;width:96px;height:96px;margin:0 auto 1.4rem}
.sc-circle{width:96px;height:96px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);display:flex;align-items:center;justify-content:center;box-shadow:0 20px 50px rgba(16,185,129,.4);animation:popIn .5s cubic-bezier(.34,1.56,.64,1) .1s both}
@keyframes popIn{from{transform:scale(0)}to{transform:scale(1)}}
.chk-svg{width:50px;height:50px}
.chk-bg{stroke:rgba(255,255,255,.3);stroke-width:2}
.chk-path{stroke:#fff;stroke-width:4;stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:50;stroke-dashoffset:50;animation:draw .5s ease .55s forwards}
@keyframes draw{to{stroke-dashoffset:0}}
.confetti-ring{position:absolute;inset:0;pointer-events:none}
.cdot{position:absolute;width:8px;height:8px;border-radius:2px;transform:translate(-50%,-50%);animation:burst .6s ease-out .4s both}
@keyframes burst{from{transform:translate(-50%,-50%) scale(0);opacity:1}to{transform:translate(-50%,-50%) scale(1);opacity:0}}
.success-modal h2{font-size:1.4rem;font-weight:800;margin-bottom:.5rem}
.success-modal > p{font-size:.875rem;color:#6b7280;line-height:1.6;margin-bottom:1.4rem}
.ref-box{background:linear-gradient(135deg,#eff6ff,#f0fdf4);border-radius:15px;padding:1.1rem;margin-bottom:1.6rem;text-align:left}
.ref-top{display:flex;justify-content:space-between;align-items:center;padding-bottom:.65rem;margin-bottom:.65rem;border-bottom:1px dashed #d1d5db}
.ref-lbl{font-size:.7rem;font-weight:800;color:#9ca3af;text-transform:uppercase}
.ref-code{font-size:1.1rem;font-weight:800;color:#5392f9}
.ref-detail{display:flex;flex-direction:column;gap:.35rem}
.ref-row{display:flex;align-items:center;gap:.45rem;font-size:.82rem;color:#6b7280}
.ref-total{justify-content:space-between;font-weight:700}
.ref-total strong{font-size:.95rem}
.sc-btns{display:flex;flex-direction:column;gap:.7rem}

/* TRANSITIONS */
.slide-enter-active{transition:all .3s ease}
.slide-leave-active{transition:all .2s ease}
.slide-enter-from{opacity:0;transform:translateX(18px)}
.slide-leave-to{opacity:0;transform:translateX(-18px)}
.fade-enter-active,.fade-leave-active{transition:opacity .3s ease}
.fade-enter-from,.fade-leave-to{opacity:0}
.expand-enter-active,.expand-leave-active{transition:all .3s ease;overflow:hidden;max-height:500px}
.expand-enter-from,.expand-leave-to{max-height:0;opacity:0}

/* RESPONSIVE */
@media(max-width:900px){
  .pay-body{grid-template-columns:1fr}
  .pay-right{order:-1}
  .summary-card{position:static}
  .header-steps{display:none}
}
@media(max-width:580px){
  .pay-body{padding:1rem}
  .fgrid-2{grid-template-columns:1fr}
  .scard{padding:1.25rem}
  .success-modal{padding:2rem 1.25rem}
  .vib-steps{grid-template-columns:1fr}
}
@media(max-width:768px){
  .header-lang-selector-dropdown { display: none !important; }
  .logo-word { display: none !important; }
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

.special-requests-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.5rem 1rem;
  margin-bottom: 0.75rem;
  background: #f9fafb;
  padding: 0.75rem 1rem;
  border-radius: 11px;
  border: 1.5px solid #e5e7eb;
}
.req-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}
.req-item input {
  width: 16px;
  height: 16px;
  cursor: pointer;
  accent-color: #5392f9;
}
.req-item span {
  font-size: 0.8rem !important;
  font-weight: 500 !important;
  color: #374151 !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
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
