<template>
  <div class="deals-page">
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

          <RouterLink to="/" class="btn-back">{{ $t('nav.back_home') }}</RouterLink>
          <template v-if="authStore.isLoggedIn">
            <span class="user-name">{{ authStore.user?.fullName }}</span>
            <RouterLink v-if="authStore.role === 'CUSTOMER'" to="/bookings" class="nav-link-btn">{{ $t('nav.my_bookings') }}</RouterLink>
            <button class="btn-logout-sm" @click="handleLogout">{{ $t('nav.logout') }}</button>
          </template>
          <template v-else>
            <RouterLink to="/login" class="btn-login-sm">{{ $t('nav.login') }}</RouterLink>
          </template>
        </div>
      </div>
    </header>

    <!-- HERO BANNER -->
    <section class="deals-hero">
      <div class="container deals-hero-content">
        <!-- Agoda decorative shapes/characters drawn in CSS -->
        <div class="hero-character left-char">
          <div class="char-body blue-char">
            <div class="char-eyes"><div class="eye"></div><div class="eye"></div></div>
            <div class="char-mouth open"></div>
          </div>
        </div>
        
        <div class="hero-text-wrap">
          <h1>{{ $t('deals.title') }}</h1>
          <p>{{ $t('deals.subtitle') }}</p>
        </div>

        <div class="hero-character right-char">
          <div class="char-body yellow-char">
            <div class="char-eyes"><div class="eye"></div><div class="eye"></div></div>
            <div class="char-mouth smile"></div>
            <div class="char-luggage"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- MAIN BODY -->
    <main class="container deals-body">
      <!-- LEFT SIDEBAR FILTERS -->
      <aside class="deals-sidebar">
        <!-- Filter Section 1 -->
        <div class="filter-box">
          <h4>{{ $t('deals.sidebar_product') }}</h4>
          <label class="filter-item">
            <input type="checkbox" v-model="filterProduct" value="hotel" />
            <span class="checkmark"></span>
            {{ $t('deals.hotels_and_homes', { count: availablePromos.length }) }}
          </label>
          <label class="filter-item text-muted">
            <input type="checkbox" disabled />
            <span class="checkmark"></span>
            {{ $t('deals.flights_cat') }}
          </label>
          <label class="filter-item text-muted">
            <input type="checkbox" disabled />
            <span class="checkmark"></span>
            {{ $t('deals.flights_hotels') }}
          </label>
        </div>

        <!-- Filter Section 2 -->
        <div class="filter-box">
          <h4>{{ $t('deals.sidebar_promos') }}</h4>
          <label class="filter-item">
            <input type="checkbox" v-model="filterType" value="coupon" />
            <span class="checkmark"></span>
            {{ $t('deals.coupons', { count: availablePromos.length }) }}
          </label>
          <label class="filter-item text-muted">
            <input type="checkbox" disabled />
            <span class="checkmark"></span>
            {{ $t('deals.credit_cards') }}
          </label>
          <label class="filter-item text-muted">
            <input type="checkbox" disabled />
            <span class="checkmark"></span>
            {{ $t('deals.special_campaigns') }}
          </label>
          <label class="filter-item">
            <input type="checkbox" v-model="filterType" value="limited" />
            <span class="checkmark"></span>
            {{ $t('deals.limited_offers', { count: availablePromos.length }) }}
          </label>
        </div>
      </aside>

      <!-- RIGHT DEALS GRID -->
      <section class="deals-content">
        <div class="deals-grid" v-if="filteredPromos.length > 0">
          <div 
            v-for="(promo, index) in filteredPromos" 
            :key="promo.id || promo.code" 
            class="deal-card"
          >
            <!-- TOP GRAPHIC BOX (Blue, Green, Red, Purple gradient box with ticket shape) -->
            <div class="dc-graphic-box" :class="getGraphicClass(index)">
              <div class="dc-graphic-ticket">
                <span class="dgt-percent">
                  {{ promo.discountType === 'PERCENT' ? `Giảm tới ${promo.discountValue}%` : `Giảm tới ${formatPriceShort(promo.discountValue)}` }}
                </span>
                <span class="dgt-tag">HOTELSTAY</span>
                
                <div class="dgt-circle-l"></div>
                <div class="dgt-circle-r"></div>
                <div class="dgt-dash-line"></div>
              </div>
            </div>

            <!-- BOTTOM CONTENT -->
            <div class="dc-info">
              <div>
                <h3 class="dc-title">
                  {{ promo.discountType === 'PERCENT' 
                    ? $t('deals.coupon_title_percent', { discount: promo.discountValue }) 
                    : $t('deals.coupon_title_fixed', { discount: formatPrice(promo.discountValue) }) }}
                </h3>
                <p class="dc-desc">{{ promo.description }}</p>
                <div class="dc-meta">
                  <span class="dc-condition">{{ $t('deals.min_spend', { amount: formatPrice(promo.minOrderAmount || 0) }) }}</span>
                  <span class="dc-divider">|</span>
                  <span class="dc-expiry">{{ getExpiryText(promo.endDate) }}</span>
                </div>
              </div>

              <div class="dc-action">
                <button 
                  v-if="isClaimed(promo.code)"
                  class="btn-claim-deal claimed"
                  disabled
                >
                  {{ $t('deals.btn_claimed') }}
                </button>
                <button 
                  v-else
                  class="btn-claim-deal"
                  @click="claimVoucher(promo.code)"
                >
                  {{ $t('deals.btn_claim') }}
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- EMPTY STATE -->
        <div class="deals-empty-state" v-else>
          <div class="empty-icon">🏷️</div>
          <h3>{{ $t('deals.empty_title') }}</h3>
          <p>{{ $t('deals.empty_desc') }}</p>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useToastStore } from '../stores/toast'
import { useI18n } from 'vue-i18n'
import axios from '../api/axios'

const router = useRouter()
const authStore = useAuthStore()
const toastStore = useToastStore()
const { t, locale } = useI18n()

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const availablePromos = ref([])
const myVouchers = ref([])
const promosLoading = ref(false)

// Functional Filters
const filterProduct = ref(['hotel'])
const filterType = ref(['coupon', 'limited'])

const getGraphicClass = (index) => {
  const classes = ['bg-blue', 'bg-green', 'bg-red', 'bg-purple']
  return classes[index % classes.length]
}

const formatPriceShort = (val) => {
  if (!val) return '0đ'
  if (val >= 1000000) {
    return (val / 1000000).toFixed(0) + 'Tr'
  }
  if (val >= 1000) {
    return (val / 1000).toFixed(0) + 'K'
  }
  return val + 'đ'
}

const formatPrice = (p) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p)
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

const getExpiryText = (endDateStr) => {
  const days = getDaysRemaining(endDateStr)
  if (days < 0) return t('deals.expired')
  if (days === 0) return t('deals.expiry_today')
  if (days === 1) return t('deals.expiry_1day')
  return t('deals.expiry_days', { count: days })
}

const fetchPromotions = async () => {
  promosLoading.value = true
  try {
    const res = await axios.get('/promotions/available')
    availablePromos.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Lỗi lấy khuyến mãi:', err)
  } finally {
    promosLoading.value = false
  }
}

const fetchMyVouchers = async () => {
  if (!authStore.isLoggedIn) return
  try {
    const res = await axios.get('/promotions/my-wallet')
    myVouchers.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Lỗi ví voucher:', err)
  }
}

const claimVoucher = async (code) => {
  if (!authStore.isLoggedIn) {
    router.push({ path: '/login', query: { redirect: '/deals' } })
    return
  }
  try {
    const res = await axios.post('/promotions/claim', { code })
    myVouchers.value.push(res.data)
    toastStore.success(locale.value === 'vi' ? 'Nhận mã khuyến mãi thành công!' : 'Voucher claimed successfully!')
  } catch (err) {
    toastStore.warning(err.response?.data?.message || t('deals.claim_fail'))
  }
}

const isClaimed = (code) => {
  if (!code) return false
  return myVouchers.value.some(v => v.code && v.code.toUpperCase() === code.toUpperCase())
}

const filteredPromos = computed(() => {
  let list = [...availablePromos.value]
  
  if (!filterProduct.value.includes('hotel')) {
    return []
  }
  if (!filterType.value.includes('coupon') && !filterType.value.includes('limited')) {
    return []
  }
  
  return list
})

const handleLogout = () => {
  authStore.logout()
  myVouchers.value = []
  router.push('/')
}

watch(() => authStore.isLoggedIn, (newVal) => {
  if (newVal) {
    fetchMyVouchers()
  } else {
    myVouchers.value = []
  }
})

onMounted(() => {
  fetchPromotions()
  if (authStore.isLoggedIn) {
    fetchMyVouchers()
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }
.deals-page {
  min-height: 100vh;
  background: #f8f9fc;
  font-family: 'Inter', sans-serif;
  color: #1e293b;
  display: flex;
  flex-direction: column;
}
.container { max-width: 1160px; margin: 0 auto; padding: 0 1.5rem; }

/* HEADER */
.header {
  background: white;
  border-bottom: 1px solid #e2e8f0;
  padding: 0.9rem 0;
  position: sticky;
  top: 0;
  z-index: 100;
}
.header .container { display: flex; justify-content: space-between; align-items: center; }
.logo { font-size: 1.4rem; font-weight: 800; letter-spacing: -0.05em; color: #1a6cf7; text-decoration: none; }
.logo-red { color: #ff567d; }
.header-right { display: flex; align-items: center; gap: 1.25rem; }
.btn-back { font-size: 0.875rem; font-weight: 600; color: #64748b; text-decoration: none; transition: color 0.2s; }
.btn-back:hover { color: #1a6cf7; }
.user-name { font-size: 0.875rem; font-weight: 600; color: #1e293b; }
.nav-link-btn { font-size: 0.85rem; font-weight: 700; color: #1a6cf7; text-decoration: none; }
.nav-link-btn:hover { text-decoration: underline; }
.btn-login-sm {
  background: #1a6cf7; color: white; border: none; border-radius: 20px; padding: 0.45rem 1.2rem;
  font-size: 0.85rem; font-weight: 700; cursor: pointer; text-decoration: none; transition: background 0.2s;
}
.btn-login-sm:hover { background: #0052cc; }
.btn-logout-sm {
  background: transparent; color: #64748b; border: 1.5px solid #cbd5e1; border-radius: 20px; padding: 0.4rem 1rem;
  font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s;
}
.btn-logout-sm:hover { border-color: #ef4444; color: #ef4444; background: #fef2f2; }

/* HERO BANNER */
.deals-hero {
  background: linear-gradient(135deg, #4b1a99, #7c2de6);
  color: white;
  padding: 2.5rem 0;
  position: relative;
  overflow: hidden;
}
.deals-hero-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.hero-text-wrap {
  text-align: center;
  flex: 1;
}
.deals-hero h1 {
  font-size: 2.2rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}
.deals-hero p {
  font-size: 0.95rem;
  opacity: 0.9;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.5;
}

/* Agoda Cartoon Characters */
.hero-character {
  width: 90px;
  height: 90px;
  position: relative;
}
.char-body {
  width: 76px;
  height: 76px;
  border-radius: 50%;
  position: relative;
  box-shadow: 0 6px 16px rgba(0,0,0,0.15);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
.blue-char {
  background: #3b82f6;
  animation: floatChar1 3s ease-in-out infinite;
}
.yellow-char {
  background: #f59e0b;
  animation: floatChar2 3.2s ease-in-out infinite;
}
.char-eyes {
  display: flex;
  gap: 8px;
}
.eye {
  width: 10px;
  height: 10px;
  background: #ffffff;
  border-radius: 50%;
  position: relative;
}
.eye::after {
  content: '';
  position: absolute;
  width: 5px;
  height: 5px;
  background: #000000;
  border-radius: 50%;
  top: 2px;
  left: 2px;
}
.char-mouth {
  width: 14px;
  height: 8px;
  border-radius: 0 0 14px 14px;
  background: #000000;
  margin-top: 6px;
}
.char-mouth.open {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}
.char-mouth.smile {
  width: 16px;
  height: 8px;
  border-radius: 0 0 16px 16px;
  background: #ffffff;
}

@keyframes floatChar1 {
  0% { transform: translateY(0) rotate(0); }
  50% { transform: translateY(-8px) rotate(5deg); }
  100% { transform: translateY(0) rotate(0); }
}
@keyframes floatChar2 {
  0% { transform: translateY(0) rotate(0); }
  50% { transform: translateY(-10px) rotate(-6deg); }
  100% { transform: translateY(0) rotate(0); }
}

/* DEALS BODY LAYOUT */
.deals-body {
  display: grid;
  grid-template-columns: 260px 1fr;
  gap: 2rem;
  padding-top: 2.5rem;
  padding-bottom: 5rem;
}

/* SIDEBAR FILTERS */
.deals-sidebar {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.filter-box {
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  padding: 1.25rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.02);
}
.filter-box h4 {
  font-size: 0.9rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
  border-bottom: 1.5px solid #f1f5f9;
  padding-bottom: 0.5rem;
}
.filter-item {
  display: flex;
  align-items: center;
  position: relative;
  padding-left: 28px;
  margin-bottom: 0.85rem;
  cursor: pointer;
  font-size: 0.85rem;
  font-weight: 500;
  color: #334155;
  user-select: none;
}
.filter-item input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}
.checkmark {
  position: absolute;
  top: 1px;
  left: 0;
  height: 18px;
  width: 18px;
  background-color: #f1f5f9;
  border: 1.5px solid #cbd5e1;
  border-radius: 4px;
  transition: all 0.2s;
}
.filter-item:hover input ~ .checkmark {
  border-color: #1a6cf7;
  background: #f8fafc;
}
.filter-item input:checked ~ .checkmark {
  background-color: #1a6cf7;
  border-color: #1a6cf7;
}
.checkmark:after {
  content: "";
  position: absolute;
  display: none;
}
.filter-item input:checked ~ .checkmark:after {
  display: block;
}
.filter-item .checkmark:after {
  left: 5px;
  top: 1px;
  width: 5px;
  height: 9px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}
.text-muted {
  color: #94a3b8 !important;
  cursor: not-allowed;
}

/* RIGHT CONTENT: GRID */
.deals-content {
  min-width: 0;
}
.deals-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.deal-card {
  background: #ffffff;
  border-radius: 14px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: transform 0.25s, box-shadow 0.25s;
}
.deal-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
}

/* Graphic Box Coupon shape */
.dc-graphic-box {
  height: 130px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}
.bg-blue { background: linear-gradient(135deg, #e6f0fa 0%, #cbdffa 100%); }
.bg-green { background: linear-gradient(135deg, #e6faf0 0%, #cbfae1 100%); }
.bg-red { background: linear-gradient(135deg, #fae6e6 0%, #facbcb 100%); }
.bg-purple { background: linear-gradient(135deg, #f5e6fa 0%, #e1cbfa 100%); }

.dc-graphic-ticket {
  width: 180px;
  height: 80px;
  border-radius: 8px;
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: #ffffff;
  box-shadow: 0 8px 20px rgba(0,0,0,0.12);
}
.bg-blue .dc-graphic-ticket { background: #3b82f6; }
.bg-green .dc-graphic-ticket { background: #10b981; }
.bg-red .dc-graphic-ticket { background: #ef4444; }
.bg-purple .dc-graphic-ticket { background: #8b5cf6; }

.dgt-percent {
  font-size: 1.15rem;
  font-weight: 800;
  text-align: center;
  max-width: 90%;
  line-height: 1.2;
}
.dgt-tag {
  font-size: 0.6rem;
  font-weight: 700;
  opacity: 0.85;
  letter-spacing: 1px;
  margin-top: 3px;
  background: rgba(0, 0, 0, 0.15);
  padding: 1px 6px;
  border-radius: 4px;
}
.dgt-circle-l, .dgt-circle-r {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
}
.bg-blue .dgt-circle-l, .bg-blue .dgt-circle-r { background: #cbdffa; }
.bg-green .dgt-circle-l, .bg-green .dgt-circle-r { background: #cbfae1; }
.bg-red .dgt-circle-l, .bg-red .dgt-circle-r { background: #facbcb; }
.bg-purple .dgt-circle-l, .bg-purple .dgt-circle-r { background: #e1cbfa; }

.dgt-circle-l { left: -6px; }
.dgt-circle-r { right: -6px; }

.dgt-dash-line {
  position: absolute;
  left: 20px;
  right: 20px;
  top: 50%;
  border-top: 1.5px dashed rgba(255,255,255,0.4);
  pointer-events: none;
}

/* Card Info */
.dc-info {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  flex: 1;
}
.dc-title {
  font-size: 0.88rem;
  font-weight: 700;
  color: #0f172a;
  line-height: 1.35;
  margin-bottom: 0.4rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.dc-desc {
  font-size: 0.76rem;
  color: #64748b;
  line-height: 1.4;
  margin-bottom: 0.6rem;
}
.dc-meta {
  display: flex;
  flex-direction: column;
  gap: 2px;
  font-size: 0.72rem;
  color: #94a3b8;
  font-weight: 600;
  margin-bottom: 1.2rem;
}
.dc-divider { display: none; }

.dc-action {
  margin-top: auto;
}
.btn-claim-deal {
  width: 100%;
  background: #1a6cf7;
  color: #ffffff;
  border: none;
  border-radius: 8px;
  padding: 0.65rem 0.5rem;
  font-size: 0.78rem;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.2s;
  box-shadow: 0 4px 10px rgba(26, 108, 247, 0.15);
}
.btn-claim-deal:hover:not(:disabled) {
  background: #0052cc;
}
.btn-claim-deal.claimed {
  background: #e2e8f0;
  color: #94a3b8;
  cursor: not-allowed;
  box-shadow: none;
}

/* EMPTY STATE */
.deals-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 5rem 2rem;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  text-align: center;
}
.empty-icon { font-size: 3rem; margin-bottom: 1rem; }
.deals-empty-state h3 { font-size: 1.1rem; font-weight: 700; color: #0f172a; margin-bottom: 0.5rem; }
.deals-empty-state p { font-size: 0.85rem; color: #64748b; }

/* RESPONSIVE */
@media (max-width: 900px) {
  .deals-body {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  .deals-sidebar {
    flex-direction: row;
    flex-wrap: wrap;
  }
  .filter-box {
    flex: 1;
    min-width: 200px;
  }
}
@media (max-width: 580px) {
  .deals-hero h1 { font-size: 1.6rem; }
  .deals-hero p { font-size: 0.85rem; }
  .hero-character { display: none; }
  .deals-sidebar {
    flex-direction: column;
  }
  .deals-grid {
    grid-template-columns: 1fr;
  }
}
</style>
