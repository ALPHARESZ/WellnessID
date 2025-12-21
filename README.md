# 🩺 WellnessID
**WellnessID** adalah aplikasi mobile berbasis **Flutter** yang dirancang untuk membantu pengguna melakukan **diagnosis awal penyakit** berdasarkan **gejala yang dipilih oleh user**. Aplikasi ini akan menampilkan **hasil diagnosis**, **detail penyakit**, serta **rekomendasi obat** yang relevan. Aplikasi dibangun dengan arsitektur yang terstruktur, menggunakan **Provider** sebagai state management, **Firebase** sebagai backend utama, dan **Firestore** sebagai database.


## 👥 Identity
| Keterangan        | Detail                            |
|-------------------|-----------------------------------|
| **Nama Kelompok** | Kelompok Tricoders                |
| **Nama Project**  | WellnessID                        |
| **Anggota 1**     | Jeremy Alphares Napitupulu        |
| **NIM**           | 231401051                         |
| **Lab**           | 5                                 |
| **Anggota 2**     | Michael Pranata Tarigan           |
| **NIM**           | 231401078                         |
| **Lab**           | 6                                 |
| **Anggota 3**     | Simon Maspero Parluhutan Hutapea  |
| **NIM**           | 231401123                         |
| **Lab**           | 6                                 |


## 🔗 Link SRS (Google Drive)
Dokumen **Software Requirements Specification (SRS)** berisi spesifikasi kebutuhan sistem **WellnessID**, meliputi:
- Ruang lingkup aplikasi
- Kebutuhan fungsional & non-fungsional
- Desain sistem
- Perencanaan pengembangan aplikasi

📄 **Akses dokumen SRS:**  [Google Drive](https://drive.google.com/drive/folders/1bHz5-nfa3nzCEooFZ3mFbb2wR7IpRqSh)


## ✨ Fitur Utama
- 🔐 Login & Register (Firebase Authentication)
- 🔑 Forgot Password
- 👤 Change Username
- 🔒 Change Password
- 📬 Mail Inbox
- 🧠 Diagnose Disease berdasarkan gejala
- 🔍 Search Disease Information
- 💊 Search Medicine Information
- ⭐ Save / Favorite Medicine


## 🛠️ Tech Stack
### Frontend
- Flutter
- Dart
- Provider (State Management)
- go_router (Navigation)
- shared_preferences
- cupertino_icons
### Backend & Services
- Firebase Authentication
- Cloud Firestore (Database)
- Firebase Core
- flutter_launcher_icons


## 🗂️ Project Structure
```
lib/
├── config/                         # Navigation Logic
│   └── routes.dart
├── models/                         # Data Models
│   ├── disease.dart                
│   ├── medicines.dart
│   └── symptom.dart
├── providers/
│   ├── auth_provider.dart
│   └── diagnose_provider.dart
├── screens/                        # UI Screens
│   └── (all UI screens)
├── services/                       # Business Logic
│   ├── auth/
│   │   └── auth_service.dart       # Firebase Authentication
│   ├── diagnose_service.dart       # Firestore Operations
│   ├── disease_service.dart        
│   ├── expert_system_service.dart
│   ├── medicines_service.dart
│   └── symptoms_service.dart
├── utils/                          # Feedback Helper
│   ├── snackbar_helper.dart
│   └── validators.dart
├── widgets/                        # Reusable Component
│   ├── card_list.dart
│   ├── confirmation_popup.dart
│   ├── navigation_bar.dart
│   ├── page_header.dart
│   └── search.dart
└── main.dart                      # App entry point
```

## 📱 Application Screens
### 🔐 Authentication & Profile
| Login | Register | Profile |
|:-----:|:--------:|:-------:|
| <img src="screenshots/Login Screen.png" width="200"> | <img src="screenshots/Register Screen.png" width="200"> | <img src="screenshots/Profile Screen.png" width="200"> |
### 🧠 Core Features
| Home | Diagnose (Symptom) | Diagnose Result |
|:----:|:------------------:|:---------------:|
| <img src="screenshots/Home Screen.png" width="200"> | <img src="screenshots/Symptom Screen.png" width="200"> | <img src="screenshots/Diagnose Result Screen.png" width="200"> |
### 🔍 Detail & Search
| Disease Detail | Medicine Detail | Search Disease |
|:--------------:|:---------------:|:--------------:|
| <img src="screenshots/Disease Detail Screen.png" width="200"> | <img src="screenshots/Medicine Detail Screen.png" width="200"> | <img src="screenshots/Search Disease Screen.png" width="200"> |


## 🔥 Firebase Integration
Aplikasi ini menggunakan **Firebase** sebagai backend utama untuk menangani autentikasi pengguna dan penyimpanan data aplikasi.
### 🔐 Firebase Authentication
Digunakan untuk proses:
- Login pengguna
- Registrasi akun baru
- Manajemen sesi autentikasi pengguna

Firebase Authentication diintegrasikan langsung ke aplikasi Flutter tanpa autentikasi tambahan dari backend pihak ketiga.
### 🗄️ Cloud Firestore
Digunakan sebagai **database utama** untuk:
- Menyimpan data pengguna
- Menyimpan data penyakit
- Menyimpan data gejala
- Menyimpan data obat dan hasil diagnosis

Firestore dipilih karena bersifat **real-time**, scalable, dan terintegrasi langsung dengan Firebase Authentication.
### ⚙️ Konfigurasi Firebase
- Aplikasi **tidak menggunakan file `.env`**
- Seluruh konfigurasi Firebase dilakukan melalui file: `google-services.json`
- File tersebut diletakkan pada direktori: ```android/app/```


## 🚀Get Started
### 1. Clone Repository
```bash
git clone https://github.com/ALPHARESZ/WellnessID.git

cd wellnessid
```
### 2. Install Dependencies
```bash
flutter pub get
```
### 3. Create Firebase Project for Flutter
#### 1️⃣ Buat Project Firebase
1. Buka halaman Firebase Console: [Firebase Console](https://console.firebase.google.com)
2. Klik **Create Project**
3. Masukkan **Project Name** → contoh: `wellnessid-app`
4. Matikan **Google Analytics** (opsional)
5. Klik **Create Project**
#### 2️⃣ Daftarkan Aplikasi Android di Firebase
1. Masuk ke Firebase Project → klik **Add App**
2. Pilih ikon **Android**
3. Isi data berikut:
   - **Android Package Name**  
     Harus sama dengan `namespace` di:
     android/app/build.gradle.kts
   - **App nickname** (opsional)
   - **SHA-1 / SHA-256** (akan ditambahkan setelah digenerate)
4. Klik **Register App**
#### 3️⃣ Download `google-services.json`
Firebase akan menampilkan tombol download.
1. Klik **Download google-services.json**
2. Letakkan file tersebut pada folder:
   ```
   android/app/
   ```
#### 4️⃣ Generate & Tambahkan SHA-1 / SHA-256 ke Firebase
##### Jalankan perintah berikut:
```bash
cd android
./gradlew signingReport
```
##### Output akan menampilkan:
```
SHA1:  XX:XX:XX:XX:...
SHA256: XX:XX:XX:XX:...
```
##### Tambahkan ke Firebase:
Masuk ke:
```
Firebase Console → Project Settings → Android App → SHA Certificate Fingerprints
```
Tambahkan:
- SHA-1
- SHA-256

**Setelah menambah SHA, download ulang file `google-services.json`**  
dan replace file lama di:
```
android/app/
```
#### 5️⃣ Konfigurasi Firebase pada Android
##### Edit file:
```
android/settings.gradle.kts
```

Tambahkan pada bagian `plugins`:
```
id("com.google.gms.google-services") version("4.3.15") apply false
```
##### Edit file:
```
android/app/build.gradle.kts
```
Tambahkan pada bagian `plugins`:
```
id("com.google.gms.google-services")
```
### 4. Integrate Firebase to Flutter
Install plugin:
```bash
flutter pub add firebase_core; flutter pub add firebase_auth; flutter pub add google_sign_in; flutter pub add cloud_firestore;
```
Inisialisasi Firebase pada file `main.dart`
### 5. Run The App
#### Run App
```bash
flutter run
```
Aplikasi WellnessID siap digunakan 🎉