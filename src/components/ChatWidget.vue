<template>
  <Teleport to="body">
    <!-- FAB -->
    <button
      id="chat-fab"
      class="chat-fab"
      :class="{ 'is-open': isOpen }"
      @click="toggleChat"
      :aria-label="t('chatbot.aria_open')"
    >
      <Transition name="icon-swap" mode="out-in">
        <svg v-if="isOpen" key="close" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
        <svg v-else key="chat" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
        </svg>
      </Transition>
      <span v-if="!isOpen && hasUnread" class="fab-badge" />
    </button>

    <!-- Chat Widget -->
    <Transition name="chat-popup">
      <div v-if="isOpen" id="chat-widget" class="chat-widget" role="dialog">

        <!-- Header -->
        <div class="chat-header">
          <div class="header-avatar">
            <span class="bot-avatar-emoji">🤖</span>
          </div>
          <div class="header-info">
            <span class="header-name">{{ t('chatbot.title') }}</span>
            <span class="header-status">
              <span class="status-dot" />
              {{ t('chatbot.status_online') }}
            </span>
          </div>
          <button class="header-close" @click="toggleChat" :aria-label="t('chatbot.aria_close')">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>

        <!-- Messages -->
        <div class="chat-messages" ref="messagesRef">
          <div
            v-for="(msg, idx) in messages"
            :key="idx"
            class="msg-row-wrap"
          >
            <div
              class="msg-row"
              :class="msg.role === 'user' ? 'msg-row--user' : 'msg-row--bot'"
            >
              <div v-if="msg.role === 'model'" class="msg-avatar">
                <span class="bot-avatar-emoji-sm">🤖</span>
              </div>
              <div class="bubble" :class="msg.role === 'user' ? 'bubble--user' : 'bubble--bot'">
                {{ msg.content }}
              </div>
            </div>

            <!-- Suggestion Room Cards under Bot Bubble -->
            <div v-if="msg.role === 'model' && msg.roomIds && msg.roomIds.length > 0" class="chat-room-cards-wrap">
              <div class="chat-room-cards-title">{{ t('chatbot.suggested_rooms') }}</div>
              <div class="chat-room-cards-container">
                <div 
                  v-for="rid in msg.roomIds" 
                  :key="rid"
                  class="chat-room-card"
                >
                  <template v-if="roomDetailsMap[rid] && !roomDetailsMap[rid].error">
                    <img 
                      :src="roomDetailsMap[rid].imageUrls && roomDetailsMap[rid].imageUrls.length > 0 ? roomDetailsMap[rid].imageUrls[0] : 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=150&q=80'" 
                      class="crc-img" 
                      alt="Room thumbnail"
                      referrerpolicy="no-referrer"
                    />
                    <div class="crc-body">
                      <h5 class="crc-name">{{ roomDetailsMap[rid].name }}</h5>
                      <div class="crc-bottom">
                        <span class="crc-price">{{ formatPrice(roomDetailsMap[rid].pricePerNight) }}{{ locale === 'vi' ? '/đêm' : '/night' }}</span>
                        <button class="crc-btn-detail" @click="goToRoom(rid)">
                          {{ t('chatbot.view_detail') }}
                        </button>
                      </div>
                    </div>
                  </template>
                  
                  <template v-else-if="!roomDetailsMap[rid]">
                    <div class="crc-loader">
                      <span class="crc-spinner-icon"></span> {{ t('chatbot.loading_room', { id: rid }) }}
                    </div>
                  </template>

                  <template v-else>
                    <div class="crc-error">
                      <span>🔍 {{ locale === 'vi' ? 'Phòng nghỉ' : 'Accommodation' }} #{{ rid }}</span>
                      <button class="crc-btn-detail-sm" @click="goToRoom(rid)">{{ t('chatbot.view_detail') }}</button>
                    </div>
                  </template>
                </div>
              </div>
            </div>
          </div>

          <Transition name="typing-fade">
            <div v-if="isTyping" class="msg-row msg-row--bot">
              <div class="msg-avatar">
                <span class="bot-avatar-emoji-sm">🤖</span>
              </div>
              <div class="bubble bubble--bot bubble--typing">
                <span class="typing-dot" />
                <span class="typing-dot" />
                <span class="typing-dot" />
              </div>
            </div>
          </Transition>

          <!-- Quick Replies & Suggested Questions when no user messages have been sent yet -->
          <div v-if="messages.length === 1 && !isTyping" class="initial-suggestions-area">
            <!-- Quick Replies -->
            <div class="quick-replies-container">
              <button 
                v-for="(reply, rIdx) in quickReplies" 
                :key="rIdx" 
                class="quick-reply-btn"
                @click="selectSuggestedQuery(reply.query)"
              >
                {{ reply.text }}
              </button>
            </div>

            <!-- Suggested Questions (Empty state) -->
            <div class="suggested-questions-wrap">
              <div class="suggested-questions-title">
                {{ t('chatbot.suggested_questions_title') }}
              </div>
              <div 
                v-for="(qText, qIdx) in suggestedQuestions" 
                :key="qIdx" 
                class="suggested-question-item"
                @click="selectSuggestedQuery(qText)"
              >
                {{ qText }}
              </div>
            </div>
          </div>
        </div>

        <!-- Input -->
        <div class="chat-input-area">
          <div class="input-wrap" :class="{ focused: inputFocused }">
            <textarea
              id="chat-input"
              ref="inputRef"
              v-model="inputText"
              class="chat-textarea"
              :placeholder="t('chatbot.placeholder')"
              rows="1"
              :disabled="isTyping"
              @keydown.enter.exact.prevent="sendMessage"
              @focus="inputFocused = true"
              @blur="inputFocused = false"
              @input="autoResize"
            />
            <button
              id="chat-send-btn"
              class="send-btn"
              :class="{ 'send-btn--active': inputText.trim() && !isTyping }"
              :disabled="!inputText.trim() || isTyping"
              @click="sendMessage"
              :aria-label="t('chatbot.aria_send')"
            >
              <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                <line x1="22" y1="2" x2="11" y2="13"/>
                <polygon points="22 2 15 22 11 13 2 9 22 2"/>
              </svg>
            </button>
          </div>
          <p class="input-hint">{{ t('chatbot.hint') }}</p>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, nextTick, watch, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import axios from '../api/axios'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const { t, locale } = useI18n()
const authStore = useAuthStore()

const isOpen       = ref(false)
const isTyping     = ref(false)
const hasUnread    = ref(true)
const inputText    = ref('')
const inputFocused = ref(false)
const messagesRef  = ref(null)
const inputRef     = ref(null)

// Room details map and dynamic loading
const roomDetailsMap = ref({})

const messages = ref([
  { role: 'model', content: t('chatbot.welcome'), roomIds: [] }
])

// Watch locale to update welcome message dynamically if no chat history yet
watch(locale, () => {
  if (messages.value.length === 1 && messages.value[0].role === 'model') {
    messages.value[0].content = t('chatbot.welcome')
  }
})

const quickReplies = computed(() => {
  const role = authStore.role
  if (role === 'ADMIN') {
    return [
      { text: t('chatbot.replies.admin.manage_rooms'), query: t('chatbot.replies.admin.manage_rooms') },
      { text: t('chatbot.replies.admin.revenue'), query: t('chatbot.replies.admin.revenue') },
      { text: t('chatbot.replies.admin.promotions'), query: t('chatbot.replies.admin.promotions') }
    ]
  } else if (role === 'HOST') {
    return [
      { text: t('chatbot.replies.host.post_room'), query: t('chatbot.replies.host.post_room') },
      { text: t('chatbot.replies.host.revenue'), query: t('chatbot.replies.host.revenue') },
      { text: t('chatbot.replies.host.bookings'), query: t('chatbot.replies.host.bookings') }
    ]
  } else {
    return [
      { text: t('chatbot.replies.guest.find_room'), query: t('chatbot.replies.guest.find_room') },
      { text: t('chatbot.replies.guest.promotions'), query: t('chatbot.replies.guest.promotions') },
      { text: t('chatbot.replies.guest.my_bookings'), query: t('chatbot.replies.guest.my_bookings') },
      { text: t('chatbot.replies.guest.contact_support'), query: t('chatbot.replies.guest.contact_support') }
    ]
  }
})

const suggestedQuestions = computed(() => {
  return [
    t('chatbot.questions.q1'),
    t('chatbot.questions.q2'),
    t('chatbot.questions.q3'),
    t('chatbot.questions.q4')
  ]
})

function selectSuggestedQuery(queryText) {
  inputText.value = queryText
  sendMessage()
}

function toggleChat() {
  isOpen.value = !isOpen.value
  if (isOpen.value) {
    hasUnread.value = false
    nextTick(() => { scrollToBottom(); inputRef.value?.focus() })
  }
}

function scrollToBottom() {
  const container = messagesRef.value
  if (!container) return
  
  // Nếu chỉ có 1 tin nhắn (tin nhắn chào đầu tiên), cuộn lên trên cùng để hiển thị từ đầu lời chào
  if (messages.value.length === 1) {
    container.scrollTo({ top: 0, behavior: 'smooth' })
    return
  }
  
  const msgWrappers = container.querySelectorAll('.msg-row-wrap')
  if (msgWrappers.length > 0) {
    const lastMsg = msgWrappers[msgWrappers.length - 1]
    const containerHeight = container.clientHeight
    const msgHeight = lastMsg.offsetHeight
    const msgOffsetTop = lastMsg.offsetTop

    // Nếu tin nhắn cuối cùng (bao gồm cả các card phòng gợi ý) cao hơn khung chat,
    // cuộn sao cho phần đầu của tin nhắn đó hiển thị ngay trên đầu khung chat.
    // Ngược lại, cuộn hết xuống dưới cùng như bình thường.
    if (msgHeight > containerHeight) {
      container.scrollTo({ top: msgOffsetTop - 10, behavior: 'smooth' })
    } else {
      container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' })
    }
  } else {
    container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' })
  }
}

watch([messages, isTyping, roomDetailsMap], () => { nextTick(scrollToBottom) }, { deep: true })

function autoResize() {
  const el = inputRef.value
  if (!el) return
  el.style.height = 'auto'
  el.style.height = Math.min(el.scrollHeight, 120) + 'px'
}

const formatPrice = (p) => {
  if (!p) return locale.value === 'vi' ? '0đ' : 'VND 0'
  return new Intl.NumberFormat(locale.value === 'vi' ? 'vi-VN' : 'en-US', {
    style: 'currency',
    currency: 'VND',
    minimumFractionDigits: 0
  }).format(p)
}

const goToRoom = (roomId) => {
  isOpen.value = false
  router.push(`/rooms/${roomId}`)
}

// Extract room IDs from text response
function extractRoomIds(text) {
  if (!text) return []
  const ids = new Set()
  
  // 1. Matches patterns like: id: 5, ID 5, id: #5, phòng 5, room 5, Room ID:** 5 (resilient to Markdown bold)
  const idRegex = /(?:id|phòng|phòng số|room)[\s*:*#]+(\d+)/gi
  let match
  while ((match = idRegex.exec(text)) !== null) {
    const val = parseInt(match[1])
    if (val > 0 && val < 1000) { // skip large values (years, prices, phones)
      ids.add(val)
    }
  }
  
  // 2. Matches URL paths: /rooms/5
  const pathRegex = /\/rooms\/(\d+)/g
  while ((match = pathRegex.exec(text)) !== null) {
    ids.add(parseInt(match[1]))
  }
  
  return Array.from(ids)
}

const fetchRoomDetail = async (id) => {
  try {
    const res = await axios.get(`/rooms/${id}`)
    roomDetailsMap.value[id] = res.data
  } catch (err) {
    console.error(`Không thể lấy chi tiết phòng ID ${id}:`, err)
    roomDetailsMap.value[id] = { error: true, name: locale.value === 'vi' ? `Phòng nghỉ #${id}` : `Accommodation #${id}` }
  }
}

async function sendMessage() {
  const text = inputText.value.trim()
  if (!text || isTyping.value) return

  messages.value.push({ role: 'user', content: text })
  inputText.value = ''
  nextTick(() => { if (inputRef.value) inputRef.value.style.height = 'auto' })

  const history = messages.value.slice(0, -1).map(m => ({ role: m.role, content: m.content }))
  isTyping.value = true

  try {
    const response = await axios.post('/chatbot/chat', {
      message: text,
      history,
      lang: locale.value
    })
    const data = response.data
    
    // Trích xuất các ID phòng từ thẻ định dạng [IDS: 9, 1, 7] và làm sạch nội dung hiển thị
    const ids = new Set()
    let cleanReply = data.reply || ''
    const idsRegex = /\[IDS:\s*([\d\s,]+)\]/i
    const matchIds = idsRegex.exec(cleanReply)

    if (matchIds) {
      const numStr = matchIds[1]
      numStr.split(',').forEach(s => {
        const val = parseInt(s.trim())
        if (!isNaN(val)) ids.add(val)
      })
      // Xoá thẻ [IDS: ...] khỏi câu trả lời hiển thị cho đẹp
      cleanReply = cleanReply.replace(idsRegex, '').trim()
    } else {
      // Hỗ trợ dự phòng nếu model quên định dạng mới (quét qua regex cũ)
      const rids = extractRoomIds(cleanReply)
      rids.forEach(rid => ids.add(rid))
    }

    const rids = Array.from(ids)
    messages.value.push({ 
      role: 'model', 
      content: cleanReply,
      roomIds: rids
    })
    
    // Fetch details asynchronously
    rids.forEach(rid => {
      if (!roomDetailsMap.value[rid]) {
        fetchRoomDetail(rid)
      }
    })
  } catch {
    messages.value.push({ role: 'model', content: t('chatbot.error_conn'), roomIds: [] })
  } finally {
    isTyping.value = false
    nextTick(() => inputRef.value?.focus())
  }
}
</script>

<style scoped>
.chat-fab, .chat-widget { font-family: 'Inter', system-ui, sans-serif; }

/* FAB */
.chat-fab {
  position: fixed; bottom: 28px; right: 28px; z-index: 9990;
  width: 58px; height: 58px; border-radius: 50%; border: none;
  background: linear-gradient(135deg, #5392f9 0%, #7ab3ff 100%);
  color: #fff; cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 6px 24px rgba(83,146,249,.45), 0 2px 8px rgba(0,0,0,.15);
  transition: transform .25s cubic-bezier(.34,1.56,.64,1), box-shadow .25s ease, background .25s ease;
  animation: fab-bounce 3.5s ease-in-out infinite;
}
.chat-fab:hover { transform: scale(1.1); box-shadow: 0 10px 32px rgba(83,146,249,.55); }
.chat-fab.is-open { background: linear-gradient(135deg,#2a2a2e,#4a4a52); animation: none; box-shadow: 0 6px 24px rgba(42,42,46,.35); }
.chat-fab.is-open:hover { transform: scale(1.08); }
@keyframes fab-bounce { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-6px); } }

.fab-badge {
  position: absolute; top: 6px; right: 6px; width: 12px; height: 12px;
  background: #ff567d; border: 2.5px solid #fff; border-radius: 50%;
  animation: badge-pulse 2s ease-in-out infinite;
}
@keyframes badge-pulse { 0%,100% { transform:scale(1); opacity:1; } 50% { transform:scale(1.35); opacity:.75; } }

.icon-swap-enter-active, .icon-swap-leave-active { transition: opacity .15s ease, transform .15s ease; }
.icon-swap-enter-from { opacity:0; transform:scale(.5) rotate(-30deg); }
.icon-swap-leave-to { opacity:0; transform:scale(.5) rotate(30deg); }

/* Popup transition */
.chat-popup-enter-active { transition: opacity .28s ease, transform .28s cubic-bezier(.34,1.56,.64,1); }
.chat-popup-leave-active { transition: opacity .18s ease, transform .18s ease; }
.chat-popup-enter-from, .chat-popup-leave-to { opacity:0; transform:translateY(18px) scale(.92); }

/* Widget */
.chat-widget {
  position: fixed; bottom: 100px; right: 28px; z-index: 9989;
  width: 380px; height: 550px; background: #fff; border-radius: 20px;
  box-shadow: 0 12px 40px rgba(83,146,249,.22), 0 4px 16px rgba(0,0,0,.12);
  display: flex; flex-direction: column; overflow: hidden;
  border: 1px solid rgba(83,146,249,.14);
}

/* Header */
.chat-header {
  display: flex; align-items: center; gap: 12px; padding: 15px 18px;
  background: linear-gradient(135deg,#5392f9 0%,#7ab3ff 100%); color:#fff; flex-shrink:0;
}
.header-avatar {
  width:40px; height:40px; border-radius:50%;
  background:rgba(255,255,255,.25); backdrop-filter:blur(8px);
  border:2px solid rgba(255,255,255,.45);
  display:flex; align-items:center; justify-content:center; flex-shrink:0;
}
.header-info { flex:1; display:flex; flex-direction:column; min-width:0; }
.header-name { font-weight:700; font-size:15px; letter-spacing:-.2px; }
.header-status { display:flex; align-items:center; gap:5px; font-size:12px; opacity:.87; margin-top:2px; }
.status-dot { width:7px; height:7px; background:#4ade80; border-radius:50%; flex-shrink:0; animation:status-pulse 2.5s ease-in-out infinite; }
@keyframes status-pulse { 0%,100%{opacity:1;} 50%{opacity:.45;} }
.header-close {
  background:rgba(255,255,255,.2); border:none; border-radius:50%;
  width:30px; height:30px; display:flex; align-items:center; justify-content:center;
  cursor:pointer; color:#fff; transition:background .2s; flex-shrink:0;
}
.header-close:hover { background:rgba(255,255,255,.35); }

/* Messages */
.chat-messages {
  flex:1; overflow-y:auto; padding:16px 14px;
  display:flex; flex-direction:column; gap:10px;
  background:linear-gradient(180deg,#f7f9ff 0%,#fff 60%);
  position: relative;
}
.chat-messages::-webkit-scrollbar { width:4px; }
.chat-messages::-webkit-scrollbar-thumb { background:#e4e6ea; border-radius:4px; }

.msg-row { display:flex; align-items:flex-end; gap:8px; animation:msg-in .22s ease-out both; }
@keyframes msg-in { from{opacity:0;transform:translateY(8px);} to{opacity:1;transform:translateY(0);} }
.msg-row--user { flex-direction:row-reverse; }

.msg-avatar {
  width:28px; height:28px; border-radius:50%;
  background:linear-gradient(135deg,#5392f9 0%,#7ab3ff 100%); color:#fff;
  display:flex; align-items:center; justify-content:center; flex-shrink:0;
  box-shadow:0 2px 8px rgba(83,146,249,.32);
}

.bubble { max-width:75%; padding:10px 14px; border-radius:18px; font-size:14px; line-height:1.58; word-break:break-word; white-space:pre-wrap; }
.bubble--user { background:linear-gradient(135deg,#5392f9 0%,#7ab3ff 100%); color:#fff; border-bottom-right-radius:5px; box-shadow:0 3px 12px rgba(83,146,249,.3); }
.bubble--bot  { background:#f2f3f5; color:#3a3a40; border-bottom-left-radius:5px; box-shadow:0 1px 4px rgba(0,0,0,.06); }

.bubble--typing { display:flex; align-items:center; gap:5px; padding:13px 16px; }
.typing-dot { width:7px; height:7px; background:#8a8a96; border-radius:50%; animation:typing-bounce 1.3s ease-in-out infinite; }
.typing-dot:nth-child(1){animation-delay:0s;} .typing-dot:nth-child(2){animation-delay:.2s;} .typing-dot:nth-child(3){animation-delay:.4s;}
@keyframes typing-bounce { 0%,80%,100%{transform:translateY(0);opacity:.4;} 40%{transform:translateY(-7px);opacity:1;} }

.typing-fade-enter-active,.typing-fade-leave-active{transition:opacity .2s ease,transform .2s ease;}
.typing-fade-enter-from{opacity:0;transform:translateY(6px);}
.typing-fade-leave-to{opacity:0;}

/* Input */
.chat-input-area { padding:12px 14px 10px; background:#fff; border-top:1px solid rgba(83,146,249,.1); flex-shrink:0; }
.input-wrap {
  display:flex; align-items:flex-end; gap:8px; background:#f2f3f5;
  border:1.5px solid transparent; border-radius:16px; padding:8px 8px 8px 14px;
  transition:border-color .2s,box-shadow .2s,background .2s;
}
.input-wrap.focused { border-color:#5392f9; box-shadow:0 0 0 3px rgba(83,146,249,.12); background:#fff; }
.chat-textarea { flex:1; border:none; background:transparent; resize:none; font-size:14px; font-family:inherit; color:#3a3a40; outline:none; line-height:1.5; max-height:120px; overflow-y:auto; }
.chat-textarea::placeholder{color:#8a8a96;}
.chat-textarea:disabled{opacity:.55;cursor:not-allowed;}

.send-btn {
  width:42px; height:42px; border-radius:14px; border:none; background:#e4e6ea; color:#8a8a96;
  cursor:pointer; display:flex; align-items:center; justify-content:center; flex-shrink:0;
  transition:all .2s ease;
}
.send-btn--active { background:linear-gradient(135deg,#5392f9 0%,#7ab3ff 100%); color:#fff; box-shadow:0 3px 12px rgba(83,146,249,.38); }
.send-btn--active:hover {
  background: linear-gradient(135deg, #4282eb 0%, #6da2ff 100%);
  color: #fff;
  box-shadow: 0 4px 16px rgba(83,146,249,.45);
  transform: scale(1.1);
}
.send-btn:disabled{cursor:not-allowed;}

.input-hint { font-size:11px; color:#8a8a96; text-align:center; margin:6px 0 0; opacity:.65; }

/* Suggestion Room Cards Styles */
.msg-row-wrap {
  display: flex;
  flex-direction: column;
  margin-bottom: 12px;
}
.msg-row-wrap .msg-row {
  margin-bottom: 0;
}
.chat-room-cards-wrap {
  margin-top: 6px;
  margin-left: 36px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  animation: fadeInMsg 0.25s ease-out;
}
.chat-room-cards-title {
  font-size: 0.72rem;
  font-weight: 700;
  color: #8a8a96;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.chat-room-cards-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.chat-room-card {
  background: #ffffff;
  border: 1px solid #e4e6ea;
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  box-shadow: 0 2px 6px rgba(0,0,0,0.03);
  transition: transform 0.2s, box-shadow 0.2s;
}
.chat-room-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.06);
}
.crc-img {
  width: 72px;
  height: 72px;
  object-fit: cover;
  flex-shrink: 0;
}
.crc-body {
  flex: 1;
  padding: 8px 12px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}
.crc-name {
  font-size: 0.82rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.crc-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.crc-price {
  font-size: 0.78rem;
  font-weight: 700;
  color: #1a6cf7;
}
.crc-btn-detail {
  background: #1a6cf7;
  color: #ffffff;
  border: none;
  border-radius: 6px;
  padding: 4px 12px;
  font-size: 0.72rem;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.15s;
}
.crc-btn-detail:hover {
  background: #0052cc;
}

/* Loading & error fallbacks */
.crc-loader {
  padding: 10px 14px;
  font-size: 0.75rem;
  color: #8a8a96;
  display: flex;
  align-items: center;
  gap: 8px;
}
.crc-spinner-icon {
  width: 12px;
  height: 12px;
  border: 2px solid #e4e6ea;
  border-top-color: #1a6cf7;
  border-radius: 50%;
  animation: crc-spin 0.8s linear infinite;
  display: inline-block;
}
@keyframes crc-spin {
  to { transform: rotate(360deg); }
}

.crc-error {
  padding: 10px 14px;
  font-size: 0.76rem;
  color: #64748b;
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}
.crc-btn-detail-sm {
  background: #f1f5f9;
  color: #475569;
  border: none;
  border-radius: 4px;
  padding: 2px 8px;
  font-size: 0.72rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s;
}
.crc-btn-detail-sm:hover {
  background: #e2e8f0;
}

@keyframes fadeInMsg {
  from { opacity: 0; transform: translateY(4px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Mobile */
@media (max-width:480px) {
  .chat-fab { bottom:18px; right:16px; width:52px; height:52px; }
  .chat-fab.is-open { display: none !important; }
  .chat-widget { bottom:0; right:0; left:0; width:100%; height:92dvh; border-radius:20px 20px 0 0; border:none; border-top:1px solid rgba(83,146,249,.14); }
}

/* New Chatbot UI elements */
.bot-avatar-emoji {
  font-size: 20px;
  line-height: 1;
}
.bot-avatar-emoji-sm {
  font-size: 14px;
  line-height: 1;
}

.initial-suggestions-area {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 8px;
}

.quick-replies-container {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-left: 36px;
  animation: fadeInMsg 0.3s ease-out;
}

.quick-reply-btn {
  background: #ffffff;
  border: 1.5px solid #5392f9;
  color: #5392f9;
  padding: 6px 12px;
  border-radius: 18px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 6px rgba(83,146,249,0.06);
}

.quick-reply-btn:hover {
  background: #5392f9;
  color: #ffffff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(83,146,249,0.2);
}

.quick-reply-btn:active {
  transform: translateY(0);
}

.suggested-questions-wrap {
  margin-left: 36px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  animation: fadeInMsg 0.4s ease-out;
}

.suggested-questions-title {
  font-size: 12px;
  font-weight: 700;
  color: #8a8a96;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 2px;
}

.suggested-question-item {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  padding: 8px 12px;
  font-size: 13px;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  gap: 8px;
}

.suggested-question-item:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
  transform: translateX(3px);
  color: #1e293b;
}
</style>
