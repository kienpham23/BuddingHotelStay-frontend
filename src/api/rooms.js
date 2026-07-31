import axios from './axios'

export const getRooms = (params) => {
    return axios.get('/rooms', { params })
}

export const getRoomDetail = (id) => {
    return axios.get(`/rooms/${id}`)
}
