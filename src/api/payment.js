import axios from './axios'

/**
 * Gọi backend tạo URL thanh toán VNPay
 * POST /api/payment/vnpay/create?bookingId=:bookingId
 * @returns { paymentUrl: string }
 */
export const createVNPayUrl = (bookingId, locale = 'vi') => {
    return axios.post('/payment/vnpay/create', null, {
        params: { bookingId, locale }
    })
}

/**
 * Gửi các query params VNPay redirect về cho backend xác minh chữ ký
 * GET /api/payment/vnpay/callback?vnp_*=...
 * @param {Object} params - toàn bộ query string từ URL callback
 * @returns { status: 'SUCCESS'|'FAILED', message: string, bookingId: string }
 */
export const verifyVNPayCallback = (params) => {
    return axios.get('/payment/vnpay/callback', { params })
}

/**
 * Gọi backend tạo URL thanh toán MoMo
 * POST /api/payment/momo/create?bookingId=:bookingId
 * @returns { paymentUrl: string }
 */
export const createMoMoUrl = (bookingId) => {
    return axios.post('/payment/momo/create', null, {
        params: { bookingId }
    })
}
