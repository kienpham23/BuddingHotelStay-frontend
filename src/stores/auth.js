import { defineStore } from 'pinia'
import axios from '../api/axios'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || null,
        user: JSON.parse(localStorage.getItem('user') || 'null'),
    }),

    getters: {
        isLoggedIn: state => !!state.token,
        role: state => state.user?.role || null,
    },

    actions: {
        async login(email, password) {
            const res = await axios.post('/auth/login', { email, password })
            this.token = res.data.token
            this.user = {
                id: res.data.id ?? res.data.user?.id,
                email: res.data.email ?? res.data.user?.email,
                fullName: res.data.fullName ?? res.data.user?.fullName,
                role: res.data.role ?? res.data.user?.role,
            }
            localStorage.setItem('token', this.token)
            localStorage.setItem('role', this.user.role)
            localStorage.setItem('user', JSON.stringify(this.user))
        },

        async loginWithGoogle(credential) {
            const res = await axios.post('/auth/google', { token: credential })
            this.token = res.data.token
            this.user = {
                id: res.data.id ?? res.data.user?.id,
                email: res.data.email ?? res.data.user?.email,
                fullName: res.data.fullName ?? res.data.user?.fullName,
                role: res.data.role ?? res.data.user?.role,
            }
            localStorage.setItem('token', this.token)
            localStorage.setItem('role', this.user.role)
            localStorage.setItem('user', JSON.stringify(this.user))
        },

        async register(data) {
            const res = await axios.post('/auth/register', data)
            this.token = res.data.token
            this.user = {
                id: res.data.id ?? res.data.user?.id,
                email: res.data.email ?? res.data.user?.email,
                fullName: res.data.fullName ?? res.data.user?.fullName,
                role: res.data.role ?? res.data.user?.role,
            }
            localStorage.setItem('token', this.token)
            localStorage.setItem('role', this.user.role)
            localStorage.setItem('user', JSON.stringify(this.user))
        },

        setUser(userData) {
            if (!userData) return
            const token = userData.token || userData.accessToken
            if (token) {
                this.token = token
                localStorage.setItem('token', token)
            }
            const userObj = userData.user || userData
            if (userObj && (userObj.id || userObj.email || userObj.fullName || userObj.role)) {
                this.user = {
                    id: userObj.id || null,
                    email: userObj.email || '',
                    fullName: userObj.fullName || '',
                    role: userObj.role || 'CUSTOMER',
                }
                localStorage.setItem('role', this.user.role)
                localStorage.setItem('user', JSON.stringify(this.user))
            }
        },

        logout() {
            this.token = null
            this.user = null
            localStorage.removeItem('token')
            localStorage.removeItem('role')
            localStorage.removeItem('user')
        }
    }
})