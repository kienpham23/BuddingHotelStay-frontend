import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useToastStore = defineStore('toast', () => {
  const toasts = ref([])

  const add = ({ title = '', message = '', type = 'info', duration = 4000 }) => {
    const id = Date.now() + Math.random().toString(36).substr(2, 9)
    toasts.value.push({ id, title, message, type, duration })

    setTimeout(() => {
      remove(id)
    }, duration)
  }

  const remove = (id) => {
    toasts.value = toasts.value.filter(t => t.id !== id)
  }

  const success = (message, title = 'Thành công') => add({ title, message, type: 'success' })
  const error = (message, title = 'Lỗi') => add({ title, message, type: 'error' })
  const warning = (message, title = 'Cảnh báo') => add({ title, message, type: 'warning' })
  const info = (message, title = 'Thông tin') => add({ title, message, type: 'info' })

  return {
    toasts,
    add,
    remove,
    success,
    error,
    warning,
    info
  }
})
