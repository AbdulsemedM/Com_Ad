import '../../model/roles.dart';
import '../../model/user.dart';

abstract class SessionRepo {
  Future<User> getUser();
}
