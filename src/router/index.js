import { createRouter, createWebHistory } from 'vue-router'

const routes = [
    { path: '/',            component: () => import('../views/HomeView.vue') },
    { path: '/login',       component: () => import('../views/LoginView.vue') },
    { path: '/register',    component: () => import('../views/RegisterView.vue') },
    { path: '/rooms/:id',   component: () => import('../views/RoomDetailView.vue') },
    { path: '/deals',       component: () => import('../views/DealsView.vue') },

    {
        path: '/host/rooms',
        component: () => import('../views/host/HostRoomsView.vue'),
        meta: { requiresAuth: true, role: 'HOST' }
    },
    {
        path: '/host/revenue',
        component: () => import('../views/host/HostRevenueView.vue'),
        meta: { requiresAuth: true, role: 'HOST' }
    },
    {
        path: '/host/register',
        name: 'host-register',
        component: () => import('../views/host/HostRegisterView.vue')
    },
    {
        path: '/admin',
        component: () => import('../views/admin/AdminView.vue'),
        meta: { requiresAuth: true, role: 'ADMIN' }
    },
    {
        path: '/admin/revenue',
        component: () => import('../views/admin/AdminRevenueView.vue'),
        meta: { requiresAuth: true, role: 'ADMIN' }
    },
    {
        path: '/admin/promotions',
        component: () => import('../views/admin/AdminPromotionsView.vue'),
        meta: { requiresAuth: true, role: 'ADMIN' }
    },
    {
        path: '/bookings',
        component: () => import('../views/MyBookingsView.vue'),
        meta: { requiresAuth: true, role: 'CUSTOMER' }
    },
    {
        path: '/payment',
        name: 'payment',
        component: () => import('../views/PaymentView.vue'),
        meta: { requiresAuth: true }, // nếu bạn có auth guard
    },
    {
        // Không cần requiresAuth: MoMo redirect thẳng vào đây,
        // token có thể đã hết hạn khi khách quay lại từ cổng thanh toán.
        path: '/payment-result',
        name: 'payment-result',
        component: () => import('../views/PaymentResultView.vue')
    },
    {
        path: '/oauth2/callback',
        name: 'oauth2-callback',
        component: () => import('../views/OAuth2Callback.vue')
    },
    {
        path: '/oauth2/redirect',
        name: 'oauth2-redirect',
        component: () => import('../views/OAuth2Callback.vue')
    },
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

// Guard kiểm tra auth
router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')
    const role = localStorage.getItem('role')

    if (token) {
        if (role === 'ADMIN') {
            const isAdminRoute = to.path.startsWith('/admin')
            const isOauthRoute = to.path.startsWith('/oauth2')
            if (!isAdminRoute && !isOauthRoute) {
                return next('/admin')
            }
        } else if (role === 'HOST') {
            const isHostRoute = to.path.startsWith('/host')
            const isOauthRoute = to.path.startsWith('/oauth2')
            if (!isHostRoute && !isOauthRoute) {
                return next('/host/rooms')
            }
        }
    }

    if (to.meta.requiresAuth && !token) {
        next('/login')
    } else if (to.meta.role && to.meta.role !== role) {
        if (role === 'ADMIN') {
            next('/admin')
        } else if (role === 'HOST') {
            next('/host/rooms')
        } else {
            next('/')
        }
    } else {
        next()
    }
})

export default router