# WASIYATI — Full Product Development Prompt
### "Leave your words behind. Forever."

---

## 🧭 PROJECT OVERVIEW

**App Name:** Wasiyati (وصيتي) — meaning "My Will" or "My Legacy Message" in Arabic  
**Tagline:** Leave your words behind. Forever.  
**Category:** Emotional / Lifestyle / Legacy Planning  
**Target Audience:** Global — adults 25–65 who care about leaving something meaningful behind  
**Platforms:** iOS + Android (Flutter for cross-platform)  
**Monetization:** Freemium (Free tier + Premium subscription)  
**Design Vibe:** Warm, emotional, soft — think soft amber tones, gentle gradients, human and intimate

---

## 🎨 DESIGN SYSTEM

### Brand Identity
- **Primary Palette:**
  - Warm Ivory: `#FAF6F1`
  - Soft Amber: `#E8A87C`
  - Deep Rose: `#C4736A`
  - Warm Taupe: `#8B7355`
  - Charcoal (text): `#2D2520`
- **Accent:** Golden Hour `#F2C46D`
- **Background:** `#FDF9F5` (off-white warm)
- **Error / Alert:** `#D45C4A`

### Typography
- **Display Font:** Cormorant Garamond (elegant, emotional, serif)
- **Body Font:** DM Sans (clean, modern, readable)
- **Arabic Support:** Noto Naskh Arabic (for multilingual messages)
- **Sizes:** Display 32px / Headline 22px / Body 16px / Caption 12px

### Design Principles
1. **Intimate, not clinical** — feels like a personal journal, not a productivity app
2. **Gentle transitions** — soft fades, no harsh cuts
3. **Warm negative space** — breathe between elements
4. **Meaningful iconography** — dove, letter seal, candle, olive branch — never generic
5. **Micro-interactions** — messages "seal" with a subtle wax stamp animation when saved

### UI Components Style
- Cards: rounded corners (20px), soft drop shadows (`rgba(139,115,85,0.12)`)
- Buttons: pill-shaped, warm gradient fills
- Inputs: borderless with subtle warm underline
- Progress: soft amber fill on warm gray track
- Modals: bottom sheets with blur backdrop

---

## 🏗️ FULL FEATURE SPECIFICATION

---

### AUTHENTICATION

**Screens:**
1. Splash Screen — animated logo (candle flame flicker), tagline fade in
2. Onboarding (3 slides):
   - "Your words are too precious to leave unsaid"
   - "Choose who receives your messages, and when"
   - "We'll make sure they reach them"
3. Sign Up / Sign In — Email + Phone + Google + Apple
4. Profile Setup — Name, Photo, Language preference, Country

---

### DASHBOARD (HOME)

**Layout:**
- Top: Greeting ("Good morning, Ahmed — your legacy is safe")
- Summary cards:
  - Total Messages Created
  - Recipients Added
  - Next Scheduled Message
  - Account Status (Free / Premium)
- Quick Actions: "+ New Message", "Manage Recipients", "Settings"
- Bottom nav: Home / Messages / Recipients / Vault / Profile

---

### MESSAGE COMPOSER

**Message Types:**
1. **Immediate Message** — sent the moment passing is confirmed
2. **Recurring Message** — weekly / monthly / yearly for a chosen duration
3. **Occasion Message** — triggered on specific date (birthday, anniversary, Eid)
4. **Milestone Message** — triggered by event (e.g., "When my child graduates")

**Content Formats:**
- 📝 Rich Text (formatted)
- 🎙️ Voice Recording (up to 5 min — Premium: unlimited)
- 🖼️ Photo with caption
- 🎥 Video (Premium only)
- 📎 File attachment (document, PDF)

**Composer UI:**
- Full-screen immersive editor
- Soft parchment-textured background
- Font selector (for emotional styling)
- "Preview as recipient" mode
- Auto-save every 30 seconds
- Message "sealing" animation when saved

**Message Settings per message:**
- Title (private, for user's reference only)
- Recipients (multi-select)
- Delivery channel per recipient (WhatsApp / Email / SMS)
- Schedule settings
- Privacy lock (require PIN to edit)

---

### RECIPIENT MANAGEMENT

**Add Recipient:**
- Name, Relationship tag (Father, Mother, Friend, Child, Partner, Other)
- Contact: WhatsApp number / Email / SMS
- Photo (optional)
- Language preference

**Recipient Profile Card:**
- Shows all messages assigned to them
- Allows per-recipient delivery preview
- "Send test message" (Premium feature)

---

### DEATH TRIGGER SYSTEM (Core Engine)

#### Method 1: Dead Man's Switch (Primary)
- Every **30 days**: push notification + email → "Are you still with us? Tap to confirm"
- User has **7 days** to respond
- If no response → system alerts the **Trusted Contact**
- Trusted Contact confirms through a special link/app screen
- **48-hour grace period** after confirmation before any message is sent
- During grace period: original user can log in to cancel ("False alarm" button)

#### Method 2: Manual Trigger by Trusted Contact
- Trusted Contact can open the app and initiate "Notification of Passing"
- Requires entering a pre-set **security phrase** chosen by the user
- Two-step confirmation with a waiting period

#### Trusted Contact
- Max 2 Trusted Contacts (1 on Free, 2 on Premium)
- They receive a special invitation with explanation of their role
- They have a separate lightweight "Trusted Contact" app view
- They can check the user's "last active" status

#### Delivery Engine
- Immediate messages: sent within 1 hour of confirmed trigger
- Recurring messages: queued in scheduler, sent per defined intervals
- Occasion messages: checked daily by cron job, sent on matching date
- All delivery attempts logged with status (sent / failed / retry)

---

### THE VAULT (Premium Feature)

A private encrypted space where users store:
- A digital will summary
- Important account credentials (encrypted, delivered posthumously)
- Video testament
- A "letter to the world" — public or private

---

### NOTIFICATIONS & REMINDERS

- Monthly check-in (Dead Man's Switch ping)
- "You have unsent messages — review them" (quarterly)
- Occasion reminders ("Ahmed's birthday is in 2 weeks — you have a message scheduled")
- Trusted Contact activity alerts
- Delivery confirmations

---

### FREE vs PREMIUM TIERS

| Feature | Free | Premium ($4.99/mo or $39.99/yr) |
|---|---|---|
| Messages | Up to 5 | Unlimited |
| Recipients | Up to 3 | Unlimited |
| Message types | Text only | Text + Voice + Photo + Video |
| Recurring duration | 3 months | Forever |
| Trusted Contacts | 1 | 2 |
| The Vault | ❌ | ✅ |
| Test send | ❌ | ✅ |
| Priority delivery | ❌ | ✅ |
| Custom occasion dates | ❌ | ✅ |
| Family plan | ❌ | ✅ ($9.99/mo, up to 5 members) |

---

## ⚙️ TECHNICAL ARCHITECTURE

### Frontend
```
Flutter (Dart)
├── State Management: Riverpod
├── Navigation: GoRouter
├── Local Storage: Hive
├── Animations: Rive (for logo/micro-interactions)
├── i18n: Flutter Intl (Arabic, English, French, Turkish, Urdu)
└── Biometrics: local_auth package
```

### Backend
```
Node.js + Express (REST API)
├── Auth: Firebase Authentication
├── Database: Firebase Firestore
├── File Storage: Firebase Storage (encrypted)
├── Scheduler: Cloud Functions (cron jobs for recurring messages)
├── Push Notifications: Firebase Cloud Messaging (FCM)
└── Email: SendGrid API
```

### Messaging Integrations
```
Phase 1:  Email (SendGrid) + SMS (Twilio)
Phase 2:  WhatsApp Business API (Meta approval required)
Phase 3:  Facebook Messenger API
```

### Security
```
- End-to-End Encryption: AES-256 for message content
- Messages encrypted at rest in Firestore
- Trusted Contact can NEVER read message content, only trigger delivery
- Biometric lock on app open
- Auto-logout after 5 minutes idle
- Zero-knowledge architecture for The Vault
```

### Database Schema (Firestore Collections)

```
/users/{userId}
  name, email, phone, photoUrl,
  language, country, timezone,
  plan: "free" | "premium",
  planExpiresAt,
  trustedContacts: [userId],
  isDeceased: false,
  deceasedConfirmedAt: null,
  lastCheckIn: timestamp,
  securityPhrase: hashed_string,
  createdAt

/messages/{messageId}
  userId, title,
  type: "immediate" | "recurring" | "occasion" | "milestone",
  contentType: "text" | "voice" | "photo" | "video" | "file",
  contentEncrypted: string,
  mediaUrl: string (encrypted),
  recipients: [{
    recipientId, channel: "whatsapp"|"email"|"sms"
  }],
  schedule: {
    recurringType: "weekly"|"monthly"|"yearly",
    recurringFor: "3months"|"1year"|"forever",
    occasionDate: date,
    milestoneLabel: string
  },
  isDelivered: false,
  deliveryLog: [],
  isPinLocked: false,
  createdAt, updatedAt

/recipients/{recipientId}
  userId, name, relationship,
  photoUrl, language,
  whatsapp, email, phone,
  createdAt

/trustedContacts/{contactId}
  userId (owner),
  contactUserId or externalEmail,
  status: "invited"|"accepted",
  invitedAt, acceptedAt

/triggers/{triggerId}
  userId,
  status: "watching"|"pending_confirmation"|"grace_period"|"confirmed"|"cancelled",
  lastCheckInSent: timestamp,
  checkInDeadline: timestamp,
  confirmationRequestedAt,
  confirmedBy: contactId,
  confirmedAt,
  gracePeriodEndsAt,
  cancelledAt

/deliveryQueue/{jobId}
  messageId, recipientId, channel,
  scheduledFor: timestamp,
  status: "queued"|"sent"|"failed"|"retrying",
  attempts: 0,
  lastAttemptAt,
  sentAt
```

---

## 📱 SCREEN LIST (Full App)

```
Auth Flow
├── Splash
├── Onboarding (x3)
├── Sign Up
├── Sign In
├── Forgot Password
└── Profile Setup

Main App
├── Dashboard (Home)
├── Messages List
│   ├── Message Detail
│   ├── Message Composer (New/Edit)
│   └── Message Preview
├── Recipients
│   ├── Recipients List
│   ├── Add/Edit Recipient
│   └── Recipient Profile
├── The Vault (Premium)
│   ├── Vault Home
│   ├── Digital Will
│   ├── Video Testament
│   └── Credentials Locker
├── Profile & Settings
│   ├── Profile
│   ├── Trusted Contacts
│   ├── Check-in Settings
│   ├── Security (PIN / Biometrics)
│   ├── Subscription & Billing
│   ├── Language & Region
│   └── Help & Support

Trusted Contact View (separate simplified view)
├── TC Dashboard
├── Confirm Passing Screen
└── Status Tracker
```

---

## 🚀 DEVELOPMENT ROADMAP

### Phase 1 — MVP (Month 1–4)
- Auth (Email + Google + Apple)
- Profile + Trusted Contact setup
- Text-only message composer
- Immediate + Recurring message types
- Dead Man's Switch system
- Email + SMS delivery
- Free tier fully functional
- App Store + Play Store submission

### Phase 2 — Growth (Month 5–7)
- Voice + Photo messages
- WhatsApp Business API integration
- Occasion + Milestone message types
- Premium subscription (Stripe / RevenueCat)
- The Vault (basic)
- Push notifications system

### Phase 3 — Scale (Month 8–12)
- Video messages
- Family plan
- Facebook Messenger integration
- AI-assisted message writing (Claude API)
- Full multilingual support (Arabic, English, French, Turkish, Urdu, Indonesian)
- Web app (Flutter Web)
- Analytics dashboard for team

---

## 🌍 LOCALIZATION STRATEGY

- **Launch languages:** English + Arabic (RTL fully supported)
- **Phase 2:** French, Turkish, Urdu
- **Phase 3:** Indonesian, Swahili, Bengali
- All UI strings externalized from day 1
- RTL layout support built into Flutter from the start
- Arabic copy reviewed by native speaker before launch

---

## 📣 MARKETING ANGLE

**Core emotion:** "The people you love the most — have you told them everything you wanted to say?"

**Target channels:**
- Instagram + TikTok (emotional short videos)
- Islamic content creators (huge audience for legacy/afterlife themes)
- Grief counseling communities
- Estate planning blogs and podcasts

**Key differentiators vs competitors:**
- Multilingual + Arabic-first (huge underserved market)
- WhatsApp delivery (dominant in MENA, South Asia, Africa)
- Warm emotional design (not clinical/legal like competitors)
- Recurring messages (not just one-time delivery)
- Family plan

---

## ⚖️ LEGAL & ETHICAL NOTES

- Clear Terms of Service: app is not a legal will substitute
- Privacy Policy: GDPR + PDPA compliant
- Data deletion: user can fully delete account + all messages
- Encrypted storage: company cannot read user messages
- Trusted Contact consent: TC must actively accept the role
- Age restriction: 18+ only

---

## 🤖 AI INTEGRATION (Optional Phase 3)

Use Claude API to offer:
- "Help me write this message" — AI-assisted message drafting
- Tone suggestions ("Make this more loving / more formal")
- Translation of messages to recipient's language
- Summary of all a user's messages for review

Prompt for AI feature:
```
You are a compassionate writing assistant inside Wasiyati, 
a legacy message app. Help the user write a heartfelt message 
to their loved one. Be warm, personal, and human. Never be 
clinical or generic. Ask clarifying questions about the 
relationship and what they want to express before drafting.
Language: {user_language}. Tone: {user_selected_tone}.
```

---

*Built with love. Designed for the words we never said.*
*Wasiyati — وصيتي*
