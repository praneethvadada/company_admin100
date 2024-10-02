import '../repositories/admin_repository.dart';
import '../entities/admin.dart';

class LoginUseCase {
  final AdminRepository repository;

  LoginUseCase(this.repository);

  Future<Admin> login(String username, String password) async {
    return await repository.login(username, password);
  }
}
