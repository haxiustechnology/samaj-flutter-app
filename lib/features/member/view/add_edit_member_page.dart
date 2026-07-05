import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../data/models/member_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/repositories/member_repository.dart';
import '../../member/bloc/member_bloc.dart';

class AddEditMemberPage extends StatefulWidget {
  final Member? member;
  const AddEditMemberPage({Key? key, this.member}) : super(key: key);

  @override
  State<AddEditMemberPage> createState() => _AddEditMemberPageState();
}

class _AddEditMemberPageState extends State<AddEditMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _middle = TextEditingController();
  final _surname = TextEditingController();
  // education controllers
  final _sscSchool = TextEditingController();
  final _sscPercentage = TextEditingController();
  final _hscSchool = TextEditingController();
  final _hscPercentage = TextEditingController();
  final _bachelorDegree = TextEditingController();
  final _bachelorPercentage = TextEditingController();
  final _masterDegree = TextEditingController();
  final _masterPercentage = TextEditingController();
  
  // new optional fields
  final _mobile = TextEditingController();
  final _businessDetails = TextEditingController();
  final _jobPost = TextEditingController();
  final _otherEducation = TextEditingController();
  
  final ValueNotifier<String> _gender = ValueNotifier<String>('Male');
  final ValueNotifier<int?> _age = ValueNotifier<int?>(null);
  final ValueNotifier<String> _maritalStatus = ValueNotifier<String>('single');
  final ValueNotifier<DateTime?> _dob = ValueNotifier<DateTime?>(null);
  final ValueNotifier<int?> _villageId = ValueNotifier<int?>(null);
  final ValueNotifier<bool> _isDoingJob = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _jobType = ValueNotifier<String?>(null);
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final ValueNotifier<bool> _isUploading = ValueNotifier<bool>(false);
  final ValueNotifier<double> _uploadProgress = ValueNotifier<double>(0.0);
  
  final _repo = MemberRepository();
  late MemberBloc _bloc;

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _first.text = widget.member!.firstName;
      _middle.text = widget.member!.middleName ?? '';
      _surname.text = widget.member!.surname;
      // Normalize gender to match dropdown item values ('Male' / 'Female')
      final g = (widget.member!.gender ?? '').toString().toLowerCase();
      if (g == 'male') {
        _gender.value = 'Male';
      } else if (g == 'female') {
        _gender.value = 'Female';
      } else {
        _gender.value = 'Male';
      }
      // parse dob if available
      if (widget.member!.birthdate != null) {
        _dob.value = DateTime.tryParse(widget.member!.birthdate!);
      }
      _villageId.value = widget.member!.villageId;
      // Normalize marital status to lowercase keys used by the dropdown
      var ms = widget.member!.maritalStatus.toString().toLowerCase();
      if (ms == 'widowed') ms = 'widow';
      if (!['single', 'married', 'divorced', 'widow'].contains(ms)) {
        ms = 'single';
      }
      _maritalStatus.value = ms;
      // set isDoingJob based on member data
      if (widget.member!.isDoingJob != null) {
        _isDoingJob.value = widget.member!.isDoingJob == 1;
      }
      // Normalize job type if present
      if (widget.member!.jobType != null) {
        final jt = widget.member!.jobType!.toString().toLowerCase();
        if (jt == 'private') {
          _jobType.value = 'Private';
        } else if (jt == 'government') {
          _jobType.value = 'Government';
        } else {
          _jobType.value = widget.member!.jobType;
        }
      }
      // prefill education
      _sscSchool.text = widget.member!.sscSchool ?? '';
      _sscPercentage.text = widget.member!.sscPercentage ?? '';
      _hscSchool.text = widget.member!.hscSchool ?? '';
      _hscPercentage.text = widget.member!.hscPercentage ?? '';
      _bachelorDegree.text = widget.member!.bachelorDegree ?? '';
      _bachelorPercentage.text = widget.member!.bachelorPercentage ?? '';
      _masterDegree.text = widget.member!.masterDegree ?? '';
      _masterPercentage.text = widget.member!.masterPercentage ?? '';
      
      // new fields prefill
      _mobile.text = widget.member!.mobile ?? '';
      _businessDetails.text = widget.member!.businessDetails ?? '';
      _jobPost.text = widget.member!.jobPost ?? '';
      _otherEducation.text = widget.member!.otherEducation ?? '';
    }
    _bloc = MemberBloc(repository: MemberRepository());
    _bloc.add(FetchVillages());
  }

  @override
  void dispose() {
    _first.dispose();
    _middle.dispose();
    _surname.dispose();
    _sscSchool.dispose();
    _sscPercentage.dispose();
    _hscSchool.dispose();
    _hscPercentage.dispose();
    _bachelorDegree.dispose();
    _bachelorPercentage.dispose();
    _masterDegree.dispose();
    _masterPercentage.dispose();
    _mobile.dispose();
    _businessDetails.dispose();
    _jobPost.dispose();
    _otherEducation.dispose();
    
    _gender.dispose();
    _age.dispose();
    _maritalStatus.dispose();
    _dob.dispose();
    _villageId.dispose();
    _isDoingJob.dispose();
    _jobType.dispose();
    _imageFile.dispose();
    _isUploading.dispose();
    _uploadProgress.dispose();
    
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: source, imageQuality: 80);
    if (x != null) _imageFile.value = File(x.path);
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
              title: Text(S.of(ctx).camera, style: AppTextStyles.bodyMedium),
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

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age -= 1;
    }
    return age;
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob.value ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (!mounted) return;
    if (picked != null) {
      _dob.value = picked;
      _age.value = _calculateAge(picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile.value != null) {
      final len = _imageFile.value!.lengthSync();
      const warnBytes = 1572864; // 1.5 * 1024 * 1024
      if (len > warnBytes) {
        final ok = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            backgroundColor: AppColors.backgroundWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            title: Text(S.of(context).largeImageWarningTitle, style: AppTextStyles.heading3),
            content: Text(S.of(context).largeImageWarningMessage, style: AppTextStyles.bodyMedium),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(S.of(context).cancel, style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(S.of(context).continueText, style: AppTextStyles.buttonSmall.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        );
        if (!mounted) return;
        if (ok != true) return;
      }
    }
    
    final body = {
      'first_name': _first.text.trim(),
      'middle_name': _middle.text.trim(),
      'surname': _surname.text.trim(),
      'gender': _gender.value,
      'village_id': _villageId.value,
      'marital_status': _maritalStatus.value,
      'age': _age.value,
      'is_doing_job': _isDoingJob.value ? 1 : 0,
      'job_type': _isDoingJob.value ? _jobType.value : null,
      'birthdate': _dob.value != null ? _dob.value!.toIso8601String().split('T').first : null,
      'mobile': _mobile.text.trim().isEmpty ? null : _mobile.text.trim(),
      'business_details': _businessDetails.text.trim().isEmpty ? null : _businessDetails.text.trim(),
      'job_post': _isDoingJob.value && (_jobType.value == 'Private' || _jobType.value == 'Government')
          ? (_jobPost.text.trim().isEmpty ? null : _jobPost.text.trim())
          : null,
      'education': {
        'ssc_school': _sscSchool.text.trim(),
        'ssc_percentage': _sscPercentage.text.trim(),
        'hsc_school': _hscSchool.text.trim(),
        'hsc_percentage': _hscPercentage.text.trim(),
        'bachelor_degree': _bachelorDegree.text.trim(),
        'bachelor_percentage': _bachelorPercentage.text.trim(),
        'master_degree': _masterDegree.text.trim(),
        'master_percentage': _masterPercentage.text.trim(),
        'other_education': _otherEducation.text.trim().isEmpty ? null : _otherEducation.text.trim(),
      }
    };

    _isUploading.value = true;
    _uploadProgress.value = 0.0;
    try {
      if (widget.member == null) {
        final resp = await _repo.addMember(body, imageFile: _imageFile.value, onSendProgress: (sent, total) {
          if (total > 0) _uploadProgress.value = sent / total;
        });
        if (!mounted) return;
        if (resp.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).memberAddedSuccessfully)));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp.message)));
        }
      } else {
        final resp = await _repo.editMember(widget.member!.id, body, imageFile: _imageFile.value, onSendProgress: (sent, total) {
          if (total > 0) _uploadProgress.value = sent / total;
        });
        if (!mounted) return;
        if (resp.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).memberUpdatedSuccessfully)));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp.message)));
        }
      }
    } finally {
      _isUploading.value = false;
      _uploadProgress.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            widget.member == null ? S.of(context).addMember : S.of(context).editMember,
            style: AppTextStyles.appBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo picker with warm primary border ring
                  Center(
                    child: GestureDetector(
                      onTap: () => _showImageSourceActionSheet(context),
                      child: Stack(
                        children: [
                          ValueListenableBuilder<File?>(
                            valueListenable: _imageFile,
                            builder: (context, imageFileValue, _) {
                              return Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 3),
                                ),
                                child: CircleAvatar(
                                  radius: 60.r,
                                  backgroundColor: AppColors.backgroundWhite,
                                  child: ClipOval(
                                    child: imageFileValue == null
                                        ? (widget.member?.profileImage != null && widget.member!.profileImage!.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: widget.member!.profileImage!,
                                                width: 120.w,
                                                height: 120.w,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => const Center(
                                                  child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                                                ),
                                                errorWidget: (context, url, error) =>
                                                    const Icon(Icons.broken_image_rounded, size: 36, color: AppColors.primary),
                                              )
                                            : const Icon(Icons.camera_alt_rounded, size: 36, color: AppColors.primary))
                                        : Image.file(
                                            imageFileValue,
                                            width: 120.w,
                                            height: 120.w,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              );
                            }
                          ),
                          Positioned(
                            bottom: 4.h,
                            right: 4.w,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      S.of(context).profileImageOptional,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Basic Profile Info Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          S.of(context).personalDetails,
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Divider(color: AppColors.borderLight, thickness: 1),
                        SizedBox(height: 12.h),

                        AppTextField(
                          controller: _first,
                          label: S.of(context).firstName,
                          hint: S.of(context).enterFirstName,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          validator: (v) => v == null || v.isEmpty ? S.of(context).requiredField : null,
                        ),
                        SizedBox(height: 16.h),

                        AppTextField(
                          controller: _middle,
                          label: S.of(context).middleName,
                          hint: S.of(context).enterMiddleName,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                        SizedBox(height: 16.h),

                        AppTextField(
                          controller: _surname,
                          label: S.of(context).surname,
                          hint: S.of(context).enterSurname,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          validator: (v) => v == null || v.isEmpty ? S.of(context).requiredField : null,
                        ),
                        SizedBox(height: 16.h),

                        // Gender Dropdown (Redesigned)
                        ValueListenableBuilder<String>(
                          valueListenable: _gender,
                          builder: (context, genderValue, _) {
                            return AppDropdownField<String>(
                              value: genderValue,
                              label: S.of(context).gender,
                              items: [
                                DropdownMenuItem(value: 'Male', child: Text(S.of(context).male)),
                                DropdownMenuItem(value: 'Female', child: Text(S.of(context).female))
                              ],
                              onChanged: (v) => _gender.value = v ?? 'Male',
                            );
                          }
                        ),
                        SizedBox(height: 16.h),

                        // Birthdate picker inside AppTextField container look
                        ValueListenableBuilder<DateTime?>(
                          valueListenable: _dob,
                          builder: (context, dobValue, _) {
                            return GestureDetector(
                              onTap: _pickDob,
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: TextEditingController(
                                    text: dobValue != null ? dobValue.toIso8601String().split('T').first : '',
                                  ),
                                  label: S.of(context).dateOfBirth,
                                  hint: S.of(context).dateOfBirth,
                                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                                  validator: (v) => null,
                                ),
                              ),
                            );
                          }
                        ),
                        ValueListenableBuilder<int?>(
                          valueListenable: _age,
                          builder: (context, ageValue, _) {
                            if (ageValue == null) return const SizedBox.shrink();
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                '${S.of(context).age}: $ageValue ${S.of(context).years}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }
                        ),
                        SizedBox(height: 16.h),

                        // Marital status dropdown
                        ValueListenableBuilder<String>(
                          valueListenable: _maritalStatus,
                          builder: (context, maritalStatusValue, _) {
                            return AppDropdownField<String>(
                              value: maritalStatusValue,
                              label: S.of(context).maritalStatus,
                              items: [
                                DropdownMenuItem(value: 'single', child: Text(S.of(context).single)),
                                DropdownMenuItem(value: 'married', child: Text(S.of(context).married)),
                                DropdownMenuItem(value: 'divorced', child: Text(S.of(context).divorced)),
                                DropdownMenuItem(value: 'widow', child: Text(S.of(context).widow)),
                              ],
                              onChanged: (v) => _maritalStatus.value = v ?? 'single',
                            );
                          }
                        ),
                        SizedBox(height: 16.h),

                        // Optional Mobile Number
                        AppTextField(
                          controller: _mobile,
                          label: S.of(context).mobileNumberOptional,
                          hint: S.of(context).enterMobileNumber,
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_iphone_rounded),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (v) {
                            if (v != null && v.isNotEmpty && v.length != 10) {
                              return S.of(context).mobileValidationMsg;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Village Dropdown from Bloc
                        BlocBuilder<MemberBloc, MemberState>(
                          builder: (context, state) {
                            if (state is MemberLoading) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                              );
                            }
                            if (state is VillagesLoaded) {
                              final villages = state.villages;
                              return ValueListenableBuilder<int?>(
                                valueListenable: _villageId,
                                builder: (context, villageIdValue, _) {
                                  return AppDropdownField<int>(
                                    value: villageIdValue,
                                    label: S.of(context).village,
                                    items: villages
                                        .map((v) => DropdownMenuItem(value: v.id, child: Text(v.villageName)))
                                        .toList(),
                                    onChanged: (val) => _villageId.value = val,
                                    validator: (v) => v == null ? S.of(context).requiredField : null,
                                  );
                                }
                              );
                            }
                            if (state is MemberError) return Text(state.message, style: TextStyle(color: AppColors.error));
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Job Section Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _isDoingJob,
                          builder: (context, isDoingJobValue, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).doingJobQuestion,
                                      style: AppTextStyles.subtitle1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Switch.adaptive(
                                      value: isDoingJobValue,
                                      activeColor: AppColors.primary,
                                      onChanged: (v) => _isDoingJob.value = v,
                                    ),
                                  ],
                                ),
                                if (isDoingJobValue) ...[
                                  SizedBox(height: 12.h),
                                  ValueListenableBuilder<String?>(
                                    valueListenable: _jobType,
                                    builder: (context, jobTypeValue, _) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          AppDropdownField<String>(
                                            value: jobTypeValue,
                                            label: S.of(context).jobType,
                                            items: [
                                              DropdownMenuItem(value: 'Private', child: Text(S.of(context).privateJob)),
                                              DropdownMenuItem(value: 'Government', child: Text(S.of(context).governmentJob)),
                                            ],
                                            onChanged: (v) => _jobType.value = v,
                                          ),
                                          if (jobTypeValue == 'Private' || jobTypeValue == 'Government') ...[
                                            SizedBox(height: 16.h),
                                            AppTextField(
                                              controller: _jobPost,
                                              label: S.of(context).designationPostOptional,
                                              hint: S.of(context).designationPostHint,
                                              prefixIcon: const Icon(Icons.badge_outlined),
                                            ),
                                          ],
                                        ],
                                      );
                                    }
                                  ),
                                  SizedBox(height: 16.h),
                                  AppTextField(
                                    controller: _businessDetails,
                                    label: S.of(context).businessJobDetailsOptional,
                                    hint: S.of(context).businessJobDetailsHint,
                                    prefixIcon: const Icon(Icons.business_center_outlined),
                                    maxLines: 3,
                                  ),
                                ],
                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Education Section Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          S.of(context).education,
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const Divider(color: AppColors.borderLight, thickness: 1),
                        SizedBox(height: 12.h),

                        AppTextField(controller: _sscSchool, label: S.of(context).sscSchool, hint: S.of(context).enterSscSchool),
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: _sscPercentage,
                          label: S.of(context).sscPercentage,
                          hint: S.of(context).examplePercentage,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9%\.]'))],
                        ),
                        SizedBox(height: 16.h),

                        AppTextField(controller: _hscSchool, label: S.of(context).hscSchool, hint: S.of(context).enterHscSchool),
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: _hscPercentage,
                          label: S.of(context).hscPercentage,
                          hint: S.of(context).examplePercentage,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9%\.]'))],
                        ),
                        SizedBox(height: 16.h),

                        AppTextField(controller: _bachelorDegree, label: S.of(context).bachelorDegree, hint: S.of(context).enterBachelorDegree),
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: _bachelorPercentage,
                          label: S.of(context).bachelorPercentage,
                          hint: S.of(context).examplePercentage,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9%\.]'))],
                        ),
                        SizedBox(height: 16.h),

                        AppTextField(controller: _masterDegree, label: S.of(context).masterDegree, hint: S.of(context).enterMasterDegree),
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: _masterPercentage,
                          label: S.of(context).masterPercentage,
                          hint: S.of(context).examplePercentage,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9%\.]'))],
                        ),
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: _otherEducation,
                          label: S.of(context).otherEducationOptional,
                          hint: S.of(context).otherEducationHint,
                          prefixIcon: const Icon(Icons.school_outlined),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Upload Progress
                  ValueListenableBuilder<bool>(
                    valueListenable: _isUploading,
                    builder: (context, isUploadingValue, _) {
                      if (!isUploadingValue) return const SizedBox.shrink();
                      return ValueListenableBuilder<double>(
                        valueListenable: _uploadProgress,
                        builder: (context, progressValue, _) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: AppColors.borderLight,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    minHeight: 6.h,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '${(progressValue * 100).toStringAsFixed(0)}% ${S.of(context).uploaded}',
                                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }
                      );
                    }
                  ),

                  // Submit button
                  ValueListenableBuilder<bool>(
                    valueListenable: _isUploading,
                    builder: (context, isUploadingValue, _) {
                      return AppButton(
                        text: S.of(context).save,
                        onPressed: isUploadingValue ? null : _submit,
                        isLoading: isUploadingValue,
                      );
                    }
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
