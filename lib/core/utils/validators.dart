import 'package:flutter/material.dart';

/// Centralized validation class for CustomTextField.
///
/// Usage:
/// ```dart
/// validator: FieldValidator.of(ValidatorType.email),
/// validator: FieldValidator.of(ValidatorType.required, label: 'Phone'),
/// validator: FieldValidator.confirmPassword(controller: _passwordController),
/// validator: FieldValidator.compose([
///   FieldValidator.required(),
///   FieldValidator.minLength(8),
/// ]),
/// ```

// ─────────────────────────────────────────────────────────────────────────────
// Validator type enum
// ─────────────────────────────────────────────────────────────────────────────

enum ValidatorType {
  /// Field must not be empty.
  required,

  /// Must be a valid email format.
  email,

  /// Must be a valid phone number (BD/international).
  phone,

  /// Minimum character length.
  minLength,

  /// Maximum character length.
  maxLength,

  /// Must contain at least one uppercase letter.
  hasUppercase,

  /// Must contain at least one digit.
  hasDigit,

  /// Must contain at least one special character.
  hasSpecialChar,

  /// Password strength: required + minLength(8) + uppercase + digit.
  password,

  /// Confirm password match — pass [matchController] or [matchValue].
  confirmPassword,

  /// Numeric only (integer or decimal).
  numeric,

  /// URL format.
  url,
}

// ─────────────────────────────────────────────────────────────────────────────
// FieldValidator
// ─────────────────────────────────────────────────────────────────────────────

class FieldValidator {
  FieldValidator._();

  // ── Regex patterns (compiled once, reused) ────────────────────────────────
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _phoneRegex = RegExp(
    r'^(?:\+?88)?01[3-9]\d{8}$|^\+?[1-9]\d{6,14}$',
  );
  static final RegExp _numericRegex = RegExp(r'^\d+(\.\d+)?$');
  static final RegExp _urlRegex = RegExp(
    r'^(https?://)?([\w\-]+\.)+[\w\-]+(/[\w\-._~:/?#\[\]@!$&()*+,;=%]*)?$',
  );
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'\d');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // ── Helper: Format field label ───────────────────────────────────────────
  /// Cleans up label for error messages — strips trailing * and trims prefixes.
  /// e.g. 'Store Name *' → 'Store Name'
  /// e.g. 'Enter your email' → 'Email', 'Enter store name' → 'Store name'
  static String formatLabel(String? label) {
    if (label == null || label.trim().isEmpty) return 'This field';
    final cleaned = label
        .replaceAll(RegExp(r'\s*\*\s*$'), '')
        .replaceAll(RegExp(r'^[Ee]nter\s+(your\s+)?', caseSensitive: false), '')
        .trim();
    if (cleaned.isEmpty) return 'This field';
    return '${cleaned[0].toUpperCase()}${cleaned.substring(1)}';
  }

  // ── Factory: single validator ─────────────────────────────────────────────

  /// Returns a [FormFieldValidator] for the given [ValidatorType].
  ///
  /// Parameters:
  /// - [label]           — field name shown in error messages (e.g. 'Email')
  /// - [minLength]       — used with [ValidatorType.minLength]
  /// - [maxLength]       — used with [ValidatorType.maxLength]
  /// - [matchController] — used with [ValidatorType.confirmPassword] for live matching
  /// - [matchValue]      — static value string for [ValidatorType.confirmPassword]
  /// - [isRequired]      — whether empty input is disallowed for format validators (default: true)
  static String? Function(String?) of(
    ValidatorType type, {
    String? label,
    int? minLength,
    int? maxLength,
    TextEditingController? matchController,
    String? matchValue,
    bool isRequired = true,
  }) {
    final displayLabel = formatLabel(label);

    switch (type) {
      case ValidatorType.required:
        return (value) {
          if (value == null || value.trim().isEmpty) {
            return '$displayLabel is required';
          }
          return null;
        };

      case ValidatorType.email:
        return (value) {
          final trimmed = value?.trim() ?? '';
          if (trimmed.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_emailRegex.hasMatch(trimmed)) {
            return 'Enter a valid email address';
          }
          return null;
        };

      case ValidatorType.phone:
        return (value) {
          final trimmed = value?.trim() ?? '';
          if (trimmed.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_phoneRegex.hasMatch(trimmed)) {
            return 'Enter a valid phone number';
          }
          return null;
        };

      case ValidatorType.minLength:
        final min = minLength ?? 1;
        return (value) {
          if (value == null || value.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (value.length < min) {
            return '$displayLabel must be at least $min characters';
          }
          return null;
        };

      case ValidatorType.maxLength:
        final max = maxLength ?? 999;
        return (value) {
          if (value != null && value.length > max) {
            return '$displayLabel must not exceed $max characters';
          }
          return null;
        };

      case ValidatorType.hasUppercase:
        return (value) {
          if (value == null || value.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_uppercaseRegex.hasMatch(value)) {
            return '$displayLabel must contain at least one uppercase letter';
          }
          return null;
        };

      case ValidatorType.hasDigit:
        return (value) {
          if (value == null || value.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_digitRegex.hasMatch(value)) {
            return '$displayLabel must contain at least one number';
          }
          return null;
        };

      case ValidatorType.hasSpecialChar:
        return (value) {
          if (value == null || value.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_specialCharRegex.hasMatch(value)) {
            return '$displayLabel must contain at least one special character';
          }
          return null;
        };

      case ValidatorType.password:
        return (value) {
          if (value == null || value.isEmpty) return 'Password is required';
          if (value.length < 8) return 'Password must be at least 8 characters';
          return null;
        };

      case ValidatorType.confirmPassword:
        return (value) {
          if (value == null || value.isEmpty)
            return 'Please confirm your password';
          final target = matchController?.text ?? matchValue;
          if (value != target) return 'Passwords do not match';
          return null;
        };

      case ValidatorType.numeric:
        return (value) {
          final trimmed = value?.trim() ?? '';
          if (trimmed.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_numericRegex.hasMatch(trimmed)) {
            return 'Enter a valid number';
          }
          return null;
        };

      case ValidatorType.url:
        return (value) {
          final trimmed = value?.trim() ?? '';
          if (trimmed.isEmpty) {
            return isRequired ? '$displayLabel is required' : null;
          }
          if (!_urlRegex.hasMatch(trimmed)) {
            return 'Enter a valid URL';
          }
          return null;
        };
    }
  }

  // ── Factory: compose multiple validators ──────────────────────────────────

  /// Chains multiple validators — returns the first error found.
  ///
  /// Example:
  /// ```dart
  /// validator: FieldValidator.compose([
  ///   FieldValidator.required(),
  ///   FieldValidator.minLength(8),
  ///   FieldValidator.hasUppercase(),
  /// ]),
  /// ```
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final error = v(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  // ── Quick shorthands ──────────────────────────────────────────────────────

  /// `required` validator with optional label.
  static String? Function(String?) required({String? label}) =>
      of(ValidatorType.required, label: label);

  /// `email` validator.
  static String? Function(String?) email({bool isRequired = true}) =>
      of(ValidatorType.email, isRequired: isRequired);

  /// `phone` validator.
  static String? Function(String?) phone({
    String? label,
    bool isRequired = true,
  }) => of(ValidatorType.phone, label: label, isRequired: isRequired);

  /// `password` strength validator.
  static String? Function(String?) get password => of(ValidatorType.password);

  /// `confirmPassword` validator with live controller matching.
  static String? Function(String?) confirmPassword({
    required TextEditingController controller,
  }) => of(ValidatorType.confirmPassword, matchController: controller);

  /// `minLength` validator.
  static String? Function(String?) minLength(int min, {String? label}) =>
      of(ValidatorType.minLength, minLength: min, label: label);

  /// `maxLength` validator.
  static String? Function(String?) maxLength(int max, {String? label}) =>
      of(ValidatorType.maxLength, maxLength: max, label: label);

  /// `numeric` validator.
  static String? Function(String?) numeric({
    String? label,
    bool isRequired = true,
  }) => of(ValidatorType.numeric, label: label, isRequired: isRequired);

  /// `url` validator.
  static String? Function(String?) url({
    String? label,
    bool isRequired = true,
  }) => of(ValidatorType.url, label: label, isRequired: isRequired);
}
