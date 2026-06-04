# Wasiyati — Firebase Setup Guide

## ⚠️ REQUIRED: You must complete these steps before the app will run with Firebase

---

## Step 1: Create Firebase Project

1. Open: **https://console.firebase.google.com**
2. Click **"Add project"**
3. Name: `wasiyati` → Continue
4. Disable Analytics (or enable, your choice) → Create project

---

## Step 2: Add Android App

1. In your project dashboard, click **Android icon** 🤖
2. Package name: **`com.wasiyati.wasiyati`** (exact — check your `app/build.gradle.kts`)
3. App nickname: `Wasiyati Android`
4. Click **Register app**
5. Click **Download google-services.json**
6. Place the file at:
   ```
   wasiyati_app/android/app/google-services.json
   ```
7. Click **Next → Next → Continue to console**

---

## Step 3: Enable Authentication

1. Go to **Authentication** in the left sidebar
2. Click **Get started**
3. Click **Email/Password** → Enable → Save
4. Click **Google** → Enable → Add your support email → Save

---

## Step 4: Enable Firestore

1. Go to **Firestore Database** in the left sidebar
2. Click **Create database**
3. Choose **Start in test mode** (we'll add real rules after)
4. Choose a region (e.g., `europe-west1` or `us-central1`) → Done

---

## Step 5: Enable Storage

1. Go to **Storage** in the left sidebar
2. Click **Get started**
3. Choose **Start in test mode** → Done

---

## Step 6: Fill in firebase_options.dart

1. Go to **Project Settings** (gear icon) → **Your apps** → Your Android app
2. Scroll to **SDK setup and configuration**
3. Open: `wasiyati_app/lib/firebase_options.dart`
4. Replace every value marked `← REPLACE THIS` with your real values

The values you need:
- `apiKey` (Web API key from General tab)
- `appId` (App ID from the Android app section)
- `messagingSenderId` (Cloud Messaging Sender ID)
- `projectId` (usually `wasiyati` or `wasiyati-xxxxx`)
- `storageBucket` (usually `wasiyati.appspot.com` or `wasiyati-xxxxx.appspot.com`)

---

## Step 7: Deploy Firestore Rules (Optional but Recommended)

After finishing testing, replace test mode rules with the real ones:

1. Go to **Firestore → Rules tab**
2. Paste the content from `wasiyati_app/../firestore.rules`
3. Click **Publish**

---

## Step 8: Run the App

```bash
flutter run
```

Sign up with a real email → your user appears in Firebase Console → Authentication ✅
Create a message → check Firestore Console → it appears in real-time ✅
