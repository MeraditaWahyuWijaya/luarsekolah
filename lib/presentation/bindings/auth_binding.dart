import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/firebase_auth_service.dart';
import 'package:luarsekolah/data/repositories/auth_repository.dart';
import 'package:luarsekolah/domain/usecases/register_usecase.dart';
import 'package:luarsekolah/domain/usecases/login_usecase.dart';
import 'package:luarsekolah/domain/usecases/logout_usecase.dart';
import 'package:luarsekolah/presentation/controllers/auth_controller.dart';
import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';

//Inject AuthController + usecase
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Service
    Get.lazyPut(() => FirebaseAuthService());

    // Repository
    Get.lazyPut<IAuthRepository>( 
      () => AuthRepository(Get.find<FirebaseAuthService>())
    );
    // Usecases
   Get.lazyPut(() => RegisterUseCase(Get.find<IAuthRepository>()));
    Get.lazyPut(() => LoginUseCase(Get.find<IAuthRepository>()));
    Get.lazyPut(() => LogoutUseCase(Get.find<IAuthRepository>()));

    // Controller
    Get.lazyPut(() => AuthController(
          registerUseCase: Get.find(),
          loginUseCase: Get.find(),
          logoutUseCase: Get.find(),
        ));
  }
}
