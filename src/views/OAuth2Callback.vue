<template>
  <div class="redirect-container">
    <div class="loader-box">
      <div class="spinner"></div>
      <p class="message">Đang xử lý đăng nhập bằng Google...</p>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

onMounted(() => {
  const token = route.query.token
  const id = route.query.id
  const email = route.query.email
  const fullName = route.query.fullName
  const role = route.query.role

  if (token) {
    // Lưu thông tin đăng nhập vào Pinia Store và localStorage
    authStore.setUser({
      token,
      user: {
        id: id || null,
        email: email || '',
        fullName: fullName || '',
        role: role || 'CUSTOMER'
      }
    })

    // Điều hướng dựa trên vai trò của người dùng
    if (role === 'ADMIN') {
      router.push('/admin')
    } else if (role === 'HOST') {
      router.push('/host/rooms')
    } else {
      router.push('/')
    }
  } else {
    // Nếu không có token, điều hướng về trang đăng nhập thông thường
    router.push('/login')
  }
})
</script>

<style scoped>
.redirect-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: #f8fafc;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.loader-box {
  text-align: center;
  background: #ffffff;
  padding: 40px 48px;
  border-radius: 24px;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
  border: 1px solid #e2e8f0;
}

.spinner {
  width: 48px;
  height: 48px;
  border: 4px solid #f1f5f9;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

.message {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
