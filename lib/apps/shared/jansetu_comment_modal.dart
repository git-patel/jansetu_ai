import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../services/local_persistence_service.dart';

/// Real Discussion Area Bottom Sheet (JanSetuCommentModal)
/// Implements Prompt 08 comment rules: View all, Write, Reply, Edit own, Delete own, Mention user, Time ago, Like, Report, Auto scroll.
class JanSetuCommentModal extends StatefulWidget {
  final int needIndex;
  final String needTitle;
  final List<Map<String, dynamic>> initialComments;
  final VoidCallback? onCommentsUpdated;

  const JanSetuCommentModal({
    super.key,
    required this.needIndex,
    required this.needTitle,
    required this.initialComments,
    this.onCommentsUpdated,
  });

  static void show(
    BuildContext context, {
    required int needIndex,
    required String needTitle,
    required List<Map<String, dynamic>> comments,
    VoidCallback? onCommentsUpdated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => JanSetuCommentModal(
        needIndex: needIndex,
        needTitle: needTitle,
        initialComments: comments,
        onCommentsUpdated: onCommentsUpdated,
      ),
    );
  }

  @override
  State<JanSetuCommentModal> createState() => _JanSetuCommentModalState();
}

class _JanSetuCommentModalState extends State<JanSetuCommentModal> {
  late List<Map<String, dynamic>> _comments;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _replyingToAuthor;
  int? _editingCommentIndex;

  @override
  void initState() {
    super.initState();
    _comments = List<Map<String, dynamic>>.from(widget.initialComments);
    // Auto scroll to latest after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && _comments.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTimeAgo(String? timestamp) {
    if (timestamp == null) return 'Just now';
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return '1h ago';
    }
  }

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (_editingCommentIndex != null && _editingCommentIndex! < _comments.length) {
      // Edit existing comment
      final updated = Map<String, dynamic>.from(_comments[_editingCommentIndex!]);
      updated['content'] = text;
      updated['edited'] = true;
      setState(() {
        _comments[_editingCommentIndex!] = updated;
        _editingCommentIndex = null;
      });
      await LocalPersistenceService.updateCommentOnNeed(widget.needIndex, _editingCommentIndex ?? 0, updated);
    } else {
      // Create new comment
      String content = text;
      if (_replyingToAuthor != null) {
        content = '@$_replyingToAuthor $text';
      }
      final newCmt = {
        'id': 'cmt-${DateTime.now().millisecondsSinceEpoch}',
        'authorName': 'Harsh (You)',
        'authorRole': 'Ward 14 Resident',
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
        'likes': 0,
        'isOwn': true,
      };
      setState(() {
        _comments.add(newCmt);
        _replyingToAuthor = null;
      });
      await LocalPersistenceService.addCommentToNeed(widget.needIndex, newCmt);
      _scrollToBottom();
    }

    _controller.clear();
    widget.onCommentsUpdated?.call();
  }

  void _handleDelete(int idx) async {
    setState(() {
      _comments.removeAt(idx);
    });
    await LocalPersistenceService.updateCommentOnNeed(widget.needIndex, idx, null);
    widget.onCommentsUpdated?.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment deleted.'), duration: Duration(seconds: 2)),
      );
    }
  }

  void _handleLike(int idx) async {
    final cmt = Map<String, dynamic>.from(_comments[idx]);
    cmt['likes'] = ((cmt['likes'] as num?)?.toInt() ?? 0) + 1;
    setState(() {
      _comments[idx] = cmt;
    });
    await LocalPersistenceService.updateCommentOnNeed(widget.needIndex, idx, cmt);
  }

  void _insertMention(String mention) {
    final current = _controller.text;
    _controller.text = '$current @$mention '.trimLeft();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  }

  Widget _buildEmojiChip(String emoji) {
    return InkWell(
      onTap: () {
        _controller.text = '${_controller.text}$emoji ';
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
        child: Text(emoji, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: JanSetuColors.slateNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(JanSetuTheme.radiusLarge)),
      ),
      child: Column(
        children: [
          // Handle & Title Bar
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space16),
            decoration: BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(JanSetuTheme.radiusLarge)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Community Discussion (${_comments.length})',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.needTitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[400],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Comments List
          Expanded(
            child: _comments.isEmpty
                ? const Center(
                    child: Text(
                      'No comments yet. Be the first to start the discussion!',
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(JanSetuTheme.space16),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final cmt = _comments[index];
                      final isOwn = cmt['isOwn'] == true || cmt['authorName'] == 'Harsh (You)';
                      final author = cmt['authorName'] ?? 'Citizen';
                      final role = cmt['authorRole'] ?? 'Local Resident';
                      final content = cmt['content'] ?? '';
                      final likes = (cmt['likes'] as num?)?.toInt() ?? 0;
                      final timeAgo = _formatTimeAgo(cmt['timestamp']);
                      final edited = cmt['edited'] == true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: JanSetuTheme.space16),
                        padding: const EdgeInsets.all(JanSetuTheme.space12),
                        decoration: BoxDecoration(
                          color: isOwn
                              ? JanSetuColors.electricBlue.withValues(alpha: 0.12)
                              : JanSetuColors.darkSurface,
                          borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
                          border: Border.all(
                            color: isOwn
                                ? JanSetuColors.electricBlue.withValues(alpha: 0.4)
                                : JanSetuColors.darkBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: isOwn ? JanSetuColors.electricBlue : JanSetuColors.saffronGold,
                                      child: Text(
                                        author.isNotEmpty ? author[0].toUpperCase() : 'C',
                                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              author,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                            ),
                                            if (edited) ...[
                                              const SizedBox(width: 4),
                                              const Text('(edited)', style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          role,
                                          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  timeAgo,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: JanSetuTheme.space8),
                            Text(
                              content,
                              style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.white),
                            ),
                            const SizedBox(height: JanSetuTheme.space8),
                            // Actions bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => _handleLike(index),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(likes > 0 ? '$likes' : 'Like', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _replyingToAuthor = author;
                                    });
                                  },
                                  child: const Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    child: Text('Reply', style: TextStyle(fontSize: 11, color: JanSetuColors.electricBlue, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                if (isOwn) ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _editingCommentIndex = index;
                                        _controller.text = content;
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      child: Text('Edit', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => _handleDelete(index),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      child: Text('Delete', style: TextStyle(fontSize: 11, color: JanSetuColors.crimsonAlert, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Comment reported to State Vigilance moderator.'), duration: Duration(seconds: 2)),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      child: Text('Report', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Emoji quick bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16, vertical: 4),
            color: JanSetuColors.darkSurface,
            child: Row(
              children: [
                const Text('Emoji: ', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                _buildEmojiChip('👍'),
                const SizedBox(width: 6),
                _buildEmojiChip('❤️'),
                const SizedBox(width: 6),
                _buildEmojiChip('⚡'),
                const SizedBox(width: 6),
                _buildEmojiChip('🚀'),
                const SizedBox(width: 6),
                _buildEmojiChip('🚨'),
                const SizedBox(width: 6),
                _buildEmojiChip('👏'),
              ],
            ),
          ),
          // Mentions bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16, vertical: 4),
            color: JanSetuColors.darkSurface,
            child: Row(
              children: [
                const Text('Mention: ', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                ActionChip(
                  label: const Text('@Officer', style: TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: Colors.white10,
                  onPressed: () => _insertMention('Officer'),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('@MP', style: TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: Colors.white10,
                  onPressed: () => _insertMention('MP'),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('@Rajesh', style: TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: Colors.white10,
                  onPressed: () => _insertMention('Rajesh'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          // Input bar
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space12),
            decoration: BoxDecoration(
              color: JanSetuColors.slateNavy,
              border: const Border(top: BorderSide(color: JanSetuColors.darkBorder)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_replyingToAuthor != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text('Replying to @$_replyingToAuthor', style: const TextStyle(fontSize: 11, color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        InkWell(
                          onTap: () => setState(() => _replyingToAuthor = null),
                          child: const Icon(Icons.close, size: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                if (_editingCommentIndex != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Text('Editing your comment', style: TextStyle(fontSize: 11, color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _editingCommentIndex = null;
                              _controller.clear();
                            });
                          },
                          child: const Icon(Icons.close, size: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: _editingCommentIndex != null
                              ? 'Edit comment...'
                              : (_replyingToAuthor != null ? 'Reply to @$_replyingToAuthor...' : 'Add a public comment...'),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                          fillColor: JanSetuColors.darkSurface,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: JanSetuColors.darkBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: JanSetuColors.darkBorder),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          isDense: true,
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: JanSetuColors.electricBlue,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 18),
                        onPressed: _handleSend,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

