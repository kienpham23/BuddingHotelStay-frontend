<template>
  <div class="excel-panel">
    <!-- Panel Header -->
    <div class="excel-panel-header">
      <div class="excel-panel-title">
        <span class="excel-icon"><BarChart3 :size="22" /></span>
        <div>
          <h3>{{ $t('host.excel.panel_title') }}</h3>
          <p>{{ $t('host.excel.panel_subtitle') }}</p>
        </div>
      </div>
    </div>

    <!-- Date Range Picker + Action Buttons Row -->
    <div class="excel-actions-row">
      <!-- Nút 1: Xuất Excel đặt phòng (kèm bộ chọn ngày) -->
      <div class="export-bookings-wrap">
        <!-- Bộ chọn khoảng ngày -->
        <div class="date-range-row">
          <div class="date-field">
            <label for="export-start-date" class="date-label">{{ $t('host.excel.date_start') }}</label>
            <input
              type="date"
              id="export-start-date"
              class="date-input"
              v-model="startDate"
            />
          </div>
          <div class="date-field">
            <label for="export-end-date" class="date-label">{{ $t('host.excel.date_end') }}</label>
            <input
              type="date"
              id="export-end-date"
              class="date-input"
              v-model="endDate"
            />
          </div>
        </div>

        <!-- Ghi chú -->
        <p class="export-note">
          {{ $t('host.excel.export_note') }}
        </p>

        <!-- Thông báo lỗi validate -->
        <p v-if="exportDateError" class="export-date-error">{{ exportDateError }}</p>

        <!-- Nút xuất -->
        <button
          class="excel-btn excel-btn--export"
          @click="exportBookings"
          :disabled="exportingBookings"
          id="btn-export-bookings"
        >
          <span class="excel-btn-inner">
            <span v-if="!exportingBookings" class="btn-icon"><Download :size="20" /></span>
            <span v-else class="spinner-small"></span>
            <span>
              <span class="btn-label">{{ exportingBookings ? $t('host.excel.exporting_btn') : $t('host.excel.export_btn') }}</span>
              <span class="btn-desc">{{ $t('host.excel.export_desc') }}</span>
            </span>
          </span>
        </button>
      </div>

      <!-- Nút 2: Tải mẫu Excel nhập phòng -->
      <button
        class="excel-btn excel-btn--template"
        @click="downloadRoomTemplate"
        :disabled="downloadingTemplate"
        id="btn-download-template"
      >
        <span class="excel-btn-inner">
          <span v-if="!downloadingTemplate" class="btn-icon"><FileSpreadsheet :size="20" /></span>
          <span v-else class="spinner-small"></span>
          <span>
            <span class="btn-label">{{ downloadingTemplate ? $t('host.excel.downloading_btn') : $t('host.excel.template_btn') }}</span>
            <span class="btn-desc">{{ $t('host.excel.template_desc') }}</span>
          </span>
        </span>
      </button>
    </div>

    <!-- Import Section -->
    <div class="import-section">
      <div class="import-section-header">
        <span class="import-section-icon"><Upload :size="18" /></span>
        <div>
          <p class="import-section-title">{{ $t('host.excel.import_title') }}</p>
          <p class="import-section-desc">{{ $t('host.excel.import_desc') }}</p>
        </div>
      </div>

      <!-- Dropzone (chỉ hiện khi chưa có kết quả) -->
      <div
        v-if="!importResult"
        class="excel-dropzone"
        :class="{
          'is-dragging': isDraggingExcel,
          'is-loading': importingFile
        }"
        @dragover.prevent="isDraggingExcel = true"
        @dragleave.prevent="isDraggingExcel = false"
        @drop.prevent="handleExcelDrop"
        @click="!importingFile && triggerExcelInput()"
        id="excel-dropzone"
      >
        <input
          type="file"
          ref="excelFileInput"
          accept=".xlsx"
          class="hidden-input"
          @change="handleExcelSelect"
          id="excel-file-input"
        />

        <!-- Trạng thái bình thường -->
        <div v-if="!importingFile" class="dropzone-body">
          <div class="dropzone-icon-wrap">
            <FolderOpen :size="28" class="dropzone-big-icon" />
          </div>
          <p class="dropzone-main-text">{{ $t('host.excel.dropzone_main') }}</p>
          <p class="dropzone-sub-text">hoặc <strong>{{ $t('host.excel.dropzone_sub') }}</strong></p>
          <div class="dropzone-format-badge">{{ $t('host.excel.dropzone_badge') }}</div>
        </div>

        <!-- Trạng thái đang xử lý -->
        <div v-else class="dropzone-loading">
          <div class="loading-spinner-lg"></div>
          <p class="loading-text">{{ $t('host.excel.processing') }}</p>
          <p class="loading-subtext">{{ $t('host.excel.processing_sub') }}</p>
        </div>
      </div>

      <!-- Kết quả import -->
      <div v-if="importResult" class="import-result">
        <!-- Banner tổng kết -->
        <div
          class="result-banner"
          :class="{
            'banner--success': importResult.errorCount === 0,
            'banner--partial': importResult.errorCount > 0 && importResult.successCount > 0,
            'banner--error':   importResult.successCount === 0 && importResult.errorCount > 0
          }"
        >
          <span class="banner-icon">
            <CheckCircle2 v-if="importResult.errorCount === 0" :size="20" class="icon-success" />
            <XCircle v-else-if="importResult.successCount === 0" :size="20" class="icon-error" />
            <AlertCircle v-else :size="20" class="icon-warning" />
          </span>
          <div class="banner-text">
            <strong>{{ $t('host.excel.processed_rows', { count: importResult.totalRows }) }}</strong>
            <span class="banner-stats">
              <span class="stat-success">{{ $t('host.excel.success_count', { count: importResult.successCount }) }}</span>
              <span class="stat-divider">,</span>
              <span class="stat-error">{{ $t('host.excel.error_count', { count: importResult.errorCount }) }}</span>
            </span>
          </div>
        </div>

        <!-- Danh sách thành công -->
        <div v-if="importResult.successCount > 0" class="result-list-section">
          <div class="result-list-header result-list-header--success">
            <CheckCircle2 :size="13" style="vertical-align: middle; margin-right: 4px;" /> {{ $t('host.excel.result_success_header', { count: importResult.successCount }) }}
          </div>
          <div class="result-list">
            <div
              v-for="(msg, idx) in importResult.successes"
              :key="'s-' + idx"
              class="result-item result-item--success"
            >
              <Check :size="13" class="result-item-icon" />
              <span class="result-item-text">{{ msg }}</span>
            </div>
          </div>
        </div>

        <!-- Danh sách lỗi -->
        <div v-if="importResult.errorCount > 0" class="result-list-section">
          <div class="result-list-header result-list-header--error">
            <AlertCircle :size="13" style="vertical-align: middle; margin-right: 4px;" /> {{ $t('host.excel.result_error_header', { count: importResult.errorCount }) }}
          </div>
          <div class="result-list">
            <div
              v-for="(msg, idx) in importResult.errors"
              :key="'e-' + idx"
              class="result-item result-item--error"
            >
              <X :size="13" class="result-item-icon" />
              <span class="result-item-text">{{ msg }}</span>
            </div>
          </div>
        </div>

        <!-- Nút hành động -->
        <div class="result-actions">
          <button class="excel-btn-sm excel-btn-sm--ghost" @click="closeImportResult" id="btn-close-result">
            {{ $t('host.excel.btn_close') }}
          </button>
          <button class="excel-btn-sm excel-btn-sm--primary" @click="resetForNewUpload" id="btn-upload-another">
            <Paperclip :size="14" style="vertical-align: middle; margin-right: 4px;" /> {{ $t('host.excel.btn_upload_another') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from '../../api/axios'
import { useI18n } from 'vue-i18n'
import {
  BarChart3, Download, FileSpreadsheet, Upload,
  FolderOpen, CheckCircle2, XCircle, AlertCircle,
  Check, X, Paperclip
} from 'lucide-vue-next'

const { t } = useI18n()

// Emit sự kiện để parent (HostRoomsView) cập nhật danh sách phòng
const emit = defineEmits(['rooms-updated'])

// ========================
// STATE
// ========================
const exportingBookings   = ref(false)
const downloadingTemplate = ref(false)
const importingFile       = ref(false)
const isDraggingExcel     = ref(false)
const excelFileInput      = ref(null)
const importResult        = ref(null)
const exportDateError     = ref('')

// Giá trị mặc định: đầu và cuối tháng hiện tại
const _now = new Date()
const _yyyy = _now.getFullYear()
const _mm   = String(_now.getMonth() + 1).padStart(2, '0')
const _lastDay = new Date(_now.getFullYear(), _now.getMonth() + 1, 0).getDate()
const startDate = ref(`${_yyyy}-${_mm}-01`)
const endDate   = ref(`${_yyyy}-${_mm}-${String(_lastDay).padStart(2, '0')}`)

// ========================
// HELPERS
// ========================

/** Trả về ngày hiện tại định dạng YYYY-MM-DD */
const today = () => {
  const d    = new Date()
  const yyyy = d.getFullYear()
  const mm   = String(d.getMonth() + 1).padStart(2, '0')
  const dd   = String(d.getDate()).padStart(2, '0')
  return `${yyyy}-${mm}-${dd}`
}

/**
 * Kích hoạt tải file về máy từ Blob (không dùng thư viện ngoài).
 * @param {Blob}   blob     - dữ liệu nhị phân nhận từ server
 * @param {string} filename - tên file khi lưu xuống
 */
const downloadBlob = (blob, filename) => {
  const url = URL.createObjectURL(blob)
  const a   = document.createElement('a')
  a.href     = url
  a.download = filename
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
  URL.revokeObjectURL(url)
}

// ========================
// 1) XUẤT EXCEL ĐẶT PHÒNG
// ========================
const exportBookings = async () => {
  // Validate trước khi gọi API
  exportDateError.value = ''
  if (!startDate.value || !endDate.value) {
    exportDateError.value = '⚠️ ' + t('host.excel.validation_date_missing')
    return
  }
  if (endDate.value < startDate.value) {
    exportDateError.value = '⚠️ ' + t('host.excel.validation_date_invalid')
    return
  }

  exportingBookings.value = true
  try {
    // QUAN TRỌNG: phải đặt responseType: 'blob' vì đây là file nhị phân .xlsx
    const res = await axios.get('/excel/host/export-bookings', {
      params: { startDate: startDate.value, endDate: endDate.value },
      responseType: 'blob'
    })
    downloadBlob(res.data, `MyBookings_${startDate.value}_${endDate.value}.xlsx`)
  } catch (err) {
    const msg = err.response?.data?.message || err.message || ''
    alert('❌ ' + t('host.excel.export_failed_msg') + msg)
  } finally {
    exportingBookings.value = false
  }
}

// ========================
// 2) TẢI MẪU EXCEL NHẬP PHÒNG
// ========================
const downloadRoomTemplate = async () => {
  downloadingTemplate.value = true
  try {
    const res = await axios.get('/excel/host/room-template', {
      responseType: 'blob'
    })
    downloadBlob(res.data, 'HotelStay_RoomTemplate.xlsx')
  } catch (err) {
    const msg = err.response?.data?.message || err.message || ''
    alert('❌ ' + t('host.excel.download_template_failed') + msg)
  } finally {
    downloadingTemplate.value = false
  }
}

// ========================
// 3) NHẬP DANH SÁCH PHÒNG
// ========================
const triggerExcelInput = () => {
  if (excelFileInput.value) excelFileInput.value.click()
}

const handleExcelSelect = (event) => {
  const file = event.target.files?.[0]
  if (file) processImportFile(file)
  // Reset để có thể chọn lại cùng một file
  event.target.value = ''
}

const handleExcelDrop = (event) => {
  isDraggingExcel.value = false
  const file = event.dataTransfer.files?.[0]
  if (!file) return
  if (!file.name.toLowerCase().endsWith('.xlsx')) {
    alert('⚠️ ' + t('host.excel.only_xlsx'))
    return
  }
  processImportFile(file)
}

const processImportFile = async (file) => {
  if (!file.name.toLowerCase().endsWith('.xlsx')) {
    alert('⚠️ ' + t('host.excel.only_xlsx'))
    return
  }

  importingFile.value  = true
  importResult.value   = null

  const formData = new FormData()
  formData.append('file', file)      // field name "file" đúng với backend

  try {
    const res = await axios.post('/excel/host/import-rooms', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })

    // Lưu kết quả — cấu trúc DTO: { totalRows, successCount, errorCount, successes[], errors[] }
    importResult.value = res.data

    // Sau khi import xong, reload danh sách phòng (có thể có phòng PENDING mới)
    try {
      const roomsRes = await axios.get('/rooms/host')
      emit('rooms-updated', roomsRes.data ?? [])
    } catch (e) {
      console.warn('Không thể reload danh sách phòng:', e)
    }
  } catch (err) {
    const msg = err.response?.data?.message || err.message || ''
    alert('❌ ' + t('host.excel.import_failed_msg') + msg)
  } finally {
    importingFile.value = false
  }
}

const closeImportResult = () => {
  importResult.value = null
}

const resetForNewUpload = () => {
  importResult.value = null
  // Chờ DOM cập nhật rồi mở hộp thoại chọn file
  setTimeout(() => triggerExcelInput(), 60)
}
</script>

<style scoped>
/* =====================================================
   EXCEL DATA PANEL — scoped styles
   Kế thừa thiết kế: font 'Inter', primary #1a6cf7,
   border-radius 10-16px, tái dùng .spinner-small
   ===================================================== */

.excel-panel {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 18px;
  overflow: hidden;
  margin-bottom: 2rem;
  box-shadow: 0 4px 24px rgba(26, 108, 247, 0.07);
  font-family: 'Inter', sans-serif;
}

/* ---- Header ---- */
.excel-panel-header {
  background: linear-gradient(135deg, #1a6cf7 0%, #0e4fc4 100%);
  padding: 1.2rem 1.5rem;
}

.excel-panel-title {
  display: flex;
  align-items: center;
  gap: 0.85rem;
}

.excel-icon {
  font-size: 1.6rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
}

.excel-panel-title h3 {
  font-size: 1rem;
  font-weight: 800;
  color: white;
  margin: 0;
}

.excel-panel-title p {
  font-size: 0.78rem;
  color: rgba(255, 255, 255, 0.72);
  margin: 0.1rem 0 0;
}

/* ---- Action Buttons Row ---- */
.excel-actions-row {
  display: flex;
  gap: 1rem;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #f1f5f9;
  flex-wrap: wrap;
}

/* ---- Export Bookings Wrap (date picker + button) ---- */
.export-bookings-wrap {
  flex: 1;
  min-width: 210px;
  display: flex;
  flex-direction: column;
  gap: 0.65rem;
}

.date-range-row {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.date-field {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
  flex: 1;
  min-width: 130px;
}

.date-label {
  font-size: 0.75rem;
  font-weight: 700;
  color: #374151;
  letter-spacing: 0.01em;
}

.date-input {
  padding: 0.45rem 0.65rem;
  border: 1.5px solid #d1d5db;
  border-radius: 8px;
  font-size: 0.82rem;
  font-family: 'Inter', sans-serif;
  color: #1e293b;
  background: white;
  transition: border-color 0.18s, box-shadow 0.18s;
  cursor: pointer;
}

.date-input:focus {
  outline: none;
  border-color: #1a6cf7;
  box-shadow: 0 0 0 3px rgba(26, 108, 247, 0.12);
}

.export-note {
  font-size: 0.72rem;
  color: #94a3b8;
  margin: 0;
  line-height: 1.5;
}

.export-date-error {
  font-size: 0.75rem;
  color: #dc2626;
  margin: 0;
  font-weight: 600;
  line-height: 1.4;
}

.excel-btn {
  flex: 1;
  min-width: 210px;
  padding: 0.85rem 1.2rem;
  border-radius: 12px;
  border: none;
  cursor: pointer;
  transition: all 0.22s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: 'Inter', sans-serif;
  text-align: left;
}

.excel-btn:disabled {
  opacity: 0.65;
  cursor: not-allowed;
  transform: none !important;
  box-shadow: none !important;
}

/* Export button — xanh lá nhạt */
.excel-btn--export {
  background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
  border: 1.5px solid #a7f3d0;
  color: #065f46;
}
.excel-btn--export:not(:disabled):hover {
  background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
  border-color: #6ee7b7;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.2);
}

/* Template button — xanh dương nhạt */
.excel-btn--template {
  background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
  border: 1.5px solid #bfdbfe;
  color: #1e40af;
}
.excel-btn--template:not(:disabled):hover {
  background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
  border-color: #93c5fd;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(26, 108, 247, 0.2);
}

.excel-btn-inner {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.btn-icon {
  font-size: 1.4rem;
  line-height: 1;
  flex-shrink: 0;
}

.btn-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 700;
  line-height: 1.3;
}

.btn-desc {
  display: block;
  font-size: 0.72rem;
  font-weight: 500;
  opacity: 0.65;
  margin-top: 0.1rem;
}

/* ---- Import Section ---- */
.import-section {
  padding: 1.25rem 1.5rem 1.5rem;
}

.import-section-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.import-section-icon {
  font-size: 1.2rem;
}

.import-section-title {
  font-size: 0.875rem;
  font-weight: 700;
  color: #0f172a;
  margin: 0;
}

.import-section-desc {
  font-size: 0.75rem;
  color: #64748b;
  margin: 0.1rem 0 0;
}

/* ---- Excel Dropzone ---- */
.excel-dropzone {
  border: 2px dashed #bfdbfe;
  border-radius: 14px;
  padding: 2rem 1.5rem;
  text-align: center;
  background: #f8fbff;
  cursor: pointer;
  transition: all 0.22s cubic-bezier(0.4, 0, 0.2, 1);
  user-select: none;
}

.excel-dropzone:hover:not(.is-loading),
.excel-dropzone.is-dragging {
  border-color: #1a6cf7;
  background: #eff6ff;
  box-shadow: 0 0 0 4px rgba(26, 108, 247, 0.09);
  transform: scale(1.005);
}

.excel-dropzone.is-loading {
  cursor: default;
  border-color: #93c5fd;
  background: #eff6ff;
}

.hidden-input {
  display: none;
}

.dropzone-body {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.dropzone-icon-wrap {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: white;
  border: 1.5px solid #dbeafe;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(26, 108, 247, 0.1);
  margin-bottom: 0.4rem;
  transition: all 0.22s;
}

.excel-dropzone:hover .dropzone-icon-wrap,
.excel-dropzone.is-dragging .dropzone-icon-wrap {
  background: #1a6cf7;
  border-color: #1a6cf7;
  transform: scale(1.1);
  box-shadow: 0 6px 18px rgba(26, 108, 247, 0.3);
}

.dropzone-big-icon {
  font-size: 1.75rem;
  line-height: 1;
  transition: filter 0.2s;
}

.excel-dropzone:hover .dropzone-big-icon,
.excel-dropzone.is-dragging .dropzone-big-icon {
  filter: brightness(100) invert(1);
}

.dropzone-main-text {
  font-size: 0.9rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.dropzone-sub-text {
  font-size: 0.8rem;
  color: #64748b;
  margin: 0;
}

.dropzone-sub-text strong {
  color: #1a6cf7;
}

.dropzone-format-badge {
  margin-top: 0.4rem;
  display: inline-block;
  background: #e0eaff;
  color: #1a6cf7;
  font-size: 0.7rem;
  font-weight: 700;
  padding: 0.2rem 0.65rem;
  border-radius: 999px;
  letter-spacing: 0.04em;
}

/* Dropzone — loading state */
.dropzone-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.65rem;
  padding: 0.5rem 0;
}

.loading-spinner-lg {
  width: 40px;
  height: 40px;
  border: 3.5px solid rgba(26, 108, 247, 0.15);
  border-top-color: #1a6cf7;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.loading-text {
  font-size: 0.9rem;
  font-weight: 700;
  color: #1a6cf7;
  margin: 0;
}

.loading-subtext {
  font-size: 0.75rem;
  color: #64748b;
  margin: 0;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ---- Import Result ---- */
.import-result {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  animation: fadeSlideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes fadeSlideIn {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* Banner tổng kết */
.result-banner {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  padding: 1rem 1.25rem;
  border-radius: 12px;
  font-size: 0.875rem;
}

.banner--success {
  background: #ecfdf5;
  border: 1.5px solid #a7f3d0;
  color: #065f46;
}

.banner--partial {
  background: #fffbeb;
  border: 1.5px solid #fde68a;
  color: #92400e;
}

.banner--error {
  background: #fef2f2;
  border: 1.5px solid #fecaca;
  color: #991b1b;
}

.banner-icon {
  font-size: 1.35rem;
  flex-shrink: 0;
}

.banner-text {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.4rem;
  font-weight: 600;
}

.banner-stats {
  display: flex;
  align-items: center;
  gap: 0.3rem;
}

.stat-success { color: #059669; font-weight: 700; }
.stat-divider { opacity: 0.5; }
.stat-error   { color: #dc2626; font-weight: 700; }

/* Danh sách kết quả */
.result-list-section {
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #e2e8f0;
}

.result-list-header {
  padding: 0.55rem 1rem;
  font-size: 0.75rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.result-list-header--success {
  background: #ecfdf5;
  color: #059669;
  border-bottom: 1px solid #a7f3d0;
}

.result-list-header--error {
  background: #fef2f2;
  color: #dc2626;
  border-bottom: 1px solid #fecaca;
}

.result-list {
  max-height: 180px;
  overflow-y: auto;
  background: #fafbfc;
}

.result-list::-webkit-scrollbar { width: 5px; }
.result-list::-webkit-scrollbar-track { background: transparent; }
.result-list::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 99px; }

.result-item {
  display: flex;
  align-items: flex-start;
  gap: 0.6rem;
  padding: 0.6rem 1rem;
  border-bottom: 1px solid #f1f5f9;
  font-size: 0.82rem;
  line-height: 1.5;
}

.result-item:last-child { border-bottom: none; }

.result-item-icon {
  flex-shrink: 0;
  font-size: 0.72rem;
  margin-top: 0.22rem;
  font-weight: 900;
}

.result-item--success .result-item-icon { color: #059669; }
.result-item--error   .result-item-icon { color: #dc2626; }
.result-item-text { color: #334155; }

/* Nút hành động sau kết quả */
.result-actions {
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
  padding-top: 0.25rem;
}

.excel-btn-sm {
  padding: 0.5rem 1.15rem;
  border-radius: 10px;
  font-size: 0.82rem;
  font-weight: 700;
  cursor: pointer;
  border: none;
  font-family: 'Inter', sans-serif;
  transition: all 0.18s;
}

.excel-btn-sm--ghost {
  background: #f1f5f9;
  color: #475569;
}
.excel-btn-sm--ghost:hover { background: #e2e8f0; }

.excel-btn-sm--primary {
  background: #1a6cf7;
  color: white;
  box-shadow: 0 4px 12px rgba(26, 108, 247, 0.25);
}
.excel-btn-sm--primary:hover {
  background: #1558d6;
  transform: translateY(-1px);
}

/* Spinner nhỏ — tái dùng class .spinner-small của project */
.spinner-small {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(0, 0, 0, 0.15);
  border-top-color: currentColor;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
  display: inline-block;
  flex-shrink: 0;
}

.excel-btn--export  .spinner-small { border-top-color: #065f46; }
.excel-btn--template .spinner-small { border-top-color: #1e40af; }

/* Responsive */
@media (max-width: 640px) {
  .excel-actions-row  { flex-direction: column; }
  .excel-btn          { min-width: unset; }
  .result-actions     { flex-direction: column-reverse; }
  .excel-btn-sm       { width: 100%; text-align: center; }
}
</style>
