abstract class LoginRepo {
  Future<String> login(String email, String password);
  Future<bool> requestPasswordReset(String emailOrPhone);
  Future<bool> confirmPasswordReset(String emailOrPhone, String token, String newPassword);
}
