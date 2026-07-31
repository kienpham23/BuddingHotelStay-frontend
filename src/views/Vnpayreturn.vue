<template>
  <div class="ret-page" style="position: relative;">
    <!-- Language Selector -->
    <div class="header-lang-selector-dropdown" style="position: absolute; top: 20px; right: 20px; z-index: 100;">
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

    <div class="ret-card">

      <!-- LOADING -->
      <div v-if="state === 'loading'" class="ret-state">
        <div class="ret-spin"></div>
        <h2>{{ $t('payment.verifying_txn') }}</h2>
        <p>{{ $t('payment.dont_close') }}</p>
      </div>

      <!-- SUCCESS -->
      <div v-else-if="state === 'success'" class="ret-state">
        <div class="ret-icon ret-icon-ok">
          <svg viewBox="0 0 52 52" class="chk-svg">
            <circle cx="26" cy="26" r="25" fill="none" class="chk-bg"/>
            <path fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8" class="chk-path"/>
          </svg>
        </div>
        <h2>{{ isInvoice ? $t('payment.invoice_success_title') : $t('payment.booking_success_title') }}</h2>
        <p>{{ message || (isInvoice ? $t('payment.invoice_success_desc') : $t('payment.booking_success_desc')) }}</p>
        <div class="ref-box" v-if="bookingId && !isInvoice">
          <span>{{ $t('payment.booking_id') }}</span>
          <strong>#{{ bookingId }}</strong>
        </div>
        <div class="ref-box" v-if="bookingId && isInvoice">
          <span>{{ $t('payment.invoice_id') }}</span>
          <strong>#INV-{{ bookingId }}</strong>
        </div>
        <div class="ret-btns">
          <RouterLink v-if="isInvoice" to="/host/revenue" class="btn-primary">{{ $t('payment.btn_manage_revenue') }}</RouterLink>
          <RouterLink v-else to="/bookings" class="btn-primary">{{ $t('payment.btn_view_booking') }}</RouterLink>
          <RouterLink to="/" class="btn-ghost">{{ $t('payment.btn_home') }}</RouterLink>
        </div>
      </div>

      <!-- FAILED -->
      <div v-else-if="state === 'failed'" class="ret-state">
        <div class="ret-icon ret-icon-fail">
          <XCircle :size="42" color="#fff" />
        </div>
        <h2>{{ isInvoice ? $t('payment.invoice_failed_title') : $t('payment.booking_failed_title') }}</h2>
        <p>{{ message || (isInvoice ? $t('payment.invoice_failed_desc') : $t('payment.booking_failed_desc')) }}</p>
        <div class="ret-btns">
          <RouterLink v-if="isInvoice" to="/host/revenue" class="btn-primary">{{ $t('payment.btn_back_revenue') }}</RouterLink>
          <button v-else class="btn-primary" @click="retryPayment">{{ $t('payment.btn_retry_payment') }}</button>
          <RouterLink v-if="!isInvoice" to="/bookings" class="btn-ghost">{{ $t('payment.btn_back_booking') }}</RouterLink>
          <RouterLink v-else to="/" class="btn-ghost">{{ $t('payment.btn_home') }}</RouterLink>
        </div>
      </div>

      <!-- ERROR (network / không xác minh được) -->
      <div v-else class="ret-state">
        <div class="ret-icon ret-icon-fail">
          <AlertTriangle :size="42" color="#fff" />
        </div>
        <h2>{{ $t('payment.cannot_verify') }}</h2>
        <p>{{ message || $t('payment.verify_error_desc') }}</p>
        <div class="ret-btns">
          <RouterLink v-if="isInvoice" to="/host/revenue" class="btn-primary">{{ $t('payment.btn_back_revenue') }}</RouterLink>
          <RouterLink v-else to="/bookings" class="btn-primary">{{ $t('payment.btn_check_booking') }}</RouterLink>
          <RouterLink to="/" class="btn-ghost">{{ $t('payment.btn_home') }}</RouterLink>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { XCircle, AlertTriangle } from 'lucide-vue-next'
import { verifyVNPayCallback } from '../api/payment'

const route  = useRoute()
const router = useRouter()
const { t, locale } = useI18n()

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const state     = ref('loading') // 'loading' | 'success' | 'failed' | 'error'
const message   = ref('')
const bookingId = ref('')
const isInvoice = ref(false)

onMounted(async () => {
  // toàn bộ query string VNPay trả về (vnp_Amount, vnp_ResponseCode, vnp_SecureHash, ...)
  const vnpParams = { ...route.query }

  if (!Object.keys(vnpParams).length) {
    state.value = 'error'
    message.value = t('payment.not_found')
    return
  }

  try {
    const { data } = await verifyVNPayCallback(vnpParams)
    let rawBookingId = data?.bookingId || ''
    message.value   = data?.message || ''

    if (rawBookingId.startsWith('invoice_')) {
      isInvoice.value = true
      bookingId.value = rawBookingId.replace('invoice_', '')
    } else {
      bookingId.value = rawBookingId
    }

    if (data?.status === 'SUCCESS') {
      state.value = 'success'
    } else {
      state.value = 'failed'
    }
  } catch (e) {
    state.value = 'error'
    message.value = e.response?.data?.message || t('payment.server_error')
  }
})

const retryPayment = () => {
  if (bookingId.value) {
    router.push(`/bookings/${bookingId.value}`)
  } else {
    router.push('/bookings')
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}

.ret-page{font-family:'Inter',sans-serif;min-height:100vh;background:#f2f4f9;display:flex;align-items:center;justify-content:center;padding:1.5rem}
.ret-card{background:#fff;border-radius:24px;padding:3rem 2.25rem;max-width:440px;width:100%;text-align:center;box-shadow:0 20px 60px rgba(0,0,0,.1)}
.ret-state h2{font-size:1.25rem;font-weight:800;margin:1.4rem 0 .5rem;color:#1e2130}
.ret-state p{font-size:.875rem;color:#6b7280;line-height:1.6}

.ret-spin{width:52px;height:52px;border:4px solid #e5e7eb;border-top-color:#5392f9;border-radius:50%;margin:0 auto;animation:spin .8s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}

.ret-icon{width:88px;height:88px;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto;box-shadow:0 16px 40px rgba(0,0,0,.18)}
.ret-icon-ok{background:linear-gradient(135deg,#10b981,#059669)}
.ret-icon-fail{background:linear-gradient(135deg,#ef4444,#dc2626)}
.chk-svg{width:46px;height:46px}
.chk-bg{stroke:rgba(255,255,255,.3);stroke-width:2}
.chk-path{stroke:#fff;stroke-width:4;stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:50;stroke-dashoffset:50;animation:draw .5s ease .2s forwards}
@keyframes draw{to{stroke-dashoffset:0}}

.ref-box{display:flex;justify-content:space-between;align-items:center;background:#f0fdf4;border-radius:12px;padding:.8rem 1.1rem;margin:1.25rem 0 0;font-size:.82rem;font-weight:700;color:#1e2130}
.ref-box strong{color:#10b981;font-size:.95rem}

.ret-btns{display:flex;flex-direction:column;gap:.7rem;margin-top:1.75rem}
.btn-primary{display:inline-flex;align-items:center;justify-content:center;padding:.85rem 1.5rem;border-radius:13px;background:linear-gradient(135deg,#5392f9,#7c3aed);color:#fff;border:none;font-size:.9rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;text-decoration:none;transition:transform .2s}
.btn-primary:hover{transform:translateY(-2px)}
.btn-ghost{display:inline-flex;align-items:center;justify-content:center;padding:.85rem 1.5rem;border-radius:13px;background:#fff;color:#6b7280;border:1.5px solid #e5e7eb;font-size:.875rem;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;text-decoration:none;transition:all .2s}
.btn-ghost:hover{border-color:#5392f9;color:#5392f9}
</style>