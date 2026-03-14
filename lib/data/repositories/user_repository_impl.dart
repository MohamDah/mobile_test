// TODO(Person4): Implement this fully.
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/firestore_user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dataSource);
  final FirestoreUserDataSource _dataSource;

  @override
  Stream<UserEntity?> getUserStream(String userId) => const Stream.empty();

  @override
  Future<void> saveGym({required String userId, required String gymId}) =>
      throw UnimplementedError('TODO(Person4)');

  @override
  Future<void> unsaveGym({required String userId, required String gymId}) =>
      throw UnimplementedError('TODO(Person4)');
}
