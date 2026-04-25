// ─── utils/youtube_utils.dart ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeUtils {
  /// Extracts video ID from any YouTube URL format:
  /// https://www.youtube.com/watch?v=gHvX2tmr3jc
  /// https://youtu.be/gHvX2tmr3jc
  /// https://www.youtube.com/shorts/gHvX2tmr3jc
  static String? extractId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }
}

// ─── models/reel_model.dart ───────────────────────────────────────────────
class ReelModel {
  final String id;
  final String youtubeUrl;       // full YouTube URL
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

  // Derived
  String get videoId => YoutubePlayer.convertUrlToId(youtubeUrl) ?? '';

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
    // Paste any YouTube URL directly — playlists, shorts, regular watch URLs
    reels.assignAll([
      ReelModel(
        id: '1',
        youtubeUrl: 'https://www.youtube.com/watch?v=gHvX2tmr3jc&list=PLfTK-B0vyWwbSWxnLWX-YkBkCJX6sKdFK&index=11',
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
        youtubeUrl: 'https://www.youtube.com/watch?v=ANOTHER_ID',
        doctorName: 'Dr. Rahul Mehta',
        specialty: 'Neurologist',
        hospital: 'Fortis Mumbai',
        topic: 'Migraine vs Headache',
        description: 'These two are often confused. Here\'s how to tell them apart.',
        tag: 'Neurology',
        likeCount: 9200,
        commentCount: 521,
        shareCount: 1800,
        isVerified: true,
      ),
    ]);
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

  // One YoutubePlayerController per reel
  final Map<int, YoutubePlayerController> _ytControllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.reels.isNotEmpty) _initYT(0);
    });
  }

  void _initYT(int index) {
    if (_ytControllers.containsKey(index)) return;
    final reel = controller.reels[index];

    _ytControllers[index] = YoutubePlayerController(
      initialVideoId: reel.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: index == controller.currentIndex.value,
        mute: false,
        loop: true,
        forceHD: false,
        enableCaption: false,
        hideControls: true,       // hide YouTube controls — use your own UI
        hideThumbnail: true,
      ),
    );
  }

  void _onPageChanged(int index) {
    // Pause old
    _ytControllers[controller.currentIndex.value]?.pause();
    controller.currentIndex.value = index;
    // Init + play new
    _initYT(index);
    _ytControllers[index]?.play();
    // Preload next
    if (index + 1 < controller.reels.length) _initYT(index + 1);
  }

  @override
  void dispose() {
    for (final c in _ytControllers.values) c.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lock to portrait for reels feel
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
            // ── Vertical reel feed ──
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: controller.reels.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                _initYT(index); // ensure initialized
                return _ReelItem(
                  reel: controller.reels[index],
                  ytController: _ytControllers[index],
                  shortsController: controller,
                );
              },
            ),

            // ── Top bar ──
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Health Shorts',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 8)])),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Dot scroll indicator ──
            Positioned(
              right: 6,
              top: MediaQuery.of(context).size.height * 0.35,
              child: Obx(() => Column(
                    children: List.generate(controller.reels.length, (i) {
                      final active = i == controller.currentIndex.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        width: 3,
                        height: active ? 20 : 6,
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.white38,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  )),
            ),
          ],
        );
      }),
    );
  }
}

// ─── widgets/_reel_item.dart ──────────────────────────────────────────────
class _ReelItem extends StatelessWidget {
  final ReelModel reel;
  final YoutubePlayerController? ytController;
  final ShortsController shortsController;

  const _ReelItem({
    required this.reel,
    required this.shortsController,
    this.ytController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── YouTube Player ──
        if (ytController != null)
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: ytController!,
              showVideoProgressIndicator: false,
            ),
            builder: (context, player) {
              return SizedBox(
                width: size.width,
                height: size.height,
                child: FittedBox(
                  fit: BoxFit.cover,       // crop to fill like a reel
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * 9 / 16, // 16:9 → cropped to fill
                    child: player,
                  ),
                ),
              );
            },
          )
        else
          // Fallback thumbnail while player initializes
          Container(
            color: Colors.black,
            child: Image.network(
              'https://img.youtube.com/vi/${reel.videoId}/maxresdefault.jpg',
              fit: BoxFit.cover,
              width: size.width,
              height: size.height,
            ),
          ),

        // ── Dark gradient scrim ──
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

        // ── Bottom info overlay ──
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
                // Tag chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(reel.tag,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11)),
                ),
                const SizedBox(height: 10),
                Text(reel.topic,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(reel.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12)),
                const SizedBox(height: 14),
                // Doctor row
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Flexible(
                              child: Text(reel.doctorName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ),
                            if (reel.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified,
                                  color: Colors.lightBlueAccent,
                                  size: 14),
                            ]
                          ]),
                          Text('${reel.specialty} · ${reel.hospital}',
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
                          style: TextStyle(
                              color: Colors.white, fontSize: 12)),
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
                    icon: shortsController.isLiked(reel.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: shortsController.formatCount(reel.likeCount +
                        (shortsController.isLiked(reel.id) ? 1 : 0)),
                    color: shortsController.isLiked(reel.id)
                        ? Colors.redAccent
                        : Colors.white,
                    onTap: () => shortsController.toggleLike(reel.id),
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.comment_outlined,
                    label: shortsController.formatCount(reel.commentCount),
                    onTap: () => _showComments(context),
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: shortsController.formatCount(reel.shareCount),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: shortsController.isSaved(reel.id)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    label: 'Save',
                    color: shortsController.isSaved(reel.id)
                        ? Colors.amberAccent
                        : Colors.white,
                    onTap: () => shortsController.toggleSave(reel.id),
                  ),
                  const SizedBox(height: 20),
                  // Tap to open full YouTube
                  _ActionButton(
                    icon: Icons.open_in_new,
                    label: 'YouTube',
                    onTap: () {
                      // launch(reel.youtubeUrl) with url_launcher
                    },
                  ),
                ],
              )),
        ),
      ],
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
                          style:
                              const TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                        ['Aryan K.', 'Riya M.', 'Suresh P.'][i],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13)),
                    subtitle: Text(
                      [
                        'Very informative, thank you doctor!',
                        'Finally someone explained this clearly.',
                        'Sharing this with my family.',
                      ][i],
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12),
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