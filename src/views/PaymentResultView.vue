<template>
  <div class="result-page">
    <div class="result-card" :class="isSuccess ? 'card-success' : 'card-fail'">

      <!-- Animated Icon -->
      <div class="icon-circle" :class="isSuccess ? 'icon-success' : 'icon-fail'">
        <svg v-if="isSuccess" viewBox="0 0 52 52" class="checkmark-svg">
          <circle class="checkmark-circle" cx="26" cy="26" r="24" fill="none" />
          <path class="checkmark-check" fill="none" d="M14 27l8 8 16-16" />
        </svg>
        <svg v-else viewBox="0 0 52 52" class="crossmark-svg">
          <circle class="crossmark-circle" cx="26" cy="26" r="24" fill="none" />
          <path class="crossmark-x" fill="none" d="M16 16 36 36 M36 16 16 36" />
        </svg>
      </div>

      <!-- Title -->
      <h1 class="result-title" :class="isSuccess ? 'title-success' : 'title-fail'">
        {{ isSuccess ? 'Thanh toán thành công!' : 'Thanh toán thất bại' }}
      </h1>

      <!-- Order ID badge -->
      <div class="order-id-badge" v-if="orderId">
        <span class="badge-label">Mã đơn hàng</span>
        <span class="badge-value">#{{ orderId }}</span>
      </div>

      <!-- Success description -->
      <p v-if="isSuccess" class="result-desc">
        🎉 Giao dịch của bạn đã được xử lý thành công. Chúng tôi sẽ gửi xác nhận
        đặt phòng qua email của bạn trong vài phút.
      </p>

      <!-- Fail message -->
      <div v-else class="fail-message-box">
        <span class="fail-icon-inline">⚠️</span>
        <p class="fail-desc">{{ decodedMessage || 'Giao dịch không thể hoàn tất. Vui lòng thử lại hoặc liên hệ hỗ trợ.' }}</p>
      </div>

      <!-- Divider -->
      <div class="divider"></div>

      <!-- Action Buttons -->
      <div class="action-btns">
        <RouterLink v-if="isSuccess" to="/bookings" class="btn-primary" id="btn-view-bookings">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="M9 12h6M9 16h4"/></svg>
          Xem đặt phòng của tôi
        </RouterLink>

        <template v-else>
          <RouterLink to="/bookings" class="btn-primary" id="btn-retry-booking">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></svg>
            Thử lại
          </RouterLink>
          <RouterLink to="/" class="btn-secondary" id="btn-go-home">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Về trang chủ
          </RouterLink>
        </template>
      </div>

      <!-- Footer note -->
      <p class="footer-note">
        Nếu bạn cần hỗ trợ, vui lòng liên hệ
        <a href="mailto:support@hotelstay.vn">support@hotelstay.vn</a>
      </p>
    </div>

    <!-- Brand -->
    <RouterLink to="/" class="brand-link">HOTEL<span>STAY</span></RouterLink>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const resultCode = route.query.resultCode
const orderId    = route.query.orderId
const message    = route.query.message

const isSuccess = computed(() => resultCode === '0')

const decodedMessage = computed(() => {
  if (!message) return ''
  try {
    return decodeURIComponent(message)
  } catch {
    return message
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }

.result-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem 1rem 4rem;
  background: linear-gradient(135deg, #f0f4ff 0%, #faf5ff 50%, #f0fdf4 100%);
  font-family: 'Inter', sans-serif;
  position: relative;
}

/* CARD */
.result-card {
  background: white;
  border-radius: 24px;
  padding: 3rem 2.5rem;
  width: 100%;
  max-width: 480px;
  text-align: center;
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.1), 0 8px 20px rgba(0, 0, 0, 0.06);
  animation: fadeUp 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both;
  position: relative;
  overflow: hidden;
}

.result-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 4px;
  border-radius: 24px 24px 0 0;
}

.card-success::before { background: linear-gradient(90deg, #10b981, #34d399); }
.card-fail::before    { background: linear-gradient(90deg, #f97316, #ef4444); }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(24px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* ICON CIRCLE */
.icon-circle {
  width: 88px;
  height: 88px;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.75rem;
}

.icon-success {
  background: radial-gradient(circle, #d1fae5, #a7f3d0);
  box-shadow: 0 0 0 12px rgba(16, 185, 129, 0.1);
}

.icon-fail {
  background: radial-gradient(circle, #fee2e2, #fecaca);
  box-shadow: 0 0 0 12px rgba(239, 68, 68, 0.1);
}

/* SVG Animations */
.checkmark-svg, .crossmark-svg {
  width: 52px;
  height: 52px;
}

.checkmark-circle {
  stroke: #10b981;
  stroke-width: 2.5;
  stroke-dasharray: 166;
  stroke-dashoffset: 166;
  animation: drawCircle 0.6s 0.1s ease-out forwards;
}

.checkmark-check {
  stroke: #10b981;
  stroke-width: 3;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-dasharray: 48;
  stroke-dashoffset: 48;
  animation: drawCheck 0.4s 0.6s ease-out forwards;
}

.crossmark-circle {
  stroke: #ef4444;
  stroke-width: 2.5;
  stroke-dasharray: 166;
  stroke-dashoffset: 166;
  animation: drawCircle 0.6s 0.1s ease-out forwards;
}

.crossmark-x {
  stroke: #ef4444;
  stroke-width: 3;
  stroke-linecap: round;
  stroke-dasharray: 60;
  stroke-dashoffset: 60;
  animation: drawCheck 0.4s 0.6s ease-out forwards;
}

@keyframes drawCircle {
  to { stroke-dashoffset: 0; }
}
@keyframes drawCheck {
  to { stroke-dashoffset: 0; }
}

/* TITLE */
.result-title {
  font-size: 1.65rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  margin-bottom: 1rem;
}
.title-success { color: #065f46; }
.title-fail    { color: #7f1d1d; }

/* ORDER ID BADGE */
.order-id-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 999px;
  padding: 0.35rem 1rem;
  margin-bottom: 1.25rem;
}
.badge-label {
  font-size: 0.72rem;
  font-weight: 700;
  color: #94a3b8;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.badge-value {
  font-size: 0.82rem;
  font-weight: 800;
  color: #1e293b;
}

/* DESCRIPTIONS */
.result-desc {
  font-size: 0.92rem;
  color: #475569;
  line-height: 1.65;
  margin-bottom: 1.5rem;
}

.fail-message-box {
  display: flex;
  align-items: flex-start;
  gap: 0.6rem;
  background: #fff7ed;
  border: 1px solid #fed7aa;
  border-radius: 12px;
  padding: 0.9rem 1rem;
  margin-bottom: 1.5rem;
  text-align: left;
}
.fail-icon-inline { font-size: 1.1rem; line-height: 1.4; flex-shrink: 0; }
.fail-desc {
  font-size: 0.875rem;
  color: #9a3412;
  line-height: 1.6;
}

/* DIVIDER */
.divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, #e2e8f0, transparent);
  margin: 0.5rem 0 1.75rem;
}

/* BUTTONS */
.action-btns {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.btn-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  background: linear-gradient(135deg, #1a6cf7, #3d8ef8);
  color: white;
  text-decoration: none;
  padding: 0.875rem 1.5rem;
  border-radius: 12px;
  font-size: 0.95rem;
  font-weight: 700;
  box-shadow: 0 6px 18px rgba(26, 108, 247, 0.3);
  transition: all 0.22s cubic-bezier(0.4, 0, 0.2, 1);
}
.btn-primary:hover {
  background: linear-gradient(135deg, #1558d6, #2a7cf0);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(26, 108, 247, 0.4);
}

.btn-secondary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  background: white;
  color: #475569;
  text-decoration: none;
  padding: 0.875rem 1.5rem;
  border-radius: 12px;
  font-size: 0.95rem;
  font-weight: 700;
  border: 1.5px solid #e2e8f0;
  transition: all 0.2s;
}
.btn-secondary:hover {
  border-color: #1a6cf7;
  color: #1a6cf7;
  background: #eff6ff;
}

/* FOOTER NOTE */
.footer-note {
  font-size: 0.78rem;
  color: #94a3b8;
}
.footer-note a {
  color: #1a6cf7;
  font-weight: 600;
  text-decoration: none;
}
.footer-note a:hover { text-decoration: underline; }

/* BRAND */
.brand-link {
  position: absolute;
  top: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  font-size: 1.2rem;
  font-weight: 800;
  letter-spacing: -0.05em;
  color: #1a6cf7;
  text-decoration: none;
  white-space: nowrap;
}
.brand-link span { color: #ff567d; }

@media (max-width: 520px) {
  .result-card { padding: 2rem 1.25rem; border-radius: 18px; }
  .result-title { font-size: 1.4rem; }
}
</style>
