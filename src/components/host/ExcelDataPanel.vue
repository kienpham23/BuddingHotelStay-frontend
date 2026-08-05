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
      <!-- Nút 1: Xuất danh sách phòng nghỉ -->
      <div class="export-bookings-wrap" style="justify-content: center;">
        <button
          class="excel-btn excel-btn--export"
          @click="exportRooms"
          :disabled="exportingRooms"
          id="btn-export-rooms"
        >
          <span class="excel-btn-inner">
            <span v-if="!exportingRooms" class="btn-icon"><Download :size="20" /></span>
            <span v-else class="spinner-small"></span>
            <span>
              <span class="btn-label">{{ exportingRooms ? (locale === 'vi' ? 'Đang xuất...' : 'Exporting...') : (locale === 'vi' ? 'Xuất danh sách phòng' : 'Export Rooms List') }}</span>
              <span class="btn-desc">{{ locale === 'vi' ? 'Tải về toàn bộ danh sách phòng nghỉ của bạn dưới dạng tệp Excel.' : 'Download your entire current rooms list as an Excel sheet.' }}</span>
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

      <!-- Dropzone (chỉ hiện khi chưa có kết quả và chưa xem trước) -->
      <div
        v-if="!importResult && !showPreview"
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
            <FolderOpen :size="18" class="dropzone-big-icon" />
          </div>
          <div class="dropzone-text-group" style="text-align: left; display: flex; flex-direction: column; gap: 2px;">
            <p class="dropzone-main-text" style="font-size: 0.85rem; font-weight: 700; color: #1e293b; margin: 0;">{{ $t('host.excel.dropzone_main') }}</p>
            <p class="dropzone-sub-text" style="font-size: 0.75rem; color: #64748b; margin: 0;">hoặc <strong style="color: #1a6cf7;">{{ $t('host.excel.dropzone_sub') }}</strong></p>
          </div>
          <div class="dropzone-format-badge" style="margin-top: 0; margin-left: auto; font-size: 0.7rem; font-weight: 700; padding: 0.15rem 0.5rem; background: #e0eaff; color: #1a6cf7; border-radius: 999px;">{{ $t('host.excel.dropzone_badge') }}</div>
        </div>

        <!-- Loading state: importing file -->
        <div v-if="importingFile" class="loading-overlay">
          <div class="loading-spinner-lg"></div>
          <p class="loading-text">{{ $t('host.excel.processing') }}</p>
          <p class="loading-subtext">{{ $t('host.excel.processing_sub') }}</p>
        </div>
      </div>

      <!-- Ghi chú hỗ trợ URL ảnh -->
      <div v-if="!importResult && !showPreview" class="image-url-hint">
        <span class="hint-icon" style="display: flex; align-items: center; margin-top: 2px;"><ImageIcon :size="14" /></span>
        <span class="hint-text">
          {{ locale === 'vi'
            ? 'File Excel hỗ trợ cột ảnh: imageUrl1, imageUrl2, imageUrl3 — dán link ảnh công khai (Cloudinary, Google Drive, Unsplash...)'
            : 'Excel supports image columns: imageUrl1, imageUrl2, imageUrl3 — paste public image links (Cloudinary, Google Drive, Unsplash...)'
          }}
        </span>
      </div>

      <!-- Giao diện Xem trước dữ liệu (Preview Panel) -->
      <div v-if="showPreview" class="preview-panel">
        <div class="preview-header">
          <div class="preview-title">
            <span class="preview-icon"><FileSpreadsheet :size="18" /></span>
            <strong>{{ locale === 'vi' ? 'Xác nhận thông tin nhập' : 'Confirm Import Details' }}</strong>
          </div>
          <span class="preview-subtitle">
            {{ locale === 'vi' ? `Tìm thấy ${previewRooms.length} phòng nghỉ sẵn sàng nhập.` : `Found ${previewRooms.length} rooms ready to import.` }}
          </span>
        </div>
        
        <div class="preview-table-container">
          <table class="preview-table">
            <thead>
              <tr>
                <th>{{ locale === 'vi' ? 'Tên phòng' : 'Room Name' }}</th>
                <th>{{ locale === 'vi' ? 'Loại' : 'Type' }}</th>
                <th>{{ locale === 'vi' ? 'Thành phố' : 'City' }}</th>
                <th>{{ locale === 'vi' ? 'Giá/đêm' : 'Price/Night' }}</th>
                <th>{{ locale === 'vi' ? 'Khách tối đa' : 'Max Guests' }}</th>
                <th>{{ locale === 'vi' ? 'Tọa độ' : 'Coordinates' }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(room, index) in previewRooms" :key="index">
                <td style="font-weight: 700; color: #334155;">{{ room.name }}</td>
                <td><span class="preview-badge">{{ room.roomTypeName }}</span></td>
                <td>{{ room.city }}</td>
                <td style="color: #ea580c; font-weight: 700;">{{ formatPrice(room.pricePerNight) }}</td>
                <td>{{ room.maxGuests }}</td>
                <td>
                  <span v-if="room.latitude && room.longitude" style="font-size: 12px; color: #475569;">
                    {{ room.latitude }}, {{ room.longitude }}
                  </span>
                  <span v-else style="color: #64748b; font-style: italic; font-size: 11px;">
                    {{ locale === 'vi' ? 'Tự động định vị' : 'Auto Geocode' }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <div class="preview-actions">
          <button class="excel-btn-sm excel-btn-sm--ghost" @click="cancelImport">
            {{ locale === 'vi' ? 'Hủy bỏ' : 'Cancel' }}
          </button>
          <button class="excel-btn-sm excel-btn-sm--primary" @click="confirmImport">
            {{ locale === 'vi' ? 'Nhập vào hệ thống' : 'Confirm Import' }}
          </button>
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
              <span class="result-item-text">{{ translateSuccessMessage(msg) }}</span>
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
              <span class="result-item-text">{{ translateErrorMessage(msg) }}</span>
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
  Check, X, Paperclip, Image as ImageIcon
} from 'lucide-vue-next'

const { t, locale } = useI18n()

// Emit sự kiện để parent (HostRoomsView) cập nhật danh sách phòng
const emit = defineEmits(['rooms-updated'])

// ========================
// STATE
// ========================
const exportingRooms       = ref(false)
const downloadingTemplate  = ref(false)
const importingFile        = ref(false)
const uploadingImages      = ref(false)
const isDraggingExcel      = ref(false)
const excelFileInput       = ref(null)
const importResult         = ref(null)
const imageUploadResults   = ref([])  // [{ok, message}]
const imageUploadProgress  = ref(0)
const imageUploadTotal     = ref(0)

const selectedFile         = ref(null)
const previewRooms         = ref([])
const showPreview          = ref(false)

// ========================
// HELPERS
// ========================
const today = () => {
  const d = new Date()
  return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`
}

const downloadBlob = (blob, filename) => {
  const url = URL.createObjectURL(blob)
  const a   = document.createElement('a')
  a.href = url; a.download = filename
  document.body.appendChild(a); a.click()
  document.body.removeChild(a); URL.revokeObjectURL(url)
}

/**
 * Tải SheetJS (xlsx) từ CDN một lần, cache vào window.XLSX
 */
const loadSheetJS = () => new Promise((resolve, reject) => {
  if (window.XLSX) return resolve(window.XLSX)
  const script = document.createElement('script')
  script.src = 'https://unpkg.com/xlsx@0.18.5/dist/xlsx.full.min.js'
  script.crossOrigin = 'anonymous'
  script.onload  = () => resolve(window.XLSX)
  script.onerror = () => reject(new Error('Không thể tải SheetJS từ CDN'))
  document.head.appendChild(script)
})

// ========================
// 1) XUẤT DANH SÁCH PHÒNG
// ========================
const exportRooms = async () => {
  exportingRooms.value = true
  try {
    const res = await axios.get('/excel/host/export-rooms', { responseType: 'blob' })
    downloadBlob(res.data, 'MyRooms.xlsx')
  } catch (err) {
    const msg = err.response?.data?.message || err.message || ''
    alert('❌ ' + (locale.value === 'vi' ? 'Xuất danh sách phòng thất bại: ' : 'Failed to export rooms list: ') + msg)
  } finally {
    exportingRooms.value = false
  }
}

// ========================
// 2) TẢI MẪU EXCEL NHẬP PHÒNG (frontend-generated)
// ========================
const generateTemplateFrontend = async () => {
  const XLSX = await loadSheetJS()
  const wb = XLSX.utils.book_new()

  // ---- Sheet 1: Dữ liệu mẫu ----
  const headerLabels = [
    'name', 'roomTypeName', 'city', 'address',
    'pricePerNight', 'maxGuests', 'description', 'amenities',
    'imageUrl1', 'imageUrl2', 'imageUrl3',
    'latitude', 'longitude'
  ]
  const displayLabels = [
    'Tên phòng *', 'Loại phòng *', 'Thành phố *', 'Địa chỉ *',
    'Giá/đêm (VNĐ) *', 'Sức chứa *', 'Mô tả phòng', 'Tiện ích (dấu phẩy)',
    'URL Ảnh 1', 'URL Ảnh 2', 'URL Ảnh 3',
    'Vĩ độ', 'Kinh độ'
  ]
  const sampleRows = [
    displayLabels,
    [
      'Phòng Deluxe view biển Mỹ Khê', 'Deluxe', 'Đà Nẵng', '45 Trường Sa, Hòa Hải, Ngũ Hành Sơn',
      1500000, 3, 'Phòng sang trọng ban công nhìn thẳng ra biển. Đầy đủ tiện nghi cao cấp.',
      'WiFi miễn phí, Điều hòa, TV 50 inch, Tủ lạnh, Bồn tắm, Minibar',
      'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
      'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', '',
      '16.05440000', '108.24440000'
    ],
    [
      'Villa ven hồ Đà Lạt', 'Villa', 'Đà Lạt', '123 Hồ Xuân Hương, Phường 1',
      3500000, 8, 'Villa 4 phòng ngủ view hồ Xuân Hương, hồ bơi riêng, BBQ sân vườn.',
      'WiFi, Điều hòa, Hồ bơi riêng, Bếp đầy đủ, BBQ, Chỗ đỗ xe, Smart TV',
      'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
      'https://images.unsplash.com/photo-1416331108676-a22ccb276e35?w=800', '',
      '11.94040000', '108.44040000'
    ],
    [
      'Căn hộ studio Hà Nội trung tâm', 'Standard', 'Hà Nội', '15 Lý Thường Kiệt, Hoàn Kiếm',
      700000, 2, 'Studio hiện đại ngay trung tâm, gần hồ Hoàn Kiếm.',
      'WiFi miễn phí, Điều hòa, TV, Tủ lạnh, Ấm đun nước',
      'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800', '', '',
      '21.02850000', '105.80480000'
    ]
  ]

  const ws1 = XLSX.utils.aoa_to_sheet(sampleRows)
  ws1['!cols'] = [35,18,12,40,16,10,55,50,65,65,65,15,15].map(w => ({ wch: w }))
  XLSX.utils.book_append_sheet(wb, ws1, 'Danh sách phòng')

  // ---- Sheet 2: Hướng dẫn ----
  const guideRows = [
    ['📋 HƯỚNG DẪN NHẬP DỮ LIỆU PHÒNG — CÓ HỖ TRỢ URL ẢNH & TỌA ĐỘ'],
    [''],
    ['Tên cột (KHÔNG đổi tên)', 'Bắt buộc', 'Mô tả', 'Ví dụ'],
    ['name', 'CÓ', 'Tên phòng (tối đa 200 ký tự)', 'Phòng Deluxe biển Mỹ Khê'],
    ['roomTypeName', 'CÓ', 'Loại phòng: Standard | Deluxe | Family Room | Villa | Penthouse | Nhà nguyên căn', 'Deluxe'],
    ['city', 'CÓ', 'Thành phố: Đà Nẵng | Hà Nội | Hồ Chí Minh | Hội An | Nha Trang | Đà Lạt | Huế...', 'Đà Nẵng'],
    ['address', 'CÓ', 'Địa chỉ đầy đủ (số nhà, đường, phường, quận)', '45 Trường Sa, Hòa Hải'],
    ['pricePerNight', 'CÓ', 'Giá mỗi đêm (VNĐ) — chỉ nhập số nguyên, tối thiểu 100000', '1500000'],
    ['maxGuests', 'CÓ', 'Sức chứa tối đa (1 - 20 người)', '3'],
    ['description', 'KHÔNG', 'Mô tả chi tiết về phòng (tối đa 2000 ký tự)', 'Phòng sang trọng, view biển đẹp...'],
    ['amenities', 'KHÔNG', 'Danh sách tiện ích cách nhau bởi dấu phẩy', 'WiFi, Điều hòa, TV, Tủ lạnh'],
    ['imageUrl1', 'KHÔNG', '⭐ URL ảnh chính (sẽ thành ảnh đại diện). Phải là link ảnh công khai, trực tiếp.', 'https://images.unsplash.com/photo-xxx?w=800'],
    ['imageUrl2', 'KHÔNG', 'URL ảnh phụ thứ 2', 'https://res.cloudinary.com/demo/image/upload/xxx.jpg'],
    ['imageUrl3', 'KHÔNG', 'URL ảnh phụ thứ 3', ''],
    ['latitude', 'KHÔNG', 'Tọa độ Vĩ độ. Nếu để trống, hệ thống sẽ tự động gọi Geocoding lấy tọa độ từ Địa chỉ.', '16.0544'],
    ['longitude', 'KHÔNG', 'Tọa độ Kinh độ. Nếu để trống, hệ thống sẽ tự động gọi Geocoding lấy tọa độ từ Địa chỉ.', '108.2444'],
    [''],
    ['📸 HƯỚNG DẪN URL ẢNH:'],
    ['• URL phải là đường dẫn TRỰC TIẾP đến file ảnh (kết thúc bằng .jpg / .png / .webp hoặc có tham số ?w=)'],
    ['• Hỗ trợ: Cloudinary, Unsplash, Imgur, hosting cá nhân, Google Drive (xem phía dưới)'],
    ['• Google Drive: Tải ảnh lên Drive → Chia sẻ "Bất kỳ ai có link" → Lấy ID file → dùng: https://lh3.googleusercontent.com/d/{FILE_ID}'],
    [''],
    ['⚠️ LƯU Ý CHUNG:'],
    ['• Hàng đầu tiên là TÊN CỘT (name, roomTypeName...) — KHÔNG XÓA, KHÔNG ĐỔI TÊN'],
    ['• Các cột có (*) là bắt buộc — để trống sẽ bị báo lỗi khi import'],
    ['• Sau khi import, phòng có trạng thái CHỜ DUYỆT và cần Admin phê duyệt trước khi hiển thị'],
    ['• Mỗi lần import tối đa 50 phòng'],
    ['• File phải định dạng .xlsx (Excel 2007 trở lên)']
  ]
  const ws2 = XLSX.utils.aoa_to_sheet(guideRows)
  ws2['!cols'] = [22,12,75,55].map(w => ({ wch: w }))
  XLSX.utils.book_append_sheet(wb, ws2, 'Hướng dẫn')

  const buf = XLSX.write(wb, { type: 'array', bookType: 'xlsx' })
  downloadBlob(
    new Blob([buf], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }),
    'HotelStay_RoomTemplate.xlsx'
  )
}

const downloadRoomTemplate = async () => {
  downloadingTemplate.value = true
  try {
    // Thử backend trước
    const res = await axios.get('/excel/host/room-template', { responseType: 'blob' })
    // Kiểm tra nếu backend trả về file thực (không phải JSON lỗi)
    if (res.data && res.data.size > 0 && res.data.type !== 'application/json') {
      downloadBlob(res.data, 'HotelStay_RoomTemplate.xlsx')
      return
    }
    throw new Error('Backend returned empty or invalid file')
  } catch {
    // Fallback: tạo file template trên frontend
    try {
      await generateTemplateFrontend()
    } catch (genErr) {
      alert('❌ ' + (locale.value === 'vi'
        ? 'Không thể tạo file mẫu. Vui lòng kiểm tra kết nối mạng.'
        : 'Cannot generate template. Please check your internet connection.'))
    }
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
  event.target.value = ''
}

const handleExcelDrop = (event) => {
  isDraggingExcel.value = false
  const file = event.dataTransfer.files?.[0]
  if (!file) return
  if (!file.name.toLowerCase().endsWith('.xlsx')) {
    alert('⚠️ ' + t('host.excel.only_xlsx')); return
  }
  processImportFile(file)
}

const formatPrice = (p) => {
  if (!p) return '0 ₫'
  return new Intl.NumberFormat('vi-VN').format(p) + ' ₫'
}

const translateErrorMessage = (msg) => {
  if (!msg) return ''

  // Phân tích số dòng: "Dòng X: <Nội dung>" hoặc "Row X: <Nội dung>"
  const match = msg.match(/^(?:Dòng|Row)\s+(\d+):\s*(.*)$/i)
  if (!match) return msg

  const rowNum = match[1]
  const content = match[2].trim()

  const prefix = locale.value === 'vi' ? `Dòng ${rowNum}: ` : `Row ${rowNum}: `

  const mappings = [
    {
      vi: 'Tên phòng không được để trống',
      en: 'Room name cannot be empty'
    },
    {
      vi: 'Thành phố không được để trống',
      en: 'City cannot be empty'
    },
    {
      vi: 'Địa chỉ không được để trống',
      en: 'Address cannot be empty'
    },
    {
      vi: 'Loại phòng không được để trống',
      en: 'Room type cannot be empty'
    },
    {
      vi: 'Giá/đêm không được để trống',
      en: 'Price per night cannot be empty'
    },
    {
      vi: 'Số khách tối đa không được để trống',
      en: 'Max guests cannot be empty'
    },
    {
      vi: 'Giá/đêm không hợp lệ - phải là số dương',
      en: 'Invalid price per night - must be a positive number'
    },
    {
      vi: 'Số khách tối đa không hợp lệ - phải là số nguyên dương',
      en: 'Invalid max guests - must be a positive integer'
    }
  ]

  for (const map of mappings) {
    if (content === map.vi || content.toLowerCase() === map.vi.toLowerCase()) {
      return prefix + (locale.value === 'vi' ? map.vi : map.en)
    }
  }

  // Dịch các lỗi hệ thống / biệt lệ từ database
  if (content.startsWith('Lỗi không xác định -') || content.startsWith('Lỗi hệ thống -')) {
    const detail = content.substring(content.indexOf('-') + 1).trim()
    let translatedDetail = detail

    if (detail.includes('Query did not return a unique result')) {
      translatedDetail = locale.value === 'vi'
        ? 'Dữ liệu bị trùng lặp trong hệ thống (tìm thấy nhiều hơn 1 phòng có cùng tên và địa chỉ của bạn).'
        : 'Duplicate data in the system (found more than 1 room with the same name and address under your account).'
    } else if (detail.includes('ConstraintViolationException') || detail.includes('Duplicate entry')) {
      translatedDetail = locale.value === 'vi'
        ? 'Dữ liệu bị trùng hoặc vi phạm ràng buộc hệ thống.'
        : 'Data is duplicated or violates system constraints.'
    }

    const errLabel = locale.value === 'vi' ? 'Lỗi hệ thống' : 'System error'
    return `${prefix}${errLabel} - ${translatedDetail}`
  }

  return msg
}

const translateSuccessMessage = (msg) => {
  if (!msg) return ''

  const match = msg.match(/^(?:Dòng|Row)\s+(\d+):\s*(.*)$/i)
  if (!match) return msg

  const rowNum = match[1]
  const content = match[2].trim()

  const prefix = locale.value === 'vi' ? `Dòng ${rowNum}: ` : `Row ${rowNum}: `

  if (content.includes('Tạo phòng') && content.includes('thành công')) {
    const nameMatch = content.match(/"([^"]+)"/)
    const roomName = nameMatch ? nameMatch[1] : ''
    return prefix + (locale.value === 'vi'
      ? `Tạo phòng "${roomName}" cùng danh sách ảnh thành công`
      : `Created room "${roomName}" with images successfully`)
  }

  if (content.includes('Cập nhật phòng') && content.includes('thành công')) {
    const nameMatch = content.match(/"([^"]+)"/)
    const roomName = nameMatch ? nameMatch[1] : ''
    return prefix + (locale.value === 'vi'
      ? `Cập nhật phòng "${roomName}" cùng danh sách ảnh mới thành công`
      : `Updated room "${roomName}" with new images successfully`)
  }

  return msg
}

const processImportFile = async (file) => {
  if (!file.name.toLowerCase().endsWith('.xlsx')) {
    alert('⚠️ ' + t('host.excel.only_xlsx')); return
  }

  selectedFile.value = file
  importingFile.value = true
  importResult.value = null
  showPreview.value = false

  try {
    const XLSX = await loadSheetJS()
    const data = await file.arrayBuffer()
    const workbook = XLSX.read(data, { type: 'array' })
    const sheetName = workbook.SheetNames[0]
    const sheet = workbook.Sheets[sheetName]
    const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 })

    const rooms = []
    for (let i = 1; i < rows.length; i++) {
      const row = rows[i]
      if (!row || row.length === 0 || !row[0]) continue
      rooms.push({
        name: row[0] || '',
        roomTypeName: row[1] || '',
        city: row[2] || '',
        address: row[3] || '',
        pricePerNight: row[4] || 0,
        maxGuests: row[5] || 0,
        description: row[6] || '',
        amenities: row[7] || '',
        imageUrl1: row[8] || '',
        imageUrl2: row[9] || '',
        imageUrl3: row[10] || '',
        latitude: row[11] || null,
        longitude: row[12] || null
      })
    }

    previewRooms.value = rooms
    showPreview.value = true
  } catch (err) {
    alert('❌ ' + (locale.value === 'vi' ? 'Không thể đọc file Excel: ' : 'Failed to read Excel file: ') + err.message)
    selectedFile.value = null
    previewRooms.value = []
    showPreview.value = false
  } finally {
    importingFile.value = false
  }
}

const confirmImport = async () => {
  if (!selectedFile.value) return

  importingFile.value = true
  showPreview.value = false

  const formData = new FormData()
  formData.append('file', selectedFile.value)

  try {
    const res = await axios.post('/excel/host/import-rooms', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    importResult.value = res.data

    // Reload danh sách phòng
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
    selectedFile.value = null
    previewRooms.value = []
  }
}

const cancelImport = () => {
  selectedFile.value = null
  previewRooms.value = []
  showPreview.value = false
}

const closeImportResult = () => {
  importResult.value = null
  imageUploadResults.value = []
  selectedFile.value = null
  previewRooms.value = []
  showPreview.value = false
}

const resetForNewUpload = () => {
  importResult.value = null
  imageUploadResults.value = []
  selectedFile.value = null
  previewRooms.value = []
  showPreview.value = false
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
  padding: 0.75rem 1.5rem 1rem;
}

.import-section-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
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

/* ---- Image URL Hint ---- */
.image-url-hint {
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  margin-top: 0.65rem;
  padding: 0.55rem 0.85rem;
  background: #fffbeb;
  border: 1px solid #fde68a;
  border-radius: 8px;
  font-size: 0.75rem;
  color: #92400e;
  line-height: 1.5;
}

.hint-icon {
  font-size: 0.9rem;
  flex-shrink: 0;
  margin-top: 1px;
}

.hint-text {
  font-weight: 500;
}

/* ---- Excel Dropzone ---- */
.excel-dropzone {
  border: 2px dashed #bfdbfe;
  border-radius: 12px;
  padding: 0.75rem 1.25rem;
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
  flex-direction: row;
  align-items: center;
  gap: 0.75rem;
}

.dropzone-icon-wrap {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: white;
  border: 1.5px solid #dbeafe;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 10px rgba(26, 108, 247, 0.08);
  transition: all 0.22s;
  flex-shrink: 0;
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

/* ---- Preview Panel ---- */
.preview-panel {
  border: 1px solid #bfdbfe;
  border-radius: 12px;
  background: #f8fbff;
  padding: 1.2rem;
  margin-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  animation: fadeSlideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.preview-header {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.preview-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #1e3a8a;
  font-size: 0.95rem;
}

.preview-subtitle {
  font-size: 0.8rem;
  color: #4b5563;
  font-weight: 500;
}

.preview-table-container {
  max-height: 250px;
  overflow-y: auto;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background: white;
}

.preview-table-container::-webkit-scrollbar {
  width: 6px;
}
.preview-table-container::-webkit-scrollbar-track {
  background: transparent;
}
.preview-table-container::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 99px;
}

.preview-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.82rem;
  text-align: left;
}

.preview-table th {
  background: #f1f5f9;
  padding: 0.6rem 0.85rem;
  font-weight: 700;
  color: #475569;
  border-bottom: 1px solid #e2e8f0;
  position: sticky;
  top: 0;
  z-index: 1;
}

.preview-table td {
  padding: 0.6rem 0.85rem;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}

.preview-table tr:last-child td {
  border-bottom: none;
}

.preview-badge {
  background: #eff6ff;
  color: #1e40af;
  padding: 0.15rem 0.45rem;
  border-radius: 4px;
  font-size: 0.72rem;
  font-weight: 600;
}

.preview-actions {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
}
</style>
