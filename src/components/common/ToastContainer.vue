<template>
  <div class="toast-container">
    <TransitionGroup name="toast-slide">
      <div 
        v-for="toast in toastStore.toasts" 
        :key="toast.id" 
        class="toast-card" 
        :class="toast.type"
      >
        <!-- Icon -->
        <div class="toast-icon-wrap">
          <CheckCircle v-if="toast.type === 'success'" :size="20" class="icon-success" />
          <XCircle v-else-if="toast.type === 'error'" :size="20" class="icon-error" />
          <AlertTriangle v-else-if="toast.type === 'warning'" :size="20" class="icon-warning" />
          <Info v-else :size="20" class="icon-info" />
        </div>

        <!-- Content -->
        <div class="toast-body">
          <h4 class="toast-title">{{ toast.title }}</h4>
          <p class="toast-msg">{{ toast.message }}</p>
        </div>

        <!-- Close Button -->
        <button class="btn-toast-close" @click="toastStore.remove(toast.id)">
          <X :size="16" />
        </button>
      </div>
    </TransitionGroup>
  </div>
</template>

<script setup>
import { useToastStore } from '../../stores/toast'
import { CheckCircle, XCircle, AlertTriangle, Info, X } from 'lucide-vue-next'

const toastStore = useToastStore()
</script>

<style scoped>
.toast-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 99999;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 380px;
  width: calc(100vw - 40px);
  pointer-events: none;
}

.toast-card {
  pointer-events: auto;
  display: flex;
  align-items: flex-start;
  padding: 14px 16px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(226, 232, 240, 0.8);
  box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.1), 0 8px 16px -6px rgba(15, 23, 42, 0.05);
  position: relative;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  overflow: hidden;
}

/* Subtle type indicator border */
.toast-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  border-radius: 4px 0 0 4px;
}

/* Success Styling */
.toast-card.success {
  border-color: rgba(187, 247, 208, 0.7);
}
.toast-card.success::before {
  background: #10b981;
}
.icon-success {
  color: #10b981;
}

/* Error Styling */
.toast-card.error {
  border-color: rgba(254, 202, 202, 0.7);
}
.toast-card.error::before {
  background: #ef4444;
}
.icon-error {
  color: #ef4444;
}

/* Warning Styling */
.toast-card.warning {
  border-color: rgba(253, 230, 138, 0.7);
}
.toast-card.warning::before {
  background: #f59e0b;
}
.icon-warning {
  color: #f59e0b;
}

/* Info Styling */
.toast-card.info {
  border-color: rgba(191, 219, 254, 0.7);
}
.toast-card.info::before {
  background: #3b82f6;
}
.icon-info {
  color: #3b82f6;
}

/* Icon placement */
.toast-icon-wrap {
  flex-shrink: 0;
  margin-right: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 20px;
}

/* Body / Text */
.toast-body {
  flex: 1;
  margin-right: 18px;
}

.toast-title {
  font-size: 13.5px;
  font-weight: 700;
  color: #0f172a;
  margin: 0 0 3px 0;
  line-height: 1.3;
}

.toast-msg {
  font-size: 12.5px;
  color: #475569;
  margin: 0;
  line-height: 1.4;
  font-weight: 500;
}

/* Close button */
.btn-toast-close {
  background: transparent;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  padding: 4px;
  margin: -4px -4px 0 0;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.btn-toast-close:hover {
  background: #f1f5f9;
  color: #475569;
}

/* Vue Slide Transitions */
.toast-slide-enter-from {
  opacity: 0;
  transform: translateX(100px) scale(0.9);
}
.toast-slide-leave-to {
  opacity: 0;
  transform: translateX(100px) scale(0.9);
}
.toast-slide-enter-active,
.toast-slide-leave-active {
  transition: all 0.35s cubic-bezier(0.23, 1, 0.32, 1);
}
.toast-slide-leave-active {
  position: absolute;
}
</style>
