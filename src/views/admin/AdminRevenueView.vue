<template>
  <div class="min-h-screen" style="background:#f8f7f9; font-family: 'Inter', sans-serif; color: var(--dark);">
    <!-- HEADER -->
    <header class="header">
      <div class="container">
        <div class="header-left">
          <RouterLink to="/admin" class="logo">
            <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="22" height="22" style="width: 22px; height: 22px; flex-shrink: 0; margin-right: 6px;">
              <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="logo-word building">Building</span>
            <span class="logo-word hotel">Hotel</span>
            <span class="logo-word stay">Stay</span>
          </RouterLink>
          <span class="divider">/</span>
          <span class="panel-tag">{{ $t('admin.revenue') }}</span>
        </div>
        <div class="header-right">
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
          <RouterLink to="/admin" class="btn-back-nav">{{ $t('admin.back_admin') }}</RouterLink>
          <span class="user-name" v-if="authStore.isLoggedIn">{{ authStore.user?.fullName }}</span>
          <button class="btn-outline" @click="handleLogout">{{ $t('admin.logout') }}</button>
        </div>
      </div>
    </header>

    <main class="container main-content">
      <!-- TITLE AND FILTER ROW -->
      <div class="title-row" style="align-items: flex-end;">
        <div class="title-info">
          <h1>{{ $t('admin.revenue_report_title') }}</h1>
          <p class="subtitle">{{ $t('admin.revenue_report_subtitle') }}</p>
        </div>
        <div class="filter-box-row" style="display: flex; gap: 16px; align-items: center; flex-wrap: wrap;">
          <!-- Filter Mode Selector -->
          <div class="filter-box">
            <label for="mode-select" style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Kiểu báo cáo' : 'Report Type' }}</label>
            <select id="mode-select" v-model="filterMode" @change="handleModeChange" class="select-input" style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-weight: 600; color: #334155;">
              <option value="ALL_TIME">{{ locale === 'vi' ? 'Từ xưa đến nay' : 'All-time' }}</option>
              <option value="BY_YEAR">{{ locale === 'vi' ? 'Theo năm' : 'By Year' }}</option>
              <option value="CUSTOM_RANGE">{{ locale === 'vi' ? 'Khoảng thời gian tự chọn' : 'Custom Range' }}</option>
            </select>
          </div>

          <!-- Year Selector (visible if mode is BY_YEAR) -->
          <div class="filter-box" v-if="filterMode === 'BY_YEAR'">
            <label for="year-select" style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ $t('admin.select_year') }}</label>
            <select id="year-select" v-model="selectedYear" @change="fetchRevenueData" class="select-input" style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-weight: 600; color: #334155;">
              <option v-for="year in availableYears" :key="year" :value="year">{{ $t('admin.year_unit', { year: year }) }}</option>
            </select>
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
        </div>
      </div>

      <!-- LOADING STATE -->
      <div v-if="loading" class="loading-state">
        <div class="spinner-large"></div>
        <p>{{ $t('admin.loading_report') }}</p>
      </div>

      <!-- ERROR STATE -->
      <div v-else-if="error" class="error-state">
        <p class="error-msg">{{ error }}</p>
        <button class="btn-primary" @click="fetchRevenueData">{{ $t('admin.retry') }}</button>
      </div>

      <!-- CONTENT STATE -->
      <div v-else-if="data" class="dashboard-content">
        <!-- 6 CARDS STATS -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon rev-color"><DollarSign :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('admin.stat_total_revenue') }}</h4>
              <span class="stat-val">{{ formatPrice(data.totalRevenue) }}</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon commission-color"><Percent :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('admin.stat_commission') }}</h4>
              <span class="stat-val">{{ formatPrice(data.totalCommission) }}</span>
              <div class="system-rate-row">
                <span class="rate-label">{{ $t('admin.default_commission') }}: </span>
                <span v-if="!editingSystemRate" class="rate-val-display" @click="startEditSystemRate" :title="$t('admin.edit_default_commission')">
                  {{ systemRate }}% <Edit2 :size="10" class="edit-icon-inline" />
                </span>
                <span v-else class="rate-val-form" @click.stop>
                  <input
                    type="number"
                    v-model.number="tempSystemRate"
                    min="0"
                    max="100"
                    class="system-rate-input"
                    @keyup.enter="saveSystemRate"
                    @keyup.esc="editingSystemRate = false"
                  />
                  <span class="pct-sign-inline">%</span>
                  <button class="btn-save-inline-rate" @click="saveSystemRate"><Check :size="10" /></button>
                  <button class="btn-cancel-inline-rate" @click="editingSystemRate = false"><X :size="10" /></button>
                </span>
              </div>
              <small class="stat-sub">{{ $t('admin.commission_percentage', { percentage: getCommissionPercentage }) }}</small>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon hostearning-color"><Wallet :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('admin.stat_host_earning') }}</h4>
              <span class="stat-val">{{ formatPrice(data.totalRevenue - (data.totalCommission || 0)) }}</span>
              <small class="stat-sub">{{ $t('admin.commission_percentage', { percentage: getHostEarningPercentage }) }}</small>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon booking-color"><FileText :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('admin.total_bookings') }}</h4>
              <span class="stat-val">{{ data.totalBookings }} {{ $t('admin.bookings_unit') }}</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon user-color"><Users :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('admin.total_users') }}</h4>
              <span class="stat-val">{{ data.totalUsers }} {{ $t('admin.members') }}</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon room-color"><Hotel :size="24" /></div>
            <div class="stat-info">
              <h4>{{ $t('admin.total_rooms') }}</h4>
              <span class="stat-val">{{ data.totalRooms }} {{ $t('admin.rooms_unit') }}</span>
            </div>
          </div>
        </div>

        <!-- CHART AND BOOKING STATUS BREAKDOWN ROW -->
        <div class="dashboard-row">
          <!-- CHART SECTION -->
          <div class="card chart-card">
            <h3 class="card-title"><BarChart3 :size="20" /> {{ $t('admin.monthly_revenue', { year: selectedYear }) }}</h3>
            
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
                    <th>{{ $t('admin.rank') }}</th>
                    <th>{{ $t('admin.room_name') }}</th>
                    <th>{{ $t('admin.city') }}</th>
                    <th class="text-right">{{ $t('admin.booking_count') }}</th>
                    <th class="text-right">{{ $t('admin.total_revenue') }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(room, index) in data.topRooms" :key="room.roomId">
                    <td>
                      <span class="rank-badge" :class="`rank-${index + 1}`">{{ index + 1 }}</span>
                    </td>
                    <td><strong>{{ room.roomName }}</strong></td>
                    <td>{{ room.city }}</td>
                    <td class="text-right">{{ $t('admin.booking_count_unit', { count: room.bookingCount }) }}</td>
                    <td class="text-right highlight-price"><strong>{{ formatPrice(room.totalRevenue) }}</strong></td>
                  </tr>
                  <tr v-if="!data.topRooms || data.topRooms.length === 0">
                    <td colspan="5" class="text-center empty-row">{{ $t('admin.empty_rooms') }}</td>
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
                    <th>{{ $t('admin.rank') }}</th>
                    <th>{{ $t('admin.room_name') }}</th>
                    <th>{{ $t('admin.city') }}</th>
                    <th class="text-right">{{ $t('admin.booking_count') }}</th>
                    <th class="text-right">{{ $t('admin.total_revenue') }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(room, index) in data.bottomRooms" :key="room.roomId">
                    <td>
                      <span class="rank-badge rank-bottom" style="background: #fee2e2; color: #ef4444; border-radius: 50%; width: 24px; height: 24px; display: inline-flex; align-items: center; justify-content: center; font-weight: bold; font-size: 12px;">{{ index + 1 }}</span>
                    </td>
                    <td><strong>{{ room.roomName }}</strong></td>
                    <td>{{ room.city }}</td>
                    <td class="text-right">{{ $t('admin.booking_count_unit', { count: room.bookingCount }) }}</td>
                    <td class="text-right highlight-price-red" style="color: #ef4444;"><strong>{{ formatPrice(room.totalRevenue) }}</strong></td>
                  </tr>
                  <tr v-if="!data.bottomRooms || data.bottomRooms.length === 0">
                    <td colspan="5" class="text-center empty-row">{{ $t('admin.empty_rooms') }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- QUẢN LÝ HÓA ĐƠN CÔNG NỢ HOA HỒNG HOST -->
        <div class="card table-card" style="margin-top: 24px;">
          <div class="card-title-row" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-wrap: wrap; gap: 12px;">
            <h3 class="card-title" style="margin-bottom: 0;"><FileText :size="20" /> {{ $t('admin.manage_host_invoices') }}</h3>
            <div class="generate-action-box" style="display: flex; align-items: center; gap: 8px;">
              <label for="end-date-select" style="font-size: 13px; font-weight: 600; color: #475569;">{{ $t('admin.billing_end_date') }}</label>
              <input id="end-date-select" type="date" v-model="generateDate" class="date-input-sm" style="padding: 4px 8px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" />
              <button 
                class="btn-primary-sm" 
                :disabled="generateLoading"
                @click="handleGenerateInvoices"
              >
                <span v-if="generateLoading" class="spinner-sm"></span>
                <span v-else>{{ $t('admin.btn_generate_monthly_invoices') }}</span>
              </button>
            </div>
          </div>
          
          <div class="table-responsive">
            <table class="report-table">
              <thead>
                <tr>
                  <th>{{ $t('admin.col_invoice_id') }}</th>
                  <th>{{ $t('admin.col_host') }}</th>
                  <th>{{ $t('admin.col_billing_period') }}</th>
                  <th class="text-right">{{ $t('admin.col_amount_due') }}</th>
                  <th>{{ $t('admin.col_due_date') }}</th>
                  <th>{{ $t('admin.col_status') }}</th>
                  <th>{{ $t('admin.col_txn_id') }}</th>
                  <th>{{ $t('admin.col_payment_date') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="invoice in invoices" :key="invoice.id">
                  <td><strong>#INV-{{ invoice.id }}</strong></td>
                  <td>
                    <div><strong>{{ invoice.host?.fullName }}</strong></div>
                    <small style="color: #64748b;">{{ invoice.host?.email }}</small>
                  </td>
                  <td>{{ formatDate(invoice.billingPeriodStart) }} - {{ formatDate(invoice.billingPeriodEnd) }}</td>
                  <td class="text-right highlight-price"><strong>{{ formatPrice(invoice.amount) }}</strong></td>
                  <td>
                    <span :class="{ 'text-red': invoice.status === 'OVERDUE' }">
                      {{ formatDate(invoice.dueDate) }}
                    </span>
                  </td>
                  <td>
                    <span class="status-badge" :class="invoice.status.toLowerCase()">
                      {{ getStatusLabel(invoice.status) }}
                    </span>
                  </td>
                  <td>
                    <small style="font-family: monospace; color: #475569;">{{ invoice.transactionId || '-' }}</small>
                  </td>
                  <td>{{ invoice.paidAt ? formatDateTime(invoice.paidAt) : '-' }}</td>
                </tr>
                <tr v-if="!invoices || invoices.length === 0">
                  <td colspan="8" class="text-center empty-row">{{ $t('admin.empty_invoices') }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </main>

    <!-- Toast notification -->
    <Transition name="toast-slide">
      <div class="toast" :class="toast.type" v-if="toast.show">
        <component :is="toast.type === 'success' ? CheckCircle : AlertCircle" :size="16" />
        {{ toast.message }}
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import axios from '../../api/axios'
import { useI18n } from 'vue-i18n'
import {
  DollarSign, FileText, Users, Hotel,
  BarChart3, PieChart, Award, Percent, Wallet,
  Edit2, Check, X, CheckCircle, AlertCircle
} from 'lucide-vue-next'
import { getAllInvoicesAdmin, generateInvoicesAdmin } from '../../api/invoices'

const { t, locale } = useI18n()

const invoices = ref([])
const generateDate = ref(new Date().toISOString().split('T')[0])
const generateLoading = ref(false)

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const router = useRouter()
const authStore = useAuthStore()

// System-wide Commission Rate state
const systemRate = ref(10)
const editingSystemRate = ref(false)
const tempSystemRate = ref(10)

// Toast notifications state
const toast = ref({ show: false, type: 'success', message: '' })
const showToast = (message, type = 'success') => {
  toast.value = { show: true, type, message }
  setTimeout(() => { toast.value.show = false }, 3500)
}

const startEditSystemRate = () => {
  tempSystemRate.value = systemRate.value
  editingSystemRate.value = true
}

const saveSystemRate = async () => {
  if (tempSystemRate.value === null || tempSystemRate.value === '') {
    showToast('Tỷ lệ hoa hồng không được để trống', 'error')
    return
  }
  const rateNum = Number(tempSystemRate.value)
  if (isNaN(rateNum) || rateNum < 0 || rateNum > 100) {
    showToast('Tỷ lệ hoa hồng phải từ 0% đến 100%', 'error')
    return
  }
  
  try {
    const response = await axios.put('/admin/settings/commission-rate', null, { params: { rate: rateNum } })
    systemRate.value = rateNum
    editingSystemRate.value = false
    showToast(response.data?.message || `Đã cập nhật tỷ lệ hoa hồng hệ thống: ${rateNum}%`)
    // Re-fetch revenue data to reflect changes
    await fetchRevenueData()
  } catch (err) {
    console.error('Cập nhật tỷ lệ hoa hồng hệ thống thất bại:', err)
    // Fallback/Mockup mode logic
    systemRate.value = rateNum
    editingSystemRate.value = false
    showToast(`Đã cập nhật tỷ lệ hoa hồng hệ thống (Mock): ${rateNum}%`)
    
    // Update mockup data commission based on the new rate
    if (data.value) {
      data.value.totalCommission = data.value.totalRevenue * (rateNum / 100)
    }
  }
}

const fetchSystemRate = async () => {
  try {
    const res = await axios.get('/admin/settings/commission-rate')
    if (res.data && res.data.defaultRate !== undefined) {
      systemRate.value = res.data.defaultRate
    }
  } catch (e) {
    console.warn('Không thể lấy tỷ lệ hoa hồng mặc định từ server:', e)
  }
}

const selectedYear = ref(2026)
const availableYears = [2026, 2025, 2024]
const filterMode = ref('BY_YEAR') // 'ALL_TIME' | 'BY_YEAR' | 'CUSTOM_RANGE'
const customStartDate = ref(new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split('T')[0])
const customEndDate = ref(new Date().toISOString().split('T')[0])
const loading = ref(false)
const error = ref('')
const data = ref(null)

const handleModeChange = () => {
  fetchRevenueData()
}

// Format numbers as VND currency
const formatPrice = (amount) => {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0)
}

// Compact VND formatting for graph scale values
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

// Compute standard 12 months array (fill missing months with 0 revenue)
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

// Find highest monthly revenue to scale the graph bar heights
const maxMonthlyRevenue = computed(() => {
  const max = Math.max(...fullYearRevenues.value.map(item => item.revenue), 1)
  // Round up to nice number for the graph top limit
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
  if (!data.value || !data.value.totalRevenue) return '0%'
  const percentage = ((data.value.totalCommission || 0) / data.value.totalRevenue) * 100
  return `${percentage.toFixed(1)}%`
})

const getHostEarningPercentage = computed(() => {
  if (!data.value || !data.value.totalRevenue) return '0%'
  const hostEarning = data.value.totalRevenue - (data.value.totalCommission || 0)
  const percentage = (hostEarning / data.value.totalRevenue) * 100
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
    } else if (filterMode.value === 'CUSTOM_RANGE') {
      params.startDate = customStartDate.value
      params.endDate = customEndDate.value
    }
    const response = await axios.get('/revenue/admin', { params })
    data.value = response.data
  } catch (err) {
    console.error('Lấy dữ liệu báo cáo thất bại:', err)
    error.value = err.response?.data?.message || 'Không thể lấy dữ liệu báo cáo từ server. Vui lòng kiểm tra lại kết nối.'
    // Fallback to sample mockup logic only when backend request fails completely
    useFallbackMockup()
  } finally {
    loading.value = false
  }
}

// Sample fallback mockup structured exactly like standard response to keep UI premium if server not running
const useFallbackMockup = () => {
  const sampleRevenues = []
  const baseRevenues = [12, 18, 25, 30, 28, 35, 45, 50, 38, 28, 22, 19] // Million VND
  baseRevenues.forEach((rev, idx) => {
    sampleRevenues.push({
      month: idx + 1,
      year: selectedYear.value,
      revenue: rev * 1000000,
      bookingCount: Math.round(rev * 0.8)
    })
  })

  const totalRev = baseRevenues.reduce((sum, r) => sum + r, 0) * 1000000
  data.value = {
    totalRevenue: totalRev,
    totalCommission: totalRev * (systemRate.value / 100),
    totalBookings: 245,
    pendingBookings: 35,
    confirmedBookings: 60,
    completedBookings: 135,
    cancelledBookings: 15,
    totalUsers: 380,
    totalRooms: 68,
    totalHosts: 22,
    monthlyRevenues: sampleRevenues,
    topRooms: [
      { roomId: 1, roomName: "Biệt Thự Cổ Điển View Thung Lũng Mây", city: "Đà Lạt", totalRevenue: 45000000, bookingCount: 22 },
      { roomId: 2, roomName: "Phòng Deluxe Hướng Biển - Vinpearl Resort", city: "Đà Nẵng", totalRevenue: 38000000, bookingCount: 18 },
      { roomId: 3, roomName: "Premium Suite Luxury - InterContinental", city: "Hà Nội", totalRevenue: 35000000, bookingCount: 15 },
      { roomId: 4, roomName: "Căn Hộ Studio Hiện Đại Trung Tâm Quận 1", city: "Hồ Chí Minh", totalRevenue: 28000000, bookingCount: 20 },
      { roomId: 5, roomName: "Bungalow Gió Biển Ngắm Hoàng Hôn", city: "Phú Quốc", totalRevenue: 22000000, bookingCount: 12 }
    ],
    bottomRooms: [
      { roomId: 10, roomName: "Villa Riêng Biển Non Nước", city: "Đà Nẵng", totalRevenue: 3500000, bookingCount: 1 },
      { roomId: 9, roomName: "Standard Gần Cầu Rồng", city: "Đà Nẵng", totalRevenue: 4000000, bookingCount: 2 },
      { roomId: 8, roomName: "Suite Sông Hàn Sang Trọng", city: "Đà Nẵng", totalRevenue: 5400000, bookingCount: 3 },
      { roomId: 7, roomName: "Deluxe View Biển Mỹ Khê", city: "Đà Nẵng", totalRevenue: 6000000, bookingCount: 4 },
      { roomId: 6, roomName: "Phòng đơn view vườn", city: "Nha Trang", totalRevenue: 8500000, bookingCount: 5 }
    ]
  }
}

const fetchInvoices = async () => {
  try {
    const res = await getAllInvoicesAdmin()
    invoices.value = res.data
  } catch (err) {
    console.error('Lỗi khi lấy danh sách hóa đơn:', err)
    showToast(err.response?.data?.message || 'Không thể lấy danh sách hóa đơn từ server.', 'error')
  }
}

const handleGenerateInvoices = async () => {
  if (!generateDate.value) {
    showToast('Vui lòng chọn ngày chốt dữ liệu.', 'error')
    return
  }
  generateLoading.value = true
  try {
    const res = await generateInvoicesAdmin(generateDate.value)
    showToast(res.data.message || 'Đã xuất hóa đơn thành công.', 'success')
    fetchInvoices()
  } catch (err) {
    showToast(err.response?.data?.message || 'Có lỗi xảy ra khi tạo hóa đơn.', 'error')
  } finally {
    generateLoading.value = false
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  const currentLocale = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Intl.DateTimeFormat(currentLocale).format(date)
}

const formatDateTime = (dateTimeStr) => {
  if (!dateTimeStr) return ''
  const date = new Date(dateTimeStr)
  const currentLocale = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Intl.DateTimeFormat(currentLocale, {
    year: 'numeric', month: 'numeric', day: 'numeric',
    hour: 'numeric', minute: 'numeric'
  }).format(date)
}

const getStatusLabel = (status) => {
  if (status === 'PENDING') return t('admin.status_pending_payment')
  if (status === 'PAID') return t('admin.status_paid')
  if (status === 'OVERDUE') return t('admin.status_overdue')
  return status
}

onMounted(async () => {
  await fetchSystemRate()
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

/* 4 Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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

.stat-icon.user-color {
  background: #fffbeb;
  color: #ffb703;
}

.stat-icon.room-color {
  background: #f0fdf4;
  color: #10b981;
}

.stat-icon.commission-color {
  background: #faf5ff;
  color: #a855f7;
}

.stat-icon.hostearning-color {
  background: #ecfdf5;
  color: #10b981;
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

/* System rate edit styling */
.system-rate-row {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  margin-top: 0.35rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: #64748b;
}

.rate-val-display {
  font-weight: 700;
  color: #5392f9;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.15rem;
  padding: 0.1rem 0.35rem;
  background: #f0f6ff;
  border-radius: 4px;
  border: 1px solid transparent;
  transition: all 0.2s;
}

.rate-val-display:hover {
  background: #e0ecff;
  border-color: #bfdbfe;
}

.edit-icon-inline {
  color: #94a3b8;
}

.rate-val-display:hover .edit-icon-inline {
  color: #5392f9;
}

.rate-val-form {
  display: inline-flex;
  align-items: center;
  gap: 0.15rem;
  background: #f8fafc;
  padding: 0.1rem;
  border-radius: 6px;
  border: 1px solid #cbd5e1;
}

.system-rate-input {
  width: 44px;
  padding: 0.1rem 0.25rem;
  border: 1px solid #5392f9 !important;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 700;
  text-align: center;
  outline: none;
}

.pct-sign-inline {
  font-size: 0.75rem;
  font-weight: 700;
  color: #475569;
}

.btn-save-inline-rate {
  background: #ecfdf5;
  border: 1px solid #10b981;
  color: #059669;
  width: 18px;
  height: 18px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-save-inline-rate:hover {
  background: #d1fae5;
}

.btn-cancel-inline-rate {
  background: #fef2f2;
  border: 1px solid #fca5a5;
  color: #ef4444;
  width: 18px;
  height: 18px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-cancel-inline-rate:hover {
  background: #fee2e2;
}

/* Toast styles */
.toast {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: .6rem;
  padding: .85rem 1.4rem;
  border-radius: 13px;
  font-size: .85rem;
  font-weight: 700;
  box-shadow: 0 12px 40px rgba(0,0,0,.18);
  min-width: 260px;
}
.toast.success { background: #fff; border: 2px solid #10b981; color: #065f46; }
.toast.error { background: #fff; border: 2px solid #ef4444; color: #dc2626; }

.toast-slide-enter-active { transition: all .35s cubic-bezier(.34,1.56,.64,1); }
.toast-slide-leave-active { transition: all .25s ease; }
.toast-slide-enter-from { transform: translateY(20px); opacity: 0; }
.toast-slide-leave-to { transform: translateY(10px); opacity: 0; }

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

.status-badge {
  font-size: 0.72rem;
  font-weight: 700;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  text-transform: uppercase;
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
  padding: 0.45rem 1rem;
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
