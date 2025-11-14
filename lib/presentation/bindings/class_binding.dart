import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/api_service.dart';
import 'package:luarsekolah/data/repositories/class_repository.dart';
import 'package:luarsekolah/domain/repositories/i_class_repository.dart';
import 'package:luarsekolah/domain/usecases/get_filtered_classes_use_case.dart';
import 'package:luarsekolah/presentation/controllers/class_controllers.dart';

class ClassBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService());

    Get.lazyPut<IClassRepository>(
      () => ClassRepository(Get.find<ApiService>()),
    );

    Get.lazyPut<GetFilteredClassesUseCase>(
      () => GetFilteredClassesUseCase(Get.find<IClassRepository>()),
    );

    Get.lazyPut<ClassController>(
      () => ClassController(
        Get.find<GetFilteredClassesUseCase>(),
        Get.find<IClassRepository>(),
      ),
    );
  }
}
