import axios from './axios'

/**
 * Host lấy danh sách hóa đơn công nợ hoa hồng của mình
 * GET /api/invoices/my-invoices
 */
export const getMyInvoices = () => {
  return axios.get('/invoices/my-invoices')
}

/**
 * Host yêu cầu tạo link thanh toán hóa đơn VNPay
 * POST /api/invoices/:id/pay
 */
export const payInvoice = (invoiceId, locale = 'vi') => {
  return axios.post(`/invoices/${invoiceId}/pay`, null, {
    params: { locale }
  })
}

/**
 * Admin lấy danh sách toàn bộ hóa đơn công nợ
 * GET /api/admin/invoices
 */
export const getAllInvoicesAdmin = () => {
  return axios.get('/admin/invoices')
}

/**
 * Admin yêu cầu chốt hóa đơn công nợ cho các Host tính đến ngày endDate
 * POST /api/admin/invoices/generate?endDate=YYYY-MM-DD
 */
export const generateInvoicesAdmin = (endDate) => {
  return axios.post('/admin/invoices/generate', null, {
    params: { endDate }
  })
}
