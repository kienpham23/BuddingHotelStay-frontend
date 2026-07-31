<template>
  <div class="auth-page">
    <div class="auth-box">
      <!-- Decorative Background Blobs -->
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>



      <RouterLink to="/" class="logo-wrap">
        <h1 class="logo">
          <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="22" height="22" style="width: 22px; height: 22px; flex-shrink: 0; margin-right: 6px;">
            <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="logo-word building">Building</span>
          <span class="logo-word hotel">Hotel</span>
          <span class="logo-word stay">Stay</span>
        </h1>
      </RouterLink>
      
      <h2>{{ $t('auth.register_title') }}</h2>
      <p class="subtitle">{{ $t('auth.register_subtitle') }}</p>

      <form @submit.prevent="handleRegister" class="auth-form">
        <div class="field-group">
          <label>{{ $t('auth.fullname_label') }}</label>
          <div class="input-wrap">
            <input
              v-model="fullName"
              type="text"
              :placeholder="$t('auth.fullname_placeholder')"
              required
            />
          </div>
        </div>

        <div class="field-group">
          <label>{{ $t('auth.email_label') }}</label>
          <div class="input-wrap">
            <input
              v-model="email"
              type="email"
              :placeholder="$t('auth.email_placeholder')"
              required
            />
          </div>
        </div>

        <div class="form-row">
          <div class="field-group">
            <label>{{ $t('auth.password_label') }}</label>
            <div class="input-wrap">
              <input
                v-model="password"
                :type="showPwd ? 'text' : 'password'"
                :placeholder="$t('auth.password_placeholder')"
                required
                minlength="6"
              />
            </div>
          </div>

          <div class="field-group">
            <label>{{ $t('auth.confirm_pwd_label') }}</label>
            <div class="input-wrap" :class="{ 'input-error': pwdMismatch }">
              <input
                v-model="confirmPassword"
                :type="showPwd ? 'text' : 'password'"
                :placeholder="$t('auth.password_placeholder')"
                required
              />
            </div>
          </div>
        </div>
        <span v-if="pwdMismatch" class="field-error">{{ $t('auth.pwd_mismatch') }}</span>

        <div class="host-cta-box">
          <span>{{ $t('auth.host_cta_text') }}</span>
          <RouterLink to="/host/register">{{ $t('auth.host_cta_link') }}</RouterLink>
        </div>

        <div v-if="error" class="error-msg">{{ error }}</div>

        <button type="submit" class="btn-primary" :disabled="loading || pwdMismatch">
          <span v-if="!loading">{{ $t('auth.register_btn') }}</span>
          <span v-else class="spinner"></span>
        </button>

        <div class="auth-divider">
          <span>{{ $t('auth.or_divider') }}</span>
        </div>

        <button @click="redirectToGoogle" type="button" class="btn-google">
          <svg class="google-icon" viewBox="0 0 24 24" width="18" height="18">
            <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v3.92h6.69c-.29 1.5-1.14 2.77-2.4 3.61v3h3.86c2.26-2.08 3.59-5.14 3.59-8.46z"/>
            <path fill="#34A853" d="M12 24c3.24 0 5.97-1.08 7.96-2.91l-3.86-3c-1.08.72-2.45 1.16-4.1 1.16-3.15 0-5.81-2.13-6.76-5.01H1.27v3.1A12 12 0 0 0 12 24z"/>
            <path fill="#FBBC05" d="M5.24 14.24a7.15 7.15 0 0 1 0-4.48V6.66H1.27a11.96 11.96 0 0 0 0 10.68l3.97-3.1z"/>
            <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.22 0 12 0A12 12 0 0 0 1.27 6.66l3.97 3.1c.95-2.88 3.61-5.01 6.76-5.01z"/>
          </svg>
          {{ $t('auth.register_google') }}
        </button>

        <p class="switch-text">
          {{ $t('auth.already_have_account') }}
          <RouterLink to="/login">{{ $t('auth.login_now') }}</RouterLink>
        </p>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useI18n } from 'vue-i18n'

const router = useRouter()
const authStore = useAuthStore()
const { t, locale } = useI18n()

const fullName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const role = ref('CUSTOMER')
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
      role: role.value
    })
    
    // Redirect appropriately
    const userRole = authStore.role
    if (userRole === 'ADMIN') router.push('/admin')
    else if (userRole === 'HOST') router.push('/host/rooms')
    else if (userRole === 'CUSTOMER') router.push('/bookings')
    else router.push('/')
  } catch (e) {
    const apiMsg = e.response?.data?.message || e.response?.data?.error
    if (apiMsg && apiMsg.toLowerCase().includes('exist')) {
      error.value = t('auth.errors.register_failed_exists')
    } else {
      error.value = apiMsg || t('auth.errors.register_failed_unknown')
    }
  } finally {
    loading.value = false
  }
}

const redirectToGoogle = () => {
  const backendUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8088'
  window.location.href = `${backendUrl}/api/auth/oauth2/initiate?role=CUSTOMER`
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }

.auth-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f0f4ff 0%, #faf5ff 50%, #f0fdf4 100%);
  font-family: 'Inter', sans-serif;
  padding: 1.5rem;
}

.auth-box {
  background: linear-gradient(135deg, #ffffff 0%, #fcfcff 50%, #f8fafc 100%);
  padding: 3rem 2.5rem;
  border-radius: 24px;
  box-shadow: 0 20px 40px -15px rgba(15, 23, 42, 0.15);
  border: 1px solid rgba(226, 232, 240, 0.8);
  width: 100%;
  max-width: 480px;
  text-align: center;
  position: relative;
  overflow: hidden;
}

/* ── Decorative Background Blobs ─────────────────────── */
.blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(45px);
  opacity: 0.12;
  z-index: 0;
  pointer-events: none;
}
.blob-1 {
  top: -20px;
  left: -20px;
  width: 130px;
  height: 130px;
  background: #3b82f6;
}
.blob-2 {
  bottom: -20px;
  right: -20px;
  width: 150px;
  height: 150px;
  background: #a855f7;
}

/* Ensure inner elements lay on top of blobs */
.logo-wrap, h2, .subtitle, .auth-form {
  position: relative;
  z-index: 1;
}

.auth-box::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 5px;
  background: linear-gradient(90deg, #1a6cf7, #3b82f6);
  z-index: 2;
}

.logo-wrap {
  text-decoration: none;
  display: inline-block;
  margin-bottom: 1.25rem;
}

.logo {
  font-size: 1.65rem;
  font-weight: 800;
  letter-spacing: -0.05em;
  color: #1a6cf7;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-decoration: none;
}

.logo-brand-icon, .logo-word {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo:hover .logo-brand-icon {
  transform: rotate(-10deg) scale(1.15);
  stroke: #ff567d;
}
.logo:hover .logo-word.building { color: #ff567d; }
.logo:hover .logo-word.hotel { color: #1a6cf7; }
.logo:hover .logo-word.stay { color: #1f2937; }

.logo-brand-icon {
  width: 24px;
  height: 24px;
}

.logo-word.building { color: #1a6cf7; }
.logo-word.hotel { color: #ff567d; }
.logo-word.stay { color: #1a6cf7; }

h2 {
  font-size: 1.5rem;
  font-weight: 800;
  color: #0f172a;
  margin-bottom: 0.4rem;
}

.subtitle {
  font-size: 13.5px;
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

.field-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
  min-width: 0;
}

.field-group label {
  font-size: 10.5px;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.input-wrap {
  display: flex;
  align-items: center;
  border: 1px solid #cbd5e1;
  border-radius: 12px;
  padding: 0 14px;
  height: 46px;
  background: #ffffff;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.input-wrap:focus-within {
  border-color: #3b82f6;
  background: #ffffff;
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
}

.input-wrap.input-error {
  border-color: #ef4444;
  background: #fff5f5;
}

.input-wrap input, .role-select {
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

.role-select {
  cursor: pointer;
  height: 100%;
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

.switch-text {
  text-align: center;
  font-size: 13.5px;
  color: #64748b;
  margin-top: 4px;
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
  margin-bottom: 8px;
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

.host-cta-box {
  background: #f8fafc;
  border: 1.5px dashed #cbd5e1;
  border-radius: 12px;
  padding: 10px 12px;
  text-align: center;
  font-size: 13.5px;
  color: #475569;
  margin-top: 4px;
  margin-bottom: 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.host-cta-box a {
  color: #1a6cf7;
  font-weight: 700;
  text-decoration: none;
}
.host-cta-box a:hover {
  text-decoration: underline;
}

@media (max-width: 480px) {
  .form-row {
    flex-direction: column;
    gap: 16px;
  }
}

.lang-selector {
  position: absolute;
  top: 24px;
  right: 24px;
  display: flex;
  align-items: center;
  gap: 4px;
  z-index: 10;
  background: rgba(241, 245, 249, 0.85);
  padding: 4px 8px;
  border-radius: 20px;
  border: 1px solid rgba(226, 232, 240, 0.8);
  backdrop-filter: blur(4px);
}

.lang-btn {
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

.lang-btn:hover {
  color: #0f172a;
}

.lang-btn.active {
  color: #ffffff;
  background: #3b82f6;
}

.lang-divider {
  font-size: 10px;
  color: #cbd5e1;
}
</style>