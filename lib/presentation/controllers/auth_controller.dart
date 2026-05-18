import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/repositories/i_auth_repository.dart';

class AuthController extends GetxController {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final IAuthRepository repository; 

  AuthController({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.repository,
  });

  var isLoading = false.obs;
  var user = Rxn<UserEntity>(); // State reaktif untuk profil & role

  @override
  void onInit() {
    super.onInit();
    fetchUserRole(); // Cek role saat aplikasi pertama kali dibuka
  }

  // PERBAIKAN 1: Membungkus fungsi dengan try-catch agar aman dari crash Firebase
  Future<void> fetchUserRole() async {
    try {
      final data = await repository.getCurrentUserData();
      user.value = data;
      print("INFO AUTH: Berhasil memuat data user. Role saat ini = ${data?.role}");
    } catch (e) {
      // Jika terjadi error (misal token expired / permission denied), aplikasi tidak akan crash
      print("ERROR AUTH: Gagal mengambil data user dari Firestore: $e");
      user.value = null; 
    }
  }

  // Getter reaktif yang dipantau oleh Obx di ClassScreen
  bool get isAdmin => user.value?.role == 'admin';

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      user.value = null; // Reset data user lama sebelum mendaftar
      
      await registerUseCase.execute(name: name, email: email, password: password, phone: phone);
      await fetchUserRole(); // Ambil role baru setelah daftar sukses
      
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      user.value = null; // PERBAIKAN 2: Reset data user lama agar tidak tersangkut cache session sebelumnya
      
      await loginUseCase.execute(email: email, password: password);
      await fetchUserRole(); // Ambil data role yang segar dari Firestore setelah sukses login
      
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // TAMBAHAN: Fungsi Logout agar sinkron saat kamu mau reset session
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await logoutUseCase.execute();
      user.value = null; // Kosongkan data setelah logout
      Get.offAllNamed('/login'); // Arahkan kembali ke halaman login kamu
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}