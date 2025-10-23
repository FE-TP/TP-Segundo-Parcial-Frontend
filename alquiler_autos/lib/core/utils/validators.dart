class Validators {
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  static String? onlyNumbers(String? value) {
    if (value == null || value.isEmpty) return 'Campo obligatorio';
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) return 'Solo se permiten números';
    return null;
  }
}
