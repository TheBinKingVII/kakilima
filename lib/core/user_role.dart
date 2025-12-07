enum UserRole {
  customer,
  vendor,
}

extension UserRoleExtension on UserRole {
  String get value => switch (this) {
        UserRole.customer => 'customer',
        UserRole.vendor => 'vendor',
      };

  static UserRole fromValue(String value) => switch (value) {
        'customer' => UserRole.customer,
        'vendor' => UserRole.vendor,
        _ => UserRole.customer,
      };
}