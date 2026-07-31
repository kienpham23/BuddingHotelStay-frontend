<template>
  <RouterView />
  <ChatWidget />
  <ToastContainer />
</template>

<script setup>
import { RouterView } from 'vue-router'
import ChatWidget from './components/ChatWidget.vue'
import ToastContainer from './components/common/ToastContainer.vue'
</script>

<style>
html, body {
  margin: 0;
  padding: 0;
}

.header-lang-selector-dropdown {
  position: relative;
  display: inline-block;
  align-self: center;
  margin-right: 12px;
}

.lang-dropdown-btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background: rgba(241, 245, 249, 0.85);
  border: 1px solid rgba(226, 232, 240, 0.8);
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 14.5px;
  font-weight: 600;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
}

.lang-dropdown-btn:hover {
  background: rgba(226, 232, 240, 0.9);
  border-color: rgba(203, 213, 225, 0.9);
}

.flag-icon {
  display: inline-flex;
  align-items: center;
  border-radius: 2px;
  overflow: hidden;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.flag-icon svg {
  width: 22px !important;
  height: auto !important;
}

.lang-text-active {
  font-size: 13.5px;
  font-weight: 700;
  color: #475569;
}

.dropdown-chevron {
  font-size: 10px;
  color: #94a3b8;
  transition: transform 0.2s;
}

.header-lang-selector-dropdown:hover .dropdown-chevron {
  transform: rotate(180deg);
}

.lang-dropdown-menu {
  display: none;
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 8px;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
  z-index: 100000;
  min-width: 150px;
  padding: 8px;
}

.header-lang-selector-dropdown:hover .lang-dropdown-menu {
  display: block;
}

.lang-dropdown-item {
  width: 100%;
  display: flex;
  align-items: center;
  padding: 10px 14px;
  background: none;
  border: none;
  font-size: 13.5px;
  font-weight: 600;
  color: #475569;
  cursor: pointer;
  text-align: left;
  border-radius: 8px;
  transition: all 0.15s ease;
}

.lang-dropdown-item svg {
  width: 20px !important;
  height: auto !important;
  margin-right: 10px !important;
}

.lang-dropdown-item:hover {
  background: #f1f5f9;
  color: #0f172a;
}

.lang-dropdown-item.active {
  background: #eff6ff;
  color: #1d4ed8;
}
</style>