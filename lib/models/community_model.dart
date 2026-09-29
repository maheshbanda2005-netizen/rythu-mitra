class CommunityPost {
  final String id;
  final String authorName;
  final String authorLocation;
  final String cropTag;
  final String questionText;
  final String? audioQueryDuration;
  final String timeAgo;
  final int likes;
  final int commentsCount;
  final bool isAnsweredByExpert;
  final String? expertAnswer;

  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.cropTag,
    required this.questionText,
    this.audioQueryDuration,
    required this.timeAgo,
    required this.likes,
    required this.commentsCount,
    this.isAnsweredByExpert = false,
    this.expertAnswer,
  });
}
