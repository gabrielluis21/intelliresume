import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/data/datasources/user_remote_datasource.dart';
import 'package:intelliresume/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> saveUser(User user) async {
    await remoteDataSource.saveUser(user);
  }
}
