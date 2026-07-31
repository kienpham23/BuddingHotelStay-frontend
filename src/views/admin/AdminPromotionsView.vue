<template>
  <div class="promo-page">

    <!-- ===== HEADER ===== -->
    <header class="promo-header">
      <div class="promo-header-inner">
        <div class="header-left">
          <RouterLink to="/" class="logo">
            <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="22" height="22" style="width: 22px; height: 22px; flex-shrink: 0; margin-right: 6px;">
              <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="logo-word building">Building</span>
            <span class="logo-word hotel">Hotel</span>
            <span class="logo-word stay">Stay</span>
          </RouterLink>
          <span class="divider-dot">/</span>
          <span class="panel-tag">{{ $t('admin.promotions') }}</span>
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
          <RouterLink to="/admin" class="btn-back">
            <ChevronLeft :size="15" /> {{ $t('admin.back_admin_btn') }}
          </RouterLink>
          <RouterLink to="/admin/revenue" class="btn-back btn-revenue">
            <BarChart2 :size="15" /> {{ $t('admin.revenue') }}
          </RouterLink>
          <span class="user-name" v-if="authStore.isLoggedIn">{{ authStore.user?.fullName }}</span>
          <button class="btn-outline" @click="handleLogout">{{ $t('admin.logout') }}</button>
        </div>
      </div>
    </header>

    <!-- ===== MAIN CONTENT ===== -->
    <main class="promo-main">

      <!-- Page title + create button -->
      <div class="page-title-row">
        <div class="page-title-left">
          <div class="page-icon-wrap">
            <Tag :size="24" />
          </div>
          <div>
            <h1>{{ $t('admin.promo_title') }}</h1>
            <p class="page-subtitle">{{ $t('admin.subtitle_promotions') }}</p>
          </div>
        </div>
        <button class="btn-create" @click="openCreateModal" id="btn-create-promo">
          <Plus :size="18" /> {{ $t('admin.btn_create_promo') }}
        </button>
      </div>

      <!-- Stats cards -->
      <div class="stats-row" v-if="!loading">
        <div class="stat-card">
          <div class="stat-icon-wrap s-blue"><Tag :size="20" /></div>
          <div class="stat-info">
            <span class="stat-val">{{ promotions.length }}</span>
            <span class="stat-label">{{ $t('admin.promotions') }}</span>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon-wrap s-green"><CheckCircle :size="20" /></div>
          <div class="stat-info">
            <span class="stat-val">{{ activeCount }}</span>
            <span class="stat-label">{{ $t('admin.active_promos') }}</span>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon-wrap s-amber"><AlertTriangle :size="20" /></div>
          <div class="stat-info">
            <span class="stat-val">{{ exhaustedCount }}</span>
            <span class="stat-label">{{ $t('admin.exhausted_promos') }}</span>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon-wrap s-gray"><Clock :size="20" /></div>
          <div class="stat-info">
            <span class="stat-val">{{ expiredCount }}</span>
            <span class="stat-label">{{ $t('admin.expired_promos') }}</span>
          </div>
        </div>
      </div>

      <!-- Loading -->
      <div class="loading-wrap" v-if="loading">
        <div class="spinner"></div>
        <p>{{ $t('admin.loading_report') }}</p>
      </div>

      <!-- Error banner -->
      <div class="err-banner" v-if="fetchError">
        <AlertCircle :size="16" /> {{ fetchError }}
        <button class="retry-btn" @click="fetchPromotions">{{ $t('admin.retry') }}</button>
      </div>

      <!-- Table -->
      <div class="table-wrap" v-if="!loading && !fetchError">
        <div class="table-container" v-if="promotions.length > 0">
          <table class="promo-table">
            <thead>
              <tr>
                <th>{{ $t('admin.col_promo_code') }}</th>
                <th>{{ $t('admin.col_description') }}</th>
                <th>{{ $t('admin.col_discount_type') }}</th>
                <th>{{ $t('admin.col_value') }}</th>
                <th>{{ $t('admin.col_usage') }}</th>
                <th>{{ $t('admin.col_duration') }}</th>
                <th>{{ $t('admin.col_status') }}</th>
                <th>{{ $t('admin.col_action') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="promo in promotions" :key="promo.id" class="table-row">
                <td>
                  <span class="code-badge">{{ promo.code }}</span>
                </td>
                <td>
                  <span class="desc-text">{{ promo.description || '—' }}</span>
                </td>
                <td>
                  <span class="type-pill" :class="promo.discountType === 'PERCENT' ? 'type-percent' : 'type-fixed'">
                    {{ promo.discountType === 'PERCENT' ? $t('admin.type_percent') : $t('admin.type_fixed') }}
                  </span>
                </td>
                <td>
                  <div class="value-cell">
                    <strong class="discount-val">
                      {{ promo.discountType === 'PERCENT' ? `${promo.discountValue}%` : fmtPrice(promo.discountValue) }}
                    </strong>
                    <small v-if="promo.discountType === 'PERCENT' && promo.maxDiscountAmount" class="max-note">
                      {{ $t('admin.max_discount') }} {{ fmtPrice(promo.maxDiscountAmount) }}
                    </small>
                    <small v-if="promo.minOrderAmount" class="min-note">
                      {{ $t('admin.min_order') }} {{ fmtPrice(promo.minOrderAmount) }}
                    </small>
                  </div>
                </td>
                <td>
                  <div class="usage-cell">
                    <div class="usage-bar-wrap">
                      <div class="usage-bar">
                        <div
                          class="usage-fill"
                          :style="{ width: usagePercent(promo) + '%' }"
                          :class="usagePercent(promo) >= 90 ? 'fill-red' : usagePercent(promo) >= 60 ? 'fill-amber' : 'fill-green'"
                        ></div>
                      </div>
                    </div>
                    <span class="usage-text">
                      {{ promo.usedCount }} / {{ promo.usageLimit ?? '∞' }}
                    </span>
                  </div>
                </td>
                <td>
                  <div class="date-cell">
                    <span class="date-row"><Calendar :size="11" /> {{ fmtDate(promo.startDate) }}</span>
                    <span class="date-sep">→</span>
                    <span class="date-row"><Calendar :size="11" /> {{ fmtDate(promo.endDate) }}</span>
                  </div>
                </td>
                <td>
                  <span class="status-badge" :class="getStatusClass(promo)">
                    {{ getStatusLabel(promo) }}
                  </span>
                </td>
                <td>
                  <div class="actions-cell">
                    <!-- Toggle active -->
                    <button
                      class="action-btn toggle-btn"
                      :class="promo.active ? 'toggle-on' : 'toggle-off'"
                      @click="toggleActive(promo)"
                      :title="promo.active ? $t('admin.btn_deactivate') : $t('admin.btn_activate')"
                      :disabled="togglingId === promo.id"
                    >
                      <component :is="promo.active ? ToggleRight : ToggleLeft" :size="18" />
                    </button>
                    <!-- Edit -->
                    <button class="action-btn edit-btn" @click="openEditModal(promo)" :title="$t('admin.btn_edit')">
                      <Pencil :size="15" />
                    </button>
                    <!-- Delete -->
                    <button class="action-btn delete-btn" @click="confirmDelete(promo)" :title="$t('admin.btn_delete_promo')">
                      <Trash2 :size="15" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Empty state -->
        <div class="empty-state" v-else>
          <div class="empty-icon"><Tag :size="52" /></div>
          <h3>{{ $t('admin.empty_promos') }}</h3>
          <p>{{ $t('admin.empty_promos_desc') }}</p>
          <button class="btn-create" @click="openCreateModal">
            <Plus :size="16" /> {{ $t('admin.btn_create_first_promo') }}
          </button>
        </div>
      </div>

    </main>

    <!-- ===== CREATE / EDIT MODAL ===== -->
    <Transition name="modal-fade">
      <div class="modal-backdrop" v-if="showFormModal" @click.self="closeModal">
        <div class="promo-modal">
          <div class="modal-header">
            <div class="modal-title-wrap">
              <div class="modal-icon" :class="isEditMode ? 'icon-edit' : 'icon-create'">
                <component :is="isEditMode ? Pencil : Plus" :size="18" />
              </div>
              <h2>{{ isEditMode ? $t('admin.edit_promo_title') : $t('admin.create_promo_title') }}</h2>
            </div>
            <button class="btn-close-modal" @click="closeModal">✕</button>
          </div>

          <form @submit.prevent="savePromo" class="modal-form" id="promo-form">

            <!-- Code + Active row -->
            <div class="form-row-2">
              <div class="fgroup" :class="{ ferr: formErr.code }">
                <label>{{ $t('admin.col_promo_code') }} <span class="req">*</span></label>
                <div class="inp-wrap">
                  <Tag :size="15" class="inp-ico" />
                  <input
                    v-model="form.code"
                    type="text"
                    placeholder="VD: SUMMER2026"
                    @input="form.code = form.code.toUpperCase()"
                    id="input-promo-code"
                  />
                </div>
                <span class="emsg" v-if="formErr.code">{{ formErr.code }}</span>
              </div>
              <div class="fgroup">
                <label>{{ $t('admin.col_status') }}</label>
                <label class="toggle-label">
                  <input type="checkbox" v-model="form.active" class="toggle-checkbox" />
                  <span class="toggle-track">
                    <span class="toggle-thumb"></span>
                  </span>
                  <span class="toggle-text">{{ form.active ? $t('admin.status_active_toggle') : $t('admin.status_inactive_toggle') }}</span>
                </label>
              </div>
            </div>

            <!-- Description -->
            <div class="fgroup">
              <label>{{ $t('admin.col_description') }} <span class="req">*</span></label>
              <input
                v-model="form.description"
                type="text"
                :placeholder="$t('admin.placeholder_desc')"
              />
              <span class="emsg" v-if="formErr.description">{{ formErr.description }}</span>
            </div>

            <!-- Discount type -->
            <div class="fgroup">
              <label>{{ $t('admin.col_discount_type') }} <span class="req">*</span></label>
              <div class="radio-group">
                <label class="radio-item" :class="{ 'radio-selected': form.discountType === 'PERCENT' }">
                  <input type="radio" v-model="form.discountType" value="PERCENT" />
                  <Percent :size="16" />
                  <span>{{ $t('admin.discount_percent_label') }}</span>
                </label>
                <label class="radio-item" :class="{ 'radio-selected': form.discountType === 'FIXED' }">
                  <input type="radio" v-model="form.discountType" value="FIXED" />
                  <Banknote :size="16" />
                  <span>{{ $t('admin.discount_fixed_label') }}</span>
                </label>
              </div>
            </div>

            <!-- Discount value + max discount (conditional) -->
            <div class="form-row-2">
              <div class="fgroup" :class="{ ferr: formErr.discountValue }">
                <label>
                  {{ $t('admin.discount_value_label') }}
                  <span class="unit-hint">{{ form.discountType === 'PERCENT' ? '(%)' : '(VND)' }}</span>
                  <span class="req">*</span>
                </label>
                <input
                  v-model.number="form.discountValue"
                  type="number"
                  min="1"
                  :max="form.discountType === 'PERCENT' ? 100 : undefined"
                  placeholder="VD: 10"
                />
                <span class="emsg" v-if="formErr.discountValue">{{ formErr.discountValue }}</span>
              </div>
              <Transition name="field-slide">
                <div class="fgroup" v-if="form.discountType === 'PERCENT'">
                  <label>{{ $t('admin.max_discount_label') }}</label>
                  <input
                    v-model.number="form.maxDiscountAmount"
                    type="number"
                    min="0"
                    :placeholder="$t('admin.max_discount_placeholder')"
                  />
                </div>
              </Transition>
            </div>

            <!-- Min order + usage limit -->
            <div class="form-row-2">
              <div class="fgroup">
                <label>{{ $t('admin.min_order_label') }}</label>
                <input
                  v-model.number="form.minOrderAmount"
                  type="number"
                  min="0"
                  placeholder="VD: 500000"
                />
              </div>
              <div class="fgroup">
                <label>{{ $t('admin.usage_limit_label') }}</label>
                <input
                  v-model.number="form.usageLimit"
                  type="number"
                  min="1"
                  :placeholder="$t('admin.limit_placeholder')"
                />
                <span class="hint-text">{{ $t('admin.limit_hint') }}</span>
              </div>
            </div>

            <!-- Date range -->
            <div class="form-row-2">
              <div class="fgroup" :class="{ ferr: formErr.startDate }">
                <label>{{ $t('admin.start_date_label') }} <span class="req">*</span></label>
                <div class="inp-wrap">
                  <Calendar :size="15" class="inp-ico" />
                  <input v-model="form.startDate" type="date" />
                </div>
                <span class="emsg" v-if="formErr.startDate">{{ formErr.startDate }}</span>
              </div>
              <div class="fgroup" :class="{ ferr: formErr.endDate }">
                <label>{{ $t('admin.end_date_label') }} <span class="req">*</span></label>
                <div class="inp-wrap">
                  <Calendar :size="15" class="inp-ico" />
                  <input v-model="form.endDate" type="date" />
                </div>
                <span class="emsg" v-if="formErr.endDate">{{ formErr.endDate }}</span>
              </div>
            </div>

            <!-- Submit error -->
            <div class="submit-err" v-if="formErr.submit">
              <AlertCircle :size="15" /> {{ formErr.submit }}
            </div>

            <!-- Actions -->
            <div class="modal-actions">
              <button type="button" class="btn-cancel" @click="closeModal">{{ $t('admin.btn_cancel') }}</button>
              <button type="submit" class="btn-submit" :disabled="formLoading" id="btn-submit-promo">
                <span v-if="!formLoading">
                  <component :is="isEditMode ? Save : Plus" :size="16" />
                  {{ isEditMode ? $t('admin.btn_save_changes') : $t('admin.btn_create') }}
                </span>
                <span v-else class="spinner-sm"></span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </Transition>

    <!-- ===== DELETE CONFIRM MODAL ===== -->
    <Transition name="modal-fade">
      <div class="modal-backdrop" v-if="showDeleteModal" @click.self="showDeleteModal = false">
        <div class="confirm-modal">
          <div class="confirm-icon">
            <Trash2 :size="28" />
          </div>
          <h3>{{ $t('admin.confirm_delete_promo_title') }}</h3>
          <p>
            {{ locale === 'en' ? 'Are you sure you want to delete promo code ' : 'Bạn có chắc muốn xóa mã ' }}
            <strong class="code-hl">{{ deleteTarget?.code }}</strong>
            {{ locale === 'en' ? '? This action cannot be undone.' : '? Hành động này không thể hoàn tác.' }}
          </p>
          <div class="confirm-actions">
            <button class="btn-cancel" @click="showDeleteModal = false">{{ $t('admin.btn_cancel_deletion') }}</button>
            <button class="btn-delete-confirm" @click="executeDelete" :disabled="deleteLoading" id="btn-confirm-delete">
              <span v-if="!deleteLoading"><Trash2 :size="15" /> {{ $t('admin.btn_delete_permanently') }}</span>
              <span v-else class="spinner-sm"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

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
  Tag, Plus, Pencil, Trash2, CheckCircle, AlertCircle, AlertTriangle,
  Clock, Calendar, ChevronLeft, BarChart2,
  ToggleLeft, ToggleRight, Percent, Banknote, Save
} from 'lucide-vue-next'

const { t, locale } = useI18n()

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const router = useRouter()
const authStore = useAuthStore()

// ─── Data
const promotions = ref([])
const loading = ref(true)
const fetchError = ref('')

// ─── Computed stats
const activeCount = computed(() =>
  promotions.value.filter(p => p.active && !p.isExpired && !p.isExhausted).length
)
const exhaustedCount = computed(() =>
  promotions.value.filter(p => p.isExhausted).length
)
const expiredCount = computed(() =>
  promotions.value.filter(p => p.isExpired).length
)

// ─── Toast
const toast = ref({ show: false, type: 'success', message: '' })
const showToast = (message, type = 'success') => {
  toast.value = { show: true, type, message }
  setTimeout(() => { toast.value.show = false }, 3500)
}

// ─── Fetch
const fetchPromotions = async () => {
  loading.value = true
  fetchError.value = ''
  try {
    const res = await axios.get('/admin/promotions')
    promotions.value = res.data
  } catch (err) {
    fetchError.value = err.response?.data?.message || 'Không thể tải danh sách mã khuyến mãi.'
  } finally {
    loading.value = false
  }
}

onMounted(fetchPromotions)

// ─── Formatters
const fmtPrice = (n) => {
  const currentLocale = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Intl.NumberFormat(currentLocale, { style: 'currency', currency: 'VND' }).format(n ?? 0)
}

const fmtDate = (d) => {
  if (!d) return '—'
  const currentLocale = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Date(d + 'T00:00:00').toLocaleDateString(currentLocale, {
    day: '2-digit', month: '2-digit', year: 'numeric'
  })
}

// ─── Status helpers
const getStatusLabel = (promo) => {
  if (!promo.active) return t('admin.status_inactive_toggle')
  if (promo.isExpired) return t('admin.expired_promos')
  if (promo.isExhausted) return t('admin.exhausted_promos')
  return t('admin.status_active')
}

const getStatusClass = (promo) => {
  if (!promo.active) return 'status-off'
  if (promo.isExpired) return 'status-expired'
  if (promo.isExhausted) return 'status-exhausted'
  return 'status-active'
}

const usagePercent = (promo) => {
  if (!promo.usageLimit) return 0
  return Math.min(100, Math.round((promo.usedCount / promo.usageLimit) * 100))
}

// ─── Toggle active
const togglingId = ref(null)
const toggleActive = async (promo) => {
  togglingId.value = promo.id
  try {
    await axios.patch(`/admin/promotions/${promo.id}/toggle-active`)
    promo.active = !promo.active
    showToast(`Mã ${promo.code} đã được ${promo.active ? 'bật' : 'tắt'} thành công.`)
  } catch (err) {
    showToast(err.response?.data?.message || 'Không thể thay đổi trạng thái mã.', 'error')
  } finally {
    togglingId.value = null
  }
}

// ─── Modal form state
const showFormModal = ref(false)
const isEditMode = ref(false)
const formLoading = ref(false)
const formErr = ref({})
const editingId = ref(null)

const defaultForm = () => ({
  code: '',
  description: '',
  discountType: 'PERCENT',
  discountValue: null,
  maxDiscountAmount: null,
  minOrderAmount: null,
  startDate: '',
  endDate: '',
  usageLimit: null,
  active: true,
})

const form = ref(defaultForm())

const openCreateModal = () => {
  isEditMode.value = false
  editingId.value = null
  form.value = defaultForm()
  formErr.value = {}
  showFormModal.value = true
}

const openEditModal = (promo) => {
  isEditMode.value = true
  editingId.value = promo.id
  form.value = {
    code: promo.code,
    description: promo.description || '',
    discountType: promo.discountType,
    discountValue: promo.discountValue,
    maxDiscountAmount: promo.maxDiscountAmount ?? null,
    minOrderAmount: promo.minOrderAmount ?? null,
    startDate: promo.startDate || '',
    endDate: promo.endDate || '',
    usageLimit: promo.usageLimit ?? null,
    active: promo.active,
  }
  formErr.value = {}
  showFormModal.value = true
}

const closeModal = () => {
  showFormModal.value = false
}

// ─── Validation
const validateForm = () => {
  const e = {}
  if (!form.value.code.trim()) e.code = 'Vui lòng nhập mã khuyến mãi'
  else if (!/^[A-Z0-9_-]{2,30}$/.test(form.value.code)) e.code = 'Mã chỉ gồm chữ hoa, số, - hoặc _ (2-30 ký tự)'
  if (!form.value.description.trim()) e.description = 'Vui lòng nhập mô tả'
  if (!form.value.discountValue || form.value.discountValue <= 0) e.discountValue = 'Giá trị giảm phải lớn hơn 0'
  if (form.value.discountType === 'PERCENT' && form.value.discountValue > 100) e.discountValue = 'Phần trăm không được vượt quá 100%'
  if (!form.value.startDate) e.startDate = 'Vui lòng chọn ngày bắt đầu'
  if (!form.value.endDate) e.endDate = 'Vui lòng chọn ngày kết thúc'
  if (form.value.startDate && form.value.endDate && form.value.startDate > form.value.endDate) {
    e.endDate = 'Ngày kết thúc phải sau ngày bắt đầu'
  }
  formErr.value = e
  return Object.keys(e).length === 0
}

// ─── Save (create or edit)
const savePromo = async () => {
  if (!validateForm()) return
  formLoading.value = true
  formErr.value = {}

  const payload = {
    code: form.value.code.trim(),
    description: form.value.description.trim(),
    discountType: form.value.discountType,
    discountValue: form.value.discountValue,
    maxDiscountAmount: form.value.discountType === 'PERCENT' ? (form.value.maxDiscountAmount || null) : null,
    minOrderAmount: form.value.minOrderAmount || null,
    startDate: form.value.startDate,
    endDate: form.value.endDate,
    usageLimit: form.value.usageLimit || null,
    active: form.value.active,
  }

  try {
    if (isEditMode.value) {
      const res = await axios.put(`/admin/promotions/${editingId.value}`, payload)
      const idx = promotions.value.findIndex(p => p.id === editingId.value)
      if (idx !== -1) promotions.value[idx] = res.data
      showToast(`Đã cập nhật mã ${payload.code} thành công!`)
    } else {
      const res = await axios.post('/admin/promotions', payload)
      promotions.value.unshift(res.data)
      showToast(`Đã tạo mã ${payload.code} thành công!`)
    }
    closeModal()
  } catch (err) {
    formErr.value.submit = err.response?.data?.message || 'Có lỗi xảy ra. Vui lòng thử lại.'
  } finally {
    formLoading.value = false
  }
}

// ─── Delete
const showDeleteModal = ref(false)
const deleteTarget = ref(null)
const deleteLoading = ref(false)

const confirmDelete = (promo) => {
  deleteTarget.value = promo
  showDeleteModal.value = true
}

const executeDelete = async () => {
  if (!deleteTarget.value) return
  deleteLoading.value = true
  try {
    await axios.delete(`/admin/promotions/${deleteTarget.value.id}`)
    promotions.value = promotions.value.filter(p => p.id !== deleteTarget.value.id)
    showToast(`Đã xóa mã ${deleteTarget.value.code}.`)
    showDeleteModal.value = false
  } catch (err) {
    showToast(err.response?.data?.message || 'Không thể xóa mã khuyến mãi.', 'error')
  } finally {
    deleteLoading.value = false
    deleteTarget.value = null
  }
}

// ─── Logout
const handleLogout = () => {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

/* ── Variables ── */
:root {
  --blue: #5392f9;
  --red: #ff567d;
  --green: #10b981;
  --amber: #f59e0b;
  --gray: #6b7280;
  --dark: #2a2a2e;
}

.promo-page {
  font-family: 'Inter', sans-serif;
  background: #f2f4f9;
  min-height: 100vh;
  color: var(--dark);
}

/* ── HEADER ── */
.promo-header {
  background: #fff;
  border-bottom: 1px solid #e5e7eb;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 12px rgba(0,0,0,.05);
}
.promo-header-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: .85rem 1.75rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}
.header-left {
  display: flex;
  align-items: center;
  gap: .75rem;
}
.logo {
  font-size: 1.35rem;
  font-weight: 800;
  color: #5392f9;
  text-decoration: none;
  letter-spacing: -.05em;
  white-space: nowrap;
}
.logo-red { color: #ff567d; }
.divider-dot { color: #d1d5db; font-weight: 300; }
.panel-tag {
  font-size: .8rem;
  font-weight: 700;
  color: #6b7280;
  background: #f3f4f6;
  padding: .25rem .65rem;
  border-radius: 999px;
}
.header-right {
  display: flex;
  align-items: center;
  gap: .75rem;
}
.btn-back {
  display: inline-flex;
  align-items: center;
  gap: .3rem;
  font-size: .8rem;
  font-weight: 600;
  color: #6b7280;
  text-decoration: none;
  padding: .4rem .85rem;
  border-radius: 8px;
  background: #f3f4f6;
  transition: all .2s;
  white-space: nowrap;
}
.btn-back:hover { background: #e5e7eb; color: var(--dark); }
.btn-revenue { color: #5392f9; background: rgba(83,146,249,.08); }
.btn-revenue:hover { background: rgba(83,146,249,.15); }
.user-name {
  font-size: .8rem;
  font-weight: 700;
  color: var(--dark);
  white-space: nowrap;
}
.btn-outline {
  font-size: .8rem;
  font-weight: 700;
  color: #ff567d;
  border: 1.5px solid #ff567d;
  background: none;
  padding: .4rem .85rem;
  border-radius: 8px;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  transition: all .2s;
  white-space: nowrap;
}
.btn-outline:hover { background: #ff567d; color: #fff; }

/* ── MAIN ── */
.promo-main {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem 1.75rem;
}

/* Page title */
.page-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 1.75rem;
}
.page-title-left {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.page-icon-wrap {
  width: 52px;
  height: 52px;
  border-radius: 15px;
  background: linear-gradient(135deg, #5392f9, #7c3aed);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 20px rgba(83,146,249,.3);
  flex-shrink: 0;
}
.page-title-left h1 {
  font-size: 1.45rem;
  font-weight: 800;
  color: var(--dark);
  line-height: 1.2;
}
.page-subtitle {
  font-size: .82rem;
  color: #6b7280;
  margin-top: .2rem;
}

/* Create button */
.btn-create {
  display: inline-flex;
  align-items: center;
  gap: .5rem;
  padding: .75rem 1.5rem;
  border-radius: 12px;
  background: linear-gradient(135deg, #5392f9, #7c3aed);
  color: #fff;
  border: none;
  font-size: .9rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  box-shadow: 0 6px 20px rgba(83,146,249,.35);
  transition: all .2s;
  white-space: nowrap;
}
.btn-create:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(83,146,249,.45); }

/* Stats row */
.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
  margin-bottom: 1.75rem;
}
.stat-card {
  background: #fff;
  border-radius: 16px;
  padding: 1.15rem 1.35rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  border: 1px solid #e5e7eb;
  box-shadow: 0 2px 12px rgba(0,0,0,.04);
  transition: box-shadow .2s;
}
.stat-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,.08); }
.stat-icon-wrap {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.s-blue { background: rgba(83,146,249,.12); color: #5392f9; }
.s-green { background: rgba(16,185,129,.12); color: #10b981; }
.s-amber { background: rgba(245,158,11,.12); color: #f59e0b; }
.s-gray { background: rgba(107,114,128,.1); color: #6b7280; }
.stat-info { display: flex; flex-direction: column; gap: .1rem; }
.stat-val { font-size: 1.6rem; font-weight: 800; line-height: 1; color: var(--dark); }
.stat-label { font-size: .72rem; font-weight: 600; color: #6b7280; }

/* Loading */
.loading-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 4rem;
  color: #6b7280;
}

/* Error banner */
.err-banner {
  display: flex;
  align-items: center;
  gap: .6rem;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 12px;
  padding: .9rem 1.25rem;
  color: #dc2626;
  font-size: .85rem;
  font-weight: 600;
  margin-bottom: 1rem;
}
.retry-btn {
  margin-left: auto;
  background: #dc2626;
  color: #fff;
  border: none;
  padding: .3rem .75rem;
  border-radius: 7px;
  font-size: .75rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
}

/* Table */
.table-wrap { background: #fff; border-radius: 20px; border: 1px solid #e5e7eb; overflow: hidden; box-shadow: 0 4px 24px rgba(0,0,0,.06); }
.table-container { overflow-x: auto; }
.promo-table { width: 100%; border-collapse: collapse; min-width: 900px; }
.promo-table thead tr { background: linear-gradient(135deg, #f8f9ff, #f0f4ff); border-bottom: 1.5px solid #e5e7eb; }
.promo-table th {
  padding: 1rem 1.1rem;
  font-size: .7rem;
  font-weight: 800;
  color: #6b7280;
  text-align: left;
  letter-spacing: .06em;
  text-transform: uppercase;
  white-space: nowrap;
}
.promo-table tbody tr {
  border-bottom: 1px solid #f3f4f6;
  transition: background .15s;
}
.promo-table tbody tr:last-child { border-bottom: none; }
.promo-table tbody tr:hover { background: #fafbff; }
.promo-table td { padding: .9rem 1.1rem; vertical-align: middle; }

/* Code badge */
.code-badge {
  font-family: 'Courier New', monospace;
  font-size: .8rem;
  font-weight: 800;
  background: linear-gradient(135deg, #eff6ff, #f0f4ff);
  color: #3b4fd1;
  border: 1.5px solid #c7d2fe;
  padding: .3rem .7rem;
  border-radius: 7px;
  letter-spacing: .04em;
  white-space: nowrap;
}

/* Type pill */
.type-pill {
  font-size: .7rem;
  font-weight: 700;
  padding: .25rem .65rem;
  border-radius: 999px;
  white-space: nowrap;
}
.type-percent { background: #dbeafe; color: #1d4ed8; }
.type-fixed { background: #d1fae5; color: #065f46; }

/* Value cell */
.value-cell { display: flex; flex-direction: column; gap: .15rem; }
.discount-val { font-size: .9rem; font-weight: 800; color: var(--dark); }
.max-note, .min-note { font-size: .68rem; color: #9ca3af; }

/* Usage cell */
.usage-cell { display: flex; flex-direction: column; gap: .35rem; min-width: 110px; }
.usage-bar-wrap {}
.usage-bar { height: 5px; background: #f3f4f6; border-radius: 999px; overflow: hidden; }
.usage-fill { height: 100%; border-radius: 999px; transition: width .3s; }
.fill-green { background: #10b981; }
.fill-amber { background: #f59e0b; }
.fill-red { background: #ef4444; }
.usage-text { font-size: .75rem; font-weight: 700; color: #374151; }

/* Date cell */
.date-cell { display: flex; flex-direction: column; gap: .15rem; font-size: .75rem; }
.date-row { display: flex; align-items: center; gap: .3rem; color: #374151; font-weight: 600; }
.date-sep { color: #9ca3af; font-size: .65rem; }

/* Status badge */
.status-badge {
  display: inline-flex;
  align-items: center;
  gap: .3rem;
  font-size: .72rem;
  font-weight: 800;
  padding: .35rem .8rem;
  border-radius: 999px;
  white-space: nowrap;
}
.status-badge::before {
  content: '';
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: currentColor;
}
.status-active { background: #d1fae5; color: #065f46; }
.status-exhausted { background: #fef3c7; color: #92400e; }
.status-expired { background: #f3f4f6; color: #4b5563; }
.status-off { background: #fee2e2; color: #991b1b; }

/* Desc */
.desc-text { font-size: .8rem; color: #374151; max-width: 220px; display: block; }

/* Actions */
.actions-cell { display: flex; align-items: center; gap: .4rem; }
.action-btn {
  width: 34px;
  height: 34px;
  border-radius: 9px;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all .2s;
  font-family: 'Inter', sans-serif;
}
.toggle-btn { background: #f3f4f6; }
.toggle-on { background: rgba(16,185,129,.12); color: #10b981; }
.toggle-off { background: rgba(239,68,68,.08); color: #ef4444; }
.toggle-btn:hover { transform: scale(1.1); }
.toggle-btn:disabled { opacity: .5; cursor: not-allowed; transform: none; }
.edit-btn { background: rgba(83,146,249,.1); color: #5392f9; }
.edit-btn:hover { background: #5392f9; color: #fff; }
.delete-btn { background: rgba(255,86,125,.08); color: #ff567d; }
.delete-btn:hover { background: #ff567d; color: #fff; }

/* Empty state */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 5rem 2rem;
  color: #9ca3af;
  text-align: center;
}
.empty-icon {
  width: 80px;
  height: 80px;
  border-radius: 20px;
  background: #f3f4f6;
  display: flex;
  align-items: center;
  justify-content: center;
}
.empty-state h3 { font-size: 1.1rem; font-weight: 700; color: #374151; }
.empty-state p { font-size: .85rem; max-width: 300px; line-height: 1.6; }

/* ── MODAL ── */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,.55);
  backdrop-filter: blur(6px);
  z-index: 200;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

.promo-modal {
  background: #fff;
  border-radius: 22px;
  width: 100%;
  max-width: 620px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 40px 100px rgba(0,0,0,.25);
  animation: modalIn .3s cubic-bezier(.34,1.56,.64,1);
}
@keyframes modalIn { from { transform: scale(.9) translateY(20px); opacity: 0; } to { transform: scale(1) translateY(0); opacity: 1; } }

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem 1.75rem 0;
}
.modal-title-wrap { display: flex; align-items: center; gap: .85rem; }
.modal-icon {
  width: 42px;
  height: 42px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}
.icon-create { background: linear-gradient(135deg, #5392f9, #7c3aed); }
.icon-edit { background: linear-gradient(135deg, #f59e0b, #ef4444); }
.modal-header h2 { font-size: 1.1rem; font-weight: 800; }
.btn-close-modal {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  border: 1.5px solid #e5e7eb;
  background: #fff;
  cursor: pointer;
  font-size: .9rem;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all .2s;
  font-family: 'Inter', sans-serif;
}
.btn-close-modal:hover { background: #f3f4f6; }

.modal-form {
  padding: 1.5rem 1.75rem 1.75rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* Form groups */
.fgroup { display: flex; flex-direction: column; gap: .35rem; }
.fgroup label {
  font-size: .7rem;
  font-weight: 700;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: .06em;
  display: flex;
  align-items: center;
  gap: .35rem;
}
.req { color: #ef4444; font-weight: 800; }
.unit-hint { font-weight: 600; color: #5392f9; font-size: .65rem; text-transform: none; letter-spacing: 0; }
.fgroup input, .fgroup select {
  width: 100%;
  padding: .65rem .95rem;
  border: 1.5px solid #e5e7eb;
  border-radius: 11px;
  font-size: .875rem;
  font-weight: 500;
  color: var(--dark);
  font-family: 'Inter', sans-serif;
  background: #f9fafb;
  outline: none;
  transition: all .2s;
}
.fgroup input:focus, .fgroup select:focus {
  border-color: #5392f9;
  background: #fff;
  box-shadow: 0 0 0 3px rgba(83,146,249,.1);
}
.fgroup.ferr input { border-color: #ef4444; background: #fff5f5; }
.emsg { font-size: .72rem; color: #ef4444; font-weight: 600; }
.hint-text { font-size: .68rem; color: #9ca3af; font-weight: 500; }

.inp-wrap { position: relative; }
.inp-wrap input { padding-left: 2.2rem; }
.inp-ico { position: absolute; left: .7rem; top: 50%; transform: translateY(-50%); color: #9ca3af; pointer-events: none; }

.form-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

/* Radio group */
.radio-group { display: grid; grid-template-columns: 1fr 1fr; gap: .65rem; }
.radio-item {
  display: flex;
  align-items: center;
  gap: .6rem;
  padding: .75rem 1rem;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  cursor: pointer;
  font-size: .85rem;
  font-weight: 600;
  color: #6b7280;
  transition: all .2s;
  background: #f9fafb;
}
.radio-item input { display: none; }
.radio-selected { border-color: #5392f9; background: rgba(83,146,249,.05); color: #5392f9; }
.radio-item:hover { border-color: rgba(83,146,249,.5); }

/* Toggle switch */
.toggle-label {
  display: flex;
  align-items: center;
  gap: .75rem;
  cursor: pointer;
  text-transform: none !important;
  font-size: .875rem !important;
  font-weight: 600 !important;
  color: var(--dark) !important;
  letter-spacing: 0 !important;
  padding-top: .35rem;
}
.toggle-checkbox { display: none; }
.toggle-track {
  width: 44px;
  height: 24px;
  border-radius: 999px;
  background: #d1d5db;
  position: relative;
  transition: background .2s;
  flex-shrink: 0;
}
.toggle-checkbox:checked + .toggle-track { background: #10b981; }
.toggle-thumb {
  position: absolute;
  top: 3px;
  left: 3px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0,0,0,.2);
  transition: transform .2s;
}
.toggle-checkbox:checked + .toggle-track .toggle-thumb { transform: translateX(20px); }
.toggle-text { font-size: .82rem; font-weight: 600; color: #374151; }

/* Submit err */
.submit-err {
  display: flex;
  align-items: center;
  gap: .5rem;
  font-size: .8rem;
  font-weight: 600;
  color: #dc2626;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 10px;
  padding: .65rem .9rem;
}

/* Modal actions */
.modal-actions { display: flex; gap: .75rem; justify-content: flex-end; padding-top: .5rem; }
.btn-cancel {
  padding: .7rem 1.4rem;
  border-radius: 11px;
  border: 1.5px solid #e5e7eb;
  background: #fff;
  color: #6b7280;
  font-size: .875rem;
  font-weight: 600;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  transition: all .2s;
}
.btn-cancel:hover { border-color: var(--dark); color: var(--dark); }
.btn-submit {
  display: inline-flex;
  align-items: center;
  gap: .5rem;
  padding: .7rem 1.6rem;
  border-radius: 11px;
  background: linear-gradient(135deg, #5392f9, #7c3aed);
  color: #fff;
  border: none;
  font-size: .875rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  box-shadow: 0 4px 14px rgba(83,146,249,.3);
  transition: all .2s;
}
.btn-submit:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 7px 20px rgba(83,146,249,.4); }
.btn-submit:disabled { opacity: .65; cursor: not-allowed; transform: none; }

/* Confirm modal */
.confirm-modal {
  background: #fff;
  border-radius: 22px;
  padding: 2.25rem 2rem;
  max-width: 420px;
  width: 100%;
  text-align: center;
  box-shadow: 0 40px 100px rgba(0,0,0,.25);
  animation: modalIn .3s cubic-bezier(.34,1.56,.64,1);
}
.confirm-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: #fee2e2;
  color: #ef4444;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.1rem;
}
.confirm-modal h3 { font-size: 1.1rem; font-weight: 800; margin-bottom: .5rem; }
.confirm-modal p { font-size: .875rem; color: #6b7280; line-height: 1.6; margin-bottom: 1.5rem; }
.code-hl { color: #3b4fd1; }
.confirm-actions { display: flex; gap: .75rem; justify-content: center; }
.btn-delete-confirm {
  display: inline-flex;
  align-items: center;
  gap: .45rem;
  padding: .7rem 1.5rem;
  border-radius: 11px;
  background: linear-gradient(135deg, #ef4444, #dc2626);
  color: #fff;
  border: none;
  font-size: .875rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  box-shadow: 0 4px 14px rgba(239,68,68,.3);
  transition: all .2s;
}
.btn-delete-confirm:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 7px 20px rgba(239,68,68,.4); }
.btn-delete-confirm:disabled { opacity: .65; cursor: not-allowed; transform: none; }

/* Spinner */
.spinner {
  width: 36px; height: 36px;
  border: 3px solid #e5e7eb;
  border-top-color: #5392f9;
  border-radius: 50%;
  animation: spin .7s linear infinite;
}
.spinner-sm {
  display: inline-block;
  width: 18px; height: 18px;
  border: 2.5px solid rgba(255,255,255,.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin .7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* Toast */
.toast {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  z-index: 999;
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

/* Transitions */
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity .25s ease; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
.toast-slide-enter-active { transition: all .35s cubic-bezier(.34,1.56,.64,1); }
.toast-slide-leave-active { transition: all .25s ease; }
.toast-slide-enter-from { transform: translateY(20px); opacity: 0; }
.toast-slide-leave-to { transform: translateY(10px); opacity: 0; }
.field-slide-enter-active { transition: all .25s ease; }
.field-slide-leave-active { transition: all .2s ease; }
.field-slide-enter-from, .field-slide-leave-to { opacity: 0; transform: translateX(10px); }

/* Responsive */
@media (max-width: 900px) {
  .stats-row { grid-template-columns: repeat(2, 1fr); }
  .form-row-2 { grid-template-columns: 1fr; }
  .promo-main { padding: 1.25rem 1rem; }
  .page-title-row { flex-direction: column; align-items: flex-start; }
}
@media (max-width: 600px) {
  .stats-row { grid-template-columns: 1fr 1fr; }
  .header-right .btn-revenue { display: none; }
  .radio-group { grid-template-columns: 1fr; }
}
</style>
