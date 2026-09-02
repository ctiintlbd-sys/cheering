import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';

/// Ultra-smooth, fully customizable, theme-reactive CustomTextField.
///
/// Constructors:
///   • [CustomTextField]          — normal text input (default: required validation)
///   • [CustomTextField.password] — obscure text with toggle eye icon
///   • [CustomTextField.menuShow] — tap-to-open dropdown with arrow icon
///
/// Validation Defaults:
///   • By default, [CustomTextField] has `validatorType: ValidatorType.required`.
///   • Auto-derives error label from `validatorLabel` -> `labelText` -> `hintText`.
///   • To make a field **OPTIONAL**, pass `validatorType: null`.
///
/// Examples:
/// ```dart
/// // 1. Default (Required field — label derived automatically)
/// CustomTextField(
///   labelText: 'Store Name *',
///   hintText: 'Enter store name',
/// )
///
/// // 2. Optional field — just pass validatorType: null
/// CustomTextField(
///   labelText: 'Additional Notes',
///   validatorType: null,
/// )
///
/// // 3. Specific validator type (e.g. Email)
/// CustomTextField(
///   labelText: 'Email',
///   validatorType: ValidatorType.email,
/// )
/// ```

class CustomTextField extends StatefulWidget {
  // ─────────────────────────── Default constructor ────────────────────────────
  const CustomTextField({
    super.key,
    this.controller,
    // Label
    this.labelText,
    this.labelColor,
    this.labelSize = 14,
    this.labelWeight = FontWeight.w500,
    this.labelBottom = 6,
    // Hint
    this.hintText,
    this.hintColor,
    this.hintSize = 14,
    this.hintWeight = FontWeight.w400,
    // Text
    this.textColor,
    this.textSize = 14,
    this.textWeight = FontWeight.w400,
    this.fontFamily,
    this.cursorColor,
    // Colors & Border
    this.fillColor,
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.focusBorderWidth = 1.5,
    this.borderRadius = 10,
    this.border,
    // Padding
    this.contentPaddingHorizontal = 16,
    this.contentPaddingVertical = 14,
    this.contentPadding,
    // Icons
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    // Keyboard & Actions
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.validatorType = ValidatorType.required, // Default: Required
    this.validatorLabel,
    this.validatorMinLength,
    this.validatorMaxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    // State & Focus
    this.focusNode,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.maxLines,
    this.minLines,
  })  : _mode = _FieldMode.normal,
        isObscureText = false,
        obscuringCharacter = '•',
        menuItems = const [],
        onMenuItemSelected = null,
        isMultiSelect = false,
        selectedItems = const [],
        onMultiSelectionChanged = null,
        menuItemBuilder = null,
        dropdownMaxHeight = 220,
        dropdownElevation = 4,
        dropdownBorderRadius = 10,
        dropdownWidth = null;

  // ─────────────────────────── Password constructor ───────────────────────────
  const CustomTextField.password({
    super.key,
    this.controller,
    // Label
    this.labelText,
    this.labelColor,
    this.labelSize = 14,
    this.labelWeight = FontWeight.w500,
    this.labelBottom = 6,
    // Hint
    this.hintText,
    this.hintColor,
    this.hintSize = 14,
    this.hintWeight = FontWeight.w400,
    // Text
    this.textColor,
    this.textSize = 14,
    this.textWeight = FontWeight.w400,
    this.fontFamily,
    this.cursorColor,
    this.obscuringCharacter = '•',
    // Colors & Border
    this.fillColor,
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.focusBorderWidth = 1.5,
    this.borderRadius = 10,
    this.border,
    // Padding
    this.contentPaddingHorizontal = 16,
    this.contentPaddingVertical = 14,
    this.contentPadding,
    // Icons
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    // Keyboard & Actions
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.validatorType = ValidatorType.password, // Default: Password
    this.validatorLabel,
    this.validatorMinLength,
    this.validatorMaxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    // State & Focus
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
  })  : _mode = _FieldMode.password,
        isObscureText = true,
        suffixIcon = null,
        keyboardType = TextInputType.visiblePassword,
        readOnly = false,
        maxLength = null,
        maxLines = null,
        minLines = null,
        menuItems = const [],
        onMenuItemSelected = null,
        isMultiSelect = false,
        selectedItems = const [],
        onMultiSelectionChanged = null,
        menuItemBuilder = null,
        dropdownMaxHeight = 220,
        dropdownElevation = 4,
        dropdownBorderRadius = 10,
        dropdownWidth = null;

  // ─────────────────────────── MenuShow constructor ───────────────────────────
  const CustomTextField.menuShow({
    super.key,
    this.controller,
    // Label
    this.labelText,
    this.labelColor,
    this.labelSize = 14,
    this.labelWeight = FontWeight.w500,
    this.labelBottom = 6,
    // Hint
    this.hintText,
    this.hintColor,
    this.hintSize = 14,
    this.hintWeight = FontWeight.w400,
    // Text
    this.textColor,
    this.textSize = 14,
    this.textWeight = FontWeight.w400,
    this.fontFamily,
    this.cursorColor,
    // Colors & Border
    this.fillColor,
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.focusBorderWidth = 1.5,
    this.borderRadius = 10,
    this.border,
    // Padding
    this.contentPaddingHorizontal = 16,
    this.contentPaddingVertical = 14,
    this.contentPadding,
    // Icons
    this.prefixIcon,
    this.prefixIconConstraints,
    // Dropdown specific
    required this.menuItems,
    this.onMenuItemSelected,
    this.isMultiSelect = false,
    this.selectedItems = const [],
    this.onMultiSelectionChanged,
    this.menuItemBuilder,
    this.dropdownMaxHeight = 220,
    this.dropdownElevation = 4,
    this.dropdownBorderRadius = 10,
    this.dropdownWidth,
    // Validation
    this.validator,
    this.validatorLabel,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    // State & Focus
    this.focusNode,
    this.enabled = true,
  })  : _mode = _FieldMode.menu,
        isObscureText = false,
        obscuringCharacter = '•',
        suffixIcon = null,
        suffixIconConstraints = null,
        keyboardType = TextInputType.none,
        textInputAction = null,
        inputFormatters = null,
        onFieldSubmitted = null,
        onTap = null,
        readOnly = true,
        autofocus = false,
        maxLength = null,
        maxLines = 1,
        minLines = 1,
        validatorType = null,
        validatorMinLength = null,
        validatorMaxLength = null;

  // ─────────────────────────── Shared fields ──────────────────────────────────
  final _FieldMode _mode;
  final TextEditingController? controller;

  // Label
  final String? labelText;
  final Color? labelColor;
  final double labelSize;
  final FontWeight labelWeight;
  final double labelBottom;

  // Hint
  final String? hintText;
  final Color? hintColor;
  final double hintSize;
  final FontWeight hintWeight;

  // Text
  final Color? textColor;
  final double textSize;
  final FontWeight textWeight;
  final String? fontFamily;
  final Color? cursorColor;

  // Colors & Border
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? errorBorderColor;
  final double borderWidth;
  final double focusBorderWidth;
  final double borderRadius;
  final InputBorder? border;

  // Padding
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final EdgeInsetsGeometry? contentPadding;

  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;

  // Obscure
  final bool isObscureText;
  final String obscuringCharacter;

  // Keyboard & Actions
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  // Validation
  final FormFieldValidator<String>? validator;
  final ValidatorType? validatorType;
  final String? validatorLabel;
  final int? validatorMinLength;
  final int? validatorMaxLength;
  final AutovalidateMode autovalidateMode;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  // State & Focus
  final FocusNode? focusNode;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;

  // Menu / Dropdown
  final List<String> menuItems;
  final ValueChanged<String>? onMenuItemSelected;
  final bool isMultiSelect;
  final List<String> selectedItems;
  final ValueChanged<List<String>>? onMultiSelectionChanged;
  final Widget Function(BuildContext context, String item, bool isSelected)? menuItemBuilder;
  final double dropdownMaxHeight;
  final double dropdownElevation;
  final double dropdownBorderRadius;
  final double? dropdownWidth;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal mode enum
// ─────────────────────────────────────────────────────────────────────────────

enum _FieldMode { normal, password, menu }

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  // ── Password ──────────────────────────────────────────────────
  late bool _obscureText;

  // ── Controller ────────────────────────────────────────────────
  TextEditingController? _fallbackController;
  TextEditingController get _effectiveController =>
      widget.controller ?? _fallbackController!;

  // ── Menu / Dropdown ───────────────────────────────────────────
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;
  String? _selectedItem;
  List<String> _selectedItems = [];
  AnimationController? _arrowAnimController;
  Animation<double>? _arrowAnimation;

  bool get _isMenu => widget._mode == _FieldMode.menu;
  bool get _isPassword => widget._mode == _FieldMode.password;

  // ── Cached font ───────────────────────────────────────────────
  late String _effectiveFont;

  @override
  void initState() {
    super.initState();
    _obscureText = _isPassword || widget.isObscureText;
    _effectiveFont = widget.fontFamily ?? FontFamily.sFPro;

    if (widget.controller == null) {
      _fallbackController = TextEditingController();
    }

    if (widget.isMultiSelect) {
      _selectedItems = List.from(widget.selectedItems);
      if (_selectedItems.isNotEmpty && _effectiveController.text.isEmpty) {
        _effectiveController.text = _selectedItems.join(', ');
      }
    }

    if (_isMenu) {
      _arrowAnimController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
      );
      _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _arrowAnimController!, curve: Curves.easeOut),
      );
    }
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Controller swap
    if (widget.controller != oldWidget.controller) {
      if (widget.controller == null && _fallbackController == null) {
        _fallbackController = TextEditingController();
      } else if (widget.controller != null && _fallbackController != null) {
        _fallbackController!.dispose();
        _fallbackController = null;
      }
    }
    // Font cache update
    if (widget.fontFamily != oldWidget.fontFamily) {
      _effectiveFont = widget.fontFamily ?? FontFamily.sFPro;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _fallbackController?.dispose();
    _arrowAnimController?.dispose();
    super.dispose();
  }

  // ── Password toggle ───────────────────────────────────────────
  void _togglePasswordVisibility() =>
      setState(() => _obscureText = !_obscureText);

  // ── Dropdown logic ────────────────────────────────────────────
  void _toggleMenu() => _isMenuOpen ? _closeMenu() : _openMenu();

  void _openMenu() {
    if (!_isMenu || !mounted) return;
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _arrowAnimController?.forward();
    setState(() => _isMenuOpen = true);
  }

  void _closeMenu() {
    if (!_isMenu || !mounted) return;
    _removeOverlay();
    _arrowAnimController?.reverse();
    setState(() => _isMenuOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(String item) {
    if (!mounted) return;
    setState(() {
      _selectedItem = item;
      _effectiveController.text = item;
    });
    widget.onMenuItemSelected?.call(item);
    widget.onChanged?.call(item);
    _closeMenu();
  }

  void _selectMultiItem(List<String> items) {
    if (!mounted) return;
    setState(() {
      _selectedItems = List.from(items);
      _effectiveController.text = _selectedItems.join(', ');
    });
    widget.onMultiSelectionChanged?.call(_selectedItems);
    widget.onChanged?.call(_selectedItems.join(', '));
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final effectiveWidth = widget.dropdownWidth ?? size.width;
    final horizontalOffset = (widget.dropdownWidth != null && widget.dropdownWidth! > size.width)
        ? -(widget.dropdownWidth! - size.width)
        : 0.0;

    return OverlayEntry(
      maintainState: false,
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeMenu,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(horizontalOffset, size.height + 4.h),
            child: Material(
              color: Colors.transparent,
              child: _DropdownMenu(
                items: widget.menuItems,
                selectedItem: _selectedItem,
                selectedItems: _selectedItems,
                isMultiSelect: widget.isMultiSelect,
                width: effectiveWidth,
                maxHeight: widget.dropdownMaxHeight.h,
                elevation: widget.dropdownElevation,
                borderRadius: widget.dropdownBorderRadius.r,
                itemBuilder: widget.menuItemBuilder,
                onSelected: _selectItem,
                onMultiSelected: _selectMultiItem,
                fillColor: widget.fillColor,
                borderColor: widget.borderColor,
                textSize: widget.textSize,
                textWeight: widget.textWeight,
                fontFamily: _effectiveFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Resolve validator ─────────────────────────────────────────
  //
  // Priority:
  // 1. Custom widget.validator
  // 2. widget.validatorType (Defaults to ValidatorType.required)
  // 3. Menu mode auto required fallback
  FormFieldValidator<String>? get _resolvedValidator {
    // 1. Explicit custom validator — highest priority
    if (widget.validator != null) return widget.validator;

    // Auto derive label: validatorLabel -> labelText -> hintText
    final effectiveLabel = widget.validatorLabel ??
        widget.labelText ??
        widget.hintText;

    // 2. validatorType param — auto build from FieldValidator
    if (widget.validatorType != null) {
      return FieldValidator.of(
        widget.validatorType!,
        label: effectiveLabel,
        minLength: widget.validatorMinLength,
        maxLength: widget.validatorMaxLength,
      );
    }

    // 3. Menu mode default — required if no validator provided
    if (_isMenu) {
      return (value) {
        if (value == null || value.trim().isEmpty) {
          final displayLabel = FieldValidator.formatLabel(effectiveLabel);
          return 'Please select $displayLabel';
        }
        return null;
      };
    }

    return null;
  }

  // ── Build ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveRadius = BorderRadius.circular(widget.borderRadius.r);
    final defaultBorderColor = widget.borderColor ?? colors.borderSecondary;
    final defaultFillColor = widget.fillColor ?? colors.bgSecondary;
    final defaultHintColor = widget.hintColor ?? colors.textPlaceholder;

    final enabledBorder = widget.border ??
        OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(color: defaultBorderColor, width: widget.borderWidth),
        );
    final focusedBorder = widget.border ??
        OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(
            color: widget.focusBorderColor ?? defaultBorderColor,
            width: widget.focusBorderWidth,
          ),
        );
    final errorBorder = widget.border ??
        OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(
            color: widget.errorBorderColor ?? colors.error,
            width: widget.borderWidth,
          ),
        );

    // ── Suffix icon ───────────────────────────────────────────
    Widget? resolvedSuffix;
    if (_isPassword) {
      resolvedSuffix = _PasswordToggleButton(
        isObscured: _obscureText,
        iconColor: colors.iconSecondary,
        onPressed: _togglePasswordVisibility,
      );
    } else if (_isMenu && _arrowAnimation != null) {
      resolvedSuffix = Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: RotationTransition(
          turns: _arrowAnimation!,
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.iconSecondary,
            size: 22.r,
          ),
        ),
      );
    } else {
      resolvedSuffix = widget.suffixIcon;
    }

    // ── Content padding ───────────────────────────────────────
    final contentPadding = widget.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal.w,
          vertical: widget.contentPaddingVertical.h,
        );

    // ── Prefix icon ───────────────────────────────────────────
    final prefixIconConstraints = widget.prefixIconConstraints ??
        BoxConstraints(minWidth: 40.w, minHeight: 24.h);

    final resolvedPrefixIcon = widget.prefixIcon != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: widget.prefixIcon,
          )
        : null;

    // ── Core field ────────────────────────────────────────────
    final field = TextFormField(
      controller: _effectiveController,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      readOnly: _isMenu ? true : widget.readOnly,
      maxLength: widget.maxLength,
      keyboardType: _isMenu ? TextInputType.none : widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      obscureText: _obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      autovalidateMode: widget.autovalidateMode,
      minLines: _isMenu ? 1 : (_isPassword ? 1 : widget.minLines),
      maxLines: _isMenu ? 1 : (_isPassword ? 1 : widget.maxLines),
      cursorColor: widget.cursorColor ?? colors.textPrimary,
      cursorWidth: 1.5,
      onTap: _isMenu ? _toggleMenu : widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: _resolvedValidator,
      style: TextStyle(
        color: widget.textColor ?? colors.textPrimary,
        fontSize: widget.textSize.sp,
        fontFamily: _effectiveFont,
        fontWeight: widget.textWeight,
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: defaultFillColor,
        counterText: '',
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: defaultHintColor,
          fontSize: widget.hintSize.sp,
          fontFamily: _effectiveFont,
          fontWeight: widget.hintWeight,
          overflow: TextOverflow.ellipsis,
        ),
        contentPadding: contentPadding,
        prefixIcon: resolvedPrefixIcon,
        prefixIconConstraints: prefixIconConstraints,
        suffixIcon: resolvedSuffix,
        suffixIconConstraints: _isPassword
            ? null
            : (widget.suffixIconConstraints ??
                BoxConstraints(minWidth: 40.w, minHeight: 24.h)),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: enabledBorder,
        border: enabledBorder,
        errorStyle: TextStyle(
          color: colors.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontFamily: _effectiveFont,
        ),
      ),
    );

    // ── Label + field column ──────────────────────────────────
    final contentWidget = widget.labelText != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: widget.labelText!,
                fontSize: widget.labelSize.sp,
                fontWeight: widget.labelWeight,
                color: widget.labelColor ?? colors.textPrimary,
                bottom: widget.labelBottom.h,
              ),
              field,
            ],
          )
        : field;

    if (_isMenu) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: contentWidget,
      );
    }

    return contentWidget;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Password toggle button
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordToggleButton extends StatelessWidget {
  const _PasswordToggleButton({
    required this.isObscured,
    required this.iconColor,
    required this.onPressed,
  });

  final bool isObscured;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: iconColor,
        size: 20.r,
      ),
      onPressed: onPressed,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dropdown overlay widget
// ─────────────────────────────────────────────────────────────────────────────

class _DropdownMenu extends StatefulWidget {
  const _DropdownMenu({
    required this.items,
    required this.selectedItem,
    required this.selectedItems,
    required this.isMultiSelect,
    required this.width,
    required this.maxHeight,
    required this.elevation,
    required this.borderRadius,
    required this.onSelected,
    required this.onMultiSelected,
    required this.textSize,
    required this.textWeight,
    required this.fontFamily,
    this.itemBuilder,
    this.fillColor,
    this.borderColor,
  });

  final List<String> items;
  final String? selectedItem;
  final List<String> selectedItems;
  final bool isMultiSelect;
  final double width;
  final double maxHeight;
  final double elevation;
  final double borderRadius;
  final ValueChanged<String> onSelected;
  final ValueChanged<List<String>> onMultiSelected;
  final Widget Function(BuildContext, String, bool)? itemBuilder;
  final Color? fillColor;
  final Color? borderColor;
  final double textSize;
  final FontWeight textWeight;
  final String fontFamily;

  @override
  State<_DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<_DropdownMenu> {
  late List<String> _currentMultiSelected;

  @override
  void initState() {
    super.initState();
    _currentMultiSelected = List.from(widget.selectedItems);
  }

  void _onItemTapped(String item) {
    if (widget.isMultiSelect) {
      setState(() {
        if (_currentMultiSelected.contains(item)) {
          _currentMultiSelected.remove(item);
        } else {
          _currentMultiSelected.add(item);
        }
      });
      widget.onMultiSelected(_currentMultiSelected);
    } else {
      widget.onSelected(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: widget.width,
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 17,
          ),
        ],
        color: colors.background,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor ?? colors.borderTertiary),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: widget.items.isEmpty
            ? Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'No options available',
                  style: TextStyle(
                    color: colors.textPlaceholder,
                    fontSize: widget.textSize.sp,
                    fontFamily: widget.fontFamily,
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: colors.borderTertiary,
                ),
                itemBuilder: (ctx, index) {
                  final item = widget.items[index];
                  final isSelected = widget.isMultiSelect
                      ? _currentMultiSelected.contains(item)
                      : item == widget.selectedItem;

                  if (widget.itemBuilder != null) {
                    return GestureDetector(
                      onTap: () => _onItemTapped(item),
                      child: widget.itemBuilder!(ctx, item, isSelected),
                    );
                  }

                  return _DefaultMenuItem(
                    item: item,
                    isSelected: isSelected,
                    textSize: widget.textSize,
                    textWeight: widget.textWeight,
                    fontFamily: widget.fontFamily,
                    onTap: () => _onItemTapped(item),
                  );
                },
              ),
      ),
    );
  }
}

class _DefaultMenuItem extends StatelessWidget {
  const _DefaultMenuItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.textSize,
    required this.textWeight,
    required this.fontFamily,
  });

  final String item;
  final bool isSelected;
  final VoidCallback onTap;
  final double textSize;
  final FontWeight textWeight;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: textSize.sp,
                  fontFamily: fontFamily,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: context.colors.bgSuccessSecondary,
                size: 18.r,
              ),
          ],
        ),
      ),
    );
  }
}