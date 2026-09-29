import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/community_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<CommunityPost> _posts = List.from(AgriDataService.communityPosts);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('communityTitle')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAskQuestionDialog(context, appState),
        backgroundColor: const Color(0xFF4F46E5),
        icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
        label: Text(context.tr('communityPostBtn'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 80),
        itemCount: _posts.length,
        separatorBuilder: (_, index) => const SizedBox(height: 16),
        itemBuilder: (context, idx) {
          final post = _posts[idx];
          return _buildPostCard(context, post, isDark, idx);
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, CommunityPost post, bool isDark, int index) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  radius: 20,
                  child: Text(
                    post.authorName.characters.first,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                      Text('${post.authorLocation} • ${post.timeAgo}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    post.cropTag,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.questionText,
              style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // Verified Expert Answer Box
            if (post.isAnsweredByExpert && post.expertAnswer != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1B2F22) : const Color(0xFFEFF8F0),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.verified_rounded, size: 15, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Expert Answer ✓',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.expertAnswer!,
                      style: const TextStyle(fontSize: 12.5, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Action Bar (Likes, Comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _posts[index] = CommunityPost(
                            id: post.id,
                            authorName: post.authorName,
                            authorLocation: post.authorLocation,
                            cropTag: post.cropTag,
                            questionText: post.questionText,
                            timeAgo: post.timeAgo,
                            likes: post.likes + 1,
                            commentsCount: post.commentsCount,
                            isAnsweredByExpert: post.isAnsweredByExpert,
                            expertAnswer: post.expertAnswer,
                          );
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_up_alt_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text('${post.likes} ${context.tr('communityLikes')}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        const Icon(Icons.mode_comment_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${post.commentsCount} ${context.tr('communityReplies')}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.tr('communityReplies'))),
                    );
                  },
                  child: Text(context.tr('communityShare'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAskQuestionDialog(BuildContext context, AppStateService appState) {
    final textCtrl = TextEditingController();
    final lang = appState.currentLanguage;
    String selectedCrop = appState.activeCrop;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF131F17)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr('communityPostBtn'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            TextField(
              controller: textCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: context.tr('searchPlaceholder'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (textCtrl.text.isNotEmpty) {
                  setState(() {
                    _posts.insert(
                      0,
                      CommunityPost(
                        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
                        authorName: appState.farmerName,
                        authorLocation: appState.location,
                        cropTag: selectedCrop,
                        questionText: textCtrl.text.trim(),
                        timeAgo: lang == 'te' ? 'ఇప్పుడే' : (lang == 'hi' ? 'अभी' : 'Just now'),
                        likes: 1,
                        commentsCount: 0,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text(context.tr('communityPostBtn')),
            ),
          ],
        ),
      ),
    );
  }
}
