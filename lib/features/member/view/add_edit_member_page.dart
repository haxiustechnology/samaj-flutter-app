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
  
  String _gender = 'Male';
  int? _age;
  String _maritalStatus = 'single';
  DateTime? _dob;
  int? _villageId;
  bool _isDoingJob = false;
  String? _jobType;
  File? _imageFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
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
        _gender = 'Male';
      } else if (g == 'female') {
        _gender = 'Female';
      } else {
        _gender = 'Male';
      }
      // parse dob if available
      if (widget.member!.birthdate != null) {
        _dob = DateTime.tryParse(widget.member!.birthdate!);
      }
      _villageId = widget.member!.villageId;
      // Normalize marital status to lowercase keys used by the dropdown
      final ms = (widget.member!.maritalStatus ?? '').toString().toLowerCase();
      _maritalStatus = ms.isNotEmpty ? ms : 'single';
      // set isDoingJob based on member data
      if (widget.member!.isDoingJob != null) {
        _isDoingJob = widget.member!.isDoingJob == 1;
      }
      // Normalize job type if present
      if (widget.member!.jobType != null) {
        final jt = widget.member!.jobType!.toString().toLowerCase();
        if (jt == 'private') {
          _jobType = 'Private';
        } else if (jt == 'government') {
          _jobType = 'Government';
        } else {
          _jobType = widget.member!.jobType;
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
    }
    _bloc = MemberBloc(repository: MemberRepository());
    _bloc.add(FetchVillages());
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
    final initial = _dob ?? DateTime(now.year - 20, now.month, now.day);
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
      setState(() {
        _dob = picked;
        _age = _calculateAge(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile != null) {
      final len = _imageFile!.lengthSync();
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
      'gender': _gender,
      'village_id': _villageId,
      'marital_status': _maritalStatus,
      'age': _age,
      'is_doing_job': _isDoingJob ? 1 : 0,
      'job_type': _jobType,
      'birthdate': _dob != null ? _dob!.toIso8601String().split('T').first : null,
      'education': {
        'ssc_school': _sscSchool.text.trim(),
        'ssc_percentage': _sscPercentage.text.trim(),
        'hsc_school': _hscSchool.text.trim(),
        'hsc_percentage': _hscPercentage.text.trim(),
        'bachelor_degree': _bachelorDegree.text.trim(),
        'bachelor_percentage': _bachelorPercentage.text.trim(),
        'master_degree': _masterDegree.text.trim(),
        'master_percentage': _masterPercentage.text.trim(),
      }
    };

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });
    try {
      if (widget.member == null) {
        final resp = await _repo.addMember(body, imageFile: _imageFile, onSendProgress: (sent, total) {
          if (total > 0) setState(() => _uploadProgress = sent / total);
        });
        if (!mounted) return;
        if (resp.isSuccess) Navigator.pop(context);
        else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp.message)));
      } else {
        final resp = await _repo.editMember(widget.member!.id, body, imageFile: _imageFile, onSendProgress: (sent, total) {
          if (total > 0) setState(() => _uploadProgress = sent / total);
        });
        if (!mounted) return;
        if (resp.isSuccess) Navigator.pop(context);
        else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp.message)));
      }
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
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
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 60.r,
                              backgroundColor: AppColors.backgroundWhite,
                              child: ClipOval(
                                child: _imageFile == null
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
                                        _imageFile!,
                                        width: 120.w,
                                        height: 120.w,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
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
                          'Personal Details',
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
                        AppDropdownField<String>(
                          value: _gender,
                          label: S.of(context).gender,
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female'))
                          ],
                          onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                        ),
                        SizedBox(height: 16.h),

                        // Birthdate picker inside AppTextField container look
                        GestureDetector(
                          onTap: _pickDob,
                          child: AbsorbPointer(
                            child: AppTextField(
                              controller: TextEditingController(
                                text: _dob != null ? _dob!.toIso8601String().split('T').first : '',
                              ),
                              label: S.of(context).dateOfBirth,
                              hint: S.of(context).dateOfBirth,
                              prefixIcon: const Icon(Icons.calendar_today_rounded),
                              validator: (v) => null,
                            ),
                          ),
                        ),
                        if (_age != null) ...[
                          SizedBox(height: 8.h),
                          Text(
                            '${S.of(context).age}: $_age years',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        SizedBox(height: 16.h),

                        // Marital status dropdown
                        AppDropdownField<String>(
                          value: _maritalStatus,
                          label: S.of(context).maritalStatus,
                          items: [
                            DropdownMenuItem(value: 'single', child: Text(S.of(context).single)),
                            DropdownMenuItem(value: 'married', child: Text(S.of(context).married)),
                            DropdownMenuItem(value: 'widowed', child: Text(S.of(context).widowed)),
                          ],
                          onChanged: (v) => setState(() => _maritalStatus = v ?? 'single'),
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
                              return AppDropdownField<int>(
                                value: _villageId,
                                label: S.of(context).village,
                                items: villages
                                    .map((v) => DropdownMenuItem(value: v.id, child: Text(v.villageName)))
                                    .toList(),
                                onChanged: (val) => setState(() => _villageId = val),
                                validator: (v) => v == null ? S.of(context).requiredField : null,
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
                              value: _isDoingJob,
                              activeColor: AppColors.primary,
                              onChanged: (v) => setState(() => _isDoingJob = v),
                            ),
                          ],
                        ),
                        if (_isDoingJob) ...[
                          SizedBox(height: 12.h),
                          AppDropdownField<String>(
                            value: _jobType,
                            label: S.of(context).jobType,
                            items: const [
                              DropdownMenuItem(value: 'Private', child: Text('Private')),
                              DropdownMenuItem(value: 'Government', child: Text('Government')),
                            ],
                            onChanged: (v) => setState(() => _jobType = v),
                          ),
                        ],
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
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Upload Progress
                  if (_isUploading) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: LinearProgressIndicator(
                              value: _uploadProgress,
                              backgroundColor: AppColors.borderLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              minHeight: 6.h,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${(_uploadProgress * 100).toStringAsFixed(0)}% uploaded',
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Submit button
                  AppButton(
                    text: S.of(context).save,
                    onPressed: _isUploading ? null : _submit,
                    isLoading: _isUploading,
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
