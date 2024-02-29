

import '../../model/user.dart';

abstract class DataHelper {
  Future<User> getUser();

  Future<void> saveUser(User user);

 
  //  List<Role> getUserRoles() {
  //   // Example: replace with the actual method to get user roles
  //   // This might involve querying a database or accessing stored data
  //   return /* logic to get user roles */;
  // }
}
