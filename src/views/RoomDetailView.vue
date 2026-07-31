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
            <ChevronLeft :size="16" /> {{ $t('nav.back_search') }}
          </RouterLink>
          <template v-if="authStore.isLoggedIn">
            <span class="user-name">{{ authStore.user?.fullName }}</span>
            <RouterLink v-if="authStore.role === 'CUSTOMER'" to="/bookings" class="btn-outline">{{ $t('nav.my_bookings') }}</RouterLink>
          </template>
          <template v-else>
            <button class="btn-outline" @click="showAuth = true">{{ $t('nav.login') }}</button>
          </template>
        </div>
      </div>
    </header>

    <main class="container main-content" v-if="room">
      <!-- TITLE SECTION -->
      <div class="title-section">
        <span class="room-type-badge">{{ room.roomTypeName }}</span>
        <h1>{{ room.name }}</h1>
        <p class="address-text">
          <MapPin :size="16" class="color-blue" /> {{ room.address }}, {{ room.city }}
        </p>
      </div>

      <!-- PHOTO GALLERY -->
      <div class="gallery-grid">
        <div class="main-photo" @click="openLightbox(0)">
          <img :src="room.imageUrls[0] || 'https://images.unsplash.com/photo-1611891487122-2075b96244e1?q=80&w=800&auto=format&fit=crop'" alt="Room image" />
        </div>
        <div class="sub-photos">
          <div v-for="(img, idx) in room.imageUrls.slice(1, 3)" :key="idx" class="sub-photo-item" @click="openLightbox(idx + 1)">
            <img :src="img" alt="Room detail image" />
          </div>
          <div class="more-photos-btn" v-if="room.imageUrls.length > 3" @click="openLightbox(3)">
            <span>+{{ room.imageUrls.length - 3 }} {{ locale === 'vi' ? 'ảnh khác' : 'more photos' }}</span>
          </div>
        </div>
      </div>

      <!-- MAIN GRID (INFO & BOOKING) -->
      <div class="content-grid">
        <!-- LEFT: ROOM INFO -->
        <div class="info-column">
          <!-- QUICK HIGHLIGHTS -->
          <div class="card info-card">
            <h2 class="card-title"><Sparkles :size="20" class="color-blue" /> {{ $t('detail.highlights') }}</h2>
            <div class="highlights-grid">
              <div class="hl-item">
                <span class="hl-icon"><Users :size="18" /></span>
                <div>
                  <h4>{{ $t('detail.capacity') }}</h4>
                  <p>{{ $t('detail.adults', { count: room.maxGuests }) }}</p>
                </div>
              </div>
              <div class="hl-item">
                <span class="hl-icon"><Building2 :size="18" /></span>
                <div>
                  <h4>{{ $t('detail.room_type') }}</h4>
                  <p>{{ room.roomTypeName }}</p>
                </div>
              </div>
              <div class="hl-item">
                <span class="hl-icon"><Star :size="18" /></span>
                <div>
                  <h4>{{ $t('detail.avg_rating') }}</h4>
                  <p>{{ $t('detail.rating_summary', { rating: room.avgRating?.toFixed(1), count: room.ratingCount }) }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- DESCRIPTION -->
          <div class="card">
            <h2 class="card-title">{{ $t('detail.description') }}</h2>
            <p class="description-body">{{ room.description }}</p>
          </div>

          <!-- AMENITIES -->
          <div class="card" v-if="room.amenities && room.amenities.length">
            <h2 class="card-title">{{ $t('detail.amenities') }}</h2>
            <div class="amenities-list">
              <div v-for="(amenity, idx) in parsedAmenities" :key="idx" class="amenity-item">
                <component :is="getAmenityIcon(amenity)" :size="18" class="amenity-ico" />
                <span>{{ amenity }}</span>
              </div>
            </div>
          </div>

          <!-- REVIEWS -->
          <div class="card">
            <h2 class="card-title">{{ $t('detail.reviews_title', { count: room.reviews?.length || 0 }) }}</h2>
            <div class="rating-summary" v-if="room.avgRating">
              <div class="rating-big-box">
                <span class="rating-num">{{ room.avgRating?.toFixed(1) }}</span>
                <span class="rating-max">/5.0</span>
                <div class="stars-row">
                  <Star v-for="i in 5" :key="i" :size="14" fill="#ffb703" :color="i <= Math.round(room.avgRating) ? '#ffb703' : '#e2e8f0'" />
                </div>
                <p class="rating-tag">{{ locale === 'vi' ? 'Rất xuất sắc' : 'Excellent' }}</p>
              </div>
              <div class="rating-bars">
                <div class="bar-row">
                  <span>{{ locale === 'vi' ? 'Sạch sẽ' : 'Cleanliness' }}</span>
                  <div class="progress-bar"><div class="fill" style="width: 96%"></div></div>
                  <span>4.8</span>
                </div>
                <div class="bar-row">
                  <span>{{ locale === 'vi' ? 'Vị trí' : 'Location' }}</span>
                  <div class="progress-bar"><div class="fill" style="width: 92%"></div></div>
                  <span>4.6</span>
                </div>
                <div class="bar-row">
                  <span>{{ locale === 'vi' ? 'Phục vụ' : 'Service' }}</span>
                  <div class="progress-bar"><div class="fill" style="width: 98%"></div></div>
                  <span>4.9</span>
                </div>
              </div>
            </div>
            
            <div class="reviews-list" v-if="room.reviews && room.reviews.length">
              <div v-for="(rev, idx) in room.reviews" :key="idx" class="review-item">
                <div class="review-header">
                  <div class="author-avatar">{{ (rev.customerName || 'K').charAt(0).toUpperCase() }}</div>
                  <div>
                    <h4>{{ rev.customerName }}</h4>
                    <small><Clock :size="12" /> {{ formatDate(rev.createdAt) }}</small>
                  </div>
                  <div class="review-badge-star">
                    <Star :size="12" fill="#ffb703" color="#ffb703" /> {{ rev.rating }}.0
                  </div>
                </div>
                <p class="review-content">"{{ rev.comment }}"</p>
              </div>
            </div>
            <div class="no-reviews" v-else>
              {{ $t('detail.no_reviews') }}
            </div>
          </div>
        </div>

        <!-- RIGHT: BOOKING SIDEBAR -->
        <div class="booking-column">
          <div class="booking-sidebar">
            <div class="price-header">
              <span class="price-title">{{ $t('detail.price_night') }}</span>
              <span class="price-big">{{ formatPrice(room.pricePerNight) }}<small>/{{ $t('search.rooms') }}</small></span>
            </div>

            <form @submit.prevent="submitBooking" class="booking-form">
              <!-- DATE INPUTS -->
              <div class="form-row">
                <div class="form-group">
                  <label>{{ $t('search.check_in') }}</label>
                  <input v-model="bookingForm.checkIn" type="date" :min="today" required @change="calculateNights" />
                </div>
                <div class="form-group">
                  <label>{{ $t('search.check_out') }}</label>
                  <input v-model="bookingForm.checkOut" type="date" :min="minCheckOut" required @change="calculateNights" />
                </div>
              </div>

              <!-- Lịch bận (Đã được đặt) -->
              <div v-if="bookedDates.length > 0" class="booked-dates-container" style="margin-bottom: 1.25rem; text-align: left;">
                <label style="font-size: 0.72rem; font-weight: 700; color: #ef4444; text-transform: uppercase; letter-spacing: .05em; display: block; margin-bottom: 0.35rem;">
                  {{ locale === 'vi' ? 'Lịch bận (Phòng đã có khách đặt)' : 'Unavailable / Booked dates' }}
                </label>
                <div style="background: #fff5f5; border: 1px solid #fecaca; border-radius: 12px; padding: 0.6rem 0.85rem; font-size: 0.8rem; color: #b91c1c; max-height: 120px; overflow-y: auto;">
                  <ul style="padding-left: 1.1rem; margin: 0; line-height: 1.45;">
                    <li v-for="(range, idx) in bookedDates" :key="idx">
                      {{ formatDate(range.checkIn) }} &rarr; {{ formatDate(range.checkOut) }}
                    </li>
                  </ul>
                </div>
              </div>

              <!-- Show read-only customer info for reassurance -->
              <div class="user-info-summary" v-if="authStore.isLoggedIn" style="background:#f8fafc; padding:0.75rem 1rem; border-radius:10px; border:1px solid #e2e8f0; margin-bottom:1rem; font-size:0.85rem; color:#475569; text-align:left;">
                <p style="margin:0">{{ locale === 'vi' ? 'Khách đặt' : 'Booker' }}: <strong>{{ authStore.user?.fullName }}</strong> ({{ authStore.user?.email }})</p>
              </div>

              <!-- GUEST CAPACITY & NOTE -->
              <div class="form-row">
                <div class="form-group">
                  <label>{{ locale === 'vi' ? 'Số lượng khách' : 'Guests count' }}</label>
                  <input v-model.number="bookingForm.numGuests" type="number" min="1" required />
                </div>
              </div>

              <div class="form-group">
                <label>{{ locale === 'vi' ? 'Ghi chú đặt phòng' : 'Booking note' }}</label>
                <textarea v-model="bookingForm.note" :placeholder="locale === 'vi' ? 'Yêu cầu đặc biệt (ví dụ: nhận phòng sớm, giường phụ...)' : 'Special requests (e.g. early check-in, extra bed...)'" rows="2" style="width:100%; padding:0.65rem 0.8rem; border-radius:10px; border:1.5px solid #dde1e9; font-size:0.875rem; outline:none; background:#fafbfc; resize:vertical; font-family:'Inter',sans-serif;"></textarea>
              </div>

              <!-- BILLING SUMMARY -->
              <div class="billing-summary" v-if="nights > 0">
                <div class="bill-line">
                  <span>{{ formatPrice(room.pricePerNight) }} × {{ $t('detail.nights', { count: nights }) }}</span>
                  <span>{{ formatPrice(room.pricePerNight * nights) }}</span>
                </div>
                <div class="bill-line">
                  <span>{{ locale === 'vi' ? 'Thuế & Phí dịch vụ (5%)' : 'Tax & Service fee (5%)' }}</span>
                  <span>{{ formatPrice(room.pricePerNight * nights * 0.05) }}</span>
                </div>
                <div class="bill-divider"></div>
                <div class="bill-line total">
                  <span>{{ locale === 'vi' ? 'Tổng cộng thanh toán' : 'Total payment' }}</span>
                  <span class="total-price-text">{{ formatPrice(room.pricePerNight * nights * 1.05) }}</span>
                </div>
              </div>

              <!-- ERROR -->
              <div v-if="bookingError" class="booking-error-msg">
                {{ bookingError }}
              </div>

              <!-- BUTTON -->
              <button type="submit" class="btn-book-now" :disabled="bookingLoading || !!bookingError || nights <= 0">
                <Lock :size="16" v-if="!bookingLoading" />
                <span v-if="!bookingLoading">{{ locale === 'vi' ? 'Xác nhận đặt phòng' : 'Confirm booking' }}</span>
                <span v-else class="spinner-small"></span>
              </button>
            </form>

            <p class="lock-hint">
              <Info :size="12" /> {{ locale === 'vi' ? 'Giá đã bao gồm ưu đãi nội bộ Agoda. Hủy miễn phí trước 24h.' : 'Price includes Agoda internal discount. Free cancellation 24h prior.' }}
            </p>
          </div>
        </div>
      </div>
    </main>

    <div class="container loading-wrapper" v-else-if="loading">
      <div class="spinner"></div>
      <p>{{ locale === 'vi' ? 'Đang tải chi tiết phòng nghỉ...' : 'Loading room details...' }}</p>
    </div>

    <!-- LIGHTBOX MODAL -->
    <div class="lightbox" v-if="lightboxOpen" @click="lightboxOpen = false">
      <div class="lightbox-content" @click.stop>
        <img :src="room.imageUrls[activeImageIdx]" alt="Full size image" />
        <button class="lightbox-close" @click="lightboxOpen = false">×</button>
        <button class="lightbox-prev" @click="prevImage" v-if="activeImageIdx > 0">‹</button>
        <button class="lightbox-next" @click="nextImage" v-if="activeImageIdx < room.imageUrls.length - 1">›</button>
      </div>
    </div>

    <!-- SUCCESS MODAL -->
    <div class="success-backdrop" v-if="bookingSuccess">
      <div class="success-card">
        <div class="success-icon-wrap">
          <svg class="checkmark-svg" viewBox="0 0 52 52">
            <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none"/>
            <path class="checkmark-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
          </svg>
        </div>
        <h2>{{ locale === 'vi' ? 'Đặt phòng thành công!' : 'Booking successful!' }}</h2>
        <p>{{ locale === 'vi' ? 'Cảm ơn bạn đã lựa chọn dịch vụ của chúng tôi. Mã đơn đặt phòng của bạn đã được ghi nhận trên hệ thống.' : 'Thank you for choosing our service. Your booking request has been submitted.' }}</p>
        <div class="success-details">
          <p>{{ locale === 'vi' ? 'Khách sạn' : 'Hotel' }}: <strong>{{ room.name }}</strong></p>
          <p>Check-in: <strong>{{ bookingForm.checkIn }}</strong></p>
          <p>Check-out: <strong>{{ bookingForm.checkOut }}</strong></p>
          <p>{{ locale === 'vi' ? 'Tổng tiền' : 'Total price' }}: <strong class="color-blue">{{ formatPrice(room.pricePerNight * nights * 1.05) }}</strong></p>
        </div>
        <button class="btn-go-bookings" @click="goToBookings">{{ $t('nav.my_bookings') }}</button>
      </div>
    </div>

    <!-- AUTH MODAL -->
    <AuthModal v-model="showAuth" @login-success="onLoginSuccess" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useI18n } from 'vue-i18n'
import { getRoomDetail } from '../api/rooms'
import axios from '../api/axios'
import AuthModal from '../components/auth/AuthModal.vue'
import {
  MapPin, Calendar, Users, Star, ChevronLeft,
  Wifi, Tv, Wind, Coffee, Car, Smile, Info, Lock,
  Building2, Sparkles, Clock
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const { t, locale } = useI18n()

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const room = ref(null)
const loading = ref(true)
const bookingLoading = ref(false)
const showAuth = ref(false)
const bookingError = ref('')
const bookingSuccess = ref(false)
const bookedDates = ref([])

const parsedAmenities = computed(() => {
  if (!room.value?.amenities) return []
  return room.value.amenities.split(',').map(a => a.trim()).filter(Boolean)
})
// Gallery Lightbox states
const lightboxOpen = ref(false)
const activeImageIdx = ref(0)

// Booking form states
const today = new Date().toISOString().split('T')[0]
const bookingForm = ref({
  roomId: null,
  checkIn: '',
  checkOut: '',
  numGuests: 1,
  note: '',
})
const nights = ref(0)

const minCheckOut = computed(() => {
  if (!bookingForm.value.checkIn) return today
  const d = new Date(bookingForm.value.checkIn)
  d.setDate(d.getDate() + 1)
  return d.toISOString().split('T')[0]
})

const isOverlappingBookedDates = () => {
  if (!bookingForm.value.checkIn || !bookingForm.value.checkOut) return false
  const s1 = new Date(bookingForm.value.checkIn)
  const e1 = new Date(bookingForm.value.checkOut)
  for (const range of bookedDates.value) {
    const s2 = new Date(range.checkIn)
    const e2 = new Date(range.checkOut)
    if (s1 < e2 && e1 > s2) return true
  }
  return false
}

const calculateNights = () => {
  bookingError.value = ''
  if (!bookingForm.value.checkIn || !bookingForm.value.checkOut) {
    nights.value = 0
    return
  }
  const checkInDate = new Date(bookingForm.value.checkIn)
  const checkOutDate = new Date(bookingForm.value.checkOut)
  if (checkOutDate <= checkInDate) {
    nights.value = 0
    return
  }

  if (isOverlappingBookedDates()) {
    bookingError.value = locale.value === 'vi'
      ? 'Phòng này đã được đặt trong khoảng thời gian bạn chọn. Vui lòng chọn ngày khác.'
      : 'This room is already booked for the selected dates. Please choose another range.'
    nights.value = 0
    return
  }

  const diffTime = Math.abs(checkOutDate - checkInDate)
  nights.value = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
}

const onLoginSuccess = (userData) => {
  authStore.setUser(userData)
}

const getAmenityIcon = (name) => {
  const norm = name.toLowerCase()
  if (norm.includes('wifi')) return Wifi
  if (norm.includes('điều hòa') || norm.includes('ac')) return Wind
  if (norm.includes('tivi') || norm.includes('tv')) return Tv
  if (norm.includes('ăn sáng') || norm.includes('sáng')) return Coffee
  if (norm.includes('xe') || norm.includes('đỗ xe')) return Car
  if (norm.includes('view') || norm.includes('ban công') || norm.includes('biển')) return Smile
  return Info
}

const formatPrice = (p) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p)

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  return d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

// Lightbox Navigation
const openLightbox = (idx) => {
  activeImageIdx.value = idx
  lightboxOpen.value = true
}
const prevImage = () => {
  if (activeImageIdx.value > 0) activeImageIdx.value--
}
const nextImage = () => {
  if (activeImageIdx.value < room.value.imageUrls.length - 1) activeImageIdx.value++
}

// Fetch Room details
const fetchRoomDetails = async () => {
  loading.value = true
  try {
    const res = await getRoomDetail(route.params.id)
    room.value = res.data
    bookingForm.value.roomId = room.value.id

    // Fetch reviews for this room
    try {
      const resReviews = await axios.get(`/reviews/room/${route.params.id}`)
      room.value.reviews = resReviews.data
    } catch (revErr) {
      console.warn('Không thể tải danh sách đánh giá:', revErr)
      room.value.reviews = []
    }

    // Fetch booked dates for this room
    try {
      const resBooked = await axios.get(`/rooms/${route.params.id}/booked-dates`)
      bookedDates.value = resBooked.data || []
    } catch (bookedErr) {
      console.warn('Không thể tải lịch bận:', bookedErr)
      bookedDates.value = []
    }
  } catch (err) {
    console.error(err)
  } finally {
    loading.value = false
  }
}

// Booking Submit handler
 const submitBooking = () => {
     if (!authStore.isLoggedIn) {
         showAuth.value = true
             return
       }

         bookingError.value = ''

    if (nights.value <= 0) {
      bookingError.value = locale.value === 'vi' ? 'Vui lòng chọn ngày check-in / check-out hợp lệ.' : 'Please select valid check-in / check-out dates.'
      return
    }

    if (isOverlappingBookedDates()) {
      bookingError.value = locale.value === 'vi'
        ? 'Phòng này đã được đặt trong khoảng thời gian bạn chọn.'
        : 'This room is already booked for the selected dates.'
      return
    }

         router.push({
              path: '/payment',
          query: {
          roomId:    room.value.id,
               roomName:  room.value.name,
               roomType:  room.value.roomTypeName,
               city:      room.value.city,
               image:     room.value.imageUrls?.[0] || '',
              rating:    room.value.avgRating,
               price:     room.value.pricePerNight,
               checkIn:   bookingForm.value.checkIn,
               checkOut:  bookingForm.value.checkOut,
               guests:    bookingForm.value.numGuests,
               nights:    nights.value,
             }
     })
   }

const goToBookings = () => {
  bookingSuccess.value = false
  router.push('/bookings')
}

onMounted(() => {
  fetchRoomDetails()
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; color: #1e293b; background: #f8f9fc; }

.container { max-width: 1200px; margin: 0 auto; padding: 0 1.5rem; }
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
.btn-back { display: flex; align-items: center; gap: 0.25rem; font-size: 0.875rem; font-weight: 600; color: #64748b; text-decoration: none; transition: color 0.2s; }
.btn-back:hover { color: #1a6cf7; }
.user-name { font-size: 0.875rem; font-weight: 600; color: #1e293b; }
.btn-outline {
  padding: 0.45rem 1.1rem; border-radius: 999px; font-size: 0.85rem; font-weight: 600;
  border: 1.5px solid #1a6cf7; color: #1a6cf7; background: transparent;
  cursor: pointer; text-decoration: none; transition: all 0.2s;
}
.btn-outline:hover { background: #1a6cf7; color: white; }

/* MAIN CONTENT */
.main-content { padding-top: 2.5rem; padding-bottom: 5rem; }

.title-section { margin-bottom: 1.5rem; }
.room-type-badge { display: inline-block; background: #eff6ff; color: #1a6cf7; font-size: 0.75rem; font-weight: 700; padding: 0.25rem 0.75rem; border-radius: 999px; margin-bottom: 0.5rem; }
.title-section h1 { font-size: 2rem; font-weight: 800; color: #0f172a; margin-bottom: 0.5rem; letter-spacing: -0.02em; }
.address-text { display: flex; align-items: center; gap: 0.35rem; font-size: 0.9rem; color: #64748b; font-weight: 500; }
.color-blue { color: #1a6cf7; }

/* GALLERY GRID */
.gallery-grid {
  display: grid; grid-template-columns: 2fr 1fr; gap: 0.75rem;
  height: 400px; border-radius: 16px; overflow: hidden; margin-bottom: 2.5rem;
}
.main-photo { height: 100%; cursor: pointer; position: relative; }
.main-photo img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
.main-photo:hover img { transform: scale(1.02); }
.sub-photos { display: grid; grid-template-rows: 1fr 1fr; gap: 0.75rem; height: 100%; position: relative; }
.sub-photo-item { cursor: pointer; position: relative; overflow: hidden; }
.sub-photo-item img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
.sub-photo-item:hover img { transform: scale(1.02); }
.more-photos-btn {
  position: absolute; bottom: 0.75rem; right: 0.75rem;
  background: rgba(0, 0, 0, 0.7); backdrop-filter: blur(4px);
  color: white; border-radius: 8px; padding: 0.5rem 1rem;
  font-size: 0.85rem; font-weight: 600; cursor: pointer;
  transition: background 0.2s;
}
.more-photos-btn:hover { background: rgba(0, 0, 0, 0.85); }

/* CONTENT GRID */
.content-grid { display: grid; grid-template-columns: 1.7fr 1.1fr; gap: 2rem; align-items: start; }
.card { background: white; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.75rem; margin-bottom: 1.5rem; }
.card-title { font-size: 1.2rem; font-weight: 700; color: #0f172a; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem; }

/* HIGHLIGHTS */
.highlights-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }
.hl-item { display: flex; align-items: center; gap: 0.75rem; }
.hl-icon { width: 42px; height: 42px; border-radius: 12px; background: #f0f7ff; color: #1a6cf7; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.hl-item h4 { font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; }
.hl-item p { font-size: 0.875rem; color: #0f172a; font-weight: 700; margin-top: 0.1rem; }

/* DESC & AMENITIES */
.description-body { font-size: 0.95rem; color: #475569; line-height: 1.7; white-space: pre-line; }
.amenities-list { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
.amenity-item { display: flex; align-items: center; gap: 0.6rem; font-size: 0.9rem; color: #334155; font-weight: 500; }
.amenity-ico { color: #64748b; }

/* RATINGS & REVIEWS */
.rating-summary { display: flex; gap: 2.5rem; background: #f8fafc; border-radius: 12px; padding: 1.5rem; margin-bottom: 2rem; align-items: center; }
.rating-big-box { text-align: center; border-right: 1px solid #e2e8f0; padding-right: 2.5rem; }
.rating-num { font-size: 2.5rem; font-weight: 800; color: #1a6cf7; }
.rating-max { font-size: 1rem; color: #94a3b8; font-weight: 600; }
.stars-row { display: flex; justify-content: center; gap: 0.1rem; margin: 0.25rem 0; }
.rating-tag { font-size: 0.85rem; font-weight: 700; color: #1e293b; text-transform: uppercase; }
.rating-bars { flex: 1; display: flex; flex-direction: column; gap: 0.6rem; }
.bar-row { display: flex; align-items: center; gap: 0.75rem; font-size: 0.85rem; font-weight: 600; color: #475569; }
.bar-row span:first-child { width: 70px; }
.progress-bar { flex: 1; height: 6px; background: #e2e8f0; border-radius: 99px; overflow: hidden; }
.progress-bar .fill { height: 100%; background: #ffb703; border-radius: 99px; }

.review-item { border-bottom: 1px solid #f1f5f9; padding: 1.25rem 0; }
.review-item:last-child { border-bottom: none; }
.review-header { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; }
.author-avatar { width: 36px; height: 36px; border-radius: 50%; background: #e0e7ff; color: #4f46e5; font-weight: 700; font-size: 0.95rem; display: flex; align-items: center; justify-content: center; }
.review-header h4 { font-size: 0.9rem; font-weight: 700; color: #1e293b; }
.review-header small { font-size: 0.75rem; color: #94a3b8; display: flex; align-items: center; gap: 0.2rem; }
.review-badge-star { margin-left: auto; background: #fef3c7; color: #d97706; font-size: 0.75rem; font-weight: 700; padding: 0.2rem 0.5rem; border-radius: 6px; display: flex; align-items: center; gap: 0.2rem; }
.review-content { font-size: 0.9rem; color: #475569; line-height: 1.6; font-style: italic; }
.no-reviews { text-align: center; color: #94a3b8; padding: 2rem; font-size: 0.9rem; }

/* BOOKING SIDEBAR */
.booking-column { position: sticky; top: 80px; }
.booking-sidebar { background: white; border: 1.5px solid #1a6cf7; border-radius: 20px; padding: 1.75rem; box-shadow: 0 10px 30px rgba(26,108,247,0.06); }
.price-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
.price-title { font-size: 0.85rem; font-weight: 600; color: #64748b; }
.price-big { font-size: 1.5rem; font-weight: 800; color: #1a6cf7; }
.price-big small { font-size: 0.85rem; font-weight: 500; color: #64748b; }

.booking-form { display: flex; flex-direction: column; gap: 1rem; }
.form-row { display: flex; gap: 0.75rem; }
.form-group { display: flex; flex-direction: column; gap: 0.35rem; flex: 1; }
.form-group label { font-size: 0.7rem; font-weight: 800; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; }
.form-group input {
  padding: 0.65rem 0.8rem; border-radius: 10px; border: 1.5px solid #dde1e9;
  font-size: 0.875rem; font-weight: 600; color: #1e293b; outline: none; background: #fafbfc;
  transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.form-group input:focus { border-color: #1a6cf7; background: white; box-shadow: 0 0 0 3px rgba(26,108,247,0.1); }

.billing-summary { background: #f8fafc; border-radius: 12px; padding: 1rem; display: flex; flex-direction: column; gap: 0.5rem; margin-top: 0.5rem; border: 1px solid #f1f5f9; }
.bill-line { display: flex; justify-content: space-between; font-size: 0.8rem; color: #475569; font-weight: 500; }
.bill-divider { height: 1px; background: #e2e8f0; margin: 0.25rem 0; }
.bill-line.total { font-weight: 700; color: #0f172a; font-size: 0.9rem; }
.total-price-text { color: #ff567d; font-size: 1.05rem; }

.booking-error-msg { background: #fff0f0; border: 1px solid #ffc9c9; border-radius: 8px; padding: 0.75rem; font-size: 0.8rem; color: #c62828; }
.btn-book-now {
  background: #1a6cf7; color: white; border: none; padding: 0.9rem; border-radius: 12px;
  font-size: 0.95rem; font-weight: 700; cursor: pointer; transition: all 0.2s;
  display: flex; align-items: center; justify-content: center; gap: 0.5rem;
  box-shadow: 0 4px 15px rgba(26,108,247,0.3); font-family: 'Inter', sans-serif;
  margin-top: 0.5rem;
}
.btn-book-now:hover { background: #1558d6; transform: translateY(-1px); }
.btn-book-now:disabled { opacity: 0.6; cursor: not-allowed; }
.lock-hint { display: flex; align-items: center; justify-content: center; gap: 0.3rem; font-size: 0.72rem; color: #64748b; font-weight: 500; margin-top: 1rem; }

.loading-wrapper { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 10rem 0; color: #64748b; gap: 1rem; }
.spinner { width: 40px; height: 40px; border: 3px solid rgba(26,108,247,0.1); border-top-color: #1a6cf7; border-radius: 50%; animation: spin 0.8s linear infinite; }
.spinner-small { width: 18px; height: 18px; border: 2px solid rgba(255,255,255,0.4); border-top-color: white; border-radius: 50%; animation: spin 0.7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* LIGHTBOX */
.lightbox { position: fixed; inset: 0; background: rgba(0,0,0,0.9); z-index: 1000; display: flex; align-items: center; justify-content: center; }
.lightbox-content { position: relative; max-width: 90vw; max-height: 85vh; }
.lightbox-content img { max-width: 100%; max-height: 85vh; object-fit: contain; border-radius: 8px; }
.lightbox-close { position: absolute; top: -2.5rem; right: 0; background: none; border: none; color: white; font-size: 2rem; cursor: pointer; }
.lightbox-prev, .lightbox-next { position: absolute; top: 50%; transform: translateY(-50%); background: rgba(255,255,255,0.1); color: white; font-size: 2.5rem; border: none; width: 50px; height: 50px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background 0.2s; }
.lightbox-prev { left: -4rem; }
.lightbox-next { right: -4rem; }
.lightbox-prev:hover, .lightbox-next:hover { background: rgba(255,255,255,0.25); }

/* SUCCESS MODAL */
.success-backdrop { position: fixed; inset: 0; background: rgba(15,23,42,0.6); backdrop-filter: blur(6px); z-index: 10000; display: flex; align-items: center; justify-content: center; padding: 1.5rem; }
.success-card { background: white; border-radius: 24px; padding: 2.5rem; width: 100%; max-width: 500px; text-align: center; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); animation: scaleIn 0.32s cubic-bezier(0.34, 1.56, 0.64, 1); }
@keyframes scaleIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
.success-icon-wrap { display: flex; justify-content: center; margin-bottom: 1.5rem; }
.checkmark-svg { width: 64px; height: 64px; border-radius: 50%; stroke: #10b981; stroke-width: 3; stroke-miterlimit: 10; box-shadow: inset 0px 0px 0px #10b981; animation: fillCheckmark .4s ease-in-out .4s forwards, scaleCheckmark .3s ease-in-out .9s both; }
.checkmark-circle { stroke-dasharray: 166; stroke-dashoffset: 166; stroke-width: 3; stroke-miterlimit: 10; stroke: #10b981; fill: none; animation: strokeCheckmark .6s cubic-bezier(0.65, 0, 0.45, 1) forwards; }
.checkmark-check { transform-origin: 50% 50%; stroke-dasharray: 48; stroke-dashoffset: 48; animation: strokeCheckmark .3s cubic-bezier(0.65, 0, 0.45, 1) .6s forwards; }
@keyframes strokeCheckmark { to { stroke-dashoffset: 0; } }
@keyframes fillCheckmark { to { box-shadow: inset 0px 0px 0px 30px rgba(16,185,129,0.1); } }
@keyframes scaleCheckmark { 0%, 100% { transform: none; } 50% { transform: scale3d(1.1, 1.1, 1); } }

.success-card h2 { font-size: 1.6rem; font-weight: 800; color: #10b981; margin-bottom: 0.5rem; }
.success-card p { font-size: 0.95rem; color: #475569; line-height: 1.6; margin-bottom: 1.5rem; }
.success-details { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.25rem; text-align: left; margin-bottom: 2rem; display: flex; flex-direction: column; gap: 0.6rem; font-size: 0.9rem; }
.success-details strong { color: #1e293b; }
.btn-go-bookings {
  width: 100%; background: #1a6cf7; color: white; border: none; padding: 1rem; border-radius: 12px;
  font-size: 1rem; font-weight: 700; cursor: pointer; transition: background 0.2s;
  box-shadow: 0 4px 15px rgba(26,108,247,0.3); font-family: 'Inter', sans-serif;
}
.btn-go-bookings:hover { background: #1558d6; }

@media (max-width: 1024px) {
  .gallery-grid { height: 300px; }
  .content-grid { grid-template-columns: 1.5fr 1.2fr; }
}
@media (max-width: 768px) {
  .gallery-grid { grid-template-columns: 1fr; height: 260px; }
  .sub-photos { display: none; }
  .content-grid { grid-template-columns: 1fr; }
  .booking-column { position: static; }
  .highlights-grid { grid-template-columns: 1fr; }
  .rating-summary { flex-direction: column; gap: 1.5rem; text-align: center; }
  .rating-big-box { border-right: none; border-bottom: 1px solid #e2e8f0; padding-right: 0; padding-bottom: 1.5rem; width: 100%; }
  
  /* Header responsive */
  .header-lang-selector-dropdown { display: none !important; }
  .logo { font-size: 1.15rem; }
  .btn-back { font-size: 0.8rem; }
  .btn-outline { padding: 0.4rem 0.8rem; font-size: 0.8rem; }
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