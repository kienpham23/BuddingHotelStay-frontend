import axios from './axios'

/**
 * Lấy thông tin cá nhân của người dùng hiện tại
 * GET /api/users/profile
 */
export const getProfile = () => {
  return axios.get('/users/profile')
}

/**
 * Cập nhật thông tin cá nhân
 * PUT /api/users/profile
 */
export const updateProfile = (data) => {
  return axios.put('/users/profile', data)
}

/**
 * Đổi mật khẩu
 * PUT /api/users/change-password
 */
export const changePassword = (data) => {
  return axios.put('/users/change-password', data)
}
