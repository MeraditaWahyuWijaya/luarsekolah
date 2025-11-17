import 'package:get/get.dart';
import 'package:luarsekolah/domain/usecases/register_usecase.dart';
import 'package:luarsekolah/domain/usecases/login_usecase.dart';
import 'package:luarsekolah/domain/usecases/logout_usecase.dart';

class AuthController extends GetxController {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthController({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  });

  var isLoading = false.obs;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      await registerUseCase.execute(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await loginUseCase.execute(email: email, password: password);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await logoutUseCase.execute();
    } finally {
      isLoading.value = false;
    }
  }
}
