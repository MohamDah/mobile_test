import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/firestore_user_datasource.dart';
import '../models/user_model.dart';

/// Concrete implementation of [UserRepository] backed by Firestore.
class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._dataSource);

  final FirestoreUserDataSource _dataSource;

  @override
  Future<void> createUserDocument(UserEntity user) =>
      _dataSource.createUserDocument(UserModel.fromEntity(user));

  @override
  Stream<UserEntity?> getUserStream(String uid) =>
      _dataSource.getUserStream(uid);

  @override
  Future<UserEntity?> getUser(String uid) => _dataSource.getUser(uid);

  @override
  Future<void> saveGym(String uid, String gymId) =>
      _dataSource.saveGym(uid, gymId);

  @override
  Future<void> unsaveGym(String uid, String gymId) =>
      _dataSource.unsaveGym(uid, gymId);
}
