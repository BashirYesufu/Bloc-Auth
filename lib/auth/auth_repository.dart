class AuthRepository {
  Future<void> login() async {
    Future.delayed(Duration(seconds: 10));
    print('logged in');
  }
}