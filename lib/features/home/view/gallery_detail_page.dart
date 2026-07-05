import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class GalleryDetailPage extends StatefulWidget {
  final String mediaUrl;
  final String mediaType;

  const GalleryDetailPage({
    Key? key,
    required this.mediaUrl,
    required this.mediaType,
  }) : super(key: key);

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl))
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
          _videoController?.play();
          _videoController?.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.mediaType == 'video';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: isVideo
            ? _buildVideoPlayer()
            : _buildImageViewer(),
      ),
    );
  }

  Widget _buildImageViewer() {
    return InteractiveViewer(
      panEnabled: true,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 4.0,
      child: CachedNetworkImage(
        imageUrl: widget.mediaUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        errorWidget: (context, url, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_rounded, color: Colors.white70, size: 48.sp),
              SizedBox(height: 12.h),
              Text(
                "Failed to load image",
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
        _buildPlayPauseOverlay(),
        _buildVideoProgressIndicator(),
      ],
    );
  }

  Widget _buildPlayPauseOverlay() {
    final isPlaying = _videoController?.value.isPlaying ?? false;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isPlaying) {
            _videoController?.pause();
          } else {
            _videoController?.play();
          }
        });
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: AnimatedOpacity(
            opacity: isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoProgressIndicator() {
    return Positioned(
      bottom: 24.h,
      left: 16.w,
      right: 16.w,
      child: SafeArea(
        top: false,
        child: VideoProgressIndicator(
          _videoController!,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: AppColors.primary,
            bufferedColor: Colors.white24,
            backgroundColor: Colors.white12,
          ),
        ),
      ),
    );
  }
}
