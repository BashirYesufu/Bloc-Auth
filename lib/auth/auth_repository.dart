class AuthRepository {
  Future<void> login() async {
    try {
        await Future.delayed(Duration(seconds: 3));
    } catch(e){
      throw Exception('Login Failed');
    }
  }
}