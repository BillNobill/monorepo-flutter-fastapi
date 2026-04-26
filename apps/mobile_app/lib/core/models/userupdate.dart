class UserUpdate {
  final String? email;
  final bool? is_active;
  final String? full_name;
  final String? password;

  UserUpdate({
    this.email, this.is_active, this.full_name, this.password,
  });

  factory UserUpdate.fromJson(Map<String, dynamic> json) {
    return UserUpdate(
      email: json['email'] as String?,
      is_active: json['is_active'] as bool?,
      full_name: json['full_name'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'is_active': is_active,
    'full_name': full_name,
    'password': password,
  };
}
