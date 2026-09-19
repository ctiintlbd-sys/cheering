import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/widgets.dart';

// // Image only
// context.pickImage(
// onImagePicked: (file) { },
// );
//
// // Profile photo — circle crop
// context.pickImageWithCrop(
// cropConfig: ImageCropHelper.profilePicture,
// onCropped: (file) { },
// );
//
// // Cover photo — custom ratio
// context.pickImageWithCrop(
// cropConfig: ImageCropHelper.coverPhoto(width: 16, height: 9),
// onCropped: (file) { },
// );
//
// // File
// context.showFilePicker(
// onFilePicked: (file) {
// print(file.name);
// print(file.path);
// },
// );

// ─── Data Models ──────────────────────────────────────────────────────────────

class ImageCropConfig {
  const ImageCropConfig({
    required this.cropWidth,
    required this.cropHeight,
    this.cropStyle = CropStyle.rectangle,
  });

  final double cropWidth;
  final double cropHeight;
  final CropStyle cropStyle;
}

class _PickerOption {
  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

// ─── BuildContext Extension — Public API ──────────────────────────────────────

extension PickerExtension on BuildContext {
  void pickImage({required ValueChanged<XFile> onImagePicked}) {
    _PickerCore.showImageSheet(context: this, onImagePicked: onImagePicked);
  }

  void pickImageWithCrop({
    required ImageCropConfig cropConfig,
    required ValueChanged<File> onCropped,
  }) {
    _PickerCore.showImageSheet(
      context: this,
      onImagePicked: (file) async {
        final cropped = await ImageCropHelper.cropImage(
          context: this,
          imagePath: file.path,
          config: cropConfig,
        );
        if (cropped != null && mounted) onCropped(cropped);
      },
    );
  }

  void pickFile({required ValueChanged<PlatformFile> onFilePicked}) {
    _PickerCore.showFileSheet(context: this, onFilePicked: onFilePicked);
  }
}

// ─── Backward-Compatible Facade Class ─────────────────────────────────────────

class PickerHelper {
  PickerHelper._();

  static void pickImage({
    required BuildContext context,
    required ValueChanged<XFile> onImagePicked,
  }) {
    context.pickImage(onImagePicked: onImagePicked);
  }

  static void pickImageWithCrop({
    required BuildContext context,
    required ImageCropConfig cropConfig,
    required ValueChanged<File> onCropped,
  }) {
    context.pickImageWithCrop(cropConfig: cropConfig, onCropped: onCropped);
  }

  static void showFilePicker({
    required BuildContext context,
    required ValueChanged<PlatformFile> onFilePicked,
  }) {
    context.pickFile(onFilePicked: onFilePicked);
  }

  static Future<void> pickFile({
    required BuildContext context,
    required ValueChanged<PlatformFile> onFilePicked,
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    await _PickerCore.pickFile(
      context: context,
      onFilePicked: onFilePicked,
      type: type,
      allowedExtensions: allowedExtensions,
    );
  }
}

// ─── Core Logic (Private) ─────────────────────────────────────────────────────

class _PickerCore {
  _PickerCore._();

  static final _imagePicker = ImagePicker();

  static void showImageSheet({
    required BuildContext context,
    required ValueChanged<XFile> onImagePicked,
  }) {
    _showSheet(
      context: context,
      title: 'Select Photo',
      options: [
        _PickerOption(
          icon: Icons.camera_alt,
          label: 'Camera',
          onTap: () =>
              _pickImageFrom(context, ImageSource.camera, onImagePicked),
        ),
        _PickerOption(
          icon: Icons.photo_library,
          label: 'Gallery',
          onTap: () =>
              _pickImageFrom(context, ImageSource.gallery, onImagePicked),
        ),
      ],
    );
  }

  static void showFileSheet({
    required BuildContext context,
    required ValueChanged<PlatformFile> onFilePicked,
  }) {
    _showSheet(
      context: context,
      title: 'Select File Type',
      options: [
        _PickerOption(
          icon: Icons.insert_drive_file,
          label: 'Documents',
          onTap: () => pickFile(
            context: context,
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx'],
            onFilePicked: onFilePicked,
          ),
        ),
        _PickerOption(
          icon: Icons.folder,
          label: 'Any File',
          onTap: () => pickFile(
            context: context,
            type: FileType.any,
            onFilePicked: onFilePicked,
          ),
        ),
      ],
    );
  }

  static Future<void> _pickImageFrom(
    BuildContext context,
    ImageSource source,
    ValueChanged<XFile> onImagePicked,
  ) async {
    final navigator = Navigator.of(context);
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (navigator.mounted) navigator.pop();
    if (file != null) onImagePicked(file);
  }

  static Future<void> pickFile({
    required BuildContext context,
    required ValueChanged<PlatformFile> onFilePicked,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: type,
        allowedExtensions: type == FileType.custom ? allowedExtensions : null,
      );
      if (file != null) onFilePicked(file);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: 'Error picking file: $e',
            color: context.colors.white,
          ),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }

  static void _showSheet({
    required BuildContext context,
    required String title,
    required List<_PickerOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: context.colors.background,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 24.h,
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Drag handle indicator
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: sheetContext.colors.textPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              CustomText(
                text: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: sheetContext.colors.textPrimary,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: options
                    .map((opt) => _PickerOptionWidget(option: opt))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Option Widget ────────────────────────────────────────────────────────────

class _PickerOptionWidget extends StatelessWidget {
  const _PickerOptionWidget({required this.option});

  final _PickerOption option;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all((16.r).clamp(10.0, 20.0)),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                option.icon,
                size: (30.r).clamp(20.0, 35.0),
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: option.label,
              color: context.colors.textPrimary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Image Crop Helper ────────────────────────────────────────────────────────

class ImageCropHelper {
  ImageCropHelper._();

  static const ImageCropConfig profilePicture = ImageCropConfig(
    cropWidth: 1,
    cropHeight: 1,
    cropStyle: CropStyle.circle,
  );

  static const ImageCropConfig productPicture = ImageCropConfig(
    cropWidth: 1,
    cropHeight: 1,
    cropStyle: CropStyle.rectangle,
  );

  static const ImageCropConfig square = ImageCropConfig(
    cropWidth: 1,
    cropHeight: 1,
    cropStyle: CropStyle.rectangle,
  );

  static ImageCropConfig coverPhoto({
    required double width,
    required double height,
  }) => ImageCropConfig(cropWidth: width, cropHeight: height);

  static Future<File?> cropImage({
    BuildContext? context,
    required String imagePath,
    required ImageCropConfig config,
  }) async {
    if (config.cropWidth <= 0 || config.cropHeight <= 0) return null;

    final primaryColor = context != null
        ? context.colors.primary
        : const Color(0xFF0E8A45);
    final toolbarColor = context != null
        ? context.colors.textPrimary
        : Colors.black;

    final cropped = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(
        ratioX: config.cropWidth,
        ratioY: config.cropHeight,
      ),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: toolbarColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          cropStyle: config.cropStyle,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          cropStyle: config.cropStyle,
        ),
      ],
    );

    return cropped != null ? File(cropped.path) : null;
  }
}
