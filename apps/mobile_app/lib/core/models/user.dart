class User {
  final String? email;
  final bool? is_active;
  final String? full_name;
  final int id;

  User({
    this.email, this.is_active, this.full_name, required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String?,
      is_active: json['is_active'] as bool?,
      full_name: json['full_name'] as String?,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'is_active': is_active,
    'full_name': full_name,
    'id': id,
  };
}
