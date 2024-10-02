import '../entities/admin.dart';

abstract class AdminRepository {
  Future<Admin> login(String username, String password);
}
