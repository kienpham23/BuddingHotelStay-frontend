<template>
  <div class="admin-loading-screen" v-if="!stats">
    <div class="spinner"></div>
    <p>{{ $t('admin.loading') }}</p>
  </div>
  <div class="admin-dashboard-layout" v-else>
    <!-- SIDEBAR -->
    <aside class="admin-sidebar">
      <div class="sidebar-logo">
        <RouterLink to="/admin" class="logo" @click="activeTab = 'dashboard'">
          <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
            <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="logo-word building">Building</span>
          <span class="logo-word hotel">Hotel</span>
          <span class="logo-word stay">Stay</span>
        </RouterLink>
        <span class="panel-tag">{{ $t('admin.system_tag') }}</span>
      </div>

      <!-- User profile in sidebar -->
      <div class="sidebar-profile" v-if="authStore.isLoggedIn">
        <div class="profile-avatar">
          {{ authStore.user?.fullName ? authStore.user.fullName.charAt(0).toUpperCase() : 'A' }}
        </div>
        <div class="profile-info">
          <span class="profile-name">{{ authStore.user?.fullName }}</span>
          <span class="profile-role">{{ $t('admin.admin_role') }}</span>
        </div>
      </div>

      <!-- Sidebar Menu Navigation -->
      <nav class="sidebar-menu">
        <button
          class="menu-item"
          :class="{ active: activeTab === 'dashboard' }"
          @click="activeTab = 'dashboard'"
        >
          <LayoutDashboard :size="18" />
          <span>{{ $t('admin.dashboard') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeTab === 'bookings' }"
          @click="activeTab = 'bookings'"
        >
          <FileText :size="18" />
          <span>{{ $t('admin.bookings') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeTab === 'users' }"
          @click="activeTab = 'users'"
        >
          <Users :size="18" />
          <span>{{ $t('admin.users') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeTab === 'rooms' }"
          @click="activeTab = 'rooms'"
        >
          <Hotel :size="18" />
          <span>{{ $t('admin.rooms') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeTab === 'payments' }"
          @click="activeTab = 'payments'"
        >
          <CreditCard :size="18" />
          <span>{{ $t('admin.payments') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeTab === 'reviews' }"
          @click="activeTab = 'reviews'"
        >
          <MessageSquare :size="18" />
          <span>{{ $t('admin.reviews') }}</span>
        </button>
        <button
          class="menu-item"
          :class="{ active: activeTab === 'payouts' }"
          @click="activeTab = 'payouts'"
        >
          <Wallet :size="18" />
          <span>{{ locale === 'vi' ? 'Duyệt rút tiền' : 'Payout Approvals' }}</span>
        </button>

        <hr class="sidebar-divider" />

        <RouterLink to="/admin/revenue" class="menu-item menu-item-link">
          <BarChart3 :size="18" />
          <span>{{ $t('admin.revenue') }}</span>
        </RouterLink>
        <RouterLink to="/admin/promotions" class="menu-item menu-item-link">
          <Tag :size="18" />
          <span>{{ $t('admin.promotions') }}</span>
        </RouterLink>
      </nav>

      <!-- Sidebar Footer -->
      <div class="sidebar-footer">
        <RouterLink to="/admin" class="sidebar-link" @click="activeTab = 'dashboard'">
          <Home :size="16" />
          <span>{{ $t('admin.back_home') }}</span>
        </RouterLink>
        <button class="btn-logout-sidebar" @click="handleLogout">
          <LogOut :size="16" />
          <span>{{ $t('admin.logout') }}</span>
        </button>
      </div>
    </aside>

    <!-- MAIN CONTENT AREA -->
    <div class="admin-main-container">
      <!-- TOP NAV -->
      <header class="admin-top-header">
        <div class="header-title-section">
          <h1 class="page-title">{{ activePageTitle }}</h1>
          <p class="page-subtitle">{{ activePageSubtitle }}</p>
        </div>
        <div class="header-actions">
          <!-- Language Selector -->
          <div class="header-lang-selector-dropdown" style="margin-right: 16px;">
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
      <main class="admin-main-content">
        <!-- 0. DASHBOARD OVERVIEW -->
        <div v-if="activeTab === 'dashboard'" class="fade-in-tab">
          <!-- ANALYTICS CARDS -->
          <div class="analytics-row">
            <div class="analytic-card">
              <div class="icon-wrap"><Users :size="24" /></div>
              <div class="info">
                <h4>{{ $t('admin.total_users') }}</h4>
                <span class="val">{{ stats.totalUsers }} {{ $t('admin.members') }}</span>
              </div>
            </div>
            <div class="analytic-card">
              <div class="icon-wrap color-blue"><Hotel :size="24" /></div>
              <div class="info">
                <h4>{{ $t('admin.total_rooms') }}</h4>
                <span class="val">{{ stats.totalRooms }} {{ $t('admin.rooms_unit') }}</span>
              </div>
            </div>
            <div class="analytic-card">
              <div class="icon-wrap color-green"><FileText :size="24" /></div>
              <div class="info">
                <h4>{{ $t('admin.total_bookings') }}</h4>
                <span class="val">{{ stats.totalBookings }} {{ $t('admin.bookings_unit') }}</span>
              </div>
            </div>
            <div class="analytic-card">
              <div class="icon-wrap color-pink"><DollarSign :size="24" /></div>
              <div class="info">
                <h4>{{ $t('admin.total_revenue') }}</h4>
                <span class="val">{{ formatPrice(stats.totalRevenue) }}</span>
              </div>
            </div>
          </div>
           <!-- Row 1: Hoạt động gần đây | Phòng chờ duyệt -->
          <div class="dashboard-grid-row" style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 24px; margin-top: 24px;">
            <!-- Column 1: Recent Activity -->
            <div class="dashboard-card" style="background: white; border: 1px solid #e2e8f0; border-radius: 18px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.02); display: flex; flex-direction: column;">
              <h3 style="font-size: 1rem; font-weight: 800; color: #0f172a; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                <Clock :size="18" style="color: #1a6cf7;" />
                {{ locale === 'en' ? 'Recent Activities' : 'Hoạt động gần đây' }}
              </h3>
              <div class="activity-list" style="display: flex; flex-direction: column; gap: 14px; overflow-y: auto; max-height: 250px; padding-right: 4px;">
                <div v-for="(act, index) in recentActivities" :key="index" style="display: flex; align-items: flex-start; gap: 12px; border-bottom: 1px dashed #f1f5f9; padding-bottom: 10px;">
                  <span style="font-size: 11px; font-weight: 700; color: #1a6cf7; background: #eff6ff; padding: 2px 6px; border-radius: 4px; min-width: 46px; text-align: center; margin-top: 2px; flex-shrink: 0;">
                    {{ act.timeStr }}
                  </span>
                  <span style="font-size: 13px; font-weight: 500; color: #334155; line-height: 1.4; text-align: left;">
                    {{ act.text }}
                  </span>
                </div>
                <div v-if="recentActivities.length === 0" style="text-align: center; color: #94a3b8; font-size: 13px; padding: 20px 0;">
                  {{ locale === 'en' ? 'No recent activities.' : 'Chưa có hoạt động nào.' }}
                </div>
              </div>
            </div>

            <!-- Column 2: Rooms Pending Approval -->
            <div class="dashboard-card" style="background: white; border: 1px solid #e2e8f0; border-radius: 18px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.02); display: flex; flex-direction: column; justify-content: space-between; min-height: 220px;">
              <div>
                <h3 style="font-size: 1rem; font-weight: 800; color: #0f172a; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                  <Hotel :size="18" style="color: #f59e0b;" />
                  {{ locale === 'en' ? 'Rooms Pending Approval' : 'Phòng chờ duyệt' }}
                </h3>
                <div style="text-align: center; padding: 20px 0 10px 0;">
                  <span style="font-size: 3.2rem; font-weight: 800; color: #f59e0b; display: block; line-height: 1;">
                    {{ pendingRoomsCount }}
                  </span>
                  <span style="font-size: 13px; font-weight: 600; color: #64748b; margin-top: 8px; display: block;">
                    {{ locale === 'en' ? 'rooms waiting for approval' : 'phòng nghỉ đang chờ phê duyệt' }}
                  </span>
                </div>
              </div>
              <button 
                @click="activeTab = 'rooms'"
                style="width: 100%; padding: 11px; border-radius: 10px; font-weight: 700; border: none; background: #f59e0b; color: white; cursor: pointer; transition: background 0.2s; text-align: center; font-size: 13px; display: flex; align-items: center; justify-content: center; gap: 6px; font-family: inherit;"
              >
                {{ locale === 'en' ? 'Go to Approval List' : 'Đi tới duyệt' }} →
              </button>
            </div>
          </div>

          <!-- Row 2: Thao tác nhanh | Hoa hồng mặc định -->
          <div class="dashboard-grid-row" style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 24px; margin-top: 24px;">
            <!-- Column 1: Quick Actions -->
            <div class="dashboard-card" style="background: white; border: 1px solid #e2e8f0; border-radius: 18px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.02);">
              <h3 style="font-size: 1rem; font-weight: 800; color: #0f172a; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                <Sparkles :size="18" style="color: #7c3aed;" />
                {{ locale === 'en' ? 'Quick Actions' : 'Thao tác nhanh' }}
              </h3>
              <div class="quick-actions-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                <RouterLink to="/admin/promotions" class="action-btn-shortcut violet" style="display: flex; align-items: center; gap: 8px; justify-content: center;">
                  <Plus :size="15" />
                  {{ locale === 'en' ? 'Create Promotion' : 'Tạo khuyến mãi' }}
                </RouterLink>
                <button @click="activeTab = 'rooms'" class="action-btn-shortcut" style="display: flex; align-items: center; gap: 8px; justify-content: center; background: #eff6ff; color: #1a6cf7; border-color: #bfdbfe; font-family: inherit; font-size: 0.85rem; font-weight: 700; cursor: pointer; padding: 0.65rem 1.25rem; border-radius: 10px; transition: all 0.2s;">
                  <Hotel :size="15" />
                  {{ locale === 'en' ? 'Approve Rooms' : 'Duyệt phòng' }}
                </button>
                <RouterLink to="/admin/revenue" class="action-btn-shortcut" style="display: flex; align-items: center; gap: 8px; justify-content: center;">
                  <DollarSign :size="15" />
                  {{ locale === 'en' ? 'Commission Settings' : 'Cấu hình hoa hồng' }}
                </RouterLink>
                <RouterLink to="/admin/revenue" class="action-btn-shortcut violet" style="display: flex; align-items: center; gap: 8px; justify-content: center;">
                  <BarChart2 :size="15" />
                  {{ locale === 'en' ? 'View Reports' : 'Xem báo cáo' }}
                </RouterLink>
              </div>
            </div>

            <!-- Column 2: System Default Commission -->
            <div class="dashboard-card" style="background: white; border: 1px solid #e2e8f0; border-radius: 18px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.02); display: flex; flex-direction: column; justify-content: space-between; min-height: 180px;">
              <div>
                <h3 style="font-size: 1rem; font-weight: 800; color: #0f172a; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                  <DollarSign :size="18" style="color: #10b981;" />
                  {{ locale === 'en' ? 'System Commission' : 'Hoa hồng hệ thống' }}
                </h3>
                <div style="text-align: center; padding: 10px 0 5px 0;">
                  <span style="font-size: 3rem; font-weight: 800; color: #10b981; display: block; line-height: 1;">
                    {{ defaultCommissionRate }}%
                  </span>
                  <span style="font-size: 12px; font-weight: 600; color: #64748b; margin-top: 6px; display: block;">
                    {{ locale === 'en' ? 'default commission rate' : 'tỷ lệ hoa hồng mặc định' }}
                  </span>
                </div>
              </div>
              <button 
                @click="openCommissionModal"
                style="width: 100%; padding: 9px; border-radius: 8px; font-weight: 700; border: 1.5px solid #10b981; background: white; color: #10b981; cursor: pointer; transition: all 0.2s; text-align: center; font-size: 12px; display: flex; align-items: center; justify-content: center; gap: 6px; font-family: inherit;"
              >
                <Save :size="14" />
                {{ locale === 'en' ? 'Change Commission' : 'Thay đổi hoa hồng' }}
              </button>
            </div>
          </div>
        </div>
        <!-- TAB 1: ALL BOOKINGS LIST -->
        <div v-if="activeTab === 'bookings'">
          <div class="tab-header" style="margin-bottom: 12px;">
            <h2>{{ $t('admin.bookings_tab_title') }}</h2>
          </div>

          <!-- Transaction Search & Date Filter Bar -->
          <div class="search-bar-row" style="margin-bottom: 20px; display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 250px; max-width: 420px;">
              <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ locale === 'en' ? 'Search Keywords' : 'Từ khóa tìm kiếm' }}</label>
              <input 
                type="text" 
                v-model="bookingSearchQuery" 
                :placeholder="locale === 'en' ? 'Search by ID, guest, room, status...' : 'Tìm kiếm theo Mã đơn, tên khách, tên phòng, trạng thái...'" 
                class="search-input" 
                style="padding: 8px 16px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; width: 100%; font-weight: 500; outline: none; transition: border 0.2s; height: 38px;"
              />
            </div>
            
            <div>
              <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ locale === 'en' ? 'From Booking Date' : 'Từ ngày đặt' }}</label>
              <input 
                type="date" 
                v-model="bookingStartDate" 
                :max="bookingEndDate || undefined"
                class="date-input" 
                style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; width: 150px;"
              />
            </div>
            
            <div>
              <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">{{ locale === 'en' ? 'To Booking Date' : 'Đến ngày đặt' }}</label>
              <input 
                type="date" 
                v-model="bookingEndDate" 
                :min="bookingStartDate || undefined"
                class="date-input" 
                style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; width: 150px;"
              />
            </div>

            <button 
              type="button" 
              class="btn-secondary" 
              style="padding: 8px 16px; border-radius: 8px; font-weight: 600; height: 38px; cursor: pointer; border: 1px solid #cbd5e1; background: white; color: #475569; transition: all 0.2s;"
              @click="resetBookingFilters"
            >
              {{ locale === 'en' ? 'Reset' : 'Đặt lại' }}
            </button>
          </div>

        <div class="table-container" v-if="filteredBookings.length > 0">
          <table class="admin-table">
            <thead>
            <tr>
              <th>{{ $t('admin.col_order_id') }}</th>
              <th>{{ $t('admin.col_room_hotel') }}</th>
              <th>{{ $t('admin.col_guest_info') }}</th>
              <th>{{ $t('admin.col_stay_dates') }}</th>
              <th>{{ $t('admin.col_total_price') }}</th>
              <th>{{ $t('admin.col_status') }}</th>
              <th>{{ $t('admin.col_action') }}</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="bk in paginatedBookings" :key="bk.id" @click="openBookingDetail(bk)" class="clickable-row">
              <td>
                <strong>#{{ bk.id }}</strong>
                <div v-if="bk.createdAt" style="margin-top: 6px; font-size: 11px; color: #64748b; font-weight: 500; line-height: 1.3;">
                  {{ locale === 'vi' ? 'Đặt lúc:' : 'Booked at:' }}
                  <span style="display: block; font-weight: 600; color: #475569; margin-top: 1px;">{{ formatDateTime(bk.createdAt) }}</span>
                </div>
              </td>
              <td>
                <div class="table-room-info">
                  <img :src="bk.roomImage" class="table-room-img" />
                  <div>
                    <p class="name">{{ bk.roomName }}</p>
                    <small class="city">{{ bk.city }}</small>
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
              <td><strong class="color-blue">{{ formatPrice(bk.totalPrice) }}</strong></td>
              <td>
                  <span class="status-badge" :class="bk.status.toLowerCase()">
                    {{ getStatusLabel(bk.status) }}
                  </span>
              </td>
              <td>
                <div class="table-actions">
                  <button
                      class="btn-table-view"
                      @click.stop="openBookingDetail(bk)"
                      :title="locale === 'en' ? 'View Details' : 'Xem chi tiết'"
                  >
                    <Eye :size="14" /> {{ locale === 'en' ? 'Details' : 'Chi tiết' }}
                  </button>
                  <button
                      v-if="bk.status === 'PENDING' || bk.status === 'CONFIRMED'"
                      class="btn-table-delete"
                      @click.stop="cancelBookingStatus(bk.id)"
                      :title="$t('admin.btn_cancel')"
                  >
                    <Trash2 :size="14" /> {{ $t('admin.btn_cancel') }}
                  </button>
                  <span v-else class="color-gray" style="font-size:0.8rem; font-weight:600">{{ $t('admin.status_processed') }}</span>
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <!-- Pagination for Bookings -->
          <div class="pagination-container" v-if="bookingTotalPages > 1" style="margin-top: 20px; display: flex; justify-content: center; align-items: center; gap: 8px;">
            <button 
              class="btn-nav" 
              :disabled="bookingCurrentPage === 1" 
              @click="bookingCurrentPage = 1"
              title="Trang đầu"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="bookingCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &laquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="bookingCurrentPage === 1" 
              @click="bookingCurrentPage--"
              title="Trang trước"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="bookingCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &lsaquo;
            </button>
            
            <template v-for="p in bookingPageNumbers" :key="p">
              <span v-if="p === '...'" style="padding: 6px 12px; color: #94a3b8; font-weight: 500;">…</span>
              <button 
                v-else
                class="btn-page"
                :class="{ active: bookingCurrentPage === p }"
                @click="bookingCurrentPage = p"
                style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 500; min-width: 32px; text-align: center; transition: all 0.2s;"
                :style="bookingCurrentPage === p ? { background: '#3b82f6', borderColor: '#3b82f6', color: 'white' } : { color: '#475569' }"
              >
                {{ p }}
              </button>
            </template>
            
            <button 
              class="btn-nav" 
              :disabled="bookingCurrentPage === bookingTotalPages" 
              @click="bookingCurrentPage++"
              title="Trang sau"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="bookingCurrentPage === bookingTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &rsaquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="bookingCurrentPage === bookingTotalPages" 
              @click="bookingCurrentPage = bookingTotalPages"
              title="Trang cuối"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="bookingCurrentPage === bookingTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &raquo;
            </button>
            <span style="font-size: 13px; font-weight: 600; color: #64748b; margin-left: 8px;">
              Trang {{ bookingCurrentPage }}/{{ bookingTotalPages }}
            </span>
          </div>
        </div>

        <div class="empty-state" v-else>
          <FileText :size="48" class="color-gray" />
          <h3>{{ bookingSearchQuery ? (locale === 'en' ? 'No matching bookings found' : 'Không tìm thấy giao dịch phù hợp') : $t('admin.empty_bookings') }}</h3>
          <p>{{ bookingSearchQuery ? (locale === 'en' ? 'Try adjusting your search query.' : 'Vui lòng thử lại với từ khóa khác.') : $t('admin.empty_bookings_desc') }}</p>
        </div>
      </div>

      <!-- TAB 2: USER MANAGEMENT -->
      <div v-if="activeTab === 'users'">
        <div class="tab-header" style="margin-bottom: 12px;">
          <h2>{{ $t('admin.users_tab_title') }}</h2>
        </div>

        <!-- User Role Filter Tabs -->
        <div class="user-role-filter-row" style="margin-bottom: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
          <!-- ALL -->
          <button 
            type="button" 
            @click="userRoleFilter = 'ALL'"
            :style="{
              padding: '8px 18px',
              borderRadius: '20px',
              border: 'none',
              fontWeight: '600',
              fontSize: '13.5px',
              background: userRoleFilter === 'ALL' ? '#5392f9' : '#f1f5f9',
              color: userRoleFilter === 'ALL' ? 'white' : '#475569',
              cursor: 'pointer',
              transition: 'all 0.2s',
              boxShadow: userRoleFilter === 'ALL' ? '0 4px 10px rgba(83, 146, 249, 0.3)' : 'none'
            }"
          >
            {{ locale === 'en' ? 'All' : 'Tất cả' }} ({{ usersList.length }})
          </button>

          <!-- CUSTOMER -->
          <button 
            type="button" 
            @click="userRoleFilter = 'CUSTOMER'"
            :style="{
              padding: '8px 18px',
              borderRadius: '20px',
              border: 'none',
              fontWeight: '600',
              fontSize: '13.5px',
              background: userRoleFilter === 'CUSTOMER' ? '#10b981' : '#f1f5f9',
              color: userRoleFilter === 'CUSTOMER' ? 'white' : '#475569',
              cursor: 'pointer',
              transition: 'all 0.2s',
              boxShadow: userRoleFilter === 'CUSTOMER' ? '0 4px 10px rgba(16, 185, 129, 0.3)' : 'none'
            }"
          >
            {{ $t('admin.role_customer') }} ({{ countUsersByRole('CUSTOMER') }})
          </button>

          <!-- HOST -->
          <button 
            type="button" 
            @click="userRoleFilter = 'HOST'"
            :style="{
              padding: '8px 18px',
              borderRadius: '20px',
              border: 'none',
              fontWeight: '600',
              fontSize: '13.5px',
              background: userRoleFilter === 'HOST' ? '#f59e0b' : '#f1f5f9',
              color: userRoleFilter === 'HOST' ? 'white' : '#475569',
              cursor: 'pointer',
              transition: 'all 0.2s',
              boxShadow: userRoleFilter === 'HOST' ? '0 4px 10px rgba(245, 158, 11, 0.3)' : 'none'
            }"
          >
            {{ $t('admin.role_host') }} ({{ countUsersByRole('HOST') }})
          </button>

          <!-- ADMIN -->
          <button 
            type="button" 
            @click="userRoleFilter = 'ADMIN'"
            :style="{
              padding: '8px 18px',
              borderRadius: '20px',
              border: 'none',
              fontWeight: '600',
              fontSize: '13.5px',
              background: userRoleFilter === 'ADMIN' ? '#ef4444' : '#f1f5f9',
              color: userRoleFilter === 'ADMIN' ? 'white' : '#475569',
              cursor: 'pointer',
              transition: 'all 0.2s',
              boxShadow: userRoleFilter === 'ADMIN' ? '0 4px 10px rgba(239, 68, 68, 0.3)' : 'none'
            }"
          >
            {{ $t('admin.role_admin') }} ({{ countUsersByRole('ADMIN') }})
          </button>
        </div>

        <div class="table-container" v-if="filteredUsers.length > 0">
          <table class="admin-table">
            <thead>
            <tr>
              <th>ID</th>
              <th>{{ $t('admin.col_fullname') }}</th>
              <th>{{ $t('admin.col_email') }}</th>
              <th>{{ $t('admin.col_role') }}</th>
              <th>{{ $t('admin.col_commission') }}</th>
              <th>{{ $t('admin.col_status') }}</th>
              <th>{{ $t('admin.col_action') }}</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="usr in paginatedUsers" :key="usr.id">
              <td>#{{ usr.id }}</td>
              <td><strong>{{ usr.fullName }}</strong></td>
              <td>{{ usr.email }}</td>
              <td>
                <span class="role-badge" :class="usr.role.toLowerCase()">
                  {{ usr.role === 'CUSTOMER' ? $t('admin.role_customer') : usr.role === 'HOST' ? $t('admin.role_host') : $t('admin.role_admin') }}
                </span>
              </td>
              <td>
                <div v-if="usr.role === 'HOST'" class="commission-cell">
                  <div v-if="editingUserId !== usr.id" class="commission-display" @click="startEditCommission(usr)">
                    <span class="commission-val" :class="{ 'is-default': usr.commissionRate === null }">
                      {{ usr.commissionRate !== null ? `${usr.commissionRate}%` : $t('admin.default_commission') }}
                    </span>
                    <button class="btn-icon-edit" @click.stop="startEditCommission(usr)" :title="$t('admin.edit_commission')">
                      <Edit2 :size="12" />
                    </button>
                    <button v-if="usr.commissionRate !== null" class="btn-text-reset" @click.stop="resetCommission(usr)" :title="$t('admin.reset_default')">
                      {{ $t('admin.reset') }}
                    </button>
                  </div>
                  <div v-else class="commission-edit-form" @click.stop>
                    <input
                      type="number"
                      v-model.number="editingCommissionRate"
                      min="0"
                      max="100"
                      class="commission-inline-input"
                      :placeholder="$t('admin.default_commission')"
                      @keyup.enter="saveCommission(usr)"
                      @keyup.esc="cancelEditCommission"
                    />
                    <span class="pct-sign">%</span>
                    <button class="btn-save-inline" @click="saveCommission(usr)" :title="$t('admin.save')">
                      <Check :size="12" />
                    </button>
                    <button class="btn-cancel-inline" @click="cancelEditCommission" :title="$t('admin.cancel')">
                      <X :size="12" />
                    </button>
                  </div>
                </div>
                <span v-else class="color-gray">-</span>
              </td>
              <td>
                  <span class="status-badge-dot" :class="usr.active ? 'active' : 'inactive'">
                    {{ usr.active ? $t('admin.status_active') : $t('admin.status_locked') }}
                  </span>
              </td>
              <td>
                <div class="action-dropdown-wrap" style="display:flex; align-items:center; gap:0.5rem">
                  <select :value="usr.role" @change="changeUserRole(usr.id, $event.target.value)" class="role-select">
                    <option value="CUSTOMER">CUSTOMER ({{ $t('admin.role_customer') }})</option>
                    <option value="HOST">HOST ({{ $t('admin.role_host') }})</option>
                    <option value="ADMIN">ADMIN ({{ $t('admin.role_admin') }})</option>
                  </select>
                  <button
                      class="btn-table-view"
                      @click="openUserDetail(usr)"
                      :title="locale === 'en' ? 'View Details' : 'Xem chi tiết'"
                  >
                    <Eye :size="14" /> {{ locale === 'en' ? 'Details' : 'Chi tiết' }}
                  </button>
                  <button
                      v-if="usr.active"
                      class="btn-table-lock"
                      @click="toggleUserActive(usr)"
                      :title="$t('admin.lock_acc')"
                  >
                    <Lock :size="14" /> {{ $t('admin.lock') }}
                  </button>
                  <button
                      v-else
                      class="btn-table-unlock"
                      @click="toggleUserActive(usr)"
                      :title="$t('admin.unlock_acc')"
                  >
                    <Unlock :size="14" /> {{ $t('admin.unlock') }}
                  </button>
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <!-- Pagination for Users -->
          <div class="pagination-container" v-if="userTotalPages > 1" style="margin-top: 20px; display: flex; justify-content: center; align-items: center; gap: 8px;">
            <button 
              class="btn-nav" 
              :disabled="userCurrentPage === 1" 
              @click="userCurrentPage = 1"
              title="Trang đầu"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="userCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &laquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="userCurrentPage === 1" 
              @click="userCurrentPage--"
              title="Trang trước"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="userCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &lsaquo;
            </button>
            
            <template v-for="p in userPageNumbers" :key="p">
              <span v-if="p === '...'" style="padding: 6px 12px; color: #94a3b8; font-weight: 500;">…</span>
              <button 
                v-else
                class="btn-page"
                :class="{ active: userCurrentPage === p }"
                @click="userCurrentPage = p"
                style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 500; min-width: 32px; text-align: center; transition: all 0.2s;"
                :style="userCurrentPage === p ? { background: '#3b82f6', borderColor: '#3b82f6', color: 'white' } : { color: '#475569' }"
              >
                {{ p }}
              </button>
            </template>
            
            <button 
              class="btn-nav" 
              :disabled="userCurrentPage === userTotalPages" 
              @click="userCurrentPage++"
              title="Trang sau"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="userCurrentPage === userTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &rsaquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="userCurrentPage === userTotalPages" 
              @click="userCurrentPage = userTotalPages"
              title="Trang cuối"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="userCurrentPage === userTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &raquo;
            </button>
            <span style="font-size: 13px; font-weight: 600; color: #64748b; margin-left: 8px;">
              Trang {{ userCurrentPage }}/{{ userTotalPages }}
            </span>
          </div>
        </div>

        <div class="empty-state" v-else>
          <Users :size="48" class="color-gray" />
          <h3>{{ locale === 'en' ? 'No accounts found' : 'Không tìm thấy tài khoản nào' }}</h3>
          <p>{{ locale === 'en' ? 'There are no accounts matching the selected role.' : 'Không tìm thấy tài khoản nào phù hợp với vai trò đã chọn.' }}</p>
        </div>
      </div>

      <!-- TAB 3: ROOM MANAGEMENT -->
      <div v-if="activeTab === 'rooms'">
        <div class="tab-header">
          <h2>{{ $t('admin.rooms_tab_title') }}</h2>
        </div>

        <!-- Room Search and Filter Bar -->
        <div class="search-bar-row room-filter-bar" style="margin-bottom: 20px; display: flex; gap: 12px; align-items: flex-end; flex-wrap: wrap; background: white; padding: 16px; border-radius: 12px; border: 1px solid #e2e8f0;">
          <div style="flex: 1; min-width: 240px;">
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'Search rooms' : 'Tìm kiếm phòng nghỉ' }}
            </label>
            <input 
              type="text" 
              v-model="roomSearchQuery" 
              :placeholder="locale === 'en' ? 'Search by room name, address or host...' : 'Tìm theo tên phòng, địa chỉ hoặc chủ phòng...'" 
              style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; color: #334155; height: 38px;"
              @keyup.enter="applyRoomFilters"
            />
          </div>
          
          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'City' : 'Thành phố' }}
            </label>
            <select 
              v-model="roomCityFilter" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; min-width: 140px; background: white;"
            >
              <option value="ALL">{{ locale === 'en' ? 'All Cities' : 'Tất cả thành phố' }}</option>
              <option value="Hà Nội">Hà Nội</option>
              <option value="Đà Nẵng">Đà Nẵng</option>
              <option value="Hồ Chí Minh">Hồ Chí Minh</option>
              <option value="Phú Quốc">Phú Quốc</option>
              <option value="Đà Lạt">Đà Lạt</option>
              <option value="Nha Trang">Nha Trang</option>
              <option value="Vũng Tàu">Vũng Tàu</option>
            </select>
          </div>

          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'Room Type' : 'Loại phòng' }}
            </label>
            <select 
              v-model="roomTypeFilter" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; min-width: 140px; background: white;"
            >
              <option value="ALL">{{ locale === 'en' ? 'All Types' : 'Tất cả loại phòng' }}</option>
              <option value="Phòng đơn">{{ locale === 'en' ? 'Single Room' : 'Phòng đơn' }}</option>
              <option value="Deluxe">Deluxe</option>
              <option value="Family Room">Family Room</option>
              <option value="Villa">Villa</option>
              <option value="Standard">Standard</option>
              <option value="Penthouse">Penthouse</option>
              <option value="Nhà nguyên căn">{{ locale === 'en' ? 'Entire House' : 'Nhà nguyên căn' }}</option>
            </select>
          </div>

          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'Status' : 'Trạng thái' }}
            </label>
            <select 
              v-model="roomStatusFilter" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; min-width: 130px; background: white;"
            >
              <option value="ALL">{{ locale === 'en' ? 'All Statuses' : 'Tất cả trạng thái' }}</option>
              <option value="ACTIVE">{{ locale === 'en' ? 'Active' : 'Hoạt động' }}</option>
              <option value="PENDING">{{ locale === 'en' ? 'Pending' : 'Chờ duyệt' }}</option>
              <option value="BLOCKED">{{ locale === 'en' ? 'Locked' : 'Bị khóa' }}</option>
            </select>
          </div>

          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'Sort By' : 'Sắp xếp' }}
            </label>
            <select 
              v-model="roomSortBy" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; min-width: 160px; background: white;"
            >
              <option value="NONE">{{ locale === 'en' ? 'Default' : 'Mặc định' }}</option>
              <option value="PRICE_ASC">{{ locale === 'en' ? 'Price: Low to High' : 'Giá tăng dần' }}</option>
              <option value="PRICE_DESC">{{ locale === 'en' ? 'Price: High to Low' : 'Giá giảm dần' }}</option>
              <option value="NEWEST">{{ locale === 'en' ? 'Newest' : 'Mới đăng' }}</option>
              <option value="MOST_BOOKED">{{ locale === 'en' ? 'Most Booked' : 'Lượt đặt nhiều nhất' }}</option>
              <option value="HIGHEST_RATED">{{ locale === 'en' ? 'Highest Rated' : 'Đánh giá cao nhất' }}</option>
            </select>
          </div>

          <div style="display: flex; gap: 8px;">
            <button 
              type="button" 
              class="btn-primary" 
              style="padding: 8px 16px; border-radius: 8px; font-weight: 600; height: 38px; cursor: pointer; border: none; background: #3b82f6; color: white; transition: all 0.2s;"
              @click="applyRoomFilters"
            >
              {{ locale === 'en' ? 'Search' : 'Tìm kiếm' }}
            </button>
            <button 
              type="button" 
              class="btn-secondary" 
              style="padding: 8px 16px; border-radius: 8px; font-weight: 600; height: 38px; cursor: pointer; border: 1px solid #cbd5e1; background: white; color: #475569; transition: all 0.2s;"
              @click="resetRoomFilters"
            >
              {{ locale === 'en' ? 'Reset' : 'Đặt lại' }}
            </button>
          </div>
        </div>

        <div class="table-container" v-if="filteredRooms.length > 0">
          <table class="admin-table">
            <thead>
            <tr>
              <th>ID</th>
              <th>{{ $t('admin.col_room') }}</th>
              <th>{{ locale === 'en' ? 'Host' : 'Chủ phòng' }}</th>
              <th>{{ $t('admin.col_city') }}</th>
              <th>{{ $t('admin.col_room_type') }}</th>
              <th>{{ $t('admin.col_price') }}</th>
              <th>{{ $t('admin.col_capacity') }}</th>
              <th>{{ $t('admin.col_status') }}</th>
              <th>{{ $t('admin.col_action') }}</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="rm in paginatedRooms" :key="rm.id">
              <td><strong>#{{ rm.id }}</strong></td>
              <td>
                <div class="table-room-info">
                  <img :src="rm.imageUrls[0] || 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=800&auto=format&fit=crop'" class="table-room-img" />
                  <div>
                    <p class="name">{{ rm.name }}</p>
                    <small class="addr">{{ rm.address }}</small>
                  </div>
                </div>
              </td>
              <td>
                <div class="table-host-info" v-if="rm.hostName || rm.host?.fullName">
                  <p class="host-name"><strong>{{ rm.hostName || rm.host?.fullName }}</strong></p>
                  <small class="host-email" style="color: #64748b; display: block; font-size: 11px;">{{ rm.hostEmail || rm.host?.email }}</small>
                </div>
                <span v-else class="color-gray">-</span>
              </td>
              <td>{{ rm.city }}</td>
              <td><span class="room-type-badge">{{ rm.roomTypeName }}</span></td>
              <td><strong class="color-blue">{{ formatPrice(rm.pricePerNight) }}</strong></td>
              <td>{{ rm.maxGuests }} {{ locale === 'en' ? 'guests' : 'khách' }}</td>
              <td>
                  <span class="status-badge" :class="rm.status?.toLowerCase() || 'active'">
                    {{ getRoomStatusLabel(rm.status) }}
                  </span>
              </td>
              <td>
                <div class="table-actions">
                  <button v-if="rm.status === 'PENDING'" class="btn-table-approve" @click="approveRoom(rm.id)" :title="$t('admin.btn_approve')">
                    <Check :size="14" /> {{ $t('admin.btn_approve') }}
                  </button>

                  <button class="btn-table-view" @click="openRoomDetail(rm)" :title="locale === 'en' ? 'View Details' : 'Xem chi tiết'" style="background: #eff6ff; border-color: #bfdbfe; color: #1e40af;">
                    <Eye :size="14" /> {{ locale === 'en' ? 'Details' : 'Chi tiết' }}
                  </button>

                  <button class="btn-table-delete" @click="confirmDeleteRoom(rm)">
                    <Trash2 :size="14" /> {{ $t('admin.btn_delete') }}
                  </button>
                </div>
              </td>
            </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination controls -->
        <div class="pagination-container" v-if="roomTotalPages > 1" style="margin-top: 20px; display: flex; justify-content: center; align-items: center; gap: 8px;">
          <button 
            class="btn-pagination-nav" 
            :disabled="roomCurrentPage === 1" 
            @click="roomCurrentPage = 1"
            title="Trang đầu"
            style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-size: 13.5px; font-weight: 600; color: #475569; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
            :style="roomCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
          >
            &laquo;
          </button>
          <button 
            class="btn-pagination-nav" 
            :disabled="roomCurrentPage === 1" 
            @click="roomCurrentPage--"
            title="Trang trước"
            style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-size: 13.5px; font-weight: 600; color: #475569; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
            :style="roomCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
          >
            &lsaquo;
          </button>
          
          <template v-for="p in roomPageNumbers" :key="p">
            <span v-if="p === '...'" style="padding: 6px 12px; color: #94a3b8; font-weight: 500;">…</span>
            <button 
              v-else
              class="btn-pagination-page" 
              :class="{ active: roomCurrentPage === p }"
              @click="roomCurrentPage = p"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-size: 13.5px; font-weight: 600; transition: all 0.2s;"
              :style="roomCurrentPage === p ? { background: '#3b82f6', borderColor: '#3b82f6', color: 'white' } : { color: '#475569' }"
            >
              {{ p }}
            </button>
          </template>

          <button 
            class="btn-pagination-nav" 
            :disabled="roomCurrentPage === roomTotalPages" 
            @click="roomCurrentPage++"
            title="Trang sau"
            style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-size: 13.5px; font-weight: 600; color: #475569; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
            :style="roomCurrentPage === roomTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
          >
            &rsaquo;
          </button>
          <button 
            class="btn-pagination-nav" 
            :disabled="roomCurrentPage === roomTotalPages" 
            @click="roomCurrentPage = roomTotalPages"
            title="Trang cuối"
            style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-size: 13.5px; font-weight: 600; color: #475569; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
            :style="roomCurrentPage === roomTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
          >
            &raquo;
          </button>
          <span style="font-size: 13.5px; font-weight: 600; color: #64748b; margin-left: 8px;">
            Trang {{ roomCurrentPage }}/{{ roomTotalPages }}
          </span>
        </div>

        <div class="empty-state" v-else-if="roomsList.length > 0">
          <Hotel :size="48" class="color-gray" />
          <h3>{{ locale === 'en' ? 'No matching rooms found' : 'Không tìm thấy phòng nghỉ phù hợp' }}</h3>
          <p>{{ locale === 'en' ? 'Try adjusting your search keywords or filter conditions.' : 'Hãy thử thay đổi điều kiện tìm kiếm hoặc bộ lọc của bạn.' }}</p>
        </div>

        <div class="empty-state" v-else>
          <Hotel :size="48" class="color-gray" />
          <h3>{{ $t('admin.empty_rooms') }}</h3>
          <p>{{ $t('admin.empty_rooms_desc') }}</p>
        </div>
      </div>

      <!-- TAB 4: PAYMENTS HISTORY -->
      <div v-if="activeTab === 'payments'">
        <div class="tab-header">
          <h2>{{ $t('admin.payments_tab_title') }}</h2>
        </div>

        <!-- Filter Bar -->
        <div class="search-bar-row" style="margin-bottom: 20px; display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;" v-if="paymentsList.length > 0">
          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'Payment Status' : 'Trạng thái giao dịch' }}
            </label>
            <select 
              v-model="paymentStatusFilter" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; min-width: 160px; background: white;"
            >
              <option value="ALL">{{ locale === 'en' ? 'All Statuses' : 'Tất cả trạng thái' }}</option>
              <option value="SUCCESS">{{ locale === 'en' ? 'Success' : 'Thành công' }}</option>
              <option value="PENDING">{{ locale === 'en' ? 'Pending' : 'Chờ xử lý' }}</option>
              <option value="FAILED">{{ locale === 'en' ? 'Failed' : 'Thất bại' }}</option>
            </select>
          </div>
          
          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'From Transaction Date' : 'Từ ngày giao dịch' }}
            </label>
            <input 
              type="date" 
              v-model="paymentStartDate" 
              :max="paymentEndDate || undefined"
              class="date-input" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; width: 160px;"
            />
          </div>
          
          <div>
            <label style="display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600; color: #475569;">
              {{ locale === 'en' ? 'To Transaction Date' : 'Đến ngày giao dịch' }}
            </label>
            <input 
              type="date" 
              v-model="paymentEndDate" 
              :min="paymentStartDate || undefined"
              class="date-input" 
              style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; font-weight: 500; height: 38px; outline: none; color: #334155; width: 160px;"
            />
          </div>
          
          <button 
            type="button" 
            class="btn-secondary" 
            style="padding: 8px 16px; border-radius: 8px; font-weight: 600; height: 38px; cursor: pointer; border: 1px solid #cbd5e1; background: white; color: #475569; transition: all 0.2s;"
            @click="resetPaymentFilters"
          >
            {{ locale === 'en' ? 'Reset' : 'Đặt lại' }}
          </button>
        </div>

        <div class="table-container" v-if="filteredPayments.length > 0">
          <table class="admin-table">
            <thead>
            <tr>
              <th>{{ $t('admin.col_txn_id') }}</th>
              <th>{{ $t('admin.col_order_id') }}</th>
              <th>{{ $t('admin.col_customer') }}</th>
              <th>{{ $t('admin.col_amount') }}</th>
              <th>{{ $t('admin.col_method') }}</th>
              <th>{{ $t('admin.col_txn_date') }}</th>
              <th>{{ $t('admin.col_status') }}</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="pm in paginatedPayments" :key="pm.id">
              <td><strong>#{{ pm.id }}</strong></td>
              <td><strong>#{{ pm.bookingId }}</strong></td>
              <td>
                <p class="name">{{ pm.customerName }}</p>
                <small class="contact">{{ pm.roomName }}</small>
              </td>
              <td><strong class="color-green">{{ formatPrice(pm.amount) }}</strong></td>
              <td>{{ pm.method }}</td>
              <td>{{ formatDateTime(pm.createdAt) }}</td>
              <td>
                  <span class="status-badge" :class="pm.status.toLowerCase()">
                    {{ getPaymentStatusLabel(pm.status) }}
                  </span>
              </td>
            </tr>
            </tbody>
          </table>

          <!-- Pagination for Payments -->
          <div class="pagination-container" v-if="paymentTotalPages > 1" style="margin-top: 20px; display: flex; justify-content: center; align-items: center; gap: 8px;">
            <button 
              class="btn-nav" 
              :disabled="paymentCurrentPage === 1" 
              @click="paymentCurrentPage = 1"
              title="Trang đầu"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="paymentCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &laquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="paymentCurrentPage === 1" 
              @click="paymentCurrentPage--"
              title="Trang trước"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="paymentCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &lsaquo;
            </button>
            
            <template v-for="p in paymentPageNumbers" :key="p">
              <span v-if="p === '...'" style="padding: 6px 12px; color: #94a3b8; font-weight: 500;">…</span>
              <button 
                v-else
                class="btn-page"
                :class="{ active: paymentCurrentPage === p }"
                @click="paymentCurrentPage = p"
                style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 500; min-width: 32px; text-align: center; transition: all 0.2s;"
                :style="paymentCurrentPage === p ? { background: '#3b82f6', borderColor: '#3b82f6', color: 'white' } : { color: '#475569' }"
              >
                {{ p }}
              </button>
            </template>
            
            <button 
              class="btn-nav" 
              :disabled="paymentCurrentPage === paymentTotalPages" 
              @click="paymentCurrentPage++"
              title="Trang sau"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="paymentCurrentPage === paymentTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &rsaquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="paymentCurrentPage === paymentTotalPages" 
              @click="paymentCurrentPage = paymentTotalPages"
              title="Trang cuối"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="paymentCurrentPage === paymentTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &raquo;
            </button>
            <span style="font-size: 13px; font-weight: 600; color: #64748b; margin-left: 8px;">
              Trang {{ paymentCurrentPage }}/{{ paymentTotalPages }}
            </span>
          </div>
        </div>

        <div class="empty-state" v-else-if="paymentsList.length > 0">
          <CreditCard :size="48" class="color-gray" />
          <h3>{{ locale === 'en' ? 'No matching transactions found' : 'Không tìm thấy giao dịch phù hợp' }}</h3>
          <p>{{ locale === 'en' ? 'Try adjusting your filters.' : 'Vui lòng thử thay đổi bộ lọc ngày hoặc trạng thái.' }}</p>
        </div>

        <div class="empty-state" v-else>
          <CreditCard :size="48" class="color-gray" />
          <h3>{{ $t('admin.empty_payments') }}</h3>
          <p>{{ $t('admin.empty_payments_desc') }}</p>
        </div>
      </div>

      <!-- TAB 5: REVIEWS MANAGEMENT -->
      <div v-if="activeTab === 'reviews'">
        <div class="tab-header" style="margin-bottom: 12px;">
          <h2>{{ $t('admin.reviews_tab_title') }}</h2>
        </div>

        <!-- Rating Star Filter Tabs -->
        <div class="rating-filter-row" style="margin-bottom: 20px; display: flex; gap: 8px; flex-wrap: wrap;">
          <!-- ALL -->
          <button 
            type="button" 
            @click="starFilter = 'ALL'"
            :style="{
              padding: '6px 14px',
              borderRadius: '20px',
              border: 'none',
              fontWeight: '600',
              fontSize: '13px',
              background: starFilter === 'ALL' ? '#5392f9' : '#f1f5f9',
              color: starFilter === 'ALL' ? 'white' : '#475569',
              cursor: 'pointer',
              transition: 'all 0.2s',
              display: 'inline-flex',
              alignItems: 'center',
              gap: '4px',
              boxShadow: starFilter === 'ALL' ? '0 3px 8px rgba(83, 146, 249, 0.25)' : 'none'
            }"
          >
            {{ locale === 'en' ? 'All' : 'Tất cả' }} ({{ reviewsList.length }})
          </button>
          
          <!-- STAR BUTTONS -->
          <button 
            v-for="star in [5, 4, 3, 2, 1]" 
            :key="star"
            type="button" 
            @click="starFilter = star"
            :style="{
              padding: '6px 14px',
              borderRadius: '20px',
              border: 'none',
              fontWeight: '600',
              fontSize: '13px',
              background: starFilter === star ? '#ffb703' : '#f1f5f9',
              color: starFilter === star ? '#0f172a' : '#475569',
              cursor: 'pointer',
              transition: 'all 0.2s',
              display: 'inline-flex',
              alignItems: 'center',
              gap: '4px',
              boxShadow: starFilter === star ? '0 3px 8px rgba(255, 183, 3, 0.35)' : 'none'
            }"
          >
            {{ star }} <Star :size="13" :fill="starFilter === star ? '#0f172a' : '#64748b'" :color="starFilter === star ? '#0f172a' : '#64748b'" style="margin-bottom: 1px;" /> ({{ countReviewsByStar(star) }})
          </button>
        </div>

        <div class="table-container" v-if="filteredReviews.length > 0">
          <table class="admin-table">
            <thead>
            <tr>
              <th>ID</th>
              <th>{{ $t('admin.col_customer') }}</th>
              <th>{{ $t('admin.col_room_hotel') }}</th>
              <th>{{ $t('admin.col_rating') }}</th>
              <th>{{ $t('admin.col_comment') }}</th>
              <th>{{ $t('admin.col_review_date') }}</th>
              <th>{{ $t('admin.col_action') }}</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="rv in paginatedReviews" :key="rv.id">
              <td><strong>#{{ rv.id }}</strong></td>
              <td><strong>{{ rv.customerName }}</strong></td>
              <td><span class="room-name-cell" style="font-weight:600; color:#334155">{{ rv.roomName }}</span></td>
              <td>
                  <span class="room-rating" style="display:inline-flex; align-items:center; gap:0.2rem; font-weight:700; color:#0f172a">
                    <Star :size="13" fill="#ffb703" color="#ffb703" /> {{ rv.rating }}
                  </span>
              </td>
              <td><p class="review-comment-text" style="max-width:320px; white-space:normal; line-height:1.4; color:#475569">{{ rv.comment }}</p></td>
              <td>{{ formatDate(rv.createdAt) }}</td>
              <td>
                <div style="display: flex; gap: 8px;">
                  <button 
                    class="btn-table-detail" 
                    @click="openRoomDetailFromReview(rv)"
                    style="padding: 6px 12px; border-radius: 6px; border: 1px solid #3b82f6; background: #eff6ff; color: #1d4ed8; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; cursor: pointer; font-size: 13px; transition: all 0.2s;"
                  >
                    <Eye :size="14" /> {{ locale === 'en' ? 'Detail' : 'Chi tiết' }}
                  </button>
                  <button class="btn-table-delete" @click="confirmDeleteReview(rv)">
                    <Trash2 :size="14" /> {{ $t('admin.btn_delete') }}
                  </button>
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <!-- Pagination for Reviews -->
          <div class="pagination-container" v-if="reviewTotalPages > 1" style="margin-top: 20px; display: flex; justify-content: center; align-items: center; gap: 8px;">
            <button 
              class="btn-nav" 
              :disabled="reviewCurrentPage === 1" 
              @click="reviewCurrentPage = 1"
              title="Trang đầu"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="reviewCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &laquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="reviewCurrentPage === 1" 
              @click="reviewCurrentPage--"
              title="Trang trước"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="reviewCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &lsaquo;
            </button>
            
            <template v-for="p in reviewPageNumbers" :key="p">
              <span v-if="p === '...'" style="padding: 6px 12px; color: #94a3b8; font-weight: 500;">…</span>
              <button 
                v-else
                class="btn-page"
                :class="{ active: reviewCurrentPage === p }"
                @click="reviewCurrentPage = p"
                style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 500; min-width: 32px; text-align: center; transition: all 0.2s;"
                :style="reviewCurrentPage === p ? { background: '#3b82f6', borderColor: '#3b82f6', color: 'white' } : { color: '#475569' }"
              >
                {{ p }}
              </button>
            </template>
            
            <button 
              class="btn-nav" 
              :disabled="reviewCurrentPage === reviewTotalPages" 
              @click="reviewCurrentPage++"
              title="Trang sau"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="reviewCurrentPage === reviewTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &rsaquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="reviewCurrentPage === reviewTotalPages" 
              @click="reviewCurrentPage = reviewTotalPages"
              title="Trang cuối"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="reviewCurrentPage === reviewTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &raquo;
            </button>
            <span style="font-size: 13px; font-weight: 600; color: #64748b; margin-left: 8px;">
              Trang {{ reviewCurrentPage }}/{{ reviewTotalPages }}
            </span>
          </div>
        </div>

        <div class="empty-state" v-else>
          <MessageSquare :size="48" class="color-gray" />
          <h3>{{ starFilter !== 'ALL' ? (locale === 'en' ? 'No matching reviews found' : 'Không có đánh giá nào tương ứng') : $t('admin.empty_reviews') }}</h3>
          <p>{{ starFilter !== 'ALL' ? (locale === 'en' ? 'Try selecting another star rating.' : 'Vui lòng chọn mức đánh giá sao khác.') : $t('admin.empty_reviews_desc') }}</p>
        </div>
      </div>

      <!-- TAB 6: PAYOUT APPROVALS -->
      <div v-if="activeTab === 'payouts'">
        <div class="tab-header" style="margin-bottom: 20px;">
          <h2>{{ locale === 'vi' ? 'Duyệt yêu cầu rút tiền của Host' : 'Host Payout Approvals' }}</h2>
        </div>

        <!-- Filter bar for payout status -->
        <div class="payout-filters-row" style="margin-bottom: 20px; display: flex; gap: 8px; flex-wrap: wrap;">
          <button 
            v-for="st in ['ALL', 'PENDING', 'APPROVED', 'REJECTED']"
            :key="st"
            type="button"
            @click="adminPayoutStatusFilter = st"
            style="padding: 6px 14px; border-radius: 20px; border: none; font-weight: 600; font-size: 13px; cursor: pointer; transition: all 0.2s;"
            :style="{
              background: adminPayoutStatusFilter === st ? '#2563eb' : '#f1f5f9',
              color: adminPayoutStatusFilter === st ? 'white' : '#475569',
              boxShadow: adminPayoutStatusFilter === st ? '0 3px 8px rgba(37, 99, 235, 0.25)' : 'none'
            }"
          >
            {{ 
              st === 'ALL' ? (locale === 'en' ? 'All' : 'Tất cả') :
              st === 'PENDING' ? (locale === 'en' ? 'Pending' : 'Chờ duyệt') :
              st === 'APPROVED' ? (locale === 'en' ? 'Approved' : 'Đã duyệt') :
              (locale === 'en' ? 'Rejected' : 'Từ chối')
            }}
          </button>
        </div>

        <!-- Payout Requests Table -->
        <div class="table-container" v-if="filteredPayouts.length > 0">
          <table class="admin-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>{{ locale === 'vi' ? 'Chủ phòng (Host)' : 'Host' }}</th>
                <th>{{ locale === 'vi' ? 'Thông tin ngân hàng' : 'Bank Details' }}</th>
                <th class="text-right">{{ locale === 'vi' ? 'Số tiền rút' : 'Amount' }}</th>
                <th>{{ locale === 'vi' ? 'Ngày gửi yêu cầu' : 'Requested Date' }}</th>
                <th>{{ locale === 'vi' ? 'Trạng thái' : 'Status' }}</th>
                <th>{{ locale === 'vi' ? 'Ghi chú / Lý do từ chối' : 'Notes / Reject Reason' }}</th>
                <th>{{ locale === 'vi' ? 'Thao tác' : 'Actions' }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="p in paginatedPayouts" :key="p.id">
                <td><strong>#PAY-{{ p.id }}</strong></td>
                <td>
                  <div>
                    <p style="font-weight: 700; color: #1e293b; margin: 0;">{{ p.hostName }}</p>
                    <small style="color: #64748b; font-weight: 500;">{{ p.hostEmail }}</small>
                  </div>
                </td>
                <td>
                  <div>
                    <p style="font-weight: 700; color: #334155; margin: 0;">{{ p.bankName }}</p>
                    <small style="color: #64748b; font-weight: 500;">{{ p.accountNumber }} | {{ p.accountHolder }}</small>
                  </div>
                </td>
                <td class="text-right text-bold" style="color: #2563eb;"><strong>{{ formatPrice(p.amount) }}</strong></td>
                <td>{{ formatDate(p.createdAt) }}</td>
                <td>
                  <span class="status-badge-sm" :class="p.status.toLowerCase()" style="font-size: 0.75rem; padding: 3px 8px; border-radius: 6px; font-weight: 700; display: inline-block;">
                    {{ 
                      p.status === 'PENDING' ? (locale === 'en' ? 'Pending' : 'Chờ duyệt') :
                      p.status === 'APPROVED' ? (locale === 'en' ? 'Approved' : 'Đã duyệt') :
                      (locale === 'en' ? 'Rejected' : 'Từ chối')
                    }}
                  </span>
                </td>
                <td style="font-size: 0.85rem; color: #475569; max-width: 220px; word-wrap: break-word;">{{ p.note || '-' }}</td>
                <td>
                  <div style="display: flex; gap: 8px;" v-if="p.status === 'PENDING'">
                    <button 
                      class="btn-table-approve" 
                      @click="handleApprovePayout(p.id)"
                      style="padding: 6px 12px; border-radius: 6px; border: none; background: #d1fae5; color: #065f46; font-weight: 700; cursor: pointer; font-size: 13.5px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px;"
                    >
                      <Check :size="14" /> {{ locale === 'vi' ? 'Duyệt' : 'Duyệt' }}
                    </button>
                    <button 
                      class="btn-table-delete" 
                      @click="openRejectPayoutModal(p)"
                      style="padding: 6px 12px; border-radius: 6px; border: 1px solid #ef4444; background: white; color: #ef4444; font-weight: 700; cursor: pointer; font-size: 13.5px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px;"
                    >
                      <X :size="14" /> {{ locale === 'vi' ? 'Từ chối' : 'Từ chối' }}
                    </button>
                  </div>
                  <span v-else class="processed-text" style="color: #64748b; font-weight: 600; font-size: 0.85rem;">{{ locale === 'vi' ? 'Đã xử lý' : 'Processed' }}</span>
                </td>
              </tr>
            </tbody>
          </table>

          <!-- Pagination for Payouts -->
          <div class="pagination-container" v-if="payoutTotalPages > 1" style="margin-top: 20px; display: flex; justify-content: center; align-items: center; gap: 8px;">
            <button 
              class="btn-nav" 
              :disabled="payoutCurrentPage === 1" 
              @click="payoutCurrentPage = 1"
              title="Trang đầu"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="payoutCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &laquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="payoutCurrentPage === 1" 
              @click="payoutCurrentPage--"
              title="Trang trước"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="payoutCurrentPage === 1 ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &lsaquo;
            </button>
            
            <template v-for="p in payoutPageNumbers" :key="p">
              <span v-if="p === '...'" style="padding: 6px 12px; color: #94a3b8; font-weight: 500;">…</span>
              <button 
                v-else
                class="btn-page"
                :class="{ active: payoutCurrentPage === p }"
                @click="payoutCurrentPage = p"
                style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; font-weight: 500; min-width: 32px; text-align: center; transition: all 0.2s;"
                :style="payoutCurrentPage === p ? { background: '#2563eb', borderColor: '#2563eb', color: 'white' } : { color: '#475569' }"
              >
                {{ p }}
              </button>
            </template>
            
            <button 
              class="btn-nav" 
              :disabled="payoutCurrentPage === payoutTotalPages" 
              @click="payoutCurrentPage++"
              title="Trang sau"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="payoutCurrentPage === payoutTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &rsaquo;
            </button>
            <button 
              class="btn-nav" 
              :disabled="payoutCurrentPage === payoutTotalPages" 
              @click="payoutCurrentPage = payoutTotalPages"
              title="Trang cuối"
              style="padding: 6px 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: white; cursor: pointer; transition: all 0.2s;"
              :style="payoutCurrentPage === payoutTotalPages ? { opacity: 0.5, cursor: 'not-allowed' } : {}"
            >
              &raquo;
            </button>
            <span style="font-size: 13px; font-weight: 600; color: #64748b; margin-left: 8px;">
              Trang {{ payoutCurrentPage }}/{{ payoutTotalPages }}
            </span>
          </div>
        </div>

        <div class="empty-state" v-else>
          <Wallet :size="48" class="color-gray" />
          <h3>{{ locale === 'vi' ? 'Không có yêu cầu rút tiền nào' : 'No payout requests found' }}</h3>
          <p>{{ locale === 'vi' ? 'Thử chuyển bộ lọc trạng thái khác để kiểm tra.' : 'Try changing the status filter selection.' }}</p>
        </div>
      </div>
    </main>
  </div>

    <!-- ADMIN REJECT PAYOUT MODAL -->
    <div class="modal-backdrop" v-if="showRejectPayoutModal">
      <div class="confirm-modal" style="max-width: 450px; width: 90%; background: white; border-radius: 16px; padding: 24px; box-shadow: 0 10px 25px rgba(0,0,0,0.15); display: flex; flex-direction: column; gap: 14px;">
        <h3 style="font-size: 1.15rem; font-weight: 800; color: #0f172a;">{{ locale === 'vi' ? 'Từ chối yêu cầu rút tiền' : 'Reject Payout Request' }}</h3>
        <p style="font-size: 0.88rem; color: #475569;">
          {{ locale === 'vi' ? 'Vui lòng nhập lý do từ chối yêu cầu rút tiền này. Lý do sẽ được hiển thị cho Host.' : 'Please enter the reason for rejecting this payout. This reason will be visible to the Host.' }}
        </p>
        <div class="form-group" style="display: flex; flex-direction: column; gap: 6px;">
          <textarea 
            v-model="rejectPayoutReason" 
            placeholder="Ví dụ: Thông tin tài khoản ngân hàng không chính xác..." 
            rows="3" 
            style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; font-family: inherit; font-size: 14px;"
          ></textarea>
        </div>
        <div class="modal-actions" style="display: flex; gap: 8px; margin-top: 8px;">
          <button class="btn-cancel" @click="showRejectPayoutModal = false" style="flex: 1; padding: 10px; border-radius: 8px; border: 1px solid #cbd5e1; background: white; font-weight: 700; cursor: pointer; color: #475569;">{{ locale === 'vi' ? 'Hủy bỏ' : 'Cancel' }}</button>
          <button 
            class="btn-confirm-delete" 
            @click="handleRejectPayout" 
            style="flex: 1; padding: 10px; border-radius: 8px; border: none; background: #ef4444; color: white; font-weight: 700; cursor: pointer;"
          >
            {{ locale === 'vi' ? 'Xác nhận từ chối' : 'Reject Request' }}
          </button>
        </div>
      </div>
    </div>

    <!-- ADD/EDIT ROOM MODAL -->
    <div class="modal-backdrop" v-if="showFormModal">
      <div class="room-modal">
        <div class="modal-header">
          <h2>{{ isEditMode ? 'Cập nhật phòng nghỉ' : 'Thêm phòng nghỉ mới' }}</h2>
          <button class="btn-close" @click="showFormModal = false">×</button>
        </div>
        <form @submit.prevent="saveRoom" class="modal-form">
          <div class="form-group">
            <label>Tên phòng nghỉ/khách sạn</label>
            <input v-model="roomForm.name" type="text" placeholder="Ví dụ: Phòng Suite Luxury View Biển - Vinpearl" required />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Hạng phòng</label>
              <input v-model="roomForm.roomTypeName" type="text" placeholder="Ví dụ: Deluxe Suite, Penthouse..." required />
            </div>
            <div class="form-group">
              <label>Sức chứa tối đa (Khách)</label>
              <input v-model.number="roomForm.maxGuests" type="number" min="1" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Thành phố</label>
              <input 
                v-model="roomForm.city" 
                type="text" 
                list="admin-city-list" 
                placeholder="Nhập hoặc chọn thành phố" 
                autocomplete="off"
                required 
              />
              <datalist id="admin-city-list">
                <option value="Hà Nội">Hà Nội</option>
                <option value="Đà Nẵng">Đà Nẵng</option>
                <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                <option value="Phú Quốc">Phú Quốc</option>
                <option value="Đà Lạt">Đà Lạt</option>
                <option value="Nha Trang">Nha Trang</option>
              </datalist>
            </div>
            <div class="form-group">
              <label>Giá một đêm (VND)</label>
              <input v-model.number="roomForm.pricePerNight" type="number" min="10000" required />
            </div>
          </div>

          <div class="form-group">
            <label>Địa chỉ chi tiết</label>
            <input v-model="roomForm.address" type="text" placeholder="Số đường, Phường, Quận..." required />
          </div>

          <div class="form-group image-upload-section">
            <label>Hình ảnh phòng nghỉ (Được tải lên trực tiếp)</label>

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
                <p class="main-text">Kéo thả hoặc click để tải ảnh lên</p>
                <p class="sub-text">Hỗ trợ JPG, JPEG, PNG (tối đa 10MB/ảnh)</p>
              </div>
            </div>

            <!-- Uploading files list -->
            <div v-if="selectedNewFiles.length > 0" class="new-files-preview-list">
              <span class="preview-title">Ảnh mới chuẩn bị upload ({{ selectedNewFiles.length }}):</span>
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
                      <Star :size="10" fill="currentColor" /> Ảnh đại diện mới
                    </span>
                  </div>
                  <div class="preview-actions-overlay">
                    <button
                        type="button"
                        class="action-btn delete-btn"
                        @click.stop="removeNewFile(idx)"
                        title="Xóa ảnh"
                    >
                      <Trash2 :size="14" />
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Existing room images -->
            <div v-if="roomImages.length > 0" class="existing-files-preview-list">
              <span class="preview-title">Ảnh hiện có của phòng ({{ roomImages.length }}):</span>
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
                      <Star :size="10" fill="currentColor" /> Ảnh đại diện
                    </span>
                  </div>
                  <div class="preview-actions-overlay">
                    <button
                        v-if="!img.isPrimary"
                        type="button"
                        class="action-btn set-primary-btn"
                        @click.stop="setPrimaryImageAction(img, idx)"
                        title="Đặt làm ảnh đại diện"
                    >
                      <Star :size="14" />
                    </button>
                    <button
                        type="button"
                        class="action-btn delete-btn"
                        @click.stop="deleteImageAction(img, idx)"
                        title="Xóa ảnh"
                    >
                      <Trash2 :size="14" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label>Mô tả chi tiết phòng nghỉ</label>
            <textarea v-model="roomForm.description" placeholder="Mô tả về đặc điểm, hướng phòng, chính sách..." rows="4"></textarea>
          </div>

          <div class="modal-actions">
            <button type="button" class="btn-cancel" @click="showFormModal = false">Hủy</button>
            <button type="submit" class="btn-submit" :disabled="formLoading">
              <span v-if="!formLoading">Lưu thông tin</span>
              <span v-else class="spinner-small"></span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- DELETE CONFIRMATION MODAL -->
    <div class="modal-backdrop" v-if="showDeleteModal">
      <div class="confirm-modal">
        <h3>{{ $t('admin.confirm_delete_room_title') }}</h3>
        <p>
          {{ locale === 'en' ? 'Are you sure you want to delete room ' : 'Bạn có chắc chắn muốn xóa phòng nghỉ ' }}
          <strong>{{ selectedRoom?.name }}</strong>
          {{ locale === 'en' ? '? Room data will be permanently deleted.' : ' không? Dữ liệu phòng nghỉ sẽ bị xóa vĩnh viễn.' }}
        </p>
        <div class="modal-actions">
          <button class="btn-cancel" @click="showDeleteModal = false">{{ $t('admin.btn_cancel') }}</button>
          <button class="btn-confirm-delete" @click="executeDeleteRoom" :disabled="deleteLoading">
            <span v-if="!deleteLoading">{{ $t('admin.btn_confirm_delete') }}</span>
            <span v-else class="spinner-small"></span>
          </button>
        </div>
      </div>
    </div>

    <!-- DELETE REVIEW CONFIRMATION MODAL -->
    <div class="modal-backdrop" v-if="showReviewDeleteModal">
      <div class="confirm-modal">
        <h3>{{ $t('admin.confirm_delete_review_title') }}</h3>
        <p>
          {{ locale === 'en' ? 'Are you sure you want to delete the review of guest ' : 'Bạn có chắc chắn muốn xóa đánh giá của khách hàng ' }}
          <strong>{{ selectedReview?.customerName }}</strong>
          {{ locale === 'en' ? ' for room ' : ' cho phòng ' }}
          <strong>{{ selectedReview?.roomName }}</strong>
          {{ locale === 'en' ? '? This action cannot be undone.' : ' không? Hành động này không thể hoàn tác.' }}
        </p>
        <div class="modal-actions">
          <button class="btn-cancel" @click="showReviewDeleteModal = false">{{ $t('admin.btn_cancel') }}</button>
          <button class="btn-confirm-delete" @click="executeDeleteReview" :disabled="reviewDeleteLoading">
            <span v-if="!reviewDeleteLoading">{{ $t('admin.btn_confirm_delete') }}</span>
            <span v-else class="spinner-small"></span>
          </button>
        </div>
      </div>
    </div>

    <!-- BOOKING DETAIL MODAL -->
    <div class="modal-backdrop" v-if="showBookingDetailModal" @click.self="showBookingDetailModal = false">
      <div class="room-modal booking-detail-modal">
        <div class="modal-header">
          <h2>{{ locale === 'en' ? 'Booking Details' : 'Chi tiết giao dịch đặt phòng' }} #{{ selectedBooking?.id }}</h2>
          <button class="btn-close" @click="showBookingDetailModal = false">×</button>
        </div>
        <div class="modal-form booking-detail-body">
          <div class="detail-section">
            <h3 class="section-title">{{ locale === 'en' ? 'General Information' : 'Thông tin chung' }}</h3>
            <div class="detail-grid">
              <div class="detail-item">
                <span class="label">{{ locale === 'en' ? 'Status' : 'Trạng thái đơn' }}</span>
                <span class="value">
                  <span class="status-badge" :class="selectedBooking?.status.toLowerCase()">
                    {{ getStatusLabel(selectedBooking?.status) }}
                  </span>
                </span>
              </div>
              <div class="detail-item">
                <span class="label">{{ locale === 'en' ? 'Payment Status' : 'Thanh toán' }}</span>
                <span class="value">
                  <span class="status-badge" :class="selectedBooking?.paymentStatus?.toLowerCase() || 'pending'">
                    {{ getPaymentStatusLabel(selectedBooking?.paymentStatus) }}
                  </span>
                </span>
              </div>
              <div class="detail-item">
                <span class="label">{{ locale === 'en' ? 'Payment Method' : 'Phương thức' }}</span>
                <span class="value">{{ selectedBooking?.paymentMethod || 'N/A' }}</span>
              </div>
            </div>
          </div>

          <div class="detail-divider"></div>

          <div class="detail-section">
            <h3 class="section-title">{{ locale === 'en' ? 'Room & Owner Information' : 'Thông tin phòng & Chủ khách sạn' }}</h3>
            <div class="room-host-card">
              <div class="room-brief">
                <img :src="selectedBooking?.roomImage" class="detail-room-img" v-if="selectedBooking?.roomImage" />
                <div class="room-desc">
                  <h4 class="room-name">{{ selectedBooking?.roomName }}</h4>
                  <p class="room-addr"><MapPin :size="12" /> {{ selectedBooking?.address }}, {{ selectedBooking?.city }}</p>
                </div>
              </div>
              <div class="host-info-box">
                <span class="host-tag">{{ locale === 'en' ? 'Hotel Owner' : 'Chủ khách sạn (Host)' }}</span>
                <p class="host-name"><strong>{{ selectedBooking?.hostName || 'N/A' }}</strong></p>
                <p class="host-contact">{{ selectedBooking?.hostEmail || 'N/A' }} <span v-if="selectedBooking?.hostPhone">| {{ selectedBooking?.hostPhone }}</span></p>
              </div>
            </div>
          </div>

          <div class="detail-divider"></div>

          <div class="detail-section">
            <h3 class="section-title">{{ locale === 'en' ? 'Customer & Stay Details' : 'Thông tin khách hàng & Thời gian lưu trú' }}</h3>
            <div class="detail-grid cols-2">
              <div class="info-group-box">
                <h5>{{ locale === 'en' ? 'Customer Contact' : 'Thông tin khách liên hệ' }}</h5>
                <p><strong>{{ selectedBooking?.guestName }}</strong></p>
                <p class="contact-sub">{{ selectedBooking?.guestEmail }}</p>
                <p class="contact-sub">{{ selectedBooking?.guestPhone }}</p>
              </div>
              <div class="info-group-box">
                <h5>{{ locale === 'en' ? 'Stay Period' : 'Thời gian lưu trú' }}</h5>
                <p><strong>{{ formatDate(selectedBooking?.checkIn) }} - {{ formatDate(selectedBooking?.checkOut) }}</strong></p>
                <p class="contact-sub">{{ calculateDuration(selectedBooking?.checkIn, selectedBooking?.checkOut) }} {{ locale === 'en' ? 'nights' : 'đêm' }} | {{ selectedBooking?.numGuests }} {{ locale === 'en' ? 'guests' : 'khách' }}</p>
              </div>
            </div>
          </div>

          <div class="detail-divider"></div>

          <div class="detail-section" v-if="selectedBooking?.totalPrice">
            <h3 class="section-title">{{ locale === 'en' ? 'Price Breakdown' : 'Chi tiết giá tiền' }}</h3>
            <div class="price-breakdown">
              <div class="price-row" v-if="selectedBooking?.discountAmount && selectedBooking.discountAmount > 0">
                <span>{{ locale === 'en' ? 'Original Price' : 'Giá gốc' }}</span>
                <span>{{ formatPrice(selectedBooking?.originalPrice) }}</span>
              </div>
              <div class="price-row promo" v-if="selectedBooking?.promoCode">
                <span>{{ locale === 'en' ? 'Promo Code' : 'Mã giảm giá' }} ({{ selectedBooking.promoCode }})</span>
                <span class="color-red">-{{ formatPrice(selectedBooking?.discountAmount) }}</span>
              </div>
              <div class="price-row total">
                <span>{{ locale === 'en' ? 'Total Amount' : 'Tổng tiền thanh toán' }}</span>
                <span class="final-price">{{ formatPrice(selectedBooking?.totalPrice) }}</span>
              </div>
            </div>
          </div>

          <div class="detail-section" v-if="selectedBooking?.note">
            <h3 class="section-title">{{ locale === 'en' ? 'Customer Note' : 'Ghi chú của khách' }}</h3>
            <p class="booking-note-text">"{{ selectedBooking.note }}"</p>
          </div>
        </div>
        <div class="modal-footer booking-detail-footer">
          <button class="btn-cancel" @click="showBookingDetailModal = false">{{ locale === 'en' ? 'Close' : 'Đóng' }}</button>
        </div>
      </div>
    </div>

    <!-- USER DETAIL MODAL -->
    <div class="modal-backdrop" v-if="showUserDetailModal" @click.self="showUserDetailModal = false">
      <div class="room-modal user-detail-modal" style="max-width: 480px;">
        <div class="modal-header">
          <h2>{{ locale === 'en' ? 'User Account Details' : 'Chi tiết tài khoản người dùng' }} #{{ selectedUserDetail?.id }}</h2>
          <button class="btn-close" @click="showUserDetailModal = false">×</button>
        </div>
        <div class="modal-form user-detail-body" style="padding: 20px;">
          <div class="detail-section">
            <div class="detail-grid" style="display: flex; flex-direction: column; gap: 14px;">
              <div class="detail-item" style="display: flex; justify-content: space-between; border-bottom: 1px dashed #e2e8f0; padding-bottom: 8px;">
                <span class="label" style="font-weight: 600; color: #64748b;">{{ locale === 'en' ? 'Full Name' : 'Họ và tên' }}</span>
                <span class="value" style="font-weight: 700; color: #1e293b;">{{ selectedUserDetail?.fullName }}</span>
              </div>
              <div class="detail-item" style="display: flex; justify-content: space-between; border-bottom: 1px dashed #e2e8f0; padding-bottom: 8px;">
                <span class="label" style="font-weight: 600; color: #64748b;">{{ locale === 'en' ? 'Email Address' : 'Email tài khoản' }}</span>
                <span class="value" style="font-weight: 600; color: #3b82f6;">{{ selectedUserDetail?.email }}</span>
              </div>
              <div class="detail-item" style="display: flex; justify-content: space-between; border-bottom: 1px dashed #e2e8f0; padding-bottom: 8px;">
                <span class="label" style="font-weight: 600; color: #64748b;">{{ locale === 'en' ? 'Phone Number' : 'Số điện thoại' }}</span>
                <span class="value" style="font-weight: 700; color: #1e293b;">{{ selectedUserDetail?.phone || (locale === 'en' ? 'Not updated' : 'Chưa cập nhật') }}</span>
              </div>
              <div class="detail-item" style="display: flex; justify-content: space-between; border-bottom: 1px dashed #e2e8f0; padding-bottom: 8px;">
                <span class="label" style="font-weight: 600; color: #64748b;">{{ locale === 'en' ? 'Role' : 'Vai trò (Quyền)' }}</span>
                <span class="value">
                  <span class="role-badge" :class="selectedUserDetail?.role.toLowerCase()">
                    {{ selectedUserDetail?.role }}
                  </span>
                </span>
              </div>
              <div class="detail-item" style="display: flex; justify-content: space-between; padding-bottom: 8px;">
                <span class="label" style="font-weight: 600; color: #64748b;">{{ locale === 'en' ? 'Account Status' : 'Trạng thái hoạt động' }}</span>
                <span class="value">
                  <span class="status-badge-dot" :class="selectedUserDetail?.active ? 'active' : 'inactive'">
                    {{ selectedUserDetail?.active ? $t('admin.status_active') : $t('admin.status_locked') }}
                  </span>
                </span>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="padding: 12px 20px; display: flex; justify-content: flex-end; border-top: 1px solid #e2e8f0;">
          <button class="btn-cancel" @click="showUserDetailModal = false">{{ locale === 'en' ? 'Close' : 'Đóng' }}</button>
        </div>
      </div>
    </div>

    <!-- SYSTEM COMMISSION MODAL -->
    <div class="modal-backdrop" v-if="showCommissionModal" @click.self="showCommissionModal = false">
      <div class="room-modal" style="max-width: 400px; border-radius: 18px; overflow: hidden; background: white; box-shadow: 0 20px 50px rgba(0,0,0,0.15);">
        <div class="modal-header" style="padding: 16px 20px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center;">
          <h2 style="font-size: 1.1rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 8px; margin: 0;">
            <DollarSign :size="18" style="color: #10b981;" />
            {{ locale === 'en' ? 'Default Commission' : 'Cấu hình hoa hồng' }}
          </h2>
          <button class="btn-close" @click="showCommissionModal = false" style="background: none; border: none; font-size: 20px; cursor: pointer; color: #94a3b8;">×</button>
        </div>
        <div class="modal-form" style="padding: 20px; display: flex; flex-direction: column; gap: 16px;">
          <div class="form-group" style="display: flex; flex-direction: column; gap: 6px;">
            <label style="font-size: 12px; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.05em;">
              {{ locale === 'en' ? 'Commission Rate (%)' : 'Tỷ lệ hoa hồng (%)' }}
            </label>
            <div style="position: relative; display: flex; align-items: center;">
              <input 
                v-model.number="newSystemCommission"
                type="number"
                min="0"
                max="100"
                style="padding: 10px 14px; border: 1.5px solid #dde1e9; border-radius: 10px; font-size: 15px; font-weight: 700; color: #1e293b; outline: none; width: 100%; padding-right: 36px;"
              />
              <span style="position: absolute; right: 14px; font-size: 15px; font-weight: 800; color: #64748b;">%</span>
            </div>
            <span v-if="commissionModalError" style="font-size: 12px; color: #ef4444; font-weight: 600;">
              {{ commissionModalError }}
            </span>
          </div>
        </div>
        <div class="modal-footer" style="padding: 12px 20px; display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid #e2e8f0; background: #f8fafc;">
          <button 
            class="btn-cancel" 
            @click="showCommissionModal = false"
            style="padding: 8px 16px; border-radius: 8px; border: 1px solid #cbd5e1; background: white; color: #475569; font-weight: 600; cursor: pointer; font-size: 13px;"
          >
            {{ locale === 'en' ? 'Cancel' : 'Hủy' }}
          </button>
          <button 
            class="btn-submit" 
            @click="saveSystemCommission" 
            :disabled="commissionModalLoading"
            style="padding: 8px 18px; border-radius: 8px; border: none; background: #10b981; color: white; font-weight: 700; cursor: pointer; font-size: 13px; display: flex; align-items: center; gap: 6px; box-shadow: 0 4px 10px rgba(16, 185, 129, 0.25);"
          >
            <span v-if="!commissionModalLoading">
              <Save :size="14" />
              {{ locale === 'en' ? 'Save' : 'Lưu lại' }}
            </span>
            <span v-else class="spinner-small" style="width: 14px; height: 14px;"></span>
          </button>
        </div>
      </div>
    </div>

    <!-- ROOM DETAIL DRAWER -->
    <Transition name="drawer-slide">
      <div class="drawer-backdrop" v-if="showRoomDetailDrawer" @click="showRoomDetailDrawer = false">
        <div class="room-drawer" @click.stop>
          <div class="drawer-header">
            <h2>Chi tiết phòng nghỉ #{{ selectedRoomDetail?.id }}</h2>
            <button class="btn-close-drawer" @click="showRoomDetailDrawer = false">×</button>
          </div>
          
          <div class="drawer-body" v-if="selectedRoomDetail">
            <!-- 1. HÌNH ẢNH GALLERY -->
            <div class="drawer-section">
              <h3 class="section-title">Hình ảnh phòng</h3>
              <div class="drawer-image-gallery" v-if="selectedRoomDetail.imageUrls && selectedRoomDetail.imageUrls.length > 0">
                <img 
                  v-for="(url, idx) in selectedRoomDetail.imageUrls" 
                  :key="idx" 
                  :src="url" 
                  class="drawer-gallery-img" 
                  alt="Room photo" 
                />
              </div>
              <div class="drawer-image-gallery" v-else-if="selectedRoomDetail.images && selectedRoomDetail.images.length > 0">
                <img 
                  v-for="(img, idx) in selectedRoomDetail.images" 
                  :key="idx" 
                  :src="img.url || img.imageUrl" 
                  class="drawer-gallery-img" 
                  alt="Room photo" 
                />
              </div>
              <p v-else class="color-gray text-center py-4">Chưa có hình ảnh nào cho phòng này.</p>
            </div>

            <!-- 2. THÔNG TIN CƠ BẢN & MÔ TẢ -->
            <div class="drawer-section">
              <h3 class="section-title">Thông tin phòng nghỉ</h3>
              <div class="info-grid">
                <div class="info-item">
                  <span class="label">Tên phòng:</span>
                  <span class="value"><strong>{{ selectedRoomDetail.name }}</strong></span>
                </div>
                <div class="info-item">
                  <span class="label">Địa chỉ:</span>
                  <span class="value">{{ selectedRoomDetail.address }}, {{ selectedRoomDetail.city }}</span>
                </div>
                <div class="info-item">
                  <span class="label">Hạng phòng:</span>
                  <span class="value"><span class="room-type-badge">{{ selectedRoomDetail.roomTypeName }}</span></span>
                </div>
                <div class="info-item">
                  <span class="label">Giá / Đêm:</span>
                  <span class="value"><strong class="color-blue">{{ formatPrice(selectedRoomDetail.pricePerNight) }}</strong></span>
                </div>
                <div class="info-item">
                  <span class="label">Sức chứa tối đa:</span>
                  <span class="value">{{ selectedRoomDetail.maxGuests }} khách</span>
                </div>
                <div class="info-item">
                  <span class="label">Trạng thái:</span>
                  <span class="value">
                    <span class="status-badge" :class="selectedRoomDetail.status?.toLowerCase() || 'active'">
                      {{ getRoomStatusLabel(selectedRoomDetail.status) }}
                    </span>
                  </span>
                </div>
              </div>
              
              <div class="desc-box" style="margin-top: 12px;">
                <h4 style="font-size: 13px; font-weight: 700; color: #475569; margin-bottom: 6px;">Mô tả chi tiết:</h4>
                <p class="desc-text">{{ selectedRoomDetail.description || 'Không có mô tả chi tiết.' }}</p>
              </div>
            </div>

            <!-- 3. TIỆN ÍCH (Amenities) -->
            <div class="drawer-section">
              <h3 class="section-title">Tiện ích sẵn có</h3>
              <div class="amenities-container" v-if="parsedAmenities.length > 0">
                <span v-for="(am, idx) in parsedAmenities" :key="idx" class="amenity-pill">
                  {{ am }}
                </span>
              </div>
              <p v-else class="color-gray">Không có thông tin tiện ích.</p>
            </div>

            <!-- 4. THÔNG TIN HOST (Chủ phòng) -->
            <div class="drawer-section">
              <h3 class="section-title">Thông tin chủ phòng (Host)</h3>
              <div class="host-info-card" v-if="selectedRoomDetail.hostName || selectedRoomDetail.host">
                <div class="host-avatar-placeholder">
                  {{ (selectedRoomDetail.hostName || selectedRoomDetail.host?.fullName || 'H').charAt(0).toUpperCase() }}
                </div>
                <div class="host-details">
                  <h4 class="host-name">{{ selectedRoomDetail.hostName || selectedRoomDetail.host?.fullName || 'Chủ phòng #' + selectedRoomDetail.hostId }}</h4>
                  <p class="host-contact">Email: {{ selectedRoomDetail.hostEmail || selectedRoomDetail.host?.email || 'N/A' }}</p>
                  <p class="host-contact">SĐT: {{ selectedRoomDetail.hostPhone || selectedRoomDetail.host?.phone || 'N/A' }}</p>
                </div>
              </div>
              <p v-else class="color-gray">Không có thông tin chủ phòng.</p>
            </div>

            <!-- 5. THỐNG KÊ LƯỢT ĐẶT & DOANH THU -->
            <div class="drawer-section">
              <h3 class="section-title">Thống kê hiệu quả</h3>
              <div class="stats-mini-grid">
                <div class="stat-mini-card">
                  <span class="stat-label">Tổng lượt đặt phòng</span>
                  <span class="stat-val color-blue">{{ roomBookings.length }} lượt</span>
                </div>
                <div class="stat-mini-card">
                  <span class="stat-label">Tổng doanh thu mang lại</span>
                  <span class="stat-val color-green">{{ formatPrice(roomRevenue) }}</span>
                </div>
              </div>
            </div>

            <!-- 6. LỊCH SỬ ĐẶT PHÒNG -->
            <div class="drawer-section">
              <h3 class="section-title">Lịch sử đặt phòng ({{ roomBookings.length }})</h3>
              <div class="mini-table-wrap" v-if="roomBookings.length > 0">
                <table class="mini-table">
                  <thead>
                    <tr>
                      <th>Khách hàng</th>
                      <th>Thời gian</th>
                      <th>Doanh thu</th>
                      <th>Trạng thái</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="bk in roomBookings" :key="bk.id">
                      <td>
                        <div class="customer-cell">
                          <span class="cust-name"><strong>{{ bk.guestName }}</strong></span>
                          <span class="cust-email">{{ bk.guestEmail }}</span>
                        </div>
                      </td>
                      <td>
                        <div class="date-cell">
                          <span>{{ formatDate(bk.checkIn) }}</span>
                          <span class="arrow-down">↓</span>
                          <span>{{ formatDate(bk.checkOut) }}</span>
                        </div>
                      </td>
                      <td><strong class="color-green">{{ formatPrice(bk.totalPrice) }}</strong></td>
                      <td>
                        <span class="status-badge-sm" :class="bk.status?.toLowerCase()">
                          {{ getStatusLabel(bk.status) }}
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <p v-else class="color-gray">Chưa có lượt đặt phòng nào được ghi nhận.</p>
            </div>

            <!-- 7. ĐÁNH GIÁ (Reviews) -->
            <div class="drawer-section">
              <h3 class="section-title">Đánh giá từ khách hàng ({{ roomReviews.length }})</h3>
              <div class="drawer-reviews-list" v-if="roomReviews.length > 0">
                <div v-for="rv in roomReviews" :key="rv.id" class="drawer-review-card">
                  <div class="review-header">
                    <span class="reviewer-name"><strong>{{ rv.customerName }}</strong></span>
                    <span class="reviewer-stars">
                      <Star v-for="s in 5" :key="s" :size="10" :fill="s <= rv.rating ? '#ffb703' : 'transparent'" :color="s <= rv.rating ? '#ffb703' : '#cbd5e1'" />
                    </span>
                  </div>
                  <p class="review-comment">{{ rv.comment }}</p>
                  <span class="review-date">{{ formatDate(rv.createdAt) }}</span>
                </div>
              </div>
              <p v-else class="color-gray">Chưa có đánh giá nào cho phòng này.</p>
            </div>
            
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

    <!-- GENERAL CUSTOM CONFIRM MODAL -->
    <div class="modal-backdrop" v-if="showConfirmModal" style="z-index: 2200;">
      <div class="confirm-modal" style="animation: pop 0.25s ease-out;">
        <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin-bottom: 0.75rem;">
          {{ locale === 'vi' ? 'Xác nhận yêu cầu' : 'Confirm Action' }}
        </h3>
        <p style="font-size: 0.92rem; color: #475569; line-height: 1.5; margin-bottom: 1.5rem;">
          {{ confirmMessage }}
        </p>
        <div class="modal-actions" style="margin-top: 20px; display: flex; justify-content: flex-end; gap: 8px;">
          <button class="btn-cancel" @click="confirmCallback(false)">
            {{ locale === 'vi' ? 'Hủy' : 'Cancel' }}
          </button>
          <button class="btn-submit" @click="confirmCallback(true)" style="background: #1a6cf7; color: white;">
            {{ locale === 'vi' ? 'Xác nhận' : 'Confirm' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import axios from '../../api/axios'
import { useI18n } from 'vue-i18n'
import {
  Users, Hotel, FileText, DollarSign, Plus, MapPin, Star, Edit2, Trash2,
  CreditCard, MessageSquare, Check, Lock, Unlock,
  UploadCloud, CheckCircle, AlertCircle, X,
  LayoutDashboard, BarChart3, Home, LogOut, Tag, Sparkles, Eye,
  Clock, Save, BarChart2, Wallet
} from 'lucide-vue-next'

const { t, locale } = useI18n()

// Helper function to generate paginated numbers with ellipsis
const getPageNumbers = (total, cur) => {
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)
  const pages = [1]
  if (cur > 3) pages.push('...')
  const s = Math.max(2, cur - 1)
  const e = Math.min(total - 1, cur + 1)
  for (let i = s; i <= e; i++) pages.push(i)
  if (cur < total - 2) pages.push('...')
  pages.push(total)
  return pages
}

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const router = useRouter()
const authStore = useAuthStore()

// Commission Rate Edit states
const editingUserId = ref(null)
const editingCommissionRate = ref(null)

// Toast notification state
const toast = ref({ show: false, type: 'success', message: '' })
const showToast = (message, type = 'success') => {
  toast.value = { show: true, type, message }
  setTimeout(() => { toast.value.show = false }, 3500)
}

// Custom Confirm Modal State
const showConfirmModal = ref(false)
const confirmMessage = ref('')
const confirmCallback = ref(null)
const triggerConfirm = (message) => {
  return new Promise((resolve) => {
    confirmMessage.value = message
    confirmCallback.value = (result) => {
      showConfirmModal.value = false
      resolve(result)
    }
    showConfirmModal.value = true
  })
}

const startEditCommission = (usr) => {
  editingUserId.value = usr.id
  editingCommissionRate.value = usr.commissionRate !== null ? usr.commissionRate : ''
}

const cancelEditCommission = () => {
  editingUserId.value = null
  editingCommissionRate.value = null
}

const saveCommission = async (usr) => {
  const rateVal = editingCommissionRate.value
  
  if (rateVal !== null && rateVal !== '') {
    const rateNum = Number(rateVal)
    if (isNaN(rateNum) || rateNum < 0 || rateNum > 100) {
      showToast('Tỷ lệ hoa hồng phải từ 0% đến 100%', 'error')
      return
    }
  }
  
  try {
    const rateParam = (rateVal !== null && rateVal !== '') ? `?rate=${rateVal}` : ''
    const response = await axios.patch(`/admin/users/${usr.id}/commission-rate${rateParam}`)
    
    // Update local user state
    usr.commissionRate = (rateVal !== null && rateVal !== '') ? Number(rateVal) : null
    
    showToast(response.data?.message || `Đã cập nhật tỷ lệ hoa hồng: ${usr.commissionRate}%`)
    editingUserId.value = null
  } catch (err) {
    console.error('Cập nhật tỷ lệ hoa hồng thất bại:', err)
    showToast(err.response?.data?.message || 'Không thể cập nhật tỷ lệ hoa hồng.', 'error')
  }
}

const resetCommission = async (usr) => {
  if (!await triggerConfirm(t('admin.confirm_reset_commission', { name: usr.fullName }))) return
  try {
    const response = await axios.patch(`/admin/users/${usr.id}/commission-rate`)
    usr.commissionRate = null
    showToast(response.data?.message || 'Đã đặt lại tỷ lệ hoa hồng về mặc định hệ thống.')
    if (editingUserId.value === usr.id) {
      editingUserId.value = null
    }
  } catch (err) {
    console.error('Đặt lại tỷ lệ hoa hồng thất bại:', err)
    showToast(err.response?.data?.message || 'Không thể đặt lại tỷ lệ hoa hồng.', 'error')
  }
}

const stats = ref(null)
const allBookings = ref([])
const bookingSearchQuery = ref('')
const bookingStartDate = ref('')
const bookingEndDate = ref('')
const bookingCurrentPage = ref(1)
const bookingItemsPerPage = ref(10) // 10 bookings per page
const usersList = ref([])
const userRoleFilter = ref('ALL') // 'ALL' | 'CUSTOMER' | 'HOST' | 'ADMIN'
const userCurrentPage = ref(1)
const userItemsPerPage = ref(10) // 10 users per page
const roomsList = ref([])

// Room management filter, sort and pagination states
const roomSearchQuery = ref('')
const roomCityFilter = ref('ALL')
const roomTypeFilter = ref('ALL')
const roomStatusFilter = ref('ALL')
const roomSortBy = ref('NONE')

const appliedRoomSearchQuery = ref('')
const appliedRoomCityFilter = ref('ALL')
const appliedRoomTypeFilter = ref('ALL')
const appliedRoomStatusFilter = ref('ALL')
const appliedRoomSortBy = ref('NONE')

const roomCurrentPage = ref(1)
const roomItemsPerPage = ref(5) // 5 items per page

const applyRoomFilters = () => {
  appliedRoomSearchQuery.value = roomSearchQuery.value
  appliedRoomCityFilter.value = roomCityFilter.value
  appliedRoomTypeFilter.value = roomTypeFilter.value
  appliedRoomStatusFilter.value = roomStatusFilter.value
  appliedRoomSortBy.value = roomSortBy.value
  roomCurrentPage.value = 1
}

const resetRoomFilters = () => {
  roomSearchQuery.value = ''
  roomCityFilter.value = 'ALL'
  roomTypeFilter.value = 'ALL'
  roomStatusFilter.value = 'ALL'
  roomSortBy.value = 'NONE'
  applyRoomFilters()
}

const filteredRooms = computed(() => {
  let list = [...roomsList.value]

  // 1. Search Query (name, address, city, host name, host email, id)
  const q = appliedRoomSearchQuery.value.trim().toLowerCase()
  if (q) {
    list = list.filter(rm => {
      const nameMatch = rm.name?.toLowerCase().includes(q)
      const addrMatch = rm.address?.toLowerCase().includes(q)
      const cityMatch = rm.city?.toLowerCase().includes(q)
      const hostName = rm.hostName || rm.host?.fullName || ''
      const hostEmail = rm.hostEmail || rm.host?.email || ''
      const hostMatch = hostName.toLowerCase().includes(q) || hostEmail.toLowerCase().includes(q)
      const idMatch = `#${rm.id}` === q || rm.id?.toString() === q
      return nameMatch || addrMatch || cityMatch || hostMatch || idMatch
    })
  }

  // 2. City Filter
  if (appliedRoomCityFilter.value !== 'ALL') {
    list = list.filter(rm => rm.city === appliedRoomCityFilter.value)
  }

  // 3. Room Type Filter
  if (appliedRoomTypeFilter.value !== 'ALL') {
    list = list.filter(rm => {
      const type = rm.roomTypeName?.toLowerCase() || ''
      const filterVal = appliedRoomTypeFilter.value.toLowerCase()
      
      if (filterVal === 'phòng đơn') return type.includes('đơn') || type.includes('single')
      if (filterVal === 'deluxe') return type.includes('deluxe')
      if (filterVal === 'family room') return type.includes('family') || type.includes('gia đình')
      if (filterVal === 'villa') return type.includes('villa') || type.includes('biệt thự')
      if (filterVal === 'standard') return type.includes('standard')
      if (filterVal === 'penthouse') return type.includes('penthouse')
      if (filterVal === 'nhà nguyên căn') return type.includes('nhà nguyên căn') || type.includes('house')
      
      return type.includes(filterVal)
    })
  }

  // 4. Status Filter
  if (appliedRoomStatusFilter.value !== 'ALL') {
    list = list.filter(rm => {
      const status = rm.status?.toUpperCase() || 'ACTIVE'
      return status === appliedRoomStatusFilter.value
    })
  }

  // 5. Sorting
  if (appliedRoomSortBy.value === 'PRICE_ASC') {
    list.sort((a, b) => a.pricePerNight - b.pricePerNight)
  } else if (appliedRoomSortBy.value === 'PRICE_DESC') {
    list.sort((a, b) => b.pricePerNight - a.pricePerNight)
  } else if (appliedRoomSortBy.value === 'NEWEST') {
    list.sort((a, b) => b.id - a.id)
  } else if (appliedRoomSortBy.value === 'MOST_BOOKED') {
    list.sort((a, b) => {
      const countA = allBookings.value.filter(bk => bk.roomId === a.id).length
      const countB = allBookings.value.filter(bk => bk.roomId === b.id).length
      return countB - countA
    })
  } else if (appliedRoomSortBy.value === 'HIGHEST_RATED') {
    list.sort((a, b) => {
      const revsA = reviewsList.value.filter(rv => rv.roomId === a.id)
      const avgA = revsA.length ? revsA.reduce((sum, r) => sum + r.rating, 0) / revsA.length : 0
      
      const revsB = reviewsList.value.filter(rv => rv.roomId === b.id)
      const avgB = revsB.length ? revsB.reduce((sum, r) => sum + r.rating, 0) / revsB.length : 0
      
      return avgB - avgA
    })
  }

  return list
})

const paginatedRooms = computed(() => {
  const start = (roomCurrentPage.value - 1) * roomItemsPerPage.value
  const end = start + roomItemsPerPage.value
  return filteredRooms.value.slice(start, end)
})

const roomTotalPages = computed(() => {
  return Math.ceil(filteredRooms.value.length / roomItemsPerPage.value) || 1
})

const defaultCommissionRate = ref(10)
const fetchDefaultCommissionRate = async () => {
  try {
    const res = await axios.get('/admin/settings/commission-rate')
    defaultCommissionRate.value = res.data.defaultRate
  } catch (err) {
    console.error('Lấy hoa hồng mặc định thất bại:', err)
  }
}

const showCommissionModal = ref(false)
const newSystemCommission = ref(10)
const commissionModalError = ref('')
const commissionModalLoading = ref(false)

const openCommissionModal = () => {
  newSystemCommission.value = defaultCommissionRate.value
  commissionModalError.value = ''
  showCommissionModal.value = true
}

const saveSystemCommission = async () => {
  const val = newSystemCommission.value
  if (val === null || val === undefined || val === '') {
    commissionModalError.value = locale.value === 'en' ? 'Please enter a value' : 'Vui lòng nhập tỷ lệ hoa hồng'
    return
  }
  const num = Number(val)
  if (isNaN(num) || num < 0 || num > 100) {
    commissionModalError.value = locale.value === 'en' ? 'Rate must be between 0 and 100%' : 'Tỷ lệ hoa hồng phải từ 0% đến 100%'
    return
  }
  
  commissionModalLoading.value = true
  commissionModalError.value = ''
  try {
    await axios.put('/admin/settings/commission-rate', null, { params: { rate: num } })
    defaultCommissionRate.value = num
    showToast(locale.value === 'en' ? 'Updated commission rate successfully!' : 'Cập nhật tỷ lệ hoa hồng mặc định thành công!')
    showCommissionModal.value = false
  } catch (err) {
    console.error('Cập nhật hoa hồng thất bại:', err)
    commissionModalError.value = err.response?.data?.message || (locale.value === 'en' ? 'Failed to update commission rate' : 'Không thể cập nhật hoa hồng.')
  } finally {
    commissionModalLoading.value = false
  }
}


const pendingRoomsCount = computed(() => {
  return roomsList.value.filter(r => r.status === 'PENDING').length
})

const recentActivities = computed(() => {
  const list = []
  
  // 1. Add real bookings
  allBookings.value.forEach(bk => {
    if (bk.createdAt) {
      list.push({
        timestamp: new Date(bk.createdAt).getTime(),
        timeStr: new Date(bk.createdAt).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }),
        text: locale.value === 'en' 
          ? `Guest ${bk.guestName} booked room #${bk.id} (${bk.roomName})` 
          : `Khách hàng ${bk.guestName} đặt phòng #${bk.id} (${bk.roomName})`,
        icon: 'booking'
      })
    }
  })
  
  // 2. Add real reviews with mock timestamp based on their IDs to keep it stable
  reviewsList.value.forEach(rv => {
    const mockTime = new Date().setHours(12 - (rv.id % 12), (rv.id * 7) % 60, 0, 0)
    list.push({
      timestamp: mockTime,
      timeStr: new Date(mockTime).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }),
      text: locale.value === 'en' 
        ? `Guest ${rv.customerName} rated ${rv.rating}★ for room ${rv.roomName}` 
        : `Người dùng ${rv.customerName} đánh giá ${rv.rating}★ cho phòng ${rv.roomName}`,
      icon: 'review'
    })
  })
  
  // 3. Add real rooms with mock timestamp
  roomsList.value.slice(0, 5).forEach(rm => {
    const mockTime = new Date().setHours(14 - (rm.id % 10), (rm.id * 9) % 60, 0, 0)
    list.push({
      timestamp: mockTime,
      timeStr: new Date(mockTime).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }),
      text: locale.value === 'en' 
        ? `Host registered a new room: ${rm.name} (${rm.city})` 
        : `Chủ phòng đăng phòng mới: ${rm.name} (${rm.city})`,
      icon: 'room'
    })
  })
  
  // Sort all activities by timestamp descending
  return list.sort((a, b) => b.timestamp - a.timestamp).slice(0, 8)
})
const paymentsList = ref([])
const paymentStatusFilter = ref('ALL') // 'ALL' | 'SUCCESS' | 'PENDING' | 'FAILED'
const paymentStartDate = ref('')
const paymentEndDate = ref('')

const paymentCurrentPage = ref(1)
const paymentItemsPerPage = ref(10) // 10 items per page

const resetPaymentFilters = () => {
  paymentStatusFilter.value = 'ALL'
  paymentStartDate.value = ''
  paymentEndDate.value = ''
  paymentCurrentPage.value = 1
}

watch([paymentStatusFilter, paymentStartDate, paymentEndDate], () => {
  paymentCurrentPage.value = 1
})

const filteredPayments = computed(() => {
  let list = paymentsList.value

  if (paymentStatusFilter.value !== 'ALL') {
    list = list.filter(pm => pm.status === paymentStatusFilter.value)
  }

  if (paymentStartDate.value) {
    const startVal = new Date(paymentStartDate.value).setHours(0, 0, 0, 0)
    list = list.filter(pm => {
      if (!pm.createdAt) return false
      const pmDate = new Date(pm.createdAt).getTime()
      return pmDate >= startVal
    })
  }

  if (paymentEndDate.value) {
    const endVal = new Date(paymentEndDate.value).setHours(23, 59, 59, 999)
    list = list.filter(pm => {
      if (!pm.createdAt) return false
      const pmDate = new Date(pm.createdAt).getTime()
      return pmDate <= endVal
    })
  }

  return list
})

const paginatedPayments = computed(() => {
  const start = (paymentCurrentPage.value - 1) * paymentItemsPerPage.value
  const end = start + paymentItemsPerPage.value
  return filteredPayments.value.slice(start, end)
})

const paymentTotalPages = computed(() => {
  return Math.ceil(filteredPayments.value.length / paymentItemsPerPage.value) || 1
})

const reviewsList = ref([])
const starFilter = ref('ALL') // 'ALL' | 5 | 4 | 3 | 2 | 1
const activeTab = ref('dashboard')

const reviewCurrentPage = ref(1)
const reviewItemsPerPage = ref(10) // 10 reviews per page

const countReviewsByStar = (star) => {
  return reviewsList.value.filter(rv => Math.round(rv.rating) === star).length
}

const filteredReviews = computed(() => {
  if (starFilter.value === 'ALL') {
    return reviewsList.value
  }
  return reviewsList.value.filter(rv => Math.round(rv.rating) === starFilter.value)
})

const paginatedReviews = computed(() => {
  const start = (reviewCurrentPage.value - 1) * reviewItemsPerPage.value
  const end = start + reviewItemsPerPage.value
  return filteredReviews.value.slice(start, end)
})

const reviewTotalPages = computed(() => {
  return Math.ceil(filteredReviews.value.length / reviewItemsPerPage.value) || 1
})

watch(starFilter, () => {
  reviewCurrentPage.value = 1
})

const countUsersByRole = (role) => {
  return usersList.value.filter(u => u.role === role).length
}

const filteredUsers = computed(() => {
  if (userRoleFilter.value === 'ALL') {
    return usersList.value
  }
  return usersList.value.filter(u => u.role === userRoleFilter.value)
})

const paginatedUsers = computed(() => {
  const start = (userCurrentPage.value - 1) * userItemsPerPage.value
  const end = start + userItemsPerPage.value
  return filteredUsers.value.slice(start, end)
})

const userTotalPages = computed(() => {
  return Math.ceil(filteredUsers.value.length / userItemsPerPage.value) || 1
})

watch(userRoleFilter, () => {
  userCurrentPage.value = 1
})

const resetBookingFilters = () => {
  bookingSearchQuery.value = ''
  bookingStartDate.value = ''
  bookingEndDate.value = ''
}

const filteredBookings = computed(() => {
  let list = allBookings.value

  // 1. Filter by search query
  if (bookingSearchQuery.value && bookingSearchQuery.value.trim() !== '') {
    const query = bookingSearchQuery.value.toLowerCase().trim()
    list = list.filter(bk => {
      const idMatch = bk.id?.toString().includes(query)
      const guestMatch = bk.guestName?.toLowerCase().includes(query) || bk.guestEmail?.toLowerCase().includes(query) || bk.guestPhone?.includes(query)
      const roomMatch = bk.roomName?.toLowerCase().includes(query) || bk.city?.toLowerCase().includes(query)
      const statusMatch = getStatusLabel(bk.status)?.toLowerCase().includes(query) || bk.status?.toLowerCase().includes(query)
      return idMatch || guestMatch || roomMatch || statusMatch
    })
  }

  // 2. Filter by start booking date
  if (bookingStartDate.value) {
    const startVal = new Date(bookingStartDate.value).setHours(0, 0, 0, 0)
    list = list.filter(bk => {
      if (!bk.createdAt) return false
      const bDate = new Date(bk.createdAt).getTime()
      return bDate >= startVal
    })
  }

  // 3. Filter by end booking date
  if (bookingEndDate.value) {
    const endVal = new Date(bookingEndDate.value).setHours(23, 59, 59, 999)
    list = list.filter(bk => {
      if (!bk.createdAt) return false
      const bDate = new Date(bk.createdAt).getTime()
      return bDate <= endVal
    })
  }

  return list
})

const paginatedBookings = computed(() => {
  const start = (bookingCurrentPage.value - 1) * bookingItemsPerPage.value
  const end = start + bookingItemsPerPage.value
  return filteredBookings.value.slice(start, end)
})

const bookingTotalPages = computed(() => {
  return Math.ceil(filteredBookings.value.length / bookingItemsPerPage.value) || 1
})

watch([bookingSearchQuery, bookingStartDate, bookingEndDate], () => {
  bookingCurrentPage.value = 1
})

const todayDateLabel = computed(() => {
  const localeCode = locale.value === 'en' ? 'en-US' : 'vi-VN'
  return new Date().toLocaleDateString(localeCode, { weekday: 'long', day: '2-digit', month: '2-digit', year: 'numeric' })
})

const activePageTitle = computed(() => {
  switch (activeTab.value) {
    case 'dashboard': return t('admin.page_dashboard_title')
    case 'bookings':  return t('admin.page_bookings_title')
    case 'users':     return t('admin.page_users_title')
    case 'rooms':     return t('admin.page_rooms_title')
    case 'payments':  return t('admin.page_payments_title')
    case 'reviews':   return t('admin.page_reviews_title')
    default:          return t('admin.panel_admin')
  }
})

const activePageSubtitle = computed(() => {
  switch (activeTab.value) {
    case 'dashboard': return t('admin.subtitle_dashboard')
    case 'bookings':  return t('admin.subtitle_bookings')
    case 'users':     return t('admin.subtitle_users')
    case 'rooms':     return t('admin.subtitle_rooms')
    case 'payments':  return t('admin.subtitle_payments')
    case 'reviews':   return t('admin.subtitle_reviews')
    default:          return t('admin.subtitle_default')
  }
})

// Modals room state
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

// Modals review state
const showReviewDeleteModal = ref(false)
const selectedReview = ref(null)
const reviewDeleteLoading = ref(false)

// Booking detail modal state
const showBookingDetailModal = ref(false)
const selectedBooking = ref(null)

const openBookingDetail = (booking) => {
  selectedBooking.value = booking
  showBookingDetailModal.value = true
}

// User detail modal state
const showUserDetailModal = ref(false)
const selectedUserDetail = ref(null)

const openUserDetail = (usr) => {
  selectedUserDetail.value = usr
  showUserDetailModal.value = true
}

// Room detail right drawer state
const showRoomDetailDrawer = ref(false)
const selectedRoomDetail = ref(null)

const openRoomDetail = async (room) => {
  try {
    const res = await axios.get(`/rooms/${room.id}`)
    selectedRoomDetail.value = res.data
  } catch (err) {
    console.error('Lấy chi tiết phòng thất bại:', err)
    selectedRoomDetail.value = room
  }
  showRoomDetailDrawer.value = true
}

const openRoomDetailFromReview = async (rv) => {
  const roomId = rv.roomId || rv.room?.id
  if (!roomId) {
    alert(locale.value === 'en' ? 'Cannot find room ID for this review' : 'Không tìm thấy ID phòng cho đánh giá này')
    return
  }
  await openRoomDetail({ id: roomId })
}

const parsedAmenities = computed(() => {
  if (!selectedRoomDetail.value?.amenities) return []
  return selectedRoomDetail.value.amenities.split(',').map(a => a.trim()).filter(Boolean)
})

const roomReviews = computed(() => {
  if (!selectedRoomDetail.value) return []
  return reviewsList.value.filter(rv => rv.roomId === selectedRoomDetail.value.id)
})

const roomBookings = computed(() => {
  if (!selectedRoomDetail.value) return []
  return allBookings.value.filter(bk => bk.roomId === selectedRoomDetail.value.id)
})

const roomRevenue = computed(() => {
  return roomBookings.value
    .filter(bk => bk.status === 'COMPLETED' || bk.status === 'CONFIRMED')
    .reduce((sum, bk) => sum + (bk.totalPrice || 0), 0)
})

const formatPrice = (p) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p)

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  return d.toLocaleDateString('vi-VN')
}

const formatDateTime = (dateTimeStr) => {
  if (!dateTimeStr) return ''
  const d = new Date(dateTimeStr)
  return d.toLocaleString('vi-VN')
}

const calculateDuration = (inStr, outStr) => {
  const diff = new Date(outStr) - new Date(inStr)
  return Math.max(1, Math.ceil(diff / (1000 * 60 * 60 * 24)))
}

const getStatusLabel = (status) => {
  switch (status) {
    case 'PENDING': return t('admin.status_upcoming')
    case 'CONFIRMED': return t('admin.status_confirmed')
    case 'COMPLETED': return t('admin.status_completed')
    case 'CANCELLED': return t('admin.status_cancelled')
    default: return status
  }
}

const getRoomStatusLabel = (status) => {
  switch (status) {
    case 'PENDING': return t('admin.status_pending_approval')
    case 'ACTIVE': return t('admin.status_active')
    default: return status || t('admin.status_active')
  }
}

const getPaymentStatusLabel = (status) => {
  switch (status) {
    case 'SUCCESS':
    case 'COMPLETED': return t('admin.status_success')
    case 'PENDING': return t('admin.status_pending')
    case 'FAILED': return t('admin.status_failed')
    case 'REFUNDED': return t('admin.status_refunded')
    default: return status
  }
}

// Fetch Admin Dashboard Data
const fetchAdminData = async () => {
  try {
    const resStats = await axios.get('/admin/stats')
    stats.value = resStats.data

    const resBookings = await axios.get('/admin/bookings')
    allBookings.value = resBookings.data

    const resUsers = await axios.get('/admin/users')
    usersList.value = resUsers.data.map(u => ({
      ...u,
      commissionRate: u.commissionRate !== undefined ? u.commissionRate : null
    }))

    // Dùng đúng endpoint admin thay vì gọi /rooms (public) với query admin=true
    const resRooms = await axios.get('/admin/rooms')
    roomsList.value = resRooms.data.content ?? resRooms.data

    // Fetch payments and reviews with catch to avoid breaking if API not implemented
    try {
      const resPayments = await axios.get('/admin/payments')
      paymentsList.value = resPayments.data
    } catch (e) {
      console.warn('Lấy danh sách thanh toán thất bại:', e)
    }

    try {
      const resReviews = await axios.get('/admin/reviews')
      reviewsList.value = resReviews.data
    } catch (e) {
      console.warn('Lấy danh sách đánh giá thất bại:', e)
    }
  } catch (err) {
    console.error('Lấy thông tin Admin thất bại:', err)
  }
}

// Toggle account active status
const toggleUserActive = async (user) => {
  try {
    await axios.put(`/admin/users/${user.id}/toggle-active`)
    user.active = !user.active
  } catch (err) {
    console.error('Thay đổi trạng thái tài khoản thất bại:', err)
    alert(err.response?.data?.message || 'Không thể thay đổi trạng thái tài khoản.')
  }
}

// Approve PENDING Room to ACTIVE
const approveRoom = async (roomId) => {
  try {
    await axios.put(`/admin/rooms/${roomId}/approve`)
    const idx = roomsList.value.findIndex(r => r.id === roomId)
    if (idx !== -1) {
      roomsList.value[idx].status = 'ACTIVE'
    }
  } catch (err) {
    console.error('Duyệt phòng thất bại:', err)
    alert(err.response?.data?.message || 'Không thể duyệt phòng nghỉ.')
  }
}

// Review moderation handlers
const confirmDeleteReview = (rev) => {
  selectedReview.value = rev
  showReviewDeleteModal.value = true
}

const executeDeleteReview = async () => {
  if (!selectedReview.value) return
  reviewDeleteLoading.value = true
  try {
    await axios.delete(`/admin/reviews/${selectedReview.value.id}`)
    reviewsList.value = reviewsList.value.filter(r => r.id !== selectedReview.value.id)
    showReviewDeleteModal.value = false
  } catch (err) {
    console.error('Xóa đánh giá thất bại:', err)
    alert(err.response?.data?.message || 'Không thể xóa đánh giá.')
  } finally {
    reviewDeleteLoading.value = false
    selectedReview.value = null
  }
}

// Add/Edit/Delete Room Handlers
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

      const idx = roomsList.value.findIndex(r => r.id === roomId)
      if (idx !== -1) {
        roomsList.value[idx] = roomRes.data
      }
    } catch (err) {
      console.error('Upload ảnh thất bại:', err)
      alert('Không thể upload ảnh: ' + (err.response?.data?.message || err.message))
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
      const idx = roomsList.value.findIndex(r => r.id === roomId)
      if (idx !== -1) {
        roomsList.value[idx] = roomRes.data
      }
    } catch (err) {
      console.error('Đặt làm ảnh đại diện thất bại:', err)
      alert('Không thể đặt làm ảnh đại diện: ' + (err.response?.data?.message || err.message))
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
  if (!await triggerConfirm(locale.value === 'vi' ? 'Bạn có chắc chắn muốn xóa ảnh này?' : 'Are you sure you want to delete this image?')) return

  if (isEditMode.value && img.id) {
    formLoading.value = true
    try {
      await axios.delete(`/images/${img.id}`)

      roomImages.value.splice(index, 1)

      const roomId = roomForm.value.id
      const roomRes = await axios.get(`/rooms/${roomId}`)
      const idx = roomsList.value.findIndex(r => r.id === roomId)
      if (idx !== -1) {
        roomsList.value[idx] = roomRes.data
      }
    } catch (err) {
      console.error('Xóa ảnh thất bại:', err)
      alert('Không thể xóa ảnh: ' + (err.response?.data?.message || err.message))
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
    alert('Vui lòng chọn ít nhất một hình ảnh cho phòng nghỉ.')
    return
  }
  if (isEditMode.value && roomImages.value.length === 0) {
    alert('Vui lòng tải lên ít nhất một hình ảnh cho phòng nghỉ.')
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
    imageUrls: isEditMode.value ? roomImages.value.map(img => img.url) : [],
    description: roomForm.value.description
  }

  try {
    if (isEditMode.value) {
      const res = await axios.put(`/rooms/${roomForm.value.id}`, payload)
      const idx = roomsList.value.findIndex(r => r.id === roomForm.value.id)
      if (idx !== -1) roomsList.value[idx] = res.data
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
      roomsList.value.push(updatedRes.data)
      if (stats.value) stats.value.totalRooms++
      showFormModal.value = false
    }
  } catch (err) {
    console.error('Lưu phòng thất bại:', err)
    alert(err.response?.data?.message || 'Có lỗi xảy ra khi lưu thông tin phòng nghỉ.')
  } finally {
    formLoading.value = false
  }
}

const confirmDeleteRoom = (room) => {
  selectedRoom.value = room
  showDeleteModal.value = true
}

const executeDeleteRoom = async () => {
  if (!selectedRoom.value) return
  deleteLoading.value = true
  try {
    await axios.delete(`/rooms/${selectedRoom.value.id}`)
    roomsList.value = roomsList.value.filter(r => r.id !== selectedRoom.value.id)
    if (stats.value) stats.value.totalRooms--
    showDeleteModal.value = false
  } catch (err) {
    console.error('Xóa phòng thất bại:', err)
    alert(err.response?.data?.message || 'Không thể xóa phòng nghỉ. Vui lòng thử lại.')
  } finally {
    deleteLoading.value = false
    selectedRoom.value = null
  }
}

// Update User Role
const changeUserRole = async (userId, newRole) => {
  try {
    await axios.put(`/admin/users/${userId}/role`, { role: newRole })

    // Update local state
    const idx = usersList.value.findIndex(u => u.id === userId)
    if (idx !== -1) {
      usersList.value[idx].role = newRole
    }

    // Update statistics just in case roles count changes
    const resStats = await axios.get('/admin/stats')
    stats.value = resStats.data
  } catch (err) {
    console.error('Thay đổi vai trò thất bại:', err)
    alert(err.response?.data?.message || 'Không thể thay đổi quyền hạn người dùng.')
  }
}

// Confirm booking status (PENDING -> CONFIRMED). Việc chuyển sang COMPLETED
// là do HOST thực hiện ở luồng khác, Admin chỉ xác nhận đơn.
const confirmBookingStatus = async (bookingId) => {
  try {
    await axios.patch(`/bookings/${bookingId}/confirm`)
    const idx = allBookings.value.findIndex(b => b.id === bookingId)
    if (idx !== -1) {
      allBookings.value[idx].status = 'CONFIRMED'
    }
  } catch (err) {
    console.error('Xác nhận đặt phòng thất bại:', err)
    alert(err.response?.data?.message || 'Không thể xác nhận đơn đặt phòng.')
  }
}

// Cancel booking status (PENDING/CONFIRMED -> CANCELLED)
const cancelBookingStatus = async (bookingId) => {
  if (!await triggerConfirm(locale.value === 'vi' ? 'Bạn có chắc chắn muốn hủy đơn đặt phòng này?' : 'Are you sure you want to cancel this booking?')) return
  try {
    await axios.patch(`/bookings/${bookingId}/cancel`)
    const idx = allBookings.value.findIndex(b => b.id === bookingId)
    if (idx !== -1) allBookings.value[idx].status = 'CANCELLED'
  } catch (err) {
    console.error('Hủy đặt phòng thất bại:', err)
    alert(err.response?.data?.message || 'Không thể hủy đơn đặt phòng.')
  }
}

// ==========================================
// ADMIN PAYOUT REQUESTS MANAGEMENT
// ==========================================
const payoutRequests = ref([])
const adminPayoutStatusFilter = ref('ALL')
const payoutCurrentPage = ref(1)
const payoutItemsPerPage = 10
const showRejectPayoutModal = ref(false)
const selectedPayoutForReject = ref(null)
const rejectPayoutReason = ref('')

const fetchPayoutRequests = async () => {
  try {
    const res = await axios.get('/payouts/admin')
    payoutRequests.value = res.data || []
  } catch (err) {
    console.error('Lỗi khi tải danh sách rút tiền:', err)
  }
}

const filteredPayouts = computed(() => {
  if (adminPayoutStatusFilter.value === 'ALL') {
    return payoutRequests.value
  }
  return payoutRequests.value.filter(p => p.status === adminPayoutStatusFilter.value)
})

const paginatedPayouts = computed(() => {
  const start = (payoutCurrentPage.value - 1) * payoutItemsPerPage
  const end = start + payoutItemsPerPage
  return filteredPayouts.value.slice(start, end)
})

const payoutTotalPages = computed(() => {
  return Math.ceil(filteredPayouts.value.length / payoutItemsPerPage)
})

watch(adminPayoutStatusFilter, () => {
  payoutCurrentPage.value = 1
})

const handleApprovePayout = async (payoutId) => {
  if (!await triggerConfirm(locale.value === 'vi' ? 'Bạn có chắc chắn muốn duyệt và chuyển khoản cho yêu cầu rút tiền này?' : 'Are you sure you want to approve and transfer funds for this request?')) return
  try {
    await axios.patch(`/payouts/admin/${payoutId}/approve`)
    showToast(locale.value === 'vi' ? 'Duyệt chuyển khoản thành công' : 'Payout approved successfully')
    await fetchPayoutRequests()
  } catch (err) {
    console.error('Duyệt rút tiền thất bại:', err)
    showToast(err.response?.data?.message || (locale.value === 'vi' ? 'Duyệt rút tiền thất bại' : 'Failed to approve payout'), 'error')
  }
}

const openRejectPayoutModal = (payout) => {
  selectedPayoutForReject.value = payout
  rejectPayoutReason.value = ''
  showRejectPayoutModal.value = true
}

const handleRejectPayout = async () => {
  if (!selectedPayoutForReject.value) return
  if (!rejectPayoutReason.value.trim()) {
    showToast(locale.value === 'vi' ? 'Vui lòng nhập lý do từ chối' : 'Please input a reason for rejection', 'error')
    return
  }
  try {
    await axios.patch(`/payouts/admin/${selectedPayoutForReject.value.id}/reject`, null, {
      params: { reason: rejectPayoutReason.value.trim() }
    })
    showToast(locale.value === 'vi' ? 'Đã từ chối yêu cầu rút tiền' : 'Payout request rejected')
    showRejectPayoutModal.value = false
    await fetchPayoutRequests()
  } catch (err) {
    console.error('Từ chối rút tiền thất bại:', err)
    showToast(err.response?.data?.message || (locale.value === 'vi' ? 'Từ chối rút tiền thất bại' : 'Failed to reject payout'), 'error')
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

const handleLogout = () => {
  authStore.logout()
  router.push('/')
}

const bookingPageNumbers = computed(() => getPageNumbers(bookingTotalPages.value, bookingCurrentPage.value))
const userPageNumbers = computed(() => getPageNumbers(userTotalPages.value, userCurrentPage.value))
const roomPageNumbers = computed(() => getPageNumbers(roomTotalPages.value, roomCurrentPage.value))
const paymentPageNumbers = computed(() => getPageNumbers(paymentTotalPages.value, paymentCurrentPage.value))
const reviewPageNumbers = computed(() => getPageNumbers(reviewTotalPages.value, reviewCurrentPage.value))
const payoutPageNumbers = computed(() => getPageNumbers(payoutTotalPages.value, payoutCurrentPage.value))

onMounted(() => {
  if (!authStore.isLoggedIn) {
    router.push('/login')
  } else if (authStore.role !== 'ADMIN') {
    router.push('/')
  } else {
    fetchAdminData()
    fetchDefaultCommissionRate()
    fetchPayoutRequests()
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; background: #f8f9fc; color: #1e293b; }
.container { max-width: 1200px; margin: 0 auto; padding: 0 1.5rem; }
.min-h-screen { min-height: 100vh; display: flex; flex-direction: column; font-family: 'Inter', sans-serif; }

/* ===== SIDEBAR LAYOUT STYLES ===== */
.admin-dashboard-layout {
  display: flex;
  min-height: 100vh;
  background: #f8fafc;
  font-family: 'Inter', sans-serif;
  color: #1e293b;
  width: 100%;
}

.admin-sidebar {
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
  overflow-y: auto;
}

.admin-sidebar::-webkit-scrollbar {
  width: 4px;
}
.admin-sidebar::-webkit-scrollbar-track {
  background: transparent;
}
.admin-sidebar::-webkit-scrollbar-thumb {
  background: #e2e8f0;
  border-radius: 999px;
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
  background: #7c3aed;
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
  width: 100%;
}

.menu-item:hover, .menu-item-link:hover {
  background: #f1f5f9;
  color: #1e293b;
}

.menu-item.active {
  background: #f5f3ff;
  color: #7c3aed;
}

.menu-item-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  color: #64748b;
  text-decoration: none;
  font-size: 0.875rem;
  font-weight: 700;
  border-radius: 10px;
  transition: all 0.2s ease;
}

.sidebar-divider {
  border: 0;
  border-top: 1px solid #e2e8f0;
  margin: 0.75rem 0;
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
.admin-main-container {
  flex: 1;
  margin-left: 260px;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

.admin-top-header {
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
}

.page-subtitle {
  font-size: 0.82rem;
  color: #64748b;
  font-weight: 500;
  margin-top: 0.15rem;
}

.today-date-top {
  font-size: 0.8rem;
  font-weight: 700;
  color: #7c3aed;
  background: #f5f3ff;
  border: 1px solid #ddd6fe;
  padding: 0.35rem 0.85rem;
  border-radius: 999px;
}

.admin-main-content {
  padding: 2rem;
  flex: 1;
}

/* QUICK ACCESS CARD IN DASHBOARD */
.quick-settings-card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 20px;
  padding: 2rem;
  margin-top: 2rem;
  box-shadow: 0 4px 20px rgba(0,0,0,0.02);
}

.quick-settings-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
}

.quick-settings-header h3 {
  font-size: 1.25rem;
  font-weight: 800;
  color: #1e293b;
}

.quick-settings-card p {
  font-size: 0.9rem;
  color: #475569;
  line-height: 1.6;
}

.quick-actions-row {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}

.action-btn-shortcut {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.65rem 1.25rem;
  background: #eff6ff;
  color: #1a6cf7;
  font-size: 0.85rem;
  font-weight: 700;
  border-radius: 10px;
  text-decoration: none;
  transition: all 0.2s ease;
  border: 1.5px solid #bfdbfe;
}

.action-btn-shortcut:hover {
  background: #1a6cf7;
  color: white;
  border-color: #1a6cf7;
}

.action-btn-shortcut.violet {
  background: #f5f3ff;
  color: #7c3aed;
  border-color: #ddd6fe;
}

.action-btn-shortcut.violet:hover {
  background: #7c3aed;
  color: white;
  border-color: #7c3aed;
}

/* LOADING SCREEN */
.admin-loading-screen {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #f8fafc;
  color: #475569;
  font-family: 'Inter', sans-serif;
  gap: 1rem;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #cbd5e1;
  border-top-color: #7c3aed;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.fade-in-tab {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(4px); }
  to { opacity: 1; transform: translateY(0); }
}

.panel-tag {
  font-size: 0.72rem;
  font-weight: 700;
  background: #f5f3ff;
  color: #7c3aed;
  border: 1px solid #ddd6fe;
  padding: 0.2rem 0.5rem;
  border-radius: 6px;
}

/* ANALYTICS */
.analytics-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 2.5rem; }
.analytic-card { background: white; border: 1px solid #e2e8f0; border-radius: 18px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; }
.icon-wrap { width: 46px; height: 46px; border-radius: 12px; background: #faf5ff; color: #a855f7; display: flex; align-items: center; justify-content: center; }
.icon-wrap.color-blue { background: #eff6ff; color: #1a6cf7; }
.icon-wrap.color-green { background: #ecfdf5; color: #10b981; }
.icon-wrap.color-pink { background: #fff1f2; color: #f43f5e; }
.analytic-card h4 { font-size: 0.72rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.analytic-card .val { font-size: 1.15rem; font-weight: 800; color: #0f172a; margin-top: 0.2rem; display: block; }
.tab-btn.active { color: #1a6cf7; border-bottom-color: #1a6cf7; }

.tab-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
.tab-header h2 { font-size: 1.35rem; font-weight: 800; color: #0f172a; }

/* TABLES */
.table-container { background: white; border: 1px solid #e2e8f0; border-radius: 16px; overflow-x: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
.admin-table { width: 100%; border-collapse: collapse; text-align: left; }
.admin-table th { background: #f8fafc; padding: 1rem 1.5rem; font-size: 0.75rem; font-weight: 800; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #e2e8f0; }
.admin-table td { padding: 1.25rem 1.5rem; border-bottom: 1px solid #f1f5f9; font-size: 0.875rem; color: #334155; }
.admin-table tr:last-child td { border-bottom: none; }
.table-room-info { display: flex; align-items: center; gap: 0.75rem; }
.table-room-img { width: 44px; height: 44px; border-radius: 8px; object-fit: cover; background: #e2e8f0; }
.table-room-info .name { font-weight: 700; color: #1e293b; }
.table-room-info .city { color: #94a3b8; }
.admin-table .name { font-weight: 700; color: #1e293b; }
.admin-table .contact { color: #64748b; }
.stay-dates { font-weight: 700; }
.duration { color: #94a3b8; }
.color-green { color: #10b981; }

.status-badge {
  display: inline-block; font-size: 0.7rem; font-weight: 800;
  padding: 0.2rem 0.5rem; border-radius: 6px; text-transform: uppercase; letter-spacing: 0.02em;
}
.status-badge.pending { background: #fffbeb; color: #d97706; }
.status-badge.confirmed { background: #eff6ff; color: #1a6cf7; }
.status-badge.completed { background: #ecfdf5; color: #059669; }
.status-badge.cancelled { background: #fef2f2; color: #dc2626; }

.role-badge {
  font-size: 0.7rem; font-weight: 800; padding: 0.15rem 0.45rem; border-radius: 4px; text-transform: uppercase;
}
.role-badge.user, .role-badge.customer { background: #f1f5f9; color: #475569; }
.role-badge.host { background: #faf5ff; color: #a855f7; }
.role-badge.admin { background: #fff1f2; color: #f43f5e; }

.status-badge-dot {
  display: inline-flex; align-items: center; gap: 0.35rem; font-size: 0.8rem; font-weight: 600;
}
.status-badge-dot::before {
  content: ''; width: 8px; height: 8px; border-radius: 50%; display: inline-block;
}
.status-badge-dot.active::before { background: #10b981; }
.status-badge-dot.inactive::before { background: #ef4444; }

.role-select {
  padding: 0.4rem 0.6rem; border-radius: 8px; border: 1.5px solid #dde1e9;
  font-size: 0.8rem; font-weight: 600; color: #1e293b; outline: none; background: #fafbfc;
  cursor: pointer; font-family: 'Inter', sans-serif;
}
.role-select:focus { border-color: #1a6cf7; }

/* LOADING */
.loading-wrapper { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 10rem 0; color: #64748b; gap: 1rem; }
.spinner { width: 40px; height: 40px; border: 3px solid rgba(26,108,247,0.1); border-top-color: #1a6cf7; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* EMPTY STATE */
.empty-state { text-align: center; padding: 4rem 2rem; background: white; border: 1px solid #e2e8f0; border-radius: 18px; color: #64748b; }
.color-gray { color: #cbd5e1; }
.empty-state h3 { font-size: 1.2rem; font-weight: 700; color: #1e293b; margin-top: 1rem; margin-bottom: 0.5rem; }
.empty-state p { font-size: 0.9rem; max-width: 320px; margin: 0 auto; }

@media (max-width: 1024px) {
  .analytics-row { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
}
@media (max-width: 768px) {
  .analytics-row { grid-template-columns: 1fr; gap: 1rem; }
  .table-container { overflow-x: auto; }
  .tab-header { flex-direction: column; align-items: flex-start; gap: 1rem; }
  .btn-add-room { width: 100%; justify-content: center; }
  .form-row { flex-direction: column; gap: 1rem; }
}

/* MODAL ROOM FORM */
.modal-backdrop { position: fixed; inset: 0; background: rgba(15,23,42,0.6); backdrop-filter: blur(4px); z-index: 1000; display: flex; align-items: center; justify-content: center; padding: 1rem; }
.room-modal { background: white; border-radius: 20px; width: 100%; max-width: 600px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 25px 50px rgba(0,0,0,0.15); max-height: 90vh; text-align: left; }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 1.25rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
.modal-header h2 { font-size: 1.2rem; font-weight: 800; color: #0f172a; }
.btn-close { background: none; border: none; font-size: 1.75rem; cursor: pointer; color: #94a3b8; }
.btn-close:hover { color: #1e293b; }

.modal-form { padding: 1.5rem; overflow-y: auto; display: flex; flex-direction: column; gap: 1.1rem; }
.form-row { display: flex; gap: 1rem; }
.form-group { display: flex; flex-direction: column; gap: 0.4rem; flex: 1; text-align: left; }
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
.confirm-modal { background: white; border-radius: 18px; padding: 2rem; width: 100%; max-width: 420px; box-shadow: 0 20px 40px rgba(0,0,0,0.15); text-align: left; }
.confirm-modal h3 { font-size: 1.2rem; font-weight: 800; color: #0f172a; margin-bottom: 0.75rem; }
.confirm-modal p { font-size: 0.9rem; color: #475569; line-height: 1.5; margin-bottom: 1.5rem; }
.btn-confirm-delete { background: #ef4444; border: none; color: white; padding: 0.65rem 1.5rem; border-radius: 10px; font-weight: 700; font-size: 0.9rem; cursor: pointer; font-family: 'Inter', sans-serif; }
.btn-confirm-delete:hover { background: #dc2626; }

.spinner-small { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.4); border-top-color: white; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }

.btn-add-room {
  background: #1a6cf7; color: white; border: none; padding: 0.6rem 1.2rem; border-radius: 10px;
  font-size: 0.85rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.35rem;
  box-shadow: 0 4px 12px rgba(26,108,247,0.25); transition: background 0.2s; font-family: 'Inter', sans-serif;
}
.btn-add-room:hover { background: #1558d6; }

.table-actions { display: flex; gap: 0.5rem; }
.btn-table-edit { background: #f1f5f9; border: none; color: #475569; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.25rem; }
.btn-table-edit:hover { background: #e2e8f0; }
.btn-table-delete { background: white; border: 1px solid #ef4444; color: #ef4444; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.25rem; }
.btn-table-delete:hover { background: #fef2f2; }

.room-type-badge { display: inline-block; background: #eff6ff; color: #1a6cf7; font-size: 0.75rem; font-weight: 700; padding: 0.2rem 0.5rem; border-radius: 6px; }
.modal-actions { display: flex; justify-content: flex-end; gap: 0.5rem; margin-top: 1rem; }
.table-room-info .addr { color: #94a3b8; font-size: 0.75rem; margin-top: 0.15rem; }

/* NEW ADMIN CONTROLS */
.btn-table-approve { background: #ecfdf5; border: none; color: #059669; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 0.25rem; transition: all 0.2s; }
.btn-table-approve:hover { background: #d1fae5; }

.btn-table-lock { background: #fef2f2; border: none; color: #ef4444; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 0.25rem; transition: all 0.2s; }
.btn-table-lock:hover { background: #fee2e2; }

.btn-table-unlock { background: #eff6ff; border: none; color: #1a6cf7; padding: 0.35rem 0.75rem; border-radius: 6px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 0.25rem; transition: all 0.2s; }
.btn-table-unlock:hover { background: #dbeafe; }

.status-badge.active { background: #ecfdf5; color: #059669; }
.status-badge.success { background: #ecfdf5; color: #059669; }
.status-badge.failed { background: #fef2f2; color: #dc2626; }
.status-badge.refunded { background: #f1f5f9; color: #475569; }
.status-badge.refunded { background: #f1f5f9; color: #475569; }

.room-name-cell {
  display: block;
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

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

/* Commission rate edit styles */
.commission-cell {
  display: inline-block;
  min-width: 120px;
}

.commission-display {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  border: 1px solid transparent;
  transition: all 0.2s ease;
}

.commission-display:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
}

.commission-val {
  font-weight: 700;
  color: #0f172a;
}

.commission-val.is-default {
  font-weight: 500;
  color: #64748b;
  font-style: italic;
}

.btn-icon-edit {
  background: none;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  display: flex;
  align-items: center;
  padding: 0.15rem;
  border-radius: 4px;
  transition: all 0.2s;
}

.commission-display:hover .btn-icon-edit {
  color: #1a6cf7;
}

.btn-text-reset {
  font-size: 0.72rem;
  color: #64748b;
  background: none;
  border: none;
  text-decoration: underline;
  cursor: pointer;
  padding: 0;
  margin-left: 0.25rem;
  font-weight: 600;
}

.btn-text-reset:hover {
  color: #ef4444;
}

.commission-edit-form {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  background: white;
  padding: 0.15rem;
  border-radius: 8px;
}

.commission-inline-input {
  width: 60px;
  padding: 0.25rem 0.4rem;
  border: 1.5px solid #1a6cf7 !important;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 700;
  text-align: center;
  background: white;
  outline: none;
  font-family: 'Inter', sans-serif;
}

.pct-sign {
  font-size: 0.8rem;
  font-weight: 700;
  color: #475569;
}

.btn-save-inline {
  background: #ecfdf5;
  border: 1px solid #10b981;
  color: #059669;
  width: 24px;
  height: 24px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-save-inline:hover {
  background: #d1fae5;
  color: #047857;
}

.btn-cancel-inline {
  background: #fef2f2;
  border: 1px solid #fca5a5;
  color: #ef4444;
  width: 24px;
  height: 24px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-cancel-inline:hover {
  background: #fee2e2;
  color: #b91c1c;
}

/* BOOKING DETAIL CUSTOM MODAL */
.clickable-row {
  cursor: pointer;
  transition: background-color 0.2s ease;
}
.clickable-row:hover {
  background-color: #f8fafc !important;
}

.booking-detail-modal {
  max-width: 650px;
}

.booking-detail-body {
  padding: 1.5rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.section-title {
  font-size: 0.85rem;
  font-weight: 800;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.75rem;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

.detail-grid.cols-2 {
  grid-template-columns: repeat(2, 1fr);
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.detail-item .label {
  font-size: 0.75rem;
  font-weight: 500;
  color: #94a3b8;
}

.detail-item .value {
  font-size: 0.9rem;
  font-weight: 700;
  color: #1e293b;
}

.detail-divider {
  height: 1px;
  background-color: #f1f5f9;
  margin: 0.25rem 0;
}

.room-host-card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 1rem;
}

.room-brief {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.detail-room-img {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  object-fit: cover;
  background-color: #e2e8f0;
}

.room-desc {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.room-name {
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
}

.room-addr {
  font-size: 0.8rem;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.host-info-box {
  background: white;
  border: 1px dashed #cbd5e1;
  border-radius: 10px;
  padding: 0.75rem 1rem;
}

.host-tag {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 800;
  color: #7c3aed;
  background: #f5f3ff;
  padding: 0.15rem 0.45rem;
  border-radius: 4px;
  text-transform: uppercase;
  margin-bottom: 0.35rem;
}

.host-name {
  font-size: 0.875rem;
  color: #0f172a;
}

.host-contact {
  font-size: 0.8rem;
  color: #64748b;
  margin-top: 0.1rem;
}

.info-group-box {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.info-group-box h5 {
  font-size: 0.75rem;
  font-weight: 800;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  margin-bottom: 0.25rem;
}

.info-group-box p {
  font-size: 0.9rem;
  color: #1e293b;
}

.info-group-box .contact-sub {
  font-size: 0.8rem;
  color: #64748b;
}

.price-breakdown {
  background: #f8fafc;
  border-radius: 12px;
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.price-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.85rem;
  color: #475569;
  font-weight: 600;
}

.price-row.promo {
  color: #ef4444;
}

.price-row.total {
  border-top: 1px solid #e2e8f0;
  padding-top: 0.5rem;
  margin-top: 0.25rem;
  font-size: 1rem;
  font-weight: 800;
  color: #0f172a;
}

.final-price {
  color: #1a6cf7;
  font-size: 1.15rem;
}

.booking-note-text {
  font-size: 0.85rem;
  color: #475569;
  background: #fffbeb;
  border-left: 3px solid #f59e0b;
  padding: 0.5rem 0.75rem;
  border-radius: 0 8px 8px 0;
  font-style: italic;
}

.booking-detail-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid #e2e8f0;
  display: flex;
  justify-content: flex-end;
  background: #f8fafc;
}

.btn-table-view {
  background: #f8fafc;
  border: 1px solid #dde1e9;
  color: #475569;
  padding: 0.35rem 0.75rem;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 700;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  transition: all 0.2s;
}

.btn-table-view:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
  color: #1a6cf7;
}

/* ROOM DETAIL DRAWER STYLES */
.drawer-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(15, 23, 42, 0.45);
  backdrop-filter: blur(4px);
  z-index: 1000;
  display: flex;
  justify-content: flex-end;
}

.room-drawer {
  width: 580px;
  max-width: 100%;
  height: 100%;
  background: white;
  box-shadow: -10px 0 25px rgba(0,0,0,0.15);
  display: flex;
  flex-direction: column;
  animation: slide-in 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

@keyframes slide-in {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.drawer-header {
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #f8fafc;
}

.drawer-header h2 {
  font-size: 1.15rem;
  font-weight: 800;
  color: #0f172a;
}

.btn-close-drawer {
  background: none;
  border: none;
  font-size: 1.5rem;
  font-weight: 500;
  color: #64748b;
  cursor: pointer;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background 0.15s, color 0.15s;
}

.btn-close-drawer:hover {
  background: #e2e8f0;
  color: #0f172a;
}

.drawer-body {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.drawer-body::-webkit-scrollbar {
  width: 5px;
}
.drawer-body::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 4px;
}

.drawer-section {
  padding-bottom: 1.25rem;
  border-bottom: 1px solid #f1f5f9;
}

.drawer-section:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.section-title {
  font-size: 0.95rem;
  font-weight: 800;
  color: #0f172a;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.75rem;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* Image gallery */
.drawer-image-gallery {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.drawer-gallery-img {
  width: 100%;
  height: 100px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.drawer-gallery-img:first-child {
  grid-column: span 3;
  height: 180px;
}

.drawer-gallery-img:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 10px rgba(0,0,0,0.08);
}

/* Info grid */
.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
  background: #f8fafc;
  padding: 12px 16px;
  border-radius: 12px;
  border: 1px solid #f1f5f9;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.info-item.full-width {
  grid-column: span 2;
}

.info-item .label {
  font-size: 11px;
  font-weight: 600;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.2px;
}

.info-item .value {
  font-size: 13.5px;
  color: #1e293b;
}

.desc-text {
  font-size: 13.5px;
  line-height: 1.6;
  color: #475569;
  white-space: pre-wrap;
}

/* Amenities tags */
.amenities-container {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.amenity-pill {
  background: #f1f5f9;
  color: #334155;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12.5px;
  font-weight: 600;
  border: 1px solid #e2e8f0;
}

/* Host Card */
.host-info-card {
  display: flex;
  align-items: center;
  gap: 12px;
  background: #f8fafc;
  border: 1px solid #f1f5f9;
  padding: 12px 16px;
  border-radius: 12px;
}

.host-avatar-placeholder {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, #a855f7 0%, #d8b4fe 100%);
  color: white;
  font-weight: 700;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.host-details {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.host-details .host-name {
  font-size: 14px;
  font-weight: 700;
  color: #0f172a;
}

.host-details .host-contact {
  font-size: 12.5px;
  color: #475569;
}

/* Stats */
.stats-mini-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.stat-mini-card {
  background: #f8fafc;
  border: 1px solid #f1f5f9;
  padding: 12px 16px;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-mini-card .stat-label {
  font-size: 11.5px;
  font-weight: 600;
  color: #64748b;
}

.stat-mini-card .stat-val {
  font-size: 16px;
  font-weight: 800;
}

/* Mini Table */
.mini-table-wrap {
  width: 100%;
  overflow-x: auto;
  border: 1px solid #e2e8f0;
  border-radius: 10px;
}

.mini-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
  font-size: 12.5px;
}

.mini-table th, .mini-table td {
  padding: 10px 12px;
  border-bottom: 1px solid #f1f5f9;
  white-space: nowrap;
}

.mini-table th {
  background: #f8fafc;
  font-weight: 700;
  color: #475569;
}

.mini-table tr:last-child td {
  border-bottom: none;
}

.customer-cell {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.cust-email {
  font-size: 11px;
  color: #64748b;
}

.date-cell {
  display: flex;
  flex-direction: column;
  gap: 2px;
  font-size: 11px;
  color: #334155;
}

.date-cell .arrow-down {
  color: #94a3b8;
  font-weight: bold;
}

.status-badge-sm {
  padding: 3px 6px;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 700;
}

.status-badge-sm.completed {
  background: #ecfdf5;
  color: #10b981;
}

.status-badge-sm.confirmed {
  background: #eff6ff;
  color: #3b82f6;
}

.status-badge-sm.pending {
  background: #fffbeb;
  color: #f59e0b;
}

.status-badge-sm.cancelled {
  background: #fef2f2;
  color: #ef4444;
}

/* Reviews in Drawer */
.drawer-reviews-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.drawer-review-card {
  background: #f8fafc;
  border: 1px solid #f1f5f9;
  padding: 12px;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.reviewer-name {
  font-size: 13px;
  color: #1e293b;
}

.reviewer-stars {
  display: flex;
  gap: 2px;
}

.review-comment {
  font-size: 13px;
  line-height: 1.5;
  color: #475569;
}

.review-date {
  font-size: 10.5px;
  color: #94a3b8;
  align-self: flex-end;
}

/* Transitions */
.drawer-slide-enter-active, .drawer-slide-leave-active {
  transition: opacity 0.3s;
}

.drawer-slide-enter-active .room-drawer, .drawer-slide-leave-active .room-drawer {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.drawer-slide-enter-from {
  opacity: 0;
}

.drawer-slide-enter-from .room-drawer {
  transform: translateX(100%);
}

.drawer-slide-leave-to {
  opacity: 0;
}

.drawer-slide-leave-to .room-drawer {
  transform: translateX(100%);
}

.status-badge-sm.approved {
  background: #ecfdf5;
  color: #10b981;
}

.status-badge-sm.rejected {
  background: #fef2f2;
  color: #ef4444;
}
</style>