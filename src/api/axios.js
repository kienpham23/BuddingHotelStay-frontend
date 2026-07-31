import axios from 'axios'

const instance = axios.create({
    baseURL: `${import.meta.env.VITE_API_BASE_URL || 'http://localhost:8088'}/api`,
    timeout: 10000,
})

// Tự động đính kèm token vào mỗi request
instance.interceptors.request.use(
    (config) => {
        config.headers['ngrok-skip-browser-warning'] = 'true'
        const token = localStorage.getItem('token')
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }
        return config
    },
    (error) => Promise.reject(error)
)

// Tự động redirect về login nếu token hết hạn (401)
instance.interceptors.response.use(
    (response) => response,
    (error) => {
        const isAuthRequest = error.config?.url?.includes('/auth/')
        if (error.response?.status === 401 && !isAuthRequest) {
            localStorage.removeItem('token')
            localStorage.removeItem('role')
            localStorage.removeItem('user')
            window.location.href = '/login'
        }
        return Promise.reject(error)
    }
)

export default instance