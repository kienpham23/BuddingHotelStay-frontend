<template>
  <!-- Backdrop -->
  <Teleport to="body">
    <Transition name="backdrop-fade">
      <div
          v-if="modelValue"
          class="auth-backdrop"
          @click.self="$emit('update:modelValue', false)"
      >
        <!-- Modal -->
        <div
            v-motion
            :initial="{ opacity: 0, y: 40, scale: 0.96 }"
            :enter="{ opacity: 1, y: 0, scale: 1, transition: { duration: 320, ease: 'easeOut' } }"
            :leave="{ opacity: 0, y: 20, scale: 0.97, transition: { duration: 200 } }"
            class="auth-modal"
        >
          <!-- Decorative Background Blobs -->
          <div class="blob blob-1"></div>
          <div class="blob blob-2"></div>



          <!-- Close button -->
          <button class="btn-close" @click="$emit('update:modelValue', false)">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
              <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>

          <!-- Tabs -->
          <div class="tabs" v-if="activeTab !== 'forgot'">
            <button
                class="tab-btn"
                :class="{ active: activeTab === 'login' }"
                @click="switchTab('login')"
            >{{ $t('auth.tab_login') }}</button>
            <button
                class="tab-btn"
                :class="{ active: activeTab === 'register' }"
                @click="switchTab('register')"
            >{{ $t('auth.tab_register') }}</button>
            <!-- Sliding indicator -->
            <div class="tab-indicator" :style="indicatorStyle" />
          </div>

          <!-- Subtitle -->
          <p class="subtitle" v-if="activeTab !== 'forgot'">
            <Transition name="text-swap" mode="out-in">
              <span :key="activeTab">
                 {{ activeTab === 'login'
                  ? $t('auth.modal_login_subtitle')
                  : $t('auth.modal_register_subtitle') }}
              </span>
            </Transition>
          </p>

          <!-- Forms -->
          <Transition name="form-slide" mode="out-in">
            <!-- LOGIN FORM -->
            <form v-if="activeTab === 'login'" key="login" class="auth-form" @submit.prevent="handleLogin">
              <div class="field-group">
                <label>{{ $t('auth.email_label') }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="2" y="4" width="20" height="16" rx="2"/>
                      <polyline points="2,4 12,13 22,4"/>
                    </svg>
                  </span>
                  <input
                      v-model="loginForm.email"
                      type="email"
                      :placeholder="$t('auth.email_placeholder')"
                      autocomplete="email"
                      required
                  />
                </div>
              </div>

              <div class="field-group">
                <label>{{ $t('auth.password_label') }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                  </span>
                  <input
                      v-model="loginForm.password"
                      :type="showLoginPwd ? 'text' : 'password'"
                      :placeholder="$t('auth.password_placeholder')"
                      autocomplete="current-password"
                      required
                  />
                  <button type="button" class="eye-btn" @click="showLoginPwd = !showLoginPwd">
                    <svg v-if="!showLoginPwd" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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

              <div class="remember-row">
                <label class="checkbox-label">
                  <input v-model="loginForm.remember" type="checkbox" />
                  <span class="checkmark" />
                  {{ $t('auth.remember_me') }}
                </label>
                <a href="#" class="forgot-link" @click.prevent="switchTab('forgot')">{{ $t('auth.forgot_password_link') }}</a>
              </div>

              <!-- Error message -->
              <Transition name="error-fade">
                <div v-if="loginError" class="error-msg">{{ loginError }}</div>
              </Transition>

              <button type="submit" class="btn-primary" :class="{ loading: isLoading }">
                <span v-if="!isLoading">{{ $t('auth.login_btn') }}</span>
                <span v-else class="spinner" />
              </button>

              <p class="switch-text">
                {{ $t('auth.no_account') }}
                <a href="#" @click.prevent="switchTab('register')">{{ $t('auth.create_account') }}</a>
              </p>
            </form>

            <!-- REGISTER FORM -->
            <form v-else-if="activeTab === 'register'" key="register" class="auth-form" @submit.prevent="handleRegister">
              <div class="field-group">
                <label>{{ $t('auth.fullname_label') }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                      <circle cx="12" cy="7" r="4"/>
                    </svg>
                  </span>
                  <input
                      v-model="registerForm.fullName"
                      type="text"
                      :placeholder="$t('auth.fullname_placeholder')"
                      autocomplete="name"
                      required
                  />
                </div>
              </div>

              <div class="field-group">
                <label>{{ $t('auth.email_label') }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="2" y="4" width="20" height="16" rx="2"/>
                      <polyline points="2,4 12,13 22,4"/>
                    </svg>
                  </span>
                  <input
                      v-model="registerForm.email"
                      type="email"
                      :placeholder="$t('auth.email_placeholder')"
                      autocomplete="email"
                      required
                  />
                </div>
              </div>

              <div class="field-group">
                <label>{{ $t('auth.password_label') }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="11" width="18" height="11" rx="2"/>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                  </span>
                  <input
                      v-model="registerForm.password"
                      :type="showRegPwd ? 'text' : 'password'"
                      :placeholder="$t('auth.password_placeholder')"
                      autocomplete="new-password"
                      required
                      minlength="6"
                  />
                  <button type="button" class="eye-btn" @click="showRegPwd = !showRegPwd">
                    <svg v-if="!showRegPwd" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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

              <div class="field-group">
                <label>{{ $t('auth.confirm_pwd_label') }}</label>
                <div class="input-wrap" :class="{ 'input-error': pwdMismatch }">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="3" y="11" width="18" height="11" rx="2"/>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                  </span>
                  <input
                      v-model="registerForm.confirmPassword"
                      :type="showRegPwd ? 'text' : 'password'"
                      :placeholder="$t('auth.password_placeholder')"
                      autocomplete="new-password"
                      required
                  />
                </div>
                <Transition name="error-fade">
                  <span v-if="pwdMismatch" class="field-error">{{ $t('auth.pwd_mismatch') }}</span>
                </Transition>
              </div>

              <!-- Error message -->
              <Transition name="error-fade">
                <div v-if="registerError" class="error-msg">{{ registerError }}</div>
              </Transition>

              <button type="submit" class="btn-primary" :class="{ loading: isLoading }">
                <span v-if="!isLoading">{{ $t('auth.register_btn') }}</span>
                <span v-else class="spinner" />
              </button>

              <div class="host-cta-box">
                <span>{{ $t('auth.host_cta_text') }}</span>
                <RouterLink to="/host/register" @click="$emit('update:modelValue', false)">{{ $t('auth.host_cta_link') }}</RouterLink>
              </div>

              <p class="switch-text">
                {{ $t('auth.already_have_account') }}
                <a href="#" @click.prevent="switchTab('login')">{{ $t('auth.login_now') }}</a>
              </p>
            </form>
            <!-- REGISTER FORM END / FORGOT PASSWORD FORM -->
            <form v-else-if="activeTab === 'forgot'" key="forgot" class="auth-form" @submit.prevent="handleForgotPassword">
              <h2 style="font-size: 1.4rem; font-weight: 800; color: #0f172a; margin-bottom: 0.2rem; text-align: center;">{{ $t('auth.forgot_title') }}</h2>
              <p class="subtitle" style="margin-bottom: 12px; text-align: center;">
                {{ forgotStep === 1 
                  ? $t('auth.forgot_subtitle_step1') 
                  : $t('auth.forgot_subtitle_step2') }}
              </p>

              <!-- Step 1: Input email -->
              <div v-if="forgotStep === 1" class="field-group">
                <label>{{ $t('auth.email_reg_label') }}</label>
                <div class="input-wrap">
                  <span class="icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="2" y="4" width="20" height="16" rx="2"/>
                      <polyline points="2,4 12,13 22,4"/>
                    </svg>
                  </span>
                  <input
                      v-model="forgotForm.email"
                      type="email"
                      :placeholder="$t('auth.email_placeholder')"
                      required
                  />
                </div>
              </div>

              <!-- Step 2: Input OTP & new password -->
              <template v-else>
                <div class="field-group">
                  <label>{{ $t('auth.otp_label') }}</label>
                  <div class="input-wrap">
                    <span class="icon">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="M12 8v4M12 16h.01"/>
                      </svg>
                    </span>
                    <input
                        v-model="forgotForm.otp"
                        type="text"
                        :placeholder="$t('auth.otp_placeholder')"
                        required
                    />
                  </div>
                </div>

                <div class="field-group">
                  <label>{{ $t('auth.new_password_label') }}</label>
                  <div class="input-wrap">
                    <span class="icon">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                      </svg>
                    </span>
                    <input
                        v-model="forgotForm.newPassword"
                        type="password"
                        :placeholder="$t('auth.new_password_placeholder')"
                        required
                        minlength="6"
                    />
                  </div>
                </div>

                <div class="field-group">
                  <label>{{ $t('auth.confirm_new_password_label') }}</label>
                  <div class="input-wrap" :class="{ 'input-error': forgotPwdMismatch }">
                    <span class="icon">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                      </svg>
                    </span>
                    <input
                        v-model="forgotForm.confirmPassword"
                        type="password"
                        :placeholder="$t('auth.password_placeholder')"
                        required
                    />
                  </div>
                  <Transition name="error-fade">
                    <span v-if="forgotPwdMismatch" class="field-error">{{ $t('auth.pwd_mismatch') }}</span>
                  </Transition>
                </div>
              </template>

              <!-- Success/Error messages -->
              <div v-if="forgotSuccessMsg" class="success-msg">{{ forgotSuccessMsg }}</div>
              <div v-if="forgotErrorMsg" class="error-msg">{{ forgotErrorMsg }}</div>

              <button type="submit" class="btn-primary" :class="{ loading: isLoading }" :disabled="forgotStep === 2 && forgotPwdMismatch">
                <span v-if="!isLoading">
                  {{ forgotStep === 1 ? $t('auth.send_otp_btn') : $t('auth.reset_pwd_btn') }}
                </span>
                <span v-else class="spinner" />
              </button>

              <p class="switch-text">
                <a href="#" @click.prevent="switchTab('login')">{{ $t('auth.back_to_login') }}</a>
              </p>
            </form>
          </Transition>

          <div class="auth-divider" v-if="activeTab !== 'forgot'">
            <span>{{ $t('auth.or_divider') }}</span>
          </div>

          <div class="google-login-container" v-if="activeTab !== 'forgot'">
            <button @click="redirectToGoogle" type="button" class="btn-google">
              <svg class="google-icon" viewBox="0 0 24 24" width="18" height="18">
                <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v3.92h6.69c-.29 1.5-1.14 2.77-2.4 3.61v3h3.86c2.26-2.08 3.59-5.14 3.59-8.46z"/>
                <path fill="#34A853" d="M12 24c3.24 0 5.97-1.08 7.96-2.91l-3.86-3c-1.08.72-2.45 1.16-4.1 1.16-3.15 0-5.81-2.13-6.76-5.01H1.27v3.1A12 12 0 0 0 12 24z"/>
                <path fill="#FBBC05" d="M5.24 14.24a7.15 7.15 0 0 1 0-4.48V6.66H1.27a11.96 11.96 0 0 0 0 10.68l3.97-3.1z"/>
                <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.22 0 12 0A12 12 0 0 0 1.27 6.66l3.97 3.1c.95-2.88 3.61-5.01 6.76-5.01z"/>
              </svg>
              {{ $t('auth.login_google') }}
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useAuthStore } from '../../stores/auth'
import { useToastStore } from '../../stores/toast'
import { useI18n } from 'vue-i18n'

const authStore = useAuthStore()
const toastStore = useToastStore()
const { t } = useI18n()

const redirectToGoogle = () => {
  const backendUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8088'
  window.location.href = `${backendUrl}/oauth2/authorization/google`
}

// Props & emits
const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  initialTab: {
    type: String,
    default: 'login'
  }
})
const emit = defineEmits(['update:modelValue', 'login-success', 'register-success'])

// No watch or mounted hooks needed for OAuth2 direct redirect

// Tab state
const activeTab = ref('login')

watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    activeTab.value = props.initialTab || 'login'
  }
})

const switchTab = (tab) => {
  if (activeTab.value === tab) return
  loginError.value = ''
  registerError.value = ''
  forgotErrorMsg.value = ''
  forgotSuccessMsg.value = ''
  activeTab.value = tab
  if (tab === 'forgot') {
    forgotStep.value = 1
    forgotForm.value = { email: '', otp: '', newPassword: '', confirmPassword: '' }
  }
}

// Sliding tab indicator
const indicatorStyle = computed(() => ({
  transform: activeTab.value === 'login' ? 'translateX(0)' : 'translateX(100%)',
  width: 'calc(50% - 4px)'
}))

// Form state
const loginForm = ref({ email: '', password: '', remember: true })
const registerForm = ref({ fullName: '', email: '', password: '', confirmPassword: '' })

const showLoginPwd = ref(false)
const showRegPwd = ref(false)
const isLoading = ref(false)
const loginError = ref('')
const registerError = ref('')

const pwdMismatch = computed(() =>
    registerForm.value.confirmPassword.length > 0 &&
    registerForm.value.password !== registerForm.value.confirmPassword
)

// Forgot Password state & methods
import axios from '../../api/axios'

const forgotForm = ref({ email: '', otp: '', newPassword: '', confirmPassword: '' })
const forgotStep = ref(1)
const forgotSuccessMsg = ref('')
const forgotErrorMsg = ref('')

const forgotPwdMismatch = computed(() =>
    forgotForm.value.confirmPassword.length > 0 &&
    forgotForm.value.newPassword !== forgotForm.value.confirmPassword
)



const handleForgotPassword = async () => {
  if (isLoading.value) return
  forgotErrorMsg.value = ''
  forgotSuccessMsg.value = ''
  
  if (forgotStep.value === 1) {
    isLoading.value = true
    try {
      await axios.post(`/auth/forgot-password?email=${forgotForm.value.email}`)
      forgotSuccessMsg.value = t('auth.otp_sent_success')
      toastStore.success(forgotSuccessMsg.value)
      forgotStep.value = 2
    } catch (err) {
      const apiMsg = err.response?.data?.message
      if (apiMsg && apiMsg.includes('not found')) {
        forgotErrorMsg.value = t('auth.errors.email_not_found')
      } else {
        forgotErrorMsg.value = apiMsg || t('auth.errors.email_not_found')
      }
      toastStore.error(forgotErrorMsg.value)
    } finally {
      isLoading.value = false
    }
  } else {
    if (forgotPwdMismatch.value) return
    isLoading.value = true
    try {
      await axios.post('/auth/reset-password', {
        email: forgotForm.value.email,
        otp: forgotForm.value.otp,
        newPassword: forgotForm.value.newPassword
      })
      forgotSuccessMsg.value = t('auth.reset_pwd_success')
      toastStore.success(t('auth.reset_pwd_success_toast_msg'))
      setTimeout(() => {
        switchTab('login')
      }, 2000)
    } catch (err) {
      forgotErrorMsg.value = err.response?.data?.message || t('auth.reset_pwd_fail')
      toastStore.error(forgotErrorMsg.value)
    } finally {
      isLoading.value = false
    }
  }
}

const handleLogin = async () => {
  if (isLoading.value) return
  loginError.value = ''
  isLoading.value = true
  try {
    await authStore.login(loginForm.value.email, loginForm.value.password)
    toastStore.success(
      t('auth.login_success_toast_msg'),
      t('auth.login_success_toast_title', { name: authStore.user?.fullName || '' })
    )
    emit('login-success', authStore.user)
    emit('update:modelValue', false)
  } catch (err) {
    const apiMsg = err.response?.data?.message || err.response?.data?.error
    if (apiMsg === 'Bad credentials') {
      loginError.value = t('auth.errors.bad_credentials')
    } else {
      loginError.value = apiMsg || t('auth.errors.login_failed_unknown')
    }
    toastStore.error(loginError.value)
  } finally {
    isLoading.value = false
  }
}

const handleRegister = async () => {
  if (isLoading.value || pwdMismatch.value) return
  registerError.value = ''
  isLoading.value = true
  try {
    await authStore.register({
      fullName: registerForm.value.fullName,
      email: registerForm.value.email,
      password: registerForm.value.password
    })
    toastStore.success(t('auth.register_success_toast_msg'))
    emit('register-success')
    registerForm.value = { fullName: '', email: '', password: '', confirmPassword: '' }
    switchTab('login')
  } catch (err) {
    const apiMsg = err.response?.data?.message || err.response?.data?.error
    if (apiMsg && apiMsg.toLowerCase().includes('exist')) {
      registerError.value = t('auth.errors.register_failed_exists')
    } else {
      registerError.value = apiMsg || t('auth.errors.register_failed_unknown')
    }
    toastStore.error(registerError.value)
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
/* ── Backdrop ─────────────────────────────────────────── */
.auth-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  padding: 16px;
}

.backdrop-fade-enter-active,
.backdrop-fade-leave-active {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.backdrop-fade-enter-from,
.backdrop-fade-leave-to {
  opacity: 0;
}

/* ── Modal ───────────────────────────────────────────── */
.auth-modal {
  background: linear-gradient(135deg, #ffffff 0%, #fcfcff 50%, #f8fafc 100%);
  border-radius: 24px;
  padding: 20px 24px 20px;
  width: 100%;
  max-width: 440px;
  position: relative;
  box-shadow: 0 20px 40px -15px rgba(15, 23, 42, 0.15);
  border: 1px solid rgba(226, 232, 240, 0.8);
  max-height: 96vh;
  overflow-y: auto;
  overflow-x: hidden;
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
.tabs, .subtitle, .auth-form, .auth-divider, .google-login-container, .btn-close {
  position: relative;
  z-index: 1;
}

/* ── Close button ─────────────────────────────────────── */
.btn-close {
  position: absolute;
  top: 20px;
  right: 20px;
  background: #f1f5f9;
  border: none;
  border-radius: 50%;
  width: 34px;
  height: 34px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #64748b;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.btn-close:hover {
  background: #e2e8f0;
  color: #0f172a;
  transform: rotate(90deg);
}

/* ── Tabs (Pill Segmented Control) ─────────────────────── */
.tabs {
  display: flex;
  position: relative;
  background: #f1f5f9;
  padding: 4px;
  border-radius: 12px;
  margin-bottom: 12px;
  border: none;
}

.tab-btn {
  flex: 1;
  background: none;
  border: none;
  padding: 8px 0;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  color: #64748b;
  transition: color 0.25s ease;
  position: relative;
  z-index: 1;
}
.tab-btn.active {
  color: #0f172a;
}

.tab-indicator {
  position: absolute;
  top: 4px;
  bottom: 4px;
  left: 4px;
  background: #ffffff;
  border-radius: 9px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: transform 0.28s cubic-bezier(0.4, 0, 0.2, 1);
}

/* ── Subtitle ─────────────────────────────────────────── */
.subtitle {
  font-size: 13px;
  color: #475569;
  margin-bottom: 8px;
  min-height: 18px;
  line-height: 1.4;
  font-weight: 500;
}

.text-swap-enter-active,
.text-swap-leave-active {
  transition: opacity 0.18s ease, transform 0.18s ease;
}
.text-swap-enter-from { opacity: 0; transform: translateY(6px); }
.text-swap-leave-to   { opacity: 0; transform: translateY(-6px); }

/* ── Form slide transition ────────────────────────────── */
.form-slide-enter-active,
.form-slide-leave-active {
  transition: opacity 0.22s ease, transform 0.22s ease;
}
.form-slide-enter-from { opacity: 0; transform: translateX(18px); }
.form-slide-leave-to   { opacity: 0; transform: translateX(-18px); }

/* ── Fields ───────────────────────────────────────────── */
.auth-form { display: flex; flex-direction: column; gap: 10px; }

.field-group { display: flex; flex-direction: column; gap: 4px; }

.field-group label {
  font-size: 10.5px;
  font-weight: 700;
  letter-spacing: 0.05em;
  color: #64748b;
}

.input-wrap {
  display: flex;
  align-items: center;
  border: 1px solid #cbd5e1;
  border-radius: 12px;
  padding: 0 14px;
  height: 42px;
  gap: 10px;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  background: #ffffff;
}
.input-wrap:focus-within {
  border-color: #3b82f6;
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
  background: #ffffff;
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
  transition: color 0.2s;
}
.input-wrap:focus-within .icon {
  color: #3b82f6;
}

.input-wrap input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 14.5px;
  color: #0f172a;
  outline: none;
  font-weight: 500;
}
.input-wrap input::placeholder { color: #94a3b8; }

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
.eye-btn:hover { color: #475569; }

.field-error {
  font-size: 12px;
  color: #ef4444;
  margin-top: 2px;
  font-weight: 500;
}

/* ── Remember row ─────────────────────────────────────── */
.remember-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 2px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13.5px;
  color: #475569;
  cursor: pointer;
  user-select: none;
}

.checkbox-label input[type="checkbox"] {
  appearance: none;
  width: 18px;
  height: 18px;
  border: 1.5px solid #cbd5e1;
  border-radius: 5px;
  cursor: pointer;
  position: relative;
  transition: all 0.2s;
  flex-shrink: 0;
}
.checkbox-label input[type="checkbox"]:checked {
  background: #3b82f6;
  border-color: #3b82f6;
}
.checkbox-label input[type="checkbox"]:checked::after {
  content: '';
  position: absolute;
  left: 5px;
  top: 2px;
  width: 5px;
  height: 9px;
  border-right: 2px solid #ffffff;
  border-bottom: 2px solid #ffffff;
  transform: rotate(45deg);
}

.forgot-link {
  font-size: 13.5px;
  color: #3b82f6;
  text-decoration: none;
  font-weight: 600;
}
.forgot-link:hover { text-decoration: underline; }

/* ── Error message ────────────────────────────────────── */
.error-msg {
  background: #fef2f2;
  border: 1px solid #fee2e2;
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 13px;
  color: #b91c1c;
  font-weight: 500;
}

.error-fade-enter-active,
.error-fade-leave-active { transition: opacity 0.2s ease, transform 0.2s ease; }
.error-fade-enter-from   { opacity: 0; transform: translateY(-4px); }
.error-fade-leave-to     { opacity: 0; }

/* ── Primary button ───────────────────────────────────── */
.btn-primary {
  background: linear-gradient(135deg, #1a6cf7, #1558d6);
  color: #ffffff;
  border: none;
  border-radius: 12px;
  height: 42px;
  font-size: 14.5px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s ease;
  box-shadow: 0 4px 12px rgba(26, 108, 247, 0.25);
  margin-top: 4px;
}
.btn-primary:hover  {
  background: linear-gradient(135deg, #2c7bf9, #175ee3);
  box-shadow: 0 6px 20px rgba(26, 108, 247, 0.35);
  transform: translateY(-1px);
}
.btn-primary:active { transform: translateY(1px); }
.btn-primary.loading { pointer-events: none; opacity: 0.8; }

.spinner {
  width: 20px;
  height: 20px;
  border: 2.5px solid rgba(255,255,255,0.4);
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
  display: inline-block;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Switch text ──────────────────────────────────────── */
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
.switch-text a:hover { text-decoration: underline; }

/* ── Demo box ─────────────────────────────────────────── */
.demo-box {
  background: #f0f7ff;
  border: 1px solid #dbeafe;
  border-radius: 12px;
  padding: 8px 12px;
  font-size: 12px;
  color: #1e40af;
  line-height: 1.6;
  text-align: center;
  margin-top: 8px;
}
.demo-box strong { color: #1a6cf7; }

/* ── Scrollbar ────────────────────────────────────────── */
.auth-modal::-webkit-scrollbar { width: 4px; }
.auth-modal::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }

/* ── Auth Divider ─────────────────────────────────────── */
.auth-divider {
  display: flex;
  align-items: center;
  text-align: center;
  margin: 10px 0 6px 0;
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

/* ── Google Login Container ───────────────────────────── */
.google-login-container {
  display: flex;
  justify-content: center;
  width: 100%;
  margin-top: 4px;
}

.btn-google {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  width: 100%;
  height: 42px;
  background: #ffffff;
  border: 1.5px solid #cbd5e1;
  border-radius: 12px;
  color: #334155;
  font-size: 14px;
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

.host-cta-box {
  background: linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%);
  border: 1px solid rgba(59, 130, 246, 0.15);
  border-radius: 12px;
  padding: 10px 12px;
  text-align: center;
  font-size: 12.5px;
  color: #334155;
  margin-top: 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
}
.host-cta-box span {
  color: #475569;
  font-weight: 500;
}
.host-cta-box a {
  color: #2563eb;
  font-weight: 700;
  text-decoration: none;
  transition: color 0.2s;
}
.host-cta-box a:hover {
  color: #1d4ed8;
  text-decoration: underline;
}

.success-msg {
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 13px;
  color: #15803d;
  font-weight: 500;
  text-align: center;
}


</style>