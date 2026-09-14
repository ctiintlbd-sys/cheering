import '../../../../core/utils/assets/assets.gen.dart';
import '../../domain/entities/biometric_ui_kind.dart';

extension BiometricUiKindAssets on BiometricUiKind {
  SvgGenImage get icon =>
      this == BiometricUiKind.face ? Assets.icons.face : Assets.icons.touch;
}
