class RoleManager {
  static const String roleCitizen = 'CITIZEN';
  static const String roleMp = 'MP';
  static const String roleAdmin = 'ADMIN';

  bool isCitizen(String role) => role.toUpperCase() == roleCitizen;
  bool isMp(String role) => role.toUpperCase() == roleMp;
  bool isAdmin(String role) => role.toUpperCase() == roleAdmin;

  bool hasAccess(String currentRole, List<String> allowedRoles) {
    return allowedRoles.map((r) => r.toUpperCase()).contains(currentRole.toUpperCase());
  }
}
