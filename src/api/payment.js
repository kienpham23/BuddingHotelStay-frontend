import axios from './axios'

/**
 * Gọi backend tạo URL thanh toán VNPay
 * POST /api/payments/vnpay/create?bookingId=:bookingId
 * @returns { paymentUrl: string }
 */
export const createVNPayUrl = (bookingId, locale = 'vi') => {
    return axios.post('/payments/vnpay/create', null, {
        params: { bookingId, locale }
    })
}

/**
 * Gửi các query params VNPay redirect về cho backend xác minh chữ ký
 * GET /api/payments/vnpay/callback?vnp_*=...
 * @param {Object} params - toàn bộ query string từ URL callback
 * @returns { status: 'SUCCESS'|'FAILED', message: string, bookingId: string }
 */
export const verifyVNPayCallback = (params) => {
    return axios.get('/payments/vnpay/callback', { params })
}

/**
 * Gọi backend tạo URL thanh toán MoMo
 * POST /api/payments/momo/create?bookingId=:bookingId
 * @returns { paymentUrl: string }
 */
export const createMoMoUrl = (bookingId) => {
    return axios.post('/payments/momo/create', null, {
        params: { bookingId }
    })
}

/**
 * Gửi các query params MoMo redirect về cho backend xác minh chữ ký và giao dịch
 * GET /api/payments/momo/callback?partnerCode=...&orderId=...
 * @param {Object} params - toàn bộ query string từ URL callback
 * @returns {Object} response dữ liệu xác thực
 */
export const verifyMoMoCallback = (params) => {
    return axios.get('/payments/momo/callback', { params })
}
