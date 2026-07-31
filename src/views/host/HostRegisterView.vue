<template>
  <div class="host-register-page">
    <div class="register-container">
      
      <!-- LEFT PANEL: Brand Info & Benefits -->
      <div class="benefits-panel">
        <div class="panel-overlay"></div>
        <img src="../../assets/host_signup_hero.png" alt="Hosting cover" class="panel-bg" />
        
        <div class="panel-content">
          <RouterLink to="/" class="logo-wrap">
            <h1 class="logo">
              <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="24" height="24">
                <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              <span class="logo-word building">Building</span>
              <span class="logo-word hotel">Hotel</span>
              <span class="logo-word stay">Stay</span>
            </h1>
          </RouterLink>
          
          <div class="hero-text-group">
            <h2 class="benefits-title">{{ locale === 'vi' ? 'Trở thành chủ nhà trên Building Hotel Stay' : 'Become a Host on Building Hotel Stay' }}</h2>
            <p class="benefits-subtitle">{{ locale === 'vi' ? 'Kiếm tiền từ không gian trống của bạn và kết nối với hàng triệu khách du lịch toàn cầu.' : 'Earn money from your spare space and connect with millions of global travelers.' }}</p>
          </div>

          <div class="benefits-list">
            <div class="benefit-item">
              <div class="benefit-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                  <polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
              </div>
              <div class="benefit-info">
                <h3>{{ locale === 'vi' ? 'Đăng tin hoàn toàn miễn phí' : 'List for free' }}</h3>
                <p>{{ locale === 'vi' ? 'Đăng ký phòng nghỉ, nhà nghỉ dưỡng của bạn mà không tốn bất kỳ chi phí ban đầu nào.' : 'Register your rooms or vacation homes with zero upfront costs.' }}</p>
              </div>
            </div>

            <div class="benefit-item">
              <div class="benefit-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                </svg>
              </div>
              <div class="benefit-info">
                <h3>{{ locale === 'vi' ? 'Tối ưu hóa doanh thu của bạn' : 'Maximize your revenue' }}</h3>
                <p>{{ locale === 'vi' ? 'Gia tăng doanh thu lên đến 45% thông qua hệ thống phân phối và định giá thông minh của chúng tôi.' : 'Increase revenue up to 45% using our smart distribution and pricing systems.' }}</p>
              </div>
            </div>

            <div class="benefit-item">
              <div class="benefit-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
              </div>
              <div class="benefit-info">
                <h3>{{ locale === 'vi' ? 'Thanh toán an toàn, nhanh chóng' : 'Secure and fast payments' }}</h3>
                <p>{{ locale === 'vi' ? 'Quản lý giao dịch minh bạch, nhận thanh toán tự động qua cổng thanh toán bảo mật cao.' : 'Transparent transaction management, get paid automatically via highly secure gateway.' }}</p>
              </div>
            </div>

            <div class="benefit-item">
              <div class="benefit-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/>
                </svg>
              </div>
              <div class="benefit-info">
                <h3>{{ locale === 'vi' ? 'Công cụ quản lý chuyên nghiệp' : 'Professional management tools' }}</h3>
                <p>{{ locale === 'vi' ? 'Báo cáo doanh thu trực quan, lịch đặt phòng thông minh và bộ quản lý phòng tối tân.' : 'Visual revenue reports, smart booking calendar, and state-of-the-art room manager.' }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- RIGHT PANEL: Register Form -->
      <div class="form-panel">
        <div class="form-card">
          <h2>{{ locale === 'vi' ? 'Đăng ký Kênh Chủ Nhà' : 'Register Host Account' }}</h2>
          <p class="subtitle">{{ locale === 'vi' ? 'Bắt đầu kinh doanh dịch vụ lưu trú ngay hôm nay' : 'Start your hospitality business today' }}</p>

          <form @submit.prevent="handleRegister" class="auth-form">
            <div class="field-group">
              <label>{{ locale === 'vi' ? 'HỌ VÀ TÊN' : 'FULL NAME' }}</label>
              <div class="input-wrap">
                <span class="icon">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                  </svg>
                </span>
                <input
                  v-model="fullName"
                  type="text"
                  :placeholder="locale === 'vi' ? 'Nguyễn Văn A' : 'John Doe'"
                  required
                />
              </div>
            </div>

            <div class="field-group">
              <label>{{ locale === 'vi' ? 'EMAIL CHỦ NHÀ' : 'HOST EMAIL' }}</label>
              <div class="input-wrap">
                <span class="icon">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="2" y="4" width="20" height="16" rx="2"/>
                    <polyline points="2,4 12,13 22,4"/>
                  </svg>
                </span>
                <input
                  v-model="email"
                  type="email"
                  placeholder="host@example.com"
                  required
                />
              </div>
            </div>

            <div class="form-row">
              <div class="field-group">
                <label>{{ locale === 'vi' ? 'MẬT KHẨU' : 'PASSWORD' }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="11" width="18" height="11" rx="2"/>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                  </span>
                  <input
                    v-model="password"
                    :type="showPwd ? 'text' : 'password'"
                    placeholder="••••••••"
                    required
                    minlength="6"
                  />
                </div>
              </div>

              <div class="field-group">
                <label>{{ locale === 'vi' ? 'XÁC NHẬN MẬT KHẨU' : 'CONFIRM PASSWORD' }}</label>
                <div class="input-wrap" :class="{ 'input-error': pwdMismatch }">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="11" width="18" height="11" rx="2"/>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                  </span>
                  <input
                    v-model="confirmPassword"
                    :type="showPwd ? 'text' : 'password'"
                    placeholder="••••••••"
                    required
                  />
                  <button type="button" class="eye-btn" @click="showPwd = !showPwd">
                    <svg v-if="!showPwd" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                      <circle cx="12" cy="12" r="3"/>
                    </svg>
                    <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                      <line x1="1" y1="1" x2="23" y2="23"/>
                    </svg>
                  </button>
                </div>
              </div>
            </div>
            <span v-if="pwdMismatch" class="field-error">{{ locale === 'vi' ? 'Mật khẩu xác nhận không khớp' : 'Password confirmation does not match' }}</span>

            <div v-if="error" class="error-msg">{{ error }}</div>

            <button type="submit" class="btn-primary" :disabled="loading || pwdMismatch">
              <span v-if="!loading">{{ locale === 'vi' ? 'Đăng ký làm Chủ Nhà' : 'Register as Host' }}</span>
              <span v-else class="spinner"></span>
            </button>

            <div class="auth-divider">
              <span>{{ locale === 'vi' ? 'Hoặc' : 'Or' }}</span>
            </div>

            <!-- Google signup button specifically for host -->
            <button @click="redirectToGoogle" type="button" class="btn-google">
              <svg class="google-icon" viewBox="0 0 24 24" width="18" height="18">
                <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v3.92h6.69c-.29 1.5-1.14 2.77-2.4 3.61v3h3.86c2.26-2.08 3.59-5.14 3.59-8.46z"/>
                <path fill="#34A853" d="M12 24c3.24 0 5.97-1.08 7.96-2.91l-3.86-3c-1.08.72-2.45 1.16-4.1 1.16-3.15 0-5.81-2.13-6.76-5.01H1.27v3.1A12 12 0 0 0 12 24z"/>
                <path fill="#FBBC05" d="M5.24 14.24a7.15 7.15 0 0 1 0-4.48V6.66H1.27a11.96 11.96 0 0 0 0 10.68l3.97-3.1z"/>
                <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.22 0 12 0A12 12 0 0 0 1.27 6.66l3.97 3.1c.95-2.88 3.61-5.01 6.76-5.01z"/>
              </svg>
              {{ locale === 'vi' ? 'Đăng ký chủ nhà bằng Google' : 'Register Host with Google' }}
            </button>

            <p class="switch-text">
              {{ locale === 'vi' ? 'Đã có tài khoản chủ nhà?' : 'Already have a host account?' }}
              <RouterLink to="/login">{{ locale === 'vi' ? 'Đăng nhập ngay' : 'Login now' }}</RouterLink>
            </p>
          </form>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useI18n } from 'vue-i18n'

const router = useRouter()
const authStore = useAuthStore()
const { locale } = useI18n()

const fullName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const showPwd = ref(false)
const loading = ref(false)
const error = ref('')

const pwdMismatch = computed(() => {
  return confirmPassword.value.length > 0 && password.value !== confirmPassword.value
})

const handleRegister = async () => {
  if (pwdMismatch.value) return
  error.value = ''
  loading.value = true
  try {
    await authStore.register({
      fullName: fullName.value,
      email: email.value,
      password: password.value,
      role: 'HOST' // Predefined role for hosts
    })
    
    // Redirect to Host Rooms Panel
    router.push('/host/rooms')
  } catch (e) {
    error.value = e.response?.data?.message || (locale.value === 'vi' ? 'Đăng ký tài khoản thất bại. Email có thể đã tồn tại.' : 'Registration failed. Email may already exist.')
  } finally {
    loading.value = false
  }
}

const redirectToGoogle = () => {
  const backendUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8088'
  window.location.href = `${backendUrl}/oauth2/authorization/google`
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }

.host-register-page {
  display: flex;
  min-height: 100vh;
  font-family: 'Outfit', sans-serif;
  background: #f8fafc;
}

.register-container {
  display: flex;
  width: 100%;
}

/* ── LEFT PANEL: Benefits ──────────────────────────────── */
.benefits-panel {
  flex: 1.1;
  position: relative;
  display: flex;
  flex-direction: column;
  padding: 4rem;
  justify-content: space-between;
  overflow: hidden;
  color: #ffffff;
}

@media (max-width: 1024px) {
  .benefits-panel {
    display: none; /* Hide on tablets and mobile */
  }
}

.panel-bg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 1;
}

.panel-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.9) 0%, rgba(26, 108, 247, 0.8) 100%);
  z-index: 2;
}

.panel-content {
  position: relative;
  z-index: 3;
  display: flex;
  flex-direction: column;
  height: 100%;
  justify-content: space-between;
  gap: 3rem;
}

.logo-wrap {
  text-decoration: none;
  display: inline-block;
}

.logo {
  font-size: 1.8rem;
  font-weight: 800;
  letter-spacing: -0.05em;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.logo-brand-icon {
  stroke: #ffffff;
}

.logo-word.building { color: #ffffff; }
.logo-word.hotel { color: #3b82f6; }
.logo-word.stay { color: #ffffff; }

.hero-text-group {
  margin-top: 1rem;
}

.benefits-title {
  font-size: 2.2rem;
  font-weight: 800;
  line-height: 1.25;
  margin-bottom: 1rem;
}

.benefits-subtitle {
  font-size: 1.1rem;
  opacity: 0.85;
  line-height: 1.6;
}

.benefits-list {
  display: flex;
  flex-direction: column;
  gap: 1.75rem;
}

.benefit-item {
  display: flex;
  gap: 1.25rem;
  align-items: flex-start;
}

.benefit-icon {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(8px);
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border: 1px solid rgba(255, 255, 255, 0.25);
}

.benefit-info h3 {
  font-size: 1.05rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
}

.benefit-info p {
  font-size: 0.9rem;
  opacity: 0.8;
  line-height: 1.5;
}

/* ── RIGHT PANEL: Form ────────────────────────────────── */
.form-panel {
  flex: 0.9;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  background: #ffffff;
}

@media (max-width: 1024px) {
  .form-panel {
    flex: 1;
    background: linear-gradient(135deg, #f0f4ff 0%, #faf5ff 50%, #f0fdf4 100%);
  }
}

.form-card {
  width: 100%;
  max-width: 460px;
}

@media (max-width: 1024px) {
  .form-card {
    background: #ffffff;
    padding: 3rem 2.5rem;
    border-radius: 24px;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 30px 60px -15px rgba(15, 23, 42, 0.1);
    border: 1px solid rgba(226, 232, 240, 0.8);
  }
}

h2 {
  font-size: 1.8rem;
  font-weight: 800;
  color: #0f172a;
  margin-bottom: 0.5rem;
  letter-spacing: -0.02em;
}

.subtitle {
  font-size: 14px;
  color: #475569;
  margin-bottom: 2rem;
  font-weight: 500;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
  text-align: left;
}

.form-row {
  display: flex;
  gap: 12px;
}

@media (max-width: 480px) {
  .form-row {
    flex-direction: column;
    gap: 16px;
  }
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
  min-width: 0;
}

.field-group label {
  font-size: 11px;
  font-weight: 800;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.input-wrap {
  display: flex;
  align-items: center;
  border: 1.5px solid #e2e8f0;
  border-radius: 12px;
  padding: 0 14px;
  height: 48px;
  gap: 10px;
  background: #f8fafc;
  transition: all 0.2s ease;
}

.input-wrap:focus-within {
  border-color: #3b82f6;
  background: #ffffff;
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.12);
}

.input-wrap.input-error {
  border-color: #ef4444;
  background: #fff5f5;
}

.input-wrap .icon {
  display: flex;
  align-items: center;
  color: #94a3b8;
  flex-shrink: 0;
}

.input-wrap input {
  flex: 1;
  border: none;
  background: transparent;
  outline: none;
  font-size: 14.5px;
  font-weight: 500;
  color: #0f172a;
  width: 100%;
}

.input-wrap input::placeholder {
  color: #94a3b8;
}

.eye-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: #94a3b8;
  display: flex;
  align-items: center;
  padding: 0;
  transition: color 0.2s;
}

.eye-btn:hover {
  color: #475569;
}

.field-error {
  font-size: 12px;
  color: #ef4444;
  margin-top: -4px;
  font-weight: 500;
}

.error-msg {
  background: #fef2f2;
  border: 1px solid #fee2e2;
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 13px;
  color: #b91c1c;
  text-align: center;
  font-weight: 500;
}

.btn-primary {
  background: linear-gradient(135deg, #1a6cf7, #1558d6);
  color: white;
  border: none;
  height: 48px;
  border-radius: 12px;
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s ease;
  box-shadow: 0 4px 12px rgba(26, 108, 247, 0.25);
  margin-top: 8px;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #2c7bf9, #175ee3);
  box-shadow: 0 6px 20px rgba(26, 108, 247, 0.35);
  transform: translateY(-1px);
}

.btn-primary:active {
  transform: translateY(1px);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

/* ── Auth Divider ─────────────────────────────────────── */
.auth-divider {
  display: flex;
  align-items: center;
  text-align: center;
  margin: 10px 0;
  color: #94a3b8;
  font-size: 13px;
  font-weight: 500;
}

.auth-divider::before,
.auth-divider::after {
  content: '';
  flex: 1;
  border-bottom: 1px solid #e2e8f0;
}

.auth-divider:not(:empty)::before {
  margin-right: 12px;
}

.auth-divider:not(:empty)::after {
  margin-left: 12px;
}

/* ── Google Button ────────────────────────────────────── */
.btn-google {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  width: 100%;
  height: 48px;
  background: #ffffff;
  border: 1.5px solid #cbd5e1;
  border-radius: 12px;
  color: #334155;
  font-size: 14.5px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
}

.btn-google:hover {
  background: #f8fafc;
  border-color: #94a3b8;
  color: #0f172a;
  transform: translateY(-1px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}

.btn-google:active {
  transform: translateY(1px);
}

.google-icon {
  flex-shrink: 0;
}

.switch-text {
  text-align: center;
  font-size: 14px;
  color: #64748b;
  margin-top: 12px;
}

.switch-text a {
  color: #3b82f6;
  font-weight: 600;
  text-decoration: none;
}

.switch-text a:hover {
  text-decoration: underline;
}

.spinner {
  width: 20px;
  height: 20px;
  border: 2.5px solid rgba(255, 255, 255, 0.4);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
