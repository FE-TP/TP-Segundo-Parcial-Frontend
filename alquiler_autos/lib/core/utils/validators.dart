
class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
  
  static String? minLength(String? value, int minLength) {
    if (value == null || value.length < minLength) {
      return 'Debe tener al menos $minLength caracteres';
    }
    return null;
  }
  
  static String? onlyNumbers(String? value) {
    if (value == null) return null;
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Ingrese solo números';
    }
    return null;
  }
  
  static String? yearRange(String? value, {int? minYear, int? maxYear}) {
    if (value == null || value.isEmpty) return null;
    
    final currentYear = DateTime.now().year;
    final min = minYear ?? 1900;
    final max = maxYear ?? currentYear + 1;
    
    final year = int.tryParse(value);
    if (year == null) {
      return 'Ingrese un año válido';
    }
    
    if (year < min || year > max) {
      return 'El año debe estar entre $min y $max';
    }
    
    return null;
  }
  
  static String? combine(List<String? Function(String?)> validators, String? value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}