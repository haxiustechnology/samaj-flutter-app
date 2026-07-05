import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/full_screen_image_viewer.dart';
import '../../../data/api/api_client.dart';

@RoutePage()
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient.dio.get('/guest/notifications');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data is List) {
          setState(() {
            _notifications = data;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load notifications history";
      });
      debugPrint("Notifications Fetch Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        title: Text(
          "અગત્યની સૂચનાઓ (Announcements)",
          style: AppTextStyles.appBarTitle.copyWith(fontSize: 16.sp),
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
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        color: AppColors.primary,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: Colors.redAccent),
            SizedBox(height: 12.h),
            Text(
              _errorMessage!,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _fetchNotifications,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("Retry", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 56.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            SizedBox(height: 16.h),
            Text(
              "કોઈ નવી સૂચનાઓ નથી\n(No notifications broadcasted)",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        final title = notif['title'] ?? '';
        final body = notif['body'] ?? '';
        final image = notif['image'] as String?;
        final dateStr = notif['created_at'] != null 
            ? (notif['created_at'].toString().split('T')[0])
            : 'Recently';

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: AppCard(
            hasLeftBorderAccent: true,
            leftBorderColor: AppColors.primary,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.campaign_rounded, color: AppColors.primary, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "સંદેશ (Alert)",
                          style: AppTextStyles.subtitle2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      dateStr,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: AppTextStyles.heading4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (image != null && image.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          color: Colors.black12,
                          height: 150.h,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageViewer(imageUrl: image),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(6.w),
                            child: const Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
