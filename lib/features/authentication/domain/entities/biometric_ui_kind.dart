enum BiometricUiKind {
  face,
  touch,
  combined;

  String get promptTitle => switch (this) {
        face => 'Face ID',
        touch => 'Touch ID',
        combined => 'Touch ID / Face ID',
      };

  String get enableScreenTitle => 'Enable $promptTitle';

  String get continueWithLabel => switch (this) {
        face => 'Continue with Face ID',
        touch => 'Continue with Touch ID',
        combined => 'Continue with Touch ID / Face ID',
      };
}
