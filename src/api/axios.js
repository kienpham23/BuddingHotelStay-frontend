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

// Tự động redirect về login nếu token hết hạn (401) và chuyển đổi localhost url sang base url cấu hình
instance.interceptors.response.use(
    (response) => {
        const backendUrl = import.meta.env.VITE_API_BASE_URL
        if (backendUrl && response.data && !(response.data instanceof Blob)) {
            const replaceLocalhost = (obj) => {
                if (typeof obj === 'string') {
                    return obj.replaceAll('http://localhost:8088', backendUrl)
                } else if (Array.isArray(obj)) {
                    return obj.map(replaceLocalhost)
                } else if (obj !== null && typeof obj === 'object') {
                    for (const key in obj) {
                        obj[key] = replaceLocalhost(obj[key])
                    }
                }
                return obj
            }
            response.data = replaceLocalhost(response.data)
        }
        return response
    },
    (error) => {
        const isAuthRequest = error.config?.url?.includes('/auth/')
        if ((error.response?.status === 401 || error.response?.status === 403) && !isAuthRequest) {
            localStorage.removeItem('token')
            localStorage.removeItem('role')
            localStorage.removeItem('user')
            window.location.href = '/login'
        }
        return Promise.reject(error)
    }
)

export default instance