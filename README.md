# Luarsekolah

Aplikasi e-learning seluler untuk menambah kelas, mengelola jadwal, dan menerima notifikasi pembelajaran.

---

## Deskripsi Proyek
Luarsekolah adalah aplikasi mobile yang dirancang untuk mempermudah pengalaman e-learning pengguna.  
Fitur utama yang tersedia:

- Registrasi dan login pengguna
- Menambahkan dan mengelola berbagai kelas
- Membuat dan menyimpan catatan materi pembelajaran
- Menerima notifikasi penting terkait jadwal kelas atau materi baru

---

## Teknologi & Dependencies

Proyek ini dikembangkan menggunakan **Flutter** dan **Dart**.

### Dependencies Inti
- Flutter SDK
- Dart

### Framework & UI
- `get`: Manajemen state dan navigasi  
- `google_fonts`: Font kustom  
- `carousel_slider`: Menampilkan konten dalam slide  
- `cupertino_icons`: Ikon gaya iOS  
- `nested_scroll_view_plus`: Pengguliran fleksibel  

### Form & Validasi
- `flutter_form_builder`  
- `form_builder_image_picker`  
- `form_builder_validators`  

### Konektivitas Data
- `http` & `dio`  

### Firebase & Notifikasi
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`  
- `firebase_messaging`, `flutter_local_notifications`  
- `permission_handler`  
- `timezone`  
- `shared_preferences`  

### Gambar
- `image_picker`

---

## Fitur Utama
- **Autentikasi Pengguna**: Login dan Logout dengan Firebase Authentication  
- **Manajemen Kelas**: Tambah dan kelola daftar kelas e-learning  
- **Catatan**: Simpan catatan materi pembelajaran  
- **Notifikasi**: Pemberitahuan real-time melalui Firebase Messaging  

---

## Getting Started

### Prasyarat
- Flutter SDK
- Android Studio atau VS Code
- Firebase project (untuk integrasi fitur tertentu)

### Instalasi, Konfigurasi, Build & Penggunaan
Semua langkah berikut sudah digabung dalam satu code block:

```bash
# Install dependencies
flutter pub get

#Konfigurasi Firebase
# Android: pastikan google-services.json sudah di tempat yang tepat
# iOS: pastikan GoogleService-Info.plist sudah di tempat yang tepat
# Aktifkan Authentication & Cloud Firestore

# Build & Run Project
# Get dependencies (jika belum)
flutter pub get

# Jalankan aplikasi di emulator atau perangkat fisik
flutter run

# Build untuk Android
flutter build apk

# Build untuk iOS
flutter build ios

# Cara Penggunaan
# Registrasi/Login
# Buat akun baru atau login

# -Akses Kelas
# -Lihat daftar kelas di halaman utama

# -Tambah Kelas
# -Tambahkan kelas baru ke daftar

# -Buat Catatan
# -Rekam poin penting materi pembelajaran

# -Dapatkan Notifikasi
# -Izinkan notifikasi untuk reminder kelas & info penting
