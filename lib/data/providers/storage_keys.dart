class StorageKeys {
  //Key-key untuk local storage
 // KUNCI UTAMA OTENTIKASI DAN STATUS
 static const String rememberMe = 'rememberMe';
 static const String isLoggedIn = 'isLoggedIn'; // Kunci ini diperlukan

 // KUNCI DATA WAJIB
 static const String userEmail = 'userEmail';
 static const String userName = 'userName';
 static const String userPhone = 'userPhone'; // Dihapus duplikasi 'userPhone'

 // KUNCI DATA PROFIL TAMBAHAN (Diperlukan oleh ProfileFormScreen)
 static const String userAddress = 'userAddress';
 static const String userGender = 'userGender';
 static const String userJobStatus = 'userJobStatus';
 static const String userDOB = 'userDOB'; // Date of Birth
static const userPassword = 'user_password';
static const String accessToken = 'auth_access_token'; 
static const String userProfilePhoto = 'user_profile_photo';

 // Tambahkan konstanta lain jika diperlukan di masa depan
 // static const String userId = 'userId';
}