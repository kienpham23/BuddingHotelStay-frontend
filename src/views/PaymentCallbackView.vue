<template>
  <div class="cb-page">
    <header class="cb-header" style="display: flex; justify-content: space-between; align-items: center;">
      <RouterLink to="/" class="logo">
        <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
          <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <span class="logo-word building">Building</span>
        <span class="logo-word hotel">Hotel</span>
        <span class="logo-word stay">Stay</span>
      </RouterLink>

      <!-- Language Selector -->
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
    </header>

    <div class="cb-body">
      <!-- Loading -->
      <div v-if="status === 'loading'" class="cb-card">
        <div class="cb-spinner"></div>
        <h2>{{ $t('payment.verifying') }}</h2>
        <p>{{ $t('payment.verifying_desc') }}</p>
      </div>

      <!-- Success -->
      <div v-else-if="status === 'success'" class="cb-card">
        <div class="cb-icon-wrap success-wrap">
          <svg viewBox="0 0 52 52" class="chk-svg">
            <circle cx="26" cy="26" r="25" fill="none" class="chk-bg"/>
            <path fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8" class="chk-path"/>
          </svg>
        </div>
        <h2>{{ $t('payment.success_title') }}</h2>
        <p>{{ $t('payment.success_desc') }}</p>

        <div class="result-info">
          <div class="ri-row">
            <span>{{ $t('payment.txn_ref') }}</span>
            <strong>{{ vnpTxnRef }}</strong>
          </div>
          <div class="ri-row">
            <span>{{ $t('payment.amount') }}</span>
            <strong class="col-blue">{{ fmtPrice(Number(vnpAmount) / 100) }}</strong>
          </div>
          <div class="ri-row">
            <span>{{ $t('payment.time') }}</span>
            <strong>{{ vnpPayDate }}</strong>
          </div>
          <div class="ri-row" v-if="resultMsg">
            <span>{{ $t('payment.message') }}</span>
            <strong>{{ resultMsg }}</strong>
          </div>
        </div>

        <div class="cb-btns">
          <RouterLink to="/bookings" class="btn-primary">{{ $t('payment.btn_view_booking') }}</RouterLink>
          <RouterLink to="/" class="btn-ghost">{{ $t('payment.btn_home') }}</RouterLink>
        </div>
      </div>

      <!-- Failed -->
      <div v-else-if="status === 'failed'" class="cb-card">
        <div class="cb-icon-wrap fail-wrap">
          <svg viewBox="0 0 52 52" class="fail-svg">
            <circle cx="26" cy="26" r="25" fill="none" class="fail-circle"/>
            <path fill="none" d="M18 18l16 16M34 18l-16 16" class="fail-path"/>
          </svg>
        </div>
        <h2>{{ $t('payment.failed_title') }}</h2>
        <p>{{ resultMsg || $t('payment.failed_desc') }}</p>

        <div class="result-info" v-if="vnpTxnRef">
          <div class="ri-row">
            <span>{{ $t('payment.ref_code') }}</span>
            <strong>{{ vnpTxnRef }}</strong>
          </div>
        </div>

        <div class="cb-btns">
          <RouterLink to="/bookings" class="btn-primary">{{ $t('payment.btn_view_booking') }}</RouterLink>
          <RouterLink to="/" class="btn-ghost">{{ $t('payment.btn_home') }}</RouterLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { verifyVNPayCallback } from '../api/payment'

const route = useRoute()
const { t, locale } = useI18n()

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const status     = ref('loading')
const resultMsg  = ref('')
const vnpTxnRef  = ref('')
const vnpAmount  = ref('')
const rawPayDate = ref('')

const vnpPayDate = computed(() => {
  const raw = rawPayDate.value
  if (raw.length !== 14) return ''
  const year = parseInt(raw.slice(0, 4))
  const month = parseInt(raw.slice(4, 6)) - 1
  const day = parseInt(raw.slice(6, 8))
  const hour = parseInt(raw.slice(8, 10))
  const minute = parseInt(raw.slice(10, 12))
  const second = parseInt(raw.slice(12, 14))
  const dateObj = new Date(year, month, day, hour, minute, second)
  const currentLang = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Intl.DateTimeFormat(currentLang, {
    year: 'numeric',
    month: 'numeric',
    day: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric',
    hour12: locale.value === 'en'
  }).format(dateObj)
})

const fmtPrice = (n) => {
  const currentLang = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Intl.NumberFormat(currentLang, { style: 'currency', currency: 'VND' }).format(n)
}

onMounted(async () => {
  // Lấy toàn bộ query params VNPay gửi về
  const params = Object.fromEntries(
    Object.entries(route.query).map(([k, v]) => [k, String(v)])
  )

  vnpTxnRef.value  = params.vnp_TxnRef  || ''
  vnpAmount.value  = params.vnp_Amount   || '0'
  rawPayDate.value = params.vnp_PayDate || ''

  try {
    const { data } = await verifyVNPayCallback(params)
    resultMsg.value = data?.message || ''
    if (data?.status === 'SUCCESS') {
      status.value = 'success'
    } else {
      status.value = 'failed'
    }
  } catch (e) {
    resultMsg.value = e.response?.data?.message || 'Không thể xác minh giao dịch'
    status.value = 'failed'
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
.cb-page{font-family:'Inter',sans-serif;background:#f2f4f9;min-height:100vh;color:#1e2130}

.cb-header{background:#fff;border-bottom:1px solid #e5e7eb;padding:.9rem 1.5rem;box-shadow:0 2px 10px rgba(0,0,0,.05)}
.logo{font-size:1.4rem;font-weight:800;color:#5392f9;text-decoration:none;letter-spacing:-.05em}
.logo-red{color:#ff567d}

.cb-body{display:flex;align-items:center;justify-content:center;min-height:calc(100vh - 60px);padding:2rem 1rem}

.cb-card{background:#fff;border-radius:24px;padding:3rem 2.5rem;max-width:480px;width:100%;text-align:center;box-shadow:0 20px 60px rgba(0,0,0,.1);border:1px solid #e5e7eb;animation:fadeUp .5s ease}
@keyframes fadeUp{from{transform:translateY(20px);opacity:0}to{transform:translateY(0);opacity:1}}

/* Loading */
.cb-spinner{width:64px;height:64px;border:4px solid #e5e7eb;border-top-color:#5392f9;border-radius:50%;animation:spin .8s linear infinite;margin:0 auto 1.5rem}
@keyframes spin{to{transform:rotate(360deg)}}

/* Icon wraps */
.cb-icon-wrap{width:96px;height:96px;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 1.5rem;animation:popIn .5s cubic-bezier(.34,1.56,.64,1)}
@keyframes popIn{from{transform:scale(0)}to{transform:scale(1)}}
.success-wrap{background:linear-gradient(135deg,#10b981,#059669);box-shadow:0 20px 50px rgba(16,185,129,.4)}
.fail-wrap{background:linear-gradient(135deg,#ef4444,#dc2626);box-shadow:0 20px 50px rgba(239,68,68,.4)}

.chk-svg,.fail-svg{width:50px;height:50px}
.chk-bg{stroke:rgba(255,255,255,.3);stroke-width:2}
.chk-path{stroke:#fff;stroke-width:4;stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:50;stroke-dashoffset:50;animation:draw .5s ease .4s forwards}
@keyframes draw{to{stroke-dashoffset:0}}
.fail-circle{stroke:rgba(255,255,255,.3);stroke-width:2}
.fail-path{stroke:#fff;stroke-width:4;stroke-linecap:round;stroke-dasharray:30;stroke-dashoffset:30;animation:draw2 .4s ease .4s forwards}
@keyframes draw2{to{stroke-dashoffset:0}}

.cb-card h2{font-size:1.4rem;font-weight:800;margin-bottom:.5rem}
.cb-card > p{font-size:.875rem;color:#6b7280;line-height:1.6;margin-bottom:1.5rem}

/* Result info */
.result-info{background:#f8fafc;border-radius:14px;padding:1rem 1.25rem;margin-bottom:1.75rem;text-align:left;border:1px solid #e5e7eb}
.ri-row{display:flex;justify-content:space-between;align-items:center;padding:.45rem 0;border-bottom:1px solid #f3f4f6;font-size:.85rem}
.ri-row:last-child{border-bottom:none}
.ri-row span{color:#6b7280}
.ri-row strong{color:#1e2130}
.col-blue{color:#5392f9}

/* Buttons */
.cb-btns{display:flex;flex-direction:column;gap:.7rem}
.btn-primary{display:flex;align-items:center;justify-content:center;gap:.5rem;padding:.9rem;border-radius:13px;background:linear-gradient(135deg,#5392f9,#7c3aed);color:#fff;border:none;font-size:.9rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;text-decoration:none;transition:all .2s}
.btn-primary:hover{opacity:.9;transform:translateY(-1px)}
.btn-ghost{display:flex;align-items:center;justify-content:center;padding:.9rem;border-radius:13px;background:#fff;color:#6b7280;border:1.5px solid #e5e7eb;font-size:.9rem;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;text-decoration:none;transition:all .2s}
.btn-ghost:hover{border-color:#5392f9;color:#5392f9}
</style>

