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
  final IAuthRepository repository; // Tambahkan ini untuk ambil data profile

  AuthController({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.repository,
  });

  var isLoading = false.obs;
  var user = Rxn<UserEntity>(); // State untuk simpan profil & role

  @override
  void onInit() {
    super.onInit();
    fetchUserRole(); // Cek role saat aplikasi dibuka
  }

  // Fungsi untuk ambil role dari repository
  Future<void> fetchUserRole() async {
    user.value = await repository.getCurrentUserData();
  }

  // Getter untuk cek apakah dia admin
  bool get isAdmin => user.value?.role == 'admin';

  Future<void> register({required String name, required String email, required String password, required String phone}) async {
    try {
      isLoading.value = true;
      await registerUseCase.execute(name: name, email: email, password: password, phone: phone);
      await fetchUserRole(); // Ambil role setelah daftar
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
      await loginUseCase.execute(email: email, password: password);
      await fetchUserRole(); // Ambil role setelah login
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}