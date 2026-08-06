<template>
  <div class="min-h-screen" style="background:#f8f7f9">

    <!-- HEADER -->
    <header class="header" :class="{ scrolled: isScrolled }">
      <div class="container header-container" :class="{ 'compact-mode': isSearchCompact }">
        <template v-if="!isSearchCompact">
          <div class="header-left">
            <h1 style="margin: 0; font-size: inherit; font-weight: inherit; line-height: 1;">
              <RouterLink to="/" class="logo" @click="handleLogoClick">
                <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
                  <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <span class="logo-word building">Building</span>
                <span class="logo-word hotel">Hotel</span>
                <span class="logo-word stay">Stay</span>
              </RouterLink>
            </h1>
            <nav class="desktop-nav">
              <a
                v-for="cat in categories.slice(0, 2)"
                :key="cat.id"
                href="#"
                class="nav-cat-link"
                :class="{ active: (cat.id === 'hotels' && !onlyApartments) || (cat.id === 'apartments' && onlyApartments) }"
                @click.prevent="selectCategory(cat.id)"
              >
                <component :is="cat.icon" :size="18" /> {{ $t(`search.${cat.id}`) }}
              </a>
            </nav>
          </div>
          <div class="header-right">
            <!-- Language Selector in header -->
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

            <template v-if="authStore.isLoggedIn">
              <span class="welcome-text" @click="openProfileModal" style="cursor: pointer; text-decoration: underline; text-underline-offset: 3px; display: inline-flex; align-items: center; gap: 4px; margin-right: 8px;">
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                  <circle cx="12" cy="7" r="4" />
                </svg>
                {{ authStore.user?.fullName || '' }}
              </span>
              <RouterLink v-if="authStore.role === 'HOST'" to="/host/rooms" class="nav-link-btn">{{ $t('nav.manage_rooms') }}</RouterLink>
              <RouterLink v-if="authStore.role === 'ADMIN'" to="/admin" class="nav-link-btn">{{ $t('nav.admin') }}</RouterLink>
              <RouterLink v-if="authStore.role === 'CUSTOMER'" to="/bookings" class="nav-link-btn">{{ $t('nav.my_bookings') }}</RouterLink>
              <button class="btn-outline" @click="handleLogout">{{ $t('nav.logout') }}</button>
            </template>
            <template v-else>
              <RouterLink to="/host/register" class="nav-link-btn" style="margin-right: 8px;">{{ $t('nav.become_host') }}</RouterLink>
              <button class="btn-outline" @click="authInitialTab = 'login'; showAuth = true">{{ $t('nav.login') }}</button>
              <button class="btn-filled" @click="authInitialTab = 'register'; showAuth = true">{{ $t('nav.register') }}</button>
            </template>
            <button class="mobile-menu-btn" @click="mobileMenuOpen = true">
              <Menu :size="24" />
            </button>
          </div>
        </template>
        
        <!-- Compact Search bar when scrolled (Agoda style) -->
        <template v-else>
          <div class="compact-search-bar">
            <!-- Destination field -->
            <div 
              class="compact-field dest-field" 
              style="position: relative; display: flex; align-items: center;"
            >
              <Search :size="16" class="compact-ico" />
              <input 
                v-model="search.city" 
                type="text" 
                :placeholder="$t('search.placeholder')" 
                style="border: none; outline: none; background: transparent; font-size: 13.5px; font-weight: 600; color: #334155; width: 100%; height: 100%; padding: 0 4px 0 0;"
              />
            </div>
            
            <!-- Dates range field -->
            <div class="compact-field dates-field">
              <Calendar :size="16" class="compact-ico" />
              <div class="compact-date-inputs">
                <input v-model="search.checkIn" type="date" :title="$t('search.check_in')" />
                <span class="compact-arrow">→</span>
                <input v-model="search.checkOut" type="date" :title="$t('search.check_out')" />
              </div>
            </div>
            
            <!-- Guest & Room field -->
            <div 
              class="compact-field guest-field" 
              ref="compactGuestSelectRef"
              @click.stop="compactGuestDropdownOpen = !compactGuestDropdownOpen"
            >
              <Users :size="16" class="compact-ico" />
              <span class="compact-guest-txt">{{ guestSummary }}</span>
              <ChevronDown :size="14" class="compact-chevron" :class="{ open: compactGuestDropdownOpen }" />
              
              <!-- Compact Dropdown -->
              <div v-if="compactGuestDropdownOpen" class="compact-guest-dropdown" @click.stop>
                <!-- Phòng -->
                <div class="guest-row">
                  <div class="guest-row-label">
                    <span class="guest-row-title">{{ $t('search.room_label') }}</span>
                  </div>
                  <div class="guest-row-counter">
                    <button class="counter-btn" :disabled="search.rooms <= 1" @click="adjustGuest('rooms', -1)">-</button>
                    <span class="counter-num">{{ search.rooms }}</span>
                    <button class="counter-btn" @click="adjustGuest('rooms', 1)">+</button>
                  </div>
                </div>
                <!-- Người lớn -->
                <div class="guest-row">
                  <div class="guest-row-label">
                    <span class="guest-row-title">{{ $t('search.adults_label') }}</span>
                  </div>
                  <div class="guest-row-counter">
                    <button class="counter-btn" :disabled="search.guests <= 1" @click="adjustGuest('guests', -1)">-</button>
                    <span class="counter-num">{{ search.guests }}</span>
                    <button class="counter-btn" @click="adjustGuest('guests', 1)">+</button>
                  </div>
                </div>
                <!-- Trẻ em -->
                <div class="guest-row">
                  <div class="guest-row-label">
                    <span class="guest-row-title">{{ $t('search.children_label') }}</span>
                  </div>
                  <div class="guest-row-counter">
                    <button class="counter-btn" :disabled="search.children <= 0" @click="adjustGuest('children', -1)">-</button>
                    <span class="counter-num">{{ search.children }}</span>
                    <button class="counter-btn" @click="adjustGuest('children', 1)">+</button>
                  </div>
                </div>
                <button class="guest-done-btn" @click="compactGuestDropdownOpen = false">{{ $t('search.done') }}</button>
              </div>
            </div>
            
            <!-- Search Action button -->
            <button class="btn-compact-search" @click="handleSearch" :disabled="loading">
              <span v-if="!loading">{{ $t('search.btn') }}</span>
              <span v-else class="spinner-small"></span>
            </button>
          </div>
        </template>
      </div>
    </header>

    <!-- MOBILE MENU -->
    <div class="mobile-menu" :class="{ open: mobileMenuOpen }">
      <div class="mobile-menu-header">
        <h2 style="margin: 0; font-size: inherit; font-weight: inherit; line-height: 1;">
          <RouterLink to="/" class="logo" @click="mobileMenuOpen = false; handleLogoClick()">
            <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
              <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="logo-word building">Building</span>
            <span class="logo-word hotel">Hotel</span>
            <span class="logo-word stay">Stay</span>
          </RouterLink>
        </h2>
        <button @click="mobileMenuOpen = false"><X :size="24" /></button>
      </div>
      <nav class="mobile-nav">
        <a
          v-for="cat in categories"
          :key="cat.id"
          href="#"
          class="mobile-nav-item"
          :class="{ active: (cat.id === 'hotels' && !onlyApartments) || (cat.id === 'apartments' && onlyApartments) }"
          @click.prevent="selectCategory(cat.id); mobileMenuOpen = false"
        >
          <span class="mobile-nav-icon"><component :is="cat.icon" :size="20" /></span>
          {{ $t(`search.${cat.id}`) }}
        </a>
        <div class="mobile-divider"></div>
        <template v-if="authStore.isLoggedIn">
          <div class="mobile-welcome-text" style="font-size: 0.95rem; font-weight: 700; color: #1e293b; margin-bottom: 12px; text-align: center;">
            {{ $t('auth.login_success_toast_title', { name: authStore.user?.fullName || '' }) }}
          </div>
          <RouterLink v-if="authStore.role === 'HOST'" to="/host/rooms" class="mobile-btn-filled" style="margin-bottom: 8px;" @click="mobileMenuOpen = false">{{ $t('nav.manage_rooms') }}</RouterLink>
          <RouterLink v-if="authStore.role === 'ADMIN'" to="/admin" class="mobile-btn-filled" style="margin-bottom: 8px;" @click="mobileMenuOpen = false">{{ $t('nav.admin') }}</RouterLink>
          <RouterLink v-if="authStore.role === 'CUSTOMER'" to="/bookings" class="mobile-btn-filled" style="margin-bottom: 8px;" @click="mobileMenuOpen = false">{{ $t('nav.my_bookings') }}</RouterLink>
          <button class="mobile-btn-outline" @click="handleLogout(); mobileMenuOpen = false">{{ $t('nav.logout') }}</button>
        </template>
        <template v-else>
          <RouterLink to="/host/register" class="mobile-btn-outline" style="margin-bottom: 8px;" @click="mobileMenuOpen = false">{{ $t('nav.become_host') }}</RouterLink>
          <button class="mobile-btn-filled" style="margin-bottom: 8px;" @click="authInitialTab = 'login'; showAuth = true; mobileMenuOpen = false">{{ $t('nav.login') }}</button>
          <button class="mobile-btn-outline" @click="authInitialTab = 'register'; showAuth = true; mobileMenuOpen = false">{{ $t('nav.register') }}</button>
        </template>
      </nav>
    </div>
    <div class="mobile-overlay" v-if="mobileMenuOpen" @click="mobileMenuOpen = false"></div>

    <!-- HERO -->
    <section class="hero">
      <div class="hero-bg">
        <img :src="heroBg" alt="Hero" class="hero-img" />
        <div class="hero-overlay"></div>
      </div>
      <div class="container hero-content">
        <h2 class="hero-title">{{ $t('search.title') }}</h2>

        <!-- SEARCH CONTAINER WRAPPER -->
        <div class="search-container-wrapper">
          <!-- MAIN SEARCH CARD -->
          <div class="search-card">
            <!-- PILLS ROW -->
            <div class="search-pills">
              <button class="pill-btn" :class="{ active: searchType === 'overnight' }" @click="searchType = 'overnight'">
                {{ $t('search.overnight') }}
              </button>
              <button class="pill-btn" :class="{ active: searchType === 'dayuse' }" @click="searchType = 'dayuse'">
                {{ $t('search.dayuse') }}
              </button>
            </div>

            <!-- FIELDS GRID -->
            <div class="search-fields-grid">
              <!-- Destination Selector Dropdown -->
              <div 
                class="field-item full-width" 
                :class="{ focused: focus === 'city' }"
                style="position: relative; display: flex; align-items: center;"
              >
                <Search :size="20" class="field-ico" />
                <div class="field-input-wrap" style="flex: 1; display: flex; flex-direction: column;">
                  <span style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 2px;">{{ locale === 'en' ? 'Destination' : 'Địa điểm' }}</span>
                  <input
                      v-model="search.city"
                      type="text"
                      :placeholder="locale === 'en' ? 'Enter tourist destination or city...' : 'Nhập điểm du lịch hoặc thành phố...'"
                      @focus="focus = 'city'"
                      @blur="focus = ''"
                      style="border: none; outline: none; background: transparent; font-size: 14.5px; font-weight: 600; color: #1e293b; padding: 0; width: 100%;"
                  />
                </div>
              </div>

              <!-- Dates & Guests Row -->
              <div class="fields-subgrid">
                <!-- Check-in & Check-out -->
                <div class="field-item date-range-picker" :class="{ focused: focus === 'date' }">
                  <div class="date-box">
                    <Calendar :size="18" class="field-ico" />
                    <div class="date-info">
                      <label>{{ $t('search.check_in') }}</label>
                      <input v-model="search.checkIn" type="date" @focus="focus='date'" @blur="focus=''" />
                    </div>
                  </div>
                  <div class="date-divider">→</div>
                  <div class="date-box">
                    <Calendar :size="18" class="field-ico" />
                    <div class="date-info">
                      <label>{{ $t('search.check_out') }}</label>
                      <input v-model="search.checkOut" type="date" @focus="focus='date'" @blur="focus=''" />
                    </div>
                  </div>
                </div>

                <!-- Guests & Rooms -->
                <div
                  class="field-item guest-select"
                  :class="{ focused: guestDropdownOpen }"
                  style="position: relative;"
                  ref="guestSelectRef"
                >
                  <Users :size="20" class="field-ico" />
                  <div class="guest-info" @click="guestDropdownOpen = !guestDropdownOpen" style="cursor:pointer; flex:1;">
                    <label style="cursor:pointer;">{{ $t('search.guests_rooms') }}</label>
                    <div class="guest-display">
                      <span class="guest-text">{{ guestSummary }}</span>
                      <ChevronDown :size="16" class="guest-chevron" :class="{ open: guestDropdownOpen }" />
                    </div>
                  </div>

                  <!-- DROPDOWN PANEL -->
                  <Transition name="guest-drop">
                    <div v-if="guestDropdownOpen" class="guest-dropdown-panel">
                      <!-- Phòng -->
                      <div class="guest-row">
                        <div class="guest-row-label">
                          <span class="guest-row-title">{{ $t('search.room_label') }}</span>
                        </div>
                        <div class="guest-row-counter">
                          <button type="button" class="counter-btn" @click.stop="adjustGuest('rooms', -1)" :disabled="search.rooms <= 1">
                            <Minus :size="14" />
                          </button>
                          <span class="counter-num">{{ search.rooms }}</span>
                          <button type="button" class="counter-btn" @click.stop="adjustGuest('rooms', 1)">
                            <Plus :size="14" />
                          </button>
                        </div>
                      </div>

                      <!-- Người lớn -->
                      <div class="guest-row">
                        <div class="guest-row-label">
                          <span class="guest-row-title">{{ $t('search.adults_label') }}</span>
                          <span class="guest-row-sub">{{ $t('search.adults_sub') }}</span>
                        </div>
                        <div class="guest-row-counter">
                          <button type="button" class="counter-btn" @click.stop="adjustGuest('guests', -1)" :disabled="search.guests <= 1">
                            <Minus :size="14" />
                          </button>
                          <span class="counter-num">{{ search.guests }}</span>
                          <button type="button" class="counter-btn" @click.stop="adjustGuest('guests', 1)">
                            <Plus :size="14" />
                          </button>
                        </div>
                      </div>

                      <!-- Trẻ em -->
                      <div class="guest-row">
                        <div class="guest-row-label">
                          <span class="guest-row-title">{{ $t('search.children_label') }}</span>
                          <span class="guest-row-sub">{{ $t('search.children_sub') }}</span>
                        </div>
                        <div class="guest-row-counter">
                          <button type="button" class="counter-btn" @click.stop="adjustGuest('children', -1)" :disabled="search.children <= 0">
                            <Minus :size="14" />
                          </button>
                          <span class="counter-num">{{ search.children }}</span>
                          <button type="button" class="counter-btn" @click.stop="adjustGuest('children', 1)">
                            <Plus :size="14" />
                          </button>
                        </div>
                      </div>

                      <button type="button" class="guest-done-btn" @click.stop="guestDropdownOpen = false">{{ $t('search.done') }}</button>
                    </div>
                  </Transition>
                </div>
              </div>
            </div>

            <!-- OPTIONS ROW -->
            <div class="search-options-row">
              <label class="checkbox-container">
                <input type="checkbox" v-model="onlyApartments" />
                <span class="checkmark"></span>
                {{ $t('search.only_apartments') }}
              </label>
            </div>

            <!-- SEARCH BUTTON -->
            <div class="search-btn-container">
              <button class="btn-search-large" @click="handleSearch" :disabled="loading">
                <span v-if="!loading">{{ $t('search.btn') }}</span>
                <span v-else class="spinner-small"></span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- FAB -->
    <button v-if="isScrolled" class="fab" @click="scrollToTop">
      <ArrowUp :size="20" />
    </button>

    <!-- TOP DESTINATIONS -->
    <section class="section container" style="padding-bottom: 1.5rem;">
      <div class="section-header-simple">
        <h2 class="section-title">{{ $t('home.top_destinations') }}</h2>
      </div>
      <div class="dest-scroll-wrap">
        <!-- Floating navigation buttons -->
        <button class="dest-float-btn prev" @click="scrollDest(-1)" aria-label="Trước">
          <ChevronLeft :size="20" />
        </button>
        <button class="dest-float-btn next" @click="scrollDest(1)" aria-label="Tiếp">
          <ChevronRight :size="20" />
        </button>

        <div class="dest-track" ref="destTrackRef">
          <div
            v-for="dest in destinations"
            :key="dest.id"
            class="dest-card"
            @click="quickSearch(dest.city)"
          >
            <div class="dest-img-wrap">
              <img :src="dest.image" :alt="dest.city" class="dest-img" referrerpolicy="no-referrer" />
            </div>
            <div class="dest-text-content">
              <p class="dest-name">{{ dest.city }}</p>
              <p class="dest-count">{{ $t('home.properties_count', { count: dest.properties.toLocaleString() }) }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CHƯƠNG TRÌNH KHUYẾN MÃI CHỖ Ở (Agoda Style) -->
    <section class="container" v-if="availablePromos.length > 0" style="margin-top: 0.5rem; margin-bottom: 3.5rem;">
      <div class="section-header-simple promo-header-flex" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1.25rem;">
        <div>
          <h2 class="section-title" style="margin-bottom: 0.25rem;">{{ $t('home.promos') }}</h2>
          <p class="section-sub" style="color: #64748b; font-size: 0.9rem;">{{ $t('home.promo_sub') }}</p>
        </div>
        <RouterLink to="/deals" class="view-all-promos" style="color: var(--blue); text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 0.25rem; font-size: 0.9rem;">{{ $t('home.view_all') }} <ChevronRight :size="16" /></RouterLink>
      </div>
      
      <div class="promo-scroll-wrap" style="position: relative;">
        <!-- Floating navigation buttons -->
        <button class="promo-float-btn prev" @click="scrollPromo(-1)" aria-label="Trước">
          <ChevronLeft :size="20" />
        </button>
        <button class="promo-float-btn next" @click="scrollPromo(1)" aria-label="Tiếp">
          <ChevronRight :size="20" />
        </button>

        <div class="promo-track" ref="promoTrackRef">
          <!-- Banner Tĩnh: Nhận mọi ưu đãi -->
          <div class="promo-banner-card first-promo-card">
            <div class="pbc-glow"></div>
            <!-- Floating deco shapes -->
            <div class="pbc-float-shape percent-1">%</div>
            <div class="pbc-float-shape percent-2">%</div>
            <div class="pbc-float-shape ticket-1">🏷️</div>
            <div class="pbc-float-shape ticket-2">🏷️</div>
            
            <div class="pbc-content">
              <span class="pbc-tag">{{ $t('home.get_now') }}</span>
              <h3>{{ $t('home.claim_title') }}</h3>
              <p>{{ $t('home.claim_desc') }}</p>
              
              <div class="pbc-cursor-arrow">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="#ffffff" stroke="#6c2bc4" stroke-width="1.5">
                  <path d="M4 4l11.733 11.733-3.733 1.067 5.067 5.067-2.133 2.133-5.067-5.067-1.067 3.733z" />
                </svg>
              </div>
            </div>
          </div>

          <!-- Danh sách các voucher khả dụng -->
          <div
            v-for="(promo, index) in availablePromos"
            :key="promo.id || promo.code"
            class="promo-banner-card dynamic-promo-card"
            :style="getPromoCardStyle(promo, index)"
          >
            <!-- Top Logo Overlay -->
            <div class="pbc-logo-overlay">
              <div class="pbc-mini-logo">
                <Hotel :size="10" color="#ffffff" />
              </div>
              <span class="pbc-top-tag">{{ getPromoTopTag(index) }}</span>
            </div>

            <!-- Content Area -->
            <div class="pbc-card-body">
              <div class="pbc-text-section">
                <p class="pbc-subtitle">{{ getPromoSubtitle(index) }}</p>
                <h3 class="pbc-title-large">
                  {{ promo.discountType === 'PERCENT' ? `Giảm giá tới ${promo.discountValue}%` : `Giảm tới ${formatPriceShort(promo.discountValue)}` }}
                </h3>
                <p class="pbc-desc-text">{{ promo.description }}</p>
              </div>

              <!-- Bottom Row: Voucher Code & Claim Button -->
              <div class="pbc-bottom-row">
                <div class="pbc-info-pill">
                  <span class="pbc-code-tag">Mã: {{ promo.code }}</span>
                  <span class="pbc-min-order-tag">{{ $t('home.min_order', { amount: formatPrice(promo.minOrderAmount || 0) }) }}</span>
                </div>
                
                <button
                  v-if="isClaimed(promo.code)"
                  class="btn-promo-claim-new claimed"
                  disabled
                >
                  {{ $t('home.claimed') }}
                </button>
                <button
                  v-else
                  class="btn-promo-claim-new"
                  @click="claimVoucher(promo.code)"
                >
                  {{ $t('home.claim') }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- NHỮNG CHỖ NGHỈ NỔI BẬT (Agoda Style) -->
    <section class="container" v-if="!searched" style="margin-top: 1rem; margin-bottom: 3.5rem;">
      <div class="section-header-flex featured-header" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 0.5rem;">
        <div>
          <h2 class="section-title" style="margin-bottom: 0.75rem; font-size: 1.5rem; font-weight: 700; color: #0f172a;">{{ $t('home.featured') }}</h2>
          <div class="featured-tabs" style="display: flex; gap: 1.5rem;">
            <button 
              v-for="city in featuredCities" 
              :key="city" 
              class="featured-tab-btn" 
              :class="{ active: activeFeaturedCity === city }"
              @click="activeFeaturedCity = city"
            >
              {{ city }}
            </button>
          </div>
        </div>
        <button @click="quickSearch(activeFeaturedCity)" class="view-more-featured-link">
          {{ $t('home.view_more_featured', { city: activeFeaturedCity }) }}
          <ChevronRight :size="16" />
        </button>
      </div>

      <div class="featured-grid">
        <div 
          v-for="room in filteredFeaturedRooms" 
          :key="room.id" 
          class="featured-room-card"
          @click="goToDetail(room.id)"
        >
          <div class="frc-img-wrap">
            <img v-if="room.imageUrls?.length" :src="room.imageUrls[0]" class="frc-img" alt="room" />
            <div v-else class="frc-no-img"><Building2 :size="40" color="#94a3b8" /></div>
            <div class="frc-score-badge">
              {{ getScoreBadge(room.avgRating) }}
            </div>
          </div>
          <div class="frc-info">
            <h3 class="frc-name">{{ room.name }}</h3>
            
            <!-- Stars rating & Location link -->
            <div class="frc-stars-row">
              <div class="frc-stars">
                <Star v-for="i in 5" :key="i" :size="12" :fill="i <= Math.round(room.avgRating || 4.5) ? '#ffb703' : 'none'" :color="i <= Math.round(room.avgRating || 4.5) ? '#ffb703' : '#cbd5e1'" />
              </div>
              <span class="frc-location-text">
                <MapPin :size="12" style="margin-right: 0.2rem; flex-shrink: 0;" /> {{ room.city }}
              </span>
            </div>

            <p class="frc-price-label">{{ $t('home.price_per_night_note') }}</p>
            <p class="frc-price-val">{{ formatPriceVND(room.pricePerNight) }}</p>
          </div>
        </div>
      </div>
    </section>



    <!-- KẾT QUẢ TÌM KIẾM -->
    <section class="section container" v-if="searched" id="search-results-section">
      <div class="search-results-header" style="margin-bottom: 1.5rem;">
        <h2 class="section-title">
          {{ filteredRooms.length > 0 ? $t('filter.found_rooms', { count: filteredRooms.length }) : $t('filter.no_rooms') }}
        </h2>
        <p class="section-sub">{{ $t('filter.sub') }}</p>
      </div>

      <!-- FILTER PANEL -->
      <div class="filter-panel" v-if="rooms.length > 0">
        <div class="filter-group">
          <label>{{ locale === 'en' ? 'Location' : 'Địa điểm' }}</label>
          <select v-model="filterCity">
            <option value="all">{{ locale === 'en' ? 'All locations' : 'Tất cả địa điểm' }}</option>
            <option v-for="city in availableCities" :key="city" :value="city">{{ city }}</option>
          </select>
        </div>
        <div class="filter-group">
          <label>{{ $t('filter.price') }}</label>
          <select v-model="filterPrice">
            <option value="all">{{ $t('filter.price_all') }}</option>
            <option value="under1m">{{ $t('filter.price_under_1m') }}</option>
            <option value="1to2m">{{ $t('filter.price_1to2m') }}</option>
            <option value="over2m">{{ $t('filter.price_over_2m') }}</option>
          </select>
        </div>
        <div class="filter-group">
          <label>{{ $t('filter.rating') }}</label>
          <select v-model.number="filterRating">
            <option :value="0">{{ $t('filter.rating_all') }}</option>
            <option :value="4.5">{{ $t('filter.rating_and_up', { rating: '4.5' }) }}</option>
            <option :value="4.7">{{ $t('filter.rating_and_up', { rating: '4.7' }) }}</option>
            <option :value="4.9">{{ $t('filter.rating_and_up', { rating: '4.9' }) }}</option>
          </select>
        </div>
        <div class="filter-group">
          <label>{{ $t('filter.type') }}</label>
          <select v-model="filterType">
            <option value="all">{{ $t('filter.type_all') }}</option>
            <option value="Deluxe">Deluxe</option>
            <option value="Studio">Studio</option>
            <option value="Suite">Suite</option>
            <option value="Villa">Biệt thự / Villa</option>
            <option value="Bungalow">Bungalow</option>
          </select>
        </div>
        <div class="filter-group">
          <label>{{ $t('filter.sort') }}</label>
          <select v-model="sortBy">
            <option value="default">{{ $t('filter.sort_default') }}</option>
            <option value="priceAsc">{{ $t('filter.sort_price_asc') }}</option>
            <option value="priceDesc">{{ $t('filter.sort_price_desc') }}</option>
            <option value="ratingDesc">{{ $t('filter.sort_rating_desc') }}</option>
          </select>
        </div>
        <button class="btn-clear-filter" @click="clearFilters">{{ $t('filter.clear') }}</button>
      </div>

      <div class="room-grid" v-if="paginatedRooms.length > 0">
        <div class="room-card" v-for="room in paginatedRooms" :key="room.id" @click="goToDetail(room.id)" style="display: flex; flex-direction: column;">
          <div class="room-img-wrap">
            <img v-if="room.imageUrls?.length" :src="room.imageUrls[0]" class="room-img" alt="room" />
            <div v-else class="room-no-img"><Building2 :size="48" color="#94a3b8" /></div>
            <div class="room-badge">{{ room.roomTypeName }}</div>
          </div>
          <div class="room-info" style="display: flex; flex-direction: column; justify-content: space-between; flex: 1; padding: 16px;">
            <div>
              <h3 style="margin-top: 0; font-size: 15px; font-weight: 700; color: #0f172a; margin-bottom: 6px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; line-height: 1.4; min-height: 42px;">{{ room.name }}</h3>
              <p class="room-city" style="margin-bottom: 4px; font-size: 13px; color: #64748b; display: flex; align-items: center; gap: 4px;"><MapPin :size="13" /> {{ room.city }}</p>
              <p class="room-addr" style="font-size: 12px; color: #94a3b8; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; margin-bottom: 12px;">{{ room.address }}</p>
            </div>
            
            <div>
              <div style="margin-bottom: 10px; text-align: left;">
                <span style="font-size: 12px; color: #64748b; font-weight: 500; display: block; margin-bottom: 2px;">{{ locale === 'vi' ? 'Giá mỗi đêm' : 'Price per night' }}</span>
                <strong style="font-size: 15.5px; color: #2563eb; font-weight: 800;">{{ formatPrice(room.pricePerNight) }}</strong>
              </div>
              
              <div class="room-footer" style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f1f5f9; padding-top: 10px; width: 100%;">
                <span class="room-rating" v-if="room.avgRating" style="display: inline-flex; align-items: center; gap: 4px; font-weight: 700; color: #1e293b; font-size: 13px;">
                  <Star :size="13" fill="#ffb703" color="#ffb703" /> {{ room.avgRating?.toFixed(1) }}
                </span>
                <span class="room-rating-none" v-else style="color: #94a3b8; font-size: 12px; font-weight: 500;">
                  {{ locale === 'vi' ? 'Chưa có đánh giá' : 'No reviews' }}
                </span>
                <button 
                  class="btn-view-detail" 
                  @click.stop="goToDetail(room.id)" 
                  style="padding: 6px 14px; background: #3b82f6; color: white; border: none; border-radius: 6px; font-weight: 700; font-size: 12.5px; cursor: pointer; transition: all 0.2s;"
                >
                  {{ locale === 'vi' ? 'Xem thông tin' : 'Details' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- PAGINATION -->
      <div class="pagination-bar" v-if="searchTotalPages > 1">
        <button class="pg-btn" :disabled="searchPage === 1" @click="searchPage = 1" title="Trang đầu">«</button>
        <button class="pg-btn" :disabled="searchPage === 1" @click="searchPage--" title="Trang trước">‹</button>

        <template v-for="p in searchPageNumbers" :key="p">
          <span v-if="p === '...'" class="pg-ellipsis">…</span>
          <button v-else class="pg-btn" :class="{ active: p === searchPage }" @click="searchPage = p">{{ p }}</button>
        </template>

        <button class="pg-btn" :disabled="searchPage === searchTotalPages" @click="searchPage++" title="Trang sau">›</button>
        <button class="pg-btn" :disabled="searchPage === searchTotalPages" @click="searchPage = searchTotalPages" title="Trang cuối">»</button>

        <span class="pg-info">Trang {{ searchPage }} / {{ searchTotalPages }} · {{ filteredRooms.length }} {{ $t('search.rooms') }}</span>
      </div>

      <div class="no-result" v-else-if="filteredRooms.length === 0">{{ $t('filter.no_result') }}</div>
    </section>

    <!-- FEATURED DEALS BANNER -->
    <section class="deals-section">
      <div class="container">
        <div class="deals-banner">
          <div class="deals-glow"></div>
          <div class="deals-left">
            <div class="deals-tag">
              <Tag :size="12" />
              {{ $t('home.exclusive_tag') }}
            </div>
            <h2>{{ $t('home.early_bird_title') }}</h2>
            <p>{{ $t('home.early_bird_desc') }}</p>
            <div class="deals-btns">
              <button 
                v-if="!authStore.isLoggedIn"
                class="deals-btn-white" 
                @click="showAuth = true"
              >
                <Smartphone :size="16" /> {{ $t('home.reg_now') }}
              </button>
              <button class="deals-btn-outline" @click="router.push('/deals')">{{ $t('home.learn_more') }}</button>
            </div>
          </div>
          <div class="deals-right">
            <div class="review-card">
              <div class="stars">
                <Star v-for="i in 5" :key="i" :size="13" fill="#ffb703" color="#ffb703" />
              </div>
              <p>"Giá tốt nhất tôi từng thấy cho khách sạn tại Sài Gòn. Thủ tục nhanh gọn!"</p>
              <small>- Minh Anh</small>
            </div>
            <div class="review-card offset">
              <div class="stars">
                <Star v-for="i in 5" :key="i" :size="13" fill="#ffb703" color="#ffb703" />
              </div>
              <p>"Nhân viên hỗ trợ rất nhiệt tình khi tôi cần đổi ngày đặt phòng."</p>
              <small>- Quốc Bảo</small>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
      <div class="container">
        <div class="footer-grid">
          <div class="footer-brand">
            <h1 style="margin: 0 0 1rem 0; font-size: inherit; font-weight: inherit; line-height: 1;">
              <RouterLink to="/" class="logo" @click="handleLogoClick">
                <svg class="logo-brand-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="18" height="18">
                  <path d="M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16M9 7h6M9 11h6M9 15h6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <span class="logo-word building">Building</span>
                <span class="logo-word hotel">Hotel</span>
                <span class="logo-word stay">Stay</span>
              </RouterLink>
            </h1>
            <p>{{ $t('footer.desc') }}</p>
            <div class="social-links">
              <a href="#"><Facebook :size="18" /></a>
              <a href="#"><Twitter :size="18" /></a>
              <a href="#"><Instagram :size="18" /></a>
              <a href="#"><Linkedin :size="18" /></a>
            </div>
          </div>
          <div class="footer-col">
            <h4>{{ $t('footer.help') }}</h4>
            <a href="#">{{ $t('footer.support_center') }}</a>
            <a href="#">{{ $t('footer.faqs') }}</a>
            <a href="#">{{ $t('footer.privacy') }}</a>
            <a href="#">{{ $t('footer.terms') }}</a>
          </div>
          <div class="footer-col">
            <h4>{{ $t('footer.about_us') }}</h4>
            <a href="#">{{ $t('footer.intro') }}</a>
            <a href="#">{{ $t('footer.careers') }}</a>
            <a href="#">{{ $t('footer.blog') }}</a>
            <a href="#">{{ $t('footer.press') }}</a>
          </div>
          <div class="footer-col">
            <h4>{{ $t('footer.destinations') }}</h4>
            <a href="#">Hà Nội</a>
            <a href="#">Đà Nẵng</a>
            <a href="#">Hồ Chí Minh</a>
            <a href="#">Phú Quốc</a>
          </div>
        </div>
        <div class="footer-bottom">
          <p>{{ $t('footer.all_rights') }}</p>
          <div class="footer-links">
            <a href="#">{{ $t('footer.rights_link') }}</a>
            <a href="#">{{ $t('footer.cookie_settings') }}</a>
            <a href="#">{{ $t('footer.sitemap') }}</a>
          </div>
        </div>
      </div>
    </footer>
  </div>

  <!-- AUTH MODAL -->
  <AuthModal v-model="showAuth" :initial-tab="authInitialTab" @login-success="onLogin" @register-success="onRegister" />

  <!-- QUICK VIEW ROOM DETAILS & REVIEWS MODAL -->
  <div class="modal-backdrop" v-if="showQuickViewModal" @click.self="showQuickViewModal = false">
    <div class="room-modal quick-view-modal" style="max-width: 700px; width: 90%;">
      <div class="modal-header">
        <h2>{{ selectedQuickViewRoom?.name }}</h2>
        <button class="btn-close" @click="showQuickViewModal = false">×</button>
      </div>
      <div class="modal-form quick-view-body" style="padding: 20px; max-height: 75vh; overflow-y: auto; text-align: left;">
        
        <!-- Image Gallery / Slider -->
        <div class="quick-gallery" style="margin-bottom: 20px; border-radius: 12px; overflow: hidden; display: flex; gap: 8px; max-height: 240px;">
          <div style="flex: 2; height: 240px;">
            <img :src="selectedQuickViewRoom?.imageUrls?.[0] || 'https://images.unsplash.com/photo-1611891487122-2075b96244e1?q=80&w=800&auto=format&fit=crop'" style="width: 100%; height: 100%; object-fit: cover;" />
          </div>
          <div style="flex: 1; display: flex; flex-direction: column; gap: 8px; height: 240px;">
            <img :src="selectedQuickViewRoom?.imageUrls?.[1] || 'https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=600&auto=format&fit=crop'" style="width: 100%; flex: 1; object-fit: cover;" />
            <img :src="selectedQuickViewRoom?.imageUrls?.[2] || 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600&auto=format&fit=crop'" style="width: 100%; flex: 1; object-fit: cover;" />
          </div>
        </div>

        <!-- Room Highlights -->
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e2e8f0; padding-bottom: 14px; margin-bottom: 16px; flex-wrap: wrap; gap: 12px;">
          <div>
            <p style="font-size: 13.5px; color: #64748b; font-weight: 600; margin-bottom: 4px;">{{ selectedQuickViewRoom?.roomTypeName }} · {{ selectedQuickViewRoom?.city }}</p>
            <h3 style="font-size: 16px; font-weight: 700; color: #1e293b; margin: 0;">{{ selectedQuickViewRoom?.address }}</h3>
          </div>
          <div style="display: flex; align-items: center; gap: 8px; background: #f1f5f9; padding: 6px 12px; border-radius: 8px;">
            <Star :size="16" fill="#ffb703" color="#ffb703" />
            <span style="font-weight: 700; color: #0f172a; font-size: 15px;">{{ selectedQuickViewRoom?.avgRating ? selectedQuickViewRoom.avgRating.toFixed(1) : 'N/A' }}</span>
            <span style="font-size: 13px; color: #64748b; font-weight: 500;">({{ selectedQuickViewRoom?.ratingCount || 0 }} {{ locale === 'vi' ? 'đánh giá' : 'reviews' }})</span>
          </div>
        </div>

        <!-- Room Description -->
        <div style="margin-bottom: 24px;">
          <h4 style="font-size: 15px; font-weight: 700; color: #0f172a; margin-bottom: 8px;">{{ locale === 'vi' ? 'Giới thiệu về chỗ nghỉ' : 'About this property' }}</h4>
          <p style="font-size: 14px; color: #475569; line-height: 1.6; margin: 0; white-space: pre-line;">{{ selectedQuickViewRoom?.description }}</p>
        </div>

        <!-- Amenities -->
        <div style="margin-bottom: 24px;" v-if="selectedQuickViewRoom?.amenities">
          <h4 style="font-size: 15px; font-weight: 700; color: #0f172a; margin-bottom: 8px;">{{ locale === 'vi' ? 'Tiện nghi có sẵn' : 'Amenities' }}</h4>
          <div style="display: flex; flex-wrap: wrap; gap: 10px;">
            <span 
              v-for="amenity in selectedQuickViewRoom.amenities.split(',')" 
              :key="amenity"
              style="padding: 6px 12px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 13px; font-weight: 600; color: #475569;"
            >
              {{ amenity.trim() }}
            </span>
          </div>
        </div>

        <!-- Reviews Section -->
        <div>
          <h4 style="font-size: 15px; font-weight: 700; color: #0f172a; margin-bottom: 12px;">{{ locale === 'vi' ? 'Đánh giá từ khách đi trước' : 'Guest Reviews' }}</h4>
          
          <div v-if="quickViewReviews.length > 0" style="display: flex; flex-direction: column; gap: 12px;">
            <div 
              v-for="rev in quickViewReviews" 
              :key="rev.id"
              style="background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 12px; padding: 14px;"
            >
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                <div style="display: flex; align-items: center; gap: 8px;">
                  <div style="width: 32px; height: 32px; background: #3b82f6; color: white; font-weight: 700; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px;">
                    {{ (rev.customerName || 'K').charAt(0).toUpperCase() }}
                  </div>
                  <div>
                    <h5 style="margin: 0; font-size: 13.5px; font-weight: 700; color: #1e293b;">{{ rev.customerName }}</h5>
                    <small style="color: #64748b; font-weight: 500;">{{ formatDate(rev.createdAt) }}</small>
                  </div>
                </div>
                <div style="display: inline-flex; align-items: center; gap: 4px; background: #fef3c7; padding: 4px 8px; border-radius: 6px; font-size: 12px; font-weight: 700; color: #b45309;">
                  <Star :size="12" fill="#b45309" color="#b45309" /> {{ rev.rating }}.0
                </div>
              </div>
              <p style="margin: 0; font-size: 13.5px; color: #475569; line-height: 1.5; font-style: italic;">"{{ rev.comment }}"</p>
            </div>
          </div>
          <div v-else style="background: #f8fafc; padding: 16px; border-radius: 12px; text-align: center; color: #94a3b8; font-size: 13.5px; font-weight: 600;">
            {{ locale === 'vi' ? 'Chưa có đánh giá nào cho chỗ nghỉ này.' : 'No reviews yet for this property.' }}
          </div>
        </div>

      </div>
      <div class="modal-footer" style="padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #e2e8f0; flex-wrap: wrap; gap: 12px;">
        <div>
          <span style="font-size: 13px; color: #64748b; font-weight: 600; display: block; margin-bottom: 2px;">{{ locale === 'vi' ? 'Giá phòng / đêm' : 'Price per night' }}</span>
          <strong style="font-size: 18px; color: #3b82f6; font-weight: 800;">{{ formatPrice(selectedQuickViewRoom?.pricePerNight || 0) }}</strong>
        </div>
        <div style="display: flex; gap: 10px;">
          <button class="btn-cancel" @click="showQuickViewModal = false" style="font-weight: 600;">{{ locale === 'vi' ? 'Đóng' : 'Close' }}</button>
          <button 
            class="btn-submit" 
            style="padding: 10px 20px; font-weight: 700; border-radius: 8px; background: #3b82f6; color: white; border: none; cursor: pointer; transition: all 0.2s;"
            @click="confirmBookingFromQuickView(selectedQuickViewRoom?.id)"
          >
            {{ locale === 'vi' ? 'Đặt phòng ngay' : 'Book Now' }}
          </button>
      </div>
    </div>
  </div>

  <!-- PROFILE SETTINGS MODAL -->
  <div class="modal-backdrop" v-if="showProfileModal" style="z-index: 1200; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; padding: 20px;">
    <div style="background: white; border-radius: 20px; max-width: 600px; width: 100%; max-height: 90vh; overflow-y: auto; padding: 28px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04); border: 1px solid #f1f5f9; display: flex; flex-direction: column; gap: 24px; position: relative; font-family: inherit;">
        <!-- Close button -->
        <button type="button" @click="showProfileModal = false" style="position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #94a3b8; font-weight: 300; transition: color 0.2s;" onmouseover="this.style.color='#0f172a'" onmouseout="this.style.color='#94a3b8'">×</button>
        
        <div>
          <h3 style="font-size: 1.25rem; font-weight: 800; color: #0f172a; margin: 0 0 4px 0; display: flex; align-items: center; gap: 8px;">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #2563eb;">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            {{ locale === 'vi' ? 'Hồ sơ cá nhân' : 'Personal Profile' }}
          </h3>
          <p style="font-size: 0.85rem; color: #64748b; margin: 0;">{{ locale === 'vi' ? 'Quản lý thông tin cá nhân và tài khoản của bạn.' : 'Manage your personal profile and account settings.' }}</p>
        </div>

        <!-- Personal Info Form -->
        <form @submit.prevent="handleUpdateProfile" style="display: flex; flex-direction: column; gap: 16px; border-bottom: 1px solid #f1f5f9; padding-bottom: 24px; text-align: left;">
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Họ và tên' : 'Full Name' }}</label>
              <input type="text" v-model="profileForm.fullName" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
            </div>
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">Email</label>
              <input type="email" :value="profileForm.email" disabled style="padding: 10px 12px; border-radius: 8px; border: 1px solid #e2e8f0; background: #f8fafc; color: #94a3b8; font-size: 0.9rem;" />
            </div>
          </div>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Số điện thoại' : 'Phone Number' }}</label>
              <input type="text" v-model="profileForm.phone" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" />
            </div>
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Ảnh đại diện (URL)' : 'Avatar URL' }}</label>
              <input type="text" v-model="profileForm.avatarUrl" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" />
            </div>
          </div>
          <button type="submit" :disabled="updatingProfile" style="width: fit-content; align-self: flex-end; padding: 10px 24px; border-radius: 8px; border: none; background: #2563eb; color: white; font-weight: 700; cursor: pointer; transition: opacity 0.2s;">
            <span v-if="updatingProfile">{{ locale === 'vi' ? 'Đang lưu...' : 'Saving...' }}</span>
            <span v-else>{{ locale === 'vi' ? 'Lưu thay đổi' : 'Save Changes' }}</span>
          </button>
        </form>

        <!-- Change Password Form -->
        <form @submit.prevent="handleUpdatePassword" style="display: flex; flex-direction: column; gap: 16px; text-align: left;">
          <h4 style="font-size: 0.95rem; font-weight: 800; color: #0f172a; margin: 0; display: flex; align-items: center; gap: 6px;">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="color: #ef4444;">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg>
            {{ locale === 'vi' ? 'Đổi mật khẩu tài khoản' : 'Change Account Password' }}
          </h4>
          <div style="display: flex; flex-direction: column; gap: 6px;">
            <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Mật khẩu hiện tại' : 'Current Password' }}</label>
            <input type="password" v-model="passwordForm.oldPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
          </div>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Mật khẩu mới' : 'New Password' }}</label>
              <input type="password" v-model="passwordForm.newPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
            </div>
            <div style="display: flex; flex-direction: column; gap: 6px;">
              <label style="font-size: 0.8rem; font-weight: 700; color: #475569;">{{ locale === 'vi' ? 'Xác nhận mật khẩu mới' : 'Confirm New Password' }}</label>
              <input type="password" v-model="passwordForm.confirmPassword" style="padding: 10px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;" required />
            </div>
          </div>
          <button type="submit" :disabled="updatingPassword" style="width: fit-content; align-self: flex-end; padding: 10px 24px; border-radius: 8px; border: none; background: #ef4444; color: white; font-weight: 700; cursor: pointer; transition: opacity 0.2s;">
            <span v-if="updatingPassword">{{ locale === 'vi' ? 'Đang cập nhật...' : 'Updating...' }}</span>
            <span v-else>{{ locale === 'vi' ? 'Đổi mật khẩu' : 'Update Password' }}</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useToastStore } from '../stores/toast'
import { useI18n } from 'vue-i18n'
import axios from '../api/axios'
import { getRooms } from '../api/rooms'
import { getProfile, updateProfile, changePassword } from '../api/users'
import heroBg from '../assets/hero.png'
import AuthModal from '../components/auth/AuthModal.vue'
import {
  Hotel, Plane, Building2, Tag,
  MapPin, Calendar, Users, Search,
  Menu, X, ChevronRight, ChevronLeft, ArrowUp,
  Star, Smartphone,
  Facebook, Twitter, Instagram, Linkedin,
  Activity, Car, ChevronDown, Plus, Minus
} from 'lucide-vue-next'

const router = useRouter()
const authStore = useAuthStore()
const toastStore = useToastStore()
const { t, locale } = useI18n()

// Profile settings variables
const showProfileModal = ref(false)
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

const openProfileModal = async () => {
  showProfileModal.value = true
  await fetchUserProfile()
}

const fetchUserProfile = async () => {
  try {
    const res = await getProfile()
    profileForm.value.fullName = res.data.fullName || ''
    profileForm.value.email = res.data.email || ''
    profileForm.value.phone = res.data.phone || ''
    profileForm.value.avatarUrl = res.data.avatarUrl || ''

    if (authStore.user) {
      authStore.user.fullName = res.data.fullName
      authStore.user.avatarUrl = res.data.avatarUrl
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
    if (authStore.user) {
      authStore.user.fullName = res.data.fullName
      authStore.user.phone = res.data.phone
      authStore.user.avatarUrl = res.data.avatarUrl
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

const changeLanguage = (lang) => {
  locale.value = lang
  localStorage.setItem('locale', lang)
}

const handleLogoClick = () => {
  searched.value = false
  rooms.value = []
  onlyApartments.value = false
  isSearchCompact.value = false
  search.value = {
    city: '',
    checkIn: formatDate(today),
    checkOut: formatDate(tomorrow),
    guests: 2,
    children: 0,
    rooms: 1
  }
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const selectCategory = (catId) => {
  if (catId === 'hotels') {
    onlyApartments.value = false
  } else if (catId === 'apartments') {
    onlyApartments.value = true
  } else {
    toastStore.info(locale.value === 'vi' ? 'Tính năng đang được phát triển!' : 'Feature is under development!')
    return
  }
  // Scroll to search container
  const el = document.querySelector('.search-container-wrapper')
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'center' })
  }
}

// ===== STATE =====
const isScrolled    = ref(false)
const isSearchCompact = ref(false)
const mobileMenuOpen = ref(false)
const focus         = ref('')
const activeCategory = ref('hotels')
const loading       = ref(false)
const searched      = ref(false)
const rooms         = ref([])
const showAuth      = ref(false)
const authInitialTab = ref('login')
const searchType    = ref('overnight')
const onlyApartments = ref(false)
const guestDropdownOpen = ref(false)
const destTrackRef  = ref(null)

const compactGuestDropdownOpen = ref(false)
const compactGuestSelectRef = ref(null)

const cityDropdownOpen = ref(false)
const compactCityDropdownOpen = ref(false)
const citySelectRef = ref(null)
const compactCitySelectRef = ref(null)
const availableCities = ['Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng', 'Phú Quốc', 'Đà Lạt', 'Nha Trang', 'Vũng Tàu']

// Ngày mặc định: hôm nay và ngày mai
const formatDate = (d) => d.toISOString().split('T')[0]
const today    = new Date()
const tomorrow = new Date(); tomorrow.setDate(today.getDate() + 1)

const search = ref({
  city: '',
  checkIn: formatDate(today),
  checkOut: formatDate(tomorrow),
  guests: 2,
  children: 0,
  rooms: 1
})

const guestSummary = computed(() => {
  const adults = search.value.guests
  const children = search.value.children
  const rooms = search.value.rooms
  const parts = [`${adults} ${t('search.adults')}`]
  if (children > 0) parts.push(`${children} ${t('search.children')}`)
  return `${parts.join(', ')}, ${rooms} ${t('search.rooms')}`
})

const guestSelectRef = ref(null)

const closeGuestDropdown = (e) => {
  guestDropdownOpen.value = false
}

const handleOutsideClick = (e) => {
  if (guestSelectRef.value && !guestSelectRef.value.contains(e.target)) {
    guestDropdownOpen.value = false
  }
  if (compactGuestSelectRef.value && !compactGuestSelectRef.value.contains(e.target)) {
    compactGuestDropdownOpen.value = false
  }
  if (citySelectRef.value && !citySelectRef.value.contains(e.target)) {
    cityDropdownOpen.value = false
  }
  if (compactCitySelectRef.value && !compactCitySelectRef.value.contains(e.target)) {
    compactCityDropdownOpen.value = false
  }
}

const adjustGuest = (field, delta) => {
  if (field === 'guests') {
    search.value.guests = Math.max(1, search.value.guests + delta)
  } else if (field === 'children') {
    search.value.children = Math.max(0, search.value.children + delta)
  } else if (field === 'rooms') {
    search.value.rooms = Math.max(1, search.value.rooms + delta)
  }
}

// ===== BỘ LỌC & SẮP XẾP =====
const filterPrice  = ref('all')
const filterRating = ref(0)
const filterType   = ref('all')
const sortBy       = ref('default')
const filterCity   = ref('all')

const clearFilters = () => {
  filterPrice.value  = 'all'
  filterRating.value = 0
  filterType.value   = 'all'
  sortBy.value       = 'default'
  filterCity.value   = 'all'
}

const filteredRooms = computed(() => {
  let list = [...rooms.value]
  if (onlyApartments.value) {
    list = list.filter(r => {
      const type = r.roomTypeName?.toLowerCase() ?? ''
      return type.includes('căn hộ') || type.includes('nhà') || type.includes('villa') || type.includes('studio')
    })
  }
  // Lọc theo địa điểm
  if (filterCity.value !== 'all') {
    list = list.filter(r => r.city?.toLowerCase() === filterCity.value.toLowerCase())
  }
  // Lọc theo giá
  if (filterPrice.value === 'under1m') {
    list = list.filter(r => r.pricePerNight < 1000000)
  } else if (filterPrice.value === '1to2m') {
    list = list.filter(r => r.pricePerNight >= 1000000 && r.pricePerNight <= 2000000)
  } else if (filterPrice.value === 'over2m') {
    list = list.filter(r => r.pricePerNight > 2000000)
  }

  // Lọc theo rating
  if (filterRating.value > 0) {
    list = list.filter(r => (r.avgRating || 0) >= filterRating.value)
  }

  // Lọc theo loại phòng (so sánh chính xác, không dùng includes)
  if (filterType.value !== 'all') {
    list = list.filter(r =>
        r.roomTypeName?.toLowerCase() === filterType.value.toLowerCase()
    )
  }

  // Sắp xếp
  if (sortBy.value === 'default') {
    list.sort((a, b) => {
      // Ưu tiên rating trung bình (avgRating) cao hơn
      const rateA = a.avgRating || 0
      const rateB = b.avgRating || 0
      if (rateB !== rateA) {
        return rateB - rateA
      }
      // Cùng rating -> ưu tiên số lượng đánh giá (ratingCount) nhiều hơn
      const countA = a.ratingCount || 0
      const countB = b.ratingCount || 0
      if (countB !== countA) {
        return countB - countA
      }
      // Cùng rating và số lượng -> ưu tiên giá thấp hơn
      return a.pricePerNight - b.pricePerNight
    })
  } else if (sortBy.value === 'priceAsc') {
    list.sort((a, b) => a.pricePerNight - b.pricePerNight)
  } else if (sortBy.value === 'priceDesc') {
    list.sort((a, b) => b.pricePerNight - a.pricePerNight)
  } else if (sortBy.value === 'ratingDesc') {
    list.sort((a, b) => (b.avgRating || 0) - (a.avgRating || 0))
  }

  return list
})

// ===== PHÂN TRANG KẾT QUẢ TÌM KIẾM =====
const SEARCH_PAGE_SIZE = 12
const searchPage = ref(1)

const searchTotalPages = computed(() =>
  Math.ceil(filteredRooms.value.length / SEARCH_PAGE_SIZE)
)

const paginatedRooms = computed(() => {
  const start = (searchPage.value - 1) * SEARCH_PAGE_SIZE
  return filteredRooms.value.slice(start, start + SEARCH_PAGE_SIZE)
})

const searchPageNumbers = computed(() => {
  const total = searchTotalPages.value
  const cur = searchPage.value
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)
  const pages = [1]
  if (cur > 3) pages.push('...')
  const s = Math.max(2, cur - 1)
  const e = Math.min(total - 1, cur + 1)
  for (let i = s; i <= e; i++) pages.push(i)
  if (cur < total - 2) pages.push('...')
  pages.push(total)
  return pages
})

// Reset trang khi filter / sort thay đổi
watch([filterPrice, filterRating, filterType, sortBy, filterCity], () => { searchPage.value = 1 })

// ===== CATEGORIES & DESTINATIONS =====
const categories = [
  { id: 'hotels',     icon: Hotel,    name: 'Khách sạn' },
  { id: 'apartments', icon: Building2, name: 'Nhà và Căn hộ' },
  { id: 'activities', icon: Activity, name: 'Hoạt động' },
  { id: 'transports', icon: Car,      name: 'Đưa đón sân bay' },
]

const destinations = ref([
  { id: 1, city: 'Hà Nội',      country: 'Việt Nam', properties: 10744, image: 'https://images.unsplash.com/photo-1555921015-5532091f6026?auto=format&fit=crop&w=400&q=80' },
  { id: 2, city: 'Đà Nẵng',     country: 'Việt Nam', properties: 5534,  image: 'https://images.unsplash.com/photo-1570448896287-c0d8f249ba37?q=80&w=400&auto=format&fit=crop' },
  { id: 3, city: 'Hồ Chí Minh', country: 'Việt Nam', properties: 15546, image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=400&q=80' },
  { id: 4, city: 'Phú Quốc',    country: 'Việt Nam', properties: 3120,  image: 'https://plus.unsplash.com/premium_photo-1661962432490-6188a6420a81?q=80&w=400&auto=format&fit=crop' },
  { id: 5, city: 'Đà Lạt',      country: 'Việt Nam', properties: 4850,  image: 'https://images.unsplash.com/photo-1620814153812-38115a7f0fbd?q=80&w=400&auto=format&fit=crop' },
  { id: 6, city: 'Nha Trang',   country: 'Việt Nam', properties: 4098,  image: 'https://images.unsplash.com/photo-1533002832-1721d16b4bb9?w=400&q=80&auto=format&fit=crop' },
])

// ===== DESTINATIONS SCROLL =====
const scrollDest = (dir) => {
  const track = destTrackRef.value
  if (!track) return
  const cardW = track.querySelector('.dest-card')?.offsetWidth || 200
  track.scrollBy({ left: dir * (cardW + 16) * 2, behavior: 'smooth' })
}

// ===== SCROLL =====
const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
  isSearchCompact.value = window.scrollY > 350
}
const fetchCityStats = async () => {
  try {
    const res = await axios.get('/rooms/stats/city-count')
    console.log('[fetchCityStats] response:', res.data)
    destinations.value = destinations.value.map(dest => {
      const apiCount = res.data[dest.city]
      let count = apiCount
      if (!count) {
        if (dest.city === 'Đà Nẵng') count = 5534
        else if (dest.city === 'Vũng Tàu') count = 6329
        else if (dest.city === 'Hồ Chí Minh') count = 15546
        else if (dest.city === 'Hà Nội') count = 10744
        else if (dest.city === 'Nha Trang') count = 4098
        else if (dest.city === 'Phú Quốc') count = 3120
        else if (dest.city === 'Đà Lạt') count = 4850
        else count = 0
      }
      return {
        ...dest,
        properties: count
      }
    })
    console.log('[fetchCityStats] updated destinations:', destinations.value)
  } catch (e) {
    console.error('Lấy thống kê thành phố thất bại:', e)
  }
}

// ===== PROMOTIONS STATE & METHODS =====
const availablePromos = ref([])
const myVouchers = ref([])
const promosLoading = ref(false)
const promoTrackRef = ref(null)

const getPromoCardStyle = (promo, index) => {
  const images = [
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=500&q=80', // green lake
    'https://images.unsplash.com/photo-1540959733332-eab4deceeaf7?auto=format&fit=crop&w=500&q=80', // tokyo red/orange
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=500&q=80', // tropical beach blue
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=500&q=80'  // scenic mountain
  ]
  const overlays = [
    'linear-gradient(to right, rgba(17, 76, 50, 0.9) 0%, rgba(17, 76, 50, 0.3) 100%)', // green
    'linear-gradient(to right, rgba(125, 20, 30, 0.9) 0%, rgba(125, 20, 30, 0.3) 100%)', // red
    'linear-gradient(to right, rgba(15, 60, 110, 0.9) 0%, rgba(15, 60, 110, 0.3) 100%)', // blue
    'linear-gradient(to right, rgba(90, 35, 125, 0.9) 0%, rgba(90, 35, 125, 0.3) 100%)'  // purple
  ]
  
  const img = images[index % images.length]
  const overlay = overlays[index % overlays.length]
  return {
    background: `${overlay}, url('${img}')`,
    backgroundSize: 'cover',
    backgroundPosition: 'center'
  }
}

const getPromoTopTag = (index) => {
  const tags = ['Hạ giá Giữa Tháng', 'Từ châu Á đến thế giới', 'Độc quyền HotelStay', 'Ưu đãi mùa hè']
  return tags[index % tags.length]
}

const getPromoSubtitle = (index) => {
  const subtitles = ['Đặt phòng ngay', 'Tiết kiệm & Khám phá', 'Ưu đãi đặc biệt', 'Khám phá điểm đến mới']
  return subtitles[index % subtitles.length]
}

const formatPriceShort = (val) => {
  if (!val) return '0'
  if (val >= 1000000) {
    return (val / 1000000).toFixed(0) + 'Tr'
  }
  if (val >= 1000) {
    return (val / 1000).toFixed(0) + 'K'
  }
  return val + 'đ'
}

const fmtDateShort = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  const day = String(d.getDate()).padStart(2, '0')
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const year = d.getFullYear()
  return `${day}/${month}/${year}`
}

const fetchPromotions = async () => {
  promosLoading.value = true
  try {
    const res = await axios.get('/promotions/available')
    availablePromos.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Lỗi lấy danh sách mã khuyến mãi khả dụng:', err)
  } finally {
    promosLoading.value = false
  }
}

const fetchMyVouchers = async () => {
  if (!authStore.isLoggedIn) return
  try {
    const res = await axios.get('/promotions/my-wallet')
    myVouchers.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Lỗi khi lấy danh sách ví voucher:', err)
  }
}

const claimVoucher = async (code) => {
  if (!authStore.isLoggedIn) {
    showAuth.value = true
    return
  }
  try {
    const res = await axios.post('/promotions/claim', { code })
    myVouchers.value.push(res.data)
  } catch (err) {
    alert(err.response?.data?.message || 'Lưu mã khuyến mãi thất bại')
  }
}

const isClaimed = (code) => {
  return myVouchers.value.some(v => v.code === code)
}

const scrollPromo = (dir) => {
  const track = promoTrackRef.value
  if (!track) return
  const cardW = track.querySelector('.promo-banner-card')?.offsetWidth || 350
  track.scrollBy({ left: dir * (cardW + 16) * 2, behavior: 'smooth' })
}

// ===== FEATURED ACCOMMODATIONS STATE & METHODS =====
const featuredRooms = ref([])
const activeFeaturedCity = ref('Đà Nẵng')
const featuredCities = ['Đà Nẵng', 'Vũng Tàu', 'Hồ Chí Minh', 'Hà Nội', 'Nha Trang']

const fetchFeaturedRooms = async () => {
  try {
    const res = await getRooms({ page: 0, size: 200 })
    featuredRooms.value = res.data.content ?? res.data
  } catch (err) {
    console.error('Lỗi khi lấy danh sách chỗ nghỉ nổi bật:', err)
  }
}

const filteredFeaturedRooms = computed(() => {
  return featuredRooms.value
    .filter(r => r.city?.toLowerCase().includes(activeFeaturedCity.value.toLowerCase()))
    .slice(0, 3)
})

const getScoreBadge = (avgRating) => {
  return avgRating ? (avgRating * 2).toFixed(1) : '9.2'
}

const formatPriceVND = (price) => {
  if (!price) return 'VND 0'
  return 'VND ' + new Intl.NumberFormat('vi-VN').format(price)
}

const saveSearchState = () => {
  const state = {
    search: search.value,
    searched: searched.value,
    rooms: rooms.value,
    searchPage: searchPage.value,
    onlyApartments: onlyApartments.value,
    filterPrice: filterPrice.value,
    filterRating: filterRating.value,
    filterType: filterType.value,
    filterCity: filterCity.value,
    sortBy: sortBy.value,
    isSearchCompact: isSearchCompact.value
  }
  sessionStorage.setItem('searchState', JSON.stringify(state))
}

watch(
  [search, searched, rooms, searchPage, onlyApartments, filterPrice, filterRating, filterType, filterCity, sortBy, isSearchCompact],
  () => {
    saveSearchState()
  },
  { deep: true }
)

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  document.addEventListener('mousedown', handleOutsideClick)
  fetchCityStats()
  fetchPromotions()
  fetchFeaturedRooms()
  if (authStore.isLoggedIn) {
    fetchUserProfile()
    if (authStore.role === 'CUSTOMER') {
      fetchMyVouchers()
    }
  }

  // Restore search state from sessionStorage
  const savedSearchState = sessionStorage.getItem('searchState')
  if (savedSearchState) {
    try {
      const state = JSON.parse(savedSearchState)
      search.value = state.search || search.value
      searched.value = state.searched ?? searched.value
      rooms.value = state.rooms || []
      searchPage.value = state.searchPage || 1
      onlyApartments.value = state.onlyApartments ?? false
      filterPrice.value = state.filterPrice || 'all'
      filterRating.value = state.filterRating || 0
      filterType.value = state.filterType || 'all'
      filterCity.value = state.filterCity || 'all'
      sortBy.value = state.sortBy || 'default'
      isSearchCompact.value = state.isSearchCompact ?? false

      // If they had search results, scroll to search-results-section
      if (searched.value) {
        setTimeout(() => {
          document.getElementById('search-results-section')?.scrollIntoView({ block: 'start' })
        }, 150)
      }
    } catch (e) {
      console.error('Failed to parse search state', e)
    }
  }
})
onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  document.removeEventListener('mousedown', handleOutsideClick)
})
const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' })

// ===== SEARCH =====
const handleSearch = async () => {
  loading.value = true
  try {
    const res = await getRooms({
      city: search.value.city || undefined,
      checkIn: search.value.checkIn || undefined,
      checkOut: search.value.checkOut || undefined,
      maxGuests: search.value.guests + search.value.children,
      page: 0,
      size: 1000
    })
    rooms.value  = res.data.content ?? res.data
    searched.value = true
    searchPage.value = 1
    clearFilters()
    setTimeout(() => {
      document.getElementById('search-results-section')?.scrollIntoView({ behavior: 'smooth' })
    }, 100)
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const quickSearch = (city) => {
  search.value.city = city
  handleSearch()
}

// ===== NAVIGATION =====
const goToDetail = (id) => router.push(`/rooms/${id}`)

// Quick View Room Details & Reviews State & Methods
const showQuickViewModal = ref(false)
const selectedQuickViewRoom = ref(null)
const quickViewReviews = ref([])

const openQuickView = async (roomItem) => {
  selectedQuickViewRoom.value = roomItem
  quickViewReviews.value = []
  showQuickViewModal.value = true
  
  try {
    const res = await axios.get(`/reviews/room/${roomItem.id}`)
    quickViewReviews.value = Array.isArray(res.data) ? res.data : []
  } catch (err) {
    console.error('Lỗi khi lấy đánh giá xem nhanh:', err)
  }
}

const confirmBookingFromQuickView = (id) => {
  showQuickViewModal.value = false
  router.push(`/rooms/${id}`)
}

const handleLogout = () => {
  authStore.logout()
  myVouchers.value = []
  router.push('/')
}

const formatPrice = (p) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p)

// ===== AUTH =====
const onLogin = (userData) => {
  showAuth.value = false
  const role = authStore.role
  if (role === 'ADMIN')    router.push('/admin')
  else if (role === 'HOST') router.push('/host/rooms')
  // CUSTOMER ở lại trang chủ
  if (role === 'CUSTOMER') {
    fetchMyVouchers()
  }
}

const onRegister = () => {
  // AuthModal tự chuyển sang tab login sau khi đăng ký thành công
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }
:global(:root) {
  --blue: #5392f9;
  --red: #ff567d;
  --orange: #ffb703;
  --dark: #2a2a2e;
}

.container { max-width: 1200px; margin: 0 auto; padding: 0 1rem; }

/* HEADER */
.header {
  position: fixed; top: 0; left: 0; right: 0; z-index: 50;
  padding: 1.2rem 0; transition: all 0.3s ease;
  font-family: 'Inter', sans-serif;
}
.header.scrolled {
  background: #0f294d;
  padding: 0.5rem 0;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}
.header .container { display: flex; justify-content: space-between; align-items: center; }

/* Compact search bar (Agoda style) */
.header-container.compact-mode {
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
}

.compact-search-bar {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(255, 255, 255, 0.08);
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  width: 100%;
  max-width: 1000px;
}

.compact-field {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  background: #ffffff;
  border-radius: 8px;
  padding: 0.5rem 0.75rem;
  transition: all 0.2s ease;
  height: 38px;
}

.compact-ico {
  color: #64748b;
  flex-shrink: 0;
}

/* Field specific widths */
.compact-field.dest-field {
  flex: 2;
  min-width: 180px;
}

.compact-field.dest-field input {
  width: 100%;
  border: none;
  outline: none;
  font-size: 0.85rem;
  font-weight: 600;
  color: #1e293b;
  background: transparent;
}

.compact-field.dest-field input::placeholder {
  color: #94a3b8;
}

.compact-field.dates-field {
  flex: 1.8;
  min-width: 230px;
}

.compact-date-inputs {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  width: 100%;
}

.compact-date-inputs input[type="date"] {
  border: none;
  outline: none;
  background: transparent;
  font-size: 0.82rem;
  font-weight: 700;
  color: #1e293b;
  width: 100px;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
}

.compact-arrow {
  color: #94a3b8;
  font-size: 0.8rem;
  font-weight: 700;
  margin: 0 0.15rem;
}

.compact-field.guest-field {
  flex: 1.5;
  min-width: 180px;
  position: relative;
  cursor: pointer;
  user-select: none;
}

.compact-guest-txt {
  font-size: 0.82rem;
  font-weight: 700;
  color: #1e293b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.compact-chevron {
  color: #64748b;
  transition: transform 0.2s ease;
  flex-shrink: 0;
}

.compact-chevron.open {
  transform: rotate(180deg);
}

/* Compact Dropdown Panel */
.compact-guest-dropdown {
  position: absolute;
  top: calc(100% + 8px);
  left: 0;
  right: 0;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
  padding: 0.75rem 1rem;
  z-index: 100;
  border: 1px solid #e2e8f0;
  min-width: 250px;
  cursor: default;
}

.compact-guest-dropdown .guest-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-bottom: 1px solid #f1f5f9;
}

.compact-guest-dropdown .guest-row:last-of-type {
  border-bottom: none;
}

.compact-guest-dropdown .guest-row-title {
  font-size: 0.85rem;
  font-weight: 700;
  color: #1e293b;
}

/* Search button in compact bar */
.btn-compact-search {
  background: #5392f9;
  color: #ffffff;
  border: none;
  padding: 0.55rem 1.5rem;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 800;
  cursor: pointer;
  transition: all 0.2s ease;
  font-family: 'Inter', sans-serif;
  letter-spacing: 0.05em;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 80px;
  height: 38px;
}

.btn-compact-search:hover {
  background: #3d7ef5;
}

.btn-compact-search:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.header-left { display: flex; align-items: center; gap: 2rem; }
.header-right { display: flex; align-items: center; gap: 0.8rem; }
.logo { 
  font-size: 1.5rem; 
  font-weight: 800; 
  letter-spacing: -0.05em; 
  color: white; 
  text-decoration: none; 
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.logo-brand-icon, .logo-word {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.logo:hover {
  color: #ff385c !important;
}
.logo:hover .logo-brand-icon {
  transform: rotate(-10deg) scale(1.15) !important;
}
.header.scrolled .logo { color: var(--blue); }
.header.scrolled .logo:hover { color: #ff567d !important; }
.logo-red { color: var(--red); }
.desktop-nav { display: flex; gap: 1.5rem; }
.nav-cat-link {
  display: flex; align-items: center; gap: 0.4rem;
  color: rgba(255,255,255,0.85); text-decoration: none;
  font-size: 0.875rem; font-weight: 500; transition: all 0.2s;
}
.header.scrolled .nav-cat-link { color: #475569; }
.nav-cat-link:hover { color: var(--blue); }
.nav-cat-link.active {
  color: #fff !important;
  font-weight: 700;
  border-bottom: 2px solid #fff;
  padding-bottom: 2px;
}
.header.scrolled .nav-cat-link.active {
  color: var(--blue) !important;
  border-bottom: 2px solid var(--blue);
}
.welcome-text { color: white; font-size: 0.85rem; }
.header.scrolled .welcome-text { color: var(--dark); }
.nav-link-btn { color: white; text-decoration: none; font-size: 0.85rem; font-weight: 500; }
.header.scrolled .nav-link-btn { color: var(--dark); }
.btn-outline {
  padding: 0.4rem 1.2rem; border-radius: 999px; font-size: 0.85rem; font-weight: 600;
  border: 1.5px solid rgba(255,255,255,0.7); color: white; background: transparent;
  cursor: pointer; text-decoration: none; transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.header.scrolled .btn-outline { border-color: var(--blue); color: var(--blue); }
.btn-outline:hover { background: var(--blue); color: white; border-color: var(--blue); }
.btn-filled {
  padding: 0.5rem 1.2rem; border-radius: 999px; font-size: 0.85rem; font-weight: 600;
  background: white; color: var(--blue); border: none; cursor: pointer;
  text-decoration: none; transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.header.scrolled .btn-filled { background: var(--blue); color: white; }
.btn-filled:hover { opacity: 0.9; }
.mobile-menu-btn {
  display: none; background: none; border: none; color: white;
  cursor: pointer; padding: 0.25rem; line-height: 1;
}
.header.scrolled .mobile-menu-btn { color: var(--dark); }

/* MOBILE MENU */
.mobile-menu {
  position: fixed; inset: 0; z-index: 50; background: white;
  padding: 1.5rem; display: flex; flex-direction: column;
  transform: translateX(100%); transition: transform 0.3s ease;
}
.mobile-menu.open { transform: translateX(0); }
.mobile-overlay { position: fixed; inset: 0; z-index: 40; background: rgba(0,0,0,0.5); }
.mobile-menu-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
.mobile-menu-header button { background: none; border: none; cursor: pointer; color: #475569; }
.mobile-nav { display: flex; flex-direction: column; gap: 1rem; }
.mobile-nav-item { display: flex; align-items: center; gap: 1rem; font-size: 1.1rem; font-weight: 500; color: var(--dark); text-decoration: none; transition: all 0.2s; }
.mobile-nav-item.active { color: var(--blue) !important; font-weight: 700; }
.mobile-nav-icon { width: 40px; height: 40px; background: #f1f5f9; border-radius: 10px; display: flex; align-items: center; justify-content: center; color: var(--blue); transition: all 0.2s; }
.mobile-nav-item.active .mobile-nav-icon { background: var(--blue); color: white; }
.mobile-divider { height: 1px; background: #e2e8f0; margin: 0.5rem 0; }
.mobile-btn-filled { padding: 1rem; background: var(--blue); color: white; border: none; border-radius: 12px; text-align: center; font-weight: 700; cursor: pointer; font-family: 'Inter', sans-serif; font-size: 1rem; }
.mobile-btn-outline { padding: 1rem; border: 1.5px solid var(--blue); color: var(--blue); background: none; border-radius: 12px; text-align: center; font-weight: 700; cursor: pointer; font-family: 'Inter', sans-serif; font-size: 1rem; }

/* HERO */
.hero {
  position: relative;
  min-height: 330px;
  height: 330px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  overflow: visible;
  padding-top: 80px;
  padding-bottom: 0;
  margin-bottom: 180px;
}
.hero-bg {
  position: absolute;
  inset: 0;
  border-bottom-left-radius: 80px;
  border-bottom-right-radius: 0;
  overflow: hidden;
}
.hero-img { width: 100%; height: 100%; object-fit: cover; }
.hero-overlay { position: absolute; inset: 0; background: rgba(0,0,0,0.45); }
.hero-content {
  position: relative; z-index: 10; text-align: center; color: white;
  width: 100%; max-width: 960px !important; margin: 0 auto;
}
.hero-title {
  font-family: 'Inter', sans-serif;
  font-size: clamp(1.2rem, 3.2vw, 1.8rem);
  font-weight: 800; margin-bottom: 2.25rem;
  text-transform: uppercase; letter-spacing: 0.05em;
  text-shadow: 0 2px 10px rgba(0,0,0,0.5);
}

/* SEARCH CONTAINER */
.search-container-wrapper { width: 100%; position: relative; margin-top: 1rem; }

/* TABS */
.search-tabs {
  display: flex; background: white; border-radius: 12px 12px 0 0;
  padding: 0 1rem; border-bottom: 1.5px solid #e2e8f0;
  width: max-content; max-width: 100%; overflow-x: auto;
  scrollbar-width: none; /* Hide scrollbar for Firefox */
}
.search-tabs::-webkit-scrollbar {
  display: none; /* Hide scrollbar for Chrome, Safari and Opera */
}
.search-tab-btn {
  display: flex; align-items: center; gap: 0.5rem;
  background: transparent; border: none; border-bottom: 3px solid transparent;
  padding: 0.9rem 1.25rem; font-size: 0.875rem; font-weight: 700;
  color: #475569; cursor: pointer; white-space: nowrap;
  transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.search-tab-btn:hover { color: var(--blue); }
.search-tab-btn.active { color: var(--blue); border-bottom-color: var(--blue); }
.tab-ico { color: #64748b; transition: color 0.2s; }
.search-tab-btn:hover .tab-ico,
.search-tab-btn.active .tab-ico { color: var(--blue); }

/* SEARCH CARD */
.search-card {
  background: white; border-radius: 16px;
  padding: 2.25rem 2.25rem 3rem;
  box-shadow: 0 15px 40px rgba(0,0,0,0.2);
  position: relative; text-align: left; z-index: 5;
}

/* PILLS */
.search-pills { display: flex; gap: 0.75rem; margin-bottom: 1.5rem; }
.pill-btn {
  background: white; border: 1.5px solid #cbd5e1; color: #475569;
  padding: 0.45rem 1.25rem; border-radius: 999px;
  font-size: 0.8rem; font-weight: 700; cursor: pointer;
  transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.pill-btn:hover { border-color: var(--blue); color: var(--blue); }
.pill-btn.active { border-color: var(--blue); color: var(--blue); background: rgba(83,146,249,0.05); }

/* FIELDS */
.search-fields-grid { display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1rem; }
.field-item {
  display: flex; align-items: center; gap: 0.75rem;
  border: 1.5px solid #cbd5e1; border-radius: 12px;
  padding: 0.75rem 1rem; background: #f8fafc; transition: all 0.2s;
}
.field-item:hover { border-color: rgba(83,146,249,0.6); background: white; }
.field-item.focused { border-color: var(--blue); background: white; box-shadow: 0 0 0 3px rgba(83,146,249,0.15); }
.field-item.full-width { width: 100%; }
.field-ico { color: #64748b; flex-shrink: 0; }
.field-input-wrap { flex: 1; min-width: 0; }
.field-input-wrap input {
  width: 100%; border: none; outline: none; background: transparent;
  font-size: 0.95rem; font-weight: 600; color: var(--dark); font-family: 'Inter', sans-serif;
}
.field-input-wrap input::placeholder { color: #94a3b8; font-weight: 500; }

/* SUBGRID */
.fields-subgrid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 1rem; }
.date-range-picker { display: flex; align-items: center; justify-content: space-between; padding: 0.65rem 1rem; }
.date-box { display: flex; align-items: center; gap: 0.5rem; flex: 1; }
.date-info { display: flex; flex-direction: column; flex: 1; justify-content: center; }
.date-info label { font-size: 0.65rem; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.15rem; }
.date-info input[type="date"] {
  border: none; outline: none; background: transparent;
  font-size: 0.9rem; font-weight: 700; color: var(--dark);
  font-family: 'Inter', sans-serif; width: 100%;
  padding: 0;
  margin: 0;
  height: 20px;
  line-height: 1.2;
}
.date-divider { color: #94a3b8; font-weight: 600; margin: 0 0.5rem; }
.guest-select { display: flex; align-items: center; gap: 0.75rem; padding: 0.65rem 1rem; }
.guest-info { display: flex; flex-direction: column; flex: 1; }
.guest-info label { font-size: 0.65rem; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.15rem; }
.guest-display { display: flex; align-items: center; justify-content: space-between; gap: 0.5rem; width: 100%; }
.guest-text { font-size: 0.9rem; font-weight: 700; color: var(--dark); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.guest-chevron { color: #94a3b8; flex-shrink: 0; transition: transform 0.25s ease; }
.guest-chevron.open { transform: rotate(180deg); }

/* GUEST DROPDOWN */
.guest-dropdown-panel {
  position: absolute; top: calc(100% + 8px); left: 0; right: 0;
  background: white; border-radius: 14px;
  box-shadow: 0 12px 40px rgba(0,0,0,0.15); z-index: 100;
  padding: 1rem 1.25rem 0.75rem; min-width: 260px;
  border: 1px solid rgba(0,0,0,0.06);
}
.guest-row {
  display: flex; align-items: center; justify-content: space-between;
  padding: 0.7rem 0; border-bottom: 1px solid #f1f5f9;
}
.guest-row:last-of-type { border-bottom: none; }
.guest-row-label { display: flex; flex-direction: column; gap: 0.1rem; }
.guest-row-title { font-size: 0.9rem; font-weight: 700; color: var(--dark); }
.guest-row-sub { font-size: 0.72rem; color: #94a3b8; font-weight: 500; }
.guest-row-counter { display: flex; align-items: center; gap: 0.75rem; }
.counter-btn {
  width: 30px; height: 30px; border-radius: 50%;
  border: 1.5px solid #cbd5e1; background: white;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  color: #475569; transition: all 0.2s; flex-shrink: 0;
}
.counter-btn:hover:not(:disabled) { background: var(--blue); color: white; border-color: var(--blue); }
.counter-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.counter-num { font-size: 1rem; font-weight: 700; color: var(--dark); min-width: 20px; text-align: center; }
.guest-done-btn {
  display: block; width: 100%; margin-top: 0.75rem;
  padding: 0.6rem; border-radius: 10px; border: none;
  background: var(--blue); color: white; font-weight: 700;
  font-size: 0.88rem; cursor: pointer; font-family: 'Inter', sans-serif;
  transition: background 0.2s;
}
.guest-done-btn:hover { background: #3d7ef5; }

/* Transition */
.guest-drop-enter-active { animation: dropDown 0.22s cubic-bezier(0.16, 1, 0.3, 1); }
.guest-drop-leave-active { animation: dropDown 0.16s ease reverse; }
@keyframes dropDown {
  from { opacity: 0; transform: translateY(-8px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* OPTIONS */
.search-options-row {
  display: flex; justify-content: space-between; align-items: center;
  margin-top: 1.25rem; margin-bottom: 1.5rem;
}
.checkbox-container {
  display: flex; align-items: center; gap: 0.5rem;
  font-size: 0.85rem; font-weight: 600; color: #475569;
  cursor: pointer; user-select: none;
}
.checkbox-container input { display: none; }
.checkbox-container .checkmark {
  width: 18px; height: 18px; border: 1.5px solid #cbd5e1;
  border-radius: 4px; display: inline-block; position: relative;
  background: white; transition: background 0.2s, border-color 0.2s;
}
.checkbox-container input:checked ~ .checkmark { background: var(--blue); border-color: var(--blue); }
.checkbox-container input:checked ~ .checkmark::after {
  content: ''; position: absolute; left: 5px; top: 2px;
  width: 5px; height: 9px; border: solid white;
  border-width: 0 2px 2px 0; transform: rotate(45deg);
}
.add-flight-link { font-size: 0.85rem; font-weight: 700; color: var(--blue); text-decoration: none; }
.add-flight-link:hover { text-decoration: underline; }

/* SEARCH BUTTON */
.search-btn-container {
  position: absolute; bottom: 0; left: 50%;
  transform: translate(-50%, 50%); z-index: 15;
  width: 100%; display: flex; justify-content: center;
}
.btn-search-large {
  background: var(--blue); color: white; border: none;
  padding: 0.95rem 4.5rem; border-radius: 999px;
  font-size: 1.1rem; font-weight: 800; cursor: pointer;
  letter-spacing: 0.05em; box-shadow: 0 6px 20px rgba(83,146,249,0.45);
  transition: all 0.2s; font-family: 'Inter', sans-serif;
  min-width: 240px; display: flex; align-items: center; justify-content: center;
}
.btn-search-large:hover { background: #3d7ef5; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(83,146,249,0.6); }
.btn-search-large:active { transform: translateY(0); }
.btn-search-large:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }
.spinner-small {
  width: 18px; height: 18px; border: 2px solid rgba(255,255,255,0.4);
  border-top-color: white; border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* FAB */
.fab {
  position: fixed; bottom: 2rem; right: 2rem; z-index: 60;
  width: 48px; height: 48px; border-radius: 50%;
  background: var(--blue); color: white; border: none;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  box-shadow: 0 8px 24px rgba(83,146,249,0.4); transition: transform 0.2s;
}
.fab:hover { transform: scale(1.1); }

/* SECTION */
.section { padding: 5rem 0; }
.section-header-simple { margin-bottom: 2rem; }
.section-title { font-size: 1.8rem; font-weight: 700; color: #1e293b; }

/* DESTINATIONS CAROUSEL */
.dest-scroll-wrap {
  position: relative;
  overflow: visible; /* Cho phép nút nổi nhô ra ngoài */
}
.dest-track {
  display: flex;
  gap: 1.25rem;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  padding: 0.5rem 0.25rem;
}
.dest-track::-webkit-scrollbar { display: none; }

/* Floating Buttons */
.dest-float-btn {
  position: absolute;
  top: 38%;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: none;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #475569;
  z-index: 10;
  box-shadow: 0 4px 10px rgba(0,0,0,0.12);
  transition: all 0.2s ease;
}
.dest-float-btn:hover {
  background: white;
  color: var(--blue);
  box-shadow: 0 6px 14px rgba(0,0,0,0.18);
}
.dest-float-btn.prev {
  left: 0;
  transform: translate(-50%, -50%);
}
.dest-float-btn.next {
  right: 0;
  transform: translate(50%, -50%);
}

/* Card Style */
.dest-card {
  cursor: pointer;
  flex: 0 0 calc((100% - 5rem) / 5); /* Mặc định hiển thị 5 card đầy đủ */
  min-width: 175px;
  scroll-snap-align: start;
  transition: transform 0.2s ease;
}
.dest-card:hover {
  transform: translateY(-4px);
}
.dest-img-wrap { 
  position: relative; 
  aspect-ratio: 1/1; /* Ảnh tỷ lệ 1:1 */
  border-radius: 20px; /* Góc bo tròn lớn hơn */
  overflow: hidden; 
  margin-bottom: 0.75rem; 
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}
.dest-img { 
  width: 100%; 
  height: 100%; 
  object-fit: cover; 
  transition: transform 0.5s ease; 
}
.dest-card:hover .dest-img { 
  transform: scale(1.06); 
}
.dest-text-content {
  text-align: center; /* Căn giữa nội dung văn bản bên dưới ảnh */
}
.dest-name { 
  font-size: 1rem; 
  font-weight: 700; 
  color: #1e293b; 
  margin-bottom: 0.15rem;
}
.dest-count { 
  font-size: 0.8rem; 
  color: #64748b; 
  font-weight: 500;
}
.dest-card:hover .dest-name {
  color: var(--blue);
}

/* FILTER PANEL */
.filter-panel {
  display: flex; flex-wrap: wrap; gap: 1.25rem;
  background: white; padding: 1.25rem; border-radius: 16px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 2rem;
  align-items: flex-end; border: 1px solid #e2e8f0;
}
.filter-group { display: flex; flex-direction: column; gap: 0.4rem; flex: 1; min-width: 150px; }
.filter-group label { font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.filter-group select {
  padding: 0.6rem 0.8rem; border-radius: 10px; border: 1.5px solid #e2e8f0;
  font-size: 0.875rem; font-weight: 600; color: #1e293b;
  outline: none; background: #f8fafc; cursor: pointer;
  transition: all 0.2s; font-family: 'Inter', sans-serif;
}
.filter-group select:focus { border-color: var(--blue); background: white; box-shadow: 0 0 0 3px rgba(83,146,249,0.1); }
.btn-clear-filter {
  padding: 0.6rem 1.2rem; border-radius: 10px; background: transparent;
  color: #64748b; border: 1.5px solid #e2e8f0; font-size: 0.875rem;
  font-weight: 600; cursor: pointer; transition: all 0.2s;
  height: 38px; display: flex; align-items: center; justify-content: center;
  font-family: 'Inter', sans-serif;
}
.btn-clear-filter:hover { background: #f1f5f9; color: #1e293b; }

/* ROOM RESULTS */
.room-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem; }
.room-card { background: white; border-radius: 16px; overflow: hidden; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
.room-card:hover { transform: translateY(-4px); box-shadow: 0 12px 30px rgba(0,0,0,0.12); }
.room-img-wrap { height: 200px; position: relative; overflow: hidden; background: #e8f4fd; }
.room-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
.room-card:hover .room-img { transform: scale(1.05); }
.room-no-img { height: 100%; display: flex; align-items: center; justify-content: center; }
.room-badge { position: absolute; top: 0.75rem; left: 0.75rem; background: rgba(0,0,0,0.6); color: white; font-size: 0.7rem; font-weight: 600; padding: 0.2rem 0.6rem; border-radius: 999px; }
.room-info { padding: 1rem; }
.room-info h3 { font-size: 1rem; font-weight: 700; color: var(--dark); margin-bottom: 0.3rem; }
.room-city { font-size: 0.82rem; color: var(--blue); font-weight: 500; display: flex; align-items: center; gap: 0.25rem; }
.room-addr { font-size: 0.78rem; color: #94a3b8; margin-top: 0.1rem; margin-bottom: 0.6rem; }
.room-footer { display: flex; justify-content: space-between; align-items: center; }
.room-rating { font-size: 0.82rem; color: var(--orange); font-weight: 600; display: flex; align-items: center; gap: 0.25rem; }
.room-price { font-size: 1rem; font-weight: 700; color: var(--blue); }
.room-price small { font-size: 0.75rem; font-weight: 400; color: #94a3b8; }
.no-result { text-align: center; padding: 3rem; color: #64748b; font-size: 1rem; }

/* PAGINATION */
.pagination-bar {
  display: flex; align-items: center; justify-content: center;
  gap: 0.4rem; margin-top: 2.5rem; flex-wrap: wrap;
}
.pg-btn {
  min-width: 40px; height: 40px; padding: 0 0.65rem;
  border-radius: 10px; border: 1.5px solid #e2e8f0;
  background: white; color: #475569;
  font-size: 0.9rem; font-weight: 700; cursor: pointer;
  font-family: 'Inter', sans-serif; transition: all 0.18s;
  display: inline-flex; align-items: center; justify-content: center;
}
.pg-btn:hover:not(:disabled) {
  border-color: var(--blue); color: var(--blue); background: #eff6ff;
}
.pg-btn.active {
  background: linear-gradient(135deg, var(--blue), #7c3aed);
  border-color: var(--blue); color: white;
  box-shadow: 0 4px 14px rgba(83,146,249,0.35);
  transform: translateY(-1px);
}
.pg-btn:disabled { opacity: 0.35; cursor: not-allowed; }
.pg-ellipsis { font-size: 0.9rem; color: #94a3b8; padding: 0 0.1rem; user-select: none; }
.pg-info { font-size: 0.78rem; font-weight: 600; color: #94a3b8; margin-left: 0.5rem; white-space: nowrap; }

/* DEALS */
.deals-section { background: white; padding: 5rem 0; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
.deals-banner {
  background: linear-gradient(135deg, #5392f9 0%, #3b68d9 100%);
  border-radius: 24px; padding: 3rem; color: white;
  display: flex; gap: 3rem; align-items: center;
  position: relative; overflow: hidden;
  box-shadow: 0 20px 60px rgba(83,146,249,0.3);
}
.deals-glow { position: absolute; top: -50%; right: -10%; width: 400px; height: 400px; background: rgba(255,255,255,0.1); border-radius: 50%; filter: blur(60px); pointer-events: none; }
.deals-left { flex: 1; position: relative; z-index: 1; }
.deals-tag { display: inline-flex; align-items: center; gap: 0.4rem; background: #fbbf24; color: #78350f; padding: 0.4rem 1rem; border-radius: 12px; font-size: 0.8rem; font-weight: 800; margin-bottom: 1.5rem; }
.deals-left h2 { font-size: 2rem; font-weight: 700; margin-bottom: 0.8rem; line-height: 1.2; }
.deals-left p { color: rgba(255,255,255,0.8); margin-bottom: 1.5rem; max-width: 420px; }
.deals-btns { display: flex; gap: 1rem; flex-wrap: wrap; }
.deals-btn-white { background: white; color: var(--blue); border: none; padding: 0.8rem 2rem; border-radius: 999px; font-weight: 700; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 0.5rem; font-family: 'Inter', sans-serif; }
.deals-btn-white:hover { box-shadow: 0 4px 15px rgba(0,0,0,0.15); }
.deals-btn-outline { background: transparent; border: 1.5px solid rgba(255,255,255,0.5); color: white; padding: 0.8rem 2rem; border-radius: 999px; font-weight: 600; cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif; }
.deals-btn-outline:hover { background: rgba(255,255,255,0.1); }
.deals-right { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; flex: 1; position: relative; z-index: 1; }
.review-card { background: rgba(255,255,255,0.1); backdrop-filter: blur(8px); border: 1px solid rgba(255,255,255,0.2); border-radius: 16px; padding: 1.2rem; }
.review-card.offset { margin-top: 2rem; }
.stars { display: flex; gap: 0.2rem; margin-bottom: 0.5rem; }
.review-card p { font-size: 0.85rem; font-weight: 500; margin-bottom: 0.5rem; }
.review-card small { font-size: 0.7rem; color: rgba(255,255,255,0.6); }

/* FOOTER */
.footer { background: white; padding: 5rem 0 2rem; border-top: 1px solid #f1f5f9; font-family: 'Inter', sans-serif; }
.footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 3rem; margin-bottom: 4rem; }
.footer-brand p { font-size: 0.875rem; color: #64748b; line-height: 1.6; max-width: 280px; margin-bottom: 1.5rem; }
.social-links { display: flex; gap: 0.75rem; }
.social-links a { width: 40px; height: 40px; background: #f1f5f9; border-radius: 50%; display: flex; align-items: center; justify-content: center; text-decoration: none; color: #475569; transition: all 0.2s; }
.social-links a:hover { background: var(--blue); color: white; }
.footer-col h4 { font-weight: 700; color: var(--dark); margin-bottom: 1.5rem; }
.footer-col a { display: block; color: #64748b; text-decoration: none; font-size: 0.875rem; margin-bottom: 1rem; transition: color 0.2s; }
.footer-col a:hover { color: var(--blue); }
.footer-bottom { padding-top: 2rem; border-top: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; color: #94a3b8; font-size: 0.8rem; }
.footer-links { display: flex; gap: 1.5rem; }
.footer-links a { color: #94a3b8; text-decoration: none; }
.footer-links a:hover { color: #475569; }

/* RESPONSIVE */
@media (max-width: 1024px) {
  .desktop-nav { display: none; }
  .mobile-menu-btn { display: block; }
  .dest-grid { grid-template-columns: repeat(3, 1fr); }
  .footer-grid { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 768px) {
  .hero {
    min-height: 270px;
    height: 270px;
    padding-top: 60px;
    margin-bottom: 330px;
  }
  .hero-bg {
    border-bottom-left-radius: 30px;
    border-bottom-right-radius: 0;
  }
  .search-card { padding: 1.25rem 1.25rem 2.5rem; border-radius: 12px; }
  .fields-subgrid { grid-template-columns: 1fr; }
  .date-range-picker { flex-direction: column; align-items: stretch; gap: 0.75rem; padding: 0.75rem 1rem; }
  .date-divider { display: none; }
  .search-options-row { flex-direction: column; align-items: flex-start; gap: 0.75rem; }
  .btn-search-large { width: 90%; min-width: unset; padding: 0.8rem; }
  .dest-grid { grid-template-columns: repeat(2, 1fr); }
  .deals-banner { flex-direction: column; }
  .deals-right { grid-template-columns: 1fr; }
  .review-card.offset { margin-top: 0; }
  .section-header { flex-direction: column; align-items: flex-start; gap: 0.5rem; }
  .footer-grid { grid-template-columns: 1fr; }
  .footer-bottom { flex-direction: column; gap: 1rem; text-align: center; }
  .filter-panel { flex-direction: column; align-items: stretch; }
  .btn-clear-filter { width: 100%; }
}

/* PROMO BANNER CAROUSEL STYLES */
.promo-scroll-wrap {
  position: relative;
  width: 100%;
}
.promo-track {
  display: flex;
  gap: 20px;
  overflow-x: auto;
  padding: 10px 4px 24px;
  scrollbar-width: none; /* Hide scrollbar for Firefox */
  scroll-behavior: smooth;
}
.promo-track::-webkit-scrollbar {
  display: none; /* Hide scrollbar for Chrome, Safari, Opera */
}

.promo-banner-card {
  width: 420px;
  height: 190px;
  flex-shrink: 0;
  border-radius: 16px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
  display: flex;
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
  font-family: 'Inter', sans-serif;
}
.promo-banner-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 36px rgba(0, 0, 0, 0.18);
}

.pbc-glow {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 60%);
  pointer-events: none;
  z-index: 1;
}

/* First static card styling */
.first-promo-card {
  background: linear-gradient(135deg, #6c2bc4, #b52fd6);
  color: #ffffff;
  padding: 1.5rem;
  position: relative;
  flex-direction: column;
  justify-content: space-between;
}
.first-promo-card .pbc-content {
  display: flex;
  flex-direction: column;
  height: 100%;
  justify-content: space-between;
}
.first-promo-card .pbc-tag {
  background: #ffb703; /* Yellow accent */
  color: #2a2a2e;
  font-weight: 800;
  font-size: 0.7rem;
  padding: 3px 8px;
  border-radius: 6px;
  text-transform: uppercase;
  width: fit-content;
  letter-spacing: 0.5px;
}
.first-promo-card h3 {
  font-size: 1.35rem;
  font-weight: 800;
  line-height: 1.3;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
}
.first-promo-card p {
  font-size: 0.85rem;
  opacity: 0.9;
  line-height: 1.4;
  max-width: 85%;
}

/* Floating decorations inside first card */
.pbc-float-shape {
  position: absolute;
  font-weight: 900;
  opacity: 0.15;
  color: #ffffff;
  pointer-events: none;
}
.pbc-float-shape.percent-1 { font-size: 3rem; top: 10px; right: 80px; transform: rotate(15deg); }
.pbc-float-shape.percent-2 { font-size: 2.2rem; bottom: 20px; left: 20px; transform: rotate(-20deg); }
.pbc-float-shape.ticket-1 { font-size: 2.5rem; top: 70px; right: 20px; transform: rotate(-10deg); opacity: 0.12; }
.pbc-float-shape.ticket-2 { font-size: 1.8rem; bottom: 50px; right: 120px; transform: rotate(30deg); opacity: 0.12; }

/* Pointer arrow cursor */
.pbc-cursor-arrow {
  position: absolute;
  bottom: 20px;
  right: 25px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(4px);
  animation: cursorPulse 2s infinite ease-in-out;
}
@keyframes cursorPulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.15); }
  100% { transform: scale(1); }
}

/* Logo overlay */
.pbc-logo-overlay {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  align-items: center;
  gap: 6px;
  z-index: 5;
}
.pbc-mini-logo {
  background: #ff385c; /* Red circle */
  width: 20px;
  height: 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.pbc-top-tag {
  font-size: 0.65rem;
  font-weight: 700;
  color: #ffffff;
  background: rgba(0, 0, 0, 0.35);
  padding: 2px 8px;
  border-radius: 20px;
  backdrop-filter: blur(4px);
  letter-spacing: 0.3px;
}

/* Card body layout */
.pbc-card-body {
  width: 100%;
  height: 100%;
  padding: 1.25rem;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  position: relative;
  z-index: 2;
  color: #ffffff;
}
.pbc-text-section {
  margin-bottom: auto;
  margin-top: 1.25rem;
}
.pbc-subtitle {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  opacity: 0.9;
  margin-bottom: 2px;
}
.pbc-title-large {
  font-size: 1.45rem;
  font-weight: 800;
  line-height: 1.2;
  margin-bottom: 4px;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}
.pbc-desc-text {
  font-size: 0.78rem;
  opacity: 0.95;
  line-height: 1.35;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Bottom row details */
.pbc-bottom-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 0.75rem;
  background: rgba(0, 0, 0, 0.25);
  padding: 6px 12px;
  border-radius: 10px;
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
.pbc-info-pill {
  display: flex;
  flex-direction: column;
  gap: 1px;
}
.pbc-code-tag {
  font-size: 0.8rem;
  font-weight: 800;
  letter-spacing: 0.5px;
}
.pbc-min-order-tag {
  font-size: 0.65rem;
  opacity: 0.85;
}

/* Sleek new button style */
.btn-promo-claim-new {
  background: #ffffff;
  color: #0f172a;
  font-weight: 800;
  border: none;
  border-radius: 20px;
  padding: 6px 14px;
  font-size: 0.75rem;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}
.btn-promo-claim-new:hover {
  background: #ff385c;
  color: #ffffff;
  transform: translateY(-1px) scale(1.03);
}
.btn-promo-claim-new.claimed {
  background: rgba(255, 255, 255, 0.25);
  color: rgba(255, 255, 255, 0.8);
  cursor: not-allowed;
  box-shadow: none;
}

/* Float buttons for promo carousel */
.promo-float-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #ffffff;
  border: 1px solid #e2e8f0;
  color: #334155;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 10;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.2s ease;
}
.promo-float-btn:hover {
  background: #f8fafc;
  color: #0f172a;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-50%) scale(1.05);
}
.promo-float-btn.prev { left: -16px; }
.promo-float-btn.next { right: -16px; }

@media (max-width: 768px) {
  .promo-banner-card {
    width: 330px;
    height: 170px;
  }
  .pbc-title-large {
    font-size: 1.25rem;
  }
  .first-promo-card h3 {
    font-size: 1.15rem;
  }
  .promo-float-btn {
    display: none;
  }
  .promo-header-flex {
    flex-direction: column;
    align-items: flex-start !important;
    gap: 0.5rem;
  }
}

/* ===== FEATURED ACCOMMODATIONS STYLES ===== */
.featured-tab-btn {
  background: transparent;
  border: none;
  color: #475569;
  font-size: 14.5px;
  font-weight: 600;
  padding: 8px 0;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: all 0.2s ease;
}
.featured-tab-btn:hover {
  color: #1a6cf7;
}
.featured-tab-btn.active {
  color: #1a6cf7;
  border-bottom: 2px solid #1a6cf7;
}
.view-more-featured-link {
  background: transparent;
  border: none;
  color: #1a6cf7;
  font-weight: 600;
  font-size: 0.92rem;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  transition: all 0.2s ease;
}
.view-more-featured-link:hover {
  color: #0043a4;
  text-decoration: underline;
}
.featured-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}
.featured-room-card {
  background: #ffffff;
  border-radius: 14px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
  cursor: pointer;
  transition: all 0.25s ease;
  overflow: hidden;
}
.featured-room-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 20px -3px rgba(0, 0, 0, 0.08);
}
.frc-img-wrap {
  width: 100%;
  height: 200px;
  position: relative;
  overflow: hidden;
  background: #f1f5f9;
}
.frc-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.frc-no-img {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.frc-score-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  background: #1a6cf7;
  color: #ffffff;
  font-size: 13.5px;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.frc-info {
  padding: 16px;
}
.frc-name {
  margin: 0 0 6px 0;
  font-size: 16px;
  font-weight: 700;
  color: #0f172a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.frc-stars-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}
.frc-stars {
  display: flex;
  gap: 2px;
}
.frc-location-text {
  color: #64748b;
  font-size: 12.5px;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
}
.frc-price-label {
  margin: 0 0 2px 0;
  color: #94a3b8;
  font-size: 11.5px;
  font-weight: 500;
}
.frc-price-val {
  margin: 0;
  color: #e11d48;
  font-size: 16.5px;
  font-weight: 800;
}

@media (max-width: 1024px) {
  .featured-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
@media (max-width: 640px) {
  .featured-grid {
    grid-template-columns: 1fr;
  }
  .featured-header {
    flex-direction: column;
    align-items: flex-start !important;
    gap: 12px;
  }
}

.header-lang-selector {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: rgba(241, 245, 249, 0.85);
  padding: 4px 8px;
  border-radius: 20px;
  border: 1px solid rgba(226, 232, 240, 0.8);
  margin-right: 12px;
  align-self: center;
}

.lang-btn-header {
  background: none;
  border: none;
  font-size: 11px;
  font-weight: 700;
  color: #64748b;
  cursor: pointer;
  padding: 2px 6px;
  border-radius: 12px;
  transition: all 0.2s ease;
}

.lang-btn-header:hover {
  color: #0f172a;
}

.lang-btn-header.active {
  color: #ffffff;
  background: #3b82f6;
}

.lang-divider-header {
  font-size: 10px;
  color: #cbd5e1;
}

/* Responsive header styles */
@media (max-width: 768px) {
  .desktop-nav {
    display: none !important;
  }
  
  .header-right .header-lang-selector-dropdown,
  .header-right .welcome-text,
  .header-right .nav-link-btn,
  .header-right .btn-outline,
  .header-right .btn-filled {
    display: none !important;
  }
  
  .mobile-menu-btn {
    display: flex !important;
    align-items: center;
    justify-content: center;
    color: white !important;
  }
  
  .header.scrolled .mobile-menu-btn {
    color: var(--dark) !important;
  }
}
</style>