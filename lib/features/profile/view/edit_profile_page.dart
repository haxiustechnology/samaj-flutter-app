import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_gradient_bg.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../core/utils/shared_prefs.dart';
import 'package:samaj/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final user = await SharedPrefs.getUserModel();
    if (user == null) {
      setState(() {
        _nameCtrl.text = '';
        _mobileCtrl.text = '';
        _emailCtrl.text = '';
        _profileImageUrl = null;
      });
      return;
    }
    setState(() {
      _nameCtrl.text = user.name;
      _mobileCtrl.text = user.mobile;
      _emailCtrl.text = user.email ?? '';
      _profileImageUrl = user.profileImage;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: source, imageQuality: 80);
    if (x != null) setState(() => _imageFile = File(x.path));
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: Text(S.of(ctx).gallery, style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: const Text('Camera', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final Map<String, dynamic> body = {
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'mobile': _mobileCtrl.text.trim(),
    };

    if (_imageFile != null) {
      final bytes = _imageFile!.readAsBytesSync();
      final b64 = base64Encode(bytes);
      final ext = _imageFile!.path.split('.').last.toLowerCase();
      String mime = 'image/jpeg';
      if (ext == 'png') mime = 'image/png';
      else if (ext == 'webp') mime = 'image/webp';
      else if (ext == 'gif') mime = 'image/gif';
      body['profile_image'] = 'data:$mime;base64,$b64';
    } else {
      body['profile_image'] = '';
    }

    context.read<AuthBloc>().add(UpdateProfileEvent(data: body));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is AuthSuccess) {
          SnackbarUtils.show(context, state.message ?? S.of(context).editProfile);
          Navigator.pop(context, true);
        } else if (state is AuthError) {
          SnackbarUtils.show(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppGradientBg(
          child: SafeArea(
            child: Column(
              children: [
                // Custom AppBar (Transparent with back button)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        S.of(context).editProfile,
                        style: AppTextStyles.appBarTitle,
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20.h),
                            
                            // Form Container Card
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.backgroundWhite,
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Profile Image Selector
                                  Center(
                                    child: GestureDetector(
                                      onTap: () => _showImageSourceActionSheet(context),
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(4.w),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 3),
                                            ),
                                            child: CircleAvatar(
                                              radius: 48.r,
                                              backgroundColor: AppColors.backgroundWhite,
                                              child: ClipOval(
                                                child: _imageFile != null
                                                    ? Image.file(
                                                        _imageFile!,
                                                        width: 96.w,
                                                        height: 96.w,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                                                        ? CachedNetworkImage(
                                                            imageUrl: _profileImageUrl!,
                                                            width: 96.w,
                                                            height: 96.w,
                                                            fit: BoxFit.cover,
                                                            placeholder: (_, __) => const Center(
                                                              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                                                            ),
                                                            errorWidget: (_, __, ___) => const Icon(Icons.broken_image_rounded, color: AppColors.primary),
                                                          )
                                                        : const Icon(Icons.camera_alt_rounded, size: 28, color: AppColors.primary),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 2.h,
                                            right: 2.w,
                                            child: Container(
                                              padding: EdgeInsets.all(5.w),
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  
                                  AppTextField(
                                    controller: _nameCtrl,
                                    label: S.of(context).fullName,
                                    hint: S.of(context).fullName,
                                    prefixIcon: const Icon(Icons.person_outline_rounded),
                                    validator: (v) => v == null || v.isEmpty ? S.of(context).requiredField : null,
                                  ),
                                  SizedBox(height: 16.h),
                                  
                                  AppTextField(
                                    controller: _mobileCtrl,
                                    label: S.of(context).mobile,
                                    hint: '1234567890',
                                    keyboardType: TextInputType.phone,
                                    prefixIcon: const Icon(Icons.phone_iphone_outlined),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (v) => v == null || v.isEmpty ? S.of(context).requiredField : null,
                                  ),
                                  SizedBox(height: 16.h),
                                  
                                  AppTextField(
                                    controller: _emailCtrl,
                                    label: '${S.of(context).email} ${S.of(context).optionalBrace}',
                                    hint: 'abc@gmail.com',
                                    prefixIcon: const Icon(Icons.email_outlined),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) => null,
                                  ),
                                  SizedBox(height: 24.h),
                                  
                                  AppButton(
                                    text: S.of(context).save,
                                    onPressed: _isLoading ? null : _submit,
                                    isLoading: _isLoading,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
