import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ─── models/reel_model.dart ───────────────────────────────────────────────
class ReelModel {
  final String id;
  final String youtubeUrl;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String topic;
  final String description;
  final String tag;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isVerified;

  // Extract video ID from any YouTube URL
// ─── Fix 1: videoId getter in ReelModel ───────────────────────────────────
  String get videoId {
    final uri = Uri.tryParse(youtubeUrl);
    if (uri == null) return '';

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    if (uri.host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    }

    // Shorts — filter empty segments, ignore ?si= params automatically via URI parsing
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.contains('shorts')) {
      final idx = segments.indexOf('shorts');
      if (idx + 1 < segments.length) return segments[idx + 1];
    }

    return '';
  }

  ReelModel({
    required this.id,
    required this.youtubeUrl,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.topic,
    required this.description,
    required this.tag,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isVerified,
  });
}

// ─── controllers/shorts_controller.dart ──────────────────────────────────
class ShortsController extends GetxController {
  final RxList<ReelModel> reels = <ReelModel>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxSet<String> likedReels = <String>{}.obs;
  final RxSet<String> savedReels = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadReels();
  }

  void loadReels() {
    final reels = [
      ReelModel(
        id: '1',
        youtubeUrl: 'https://www.youtube.com/shorts/0OZwQuYXvR0',
        doctorName: 'Dr. Priya Sharma',
        specialty: 'Cardiologist',
        hospital: 'AIIMS Delhi',
        topic: '5 Warning Signs of Heart Disease',
        description: 'Watch for these early symptoms that most people ignore.',
        tag: 'Cardiology',
        likeCount: 12400,
        commentCount: 843,
        shareCount: 2100,
        isVerified: true,
      ),
      ReelModel(
        id: '2',
        youtubeUrl: 'https://www.youtube.com/shorts/87mHqOU6tXE',
        doctorName: 'Dr. Rahul Mehta',
        specialty: 'Neurologist',
        hospital: 'Fortis Hospital, Mumbai',
        topic: 'Migraine vs Headache — Know the Difference',
        description:
            'These two are often confused. Here\'s how to tell them apart quickly.',
        tag: 'Neurology',
        likeCount: 9200,
        commentCount: 521,
        shareCount: 1800,
        isVerified: true,
      ),
      ReelModel(
        id: '3',
        youtubeUrl: 'https://www.youtube.com/shorts/4dPo640kWmk',
        doctorName: 'Dr. Sneha Iyer',
        specialty: 'Dermatologist',
        hospital: 'Apollo Hospitals, Chennai',
        topic: 'Why Is Your Skin So Dry?',
        description: 'Common mistakes that damage your skin barrier every day.',
        tag: 'Dermatology',
        likeCount: 15300,
        commentCount: 1102,
        shareCount: 3400,
        isVerified: true,
      ),
      ReelModel(
        id: '4',
        youtubeUrl: 'https://youtube.com/shorts/HnmdbLk1Kdk',
        doctorName: 'Dr. Arjun Kapoor',
        specialty: 'Orthopedic Surgeon',
        hospital: 'Medanta, Gurugram',
        topic: 'Fix Your Posture in 60 Seconds',
        description: 'Simple daily exercises to prevent chronic back pain.',
        tag: 'Orthopedics',
        likeCount: 21000,
        commentCount: 1430,
        shareCount: 5200,
        isVerified: true,
      ),
      ReelModel(
        id: '5',
        youtubeUrl: 'https://www.youtube.com/shorts/eLGTAlNJrcs',
        doctorName: 'Dr. Meera Nair',
        specialty: 'Endocrinologist',
        hospital: 'Kokilaben Hospital, Mumbai',
        topic: 'Signs Your Thyroid Is Struggling',
        description: 'Fatigue, weight gain, hair fall — could all be thyroid.',
        tag: 'Endocrinology',
        likeCount: 18700,
        commentCount: 964,
        shareCount: 4100,
        isVerified: true,
      ),
      ReelModel(
        id: '6',
        youtubeUrl: 'https://www.youtube.com/shorts/KLnnMH46IZU',
        doctorName: 'Dr. Vikram Bose',
        specialty: 'Pulmonologist',
        hospital: 'PGIMER, Chandigarh',
        topic: 'How Smoking Destroys Your Lungs',
        description:
            'A visual breakdown of what happens inside your lungs with every cigarette.',
        tag: 'Pulmonology',
        likeCount: 33200,
        commentCount: 2810,
        shareCount: 9800,
        isVerified: true,
      ),
      ReelModel(
        id: '7',
        youtubeUrl: 'https://www.youtube.com/shorts/wrBMw9DIAos',
        doctorName: 'Dr. Ananya Roy',
        specialty: 'Psychiatrist',
        hospital: 'NIMHANS, Bengaluru',
        topic: 'Is It Anxiety or Just Stress?',
        description: 'Understanding the difference can change how you cope.',
        tag: 'Mental Health',
        likeCount: 27500,
        commentCount: 3200,
        shareCount: 7600,
        isVerified: true,
      ),
      ReelModel(
        id: '8',
        youtubeUrl: 'https://www.youtube.com/shorts/SET6g-TBVzc',
        doctorName: 'Dr. Suresh Pillai',
        specialty: 'Gastroenterologist',
        hospital: 'CMC Vellore',
        topic: 'Why You Feel Bloated After Every Meal',
        description:
            'Your gut is trying to tell you something. Here\'s how to listen.',
        tag: 'Gastroenterology',
        likeCount: 14100,
        commentCount: 870,
        shareCount: 2900,
        isVerified: true,
      ),
      ReelModel(
        id: '9',
        youtubeUrl: 'https://www.youtube.com/shorts/kWCkCV8ruWI',
        doctorName: 'Dr. Ritu Agarwal',
        specialty: 'Gynecologist',
        hospital: 'Manipal Hospital, Delhi',
        topic: 'PCOS — What Every Woman Should Know',
        description:
            'One of the most common yet misunderstood conditions in women.',
        tag: 'Gynecology',
        likeCount: 41000,
        commentCount: 4500,
        shareCount: 12300,
        isVerified: true,
      ),
      ReelModel(
        id: '10',
        youtubeUrl: 'https://www.youtube.com/shorts/P5tmbnFH33k',
        doctorName: 'Dr. Karan Malhotra',
        specialty: 'Diabetologist',
        hospital: 'Max Hospital, New Delhi',
        topic: 'Pre-Diabetes: The Silent Warning',
        description:
            'Millions have it and don\'t know. Catch it before it turns into Type 2.',
        tag: 'Diabetes',
        likeCount: 19800,
        commentCount: 1340,
        shareCount: 5600,
        isVerified: true,
      ),
      ReelModel(
        id: '11',
        youtubeUrl: 'https://www.youtube.com/shorts/vRvJsubQiNQ',
        doctorName: 'Dr. Divya Menon',
        specialty: 'Ophthalmologist',
        hospital: 'Sankara Nethralaya, Chennai',
        topic: 'Screen Time Is Damaging Your Eyes',
        description: 'The 20-20-20 rule and other tips to protect your vision.',
        tag: 'Ophthalmology',
        likeCount: 22600,
        commentCount: 1780,
        shareCount: 6400,
        isVerified: true,
      ),
      ReelModel(
        id: '12',
        youtubeUrl: 'https://www.youtube.com/shorts/4dPo640kWmk',
        doctorName: 'Dr. Aditya Sharma',
        specialty: 'Nephrologist',
        hospital: 'SGPGI, Lucknow',
        topic: 'Your Kidneys Are Sending You Signals',
        description:
            'Swollen feet, foamy urine — don\'t ignore these kidney warning signs.',
        tag: 'Nephrology',
        likeCount: 16400,
        commentCount: 990,
        shareCount: 3800,
        isVerified: true,
      ),
    ];

    // Sanity check — remove in production
    for (final r in reels) {
      assert(r.videoId.isNotEmpty,
          'Bad videoId for reel ${r.id}: ${r.youtubeUrl}');
      debugPrint('Reel ${r.id} → videoId: "${r.videoId}"');
    }

    this.reels.assignAll(reels);
  }

  void toggleLike(String id) =>
      likedReels.contains(id) ? likedReels.remove(id) : likedReels.add(id);

  void toggleSave(String id) =>
      savedReels.contains(id) ? savedReels.remove(id) : savedReels.add(id);

  bool isLiked(String id) => likedReels.contains(id);
  bool isSaved(String id) => savedReels.contains(id);

  String formatCount(int count) =>
      count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}K' : '$count';
}

// ─── pages/health_shorts_page.dart ───────────────────────────────────────
class HealthShortsPage extends StatefulWidget {
  const HealthShortsPage({super.key});

  @override
  State<HealthShortsPage> createState() => _HealthShortsPageState();
}

class _HealthShortsPageState extends State<HealthShortsPage> {
  final ShortsController controller = Get.put(ShortsController());
  final PageController _pageController = PageController();
  final Map<int, YoutubePlayerController> _ytControllers = {};
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.reels.isNotEmpty) {
        _prepareController(0);
        _prepareController(1);
      }
    });
  }

  void _prepareController(int index) {
    if (index < 0 || index >= controller.reels.length) return;
    if (_ytControllers.containsKey(index)) return;

    _ytControllers[index] = YoutubePlayerController(
      initialVideoId: controller.reels[index].videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        hideThumbnail: true,
        disableDragSeek: true,
        useHybridComposition: true,
      ),
    );
  }

  void _onVisibilityChanged(int index, double visibleFraction) {
    if (!mounted) return;

    if (visibleFraction >= 0.8) {
      // ── This reel is now fully visible ──
      _prepareController(index);
      _prepareController(index + 1); // pre-init next

      if (_currentPage != index) {
        // Pause the old one
        _ytControllers[_currentPage]?.pause();
        _ytControllers[_currentPage]?.seekTo(Duration.zero);
        _currentPage = index;
        controller.currentIndex.value = index;
      }

      // Play after short delay to let WebView settle
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _ytControllers[index]?.play();
      });
    } else if (visibleFraction < 0.2) {
      // ── This reel scrolled away ──
      _ytControllers[index]?.pause();
      _ytControllers[index]?.seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    for (final c in _ytControllers.values) c.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Obx(() {
        if (controller.reels.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: controller.reels.length,
              itemBuilder: (context, index) {
                _prepareController(index);
                return _ReelItem(
                  key: ValueKey('reel_$index'),
                  index: index,
                  reel: controller.reels[index],
                  ytController: _ytControllers[index],
                  shortsController: controller,
                  onVisibilityChanged: _onVisibilityChanged,
                );
              },
            ),

            // ── Top bar ──
            // SafeArea(
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const Text(
            //           'Health Shorts',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             shadows: [Shadow(blurRadius: 8)],
            //           ),
            //         ),
            //         // IconButton(
            //         //   icon: const Icon(Icons.search, color: Colors.white),
            //         //   onPressed: () {},
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),

            // ── Dot indicator ──
            // Positioned(
            //   right: 6,
            //   top: MediaQuery.of(context).size.height * 0.35,
            //   child: Obx(() => Column(
            //         children: List.generate(controller.reels.length, (i) {
            //           final active = i == controller.currentIndex.value;
            //           return AnimatedContainer(
            //             duration: const Duration(milliseconds: 250),
            //             margin: const EdgeInsets.symmetric(vertical: 3),
            //             width: 3,
            //             height: active ? 20 : 6,
            //             decoration: BoxDecoration(
            //               color: active ? Colors.white : Colors.white38,
            //               borderRadius: BorderRadius.circular(2),
            //             ),
            //           );
            //         }),
            //       )),
            // ),
          ],
        );
      }),
    );
  }
}

// ─── widgets/_reel_item.dart ──────────────────────────────────────────────
class _ReelItem extends StatefulWidget {
  final int index;
  final ReelModel reel;
  final YoutubePlayerController? ytController;
  final ShortsController shortsController;
  final void Function(int index, double visibleFraction) onVisibilityChanged;

  const _ReelItem({
    super.key,
    required this.index,
    required this.reel,
    required this.shortsController,
    required this.onVisibilityChanged,
    this.ytController,
  });

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return VisibilityDetector(
      key: Key('reel_visibility_${widget.index}'),
      onVisibilityChanged: (info) =>
          widget.onVisibilityChanged(widget.index, info.visibleFraction),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── YouTube Player ──
          if (widget.ytController != null)
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: widget.ytController!,
                showVideoProgressIndicator: false,
              ),
              builder: (context, player) => SizedBox(
                width: size.width,
                height: size.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * (16 / 9),
                    child: player,
                  ),
                ),
              ),
            )
          else
            Image.network(
              'https://img.youtube.com/vi/${widget.reel.videoId}/maxresdefault.jpg',
              fit: BoxFit.cover,
              width: size.width,
              height: size.height,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),

          // ── Gradient scrim ──
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.4, 1.0],
              ),
            ),
          ),

          // ── Bottom info ──
          Positioned(
            left: 0,
            right: 60,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(widget.reel.tag,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.reel.topic,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(widget.reel.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85), fontSize: 12)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Flexible(
                                child: Text(widget.reel.doctorName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                              ),
                              if (widget.reel.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified,
                                    color: Colors.lightBlueAccent, size: 14),
                              ]
                            ]),
                            Text(
                                '${widget.reel.specialty} · ${widget.reel.hospital}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Follow',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Right action buttons ──
          Positioned(
            right: 8,
            bottom: 100,
            child: Obx(() => Column(
                  children: [
                    _ActionButton(
                      icon: widget.shortsController.isLiked(widget.reel.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: widget.shortsController.formatCount(
                          widget.reel.likeCount +
                              (widget.shortsController.isLiked(widget.reel.id)
                                  ? 1
                                  : 0)),
                      color: widget.shortsController.isLiked(widget.reel.id)
                          ? Colors.redAccent
                          : Colors.white,
                      onTap: () =>
                          widget.shortsController.toggleLike(widget.reel.id),
                    ),
                    const SizedBox(height: 20),
                    _ActionButton(
                      icon: Icons.comment_outlined,
                      label: widget.shortsController
                          .formatCount(widget.reel.commentCount),
                      onTap: () => _showComments(context),
                    ),
                    const SizedBox(height: 20),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: widget.shortsController
                          .formatCount(widget.reel.shareCount),
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _ActionButton(
                      icon: widget.shortsController.isSaved(widget.reel.id)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      label: 'Save',
                      color: widget.shortsController.isSaved(widget.reel.id)
                          ? Colors.amberAccent
                          : Colors.white,
                      onTap: () =>
                          widget.shortsController.toggleSave(widget.reel.id),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Comments',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: 3,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white12),
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Text(['A', 'R', 'S'][i],
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(['Aryan K.', 'Riya M.', 'Suresh P.'][i],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13)),
                    subtitle: Text(
                      [
                        'Very informative, thank you doctor!',
                        'Finally someone explained this clearly.',
                        'Sharing this with my family.',
                      ][i],
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── widgets/_action_button.dart ─────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
