<template>
  <div class="min-h-screen" style="background:#f8f7f9; font-family: 'Inter', sans-serif; color: var(--dark);">
    <!-- HEADER -->
    <header class="header">
      <div class="container">
        <div class="header-left">
          <RouterLink to="/host/rooms" class="logo">
            <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="22" height="22" style="width: 22px; height: 22px; flex-shrink: 0; margin-right: 6px;">
              <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="logo-word building">Building</span>
            <span class="logo-word hotel">Hotel</span>
            <span class="logo-word stay">Stay</span>
          </RouterLink>
          <span class="divider">/</span>
          <span class="panel-tag">{{ $t('host.sidebar.revenue') }}</span>
        </div>
        <div class="header-right" style="display: flex; align-items: center; gap: 12px;">
          <!-- Language Selector -->
          <div class="header-lang-selector-dropdown">
            <button type="button" class="lang-dropdown-btn">
              <span class="flag-icon">
                <svg v-if="locale === 'vi'" viewBox="0 0 30 20" width="18" height="12">
                  <rect width="30" height="20" fill="#da251d"/>
                  <polygon points="15,4 16.2,8.2 20.6,8.2 17.1,10.8 18.4,15 15,12.4 11.6,15 12.9,10.8 9.4,8.2 13.8,8.2" fill="#ffff00"/>
                </svg>
                <svg v-else viewBox="0 0 74 39" width="18" height="9.5">
                  <rect width="74" height="39" fill="#bb133e"/>
                  <path d="M0,3 H74 M0,9 H74 M0,15 H74 M0,21 H74 M0,27 H74 M0,33 H74" stroke="#fff" stroke-width="3"/>
                  <rect width="30" height="21" fill="#002147"/>
                  <circle cx="6" cy="5" r="1" fill="#fff"/>
                  <circle cx="15" cy="5" r="1" fill="#fff"/>
                  <circle cx="24" cy="5" r="1" fill="#fff"/>
                  <circle cx="10.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="19.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="6" cy="16" r="1" fill="#fff"/>
                  <circle cx="15" cy="16" r="1" fill="#fff"/>
                  <circle cx="24" cy="16" r="1" fill="#fff"/>
                </svg>
              </span>
              <span class="lang-text-active">{{ locale === 'vi' ? 'Tiếng Việt' : 'English' }}</span>
              <span class="dropdown-chevron">▼</span>
            </button>
            <div class="lang-dropdown-menu">
              <button type="button" class="lang-dropdown-item" :class="{ active: locale === 'vi' }" @click="changeLanguage('vi')">
                <svg viewBox="0 0 30 20" width="16" height="10.7" style="margin-right: 8px;">
                  <rect width="30" height="20" fill="#da251d"/>
                  <polygon points="15,4 16.2,8.2 20.6,8.2 17.1,10.8 18.4,15 15,12.4 11.6,15 12.9,10.8 9.4,8.2 13.8,8.2" fill="#ffff00"/>
                </svg>
                Tiếng Việt
              </button>
              <button type="button" class="lang-dropdown-item" :class="{ active: locale === 'en' }" @click="changeLanguage('en')">
                <svg viewBox="0 0 74 39" width="16" height="8.4" style="margin-right: 8px;">
                  <rect width="74" height="39" fill="#bb133e"/>
                  <path d="M0,3 H74 M0,9 H74 M0,15 H74 M0,21 H74 M0,27 H74 M0,33 H74" stroke="#fff" stroke-width="3"/>
                  <rect width="30" height="21" fill="#002147"/>
                  <circle cx="6" cy="5" r="1" fill="#fff"/>
                  <circle cx="15" cy="5" r="1" fill="#fff"/>
                  <circle cx="24" cy="5" r="1" fill="#fff"/>
                  <circle cx="10.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="19.5" cy="10.5" r="1" fill="#fff"/>
                  <circle cx="6" cy="16" r="1" fill="#fff"/>
                  <circle cx="15" cy="16" r="1" fill="#fff"/>
                  <circle cx="24" cy="16" r="1" fill="#fff"/>
                </svg>
                English
              </button>
            </div>
          </div>
          <RouterLink to="/host/rooms" class="btn-back-nav">← {{ $t('host.revenue.back_to_rooms') }}</RouterLink>
          <span class="user-name" v-if="authStore.isLoggedIn">{{ authStore.user?.fullName }}</span>
          <button class="btn-outline" @click="handleLogout">{{ $t('host.sidebar.logout') }}</button>
        </div>
      </div>
    </header>

    <main class="container main-content">
      <!-- TITLE AND FILTER ROW -->
      <div class="title-row" style="align-items: flex-end;">
        <div class="title-info">
          <h1>{{ $t('host.revenue.analysis_title') }}</h1>
          <p class="subtitle">{{ $t('host.revenue.analysis_subtitle') }}</p>
        </div>
        <div class="filter-box-row" style="display: flex; gap: 16px; align-items: center; flex-wrap: wrap;">
          <!-- Filter Mode Selector -->
          <div class="filter-box">
            <label for="mode-select" style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Kiểu báo cáo' : 'Report Type' }}</label>
            <select id="mode-select" v-model="filterMode" @change="handleModeChange" class="select-input" style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-weight: 600; color: #334155;">
              <option value="ALL_TIME">{{ locale === 'vi' ? 'Từ trước đến nay' : 'All-time' }}</option>
              <option value="BY_YEAR">{{ locale === 'vi' ? 'Theo năm' : 'By Year' }}</option>
              <option value="BY_QUARTER">{{ locale === 'vi' ? 'Theo quý' : 'By Quarter' }}</option>
              <option value="CUSTOM_RANGE">{{ locale === 'vi' ? 'Khoảng thời gian tùy chọn' : 'Custom Range' }}</option>
            </select>
          </div>

          <!-- Year Selector (visible if mode is BY_YEAR) -->
          <div class="filter-box" v-if="filterMode === 'BY_YEAR'">
            <label for="year-select" style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ $t('host.revenue.year_select') }}</label>
            <select id="year-select" v-model="selectedYear" @change="fetchRevenueData" class="select-input" style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-weight: 600; color: #334155;">
              <option v-for="year in availableYears" :key="year" :value="year">{{ $t('host.revenue.year_format', { year: year }) }}</option>
            </select>
          </div>

          <!-- Quarter Selector (visible if mode is BY_QUARTER) -->
          <div class="filter-box" v-if="filterMode === 'BY_QUARTER'" style="display: flex; gap: 8px;">
            <div>
              <label for="quarter-year-select" style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ $t('host.revenue.year_select') }}</label>
              <select id="quarter-year-select" v-model="selectedYear" @change="fetchRevenueData" class="select-input" style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-weight: 600; color: #334155;">
                <option v-for="year in availableYears" :key="year" :value="year">{{ $t('host.revenue.year_format', { year: year }) }}</option>
              </select>
            </div>
            <div>
              <label for="quarter-select" style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Chọn Quý' : 'Select Quarter' }}</label>
              <select id="quarter-select" v-model="selectedQuarter" @change="fetchRevenueData" class="select-input" style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-weight: 600; color: #334155;">
                <option value="1">{{ locale === 'vi' ? 'Quý 1 (T1 - T3)' : 'Q1 (Jan - Mar)' }}</option>
                <option value="2">{{ locale === 'vi' ? 'Quý 2 (T4 - T6)' : 'Q2 (Apr - Jun)' }}</option>
                <option value="3">{{ locale === 'vi' ? 'Quý 3 (T7 - T9)' : 'Q3 (Jul - Sep)' }}</option>
                <option value="4">{{ locale === 'vi' ? 'Quý 4 (T10 - T12)' : 'Q4 (Oct - Dec)' }}</option>
              </select>
            </div>
          </div>

          <!-- Custom Date Range (visible if mode is CUSTOM_RANGE) -->
          <div class="filter-box" v-if="filterMode === 'CUSTOM_RANGE'" style="display: flex; gap: 12px; align-items: center;">
            <div>
              <label for="start-date" style="display: block; margin-bottom: 4px; font-size: 11px; font-weight: 600; color: #64748b;">{{ locale === 'vi' ? 'Từ ngày' : 'Start Date' }}</label>
              <input type="date" id="start-date" v-model="customStartDate" @change="fetchRevenueData" class="date-input-sm" style="padding: 6px 10px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; color: #334155; font-weight: 600;" />
            </div>
            <div>
              <label for="end-date" style="display: block; margin-bottom: 4px; font-size: 11px; font-weight: 600; color: #64748b;">{{ locale === 'vi' ? 'Đến ngày' : 'End Date' }}</label>
              <input type="date" id="end-date" v-model="customEndDate" @change="fetchRevenueData" class="date-input-sm" style="padding: 6px 10px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; color: #334155; font-weight: 600;" />
            </div>
          </div>

          <!-- Export Button -->
          <div class="filter-box" style="align-self: flex-end;">
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: transparent; user-select: none;">Export</label>
            <button 
              type="button" 
              class="btn-primary" 
              style="padding: 7px 16px; border-radius: 8px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; cursor: pointer; height: 38px; background: #22c55e; border: none; color: white;"
              @click="exportToExcel"
            >
              <Download :size="16" />
              {{ locale === 'vi' ? 'Xuất Excel Doanh Thu' : 'Export Excel' }}
            </button>
          </div>
        </div>
      </div>

      <!-- LOADING STATE -->
      <div v-if="loading" class="loading-state">
        <div class="spinner-large"></div>
        <p>{{ $t('host.revenue.loading_alt') }}</p>
      </div>

      <!-- ERROR STATE -->
      <div v-else-if="error" class="error-state">
        <p class="error-msg">{{ error }}</p>
        <button class="btn-primary" @click="fetchRevenueData">Thử lại</button>
      </div>

      <!-- CONTENT STATE -->
      <div v-else-if="data" class="dashboard-content">
        <!-- 4 CARDS STATS (HOST EXCLUDES USERS/HOST COUNTS) -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon rev-color"><DollarSign :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('host.revenue.gross_revenue') }}</h4>
              <span class="stat-val">{{ formatPrice(data.totalRevenue) }}</span>
            </div>
          </div>
          <div class="stat-card host-net-card">
            <div class="stat-icon net-color"><Wallet :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('host.revenue.net_revenue') }}</h4>
              <span class="stat-val highlight-green">{{ formatPrice(data.totalHostEarning) }}</span>
              <small class="stat-sub">{{ $t('host.revenue.commission_deduction', { percent: getCommissionPercentage }) }}</small>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon booking-color"><FileText :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('host.revenue.total_bookings') }}</h4>
              <span class="stat-val">{{ $t('host.revenue.bookings_unit', { count: data.totalBookings }) }}</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon room-color"><Hotel :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('host.revenue.total_rooms') }}</h4>
              <span class="stat-val">{{ $t('host.revenue.rooms_unit', { count: data.totalRooms }) }}</span>
            </div>
          </div>
        </div>

        <!-- CHART AND BOOKING STATUS BREAKDOWN ROW -->
        <div class="dashboard-row">
          <!-- CHART SECTION -->
          <div class="card chart-card">
            <h3 class="card-title"><BarChart3 :size="20" /> {{ $t('host.revenue.chart_title', { year: selectedYear }) }}</h3>
            
            <div class="chart-container">
              <!-- Grid lines background -->
              <div class="chart-grid-lines">
                <div class="grid-line" v-for="i in 5" :key="i">
                  <span class="grid-value">{{ formatPriceShort(maxMonthlyRevenue * (5 - i) / 4) }}</span>
                </div>
              </div>
              
              <!-- Bars -->
              <div class="chart-bars">
                <div 
                  v-for="item in fullYearRevenues" 
                  :key="item.month" 
                  class="chart-bar-column"
                >
                  <div class="bar-wrapper">
                    <!-- Bar with computed height -->
                    <div 
                      class="bar-fill" 
                      :style="{ height: `${getBarHeightPercentage(item.revenue)}%` }"
                    >
                      <div class="bar-tooltip">
                        <p class="tip-month">{{ $t('host.revenue.chart_month', { month: item.month }) }}</p>
                        <p class="tip-rev">{{ $t('host.revenue.chart_revenue_tip', { revenue: formatPrice(item.revenue) }) }}</p>
                        <p class="tip-bookings">{{ $t('host.revenue.chart_bookings_tip', { count: item.bookingCount }) }}</p>
                      </div>
                    </div>
                  </div>
                  <span class="month-label">{{ locale === 'en' ? 'M' : 'T' }}{{ item.month }}</span>
                </div>
              </div>
            </div>
            
            <!-- Chart Legend -->
            <div class="chart-legend">
              <span class="legend-item"><span class="legend-dot"></span> {{ $t('host.revenue.chart_legend') }}</span>
            </div>
          </div>

          <!-- BOOKING STATUS BREAKDOWN -->
          <div class="card status-card">
            <h3 class="card-title"><PieChart :size="20" /> {{ $t('host.revenue.status_breakdown') }}</h3>
            <div class="status-list">
              <div class="status-item">
                <div class="status-header">
                  <span class="status-badge pending">{{ $t('host.bookings.status_pending') }}</span>
                  <span class="status-count">{{ data.pendingBookings }} ({{ getPercentage(data.pendingBookings) }}%)</span>
                </div>
                <div class="status-progress-bg">
                  <div class="status-progress-fill pending" :style="{ width: `${getPercentage(data.pendingBookings)}%` }"></div>
                </div>
              </div>
              <div class="status-item">
                <div class="status-header">
                  <span class="status-badge confirmed">{{ $t('host.bookings.status_confirmed') }}</span>
                  <span class="status-count">{{ data.confirmedBookings }} ({{ getPercentage(data.confirmedBookings) }}%)</span>
                </div>
                <div class="status-progress-bg">
                  <div class="status-progress-fill confirmed" :style="{ width: `${getPercentage(data.confirmedBookings)}%` }"></div>
                </div>
              </div>
              <div class="status-item">
                <div class="status-header">
                  <span class="status-badge completed">{{ $t('host.bookings.status_completed') }}</span>
                  <span class="status-count">{{ data.completedBookings }} ({{ getPercentage(data.completedBookings) }}%)</span>
                </div>
                <div class="status-progress-bg">
                  <div class="status-progress-fill completed" :style="{ width: `${getPercentage(data.completedBookings)}%` }"></div>
                </div>
              </div>
              <div class="status-item">
                <div class="status-header">
                  <span class="status-badge cancelled">{{ $t('host.bookings.status_cancelled') }}</span>
                  <span class="status-count">{{ data.cancelledBookings }} ({{ getPercentage(data.cancelledBookings) }}%)</span>
                </div>
                <div class="status-progress-bg">
                  <div class="status-progress-fill cancelled" :style="{ width: `${getPercentage(data.cancelledBookings)}%` }"></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ROOM REVENUE TABLES ROW -->
        <div class="rooms-tables-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 24px;">
          <!-- TOP ROOMS TABLE -->
          <div class="card table-card" style="margin-top: 0;">
            <h3 class="card-title" style="color: #22c55e;"><Award :size="20" /> {{ locale === 'vi' ? 'Top 5 Phòng Nghỉ Doanh Thu Cao Nhất' : 'Top 5 Highest Revenue Rooms' }}</h3>
            <div class="table-responsive">
              <table class="report-table">
                <thead>
                  <tr>
                    <th>{{ $t('host.revenue.table_rank') }}</th>
                    <th>{{ $t('host.revenue.table_name') }}</th>
                    <th>{{ $t('host.revenue.table_city') }}</th>
                    <th class="text-right">{{ $t('host.revenue.table_bookings') }}</th>
                    <th class="text-right">{{ $t('host.revenue.table_revenue') }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(room, index) in data.topRooms" :key="room.roomId">
                    <td>
                      <span class="rank-badge" :class="`rank-${index + 1}`">{{ index + 1 }}</span>
                    </td>
                    <td><strong>{{ room.roomName }}</strong></td>
                    <td>{{ translateCity(room.city) }}</td>
                    <td class="text-right">{{ $t('host.revenue.table_bookings_unit', { count: room.bookingCount }) }}</td>
                    <td class="text-right highlight-price"><strong>{{ formatPrice(room.totalRevenue) }}</strong></td>
                  </tr>
                  <tr v-if="!data.topRooms || data.topRooms.length === 0">
                    <td colspan="5" class="text-center empty-row">{{ $t('host.revenue.table_empty') }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- BOTTOM ROOMS TABLE -->
          <div class="card table-card" style="margin-top: 0;">
            <h3 class="card-title" style="color: #ef4444;"><Award :size="20" style="transform: rotate(180deg);" /> {{ locale === 'vi' ? 'Top 5 Phòng Nghỉ Doanh Thu Thấp Nhất' : 'Top 5 Lowest Revenue Rooms' }}</h3>
            <div class="table-responsive">
              <table class="report-table">
                <thead>
                  <tr>
                    <th>{{ $t('host.revenue.table_rank') }}</th>
                    <th>{{ $t('host.revenue.table_name') }}</th>
                    <th>{{ $t('host.revenue.table_city') }}</th>
                    <th class="text-right">{{ $t('host.revenue.table_bookings') }}</th>
                    <th class="text-right">{{ $t('host.revenue.table_revenue') }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(room, index) in data.bottomRooms" :key="room.roomId">
                    <td>
                      <span class="rank-badge rank-bottom" style="background: #fee2e2; color: #ef4444; border-radius: 50%; width: 24px; height: 24px; display: inline-flex; align-items: center; justify-content: center; font-weight: bold; font-size: 12px;">{{ index + 1 }}</span>
                    </td>
                    <td><strong>{{ room.roomName }}</strong></td>
                    <td>{{ translateCity(room.city) }}</td>
                    <td class="text-right">{{ $t('host.revenue.table_bookings_unit', { count: room.bookingCount }) }}</td>
                    <td class="text-right highlight-price-red" style="color: #ef4444;"><strong>{{ formatPrice(room.totalRevenue) }}</strong></td>
                  </tr>
                  <tr v-if="!data.bottomRooms || data.bottomRooms.length === 0">
                    <td colspan="5" class="text-center empty-row">{{ $t('host.revenue.table_empty') }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- HÓA ĐƠN CÔNG NỢ HOA HỒNG HỆ THỐNG -->
        <div class="card table-card" style="margin-top: 24px;">
          <h3 class="card-title"><FileText :size="20" /> {{ $t('host.commission_invoice_title') }}</h3>
          <p class="subtitle" style="margin: 6px 0 16px 0; font-size: 13.5px; color: #64748b; line-height: 1.5;">
            {{ $t('host.commission_invoice_desc') }}
          </p>
          <div class="table-responsive">
            <table class="report-table">
              <thead>
                <tr>
                  <th>{{ $t('host.invoice_code') }}</th>
                  <th>{{ $t('host.billing_period') }}</th>
                  <th class="text-right">{{ $t('host.amount_due') }}</th>
                  <th>{{ $t('host.payment_due_date') }}</th>
                  <th>{{ $t('host.status') }}</th>
                  <th class="text-center">{{ $t('host.actions') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="invoice in invoices" :key="invoice.id">
                  <td><strong>#INV-{{ invoice.id }}</strong></td>
                  <td>{{ formatDate(invoice.billingPeriodStart) }} - {{ formatDate(invoice.billingPeriodEnd) }}</td>
                  <td class="text-right highlight-price"><strong>{{ formatPrice(invoice.amount) }}</strong></td>
                  <td>
                    <span :class="{ 'text-red': invoice.status === 'OVERDUE' }">
                      {{ formatDate(invoice.dueDate) }}
                    </span>
                  </td>
                  <td>
                    <span class="status-badge" :class="invoice.status.toLowerCase()">
                      {{ getInvoiceStatusLabel(invoice.status) }}
                    </span>
                  </td>
                  <td class="text-center">
                    <button 
                      v-if="invoice.status !== 'PAID'" 
                      class="btn-primary-sm" 
                      :disabled="payLoading === invoice.id"
                      @click="handlePayInvoice(invoice.id)"
                    >
                      <span v-if="payLoading === invoice.id" class="spinner-sm"></span>
                      <span v-else>{{ $t('host.pay_vnpay') }}</span>
                    </button>
                    <span v-else class="text-green text-bold">{{ $t('host.completed') }}</span>
                  </td>
                </tr>
                <tr v-if="!invoices || invoices.length === 0">
                  <td colspan="6" class="text-center empty-row">{{ $t('host.empty_invoices') }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useI18n } from 'vue-i18n'
import axios from '../../api/axios'
import {
  DollarSign, FileText, Hotel,
  BarChart3, PieChart, Award, Wallet, Download
} from 'lucide-vue-next'
import { getMyInvoices, payInvoice } from '../../api/invoices'

const { t, locale } = useI18n()
const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}
const router = useRouter()
const authStore = useAuthStore()

const selectedYear = ref(2026)
const availableYears = [2026, 2025, 2024]
const filterMode = ref('BY_YEAR') // 'ALL_TIME' | 'BY_YEAR' | 'BY_QUARTER' | 'CUSTOM_RANGE'
const selectedQuarter = ref('1') // '1' | '2' | '3' | '4'
const customStartDate = ref(new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split('T')[0])
const customEndDate = ref(new Date().toISOString().split('T')[0])
const loading = ref(false)
const error = ref('')
const data = ref(null)
const invoices = ref([])
const payLoading = ref(null)

const handleModeChange = () => {
  fetchRevenueData()
}

const formatPrice = (amount) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0)
}

const formatPriceShort = (amount) => {
  if (!amount) return '0 ₫'
  if (amount >= 1000000) {
    return (amount / 1000000).toFixed(1) + 'M ₫'
  }
  if (amount >= 1000) {
    return (amount / 1000).toFixed(0) + 'K ₫'
  }
  return amount + ' ₫'
}

const fullYearRevenues = computed(() => {
  const months = []
  const monthlyMap = new Map()
  
  if (data.value && data.value.monthlyRevenues) {
    data.value.monthlyRevenues.forEach(item => {
      monthlyMap.set(item.month, item)
    })
  }

  for (let m = 1; m <= 12; m++) {
    if (monthlyMap.has(m)) {
      months.push(monthlyMap.get(m))
    } else {
      months.push({ month: m, year: selectedYear.value, revenue: 0, bookingCount: 0 })
    }
  }
  return months
})

const maxMonthlyRevenue = computed(() => {
  const max = Math.max(...fullYearRevenues.value.map(item => item.revenue), 1)
  return Math.ceil(max * 1.1)
})

const getBarHeightPercentage = (revenue) => {
  return (revenue / maxMonthlyRevenue.value) * 100
}

const getPercentage = (count) => {
  if (!data.value || !data.value.totalBookings) return 0
  return ((count / data.value.totalBookings) * 100).toFixed(1)
}

const getCommissionPercentage = computed(() => {
  if (data.value && (data.value.commissionRate !== undefined && data.value.commissionRate !== null)) {
    return `${data.value.commissionRate}%`
  }
  if (!data.value || !data.value.totalRevenue || !data.value.totalHostEarning) return '15%'
  const diff = data.value.totalRevenue - data.value.totalHostEarning
  if (diff <= 0) return '15%'
  const percentage = (diff / data.value.totalRevenue) * 100
  return `${percentage.toFixed(1)}%`
})

const handleLogout = () => {
  authStore.logout()
  router.push('/')
}

const fetchRevenueData = async () => {
  loading.value = true
  error.value = ''
  try {
    const params = {}
    if (filterMode.value === 'BY_YEAR') {
      params.year = selectedYear.value
    } else if (filterMode.value === 'BY_QUARTER') {
      params.year = selectedYear.value
      const y = selectedYear.value
      if (selectedQuarter.value === '1') {
        params.startDate = `${y}-01-01`
        params.endDate = `${y}-03-31`
      } else if (selectedQuarter.value === '2') {
        params.startDate = `${y}-04-01`
        params.endDate = `${y}-06-30`
      } else if (selectedQuarter.value === '3') {
        params.startDate = `${y}-07-01`
        params.endDate = `${y}-09-30`
      } else if (selectedQuarter.value === '4') {
        params.startDate = `${y}-10-01`
        params.endDate = `${y}-12-31`
      }
    } else if (filterMode.value === 'CUSTOM_RANGE') {
      params.startDate = customStartDate.value
      params.endDate = customEndDate.value
    }
    const response = await axios.get('/revenue/host', { params })
    data.value = response.data
  } catch (err) {
    console.error('Lấy doanh thu host thất bại:', err)
    error.value = err.response?.data?.message || 'Không thể lấy dữ liệu báo cáo doanh thu từ server.'
    useFallbackMockup()
  } finally {
    loading.value = false
  }
}

const useFallbackMockup = () => {
  const sampleRevenues = []
  const baseRevenues = [8, 12, 16, 20, 18, 22, 30, 32, 26, 18, 14, 12] // Million VND
  baseRevenues.forEach((rev, idx) => {
    sampleRevenues.push({
      month: idx + 1,
      year: selectedYear.value,
      revenue: rev * 1000000,
      bookingCount: Math.round(rev * 0.7)
    })
  })

  const totalRev = baseRevenues.reduce((sum, r) => sum + r, 0) * 1000000
  data.value = {
    totalRevenue: totalRev,
    totalHostEarning: totalRev * 0.85,
    totalBookings: 154,
    pendingBookings: 22,
    confirmedBookings: 38,
    completedBookings: 84,
    cancelledBookings: 10,
    totalRooms: 4, // Host rooms count
    monthlyRevenues: sampleRevenues,
    topRooms: [
      { roomId: 1, roomName: "Biệt Thự Cổ Điển View Thung Lũng Mây", city: "Đà Lạt", totalRevenue: 45000000, bookingCount: 22 },
      { roomId: 2, roomName: "Phòng Deluxe Hướng Biển - Vinpearl Resort", city: "Đà Nẵng", totalRevenue: 38000000, bookingCount: 18 },
      { roomId: 4, roomName: "Căn Hộ Studio Hiện Đại Trung Tâm Quận 1", city: "Hồ Chí Minh", totalRevenue: 28000000, bookingCount: 20 },
      { roomId: 5, roomName: "Bungalow Gió Biển Ngắm Hoàng Hôn", city: "Phú Quốc", totalRevenue: 22000000, bookingCount: 12 }
    ],
    bottomRooms: [
      { roomId: 10, roomName: "Villa Riêng Biển Non Nước", city: "Đà Nẵng", totalRevenue: 3500000, bookingCount: 1 },
      { roomId: 9, roomName: "Standard Gần Cầu Rồng", city: "Đà Nẵng", totalRevenue: 4000000, bookingCount: 2 }
    ]
  }
}

const exportToExcel = () => {
  if (!data.value) return

  let csvContent = '\uFEFF' // UTF-8 BOM for Vietnamese character support in Excel

  // 1. Header & General Stats
  csvContent += 'BÁO CÁO DOANH THU CHỦ NHÀ (HOST)\n'
  csvContent += `Chủ nhà: ,${authStore.user?.fullName || ''} (${authStore.user?.email || ''})\n`
  csvContent += `Kiểu báo cáo: ,${filterMode.value === 'ALL_TIME' ? 'Từ trước đến nay' : filterMode.value === 'BY_YEAR' ? 'Theo năm ' + selectedYear.value : filterMode.value === 'BY_QUARTER' ? 'Theo quý ' + selectedQuarter.value + ' năm ' + selectedYear.value : 'Khoảng thời gian tùy chọn (' + customStartDate.value + ' đến ' + customEndDate.value + ')'}\n`
  csvContent += `Ngày xuất báo cáo: ,${new Date().toLocaleString('vi-VN')}\n\n`

  csvContent += 'TỔNG QUAN HIỆU SUẤT\n'
  csvContent += `Doanh thu thô (Gross Revenue),${data.value.totalRevenue || 0} ₫\n`
  csvContent += `Thực nhận của Host (Net Revenue),${data.value.totalHostEarning || 0} ₫\n`
  csvContent += `Khấu trừ hoa hồng (Ước tính),${((data.value.totalRevenue || 0) - (data.value.totalHostEarning || 0)) || 0} ₫ (${getCommissionPercentage.value})\n`
  csvContent += `Tổng lượt đặt phòng,${data.value.totalBookings || 0} giao dịch\n`
  csvContent += `Tổng số phòng nghỉ đang quản lý,${data.value.totalRooms || 0} phòng\n\n`

  // 2. Monthly Revenue
  csvContent += 'DOANH THU THEO TỪNG THÁNG (Trong năm)\n'
  csvContent += 'Tháng,Doanh thu (VND),Số lượt đặt\n'
  fullYearRevenues.value.forEach(item => {
    csvContent += `Tháng ${item.month},${item.revenue},${item.bookingCount}\n`
  })
  csvContent += '\n'

  // 3. Top Rooms Highest
  csvContent += 'TOP 5 PHÒNG NGHỈ DOANH THU CAO NHẤT\n'
  csvContent += 'Xếp hạng,Tên phòng,Thành phố,Số lượt đặt,Doanh thu\n'
  if (data.value.topRooms && data.value.topRooms.length > 0) {
    data.value.topRooms.forEach((room, idx) => {
      csvContent += `${idx + 1},"${room.roomName.replace(/"/g, '""')}",${room.city},${room.bookingCount},${room.totalRevenue} ₫\n`
    })
  } else {
    csvContent += '-,Không có dữ liệu,,,\n'
  }
  csvContent += '\n'

  // 4. Top Rooms Lowest
  csvContent += 'TOP 5 PHÒNG NGHỈ DOANH THU THẤP NHẤT\n'
  csvContent += 'Xếp hạng,Tên phòng,Thành phố,Số lượt đặt,Doanh thu\n'
  if (data.value.bottomRooms && data.value.bottomRooms.length > 0) {
    data.value.bottomRooms.forEach((room, idx) => {
      csvContent += `${idx + 1},"${room.roomName.replace(/"/g, '""')}",${room.city},${room.bookingCount},${room.totalRevenue} ₫\n`
    })
  } else {
    csvContent += '-,Không có dữ liệu,,,\n'
  }

  // Create blob and download
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.setAttribute('href', url)
  
  let fileName = 'Bao_cao_doanh_thu_host'
  if (filterMode.value === 'BY_YEAR') fileName += `_nam_${selectedYear.value}`
  else if (filterMode.value === 'BY_QUARTER') fileName += `_quy_${selectedQuarter.value}_nam_${selectedYear.value}`
  else if (filterMode.value === 'CUSTOM_RANGE') fileName += `_tu_${customStartDate.value}_den_${customEndDate.value}`
  else fileName += '_tat_ca_thoi_gian'
  
  link.setAttribute('download', `${fileName}.csv`)
  link.style.visibility = 'hidden'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  
  // Show toast notification
  // Since HostRevenueView doesn't have local showToast/toast defined in script setup, let's just trigger a native alert or create a fallback.
  // Wait, let's check if HostRevenueView has toast setup. It doesn't seem to have one in lines 413-432.
  // Let's use window.alert or add a simple window.confirm, or just let the download happen. Actually, a download alert/native console.log or native alert is fine, or we can just run download quietly. 
  // Let's use a native alert for now or simply run the download. Quiet download is great. Let's do alert in Vietnamese:
  alert('Đã xuất báo cáo doanh thu Excel (CSV) thành công!');
}

const fetchInvoices = async () => {
  try {
    const res = await getMyInvoices()
    invoices.value = res.data
  } catch (err) {
    console.error('Lỗi khi tải hóa đơn công nợ:', err)
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  const currentLang = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Intl.DateTimeFormat(currentLang).format(date)
}

const translateCity = (city) => {
  switch (city) {
    case 'Hà Nội': return t('cities.hanoi')
    case 'Đà Nẵng': return t('cities.danang')
    case 'Hồ Chí Minh': return t('cities.hcm')
    case 'Phú Quốc': return t('cities.phuquoc')
    case 'Đà Lạt': return t('cities.dalat')
    case 'Nha Trang': return t('cities.nhatrang')
    default: return city
  }
}

const getInvoiceStatusLabel = (status) => {
  if (status === 'PENDING') return t('host.status_pending')
  if (status === 'PAID') return t('host.status_paid')
  if (status === 'OVERDUE') return t('host.status_overdue')
  return status
}

const handlePayInvoice = async (invoiceId) => {
  payLoading.value = invoiceId
  try {
    const res = await payInvoice(invoiceId, locale.value)
    if (res.data && res.data.paymentUrl) {
      window.location.href = res.data.paymentUrl
    } else {
      alert(t('host.toast_no_link'))
    }
  } catch (err) {
    alert(err.response?.data?.message || t('host.toast_pay_error'))
  } finally {
    payLoading.value = null
  }
}

onMounted(() => {
  fetchRevenueData()
  fetchInvoices()
})
</script>

<style scoped>
/* Variables & Theme */
:root {
  --blue: #5392f9;
  --red: #ff567d;
  --orange: #ffb703;
  --dark: #2a2a2e;
  --bg: #f8f7f9;
}

/* Base Styles */
* {
  box-sizing: border-box;
}

.min-h-screen {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1.5rem;
  width: 100%;
}

/* Header */
.header {
  background: white;
  border-bottom: 1px solid #e2e8f0;
  padding: 0.9rem 0;
  position: sticky;
  top: 0;
  z-index: 50;
}

.header .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  font-size: 1.4rem;
  font-weight: 800;
  letter-spacing: -0.05em;
  color: #5392f9;
  text-decoration: none;
}

.logo-red {
  color: #ff567d;
}

.divider {
  color: #cbd5e1;
  margin: 0 0.5rem;
  font-size: 1.2rem;
  font-weight: 300;
}

.panel-tag {
  font-size: 0.85rem;
  font-weight: 600;
  color: #64748b;
  background: #f1f5f9;
  padding: 0.2rem 0.6rem;
  border-radius: 6px;
}

.header-left, .header-right {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-back-nav {
  font-size: 0.875rem;
  font-weight: 600;
  color: #64748b;
  text-decoration: none;
  transition: color 0.2s;
  margin-right: 0.75rem;
}

.btn-back-nav:hover {
  color: #5392f9;
}

.user-name {
  font-size: 0.875rem;
  font-weight: 600;
  color: #334155;
  margin-right: 0.75rem;
}

.btn-outline {
  padding: 0.45rem 1.1rem;
  border-radius: 999px;
  font-size: 0.85rem;
  font-weight: 600;
  border: 1.5px solid #5392f9;
  color: #5392f9;
  background: transparent;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-outline:hover {
  background: #5392f9;
  color: white;
}

/* Main Content */
.main-content {
  padding-top: 2rem;
  padding-bottom: 4rem;
  flex: 1;
}

/* Title & filter row */
.title-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 2rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.title-info h1 {
  font-size: 1.75rem;
  font-weight: 800;
  color: #1e293b;
  letter-spacing: -0.02em;
  margin-bottom: 0.35rem;
}

.subtitle {
  color: #64748b;
  font-size: 0.92rem;
}

.filter-box {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 0.5rem 1rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.02);
}

.filter-box label {
  font-size: 0.85rem;
  font-weight: 600;
  color: #64748b;
}

.select-input {
  border: 1px solid #e2e8f0;
  background: #f8fafc;
  padding: 0.35rem 1.5rem 0.35rem 0.75rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  color: #334155;
  cursor: pointer;
  outline: none;
}

.select-input:focus {
  border-color: #5392f9;
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.25rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1.25rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.02);
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05);
}

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-icon.rev-color {
  background: #eff6ff;
  color: #5392f9;
}

.stat-icon.booking-color {
  background: #fdf2f8;
  color: #ff567d;
}

.stat-icon.room-color {
  background: #f0fdf4;
  color: #10b981;
}

.host-net-card {
  border: 1.5px solid #10b981 !important;
  box-shadow: 0 4px 20px rgba(16, 185, 129, 0.08) !important;
}

.stat-icon.net-color {
  background: #ecfdf5;
  color: #10b981;
}

.highlight-green {
  color: #10b981 !important;
}

.stat-sub {
  display: block;
  font-size: 0.72rem;
  color: #64748b;
  margin-top: 0.25rem;
  font-weight: 500;
}

.stat-info h4 {
  font-size: 0.75rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.25rem;
}

.stat-val {
  font-size: 1.35rem;
  font-weight: 800;
  color: #1e293b;
  letter-spacing: -0.01em;
}

/* Dashboard Layout Rows */
.dashboard-row {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

@media (max-width: 900px) {
  .dashboard-row {
    grid-template-columns: 1fr;
  }
}

.card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.02);
}

.card-title {
  font-size: 1.1rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  letter-spacing: -0.01em;
}

/* CSS Chart Styles */
.chart-card {
  display: flex;
  flex-direction: column;
}

.chart-container {
  height: 250px;
  position: relative;
  margin-top: 1rem;
  margin-bottom: 1rem;
  flex: 1;
}

.chart-grid-lines {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 80%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.grid-line {
  border-bottom: 1px dashed #e2e8f0;
  width: 100%;
  position: relative;
  height: 0;
}

.grid-value {
  position: absolute;
  left: 0;
  top: -15px;
  font-size: 0.7rem;
  font-weight: 600;
  color: #94a3b8;
  background: white;
  padding-right: 0.35rem;
}

.chart-bars {
  position: absolute;
  top: 0;
  left: 50px; /* Offset for grid labels */
  right: 10px;
  height: 80%;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
}

.chart-bar-column {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  height: 100%;
  justify-content: flex-end;
}

.bar-wrapper {
  height: 100%;
  width: 50%;
  max-width: 32px;
  min-width: 14px;
  display: flex;
  align-items: flex-end;
  position: relative;
}

.bar-fill {
  width: 100%;
  background: linear-gradient(180deg, #74b9ff, #5392f9);
  border-top-left-radius: 6px;
  border-top-right-radius: 6px;
  cursor: pointer;
  position: relative;
  transition: background 0.2s, transform 0.2s;
  min-height: 2px;
}

.bar-fill:hover {
  background: linear-gradient(180deg, #ff7675, #ff567d);
  transform: scaleX(1.05);
}

.month-label {
  font-size: 0.72rem;
  font-weight: 700;
  color: #64748b;
  margin-top: 0.5rem;
}

/* Tooltip on Hover */
.bar-tooltip {
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%) translateY(-8px);
  background: rgba(15, 23, 42, 0.95);
  color: white;
  border-radius: 8px;
  padding: 0.6rem 0.8rem;
  box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
  z-index: 10;
  width: max-content;
  max-width: 180px;
  pointer-events: none;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.15s, visibility 0.15s;
}

.bar-fill:hover .bar-tooltip {
  opacity: 1;
  visibility: visible;
}

.bar-tooltip::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-width: 5px;
  border-style: solid;
  border-color: rgba(15, 23, 42, 0.95) transparent transparent transparent;
}

.tip-month {
  font-size: 0.75rem;
  font-weight: 700;
  border-bottom: 1px solid rgba(255,255,255,0.1);
  padding-bottom: 0.25rem;
  margin-bottom: 0.25rem;
}

.tip-rev {
  font-size: 0.72rem;
  font-weight: 600;
  color: #cbd5e1;
}

.tip-bookings {
  font-size: 0.65rem;
  color: #94a3b8;
}

.chart-legend {
  margin-top: auto;
  border-top: 1px solid #f1f5f9;
  padding-top: 0.75rem;
  display: flex;
  justify-content: center;
}

.legend-item {
  font-size: 0.75rem;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 0.35rem;
}

.legend-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #5392f9;
  display: inline-block;
}

/* Booking Status Breakdown CSS */
.status-list {
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
}

.status-item {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.status-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  text-transform: uppercase;
}

.status-badge.pending { background: #fffbeb; color: #ffb703; }
.status-badge.confirmed { background: #eff6ff; color: #5392f9; }
.status-badge.completed { background: #f0fdf4; color: #10b981; }
.status-badge.cancelled { background: #fdf2f8; color: #ff567d; }

.status-count {
  font-size: 0.8rem;
  font-weight: 700;
  color: #475569;
}

.status-progress-bg {
  height: 8px;
  background: #f1f5f9;
  border-radius: 999px;
  overflow: hidden;
}

.status-progress-fill {
  height: 100%;
  border-radius: 999px;
  transition: width 0.3s ease;
}

.status-progress-fill.pending { background: #ffb703; }
.status-progress-fill.confirmed { background: #5392f9; }
.status-progress-fill.completed { background: #10b981; }
.status-progress-fill.cancelled { background: #ff567d; }

/* Table View styles */
.table-card {
  margin-top: 1.5rem;
}

.table-responsive {
  width: 100%;
  overflow-x: auto;
}

.report-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
  font-size: 0.9rem;
}

.report-table th {
  padding: 0.75rem 1rem;
  background: #f8fafc;
  color: #64748b;
  font-weight: 700;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 2px solid #e2e8f0;
}

.report-table td {
  padding: 0.9rem 1rem;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
  vertical-align: middle;
}

.report-table tr:hover {
  background: #fafafb;
}

.text-right {
  text-align: right;
}

.text-center {
  text-align: center;
}

.highlight-price {
  color: #5392f9;
}

.empty-row {
  padding: 2.5rem;
  color: #94a3b8;
}

/* Rank badges */
.rank-badge {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 800;
  color: white;
}

.rank-1 { background: #ffd700; }
.rank-2 { background: #c0c0c0; }
.rank-3 { background: #cd7f32; }
.rank-4, .rank-5 { background: #94a3b8; }

/* Loading & error states */
.loading-state, .error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  margin-top: 2rem;
}

.spinner-large {
  width: 48px;
  height: 48px;
  border: 4px solid #f1f5f9;
  border-top: 4px solid #5392f9;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-msg {
  color: #ff567d;
  font-weight: 600;
  margin-bottom: 1rem;
  text-align: center;
}

.btn-primary {
  background: #5392f9;
  color: white;
  border: none;
  padding: 0.6rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-primary:hover {
  background: #3b7ddd;
}

.text-red {
  color: #ff567d;
  font-weight: 600;
}

.text-green {
  color: #10b981;
}

.text-bold {
  font-weight: 700;
}

.status-badge.pending {
  background: #fffbeb;
  color: #ffb703;
}

.status-badge.overdue {
  background: #fdf2f8;
  color: #ff567d;
}

.status-badge.paid {
  background: #f0fdf4;
  color: #10b981;
}

.btn-primary-sm {
  background: #5392f9;
  color: white;
  border: none;
  padding: 0.4rem 1rem;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.8rem;
  cursor: pointer;
  transition: background 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.btn-primary-sm:hover {
  background: #3b7ddd;
}

.btn-primary-sm:disabled {
  background: #94a3b8;
  cursor: not-allowed;
}

.spinner-sm {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  display: inline-block;
}

.highlight-price-red {
  color: #ef4444;
}

.rank-badge.rank-bottom {
  background: #fee2e2;
  color: #ef4444;
}

@media (max-width: 992px) {
  .rooms-tables-row {
    grid-template-columns: 1fr !important;
    gap: 16px;
  }
}
</style>
