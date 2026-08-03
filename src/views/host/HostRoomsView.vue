<template>
  <div class="host-dashboard-layout">
    <!-- SIDEBAR -->
    <aside class="host-sidebar">
      <div class="sidebar-logo">
        <RouterLink to="/host/rooms" class="logo" @click="activeSidebarTab = 'dashboard'">
          <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="22" height="22" style="width: 22px; height: 22px; flex-shrink: 0; margin-right: 6px;">
            <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="logo-word building">Building</span>
          <span class="logo-word hotel">Hotel</span>
          <span class="logo-word stay">Stay</span>
        </RouterLink>
        <span class="panel-tag">{{ $t('host.panel_tag') }}</span>
      </div>

      <!-- User profile in sidebar -->
      <div class="sidebar-profile" v-if="authStore.isLoggedIn">
        <div class="profile-avatar" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
          <img v-if="authStore.user?.avatarUrl" :src="authStore.user.avatarUrl" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;" />
          <template v-else>
            {{ authStore.user?.fullName ? authStore.user.fullName.charAt(0).toUpperCase() : 'H' }}
          </template>
        </div>
        <div class="profile-info">
          <span class="profile-name">{{ authStore.user?.fullName }}</span>
          <span class="profile-role">{{ $t('host.role_host') }}</span>
        </div>
      </div>

      <!-- Sidebar Menu Navigation -->
      <nav class="sidebar-menu">
        <button
          class="menu-item"
          :class="{ active: activeSidebarTab === 'dashboard' }"
          @click="activeSidebarTab = 'dashboard'"
        >
          <LayoutDashboard :size="18" />
          <span>{{ $t('host.sidebar.overview') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeSidebarTab === 'rooms' }"
          @click="activeSidebarTab = 'rooms'"
        >
          <Hotel :size="18" />
          <span>{{ $t('host.sidebar.rooms') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeSidebarTab === 'bookings' }"
          @click="activeSidebarTab = 'bookings'"
        >
          <Users :size="18" />
          <span>{{ $t('host.sidebar.bookings') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeSidebarTab === 'revenue' }"
          @click="activeSidebarTab = 'revenue'"
        >
          <BarChart3 :size="18" />
          <span>{{ $t('host.sidebar.revenue') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeSidebarTab === 'profile' }"
          @click="activeSidebarTab = 'profile'"
        >
          <User :size="18" />
          <span>{{ locale === 'vi' ? 'Tài khoản' : 'Account' }}</span>
        </button>
      </nav>

      <!-- Sidebar Footer -->
      <div class="sidebar-footer">
        <RouterLink to="/host/rooms" class="sidebar-link" @click="activeSidebarTab = 'dashboard'">
          <Home :size="16" />
          <span>{{ $t('host.sidebar.back_home') }}</span>
        </RouterLink>
        <button class="btn-logout-sidebar" @click="handleLogout">
          <LogOut :size="16" />
          <span>{{ $t('host.sidebar.logout') }}</span>
        </button>
      </div>
    </aside>

    <!-- MAIN CONTENT AREA -->
    <div class="host-main-container">
      <!-- TOP NAV -->
      <header class="host-top-header">
        <div class="header-title-section">
          <h1 class="page-title">{{ activePageTitle }}</h1>
          <p class="page-subtitle">{{ activePageSubtitle }}</p>
        </div>
        <div class="header-actions" style="display: flex; align-items: center; gap: 12px;">
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
          <span class="today-date-top">{{ todayDateLabel }}</span>
        </div>
      </header>

      <!-- VIEW CONTENT -->
      <main class="host-main-content">
        <!-- 1. DASHBOARD TAB -->
        <div v-if="activeSidebarTab === 'dashboard'" class="fade-in-tab">
          <!-- ANALYTICS CARDS -->
          <div class="analytics-row">
            <div class="analytic-card">
              <div class="icon-wrap"><Building2 :size="24" /></div>
              <div class="info">
                <h4>{{ $t('host.stats.active_rooms') }}</h4>
                <span class="val">{{ rooms.length }} {{ $t('host.stats.rooms_unit') }}</span>
              </div>
            </div>
            <div class="analytic-card">
              <div class="icon-wrap color-green"><FileText :size="24" /></div>
              <div class="info">
                <h4>{{ $t('host.stats.total_bookings') }}</h4>
                <span class="val">{{ realBookingsCount }} {{ $t('host.stats.bookings_unit') }}</span>
              </div>
            </div>
            <div class="analytic-card">
              <div class="icon-wrap color-pink"><DollarSign :size="24" /></div>
              <div class="info">
                <h4>{{ $t('host.stats.total_revenue') }}</h4>
                <span class="val">{{ formatPrice(totalRevenue) }}</span>
              </div>
            </div>
          </div>

          <!-- TODAY AVAILABILITY SECTION -->
          <div class="today-section">
            <!-- Section Header -->
            <div class="today-section-header">
              <div class="today-title-wrap">
                <div class="today-pulse-dot"></div>
                <h2 class="today-title">{{ $t('host.today.title') }}</h2>
                <span class="today-date-badge">{{ todayDateLabel }}</span>
              </div>
              <button class="btn-refresh" @click="fetchTodayAvailability" :disabled="loadingToday">
                <RefreshCw :size="15" :class="{ 'spin-icon': loadingToday }" />
                {{ loadingToday ? $t('host.today.loading') : $t('host.today.refresh') }}
              </button>
            </div>

            <!-- Summary bar -->
            <div class="today-summary-bar" v-if="!loadingToday && todayAvailability.length > 0">
              <div class="summary-text">
                <span class="summary-available">{{ availableCount }}</span>
                <span class="summary-sep">/</span>
                <span class="summary-total">{{ todayAvailability.length }}</span>
                <span class="summary-label">{{ $t('host.today.available_desc') }}</span>
              </div>
              <div class="summary-progress-wrap">
                <div class="summary-progress-track">
                  <div
                    class="summary-progress-fill"
                    :style="{ width: availabilityPercent + '%' }"
                  ></div>
                </div>
                <span class="summary-percent">{{ availabilityPercent }}%</span>
              </div>
            </div>

            <!-- Loading state -->
            <div class="today-loading" v-if="loadingToday">
              <div class="loading-shimmer-grid">
                <div class="shimmer-card" v-for="n in 4" :key="n"></div>
              </div>
            </div>

            <!-- Cards Grid -->
            <div class="today-grid" v-else-if="todayAvailability.length > 0">
              <div
                v-for="room in todayAvailability"
                :key="room.roomId"
                class="today-card"
                :class="room.isAvailableToday ? 'today-card--available' : 'today-card--occupied'"
              >
                <!-- Room Image -->
                <div class="today-card-img">
                  <img
                    :src="room.imageUrl || 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?q=80&w=800&auto=format&fit=crop'"
                    :alt="room.roomName"
                    @error="$event.target.src = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?q=80&w=800&auto=format&fit=crop'"
                  />
                  <!-- Availability badge -->
                  <span v-if="room.isAvailableToday" class="avail-badge avail-badge--green">
                    <span class="badge-dot"></span> {{ $t('host.today.status_available') }}
                  </span>
                  <span v-else class="avail-badge avail-badge--orange">
                    <span class="badge-dot"></span> {{ $t('host.today.status_occupied') }}
                  </span>
                  <!-- Overlay gradient -->
                  <div class="img-overlay"></div>
                </div>

                <!-- Card Body -->
                <div class="today-card-body">
                  <h3 class="today-card-name">{{ room.roomName }}</h3>
                  <p class="today-card-city">
                    <MapPin :size="11" /> {{ translateCity(room.city) }}
                  </p>

                  <!-- Available: show price -->
                  <div v-if="room.isAvailableToday" class="today-card-price">
                    <span class="price-amount">{{ formatPrice(room.pricePerNight) }}</span>
                    <span class="price-unit">{{ $t('host.rooms.per_night') }}</span>
                  </div>

                  <!-- Occupied: show guest info -->
                  <div v-else class="today-card-guest">
                    <div class="guest-row">
                      <UserCheck :size="13" />
                      <span>{{ $t('host.today.guest_label') }}: <strong>{{ room.guestName }}</strong></span>
                    </div>
                    <div class="guest-row checkout-row">
                      <CalendarCheck :size="13" />
                      <span>{{ $t('host.today.checkout_label') }}: <strong>{{ formatCheckOut(room.checkOutDate) }}</strong></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Empty state -->
            <div class="today-empty" v-else>
              <BedDouble :size="40" />
              <p>{{ $t('host.today.no_data') }}</p>
            </div>
          </div>
        </div>

        <!-- 2. ROOMS TAB -->
        <div v-if="activeSidebarTab === 'rooms'" class="fade-in-tab">
          <!-- EXCEL DATA PANEL: Xuất / Nhập dữ liệu -->
          <ExcelDataPanel @rooms-updated="onRoomsUpdated" />

          <div class="tab-header" style="margin-top: 1.5rem;">
            <h2>{{ $t('host.rooms.list_title') }}</h2>
            <button class="btn-add-room" @click="openAddModal">
              <Plus :size="16" /> {{ $t('host.rooms.add_btn') }}
            </button>
          </div>

          <div class="rooms-grid" v-if="rooms.length > 0">
            <div v-for="rm in rooms" :key="rm.id" class="room-card">
              <div class="room-img">
                <img :src="rm.imageUrls[0] || 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=800&auto=format&fit=crop'" alt="Room preview" />
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
                  <button class="btn-edit" @click="openEditModal(rm)"><Edit2 :size="14" /> {{ $t('host.rooms.edit') }}</button>
                  <button class="btn-calendar" @click="openRoomCalendar(rm)" style="background: #eff6ff; color: #1e40af; border: 1px solid #bfdbfe;"><Calendar :size="14" /> {{ $t('host.calendar.action_name') }}</button>
                  <button class="btn-delete" @click="confirmDeleteRoom(rm)"><Trash2 :size="14" /> {{ $t('host.rooms.delete') }}</button>
                </div>
              </div>
            </div>
          </div>

          <div class="empty-state" v-else>
            <Hotel :size="48" class="color-gray" />
            <h3>{{ $t('host.rooms.empty_title') }}</h3>
            <p>{{ $t('host.rooms.empty_desc') }}</p>
            <button class="btn-add-room mt-4" @click="openAddModal">{{ $t('host.rooms.empty_btn') }}</button>
          </div>
        </div>

        <!-- 3. BOOKINGS TAB -->
        <div v-if="activeSidebarTab === 'bookings'" class="fade-in-tab">
          <div class="tab-header">
            <h2>{{ $t('host.bookings.list_title') }}</h2>
          </div>

          <!-- Active Room Filter Badge -->
          <div v-if="appliedRoomIdFilter" style="margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 0.82rem; padding: 6px 12px; border-radius: 8px; font-weight: 700; background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; display: inline-flex; align-items: center; gap: 8px;">
              Lọc theo: {{ getRoomNameById(appliedRoomIdFilter) }}
              <button 
                @click="appliedRoomIdFilter = null" 
                style="background: transparent; border: none; font-size: 1rem; color: #ef4444; cursor: pointer; font-weight: bold; padding: 0; line-height: 1; display: inline-flex; align-items: center;"
                title="Hủy lọc phòng"
              >
                &times;
              </button>
            </span>
          </div>

          <!-- Filters Bar -->
          <div class="booking-filters-bar" v-if="bookings.length > 0">
            <div class="filter-item">
              <label>{{ $t('host.bookings.status_label') }}</label>
              <select v-model="filterStatus" class="select-input">
                <option value="">{{ $t('host.bookings.status_all') }}</option>
                <option value="PENDING">{{ $t('host.bookings.status_pending') }}</option>
                <option value="CONFIRMED">{{ $t('host.bookings.status_confirmed') }}</option>
                <option value="COMPLETED">{{ $t('host.bookings.status_completed') }}</option>
                <option value="CANCELLED">{{ $t('host.bookings.status_cancelled') }}</option>
              </select>
            </div>
            <div class="filter-item">
              <label>{{ $t('host.bookings.date_start') }}</label>
              <input type="date" v-model="filterStartDate" class="date-input" />
            </div>
            <div class="filter-item">
              <label>{{ $t('host.bookings.date_end') }}</label>
              <input type="date" v-model="filterEndDate" class="date-input" />
            </div>
            <div class="filter-actions">
              <button class="btn-filter-apply" @click="handleApplyFilter">{{ $t('host.bookings.btn_apply') }}</button>
              <button class="btn-filter-clear" @click="handleClearFilter">{{ $t('host.bookings.btn_clear') }}</button>
              <button 
                class="btn-filter-apply" 
                style="background: #10b981; border-color: #10b981; color: white; display: inline-flex; align-items: center; gap: 6px; font-weight: 700;"
                @click="exportBookingsToExcel" 
                :disabled="exportingBookings"
              >
                <span v-if="exportingBookings" class="spinner-small" style="width: 14px; height: 14px; border-width: 2px; border-top-color: white; margin: 0;"></span>
                <span v-else>📊</span>
                {{ exportingBookings ? (locale === 'vi' ? 'Đang xuất...' : 'Exporting...') : (locale === 'vi' ? 'Xuất Excel' : 'Export Excel') }}
              </button>
            </div>
          </div>

          <!-- Table bookings with filtered list -->
          <div class="table-container" v-if="filteredBookings.length > 0">
            <table class="bookings-table">
              <thead>
                <tr>
                  <th>{{ $t('host.bookings.col_id') }}</th>
                  <th>{{ $t('host.bookings.col_room') }}</th>
                  <th>{{ $t('host.bookings.col_guest') }}</th>
                  <th>{{ $t('host.bookings.col_stay') }}</th>
                  <th>{{ $t('host.bookings.col_payment') }}</th>
                  <th>{{ $t('host.bookings.col_status') }}</th>
                  <th>{{ $t('host.bookings.col_action') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="bk in filteredBookings" :key="bk.id">
                  <td><strong>#{{ bk.id }}</strong></td>
                  <td>
                    <div class="table-room-info">
                      <img :src="bk.roomImage" class="table-room-img" />
                      <div>
                        <p class="name">{{ bk.roomName }}</p>
                        <small class="city">{{ translateCity(bk.city) }}</small>
                      </div>
                    </div>
                  </td>
                  <td>
                    <p class="name">{{ bk.guestName }}</p>
                    <small class="contact">{{ bk.guestEmail }} | {{ bk.guestPhone }}</small>
                  </td>
                  <td>
                    <p class="stay-dates">{{ formatDate(bk.checkIn) }} - {{ formatDate(bk.checkOut) }}</p>
                    <small class="duration">{{ calculateDuration(bk.checkIn, bk.checkOut) }} {{ locale === 'en' ? 'nights' : 'đêm' }}</small>
                  </td>
                  <td>
                    <strong class="color-blue">{{ formatPrice(bk.totalPrice) }}</strong>
                    <div class="payment-info-badges" style="margin-top: 4px; display: flex; flex-direction: column; gap: 2px;">
                      <span class="pay-method-badge" 
                            style="font-size: 0.72rem; padding: 2px 6px; border-radius: 4px; font-weight: 600; text-transform: uppercase; width: fit-content;"
                            :style="bk.paymentMethod === 'VNPAY' ? 'background: #dbeafe; color: #1d4ed8;' : bk.paymentMethod === 'MOMO' ? 'background: #fce7f3; color: #9d174d;' : 'background: #e0f2fe; color: #0369a1;'">
                        {{ bk.paymentMethod || $t('host.bookings.payment_unknown') }}
                      </span>
                      <span class="pay-status-badge" 
                            style="font-size: 0.72rem; padding: 2px 6px; border-radius: 4px; font-weight: 600; width: fit-content;" 
                            :style="bk.paid ? 'background: #d1fae5; color: #065f46;' : 'background: #fef3c7; color: #92400e;'">
                        {{ bk.paid ? $t('host.bookings.payment_paid') : $t('host.bookings.payment_unpaid') }}
                      </span>
                    </div>
                  </td>
                  <td>
                    <span class="status-badge" :class="bk.status.toLowerCase()">
                      {{ getStatusLabel(bk.status) }}
                    </span>
                  </td>
                  <td>
                    <div class="table-actions">
                      <button 
                        class="btn-table-approve" 
                        style="background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; font-size: 0.72rem; padding: 4px 8px; border-radius: 4px; display: inline-flex; align-items: center; gap: 4px; font-weight: 700;"
                        @click="openBookingDetailModal(bk)"
                        :title="locale === 'vi' ? 'Xem Chi tiết' : 'View Details'"
                      >
                        👁️ {{ locale === 'vi' ? 'Chi tiết' : 'Details' }}
                      </button>
                      <button 
                        v-if="bk.status === 'PENDING'" 
                        class="btn-table-approve" 
                        @click="confirmBooking(bk.id)" 
                        :title="$t('host.bookings.action_approve')"
                      >
                        <Check :size="14" /> {{ $t('host.bookings.action_approve') }}
                      </button>
                      <button 
                        v-if="bk.status === 'CONFIRMED' && bk.paymentMethod === 'CASH' && !bk.paid" 
                        class="btn-table-approve" 
                        @click="confirmCashPayment(bk.id)" 
                        :title="$t('host.bookings.action_cash_payment')"
                        style="background: #10b981; color: #fff;"
                      >
                        <DollarSign :size="14" /> {{ $t('host.bookings.action_cash_payment') }}
                      </button>
                      <button 
                        v-if="bk.status === 'CONFIRMED'" 
                        class="btn-table-approve" 
                        @click="completeBooking(bk.id)" 
                        :title="$t('host.bookings.action_complete')"
                        style="background: #8b5cf6; color: #fff;"
                      >
                        <Check :size="14" /> {{ $t('host.bookings.action_complete') }}
                      </button>
                      <button 
                        v-if="bk.status === 'PENDING' || (bk.status === 'CONFIRMED' && !bk.paid)" 
                        class="btn-table-delete" 
                        @click="rejectBooking(bk.id)" 
                        :title="$t('host.bookings.action_reject')"
                      >
                        <X :size="14" /> {{ $t('host.bookings.action_reject') }}
                      </button>
                      <span v-if="bk.status !== 'PENDING' && bk.status !== 'CONFIRMED' && !(bk.status === 'CONFIRMED' && !bk.paid)" class="color-gray" style="font-size:0.8rem; font-weight:600">{{ $t('host.bookings.action_processed') }}</span>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- No matching results when filtered -->
          <div class="empty-state empty-state--no-match" v-else-if="bookings.length > 0">
            <FileText :size="48" class="color-gray" />
            <h3>{{ $t('host.bookings.no_match') }}</h3>
            <p>{{ $t('host.bookings.no_match_desc') }}</p>
          </div>

          <!-- No bookings at all -->
          <div class="empty-state" v-else>
            <FileText :size="48" class="color-gray" />
            <h3>{{ $t('host.bookings.empty_title') }}</h3>
            <p>{{ $t('host.bookings.empty_desc') }}</p>
          </div>

          <!-- BLOCKED DATES SECTION -->
          <div class="blocked-dates-section" style="margin-top: 32px; border-top: 1px solid #e2e8f0; padding-top: 24px;">
            <div class="tab-header" style="margin-bottom: 16px;">
              <h3 style="font-size: 1.15rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 8px;">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #ef4444;">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                  <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                </svg>
                {{ locale === 'vi' ? 'Danh sách chặn ngày phòng (Đóng cửa tạm thời)' : 'Blocked Dates List (Temporary Closed)' }}
              </h3>
              <p style="font-size: 0.82rem; color: #64748b; margin-top: 4px; margin-bottom: 0;">{{ locale === 'vi' ? 'Theo dõi và quản lý các khoảng ngày bạn chủ động khóa phòng để dọn dẹp hoặc bảo trì.' : 'Track and manage the date ranges you actively closed for room cleaning or maintenance.' }}</p>
            </div>

            <!-- Blocked list table -->
            <div class="table-container" v-if="blockedBookings.length > 0">
              <table class="bookings-table">
                <thead>
                  <tr>
                    <th>{{ locale === 'vi' ? 'Mã chặn' : 'Block ID' }}</th>
                    <th>{{ $t('host.bookings.col_room') }}</th>
                    <th>{{ locale === 'vi' ? 'Khoảng ngày chặn' : 'Blocked Date Range' }}</th>
                    <th>{{ locale === 'vi' ? 'Số đêm đóng' : 'Closed Nights' }}</th>
                    <th>{{ $t('host.bookings.col_status') }}</th>
                    <th>{{ $t('host.bookings.col_action') }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="bk in blockedBookings" :key="bk.id">
                    <td><strong>#BLOCK-{{ bk.id }}</strong></td>
                    <td>
                      <div class="table-room-info">
                        <img :src="bk.roomImage" class="table-room-img" />
                        <div>
                          <p class="name">{{ bk.roomName }}</p>
                          <small class="city">{{ translateCity(bk.city) }}</small>
                        </div>
                      </div>
                    </td>
                    <td>
                      <p class="stay-dates" style="color: #ef4444; font-weight: 700;">{{ formatDate(bk.checkIn) }} - {{ formatDate(bk.checkOut) }}</p>
                    </td>
                    <td>
                      <span style="font-weight: 600;">{{ calculateDuration(bk.checkIn, bk.checkOut) }} {{ locale === 'en' ? 'nights' : 'đêm' }}</span>
                    </td>
                    <td>
                      <span class="status-badge" style="background: #fee2e2; color: #991b1b; padding: 4px 8px; border-radius: 6px; font-weight: 700; font-size: 0.72rem;">
                        {{ locale === 'vi' ? 'Đã chặn' : 'Blocked' }}
                      </span>
                    </td>
                    <td>
                      <button 
                        class="btn-table-reject" 
                        style="background: #fee2e2; color: #ef4444; border: 1px solid #fecaca; font-size: 0.72rem; padding: 6px 12px; border-radius: 6px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 4px; transition: all 0.2s;"
                        onmouseover="this.style.background='#fca5a5'; this.style.color='#7f1d1d';"
                        onmouseout="this.style.background='#fee2e2'; this.style.color='#ef4444';"
                        @click="handleUnblockFromTable(bk.id)"
                      >
                        🔓 {{ locale === 'vi' ? 'Bỏ chặn' : 'Unblock' }}
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Empty state for blocked dates -->
            <div v-else style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 32px 16px; text-align: center; border: 1.5px dashed #cbd5e1; border-radius: 12px; background: #f8fafc; margin-top: 8px;">
              <span style="font-size: 2rem; margin-bottom: 8px;">🔓</span>
              <h4 style="font-size: 0.92rem; font-weight: 700; color: #334155; margin: 0 0 4px 0;">{{ locale === 'vi' ? 'Không có phòng nào đang chặn ngày' : 'No rooms currently blocked' }}</h4>
              <p style="font-size: 0.8rem; color: #64748b; margin: 0;">{{ locale === 'vi' ? 'Tất cả các phòng nghỉ của bạn đang mở bán đầy đủ các ngày.' : 'All of your rooms are fully open for bookings.' }}</p>
            </div>
          </div>
        </div>

        <!-- 4. REVENUE TAB -->
        <div v-if="activeSidebarTab === 'revenue'" class="fade-in-tab">
          <!-- Filter year -->
          <div class="revenue-filter-row">
            <div class="filter-box">
              <label for="year-select">{{ $t('host.revenue.year_select') }}</label>
              <select id="year-select" v-model="selectedYear" @change="fetchRevenueData" class="select-input">
                <option v-for="year in availableYears" :key="year" :value="year">{{ $t('host.revenue.year_format', { year: year }) }}</option>
              </select>
            </div>
          </div>

          <!-- Loading state -->
          <div v-if="loadingRevenue" class="revenue-loading">
            <div class="spinner-large"></div>
            <p>{{ $t('host.revenue.loading') }}</p>
          </div>

          <!-- Error state -->
          <div v-else-if="errorRevenue" class="revenue-error">
            <p class="error-msg">{{ errorRevenue }}</p>
            <button class="btn-primary" @click="fetchRevenueData">Thử lại</button>
          </div>

          <!-- Revenue Content -->
          <div v-else-if="revenueData" class="revenue-dashboard-content">
            <!-- stats row -->
            <div class="stats-grid-rev">
              <div class="stat-card">
                <div class="stat-icon rev-color"><DollarSign :size="24" /></div>
                <div class="stat-info">
                  <h4>{{ $t('host.revenue.gross_revenue') }}</h4>
                  <span class="stat-val">{{ formatPrice(revenueData.totalRevenue) }}</span>
                </div>
              </div>
              <div class="stat-card host-net-card">
                <div class="stat-icon net-color"><Wallet :size="24" /></div>
                <div class="stat-info">
                  <h4>{{ $t('host.revenue.net_revenue') }}</h4>
                  <span class="stat-val highlight-green">{{ formatPrice(revenueData.totalHostEarning) }}</span>
                  <small class="stat-sub">{{ $t('host.revenue.commission_deduction', { percent: getCommissionPercentage }) }}</small>
                </div>
              </div>
              <!-- Available Balance Card -->
              <div class="stat-card" style="border: 2px solid #5392f9; position: relative; overflow: hidden; background: linear-gradient(135deg, #ffffff 0%, #eff6ff 100%);">
                <div class="stat-icon" style="background: #dbeafe; color: #2563eb; display: flex; align-items: center; justify-content: center;">
                  <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                    <path d="M3 3h18v3H3z" fill="#dbeafe" />
                    <rect x="6" y="6" width="10" height="11" rx="1" fill="#eff6ff" />
                    <circle cx="11" cy="11.5" r="2.5" />
                    <path d="M11 10v3" />
                    <path d="M11 17v4" />
                    <path d="M8 20l3 3 3-3" />
                    <path d="M14 13.5c1.2-0.6 2.5 0.5 3 1.2 0.8 1.1 1.2 2.3 1.2 3.8h-4.5" />
                  </svg>
                </div>
                <div class="stat-info" style="flex: 1;">
                  <h4 style="color: #1e3a8a; font-weight: 700;">{{ locale === 'vi' ? 'Số dư khả dụng' : 'Available Balance' }}</h4>
                  <span class="stat-val" style="color: #2563eb; font-weight: 800;">{{ formatPrice(hostBalance) }}</span>
                  <button 
                    type="button" 
                    class="btn-primary" 
                    style="margin-top: 8px; font-size: 0.7rem; padding: 4px 10px; border-radius: 6px; font-weight: 700; width: fit-content; height: auto; background: #2563eb; color: white; border: none; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; gap: 4px; white-space: nowrap;"
                    @click="openPayoutModal"
                    :disabled="hostBalance <= 0"
                  >
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 2px;">
                      <line x1="4" y1="3" x2="20" y2="3" />
                      <rect x="7" y="3" width="10" height="13" rx="1" />
                      <path d="M12 6v7" />
                      <path d="M12 16v5M9 19l3 3 3-3" />
                    </svg>
                    {{ locale === 'vi' ? 'Yêu cầu rút tiền' : 'Request Payout' }}
                  </button>
                </div>
              </div>
              <div class="stat-card">
                <div class="stat-icon booking-color"><FileText :size="24" /></div>
                <div class="stat-info">
                  <h4>{{ $t('host.revenue.total_bookings') }}</h4>
                  <span class="stat-val">{{ $t('host.revenue.bookings_unit', { count: revenueData.totalBookings }) }}</span>
                </div>
              </div>
              <div class="stat-card">
                <div class="stat-icon room-color"><Hotel :size="24" /></div>
                <div class="stat-info">
                  <h4>{{ $t('host.revenue.total_rooms') }}</h4>
                  <span class="stat-val">{{ $t('host.revenue.rooms_unit', { count: revenueData.totalRooms }) }}</span>
                </div>
              </div>
            </div>

            <!-- chart and pie row -->
            <div class="dashboard-row-rev">
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
                          :style="{ 
                            height: (item.revenue === 0 ? 4 : getBarHeightPercentage(item.revenue)) + '%',
                            background: item.revenue === 0 ? '#e2e8f0' : ''
                          }"
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
                      <span class="status-count">{{ revenueData.pendingBookings }} ({{ getPercentage(revenueData.pendingBookings) }}%)</span>
                    </div>
                    <div class="status-progress-bg">
                      <div class="status-progress-fill pending" :style="{ width: getPercentage(revenueData.pendingBookings) + '%' }"></div>
                    </div>
                  </div>
                  <div class="status-item">
                    <div class="status-header">
                      <span class="status-badge confirmed">{{ $t('host.bookings.status_confirmed') }}</span>
                      <span class="status-count">{{ revenueData.confirmedBookings }} ({{ getPercentage(revenueData.confirmedBookings) }}%)</span>
                    </div>
                    <div class="status-progress-bg">
                      <div class="status-progress-fill confirmed" :style="{ width: getPercentage(revenueData.confirmedBookings) + '%' }"></div>
                    </div>
                  </div>
                  <div class="status-item">
                    <div class="status-header">
                      <span class="status-badge completed">{{ $t('host.bookings.status_completed') }}</span>
                      <span class="status-count">{{ revenueData.completedBookings }} ({{ getPercentage(revenueData.completedBookings) }}%)</span>
                    </div>
                    <div class="status-progress-bg">
                      <div class="status-progress-fill completed" :style="{ width: getPercentage(revenueData.completedBookings) + '%' }"></div>
                    </div>
                  </div>
                  <div class="status-item">
                    <div class="status-header">
                      <span class="status-badge cancelled">{{ $t('host.bookings.status_cancelled') }}</span>
                      <span class="status-count">{{ revenueData.cancelledBookings }} ({{ getPercentage(revenueData.cancelledBookings) }}%)</span>
                    </div>
                    <div class="status-progress-bg">
                      <div class="status-progress-fill cancelled" :style="{ width: getPercentage(revenueData.cancelledBookings) + '%' }"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- TOP ROOMS TABLE -->
            <div class="card table-card">
              <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; margin-bottom: 1.25rem;">
                <h3 class="card-title" style="margin: 0;"><Award :size="20" /> {{ $t('host.revenue.table_title') }}</h3>
                
                <!-- Search & Sort controls -->
                <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                  <!-- Search input -->
                  <div style="position: relative;">
                    <input 
                      type="text" 
                      v-model="roomQuery" 
                      :placeholder="locale === 'vi' ? 'Tìm tên phòng...' : 'Search room...'" 
                      class="select-input" 
                      style="padding: 5px 12px 5px 28px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.8rem; font-weight: 500; min-width: 170px;"
                    />
                    <span style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); font-size: 0.8rem; color: #94a3b8; pointer-events: none;">
                      🔍
                    </span>
                  </div>
                  <!-- Sort select -->
                  <select 
                    v-model="roomSortBy" 
                    class="select-input" 
                    style="padding: 5px 24px 5px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.8rem; font-weight: 600;"
                  >
                    <option value="revenue">{{ locale === 'vi' ? 'Sắp xếp: Doanh thu' : 'Sort: Revenue' }}</option>
                    <option value="bookings">{{ locale === 'vi' ? 'Sắp xếp: Lượt đặt' : 'Sort: Bookings' }}</option>
                  </select>
                </div>
              </div>
              <div class="table-responsive">
                <table class="report-table">
                  <thead>
                    <tr>
                      <th>{{ $t('host.revenue.table_rank') }}</th>
                      <th>{{ $t('host.revenue.table_name') }}</th>
                      <th>{{ $t('host.revenue.table_city') }}</th>
                      <th class="text-right">{{ $t('host.revenue.table_bookings') }}</th>
                      <th class="text-right">{{ locale === 'vi' ? 'Tỉ lệ lấp đầy' : 'Occupancy Rate' }}</th>
                      <th class="text-right">{{ locale === 'vi' ? 'Doanh thu TB' : 'Avg Revenue' }}</th>
                      <th class="text-right">{{ $t('host.revenue.table_revenue') }}</th>
                      <th class="text-center">{{ locale === 'vi' ? 'Thao tác' : 'Actions' }}</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(room, index) in sortedAndFilteredTopRooms" :key="room.roomId">
                      <td>
                        <span class="rank-badge" :class="'rank-' + (index + 1)">{{ index + 1 }}</span>
                      </td>
                      <td><strong>{{ room.roomName }}</strong></td>
                      <td>{{ translateCity(room.city) }}</td>
                      <td class="text-right">{{ $t('host.revenue.table_bookings_unit', { count: room.bookingCount }) }}</td>
                      <td class="text-right">{{ room.occupancyRate || Math.min(95, Math.round(45 + (room.bookingCount * 3.5))) }}%</td>
                      <td class="text-right">{{ formatPrice(room.avgDailyRevenue || (room.bookingCount ? Math.round(room.totalRevenue / room.bookingCount) : 0)) }}</td>
                      <td class="text-right highlight-price"><strong>{{ formatPrice(room.totalRevenue) }}</strong></td>
                      <td class="text-center">
                        <button 
                          class="btn-primary-sm" 
                          style="padding: 0.25rem 0.75rem; font-size: 0.75rem; border-radius: 6px;"
                          @click="handleFilterRoomBookings(room.roomId)"
                        >
                          {{ locale === 'vi' ? 'Chi tiết' : 'Details' }}
                        </button>
                      </td>
                    </tr>
                    <tr v-if="!sortedAndFilteredTopRooms || sortedAndFilteredTopRooms.length === 0">
                      <td colspan="8" class="text-center empty-row">{{ $t('host.revenue.table_empty') }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- ROW FOR BOTH TABLES SIDE-BY-SIDE -->
            <div class="tables-row-rev" style="margin-top: 24px;">
              <!-- HÓA ĐƠN CÔNG NỢ HOA HỒNG HỆ THỐNG -->
              <div class="card table-card" style="margin-top: 0; display: flex; flex-direction: column;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px;">
                  <h3 class="card-title" style="margin: 0;"><FileText :size="20" /> {{ $t('host.commission_invoice_title') }}</h3>
                  <button 
                    v-if="invoices && invoices.length > 5"
                    @click="showAllInvoices = !showAllInvoices" 
                    style="border: none; background: transparent; color: #1a6cf7; font-weight: 700; font-size: 0.85rem; cursor: pointer; display: flex; align-items: center; gap: 4px; padding: 4px 8px;"
                  >
                    {{ showAllInvoices ? (locale === 'vi' ? 'Thu gọn' : 'Show Less') : (locale === 'vi' ? 'Xem tất cả' : 'View All') }}
                  </button>
                </div>
                <p class="subtitle" style="margin: 6px 0 16px 0; font-size: 13.5px; color: #64748b; line-height: 1.5;">
                  {{ $t('host.commission_invoice_desc') }}
                </p>
                <div class="table-responsive" style="flex: 1;">
                  <table class="report-table">
                    <thead>
                      <tr>
                        <th>{{ $t('host.invoice_code') }}</th>
                        <th class="text-right">{{ $t('host.amount_due') }}</th>
                        <th>{{ $t('host.status') }}</th>
                        <th class="text-center">{{ $t('host.actions') }}</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="invoice in (showAllInvoices ? invoices : invoices.slice(0, 5))" :key="invoice.id">
                        <td>
                          <strong>#INV-{{ invoice.id }}</strong>
                          <div style="font-size: 11px; color: #64748b; margin-top: 3px; font-weight: 500; line-height: 1.4;">
                            Kỳ: {{ formatDate(invoice.billingPeriodStart) }} - {{ formatDate(invoice.billingPeriodEnd) }}
                            <br>
                            Hạn: <span :class="{ 'text-red': invoice.status === 'OVERDUE' }">{{ formatDate(invoice.dueDate) }}</span>
                          </div>
                        </td>
                        <td class="text-right highlight-price"><strong>{{ formatPrice(invoice.amount) }}</strong></td>
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
                        <td colspan="4" class="text-center empty-row">{{ $t('host.empty_invoices') }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <!-- LỊCH SỬ RÚT TIỀN (PAYOUT HISTORY) -->
              <div class="card table-card" style="margin-top: 0; display: flex; flex-direction: column;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px;">
                  <h3 class="card-title" style="margin: 0; display: flex; align-items: center; gap: 6px;">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #2563eb; flex-shrink: 0;">
                      <line x1="4" y1="3" x2="20" y2="3" />
                      <rect x="7" y="3" width="10" height="13" rx="1" />
                      <path d="M12 6v7" />
                      <path d="M12 16v5M9 19l3 3 3-3" />
                    </svg>
                    {{ locale === 'vi' ? 'Lịch Sử Yêu Cầu Rút Tiền' : 'Payout Request History' }}
                  </h3>
                  <button 
                    v-if="payouts && payouts.length > 5"
                    @click="showAllPayouts = !showAllPayouts" 
                    style="border: none; background: transparent; color: #1a6cf7; font-weight: 700; font-size: 0.85rem; cursor: pointer; display: flex; align-items: center; gap: 4px; padding: 4px 8px;"
                  >
                    {{ showAllPayouts ? (locale === 'vi' ? 'Thu gọn' : 'Show Less') : (locale === 'vi' ? 'Xem tất cả' : 'View All') }}
                  </button>
                </div>
                <p class="subtitle" style="margin: 6px 0 16px 0; font-size: 13.5px; color: #64748b; line-height: 1.5;">
                  {{ locale === 'vi' ? 'Theo dõi danh sách các yêu cầu rút tiền của bạn và trạng thái duyệt chuyển khoản từ quản trị viên.' : 'Track your payout requests and approval status from the system administrator.' }}
                </p>

                <!-- Payout Empty State -->
                <div v-if="!payouts || payouts.length === 0" class="payout-empty-state" style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 24px 16px; text-align: center; border: 1.5px dashed #cbd5e1; border-radius: 12px; background: #f8fafc; margin-top: 8px; flex: 1;">
                  <span style="font-size: 2.2rem; margin-bottom: 6px; display: block;">📄</span>
                  <p style="color: #64748b; font-size: 0.88rem; font-weight: 600; margin: 0 0 12px 0;">
                    {{ locale === 'vi' ? 'Chưa có yêu cầu rút tiền' : 'No payout requests yet.' }}
                  </p>
                  <button
                    type="button"
                    class="btn-primary-sm"
                    style="padding: 0.4rem 1.25rem; font-size: 0.8rem; border-radius: 8px;"
                    @click="openPayoutModal"
                    :disabled="hostBalance <= 0"
                  >
                    {{ locale === 'vi' ? 'Yêu cầu rút tiền' : 'Request Payout' }}
                  </button>
                </div>

                <div v-else class="table-responsive" style="flex: 1;">
                  <table class="report-table" style="width: 100%; border-collapse: collapse;">
                    <thead>
                      <tr>
                        <th style="text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Mã số' : 'ID' }}</th>
                        <th style="text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Thông tin ngân hàng' : 'Bank Details' }}</th>
                        <th class="text-right" style="padding: 12px; border-bottom: 2px solid #e2e8f0; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Số tiền rút' : 'Amount' }}</th>
                        <th style="text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Ngày yêu cầu' : 'Requested Date' }}</th>
                        <th style="text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Trạng thái' : 'Status' }}</th>
                        <th style="text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Ghi chú / Lý do' : 'Notes / Reason' }}</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="payout in (showAllPayouts ? payouts : payouts.slice(0, 5))" :key="payout.id" style="border-bottom: 1px solid #f1f5f9;">
                        <td style="padding: 12px; font-weight: 600;"><strong>#PAY-{{ payout.id }}</strong></td>
                        <td style="padding: 12px;">
                          <div>
                            <p style="font-weight: 700; color: #334155; margin: 0;">{{ payout.bankName }}</p>
                            <small style="color: #64748b; font-weight: 500;">{{ payout.accountNumber }} | {{ payout.accountHolder }}</small>
                          </div>
                        </td>
                        <td class="text-right text-bold" style="padding: 12px; color: #2563eb; font-weight: 700;"><strong>{{ formatPrice(payout.amount) }}</strong></td>
                        <td style="padding: 12px; color: #475569;">{{ formatDate(payout.createdAt) }}</td>
                        <td style="padding: 12px;">
                          <span class="status-badge" :class="payout.status.toLowerCase()">
                            {{ getPayoutStatusLabel(payout.status) }}
                          </span>
                        </td>
                        <td style="padding: 12px; font-size: 0.85rem; color: #475569; max-width: 200px; word-wrap: break-word;">{{ payout.note || '-' }}</td>
                      </tr>
                      <tr v-if="!payouts || payouts.length === 0">
                        <td colspan="6" class="text-center empty-row" style="padding: 24px; text-align: center; color: #94a3b8;">{{ locale === 'vi' ? 'Chưa có yêu cầu rút tiền nào.' : 'No payout requests found.' }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 5. PROFILE TAB -->
        <div v-if="activeSidebarTab === 'profile'" class="fade-in-tab" style="max-width: 800px; margin: 0 auto; display: flex; flex-direction: column; gap: 24px; padding-bottom: 40px;">
          <div style="background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); border: 1px solid #f1f5f9;">
            <h3 style="font-size: 1.2rem; font-weight: 800; color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
              <User :size="20" style="color: #2563eb;" />
              {{ locale === 'vi' ? 'Thông tin cá nhân' : 'Personal Information' }}
            </h3>
            <form @submit.prevent="handleUpdateProfile" style="display: flex; flex-direction: column; gap: 16px;">
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Họ và tên' : 'Full Name' }}</label>
                  <input type="text" v-model="profileForm.fullName" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
                </div>
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">Email</label>
                  <input type="email" :value="profileForm.email" disabled style="padding: 10px 12px; border-radius: 8px; border: 1px solid #e2e8f0; background: #f8fafc; color: #94a3b8; font-size: 0.9rem;" />
                </div>
              </div>
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Số điện thoại' : 'Phone Number' }}</label>
                  <input type="text" v-model="profileForm.phone" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" />
                </div>
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Ảnh đại diện (URL)' : 'Avatar URL' }}</label>
                  <input type="text" v-model="profileForm.avatarUrl" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" />
                </div>
              </div>
              <button type="submit" :disabled="updatingProfile" style="width: fit-content; align-self: flex-end; padding: 10px 24px; border-radius: 8px; border: none; background: #2563eb; color: white; font-weight: 700; cursor: pointer;">
                <span v-if="updatingProfile">{{ locale === 'vi' ? 'Đang lưu...' : 'Saving...' }}</span>
                <span v-else>{{ locale === 'vi' ? 'Lưu thay đổi' : 'Save Changes' }}</span>
              </button>
            </form>
          </div>

          <div style="background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); border: 1px solid #f1f5f9;">
            <h3 style="font-size: 1.2rem; font-weight: 800; color: #0f172a; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
              <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #ef4444;">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              {{ locale === 'vi' ? 'Đổi mật khẩu' : 'Change Password' }}
            </h3>
            <form @submit.prevent="handleUpdatePassword" style="display: flex; flex-direction: column; gap: 16px;">
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Mật khẩu hiện tại' : 'Current Password' }}</label>
                <input type="password" v-model="passwordForm.oldPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
              </div>
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Mật khẩu mới' : 'New Password' }}</label>
                  <input type="password" v-model="passwordForm.newPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
                </div>
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="font-size: 0.85rem; font-weight: 600; color: #475569;">{{ locale === 'vi' ? 'Xác nhận mật khẩu mới' : 'Confirm New Password' }}</label>
                  <input type="password" v-model="passwordForm.confirmPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
                </div>
              </div>
              <button type="submit" :disabled="updatingPassword" style="width: fit-content; align-self: flex-end; padding: 10px 24px; border-radius: 8px; border: none; background: #ef4444; color: white; font-weight: 700; cursor: pointer;">
                <span v-if="updatingPassword">{{ locale === 'vi' ? 'Đang cập nhật...' : 'Updating...' }}</span>
                <span v-else>{{ locale === 'vi' ? 'Đổi mật khẩu' : 'Update Password' }}</span>
              </button>
            </form>
          </div>
        </div>
      </main>
    </div>

    <!-- PAYOUT REQUEST DIALOG MODAL -->
    <div class="modal-backdrop" v-if="showPayoutModal" style="z-index: 1100;">
      <div class="confirm-modal" style="max-width: 500px; width: 90%; background: white; border-radius: 18px; padding: 24px; box-shadow: 0 10px 25px rgba(0,0,0,0.15); display: flex; flex-direction: column; gap: 16px; font-family: inherit;">
        <h3 style="font-size: 1.2rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 8px; margin: 0;">
          <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #2563eb;">
            <line x1="4" y1="3" x2="20" y2="3" />
            <rect x="7" y="3" width="10" height="13" rx="1" />
            <path d="M12 6v7" />
            <path d="M12 16v5M9 19l3 3 3-3" />
          </svg>
          {{ locale === 'vi' ? 'Yêu cầu rút tiền' : 'Request Payout' }}
        </h3>
        <p style="font-size: 0.88rem; color: #475569; margin: 0; line-height: 1.4;">
          {{ locale === 'vi' ? 'Nhập thông tin tài khoản ngân hàng để hệ thống thực hiện chuyển khoản doanh thu cho bạn.' : 'Enter your bank account details for the system to process the revenue payout.' }}
        </p>

        <!-- Current Available Balance -->
        <div style="background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 10px; padding: 12px; display: flex; justify-content: space-between; align-items: center;">
          <span style="font-size: 12px; font-weight: 700; color: #1e3a8a;">{{ locale === 'vi' ? 'Số dư khả dụng:' : 'Available Balance:' }}</span>
          <span style="font-size: 15px; font-weight: 800; color: #2563eb;">{{ formatPrice(hostBalance) }}</span>
        </div>

        <form @submit.prevent="submitPayoutRequest" style="display: flex; flex-direction: column; gap: 12px; text-align: left;">
          <div class="form-group" style="display: flex; flex-direction: column; gap: 4px;">
            <label style="font-size: 12px; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Số tiền rút (VND)' : 'Amount to withdraw (VND)' }}</label>
            <input 
              type="text" 
              v-model="formattedAmount" 
              @input="handleAmountInput"
              class="select-input" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; width: 100%;"
              placeholder="e.g. 500.000"
              required
            />
          </div>

          <div class="form-group" style="display: flex; flex-direction: column; gap: 4px;">
            <label style="font-size: 12px; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Tên ngân hàng' : 'Bank Name' }}</label>
            <input 
              type="text" 
              v-model="payoutForm.bankName" 
              class="select-input" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; width: 100%;"
              placeholder="e.g. Vietcombank, Techcombank"
              required
            />
          </div>

          <div class="form-group" style="display: flex; flex-direction: column; gap: 4px;">
            <label style="font-size: 12px; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Số tài khoản' : 'Account Number' }}</label>
            <input 
              type="text" 
              v-model="payoutForm.accountNumber" 
              class="select-input" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; width: 100%;"
              placeholder="e.g. 19028472938173"
              required
            />
          </div>

          <div class="form-group" style="display: flex; flex-direction: column; gap: 4px;">
            <label style="font-size: 12px; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Tên chủ tài khoản' : 'Account Holder Name' }}</label>
            <input 
              type="text" 
              v-model="payoutForm.accountHolder" 
              class="select-input" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; text-transform: uppercase; width: 100%;"
              placeholder="e.g. NGUYEN VAN A"
              required
            />
          </div>

          <div class="modal-actions" style="margin-top: 12px; display: flex; gap: 8px;">
            <button type="button" class="btn-cancel" @click="showPayoutModal = false" style="flex: 1; padding: 10px; border-radius: 8px; border: 1px solid #cbd5e1; background: white; font-weight: 700; cursor: pointer; color: #475569;">{{ locale === 'vi' ? 'Hủy bỏ' : 'Cancel' }}</button>
            <button type="submit" class="btn-submit" :disabled="payoutSubmitting" style="flex: 1; padding: 10px; border-radius: 8px; border: none; background: #2563eb; color: white; font-weight: 700; cursor: pointer;">
              <span v-if="!payoutSubmitting">{{ locale === 'vi' ? 'Gửi yêu cầu' : 'Submit' }}</span>
              <span v-else class="spinner-small"></span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- BOOKING DETAIL MODAL -->
    <div class="modal-backdrop" v-if="showBookingDetailModal && selectedBookingDetail" style="z-index: 1200;">
      <div class="confirm-modal" style="max-width: 600px; width: 95%; background: white; border-radius: 18px; padding: 28px; box-shadow: 0 10px 30px rgba(0,0,0,0.18); display: flex; flex-direction: column; gap: 20px; font-family: inherit; text-align: left; max-height: 90vh; overflow-y: auto;">
        
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f1f5f9; padding-bottom: 12px;">
          <div>
            <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin: 0; display: flex; align-items: center; gap: 8px;">
              <span style="color: #2563eb;">📄</span>
              {{ locale === 'vi' ? 'Chi Tiết Đơn Đặt Phòng' : 'Booking Details' }}
            </h3>
            <p style="font-size: 0.8rem; color: #64748b; margin: 4px 0 0 0;">
              {{ locale === 'vi' ? 'Thời gian tạo đơn:' : 'Created at:' }} {{ formatDate(selectedBookingDetail.createdAt) }}
            </p>
          </div>
          <button @click="showBookingDetailModal = false" style="background: transparent; border: none; font-size: 1.5rem; cursor: pointer; color: #94a3b8; font-weight: 300; line-height: 1;">&times;</button>
        </div>

        <!-- Body content -->
        <div style="display: flex; flex-direction: column; gap: 16px;">
          <!-- Section 1: General Info -->
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Mã đơn đặt phòng' : 'Booking ID' }}</label>
              <p style="font-size: 0.95rem; font-weight: 700; color: #0f172a; margin: 4px 0 0 0;">#{{ selectedBookingDetail.id }}</p>
            </div>
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Mã giao dịch' : 'Transaction ID' }}</label>
              <p style="font-size: 0.95rem; font-weight: 600; color: #0f172a; margin: 4px 0 0 0;">{{ selectedBookingDetail.transactionId || selectedBookingDetail.paymentTxnRef || '-' }}</p>
            </div>
          </div>

          <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 0;" />

          <!-- Section 2: Room Info -->
          <div>
            <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Thông tin phòng' : 'Room Info' }}</label>
            <p style="font-size: 0.98rem; font-weight: 700; color: #0f172a; margin: 4px 0 0 0;">{{ selectedBookingDetail.roomName }}</p>
            <small style="color: #64748b; font-weight: 500; display: block; margin-top: 2px;">{{ translateCity(selectedBookingDetail.city) }}</small>
          </div>

          <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 0;" />

          <!-- Section 3: Guest Info -->
          <div>
            <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; display: block; margin-bottom: 4px;">{{ locale === 'vi' ? 'Thông tin khách đặt' : 'Guest Details' }}</label>
            <div style="background: #f8fafc; border-radius: 8px; padding: 12px; border: 1px solid #f1f5f9; display: flex; flex-direction: column; gap: 4px;">
              <p style="font-size: 0.9rem; font-weight: 700; color: #0f172a; margin: 0;">{{ selectedBookingDetail.guestName }}</p>
              <p style="font-size: 0.82rem; color: #475569; margin: 0;">Email: {{ selectedBookingDetail.guestEmail }}</p>
              <p style="font-size: 0.82rem; color: #475569; margin: 0;">SĐT: {{ selectedBookingDetail.guestPhone || '-' }}</p>
            </div>
          </div>

          <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 0;" />

          <!-- Section 4: Stay Details -->
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Ngày nhận phòng' : 'Check-In' }}</label>
              <p style="font-size: 0.9rem; font-weight: 700; color: #0f172a; margin: 4px 0 0 0;">{{ formatDate(selectedBookingDetail.checkIn) }}</p>
            </div>
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Ngày trả phòng' : 'Check-Out' }}</label>
              <p style="font-size: 0.9rem; font-weight: 700; color: #0f172a; margin: 4px 0 0 0;">{{ formatDate(selectedBookingDetail.checkOut) }}</p>
            </div>
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Số đêm' : 'Number of Nights' }}</label>
              <p style="font-size: 0.9rem; font-weight: 700; color: #0f172a; margin: 4px 0 0 0;">{{ calculateDuration(selectedBookingDetail.checkIn, selectedBookingDetail.checkOut) }} {{ locale === 'en' ? 'nights' : 'đêm' }}</p>
            </div>
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Số khách' : 'Guests' }}</label>
              <p style="font-size: 0.9rem; font-weight: 700; color: #0f172a; margin: 4px 0 0 0;">{{ selectedBookingDetail.maxGuests || 2 }} {{ locale === 'en' ? 'guests' : 'khách' }}</p>
            </div>
          </div>

          <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 0;" />

          <!-- Section 5: Financial Info -->
          <div>
            <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; display: block; margin-bottom: 6px;">{{ locale === 'vi' ? 'Chi tiết doanh thu' : 'Financial Breakdown' }}</label>
            <div style="background: #f8fafc; border-radius: 8px; padding: 12px; border: 1px solid #f1f5f9; display: flex; flex-direction: column; gap: 6px; font-size: 0.85rem;">
              <div style="display: flex; justify-content: space-between;">
                <span style="color: #64748b;">Giá phòng / đêm:</span>
                <span style="font-weight: 600; color: #0f172a;">{{ formatPrice(selectedBookingDetail.pricePerNight || Math.round(selectedBookingDetail.totalPrice / (calculateDuration(selectedBookingDetail.checkIn, selectedBookingDetail.checkOut) || 1))) }}</span>
              </div>
              <div style="display: flex; justify-content: space-between; border-top: 1px dashed #e2e8f0; padding-top: 6px;">
                <span style="color: #64748b; font-weight: 600;">Tổng cộng (A):</span>
                <span style="font-weight: 700; color: #0f172a;">{{ formatPrice(selectedBookingDetail.totalPrice) }}</span>
              </div>
              <div style="display: flex; justify-content: space-between;">
                <span style="color: #64748b;">Phí nền tảng (B = 15%):</span>
                <span style="font-weight: 600; color: #ef4444;">- {{ formatPrice(selectedBookingDetail.totalPrice * 0.15) }}</span>
              </div>
              <div style="display: flex; justify-content: space-between; border-top: 1px solid #e2e8f0; padding-top: 6px; font-size: 0.92rem;">
                <span style="font-weight: 700; color: #10b981;">Host thực nhận (A - B):</span>
                <span style="font-weight: 800; color: #10b981;">{{ formatPrice(selectedBookingDetail.totalPrice * 0.85) }}</span>
              </div>
            </div>
          </div>

          <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 0;" />

          <!-- Section 6: Payment Method & Booking Status -->
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Phương thức thanh toán' : 'Payment Method' }}</label>
              <div style="margin-top: 4px; display: flex; align-items: center; gap: 6px;">
                <span class="pay-method-badge" 
                      style="font-size: 0.72rem; padding: 2px 8px; border-radius: 4px; font-weight: 700; text-transform: uppercase; width: fit-content;"
                      :style="selectedBookingDetail.paymentMethod === 'VNPAY' ? 'background: #dbeafe; color: #1d4ed8;' : selectedBookingDetail.paymentMethod === 'MOMO' ? 'background: #fce7f3; color: #9d174d;' : 'background: #e0f2fe; color: #0369a1;'">
                  {{ selectedBookingDetail.paymentMethod || $t('host.bookings.payment_unknown') }}
                </span>
                <span class="pay-status-badge" 
                      style="font-size: 0.72rem; padding: 2px 8px; border-radius: 4px; font-weight: 700; width: fit-content;" 
                      :style="selectedBookingDetail.paid ? 'background: #d1fae5; color: #065f46;' : 'background: #fef3c7; color: #92400e;'">
                  {{ selectedBookingDetail.paid ? $t('host.bookings.payment_paid') : $t('host.bookings.payment_unpaid') }}
                </span>
              </div>
            </div>
            <div>
              <label style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">{{ locale === 'vi' ? 'Trạng thái đơn' : 'Booking Status' }}</label>
              <div style="margin-top: 4px;">
                <span class="status-badge" :class="selectedBookingDetail.status.toLowerCase()">
                  {{ getStatusLabel(selectedBookingDetail.status) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div style="display: flex; justify-content: flex-end; border-top: 1px solid #f1f5f9; padding-top: 12px; margin-top: 8px;">
          <button 
            class="btn-primary-sm" 
            style="background: #475569; padding: 8px 20px; border-radius: 8px; font-weight: 700; border: none; cursor: pointer; color: white;"
            @click="showBookingDetailModal = false"
          >
            {{ locale === 'vi' ? 'Đóng' : 'Close' }}
          </button>
        </div>
      </div>
    </div>

    <!-- ADD/EDIT ROOM MODAL -->
    <div class="modal-backdrop" v-if="showFormModal">
      <div class="room-modal">
        <div class="modal-header">
          <h2>{{ isEditMode ? $t('host.rooms.modal_title_edit') : $t('host.rooms.modal_title_add') }}</h2>
          <button class="btn-close" @click="showFormModal = false">×</button>
        </div>
        <form @submit.prevent="saveRoom" class="modal-form">
          <div class="form-group">
            <label>{{ $t('host.rooms.form_room_name') }}</label>
            <input v-model="roomForm.name" type="text" :placeholder="$t('host.rooms.form_room_name_placeholder')" required />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>{{ $t('host.rooms.form_room_type') }}</label>
              <input v-model="roomForm.roomTypeName" type="text" :placeholder="$t('host.rooms.form_room_type_placeholder')" required />
            </div>
            <div class="form-group">
              <label>{{ $t('host.rooms.form_max_guests') }}</label>
              <input v-model.number="roomForm.maxGuests" type="number" min="1" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>{{ $t('host.rooms.form_city') }}</label>
              <select v-model="roomForm.city" required>
                <option value="">{{ $t('host.rooms.form_city_select') }}</option>
                <option v-for="c in cityOptions" :key="c.value" :value="c.value">{{ c.label }}</option>
              </select>
            </div>
            <div class="form-group">
              <label>{{ $t('host.rooms.form_price') }}</label>
              <input v-model.number="roomForm.pricePerNight" type="number" min="10000" required />
            </div>
          </div>

          <div class="form-group">
            <label>{{ $t('host.rooms.form_address') }}</label>
            <input v-model="roomForm.address" type="text" :placeholder="$t('host.rooms.form_address_placeholder')" required />
          </div>
          <div class="form-group">
            <label>{{ $t('host.rooms.form_amenities') }}</label>
            <div class="amenity-checkboxes">
              <label v-for="opt in amenityOptions" :key="opt.value" class="checkbox-lbl">
                <input type="checkbox" :value="opt.value" v-model="roomForm.amenities" />
                {{ opt.label }}
              </label>
            </div>
          </div>

          <div class="form-group image-upload-section">
            <label>{{ $t('host.rooms.form_images') }}</label>
            
            <div 
              class="upload-dropzone" 
              @dragover.prevent="isDragging = true" 
              @dragleave.prevent="isDragging = false" 
              @drop.prevent="handleDrop"
              @click="triggerFileInput"
              :class="{ 'dragging': isDragging }"
            >
              <input 
                type="file" 
                ref="fileInput" 
                multiple 
                accept="image/*" 
                class="hidden-file-input" 
                @change="handleFileSelect" 
              />
              <div class="dropzone-content">
                <UploadCloud :size="32" class="upload-icon" />
                <p class="main-text">{{ $t('host.rooms.form_drag_drop') }}</p>
                <p class="sub-text">{{ $t('host.rooms.form_image_support') }}</p>
              </div>
            </div>

            <!-- Uploading files list -->
            <div v-if="selectedNewFiles.length > 0" class="new-files-preview-list">
              <span class="preview-title">{{ $t('host.rooms.form_new_images_title', { count: selectedNewFiles.length }) }}:</span>
              <div class="images-grid-preview">
                <div 
                  v-for="(fileObj, idx) in selectedNewFiles" 
                  :key="idx" 
                  class="preview-card"
                  :class="{ 'is-primary': idx === 0 && roomImages.length === 0 }"
                >
                  <img :src="fileObj.previewUrl" alt="New upload preview" />
                  <div class="card-badges">
                    <span v-if="idx === 0 && roomImages.length === 0" class="primary-badge">
                      <Star :size="10" fill="currentColor" /> {{ $t('host.rooms.form_avatar_new') }}
                    </span>
                  </div>
                  <div class="preview-actions-overlay">
                    <button 
                      type="button" 
                      class="action-btn delete-btn" 
                      @click.stop="removeNewFile(idx)"
                      :title="$t('host.rooms.form_delete_image')"
                    >
                      <Trash2 :size="14" />
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Existing room images -->
            <div v-if="roomImages.length > 0" class="existing-files-preview-list">
              <span class="preview-title">{{ $t('host.rooms.form_existing_images_title', { count: roomImages.length }) }}:</span>
              <div class="images-grid-preview">
                <div 
                  v-for="(img, idx) in roomImages" 
                  :key="img.url" 
                  class="preview-card"
                  :class="{ 'is-primary': img.isPrimary }"
                >
                  <img :src="img.url" alt="Room preview" />
                  <div class="card-badges">
                    <span v-if="img.isPrimary" class="primary-badge">
                      <Star :size="10" fill="currentColor" /> {{ $t('host.rooms.form_avatar') }}
                    </span>
                  </div>
                  <div class="preview-actions-overlay">
                    <button 
                      v-if="!img.isPrimary" 
                      type="button" 
                      class="action-btn set-primary-btn" 
                      @click.stop="setPrimaryImageAction(img, idx)"
                      :title="$t('host.rooms.form_set_avatar')"
                    >
                      <Star :size="14" />
                    </button>
                    <button 
                      type="button" 
                      class="action-btn delete-btn" 
                      @click.stop="deleteImageAction(img, idx)"
                      :title="$t('host.rooms.form_delete_image')"
                    >
                      <Trash2 :size="14" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label>{{ $t('host.rooms.form_desc') }}</label>
            <textarea v-model="roomForm.description" :placeholder="$t('host.rooms.form_desc_placeholder')" rows="4"></textarea>
          </div>

          <div class="modal-actions">
            <button type="button" class="btn-cancel" @click="showFormModal = false">{{ $t('host.rooms.form_cancel') }}</button>
            <button type="submit" class="btn-submit" :disabled="formLoading">
              <span v-if="!formLoading">{{ $t('host.rooms.form_save') }}</span>
              <span v-else class="spinner-small"></span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- DELETE CONFIRMATION MODAL -->
    <div class="modal-backdrop" v-if="showDeleteModal">
      <div class="confirm-modal">
        <h3>{{ $t('host.rooms.delete_confirm_title') }}</h3>
        <p>{{ $t('host.rooms.delete_confirm_desc', { name: selectedRoom?.name }) }}</p>
        <div class="modal-actions">
          <button class="btn-cancel" @click="showDeleteModal = false">{{ $t('host.rooms.form_cancel') }}</button>
          <button class="btn-confirm-delete" @click="executeDeleteRoom" :disabled="deleteLoading">
            <span v-if="!deleteLoading">{{ $t('host.rooms.delete_confirm_btn') }}</span>
            <span v-else class="spinner-small"></span>
          </button>
        </div>
      </div>
    </div>

    <!-- ROOM CALENDAR MODAL (BLOCK DATES) -->
    <div class="modal-backdrop" v-if="showCalendarModal">
      <div class="calendar-modal" style="background: white; border-radius: 18px; width: 90%; max-width: 860px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); display: flex; flex-direction: column; gap: 20px; max-height: 90vh; overflow-y: auto; position: relative;">
        <!-- Header -->
        <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e2e8f0; padding-bottom: 16px;">
          <div>
            <h2 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 8px;">
              <CalendarCheck :size="22" style="color: #3b82f6;" />
              {{ $t('host.calendar.title') }}
            </h2>
            <p style="font-size: 0.85rem; color: #64748b; margin-top: 4px; font-weight: 500;">
              {{ selectedRoomForCalendar?.name }}
            </p>
          </div>
          <button @click="closeRoomCalendar" style="background: #f1f5f9; border: none; font-size: 20px; color: #64748b; cursor: pointer; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.2s; font-weight: 700; line-height: 1;">×</button>
        </div>

        <div class="calendar-layout-grid" style="display: grid; grid-template-columns: 1.6fr 1fr; gap: 24px; align-items: start;">
          <!-- Left: Calendar view -->
          <div class="calendar-view-container" style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 14px; padding: 16px;">
            <!-- Month nav -->
            <div class="month-nav-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
              <button @click="prevMonth" style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 700; color: #334155;">&laquo;</button>
              <h3 style="font-size: 1rem; font-weight: 800; color: #0f172a; text-transform: capitalize;">
                {{ new Date(calendarYear, calendarMonth).toLocaleDateString(locale === 'vi' ? 'vi-VN' : 'en-US', { month: 'long', year: 'numeric' }) }}
              </h3>
              <button @click="nextMonth" style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 700; color: #334155;">&raquo;</button>
            </div>

            <!-- Days of week -->
            <div class="days-of-week-grid" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; text-align: center; margin-bottom: 8px;">
              <span v-for="d in (locale === 'vi' ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'])" :key="d" style="font-size: 11px; font-weight: 700; color: #64748b;">{{ d }}</span>
            </div>

            <!-- Calendar Days Grid -->
            <div class="calendar-days-grid" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px;">
              <div 
                v-for="(day, index) in daysInMonthList" 
                :key="index" 
                class="calendar-day-cell"
                style="aspect-ratio: 1.1; border-radius: 8px; display: flex; flex-direction: column; align-items: center; justify-content: center; position: relative; font-size: 13px; font-weight: 600; transition: all 0.2s;"
                :style="[
                  !day.date ? { background: 'transparent' } :
                  day.isBooked ? { background: '#d1fae5', color: '#065f46', cursor: 'pointer', border: '1px solid #a7f3d0' } :
                  day.isBlocked ? { background: '#ffe4e6', color: '#9f1239', cursor: 'pointer', border: '1px solid #fecdd3' } :
                  day.isPast ? { background: '#f1f5f9', color: '#cbd5e1', cursor: 'not-allowed' } :
                  { background: 'white', color: '#334155', border: '1px solid #e2e8f0' }
                ]"
                :title="day.isBooked ? `${locale === 'vi' ? 'Khách đặt:' : 'Guest:'} ${day.booking?.guestName}` : day.isBlocked ? (locale === 'vi' ? 'Chặn bởi Host - Click để bỏ chặn' : 'Blocked by Host - Click to unblock') : ''"
                @click="day.isBlocked ? handleUnblockDates(day.booking?.id) : null"
              >
                <span>{{ day.dayNumber }}</span>
                <span v-if="day.isBlocked" style="font-size: 8px; font-weight: 800; margin-top: 2px; text-transform: uppercase;">Blocked</span>
                <span v-if="day.isBooked" style="font-size: 8px; font-weight: 800; margin-top: 2px; text-transform: uppercase;">Booked</span>
              </div>
            </div>

            <!-- Legend -->
            <div class="calendar-legend" style="display: flex; gap: 16px; margin-top: 16px; font-size: 11px; font-weight: 600; color: #475569; justify-content: center; border-top: 1px solid #e2e8f0; padding-top: 12px;">
              <div style="display: flex; align-items: center; gap: 6px;">
                <span style="display: inline-block; width: 12px; height: 12px; background: white; border: 1px solid #cbd5e1; border-radius: 3px;"></span>
                <span>{{ $t('host.calendar.available') }}</span>
              </div>
              <div style="display: flex; align-items: center; gap: 6px;">
                <span style="display: inline-block; width: 12px; height: 12px; background: #d1fae5; border: 1px solid #a7f3d0; border-radius: 3px;"></span>
                <span>{{ $t('host.calendar.booked') }}</span>
              </div>
              <div style="display: flex; align-items: center; gap: 6px;">
                <span style="display: inline-block; width: 12px; height: 12px; background: #ffe4e6; border: 1px solid #fecdd3; border-radius: 3px;"></span>
                <span>{{ $t('host.calendar.blocked') }}</span>
              </div>
            </div>
          </div>

          <!-- Right: Setup Block dates form -->
          <div class="block-form-container" style="background: white; border: 1px solid #e2e8f0; border-radius: 14px; padding: 18px; display: flex; flex-direction: column; gap: 16px;">
            <h3 style="font-size: 0.95rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 6px;">
              <Plus :size="16" style="color: #ef4444;" />
              {{ $t('host.calendar.block_new') }}
            </h3>

            <div class="form-group" style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 12px; font-weight: 700; color: #475569;">{{ $t('host.calendar.checkin') }}</label>
              <input 
                type="date" 
                v-model="blockForm.checkIn" 
                class="select-input" 
                style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-family: inherit;"
                :min="new Date().toISOString().split('T')[0]"
              />
            </div>

            <div class="form-group" style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 12px; font-weight: 700; color: #475569;">{{ $t('host.calendar.checkout') }}</label>
              <input 
                type="date" 
                v-model="blockForm.checkOut" 
                class="select-input" 
                style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-family: inherit;"
                :min="blockForm.checkIn || new Date().toISOString().split('T')[0]"
              />
            </div>

            <button 
              @click="handleBlockDates" 
              class="btn-submit" 
              style="background: #ef4444; color: white; border: none; padding: 10px; border-radius: 8px; font-weight: 700; font-family: inherit; font-size: 13.5px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; justify-content: center; gap: 6px; margin-top: 10px;"
              :disabled="blockLoading"
            >
              <X :size="15" />
              <span>{{ blockLoading ? $t('host.calendar.processing') : $t('host.calendar.btn_block') }}</span>
            </button>

            <!-- Info card -->
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 12px; font-size: 0.8rem; color: #475569; line-height: 1.4;">
              <p style="font-weight: 700; color: #334155; margin-bottom: 4px; display: flex; align-items: center; gap: 4px;">💡 {{ $t('host.calendar.tip_title') }}</p>
              <p>{{ $t('host.calendar.tip_desc') }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useToastStore } from '../../stores/toast'
import { useI18n } from 'vue-i18n'
import axios from '../../api/axios'
import {
  Building2, FileText, DollarSign, Hotel, Users,
  Plus, MapPin, Star, Edit2, Trash2, Check, X,
  UploadCloud, Loader2, RefreshCw, UserCheck, CalendarCheck, BedDouble,
  LayoutDashboard, BarChart3, PieChart, Award, LogOut, Home, Wallet, Calendar, User
} from 'lucide-vue-next'
import ExcelDataPanel from '../../components/host/ExcelDataPanel.vue'
import { getMyInvoices, payInvoice } from '../../api/invoices'
import { getProfile, updateProfile, changePassword } from '../../api/users'

const { t, locale } = useI18n()
const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}
const router = useRouter()
const authStore = useAuthStore()
const toastStore = useToastStore()

const rooms = ref([])
const bookings = ref([])
const activeSidebarTab = ref('dashboard')
const invoices = ref([])
const payLoading = ref(null)

// Room Calendar & Block Dates State
const showCalendarModal = ref(false)
const selectedRoomForCalendar = ref(null)
const calendarYear = ref(new Date().getFullYear())
const calendarMonth = ref(new Date().getMonth()) // 0-11
const blockForm = ref({
  checkIn: '',
  checkOut: ''
})
const blockLoading = ref(false)

const openRoomCalendar = (room) => {
  selectedRoomForCalendar.value = room
  calendarYear.value = new Date().getFullYear()
  calendarMonth.value = new Date().getMonth()
  blockForm.value.checkIn = ''
  blockForm.value.checkOut = ''
  showCalendarModal.value = true
}

const closeRoomCalendar = () => {
  showCalendarModal.value = false
  selectedRoomForCalendar.value = null
}

const prevMonth = () => {
  if (calendarMonth.value === 0) {
    calendarMonth.value = 11
    calendarYear.value--
  } else {
    calendarMonth.value--
  }
}

const nextMonth = () => {
  if (calendarMonth.value === 11) {
    calendarMonth.value = 0
    calendarYear.value++
  } else {
    calendarMonth.value++
  }
}

const daysInMonthList = computed(() => {
  if (!selectedRoomForCalendar.value) return []
  
  const year = calendarYear.value
  const month = calendarMonth.value
  
  // First day of the month
  const firstDay = new Date(year, month, 1)
  const startDayOfWeek = firstDay.getDay()
  // Adjust Monday as start of week (0=Mon, ..., 6=Sun)
  const adjustedStart = startDayOfWeek === 0 ? 6 : startDayOfWeek - 1
  
  const daysInMonth = new Date(year, month + 1, 0).getDate()
  const list = []
  
  // Blank days before the 1st
  for (let i = 0; i < adjustedStart; i++) {
    list.push({ date: null, dayNumber: '', dateStr: '', booking: null, isBlocked: false, isBooked: false })
  }
  
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  
  // Filter bookings of selected room
  const roomBookings = bookings.value.filter(bk => 
    bk.roomId === selectedRoomForCalendar.value.id && 
    bk.status !== 'CANCELLED' && bk.status !== 'REJECTED'
  )
  
  for (let d = 1; d <= daysInMonth; d++) {
    const currentDate = new Date(year, month, d)
    currentDate.setHours(0, 0, 0, 0)
    
    const yyyy = currentDate.getFullYear()
    const mm = String(currentDate.getMonth() + 1).padStart(2, '0')
    const dd = String(currentDate.getDate()).padStart(2, '0')
    const dateStr = `${yyyy}-${mm}-${dd}`
    
    // Find booking covering this date
    const booking = roomBookings.find(bk => {
      const checkInStr = bk.checkIn.split('T')[0]
      const checkOutStr = bk.checkOut.split('T')[0]
      return dateStr >= checkInStr && dateStr < checkOutStr
    })
    
    const isBlocked = booking && (booking.note === 'HOST_BLOCKED')
    const isBooked = booking && !isBlocked
    const isPast = currentDate < today
    
    list.push({
      date: currentDate,
      dayNumber: d,
      dateStr,
      booking,
      isBlocked,
      isBooked,
      isPast
    })
  }
  
  return list
})

const handleBlockDates = async () => {
  if (!selectedRoomForCalendar.value) return
  if (!blockForm.value.checkIn || !blockForm.value.checkOut) {
    toastStore.error(locale.value === 'vi' ? 'Vui lòng chọn đầy đủ ngày nhận và trả phòng' : 'Please select both check-in and check-out dates')
    return
  }
  
  const cIn = new Date(blockForm.value.checkIn)
  const cOut = new Date(blockForm.value.checkOut)
  if (cOut <= cIn) {
    toastStore.error(locale.value === 'vi' ? 'Ngày kết thúc phải sau ngày bắt đầu' : 'Check-out date must be after check-in date')
    return
  }
  
  blockLoading.value = true
  try {
    const payload = {
      roomId: selectedRoomForCalendar.value.id,
      checkIn: blockForm.value.checkIn,
      checkOut: blockForm.value.checkOut,
      numGuests: 1,
      paymentMethod: 'CASH',
      note: 'HOST_BLOCKED'
    }
    
    await axios.post('/bookings/host/block', payload)
    toastStore.success(locale.value === 'vi' ? 'Chặn phòng thành công' : 'Room dates blocked successfully')
    
    // Refresh bookings to reflect in calendar
    const resBookings = await axios.get('/bookings/host')
    bookings.value = resBookings.data
    
    // Reset form
    blockForm.value.checkIn = ''
    blockForm.value.checkOut = ''
  } catch (err) {
    console.error('Lỗi khi chặn phòng:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Chặn phòng thất bại' : 'Failed to block room dates'))
  } finally {
    blockLoading.value = false
  }
}

const handleUnblockDates = async (bookingId) => {
  if (!confirm(locale.value === 'vi' ? 'Bạn có chắc chắn muốn bỏ chặn khoảng ngày này?' : 'Are you sure you want to unblock this date range?')) return
  
  blockLoading.value = true
  try {
    await axios.delete(`/bookings/host/block/${bookingId}`)
    toastStore.success(locale.value === 'vi' ? 'Bỏ chặn ngày thành công' : 'Room dates unblocked successfully')
    
    // Refresh bookings to reflect in calendar
    const resBookings = await axios.get('/bookings/host')
    bookings.value = resBookings.data
  } catch (err) {
    console.error('Lỗi khi bỏ chặn phòng:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Bỏ chặn thất bại' : 'Failed to unblock room dates'))
  } finally {
    blockLoading.value = false
  }
}

const activePageTitle = computed(() => {
  switch (activeSidebarTab.value) {
    case 'dashboard': return t('host.title.overview')
    case 'rooms': return t('host.title.rooms')
    case 'bookings': return t('host.title.bookings')
    case 'revenue': return t('host.title.revenue')
    default: return t('host.panel_tag')
  }
})

const activePageSubtitle = computed(() => {
  switch (activeSidebarTab.value) {
    case 'dashboard': return t('host.subtitle.overview')
    case 'rooms': return t('host.subtitle.rooms')
    case 'bookings': return t('host.subtitle.bookings')
    case 'revenue': return t('host.subtitle.revenue')
    default: return ''
  }
})

// Today availability
const todayAvailability = ref([])
const loadingToday = ref(false)

const availableCount = computed(() => todayAvailability.value.filter(r => r.isAvailableToday).length)
const availabilityPercent = computed(() => {
  if (!todayAvailability.value.length) return 0
  return Math.round((availableCount.value / todayAvailability.value.length) * 100)
})

const todayDateLabel = computed(() => {
  const currentLang = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Date().toLocaleDateString(currentLang, { weekday: 'long', day: '2-digit', month: '2-digit', year: 'numeric' })
})

// Booking filtering states
const filterStatus = ref('')
const filterStartDate = ref('')
const filterEndDate = ref('')

const appliedStatus = ref('')
const appliedStartDate = ref('')
const appliedEndDate = ref('')
const appliedRoomIdFilter = ref(null)

const showBookingDetailModal = ref(false)
const selectedBookingDetail = ref(null)

const openBookingDetailModal = (bk) => {
  selectedBookingDetail.value = bk
  showBookingDetailModal.value = true
}

const getRoomNameById = (roomId) => {
  const r = rooms.value.find(x => x.id === roomId)
  return r ? r.name : 'Phòng #' + roomId
}

const handleFilterRoomBookings = (roomId) => {
  appliedRoomIdFilter.value = roomId
  activeSidebarTab.value = 'bookings'
}

const handleApplyFilter = () => {
  appliedStatus.value = filterStatus.value
  appliedStartDate.value = filterStartDate.value
  appliedEndDate.value = filterEndDate.value
}

const handleClearFilter = () => {
  filterStatus.value = ''
  filterStartDate.value = ''
  filterEndDate.value = ''
  appliedStatus.value = ''
  appliedStartDate.value = ''
  appliedEndDate.value = ''
  appliedRoomIdFilter.value = null
}

const realBookingsCount = computed(() => {
  return bookings.value.filter(bk => bk.note !== 'HOST_BLOCKED').length
})

const blockedBookings = computed(() => {
  return bookings.value.filter(bk => bk.note === 'HOST_BLOCKED')
})

const handleUnblockFromTable = async (bookingId) => {
  if (confirm(locale.value === 'vi' ? 'Bạn có chắc chắn muốn mở khóa (bỏ chặn) cho khoảng ngày này?' : 'Are you sure you want to unblock these dates?')) {
    try {
      await axios.delete(`/bookings/host/block/${bookingId}`)
      toastStore.success(locale.value === 'vi' ? 'Bỏ chặn ngày thành công!' : 'Dates unblocked successfully!')
      const resBookings = await axios.get('/bookings/host')
      bookings.value = resBookings.data
    } catch (err) {
      console.error(err)
      toastStore.error(locale.value === 'vi' ? 'Bỏ chặn thất bại!' : 'Failed to unblock!')
    }
  }
}

const exportingBookings = ref(false)
const exportBookingsToExcel = async () => {
  let start = filterStartDate.value
  let end = filterEndDate.value
  
  if (!start || !end) {
    const now = new Date()
    const yyyy = now.getFullYear()
    const mm = String(now.getMonth() + 1).padStart(2, '0')
    const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate()
    start = `${yyyy}-${mm}-01`
    end = `${yyyy}-${mm}-${String(lastDay).padStart(2, '0')}`
  }
  
  exportingBookings.value = true
  try {
    const res = await axios.get('/excel/host/export-bookings', {
      params: { startDate: start, endDate: end },
      responseType: 'blob'
    })
    
    const url = URL.createObjectURL(res.data)
    const a = document.createElement('a')
    a.href = url
    a.download = `MyBookings_${start}_${end}.xlsx`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
    toastStore.success(locale.value === 'vi' ? 'Xuất Excel đặt phòng thành công!' : 'Bookings exported successfully!')
  } catch (err) {
    console.error(err)
    toastStore.error(locale.value === 'vi' ? 'Xuất file Excel thất bại!' : 'Failed to export Excel!')
  } finally {
    exportingBookings.value = false
  }
}

const filteredBookings = computed(() => {
  return bookings.value.filter(bk => {
    // Không hiển thị các lệnh chặn phòng (chỉ hiển thị khách đặt thực tế)
    if (bk.note === 'HOST_BLOCKED') {
      return false
    }

    // Room Filter
    if (appliedRoomIdFilter.value && bk.roomId !== appliedRoomIdFilter.value) {
      return false
    }

    // 1. Status Filter
    if (appliedStatus.value && bk.status !== appliedStatus.value) {
      return false
    }

    // 2. Date Range Filter (check-in or check-out within range)
    if (appliedStartDate.value) {
      const start = new Date(appliedStartDate.value)
      start.setHours(0, 0, 0, 0)
      const checkInDate = new Date(bk.checkIn)
      checkInDate.setHours(0, 0, 0, 0)
      const checkOutDate = new Date(bk.checkOut)
      checkOutDate.setHours(0, 0, 0, 0)

      if (appliedEndDate.value) {
        const end = new Date(appliedEndDate.value)
        end.setHours(23, 59, 59, 999)
        
        const checkInInRange = (checkInDate >= start && checkInDate <= end)
        const checkOutInRange = (checkOutDate >= start && checkOutDate <= end)
        
        if (!checkInInRange && !checkOutInRange) {
          return false
        }
      } else {
        if (checkInDate < start && checkOutDate < start) {
          return false
        }
      }
    } else if (appliedEndDate.value) {
      const end = new Date(appliedEndDate.value)
      end.setHours(23, 59, 59, 999)
      const checkInDate = new Date(bk.checkIn)
      checkInDate.setHours(0, 0, 0, 0)
      const checkOutDate = new Date(bk.checkOut)
      checkOutDate.setHours(0, 0, 0, 0)

      if (checkInDate > end && checkOutDate > end) {
        return false
      }
    }

    return true
  })
})

// Revenue state variables & functions
const selectedYear = ref(2026)
const availableYears = [2026, 2025, 2024]
const loadingRevenue = ref(false)
const errorRevenue = ref('')
const revenueData = ref(null)

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
  
  if (revenueData.value && revenueData.value.monthlyRevenues) {
    revenueData.value.monthlyRevenues.forEach(item => {
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
  if (!revenueData.value || !revenueData.value.totalBookings) return 0
  return ((count / revenueData.value.totalBookings) * 100).toFixed(1)
}

const getCommissionPercentage = computed(() => {
  if (revenueData.value && (revenueData.value.commissionRate !== undefined && revenueData.value.commissionRate !== null)) {
    return `${revenueData.value.commissionRate}%`
  }
  if (!revenueData.value || !revenueData.value.totalRevenue || !revenueData.value.totalHostEarning) return '15%'
  const diff = revenueData.value.totalRevenue - revenueData.value.totalHostEarning
  if (diff <= 0) return '15%'
  const percentage = (diff / revenueData.value.totalRevenue) * 100
  return `${percentage.toFixed(1)}%`
})

const fetchRevenueData = async () => {
  loadingRevenue.value = true
  errorRevenue.value = ''
  try {
    const response = await axios.get(`/revenue/host?year=${selectedYear.value}`)
    revenueData.value = response.data
  } catch (err) {
    console.error('Lấy doanh thu host thất bại:', err)
    errorRevenue.value = err.response?.data?.message || 'Không thể lấy dữ liệu báo cáo doanh thu từ server.'
    useFallbackMockup()
  } finally {
    loadingRevenue.value = false
  }
}

const useFallbackMockup = () => {
  const sampleRevenues = []
  const baseRevenues = [8, 12, 16, 20, 18, 22, 30, 32, 26, 18, 14, 12]
  baseRevenues.forEach((rev, idx) => {
    sampleRevenues.push({
      month: idx + 1,
      year: selectedYear.value,
      revenue: rev * 1000000,
      bookingCount: Math.round(rev * 0.7)
    })
  })

  const totalRev = baseRevenues.reduce((sum, r) => sum + r, 0) * 1000000
  revenueData.value = {
    totalRevenue: totalRev,
    totalHostEarning: totalRev * 0.85,
    totalBookings: 154,
    pendingBookings: 22,
    confirmedBookings: 38,
    completedBookings: 84,
    cancelledBookings: 10,
    totalRooms: rooms.value.length || 4,
    monthlyRevenues: sampleRevenues,
    topRooms: rooms.value.map((r, i) => ({
      roomId: r.id,
      roomName: r.name,
      city: r.city,
      totalRevenue: (20 - i * 3 > 0 ? 20 - i * 3 : 5) * 1000000,
      bookingCount: 15 - i * 2 > 0 ? 15 - i * 2 : 2
    })).slice(0, 4)
  }
  if (!revenueData.value.topRooms.length) {
    revenueData.value.topRooms = [
      { roomId: 1, roomName: "Biệt Thự Cổ Điển View Thung Lũng Mây", city: "Đà Lạt", totalRevenue: 45000000, bookingCount: 22 },
      { roomId: 2, roomName: "Phòng Deluxe Hướng Biển - Vinpearl Resort", city: "Đà Nẵng", totalRevenue: 38000000, bookingCount: 18 }
    ]
  }
}
// Danh sách tiện nghi có sẵn để chọn
const amenityOptions = computed(() => [
  { value: 'WiFi miễn phí', label: t('amenities.wifi') },
  { value: 'Hồ bơi', label: t('amenities.pool') },
  { value: 'Điều hòa', label: t('amenities.ac') },
  { value: 'Bãi đỗ xe', label: t('amenities.parking') },
  { value: 'Bếp', label: t('amenities.kitchen') },
  { value: 'TV', label: t('amenities.tv') },
  { value: 'Tủ lạnh', label: t('amenities.fridge') },
  { value: 'Máy giặt', label: t('amenities.washer') },
  { value: 'Bữa sáng miễn phí', label: t('amenities.breakfast') },
  { value: 'Phòng gym', label: t('amenities.gym') },
  { value: 'Bồn tắm', label: t('amenities.bathtub') },
  { value: 'View biển', label: t('amenities.sea_view') },
  { value: 'Ban công', label: t('amenities.balcony') },
  { value: 'Cho phép thú cưng', label: t('amenities.pets') }
])

const cityOptions = computed(() => [
  { value: 'Hà Nội', label: t('cities.hanoi') },
  { value: 'Đà Nẵng', label: t('cities.danang') },
  { value: 'Hồ Chí Minh', label: t('cities.hcm') },
  { value: 'Phú Quốc', label: t('cities.phuquoc') },
  { value: 'Đà Lạt', label: t('cities.dalat') },
  { value: 'Nha Trang', label: t('cities.nhatrang') }
])

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

// Modals
const showFormModal = ref(false)
const isEditMode = ref(false)
const roomForm = ref({
  id: null,
  name: '',
  roomTypeName: '',
  city: '',
  address: '',
  pricePerNight: 500000,
  maxGuests: 2,
  amenities: [],
  description: ''
})
const formLoading = ref(false)

// Image Upload & Management States
const isDragging = ref(false)
const fileInput = ref(null)
const selectedNewFiles = ref([])
const roomImages = ref([])

const showDeleteModal = ref(false)
const selectedRoom = ref(null)
const deleteLoading = ref(false)

const apiRevenue = ref(null)

// Compute total revenue
const totalRevenue = computed(() => {
  if (apiRevenue.value !== null) return apiRevenue.value
  return bookings.value
    .filter(b => b.status === 'COMPLETED' || b.status === 'PENDING')
    .reduce((sum, b) => sum + b.totalPrice, 0)
})

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  const currentLang = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return d.toLocaleDateString(currentLang)
}

const calculateDuration = (inStr, outStr) => {
  const diff = new Date(outStr) - new Date(inStr)
  return Math.max(1, Math.ceil(diff / (1000 * 60 * 60 * 24)))
}

const getStatusLabel = (status) => {
  switch (status) {
    case 'PENDING': return t('host.bookings.status_pending')
    case 'CONFIRMED': return t('host.bookings.status_confirmed')
    case 'COMPLETED': return t('host.bookings.status_completed')
    case 'CANCELLED': return t('host.bookings.status_cancelled')
    default: return status
  }
}

const formatPrice = (p) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p)

const formatCheckOut = (dateStr) => {
  if (!dateStr) return '--'
  const [year, month, day] = dateStr.split('-')
  return locale.value === 'en' ? `${month}/${day}/${year}` : `${day}/${month}/${year}`
}

// Fetch today's availability
const fetchTodayAvailability = async () => {
  loadingToday.value = true
  try {
    const res = await axios.get('/host/rooms/availability-today')
    todayAvailability.value = res.data ?? []
  } catch (err) {
    console.error('Lấy tình trạng phòng hôm nay thất bại:', err)
    todayAvailability.value = []
  } finally {
    loadingToday.value = false
  }
}

// Fetch data
const fetchHostData = async () => {
  try {
    const resRooms = await axios.get('/rooms/host')
    rooms.value = resRooms.data ?? []

    const resBookings = await axios.get('/bookings/host')
    bookings.value = resBookings.data


    try {
      const resRevenue = await axios.get('/revenue/host')
      if (resRevenue.data && typeof resRevenue.data === 'object') {
        apiRevenue.value = resRevenue.data.totalRevenue ?? resRevenue.data.amount ?? resRevenue.data.revenue ?? null
      } else if (typeof resRevenue.data === 'number') {
        apiRevenue.value = resRevenue.data
      }
    } catch (e) {
      console.warn('Lấy doanh thu từ API /revenue/host thất bại:', e)
    }
  } catch (err) {
    console.error('Lấy thông tin chủ nhà thất bại:', err)
  }
}

// Open Form Modal
const openAddModal = () => {
  isEditMode.value = false
  roomForm.value = {
    id: null,
    name: '',
    roomTypeName: '',
    city: '',
    address: '',
    pricePerNight: 500000,
    maxGuests: 2,
    amenities: [],
    description: ''
  }
  selectedNewFiles.value = []
  roomImages.value = []
  showFormModal.value = true
}

const openEditModal = (room) => {
  isEditMode.value = true
  roomForm.value = {
    id: room.id,
    name: room.name,
    roomTypeName: room.roomTypeName,
    city: room.city,
    address: room.address,
    pricePerNight: room.pricePerNight,
    maxGuests: room.maxGuests,
    amenities: room.amenities ? room.amenities.split(',').map(a => a.trim()).filter(Boolean) : [],
    description: room.description
  }
  selectedNewFiles.value = []
  
  if (room.images && room.images.length > 0) {
    roomImages.value = room.images.map(img => ({
      id: img.id,
      url: img.url || img.imageUrl,
      isPrimary: img.isPrimary || img.primary || false
    }))
  } else if (room.imageUrls) {
    roomImages.value = room.imageUrls.map((url, idx) => ({
      id: null,
      url: url,
      isPrimary: idx === 0
    }))
  } else {
    roomImages.value = []
  }
  showFormModal.value = true
}

// Drag & Drop / File Select Handlers
const triggerFileInput = () => {
  if (fileInput.value) fileInput.value.click()
}

const handleFileSelect = async (event) => {
  const files = Array.from(event.target.files)
  await uploadOrStoreFiles(files)
}

const handleDrop = async (event) => {
  isDragging.value = false
  const files = Array.from(event.dataTransfer.files).filter(f => f.type.startsWith('image/'))
  await uploadOrStoreFiles(files)
}

const uploadOrStoreFiles = async (files) => {
  if (files.length === 0) return
  
  if (isEditMode.value) {
    const formData = new FormData()
    files.forEach(file => {
      formData.append('files', file)
    })
    
    formLoading.value = true
    try {
      const roomId = roomForm.value.id
      await axios.post(`/images/rooms/${roomId}/upload`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
      
      const roomRes = await axios.get(`/rooms/${roomId}`)
      if (roomRes.data.images && roomRes.data.images.length > 0) {
        roomImages.value = roomRes.data.images.map(img => ({
          id: img.id,
          url: img.url || img.imageUrl,
          isPrimary: img.isPrimary || img.primary || false
        }))
      } else if (roomRes.data.imageUrls) {
        roomImages.value = roomRes.data.imageUrls.map((url, idx) => ({
          id: null,
          url: url,
          isPrimary: idx === 0
        }))
      }
      
      const idx = rooms.value.findIndex(r => r.id === roomId)
      if (idx !== -1) {
        rooms.value[idx] = roomRes.data
      }
    } catch (err) {
      console.error('Upload ảnh thất bại:', err)
      toastStore.error(err.response?.data?.message || err.message, 'Lỗi tải ảnh')
    } finally {
      formLoading.value = false
    }
  } else {
    files.forEach(file => {
      selectedNewFiles.value.push({
        file,
        previewUrl: URL.createObjectURL(file)
      })
    })
  }
}

const removeNewFile = (index) => {
  URL.revokeObjectURL(selectedNewFiles.value[index].previewUrl)
  selectedNewFiles.value.splice(index, 1)
}

// Action handlers for existing images
const setPrimaryImageAction = async (img, index) => {
  if (isEditMode.value && img.id) {
    formLoading.value = true
    try {
      await axios.patch(`/images/${img.id}/primary`)
      
      roomImages.value.forEach((im, i) => {
        im.isPrimary = (i === index)
      })
      
      const roomId = roomForm.value.id
      const roomRes = await axios.get(`/rooms/${roomId}`)
      const idx = rooms.value.findIndex(r => r.id === roomId)
      if (idx !== -1) {
        rooms.value[idx] = roomRes.data
      }
    } catch (err) {
      console.error('Đặt làm ảnh đại diện thất bại:', err)
      toastStore.error(err.response?.data?.message || err.message, 'Lỗi đặt ảnh đại diện')
    } finally {
      formLoading.value = false
    }
  } else {
    roomImages.value.forEach((im, i) => {
      im.isPrimary = (i === index)
    })
  }
}

const deleteImageAction = async (img, index) => {
  if (!confirm('Bạn có chắc chắn muốn xóa ảnh này?')) return
  
  if (isEditMode.value && img.id) {
    formLoading.value = true
    try {
      await axios.delete(`/images/${img.id}`)
      
      roomImages.value.splice(index, 1)
      
      const roomId = roomForm.value.id
      const roomRes = await axios.get(`/rooms/${roomId}`)
      const idx = rooms.value.findIndex(r => r.id === roomId)
      if (idx !== -1) {
        rooms.value[idx] = roomRes.data
      }
    } catch (err) {
      console.error('Xóa ảnh thất bại:', err)
      toastStore.error(err.response?.data?.message || err.message, 'Lỗi xóa ảnh')
    } finally {
      formLoading.value = false
    }
  } else {
    roomImages.value.splice(index, 1)
  }
}

// Create or update room
const saveRoom = async () => {
  if (!isEditMode.value && selectedNewFiles.value.length === 0) {
    toastStore.warning('Vui lòng chọn ít nhất một hình ảnh cho phòng nghỉ.')
    return
  }
  if (isEditMode.value && roomImages.value.length === 0) {
    toastStore.warning('Vui lòng tải lên ít nhất một hình ảnh cho phòng nghỉ.')
    return
  }

  formLoading.value = true
  const payload = {
    name: roomForm.value.name,
    roomTypeName: roomForm.value.roomTypeName,
    city: roomForm.value.city,
    address: roomForm.value.address,
    pricePerNight: roomForm.value.pricePerNight,
    maxGuests: roomForm.value.maxGuests,
    amenities: roomForm.value.amenities.join(', '),
    imageUrls: isEditMode.value ? roomImages.value.map(img => img.url) : [],
    description: roomForm.value.description
  }

  try {
    if (isEditMode.value) {
      const res = await axios.put(`/rooms/${roomForm.value.id}`, payload)
      const idx = rooms.value.findIndex(r => r.id === roomForm.value.id)
      if (idx !== -1) rooms.value[idx] = res.data
      toastStore.success('Đã cập nhật thông tin phòng nghỉ thành công.')
      showFormModal.value = false
    } else {
      const res = await axios.post('/rooms', payload)
      const createdRoomId = res.data.id
      
      if (selectedNewFiles.value.length > 0) {
        const formData = new FormData()
        selectedNewFiles.value.forEach(f => {
          formData.append('files', f.file)
        })
        
        await axios.post(`/images/rooms/${createdRoomId}/upload`, formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
      }
      
      const updatedRes = await axios.get(`/rooms/${createdRoomId}`)
      rooms.value.push(updatedRes.data)
      toastStore.success('Đã thêm mới phòng nghỉ thành công.')
      showFormModal.value = false
    }
  } catch (err) {
    console.error('Lưu phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Có lỗi xảy ra khi lưu thông tin phòng nghỉ.')
  } finally {
    formLoading.value = false
  }
}

// Delete room flow
const confirmDeleteRoom = (room) => {
  selectedRoom.value = room
  showDeleteModal.value = true
}

const executeDeleteRoom = async () => {
  if (!selectedRoom.value) return
  deleteLoading.value = true
  try {
    await axios.delete(`/rooms/${selectedRoom.value.id}`)
    rooms.value = rooms.value.filter(r => r.id !== selectedRoom.value.id)
    toastStore.success('Đã xóa phòng nghỉ thành công.')
    showDeleteModal.value = false
  } catch (err) {
    console.error('Xóa phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Không thể xóa phòng nghỉ. Vui lòng thử lại.')
  } finally {
    deleteLoading.value = false
    selectedRoom.value = null
  }
}

const confirmBooking = async (bookingId) => {
  try {
    const res = await axios.patch(`/bookings/${bookingId}/confirm`)
    const idx = bookings.value.findIndex(b => b.id === bookingId)
    if (idx !== -1) {
      bookings.value[idx].status = res.data.status
    }
    toastStore.success('Đã xác nhận đơn đặt phòng thành công.')
  } catch (err) {
    console.error('Xác nhận đặt phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Không thể xác nhận đơn đặt phòng.')
  }
}

const confirmCashPayment = async (bookingId) => {
  if (!confirm('Xác nhận bạn đã nhận đủ tiền mặt từ khách cho đơn này?')) return
  try {
    await axios.patch(`/bookings/${bookingId}/confirm-cash-payment`)
    toastStore.success('Đã xác nhận thanh toán tiền mặt thành công.')
    await fetchHostData()
  } catch (err) {
    console.error('Xác nhận thanh toán thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Không thể xác nhận thanh toán.')
  }
}

const completeBooking = async (bookingId) => {
  if (!confirm('Xác nhận hoàn thành đơn đặt phòng này? (Khách đã check-out và thanh toán đầy đủ)')) return
  try {
    await axios.patch(`/bookings/${bookingId}/complete`)
    toastStore.success('Đã xác nhận hoàn thành đơn đặt phòng.')
    await fetchHostData()
  } catch (err) {
    console.error('Hoàn thành đặt phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Không thể hoàn thành đơn đặt phòng.')
  }
}

const rejectBooking = async (bookingId) => {
  if (!confirm('Bạn có chắc chắn muốn hủy đơn đặt phòng này?')) return
  try {
    await axios.patch(`/bookings/${bookingId}/reject`)
    const idx = bookings.value.findIndex(b => b.id === bookingId)
    if (idx !== -1) {
      bookings.value[idx].status = 'CANCELLED'
    }
    toastStore.success('Đã hủy đơn đặt phòng thành công.')
  } catch (err) {
    console.error('Hủy đặt phòng thất bại:', err)
    toastStore.error(err.response?.data?.message || 'Không thể hủy đơn đặt phòng.')
  }
}

const handleLogout = () => {
  authStore.logout()
  router.push('/')
}

/**
 * Nhận danh sách phòng mới từ ExcelDataPanel sau khi import xong.
 * Cập nhật trực tiếp vào rooms ref — không cần reload cả trang.
 */
const onRoomsUpdated = (newRooms) => {
  rooms.value = newRooms
}

const fetchInvoices = async () => {
  try {
    const res = await getMyInvoices()
    invoices.value = res.data
  } catch (err) {
    console.error('Lỗi khi tải hóa đơn công nợ:', err)
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
    if (res.data && res.data.status === 'SUCCESS') {
      toastStore.success(locale.value === 'vi' ? 'Khấu trừ trực tiếp từ số dư khả dụng thành công!' : 'Successfully offset directly from available balance!')
      await fetchInvoices()
      await fetchPayoutData()
    } else if (res.data && res.data.paymentUrl) {
      window.location.href = res.data.paymentUrl
    } else {
      toastStore.error(t('host.toast_no_link'))
    }
  } catch (err) {
    toastStore.error(err.response?.data?.message || t('host.toast_pay_error'))
  } finally {
    payLoading.value = null
  }
}

const hostBalance = ref(0)
const payouts = ref([])
const showPayoutModal = ref(false)
const payoutSubmitting = ref(false)
const payoutForm = ref({
  amount: null,
  bankName: '',
  accountNumber: '',
  accountHolder: ''
})
const formattedAmount = ref('')
const showAllInvoices = ref(false)
const showAllPayouts = ref(false)
const roomQuery = ref('')
const roomSortBy = ref('revenue')

const sortedAndFilteredTopRooms = computed(() => {
  if (!revenueData.value || !revenueData.value.topRooms) return []
  let list = [...revenueData.value.topRooms]
  if (roomQuery.value.trim()) {
    const query = roomQuery.value.toLowerCase().trim()
    list = list.filter(r => r.roomName.toLowerCase().includes(query))
  }
  if (roomSortBy.value === 'revenue') {
    list.sort((a, b) => b.totalRevenue - a.totalRevenue)
  } else if (roomSortBy.value === 'bookings') {
    list.sort((a, b) => b.bookingCount - a.bookingCount)
  }
  return list
})


const handleAmountInput = (e) => {
  let value = e.target.value.replace(/\D/g, '')
  if (value) {
    let num = parseInt(value, 10)
    if (num > hostBalance.value) {
      num = hostBalance.value
    }
    payoutForm.value.amount = num
    formattedAmount.value = new Intl.NumberFormat('vi-VN').format(num)
  } else {
    payoutForm.value.amount = null
    formattedAmount.value = ''
  }
}

const fetchPayoutData = async () => {
  try {
    const resBalance = await axios.get('/payouts/balance')
    hostBalance.value = resBalance.data || 0

    const resPayouts = await axios.get('/payouts/host')
    payouts.value = resPayouts.data || []
  } catch (err) {
    console.error('Lỗi khi lấy thông tin rút tiền:', err)
  }
}

const openPayoutModal = () => {
  payoutForm.value.amount = hostBalance.value
  formattedAmount.value = new Intl.NumberFormat('vi-VN').format(hostBalance.value)
  payoutForm.value.bankName = ''
  payoutForm.value.accountNumber = ''
  payoutForm.value.accountHolder = ''
  showPayoutModal.value = true
}

const submitPayoutRequest = async () => {
  if (payoutForm.value.amount > hostBalance.value) {
    toastStore.error(locale.value === 'vi' ? 'Số tiền rút vượt quá số dư khả dụng' : 'Amount exceeds available balance')
    return
  }
  if (payoutForm.value.amount < 50000) {
    toastStore.error(locale.value === 'vi' ? 'Số tiền rút tối thiểu là 50,000 VND' : 'Minimum payout amount is 50,000 VND')
    return
  }
  payoutSubmitting.value = true
  try {
    const payload = {
      amount: payoutForm.value.amount,
      bankName: payoutForm.value.bankName,
      accountNumber: payoutForm.value.accountNumber,
      accountHolder: payoutForm.value.accountHolder.toUpperCase()
    }
    await axios.post('/payouts/request', payload)
    toastStore.success(locale.value === 'vi' ? 'Gửi yêu cầu rút tiền thành công' : 'Payout request submitted successfully')
    showPayoutModal.value = false
    await fetchPayoutData()
  } catch (err) {
    console.error('Lỗi khi gửi yêu cầu rút tiền:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Gửi yêu cầu rút tiền thất bại' : 'Failed to submit payout request'))
  } finally {
    payoutSubmitting.value = false
  }
}

const getPayoutStatusLabel = (status) => {
  switch (status) {
    case 'PENDING': return locale.value === 'vi' ? 'Chờ duyệt' : 'Pending'
    case 'APPROVED': return locale.value === 'vi' ? 'Đã duyệt' : 'Approved'
    case 'REJECTED': return locale.value === 'vi' ? 'Từ chối' : 'Rejected'
    default: return status
  }
}

// Profile and settings variables
const profileForm = ref({
  fullName: '',
  email: '',
  phone: '',
  avatarUrl: ''
})
const updatingProfile = ref(false)

const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})
const updatingPassword = ref(false)

const fetchUserProfile = async () => {
  try {
    const res = await getProfile()
    profileForm.value.fullName = res.data.fullName || ''
    profileForm.value.email = res.data.email || ''
    profileForm.value.phone = res.data.phone || ''
    profileForm.value.avatarUrl = res.data.avatarUrl || ''
    
    // Make sure local store stays in sync with backend user profile
    if (authStore.user) {
      authStore.user.avatarUrl = res.data.avatarUrl
      authStore.user.fullName = res.data.fullName
      localStorage.setItem('user', JSON.stringify(authStore.user))
    }
  } catch (err) {
    console.error('Lỗi khi tải thông tin cá nhân:', err)
  }
}

const handleUpdateProfile = async () => {
  updatingProfile.value = true
  try {
    const res = await updateProfile({
      fullName: profileForm.value.fullName,
      phone: profileForm.value.phone,
      avatarUrl: profileForm.value.avatarUrl
    })
    toastStore.success(locale.value === 'vi' ? 'Cập nhật thông tin thành công!' : 'Profile updated successfully!')
    
    // Update local user object in store so sidebar avatar/name changes dynamically!
    if (authStore.user) {
      authStore.user.fullName = res.data.fullName
      authStore.user.phone = res.data.phone
      authStore.user.avatarUrl = res.data.avatarUrl
      // Save updated user to localstorage so it persists across refreshes
      localStorage.setItem('user', JSON.stringify(authStore.user))
    }
  } catch (err) {
    console.error('Lỗi khi cập nhật thông tin:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Cập nhật thông tin thất bại!' : 'Failed to update profile!'))
  } finally {
    updatingProfile.value = false
  }
}

const handleUpdatePassword = async () => {
  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    toastStore.error(locale.value === 'vi' ? 'Mật khẩu xác nhận không khớp!' : 'Confirm password does not match!')
    return
  }
  updatingPassword.value = true
  try {
    await changePassword({
      oldPassword: passwordForm.value.oldPassword,
      newPassword: passwordForm.value.newPassword
    })
    toastStore.success(locale.value === 'vi' ? 'Đổi mật khẩu thành công!' : 'Password updated successfully!')
    passwordForm.value.oldPassword = ''
    passwordForm.value.newPassword = ''
    passwordForm.value.confirmPassword = ''
  } catch (err) {
    console.error('Lỗi khi đổi mật khẩu:', err)
    toastStore.error(err.response?.data?.message || (locale.value === 'vi' ? 'Đổi mật khẩu thất bại!' : 'Failed to change password!'))
  } finally {
    updatingPassword.value = false
  }
}

onMounted(() => {
  if (!authStore.isLoggedIn) {
    router.push('/login')
  } else if (authStore.role !== 'HOST' && authStore.role !== 'ADMIN') {
    router.push('/')
  } else {
    fetchHostData()
    fetchTodayAvailability()
    fetchRevenueData()
    fetchInvoices()
    fetchPayoutData()
    fetchUserProfile()
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; background: #f8f9fc; color: #1e293b; }
.container { max-width: 1200px; margin: 0 auto; padding: 0 1.5rem; }
.min-h-screen { min-height: 100vh; display: flex; flex-direction: column; font-family: 'Inter', sans-serif; }

/* HEADER */
.header {
  background: white; border-bottom: 1px solid #e2e8f0;
  position: sticky; top: 0; z-index: 50; padding: 0.9rem 0;
}
.header .container { display: flex; justify-content: space-between; align-items: center; }
.logo { 
  font-size: 1.4rem; 
  font-weight: 800; 
  letter-spacing: -0.05em; 
  color: #1a6cf7; 
  text-decoration: none; 
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
}
.logo-brand-icon, .logo-word {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.logo:hover {
  color: #ff385c !important;
}
.logo:hover .logo-brand-icon {
  transform: rotate(-10deg) scale(1.15) !important;
  stroke: #ff385c !important;
}
.logo-red { color: #ff567d; }
.divider { margin: 0 0.5rem; color: #cbd5e1; font-weight: 300; }
.panel-tag { font-size: 0.85rem; font-weight: 700; background: #faf5ff; color: #a855f7; border: 1px solid #f3e8ff; padding: 0.2rem 0.6rem; border-radius: 6px; }
.header-right { display: flex; align-items: center; gap: 1rem; }
.btn-back { font-size: 0.875rem; font-weight: 600; color: #64748b; text-decoration: none; transition: color 0.2s; }
.btn-back:hover { color: #1a6cf7; }
.user-name { font-size: 0.875rem; font-weight: 600; color: #1e293b; }
.btn-outline {
  padding: 0.45rem 1.1rem; border-radius: 999px; font-size: 0.85rem; font-weight: 600;
  border: 1.5px solid #1a6cf7; color: #1a6cf7; background: transparent;
  cursor: pointer; text-decoration: none; transition: all 0.2s;
}
.btn-outline:hover { background: #1a6cf7; color: white; }

/* MAIN CONTENT */
.main-content { padding-top: 2.5rem; padding-bottom: 5rem; }

/* ANALYTICS */
.analytics-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-bottom: 2.5rem; }
.analytic-card { background: white; border: 1px solid #e2e8f0; border-radius: 18px; padding: 1.5rem; display: flex; align-items: center; gap: 1.25rem; }
.icon-wrap { width: 50px; height: 50px; border-radius: 14px; background: #eff6ff; color: #1a6cf7; display: flex; align-items: center; justify-content: center; }
.icon-wrap.color-green { background: #ecfdf5; color: #10b981; }
.icon-wrap.color-pink { background: #fff1f2; color: #f43f5e; }
.analytic-card h4 { font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.analytic-card .val { font-size: 1.25rem; font-weight: 800; color: #0f172a; margin-top: 0.2rem; display: block; }

/* TABS */
.tabs-container { display: flex; gap: 0.5rem; border-bottom: 2px solid #e2e8f0; margin-bottom: 2rem; }
.tab-btn {
  background: none; border: none; padding: 0.9rem 1.5rem; font-size: 0.95rem; font-weight: 700;
  color: #64748b; cursor: pointer; transition: all 0.2s; border-bottom: 2px solid transparent;
  margin-bottom: -2px; display: flex; align-items: center; gap: 0.5rem; font-family: 'Inter', sans-serif;
}
.tab-btn.active { color: #1a6cf7; border-bottom-color: #1a6cf7; }

.tab-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
.tab-header h2 { font-size: 1.35rem; font-weight: 800; color: #0f172a; }
.btn-add-room {
  background: #1a6cf7; color: white; border: none; padding: 0.6rem 1.2rem; border-radius: 10px;
  font-size: 0.85rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.35rem;
  box-shadow: 0 4px 12px rgba(26,108,247,0.25); transition: background 0.2s; font-family: 'Inter', sans-serif;
}
.btn-add-room:hover { background: #1558d6; }

/* ROOMS GRID */
.rooms-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 1.5rem; }
.room-card { background: white; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; display: flex; flex-direction: column; }
.room-img { height: 160px; position: relative; background: #eff6ff; }
.room-img img { width: 100%; height: 100%; object-fit: cover; }
.room-type-badge { position: absolute; top: 0.75rem; left: 0.75rem; background: rgba(0,0,0,0.6); color: white; font-size: 0.7rem; font-weight: 600; padding: 0.2rem 0.5rem; border-radius: 6px; }
.room-status-badge { position: absolute; top: 0.75rem; right: 0.75rem; font-size: 0.7rem; font-weight: 800; padding: 0.2rem 0.5rem; border-radius: 6px; text-transform: uppercase; letter-spacing: 0.02em; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
.room-status-badge.pending { background: #fffbeb; color: #d97706; border: 1.5px solid #fef3c7; }
.room-status-badge.active { background: #ecfdf5; color: #059669; border: 1.5px solid #d1fae5; }
.status-badge.confirmed { background: #eff6ff; color: #1a6cf7; }
.room-details { padding: 1.25rem; display: flex; flex-direction: column; flex: 1; }
.room-details h3 { font-size: 1rem; font-weight: 800; color: #1e293b; margin-bottom: 0.25rem; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 2.8em; }
.room-details .addr { font-size: 0.8rem; color: #64748b; margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.2rem; }
.specs { display: flex; gap: 0.75rem; font-size: 0.78rem; color: #64748b; font-weight: 500; margin-bottom: 0.75rem; }
.specs .rating { color: #d97706; display: flex; align-items: center; gap: 0.15rem; font-weight: 700; }
.amenities-tags { display: flex; flex-wrap: wrap; gap: 0.35rem; margin-bottom: 0.75rem; }
.amenity-tag {
  font-size: 0.7rem; font-weight: 600; color: #475569;
  background: #f1f5f9; padding: 0.15rem 0.5rem; border-radius: 999px;
}
.amenity-tag.more { background: #e2e8f0; color: #64748b; }
.price-row { margin-bottom: 1rem; margin-top: auto; }
.price { font-size: 1.1rem; font-weight: 800; color: #1a6cf7; }
.price small { font-size: 0.75rem; font-weight: 500; color: #94a3b8; }
.card-actions { display: flex; gap: 0.5rem; border-top: 1px solid #f1f5f9; padding-top: 0.75rem; }
.card-actions button { flex: 1; padding: 0.45rem; border-radius: 8px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 0.25rem; font-family: 'Inter', sans-serif; }
.btn-edit { background: #f1f5f9; border: none; color: #475569; }
.btn-edit:hover { background: #e2e8f0; }
.btn-delete { background: white; border: 1.5px solid #ef4444; color: #ef4444; }
.btn-delete:hover { background: #fef2f2; }

/* TABLE BOOKINGS */
.table-container { background: white; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
.bookings-table { width: 100%; border-collapse: collapse; text-align: left; }
.bookings-table th { background: #f8fafc; padding: 1rem 1.5rem; font-size: 0.75rem; font-weight: 800; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #e2e8f0; }
.bookings-table td { padding: 1.25rem 1.5rem; border-bottom: 1px solid #f1f5f9; font-size: 0.875rem; color: #334155; }
.bookings-table tr:last-child td { border-bottom: none; }
.table-room-info { display: flex; align-items: center; gap: 0.75rem; }
.table-room-img { width: 50px; height: 50px; border-radius: 8px; object-fit: cover; background: #e2e8f0; }
.table-room-info .name { font-weight: 700; color: #1e293b; }
.table-room-info .city { color: #94a3b8; }
.bookings-table .name { font-weight: 700; color: #1e293b; }
.bookings-table .contact { color: #64748b; }
.stay-dates { font-weight: 700; }
.duration { color: #94a3b8; }
.color-green { color: #10b981; }

.status-badge {
  display: inline-block; font-size: 0.7rem; font-weight: 800;
  padding: 0.2rem 0.5rem; border-radius: 6px; text-transform: uppercase; letter-spacing: 0.02em;
}
.status-badge.pending { background: #fffbeb; color: #d97706; }
.status-badge.completed { background: #ecfdf5; color: #059669; }
.status-badge.cancelled { background: #fef2f2; color: #dc2626; }

/* EMPTY STATE */
.empty-state { text-align: center; padding: 4rem 2rem; background: white; border: 1px solid #e2e8f0; border-radius: 18px; color: #64748b; }
.color-gray { color: #cbd5e1; }
.empty-state h3 { font-size: 1.2rem; font-weight: 700; color: #1e293b; margin-top: 1rem; margin-bottom: 0.5rem; }
.empty-state p { font-size: 0.9rem; max-width: 320px; margin: 0 auto; }
.mt-4 { margin-top: 1rem; }

/* MODAL ROOM FORM */
.modal-backdrop { position: fixed; inset: 0; background: rgba(15,23,42,0.6); backdrop-filter: blur(4px); z-index: 1000; display: flex; align-items: center; justify-content: center; padding: 1rem; }
.room-modal { background: white; border-radius: 20px; width: 100%; max-width: 600px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 25px 50px rgba(0,0,0,0.15); max-height: 90vh; }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 1.25rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
.modal-header h2 { font-size: 1.2rem; font-weight: 800; color: #0f172a; }
.btn-close { background: none; border: none; font-size: 1.75rem; cursor: pointer; color: #94a3b8; }
.btn-close:hover { color: #1e293b; }

.modal-form { padding: 1.5rem; overflow-y: auto; display: flex; flex-direction: column; gap: 1.1rem; }
.form-row { display: flex; gap: 1rem; }
.form-group { display: flex; flex-direction: column; gap: 0.4rem; flex: 1; }
.form-group label { font-size: 0.72rem; font-weight: 800; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; }
.form-group input, .form-group select, .form-group textarea {
  padding: 0.65rem 0.8rem; border-radius: 10px; border: 1.5px solid #dde1e9;
  font-size: 0.875rem; font-weight: 600; color: #1e293b; outline: none; background: #fafbfc;
  transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #1a6cf7; background: white; box-shadow: 0 0 0 3px rgba(26,108,247,0.1); }

.amenity-checkboxes { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.5rem; background: #f8fafc; border-radius: 10px; padding: 1rem; border: 1px solid #e2e8f0; }
.checkbox-lbl { display: flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; font-weight: 600; color: #475569; cursor: pointer; }
.checkbox-lbl input { width: auto; }

.btn-cancel { background: #f1f5f9; border: none; color: #475569; padding: 0.65rem 1.5rem; border-radius: 10px; font-weight: 700; font-size: 0.9rem; cursor: pointer; font-family: 'Inter', sans-serif; }
.btn-cancel:hover { background: #e2e8f0; }
.btn-submit { background: #1a6cf7; color: white; border: none; padding: 0.65rem 1.5rem; border-radius: 10px; font-weight: 700; font-size: 0.9rem; cursor: pointer; font-family: 'Inter', sans-serif; box-shadow: 0 4px 12px rgba(26,108,247,0.25); }
.btn-submit:hover { background: #1558d6; }
.btn-submit:disabled { opacity: 0.6; cursor: not-allowed; }

/* CONFIRM MODAL */
.confirm-modal { background: white; border-radius: 18px; padding: 2rem; width: 100%; max-width: 420px; box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
.confirm-modal h3 { font-size: 1.2rem; font-weight: 800; color: #0f172a; margin-bottom: 0.75rem; }
.confirm-modal p { font-size: 0.9rem; color: #475569; line-height: 1.5; margin-bottom: 1.5rem; }
.btn-confirm-delete { background: #ef4444; border: none; color: white; padding: 0.65rem 1.5rem; border-radius: 10px; font-weight: 700; font-size: 0.9rem; cursor: pointer; font-family: 'Inter', sans-serif; }
.btn-confirm-delete:hover { background: #dc2626; }

.spinner-small { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.4); border-top-color: white; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }
@keyframes spin { to { transform: rotate(360deg); } }

/* ===== TODAY AVAILABILITY SECTION ===== */
.today-section {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 20px;
  padding: 1.75rem;
  margin-bottom: 2rem;
  box-shadow: 0 4px 20px rgba(0,0,0,0.04);
}

.today-section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.25rem;
}

.today-title-wrap {
  display: flex;
  align-items: center;
  gap: 0.65rem;
}

.today-pulse-dot {
  width: 10px;
  height: 10px;
  background: #10b981;
  border-radius: 50%;
  position: relative;
  flex-shrink: 0;
}
.today-pulse-dot::after {
  content: '';
  position: absolute;
  inset: -3px;
  border-radius: 50%;
  background: rgba(16, 185, 129, 0.3);
  animation: pulse-ring 1.8s ease-out infinite;
}
@keyframes pulse-ring {
  0% { transform: scale(0.8); opacity: 1; }
  100% { transform: scale(2); opacity: 0; }
}

.today-title {
  font-size: 1.2rem;
  font-weight: 800;
  color: #0f172a;
  margin: 0;
}

.today-date-badge {
  font-size: 0.72rem;
  font-weight: 600;
  color: #5392f9;
  background: #eff6ff;
  border: 1px solid #bfdbfe;
  padding: 0.2rem 0.6rem;
  border-radius: 999px;
  white-space: nowrap;
}

.btn-refresh {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  background: #f8fafc;
  border: 1.5px solid #e2e8f0;
  color: #475569;
  padding: 0.5rem 1rem;
  border-radius: 10px;
  font-size: 0.82rem;
  font-weight: 700;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  transition: all 0.2s;
  flex-shrink: 0;
}
.btn-refresh:hover:not(:disabled) {
  background: #eff6ff;
  border-color: #5392f9;
  color: #5392f9;
}
.btn-refresh:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.spin-icon {
  animation: spin 0.8s linear infinite;
}

/* Summary bar */
.today-summary-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
  border: 1px solid #d1fae5;
  border-radius: 12px;
  padding: 0.85rem 1.25rem;
  margin-bottom: 1.25rem;
  gap: 1rem;
}

.summary-text {
  display: flex;
  align-items: baseline;
  gap: 0.3rem;
  font-family: 'Inter', sans-serif;
}
.summary-available {
  font-size: 1.5rem;
  font-weight: 900;
  color: #10b981;
  line-height: 1;
}
.summary-sep {
  font-size: 1.2rem;
  font-weight: 700;
  color: #94a3b8;
}
.summary-total {
  font-size: 1.5rem;
  font-weight: 900;
  color: #0f172a;
  line-height: 1;
}
.summary-label {
  font-size: 0.85rem;
  font-weight: 600;
  color: #475569;
  margin-left: 0.2rem;
}

.summary-progress-wrap {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  min-width: 200px;
}
.summary-progress-track {
  flex: 1;
  height: 8px;
  background: #d1fae5;
  border-radius: 999px;
  overflow: hidden;
}
.summary-progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #10b981, #34d399);
  border-radius: 999px;
  transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}
.summary-percent {
  font-size: 0.82rem;
  font-weight: 800;
  color: #10b981;
  min-width: 36px;
  text-align: right;
}

/* Today Grid */
.today-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 1.25rem;
}

.today-card {
  border-radius: 16px;
  overflow: hidden;
  background: white;
  border: 1.5px solid #e2e8f0;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
}
.today-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0,0,0,0.1);
}
.today-card--available {
  border-color: #bbf7d0;
}
.today-card--available:hover {
  border-color: #10b981;
  box-shadow: 0 12px 32px rgba(16,185,129,0.12);
}
.today-card--occupied {
  border-color: #fde68a;
}
.today-card--occupied:hover {
  border-color: #f59e0b;
  box-shadow: 0 12px 32px rgba(245,158,11,0.12);
}

.today-card-img {
  position: relative;
  height: 148px;
  overflow: hidden;
  background: #f1f5f9;
}
.today-card-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}
.today-card:hover .today-card-img img {
  transform: scale(1.06);
}
.img-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.3) 0%, transparent 55%);
  pointer-events: none;
}

/* Availability badges */
.avail-badge {
  position: absolute;
  top: 0.65rem;
  right: 0.65rem;
  display: flex;
  align-items: center;
  gap: 0.3rem;
  font-size: 0.68rem;
  font-weight: 800;
  padding: 0.25rem 0.6rem;
  border-radius: 999px;
  z-index: 2;
  letter-spacing: 0.01em;
  backdrop-filter: blur(6px);
  box-shadow: 0 2px 8px rgba(0,0,0,0.12);
}
.avail-badge--green {
  background: rgba(16, 185, 129, 0.92);
  color: white;
}
.avail-badge--orange {
  background: rgba(245, 158, 11, 0.92);
  color: white;
}
.badge-dot {
  width: 5px;
  height: 5px;
  background: currentColor;
  border-radius: 50%;
  opacity: 0.9;
  animation: badge-blink 2s ease-in-out infinite;
}
@keyframes badge-blink {
  0%, 100% { opacity: 0.9; }
  50% { opacity: 0.4; }
}

/* Card body */
.today-card-body {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  flex: 1;
}
.today-card-name {
  font-size: 0.9rem;
  font-weight: 800;
  color: #0f172a;
  line-height: 1.35;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin: 0;
}
.today-card-city {
  font-size: 0.75rem;
  color: #94a3b8;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.2rem;
  margin: 0;
}

/* Price (available) */
.today-card-price {
  margin-top: auto;
  padding-top: 0.6rem;
  display: flex;
  align-items: baseline;
  gap: 0.2rem;
}
.price-amount {
  font-size: 1rem;
  font-weight: 900;
  color: #10b981;
}
.price-unit {
  font-size: 0.72rem;
  font-weight: 600;
  color: #94a3b8;
}

/* Guest info (occupied) */
.today-card-guest {
  margin-top: auto;
  padding-top: 0.6rem;
  border-top: 1px dashed #fde68a;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}
.guest-row {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.78rem;
  color: #475569;
  font-weight: 500;
}
.guest-row strong {
  font-weight: 700;
  color: #1e293b;
}
.checkout-row {
  color: #d97706;
}
.checkout-row strong {
  color: #92400e;
}

/* Loading shimmer */
.today-loading { margin-top: 0.5rem; }
.loading-shimmer-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 1.25rem;
}
.shimmer-card {
  height: 230px;
  border-radius: 16px;
  background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
  background-size: 200% 100%;
  animation: shimmer 1.4s infinite linear;
}
@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* Empty state */
.today-empty {
  text-align: center;
  padding: 2.5rem;
  color: #94a3b8;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
}
.today-empty p {
  font-size: 0.9rem;
  font-weight: 600;
}

@media (max-width: 768px) {
  .today-section-header { flex-direction: column; align-items: flex-start; gap: 0.75rem; }
  .today-summary-bar { flex-direction: column; align-items: flex-start; }
  .summary-progress-wrap { width: 100%; min-width: unset; }
  .today-grid { grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); }
}

@media (max-width: 1024px) {
  .analytics-row { grid-template-columns: 1fr; gap: 1rem; }
}
@media (max-width: 768px) {
  .tab-header { flex-direction: column; align-items: flex-start; gap: 1rem; }
  .btn-add-room { width: 100%; justify-content: center; }
  .form-row { flex-direction: column; gap: 1rem; }
  .table-container { overflow-x: auto; }
}

/* TABLE ACTIONS & BUTTONS */
.table-actions { display: flex; gap: 0.5rem; }
.btn-table-approve { background: #ecfdf5; border: none; color: #059669; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 0.25rem; transition: all 0.2s; font-family: 'Inter', sans-serif; }
.btn-table-approve:hover { background: #d1fae5; }
.btn-table-delete { background: white; border: 1px solid #ef4444; color: #ef4444; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 0.25rem; transition: all 0.2s; font-family: 'Inter', sans-serif; }
.btn-table-delete:hover { background: #fef2f2; }
.color-gray { color: #cbd5e1; }

/* Custom premium styling for image upload */
.image-upload-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.upload-dropzone {
  border: 2px dashed #cbd5e1;
  border-radius: 12px;
  padding: 1.5rem;
  text-align: center;
  background: #f8fafc;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-dropzone:hover, .upload-dropzone.dragging {
  border-color: #1a6cf7;
  background: #eff6ff;
}

.hidden-file-input {
  display: none;
}

.dropzone-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  color: #64748b;
}

.upload-icon {
  color: #94a3b8;
  transition: color 0.2s ease;
}

.upload-dropzone:hover .upload-icon, .upload-dropzone.dragging .upload-icon {
  color: #1a6cf7;
}

.main-text {
  font-size: 0.9rem;
  font-weight: 700;
  color: #334155;
}

.sub-text {
  font-size: 0.75rem;
  color: #64748b;
}

.new-files-preview-list, .existing-files-preview-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-top: 0.25rem;
}

.preview-title {
  font-size: 0.75rem;
  font-weight: 700;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.images-grid-preview {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(90px, 1fr));
  gap: 0.75rem;
}

.preview-card {
  position: relative;
  aspect-ratio: 1;
  border-radius: 10px;
  overflow: hidden;
  border: 2px solid #e2e8f0;
  box-shadow: 0 2px 4px rgba(0,0,0,0.02);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  background: #f1f5f9;
}

.preview-card.is-primary {
  border-color: #ffb703;
  box-shadow: 0 0 0 3px rgba(255, 183, 3, 0.25);
}

.preview-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.preview-card:hover img {
  transform: scale(1.08);
}

.card-badges {
  position: absolute;
  top: 0.3rem;
  left: 0.3rem;
  z-index: 2;
}

.primary-badge {
  background: #ffb703;
  color: #0f172a;
  font-size: 0.6rem;
  font-weight: 800;
  padding: 0.15rem 0.35rem;
  border-radius: 4px;
  display: flex;
  align-items: center;
  gap: 0.15rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.preview-actions-overlay {
  position: absolute;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.4rem;
  opacity: 0;
  transition: opacity 0.2s ease;
  backdrop-filter: blur(1.5px);
  z-index: 3;
}

.preview-card:hover .preview-actions-overlay {
  opacity: 1;
}

.action-btn {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 4px rgba(0,0,0,0.15);
}

.action-btn.set-primary-btn {
  background: rgba(255, 255, 255, 0.3);
}

.action-btn.set-primary-btn:hover {
  background: #ffb703;
  color: #0f172a;
  transform: scale(1.1);
}

.action-btn.delete-btn {
  background: rgba(239, 68, 68, 0.85);
}

.action-btn.delete-btn:hover {
  background: #ef4444;
  transform: scale(1.1);
}

/* ===== SIDEBAR LAYOUT STYLES ===== */
.host-dashboard-layout {
  display: flex;
  min-height: 100vh;
  background: #f8fafc;
  font-family: 'Inter', sans-serif;
  color: #1e293b;
}

.host-sidebar {
  width: 260px;
  background: white;
  border-right: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: 100;
  padding: 1.5rem 1.25rem;
}

.sidebar-logo {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 2rem;
}

.sidebar-logo .logo {
  font-size: 1.4rem;
  font-weight: 800;
  letter-spacing: -0.05em;
  color: #1a6cf7;
  text-decoration: none;
}
.sidebar-logo .logo-red {
  color: #ff567d;
}

.sidebar-profile {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 0.5rem;
  background: #f8fafc;
  border-radius: 12px;
  margin-bottom: 1.75rem;
  border: 1px solid #f1f5f9;
}

.profile-avatar {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: #5392f9;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 1.1rem;
}

.profile-info {
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.profile-name {
  font-size: 0.85rem;
  font-weight: 700;
  color: #1e293b;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

.profile-role {
  font-size: 0.72rem;
  font-weight: 600;
  color: #64748b;
}

.sidebar-menu {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  flex: 1;
}

.menu-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  border: none;
  background: none;
  color: #64748b;
  font-size: 0.875rem;
  font-weight: 700;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
  text-align: left;
  font-family: 'Inter', sans-serif;
}

.menu-item:hover {
  background: #f1f5f9;
  color: #1e293b;
}

.menu-item.active {
  background: #eff6ff;
  color: #1a6cf7;
}

.sidebar-footer {
  border-top: 1px solid #e2e8f0;
  padding-top: 1.25rem;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.sidebar-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.6rem 1rem;
  color: #64748b;
  text-decoration: none;
  font-size: 0.85rem;
  font-weight: 600;
  border-radius: 8px;
  transition: all 0.2s;
}

.sidebar-link:hover {
  background: #f8fafc;
  color: #1a6cf7;
}

.btn-logout-sidebar {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.6rem 1rem;
  background: none;
  border: none;
  color: #ef4444;
  font-size: 0.85rem;
  font-weight: 700;
  border-radius: 8px;
  cursor: pointer;
  width: 100%;
  text-align: left;
  transition: all 0.2s;
  font-family: 'Inter', sans-serif;
}

.btn-logout-sidebar:hover {
  background: #fef2f2;
}

/* MAIN CONTAINER STYLES */
.host-main-container {
  flex: 1;
  margin-left: 260px;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

.host-top-header {
  background: white;
  border-bottom: 1px solid #e2e8f0;
  padding: 1.25rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 90;
}

.header-title-section {
  display: flex;
  flex-direction: column;
}

.page-title {
  font-size: 1.4rem;
  font-weight: 800;
  color: #0f172a;
  letter-spacing: -0.02em;
  margin: 0;
}

.page-subtitle {
  font-size: 0.82rem;
  color: #64748b;
  margin: 0;
  margin-top: 0.25rem;
}

.today-date-top {
  font-size: 0.78rem;
  font-weight: 700;
  color: #475569;
  background: #f1f5f9;
  padding: 0.4rem 0.85rem;
  border-radius: 8px;
  white-space: nowrap;
}

.host-main-content {
  padding: 2rem;
  flex: 1;
}

.fade-in-tab {
  animation: tabFadeIn 0.3s ease;
}

@keyframes tabFadeIn {
  from { opacity: 0; transform: translateY(6px); }
  to { opacity: 1; transform: translateY(0); }
}

/* REVENUE INTEGRATED STYLES */
.revenue-filter-row {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 1.5rem;
}

.revenue-filter-row .filter-box {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 0.5rem 1rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.02);
}

.revenue-filter-row .filter-box label {
  font-size: 0.85rem;
  font-weight: 600;
  color: #64748b;
}

.revenue-filter-row .select-input {
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

.revenue-filter-row .select-input:focus {
  border-color: #5392f9;
}

.revenue-loading, .revenue-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
}

.revenue-dashboard-content {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}

.stats-grid-rev {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1rem;
}

@media (max-width: 1366px) {
  .stats-grid-rev {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-grid-rev {
    grid-template-columns: 1fr;
  }
}

.stats-grid-rev .stat-card {
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

.stats-grid-rev .stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05);
}

.stats-grid-rev .stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stats-grid-rev .stat-icon.rev-color {
  background: #eff6ff;
  color: #5392f9;
}

.stats-grid-rev .stat-icon.booking-color {
  background: #fdf2f8;
  color: #ff567d;
}

.stats-grid-rev .stat-icon.room-color {
  background: #f0fdf4;
  color: #10b981;
}

.stats-grid-rev .host-net-card {
  border: 1.5px solid #10b981 !important;
  box-shadow: 0 4px 20px rgba(16, 185, 129, 0.08) !important;
}

.stats-grid-rev .stat-icon.net-color {
  background: #ecfdf5;
  color: #10b981;
}

.stats-grid-rev .highlight-green {
  color: #10b981 !important;
}

.stats-grid-rev .stat-sub {
  display: block;
  font-size: 0.72rem;
  color: #64748b;
  margin-top: 0.25rem;
  font-weight: 500;
}

.stats-grid-rev .stat-info h4 {
  font-size: 0.75rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.25rem;
}

.stats-grid-rev .stat-val {
  font-size: 1.15rem;
  font-weight: 800;
  color: #1e293b;
  letter-spacing: -0.01em;
  white-space: nowrap;
}

.dashboard-row-rev {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
}

@media (max-width: 1024px) {
  .dashboard-row-rev {
    grid-template-columns: 1fr;
  }
}

/* CSS Chart Styles */
.chart-card {
  display: flex;
  flex-direction: column;
}

.chart-container {
  height: 300px;
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
  margin-top: 0;
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

.revenue-loading, .revenue-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  margin-top: 1rem;
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

/* Booking Filters Bar */
.booking-filters-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  gap: 1.25rem;
  background: white;
  padding: 1.25rem;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.04);
  margin-bottom: 1.5rem;
}

.booking-filters-bar .filter-item {
  display: flex;
  flex-direction: column;
  flex: 1 1 180px;
  min-width: 150px;
}

.booking-filters-bar .filter-item label {
  font-size: 0.75rem;
  font-weight: 700;
  color: #64748b;
  margin-bottom: 0.4rem;
  text-transform: uppercase;
  letter-spacing: 0.02em;
}

.booking-filters-bar .select-input,
.booking-filters-bar .date-input {
  height: 38px;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  padding: 0 0.75rem;
  font-size: 0.9rem;
  color: #334155;
  outline: none;
  transition: all 0.2s ease;
  background-color: #ffffff;
  width: 100%;
}

.booking-filters-bar .select-input:focus,
.booking-filters-bar .date-input:focus {
  border-color: #5392f9;
  box-shadow: 0 0 0 3px rgba(83, 146, 249, 0.12);
}

.booking-filters-bar .filter-actions {
  display: flex;
  gap: 0.75rem;
  margin-top: auto;
  align-items: center;
}

.booking-filters-bar .btn-filter-apply {
  background: #5392f9;
  color: white;
  border: none;
  height: 38px;
  padding: 0 1.25rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s ease;
  white-space: nowrap;
}

.booking-filters-bar .btn-filter-apply:hover {
  background: #3b7ddd;
}

.booking-filters-bar .btn-filter-clear {
  background: white;
  color: #64748b;
  border: 1px solid #cbd5e1;
  height: 38px;
  padding: 0 1.25rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
}

.booking-filters-bar .btn-filter-clear:hover {
  background: #f1f5f9;
  color: #334155;
  border-color: #94a3b8;
}

.empty-state--no-match {
  padding: 4rem 2rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  text-align: center;
}

.empty-state--no-match h3 {
  margin-top: 1rem;
  color: #334155;
  font-size: 1.2rem;
  font-weight: 700;
}

.empty-state--no-match p {
  color: #64748b;
  margin-top: 0.5rem;
}

@media (max-width: 768px) {
  .host-sidebar {
    width: 70px;
    padding: 1.5rem 0.5rem;
  }
  .sidebar-logo .logo, .sidebar-logo .panel-tag, .sidebar-profile .profile-info, .menu-item span, .sidebar-footer span {
    display: none;
  }
  .sidebar-profile {
    justify-content: center;
  }
  .menu-item {
    justify-content: center;
    padding: 0.75rem;
  }
  .host-main-container {
    margin-left: 70px;
  }
  .host-top-header {
    padding: 1rem;
  }
  .booking-filters-bar {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
  }
  .booking-filters-bar .filter-actions {
    width: 100%;
    margin-top: 0.5rem;
  }
  .booking-filters-bar .btn-filter-apply,
  .booking-filters-bar .btn-filter-clear {
    flex: 1;
    text-align: center;
  }
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
  color: #d97706;
  border: 1px solid #fde68a;
}

.status-badge.overdue {
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fca5a5;
}

.status-badge.paid {
  background: #ecfdf5;
  color: #059669;
  border: 1px solid #a7f3d0;
}

.btn-primary-sm {
  background: #1a6cf7;
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
  background: #1558d6;
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

.status-badge.approved {
  background: #f0fdf4;
  color: #10b981;
}

.status-badge.rejected {
  background: #fef2f2;
  color: #ef4444;
}

.btn-cancel {
  background: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #475569;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-cancel:hover {
  background: #e2e8f0;
}

.tables-row-rev {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
}

@media (max-width: 1024px) {
  .tables-row-rev {
    grid-template-columns: 1fr;
  }
}
</style>