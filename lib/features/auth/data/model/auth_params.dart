class AuthParams {
  final String name;
  final String email;
  final String password;
  final String? specialization;

  AuthParams({
    required this.name,
    required this.email,
    required this.password,
    this.specialization,
  });
}
