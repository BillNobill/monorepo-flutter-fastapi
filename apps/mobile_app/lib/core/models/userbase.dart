class UserBase {
  final String? email;
  final bool? is_active;
  final String? full_name;

  UserBase({
    this.email, this.is_active, this.full_name,
  });

  factory UserBase.fromJson(Map<String, dynamic> json) {
    return UserBase(
      email: json['email'] as String?,
      is_active: json['is_active'] as bool?,
      full_name: json['full_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'is_active': is_active,
    'full_name': full_name,
  };
}
