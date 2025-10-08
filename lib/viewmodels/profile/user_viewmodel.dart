
class UserViewModel {
  final int id;
  String name;
  String email;
  String password;
  String? photoUrl;

  UserViewModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.photoUrl,
  });
}
