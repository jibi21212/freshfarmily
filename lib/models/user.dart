enum UserRole {
  buyer,
  farmer,
  deliveryAgent,
}

class User {
  final String id;
  final String name;
  final UserRole role;
  final DateTime created;
  final bool verificationRequired;
  final String _hashedPassword;

  // Public getter for the hashed password if needed.
  String get hashedPassword => _hashedPassword;

  // When creating a new User, you supply a plain text password that is hashed before storing.
  User({
    required this.id,
    required this.name,
    required this.role,
    required this.created,
    required String plainPassword,
  })  : _hashedPassword = _hashPassword(plainPassword),
        verificationRequired = role != UserRole.buyer;

  // Constructor for when you already have a hashed password (e.g., when loading from storage).
  User.withHashedPassword({
    required this.id,
    required this.name,
    required this.role,
    required this.created,
    required String hashedPassword,
    bool? verificationRequired,
  })  : _hashedPassword = hashedPassword,
        verificationRequired = verificationRequired ?? (role != UserRole.buyer);

  // Stub for a real password hashing function.
  // In production, use a secure package like bcrypt or argon2 to hash passwords.
  static String _hashPassword(String plainPassword) {
    // For example, using the bcrypt package:
    // return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    // Here we simply return the plainPassword as a placeholder.
    return plainPassword; // DO NOT use this in production!
  }

  // Method to verify a plain text password against the stored (hashed) password.
  bool verifyPassword(String plainPassword) {
    // In production, use:
    // return BCrypt.checkpw(plainPassword, _hashedPassword);
    return plainPassword == _hashedPassword;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.toString().split('.').last,
      'created': created.toIso8601String(),
      'verificationRequired': verificationRequired,
      'hashedPassword': _hashedPassword,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final roleStr = json['role'] as String;
    UserRole role;
    switch (roleStr) {
      case 'farmer':
        role = UserRole.farmer;
        break;
      case 'deliveryAgent':
        role = UserRole.deliveryAgent;
        break;
      case 'buyer':
      default:
        role = UserRole.buyer;
    }

    return User.withHashedPassword(
      id: json['id'] as String,
      name: json['name'] as String,
      role: role,
      created: DateTime.parse(json['created'] as String),
      hashedPassword: json['hashedPassword'] as String,
      verificationRequired: json['verificationRequired'] as bool? ?? (role != UserRole.buyer),
    );
  }
}