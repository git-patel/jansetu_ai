import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../core/config/service_locator.dart';
import '../../services/local_persistence_service.dart';

/// Floating AI Assistant Widget (FloatingAiAssistant)
/// A floating conversational helper available across all persona workspaces (Citizen, MP, State Admin).
/// Powered by Gemini 2.5 Pro synthetic responses tailored to the active role.
class FloatingAiAssistant extends StatefulWidget {
  const FloatingAiAssistant({super.key});

  @override
  State<FloatingAiAssistant> createState() => _FloatingAiAssistantState();
}

class _FloatingAiAssistantState extends State<FloatingAiAssistant> {
  void _showAiDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AiAssistantSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAiDialog(context),
      backgroundColor: JanSetuColors.slateNavy,
      elevation: 6,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome_rounded, color: JanSetuColors.emeraldGreen, size: 18),
      ),
      label: const Text(
        'JanSetu AI',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _AiAssistantSheet extends StatefulWidget {
  const _AiAssistantSheet();

  @override
  State<_AiAssistantSheet> createState() => _AiAssistantSheetState();
}

class _AiAssistantSheetState extends State<_AiAssistantSheet> {
  final TextEditingController _queryCtrl = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    final role = LocalPersistenceService.activeRole ?? 'CITIZEN';
    if (role == 'MP') {
      _messages.add({
        'sender': 'ai',
        'text': '👋 **Good Morning Hon. C.R. Patil, MP!**\nI am your Gemini 2.5 Pro Constituency Executive Assistant. How can I assist with your Ward Deficit Heatmap, Priority Queue approvals, or MPLADS budget burn today?',
      });
    } else if (role == 'ADMIN') {
      _messages.add({
        'sender': 'ai',
        'text': '👋 **Good Morning State Administrator!**\nI am your Gemini 2.5 Pro State Intelligence Copilot. Ask me about district health, department SLA velocity, or budget utilization across Gujarat!',
      });
    } else {
      _messages.add({
        'sender': 'ai',
        'text': '👋 **Namaste Citizen!**\nI am your 24x7 JanSetu Civic Helper. Ask me about ongoing road works in Ward 14 Adajan, report an issue, or check municipal SLAs!',
      });
    }
  }

  Future<void> _sendQuery(String queryText) async {
    if (queryText.trim().isEmpty) return;
    final text = queryText.trim();
    _queryCtrl.clear();

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isThinking = true;
    });

    try {
      final role = LocalPersistenceService.activeRole ?? 'CITIZEN';
      final aiRepo = ServiceLocator.instance.aiRepository;
      final reply = await aiRepo.chatAssistant(text, _messages, role: role);

      if (mounted) {
        setState(() {
          _isThinking = false;
          _messages.add({'sender': 'ai', 'text': reply});
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isThinking = false;
          _messages.add({'sender': 'ai', 'text': '🤖 **AI Engine Notice:** Unable to reach cloud inference endpoint. Switching to offline cache. Please try again.'});
        });
      }
    }
  }

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxH = MediaQuery.of(context).size.height * 0.75;
    final role = LocalPersistenceService.activeRole ?? 'CITIZEN';

    return Container(
      height: maxH,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: JanSetuColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: JanSetuColors.emeraldGreen, width: 2)),
      ),
      child: Column(
        children: [
          // Drag Handle & Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: JanSetuColors.darkBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: JanSetuColors.emeraldGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role == 'MP' ? 'Gemini 2.5 Pro Executive Copilot' : 'Gemini 2.5 Pro Civic Assistant',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          role == 'MP' ? 'Constituency Decision Support & MPLADS Intelligence' : 'Live Municipal Knowledge & GIS Synthesis',
                          style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Quick Prompt Suggestion Chips (Role-Tailored)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: JanSetuColors.darkSurface.withValues(alpha: 0.5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: role == 'MP'
                  ? [
                      _buildPromptChip('What should I approve first?'),
                      _buildPromptChip('Why is this project delayed?'),
                      _buildPromptChip('Which department is underperforming?'),
                      _buildPromptChip('Compare this ward with another'),
                      _buildPromptChip('Generate constituency report'),
                      _buildPromptChip('Summarize today\'s priorities'),
                    ]
                  : role == 'ADMIN'
                      ? [
                          _buildPromptChip('Which district requires immediate attention?'),
                          _buildPromptChip('Compare Surat and Ahmedabad'),
                          _buildPromptChip('Which MP has the best completion rate?'),
                          _buildPromptChip('Which department is underperforming?'),
                          _buildPromptChip('Generate state report'),
                          _buildPromptChip('Explain budget utilization'),
                        ]
                      : [
                          _buildPromptChip('What wards need immediate sanction?'),
                          _buildPromptChip('Show MPLADS budget breakdown'),
                          _buildPromptChip('Explain 6-Stage project timeline'),
                          _buildPromptChip('Who is responsible for Ward 14?'),
                        ],
            ),
          ),

          // Conversation Messages List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildThinkingBubble();
                }
                final msg = _messages[index];
                final isAi = msg['sender'] == 'ai';
                return _buildMessageBubble(msg['text']!, isAi);
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: JanSetuColors.darkSurface,
              border: Border(top: BorderSide(color: JanSetuColors.darkBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: role == 'MP' ? 'Ask AI Copilot about sanctions, delays, budgets...' : 'Ask Gemini about budgets, SLAs, wards...',
                      hintStyle: const TextStyle(color: JanSetuColors.darkTextSecondary),
                      filled: true,
                      fillColor: JanSetuColors.darkBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                    onSubmitted: _sendQuery,
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => _sendQuery(_queryCtrl.text),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: JanSetuColors.emeraldGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 11, fontWeight: FontWeight.w600)),
        backgroundColor: JanSetuColors.emeraldGreen.withValues(alpha: 0.1),
        side: BorderSide(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _sendQuery(text),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isAi) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAi ? JanSetuColors.darkSurface : JanSetuColors.electricBlue,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isAi ? 4 : 16),
            bottomRight: Radius.circular(isAi ? 16 : 4),
          ),
          border: isAi ? Border.all(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.3)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
            ),
            if (isAi) ...[
              const SizedBox(height: 12),
              const Divider(color: JanSetuColors.darkBorder, height: 1),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📋 Copied AI response to clipboard!'), duration: Duration(seconds: 1)));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.copy, size: 12, color: JanSetuColors.emeraldGreen), SizedBox(width: 4), Text('Copy', style: TextStyle(fontSize: 10, color: JanSetuColors.emeraldGreen))]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔄 Regenerating AI insight...'), duration: Duration(seconds: 1)));
                      if (_messages.length > 1) {
                        final lastUser = _messages[_messages.length - 2]['text'] ?? 'Summarize status';
                        _sendQuery(lastUser);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.refresh, size: 12, color: JanSetuColors.saffronGold), SizedBox(width: 4), Text('Regenerate', style: TextStyle(fontSize: 10, color: JanSetuColors.saffronGold))]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => _messages.clear());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🗑️ Chat history cleared!'), duration: Duration(seconds: 1)));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.delete_outline, size: 12, color: Colors.grey), SizedBox(width: 4), Text('Clear', style: TextStyle(fontSize: 10, color: Colors.grey))]),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: JanSetuColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: JanSetuColors.emeraldGreen),
            ),
            SizedBox(width: 12),
            Text('Gemini 2.5 Pro is synthesizing municipal data...', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
