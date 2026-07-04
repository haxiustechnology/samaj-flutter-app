import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/models/village_model.dart';
import '../../member/bloc/member_bloc.dart';
import '../../../data/models/member_model.dart';
import 'member_detail_page.dart';

class AllMembersPage extends StatefulWidget {
  const AllMembersPage({Key? key}) : super(key: key);

  @override
  State<AllMembersPage> createState() => _AllMembersPageState();
}

class _AllMembersPageState extends State<AllMembersPage> {
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();

  late MemberBloc _bloc;
  late MemberBloc _villageBloc; // separate bloc just for loading villages

  // ── Active filter values ──────────────────────────────────────────────────
  String? _search;
  int?    _villageId;
  String? _gender;   // null | 'male' | 'female' | 'other'
  String? _jobType;  // null | 'private' | 'government' | 'none'

  List<Village> _villages = [];

  // ── Gender / job options ──────────────────────────────────────────────────
  static const _genderOptions = [
    _Option(label: 'All', value: null),
    _Option(label: 'Male', value: 'male'),
    _Option(label: 'Female', value: 'female'),
    _Option(label: 'Other', value: 'other'),
  ];

  static const _jobOptions = [
    _Option(label: 'All Jobs', value: null),
    _Option(label: 'Private', value: 'private'),
    _Option(label: 'Government', value: 'government'),
    _Option(label: 'None', value: 'none'),
  ];

  @override
  void initState() {
    super.initState();
    final repo = MemberRepository();
    _bloc = MemberBloc(repository: repo);
    _villageBloc = MemberBloc(repository: repo);

    _villageBloc.add(FetchVillages());
    _fetchFirstPage();

    _scroll.addListener(_onScroll);
  }

  void _fetchFirstPage() {
    _bloc.add(FetchAllMembers(
      reset: true,
      search:    _search,
      villageId: _villageId,
      gender:    _gender,
      jobType:   _jobType,
    ));
  }

  void _fetchNextPage(int nextCursor) {
    _bloc.add(FetchAllMembers(
      lastId:    nextCursor,
      search:    _search,
      villageId: _villageId,
      gender:    _gender,
      jobType:   _jobType,
    ));
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 250) {
      final state = _bloc.state;
      if (state is AllMembersLoaded && state.hasMore && state.nextCursor != null) {
        _fetchNextPage(state.nextCursor!);
      }
    }
  }

  void _applyFilters() {
    _search = _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim();
    _fetchFirstPage();
  }

  void _clearFilters() {
    setState(() {
      _search    = null;
      _villageId = null;
      _gender    = null;
      _jobType   = null;
    });
    _searchCtrl.clear();
    _fetchFirstPage();
  }

  bool get _hasActiveFilter =>
      _search != null || _villageId != null || _gender != null || _jobType != null;

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    _bloc.close();
    _villageBloc.close();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc),
        BlocProvider.value(value: _villageBloc),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        appBar: AppBar(
          title: Text(
            'Community Members',
            style: AppTextStyles.appBarTitle,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
          ),
          actions: [
            if (_hasActiveFilter)
              IconButton(
                icon: const Icon(Icons.filter_list_off_rounded, color: Colors.white),
                tooltip: 'Clear filters',
                onPressed: _clearFilters,
              ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
              tooltip: 'Filter',
              onPressed: () => _showFilterSheet(context),
            ),
          ],
        ),
        body: BlocListener<MemberBloc, MemberState>(
          bloc: _villageBloc,
          listener: (context, state) {
            if (state is VillagesLoaded) {
              setState(() => _villages = state.villages);
            }
          },
          child: Column(
            children: [
              _buildSearchBar(),
              if (_hasActiveFilter) _buildActiveFilterChips(),
              Expanded(child: _buildMemberList()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search Bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: TextField(
        controller: _searchCtrl,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Search by name…',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchCtrl.clear();
                    _applyFilters();
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.backgroundWhite,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onSubmitted: (_) => _applyFilters(),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  // ── Active Filter Chips ───────────────────────────────────────────────────

  Widget _buildActiveFilterChips() {
    final chips = <Widget>[];

    if (_gender != null) {
      chips.add(_filterChip(
        label: _gender!.toUpperCase(),
        onDelete: () => setState(() { _gender = null; _fetchFirstPage(); }),
      ));
    }
    if (_jobType != null) {
      chips.add(_filterChip(
        label: _jobType!.toUpperCase(),
        onDelete: () => setState(() { _jobType = null; _fetchFirstPage(); }),
      ));
    }
    if (_villageId != null) {
      final village = _villages.firstWhere(
        (v) => v.id == _villageId,
        orElse: () => Village(id: _villageId!, villageName: 'Village'),
      );
      chips.add(_filterChip(
        label: village.villageName,
        onDelete: () => setState(() { _villageId = null; _fetchFirstPage(); }),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        physics: const BouncingScrollPhysics(),
        children: chips,
      ),
    );
  }

  Widget _filterChip({required String label, required VoidCallback onDelete}) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Chip(
        label: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        deleteIcon: Icon(Icons.close_rounded, size: 14.sp, color: AppColors.primary),
        onDeleted: onDelete,
        backgroundColor: AppColors.primarySurface,
        side: const BorderSide(color: AppColors.primaryLight, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // ── Filter Bottom Sheet ───────────────────────────────────────────────────

  void _showFilterSheet(BuildContext context) {
    String? tempGender   = _gender;
    String? tempJobType  = _jobType;
    int?    tempVillage  = _villageId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.65,
              maxChildSize: 0.9,
              builder: (_, sc) => Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: ListView(
                  controller: sc,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Center(
                      child: Container(
                        width: 44.w,
                        height: 5.h,
                        margin: EdgeInsets.only(bottom: 20.h),
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    Text(
                      'Filter Members',
                      style: AppTextStyles.heading3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Gender Filter
                    Text(
                      'Gender',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      children: _genderOptions.map((opt) {
                        final selected = tempGender == opt.value;
                        return ChoiceChip(
                          label: Text(opt.label),
                          selected: selected,
                          onSelected: (_) => setSheet(() => tempGender = opt.value),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.backgroundCream,
                          checkmarkColor: Colors.white,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: selected ? AppColors.primary : AppColors.borderLight,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),

                    // Job Type Filter
                    Text(
                      'Job Type',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      children: _jobOptions.map((opt) {
                        final selected = tempJobType == opt.value;
                        return ChoiceChip(
                          label: Text(opt.label),
                          selected: selected,
                          onSelected: (_) => setSheet(() => tempJobType = opt.value),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.backgroundCream,
                          checkmarkColor: Colors.white,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: selected ? AppColors.primary : AppColors.borderLight,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),

                    // Village Dropdown
                    Text(
                      'Village',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (_villages.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'Loading villages…',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    else
                      DropdownButtonFormField<int?>(
                        value: tempVillage,
                        dropdownColor: AppColors.backgroundWhite,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundCream,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('All Villages'),
                          ),
                          ..._villages.map((v) => DropdownMenuItem<int?>(
                            value: v.id,
                            child: Text(v.villageName),
                          )),
                        ],
                        onChanged: (v) => setSheet(() => tempVillage = v),
                      ),
                    SizedBox(height: 32.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: const BorderSide(color: AppColors.borderMedium, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            onPressed: () {
                              setSheet(() {
                                tempGender = null;
                                tempJobType = null;
                                tempVillage = null;
                              });
                            },
                            child: Text(
                              'Reset',
                              style: AppTextStyles.buttonSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _gender    = tempGender;
                                _jobType   = tempJobType;
                                _villageId = tempVillage;
                              });
                              Navigator.pop(ctx);
                              _fetchFirstPage();
                            },
                            child: Text(
                              'Apply',
                              style: AppTextStyles.buttonSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Member List ───────────────────────────────────────────────────────────

  Widget _buildMemberList() {
    return BlocConsumer<MemberBloc, MemberState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is MemberError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is MemberLoading) return _buildShimmer();

        List<Member> members = [];
        bool hasMore = false;
        bool pageLoading = false;

        if (state is AllMembersLoaded) {
          members = state.members;
          hasMore = state.hasMore;
        } else if (state is AllMembersPageLoading) {
          members = state.currentMembers;
          pageLoading = true;
        } else if (state is MemberError && _bloc.state is AllMembersLoaded) {
          members = (_bloc.state as AllMembersLoaded).members;
        }

        if (members.isEmpty && state is! MemberLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 64.sp,
                  color: AppColors.textMuted,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No members found',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (_hasActiveFilter) ...[
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'Clear filters',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scroll,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: members.length + (pageLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= members.length) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }
            return _buildMemberCard(members[index]);
          },
        );
      },
    );
  }

  Widget _buildMemberCard(Member m) {
    // Saffron border accent for male, Maroon for female, Gold for other/unspecified
    final bool isFemale = m.gender?.toLowerCase() == 'female';
    final bool isMale = m.gender?.toLowerCase() == 'male';
    final Color borderAccentColor = isFemale 
        ? AppColors.secondary 
        : (isMale ? AppColors.primary : AppColors.accent);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: AppCard(
        hasLeftBorderAccent: true,
        leftBorderColor: borderAccentColor,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MemberDetailPage(memberId: m.id)),
        ),
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Styled Avatar Frame
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderAccentColor.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: m.profileImage != null && m.profileImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: m.profileImage!,
                        width: 48.w,
                        height: 48.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _avatarPlaceholder(borderAccentColor),
                        errorWidget: (_, __, ___) => _avatarPlaceholder(borderAccentColor),
                      )
                    : _avatarPlaceholder(borderAccentColor),
              ),
            ),
            SizedBox(width: 14.w),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${m.firstName} ${m.surname}',
                    style: AppTextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (m.villageName != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14.sp,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          m.villageName!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 6.h),
                  _buildTagRow(m),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagRow(Member m) {
    final tags = <Widget>[];
    if (m.gender != null) {
      tags.add(_tag(m.gender!.toUpperCase(), m.gender!));
    }
    if (m.jobType != null && m.jobType != 'none') {
      tags.add(_tag(m.jobType!.toUpperCase(), m.jobType!));
    }
    if (tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: tags,
    );
  }

  Widget _tag(String label, String rawValue) {
    // Custom colors for tags based on content
    Color bgColor = AppColors.primarySurface;
    Color fgColor = AppColors.primary;

    final lower = rawValue.toLowerCase();
    if (lower == 'female') {
      bgColor = AppColors.secondary.withValues(alpha: 0.08);
      fgColor = AppColors.secondary;
    } else if (lower == 'male') {
      bgColor = AppColors.primarySurface;
      fgColor = AppColors.primary;
    } else if (lower == 'government') {
      bgColor = AppColors.success.withValues(alpha: 0.08);
      fgColor = AppColors.success;
    } else if (lower == 'private') {
      bgColor = AppColors.info.withValues(alpha: 0.08);
      fgColor = AppColors.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  Widget _avatarPlaceholder(Color baseColor) {
    return Container(
      width: 48.w,
      height: 48.w,
      color: baseColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.person_rounded,
        size: 24.sp,
        color: baseColor,
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 8,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Shimmer.fromColors(
          baseColor: AppColors.backgroundCream,
          highlightColor: AppColors.backgroundWhite,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: ListTile(
                leading: CircleAvatar(radius: 24.r, backgroundColor: Colors.white),
                title: Container(height: 12.h, color: Colors.white, margin: EdgeInsets.only(right: 60.w)),
                subtitle: Container(height: 10.h, color: Colors.white, margin: EdgeInsets.only(top: 6.h, right: 100.w)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Option {
  final String label;
  final String? value;
  const _Option({required this.label, required this.value});
}
