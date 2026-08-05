<template>
  <div>
    <div class="tab-header" style="margin-top: 1.5rem;">
      <h2>{{ $t('host.rooms.list_title') }}</h2>
      <button class="btn-add-room" @click="$emit('add')">
        <Plus :size="16" /> {{ $t('host.rooms.add_btn') }}
      </button>
    </div>

    <div class="rooms-grid" v-if="rooms.length > 0">
      <div v-for="rm in rooms" :key="rm.id" class="room-card">
        <div class="room-img">
          <img :src="rm.imageUrls?.[0] || 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=800&auto=format&fit=crop'" alt="Room preview" />
          <span class="room-type-badge">{{ rm.roomTypeName }}</span>
          <span class="room-status-badge" :class="rm.status?.toLowerCase() || 'active'">
            {{ rm.status === 'PENDING' ? $t('host.rooms.status_pending') : $t('host.rooms.status_active') }}
          </span>
        </div>
        <div class="room-details">
          <h3>{{ rm.name }}</h3>
          <p class="addr"><MapPin :size="12" /> {{ rm.address }}, {{ translateCity(rm.city) }}</p>
          <div class="specs">
            <span><Users :size="12" /> {{ $t('host.rooms.max_guests', { count: rm.maxGuests }) }}</span>
            <span class="rating" v-if="rm.avgRating"><Star :size="12" fill="#ffb703" color="#ffb703" /> {{ rm.avgRating.toFixed(1) }}</span>
          </div>
          <div class="amenities-tags" v-if="rm.amenities">
            <span
                class="amenity-tag"
                v-for="a in rm.amenities.split(',').map(x => x.trim()).filter(Boolean).slice(0, 3)"
                :key="a"
            >
              {{ translateAmenity(a) }}
            </span>
            <span class="amenity-tag more" v-if="rm.amenities.split(',').filter(Boolean).length > 3">
              +{{ rm.amenities.split(',').filter(Boolean).length - 3 }}
            </span>
          </div>
          <div class="price-row">
            <span class="price">{{ formatPrice(rm.pricePerNight) }}<small>{{ $t('host.rooms.per_night') }}</small></span>
          </div>
          <div class="card-actions">
            <button class="btn-edit" @click="$emit('edit', rm)"><Edit2 :size="14" /> {{ $t('host.rooms.edit') }}</button>
            <button class="btn-calendar" @click="$emit('calendar', rm)" style="background: #eff6ff; color: #1e40af; border: 1px solid #bfdbfe;"><Calendar :size="14" /> {{ $t('host.calendar.action_name') }}</button>
            <button class="btn-delete" @click="$emit('delete', rm)"><Trash2 :size="14" /> {{ $t('host.rooms.delete') }}</button>
          </div>
        </div>
      </div>
    </div>

    <div class="empty-state" v-else>
      <Hotel :size="48" class="color-gray" />
      <h3>{{ $t('host.rooms.empty_title') }}</h3>
      <p>{{ $t('host.rooms.empty_desc') }}</p>
      <button class="btn-add-room mt-4" @click="$emit('add')">{{ $t('host.rooms.empty_btn') }}</button>
    </div>
  </div>
</template>

<script setup>
import { 
  Plus, MapPin, Users, Star, Edit2, Calendar, Trash2, Hotel 
} from 'lucide-vue-next'
import { useI18n } from 'vue-i18n'

const props = defineProps({
  rooms: {
    type: Array,
    required: true,
    default: () => []
  },
  locale: {
    type: String,
    required: true
  }
})

defineEmits(['add', 'edit', 'calendar', 'delete'])

const { t } = useI18n()

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

const translateAmenity = (name) => {
  switch (name) {
    case 'WiFi miễn phí': return t('amenities.wifi')
    case 'Hồ bơi': return t('amenities.pool')
    case 'Điều hòa': return t('amenities.ac')
    case 'Bãi đỗ xe': return t('amenities.parking')
    case 'Bếp': return t('amenities.kitchen')
    case 'TV': return t('amenities.tv')
    case 'Tủ lạnh': return t('amenities.fridge')
    case 'Máy giặt': return t('amenities.washer')
    case 'Bữa sáng miễn phí': return t('amenities.breakfast')
    case 'Phòng gym': return t('amenities.gym')
    case 'Bồn tắm': return t('amenities.bathtub')
    case 'View biển': return t('amenities.sea_view')
    case 'Ban công': return t('amenities.balcony')
    case 'Cho phép thú cưng': return t('amenities.pets')
    default: return name
  }
}

const formatPrice = (value) => {
  if (value === null || value === undefined) return ''
  return value.toLocaleString('vi-VN') + ' VND'
}
</script>
