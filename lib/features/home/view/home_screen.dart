import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

import '../../../app/app_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import 'package:samaj/generated/l10n.dart';
import '../../../core/utils/auth_guard.dart';
import '../../profile/view/profile_screen.dart';
import '../../../core/utils/shared_prefs.dart';
import 'news_page.dart';
import 'gallery_page.dart';
import 'upcoming_events_page.dart';
import '../../advertise/view/advertise_tab.dart';
import 'pragati_mandal_list_page.dart';
import 'shikshan_samiti_list_page.dart';
import 'village_list_page.dart';
import 'samuh_lagna_samiti_list_page.dart';
import 'mahila_mandal_samiti_list_page.dart';
import '../../member/view/all_members_page.dart';

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
              color: Colors.black.withOpacity(0.06),
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
      body: Column(
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
                  Column(
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
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded),
                      color: Colors.white,
                      onPressed: () {
                        // Action for notifications
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Grid Contents
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.05,
                physics: const BouncingScrollPhysics(),
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
          ),
        ],
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
            color: gradient.colors.first.withOpacity(0.25),
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
                    color: Colors.white.withOpacity(0.22),
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
                        color: Colors.black.withOpacity(0.15),
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
