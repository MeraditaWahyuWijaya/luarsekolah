import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';


//diusecase itu isinya turan buat proses registrasi 
//disini cuman nerima perintah dari controller dan panggil repo interface
class RegisterUseCase {
  final IAuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> execute({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
