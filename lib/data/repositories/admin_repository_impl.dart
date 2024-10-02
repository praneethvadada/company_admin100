import '../data_sources/remote_data_source.dart';
import '../models/admin_model.dart';
import '../../domain/entities/admin.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final RemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<Admin> login(String username, String password) async {
    // Fetch the admin model from the API
    AdminModel adminModel = await remoteDataSource.login(username, password);

    // Convert the AdminModel to Admin and return it
    return Admin(
      id: adminModel.id,
      username: adminModel.username,
      token: adminModel.token,
    );
  }
}
