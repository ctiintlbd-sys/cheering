import 'package:cheering/core/helpers/picker_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {}

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: const CustomSliverAppBar(title: 'Account Settings'),
      bodyList: [
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              CustomNetworkImage.view(
                imageUrl: '',
                imageFile: null,
                width: 94.r,
                height: 94.r,
                boxShape: BoxShape.circle,
                border: Border.all(color: context.colors.borderSecondary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.pickImageWithCrop(
                      cropConfig: ImageCropHelper.profilePicture,
                      onCropped: (value) {},
                    );
                  },
                  child: Assets.icons.imageUpdate.svg(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // ── 2. Form Input Fields ─────────────────────────────────
        CustomTextField(
          labelText: 'Full Name',
          controller: _nameController,
          hintText: 'e.g. Tanvir Hridoy',
        ),

        SizedBox(height: 12.h),

        CustomTextField(
          labelText: 'Email',
          controller: _phoneController,
          hintText: 'example.gmail.com',
          keyboardType: TextInputType.emailAddress,
          enabled: false,
        ),
        SizedBox(height: 12.h),

        CustomTextField(
          labelText: 'Phone number',
          controller: _phoneController,
          hintText: '01*************',
          keyboardType: TextInputType.phone,
        ),

        SizedBox(height: 32.h),
      ],
      bottomNavigationBar: CustomButton(
        text: 'Save Changes',
        onPressed: _onSaveChanges,
      ),
    );
  }
}
