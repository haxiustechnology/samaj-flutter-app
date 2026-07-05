import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';


import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../app/app_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/full_screen_image_viewer.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../core/utils/auth_guard.dart';
import '../../profile/view/profile_screen.dart';

import '../../advertise/view/advertise_tab.dart';
import 'pragati_mandal_list_page.dart';
import 'shikshan_samiti_list_page.dart';
import 'village_list_page.dart';
import 'samuh_lagna_samiti_list_page.dart';
import 'mahila_mandal_samiti_list_page.dart';
import 'notifications_page.dart';
import '../../member/view/all_members_page.dart';

import '../../../data/repositories/guest_repository.dart';
import '../../../data/models/banner_model.dart';
import '../bloc/guest_bloc.dart';


@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const CommunityTab(),
    const AdvertiseTab(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) async {
                if (index == 3) {
                  final allowed = await ensureLoggedIn(context);
                  if (!allowed) return;
                }
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.navActive,
              unselectedItemColor: AppColors.navInactive,
              selectedLabelStyle: AppTextStyles.navLabel.copyWith(
                color: AppColors.navActive,
              ),
              unselectedLabelStyle: AppTextStyles.navLabel.copyWith(
                color: AppColors.navInactive,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.home_rounded, 0),
                  label: S.of(context).home,
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.people_alt_rounded, 1),
                  label: S.of(context).community,
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.campaign_rounded, 2),
                  label: S.of(context).advertise,
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.person_rounded, 3),
                  label: S.of(context).profile,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySurface : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.navInactive,
        size: 24.sp,
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Elegant Header with Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.h, bottom: 24.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).welcomeToApp,
                            style: AppTextStyles.heading3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Prajapati Samaj Community',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none_rounded),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dynamic Banner Slider
            const HomeBannerSlider(),
            
            // Grid Contents
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 20.h),
              child: GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.05,
                children: [
                  _GridItem(
                    icon: Icons.article_rounded,
                    title: S.of(context).news,
                    gradient: AppColors.gridCard1,
                    onTap: () {
                      context.router.push(const NewsRoute());
                    },
                  ),
                  _GridItem(
                    icon: Icons.photo_library_rounded,
                    title: S.of(context).gallery,
                    gradient: AppColors.gridCard2,
                    onTap: () {
                      context.router.push(const GalleryRoute());
                    },
                  ),
                  _GridItem(
                    icon: Icons.event_note_rounded,
                    title: S.of(context).upcomingEvents,
                    gradient: AppColors.gridCard3,
                    onTap: () {
                      context.router.push(const UpcomingEventsRoute());
                    },
                  ),
                  _GridItem(
                    icon: Icons.groups_rounded,
                    title: S.of(context).pragatiMandalList,
                    gradient: AppColors.gridCard4,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PragatiMandalListPage(),
                        ),
                      );
                    },
                  ),
                  _GridItem(
                    icon: Icons.school_rounded,
                    title: S.of(context).shikshanSamitiList,
                    gradient: AppColors.gridCard5,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShikshanSamitiListPage(),
                        ),
                      );
                    },
                  ),
                  _GridItem(
                    icon: Icons.location_city_rounded,
                    title: S.of(context).villageList,
                    gradient: AppColors.gridCard6,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VillageListPage(),
                        ),
                      );
                    },
                  ),
                  _GridItem(
                    icon: Icons.favorite_rounded,
                    title: S.of(context).samuhLagnaSamitiList,
                    gradient: AppColors.gridCard1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SamuhLagnaSamitiListPage(),
                        ),
                      );
                    },
                  ),
                  _GridItem(
                    icon: Icons.female_rounded,
                    title: S.of(context).mahilaMandalSamitiList,
                    gradient: AppColors.gridCard2,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MahilaMandalSamitiListPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _GridItem({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AllMembersPage();
  }
}

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay(int totalPages) {
    _timer?.cancel();
    if (totalPages <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % totalPages;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestBloc(guestRepository: GuestRepository())..add(BannerListEvent()),
      child: BlocBuilder<GuestBloc, GuestState>(
        builder: (context, state) {
          if (state is GuestLoading) {
            return _buildShimmerLoading();
          } else if (state is GuestLoaded) {
            final banners = state.data.cast<BannerModel>();
            if (banners.isEmpty) {
              return const SizedBox.shrink();
            }

            // Start or restart autoplay timer when state completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startAutoPlay(banners.length);
            });

            return Column(
              children: [
                SizedBox(height: 16.h),
                SizedBox(
                  height: 185.h,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImageViewer(imageUrl: banner.image),
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.black87,
                                child: CachedNetworkImage(
                                  imageUrl: banner.image,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (banners.length > 1) ...[
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: _currentPage == index ? 18.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 185.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}
