import 'package:flutter/material.dart';

/// A chat-style AI Assistance screen for DēGlitch.
///
/// Supply [onSendMessage] to connect a real assistant service. If no handler is
/// provided, this screen uses short prototype replies and labels them as demo
/// responses so they are not confused with live diagnostics or an AI model.
class SuperMobileAiAssistance extends StatefulWidget {
  const SuperMobileAiAssistance({
    super.key,
    this.onSendMessage,
    this.onOpenDiagnostics,
    this.onOpenServers,
  });

  /// Called with the user's message. Return the assistant's reply.
  final Future<String> Function(String message)? onSendMessage;

  /// Optional navigation callbacks for contextual actions in a reply.
  final VoidCallback? onOpenDiagnostics;
  final VoidCallback? onOpenServers;

  @override
  State<SuperMobileAiAssistance> createState() =>
      _SuperMobileAiAssistanceState();
}

class _AssistantMessage {
  const _AssistantMessage({
    required this.text,
    required this.fromUser,
    required this.time,
    this.actionLabel,
    this.actionKey,
  });

  final String text;
  final bool fromUser;
  final DateTime time;
  final String? actionLabel;
  final String? actionKey;
}

class _SuperMobileAiAssistanceState extends State<SuperMobileAiAssistance> {
  static const Color _blue = Color(0xFF0878F9);
  static const Color _deepBlue = Color(0xFF12447F);
  static const Color _mutedBlue = Color(0xFF7093B9);
  static const Color _page = Color(0xFFF3F8FD);
  static const Color _line = Color(0xFFDCEBFA);
  static const Color _assistantBubble = Color(0xFFE8F3FF);

  final TextEditingController _composer = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<_AssistantMessage> _messages = <_AssistantMessage>[];

  bool _isTyping = false;
  bool _showSuggestions = true;
  String? _errorText;

  bool get _isDemoMode => widget.onSendMessage == null;

  @override
  void initState() {
    super.initState();
    _messages.add(
      _AssistantMessage(
        text:
            'Hi! I’m DēGlitch Assistant. I can help you understand connection '
            'issues, diagnostics, server choices and connectivity settings. '
            'What would you like help with?',
        fromUser: false,
        time: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _composer.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _send([String? suppliedText]) async {
    final text = (suppliedText ?? _composer.text).trim();
    if (text.isEmpty || _isTyping) return;

    _composer.clear();
    _focusNode.unfocus();
    setState(() {
      _errorText = null;
      _showSuggestions = false;
      _messages.add(
        _AssistantMessage(
          text: text,
          fromUser: true,
          time: DateTime.now(),
        ),
      );
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final reply = widget.onSendMessage != null
          ? await widget.onSendMessage!(text)
          : await _prototypeReply(text);
      if (!mounted) return;
      setState(() {
        _messages.add(
          _AssistantMessage(
            text: reply,
            fromUser: false,
            time: DateTime.now(),
            actionLabel: _suggestActionLabel(text),
            actionKey: _suggestActionKey(text),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _errorText =
            'I could not get a response. Check your connection and try again.';
      });
    }
  }

  Future<String> _prototypeReply(String question) async {
    // Brief delay gives the prototype a visible composing state.
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final q = question.toLowerCase();

    if (q.contains('slow') || q.contains('latency') || q.contains('lag')) {
      return 'A slow connection can be caused by latency, packet loss, a busy '
          'endpoint or an unstable local network. Run Diagnostics first, then '
          'compare available server measurements before switching. I do not '
          'have live network measurements in this prototype.';
    }
    if (q.contains('server') || q.contains('recommend') || q.contains('best')) {
      return 'A useful server choice should be based on current measurements '
          'such as latency, packet loss and endpoint availability, together '
          'with your activity profile. The server scores shown in this preview '
          'are not live measurements.';
    }
    if (q.contains('diagnostic') || q.contains('test') || q.contains('packet')) {
      return 'Diagnostics can check internet reachability, DNS resolution and '
          'available latency or packet-loss measurements. Some values depend '
          'on the active tunnel and endpoint telemetry. Open Diagnostics to '
          'review which checks are available.';
    }
    if (q.contains('lite') || q.contains('battery') || q.contains('data')) {
      return 'Lite Mode is designed to reduce specifically identified '
          'non-essential background work. Data Saver and Battery Saver are '
          'separate preferences. Any claimed savings should be measured under '
          'matched test conditions.';
    }
    if (q.contains('profile') || q.contains('gaming') || q.contains('video')) {
      return 'Activity profiles can prioritize different connection goals. '
          'For example, gaming often prioritizes low latency, while video '
          'calls need stability and low packet loss. The profile should guide '
          'a recommendation—not silently change the connection unless you '
          'have explicitly enabled that behavior.';
    }
    return 'I can help with connection troubleshooting, interpreting '
        'diagnostics, server-selection factors and DēGlitch settings. This is '
        'a prototype reply; connect an assistant service to enable live, '
        'context-aware responses.';
  }

  String? _suggestActionLabel(String question) {
    final q = question.toLowerCase();
    if (q.contains('server') || q.contains('recommend') || q.contains('best')) {
      return widget.onOpenServers == null ? null : 'View servers';
    }
    if (q.contains('slow') || q.contains('latency') || q.contains('diagnostic')) {
      return widget.onOpenDiagnostics == null ? null : 'Open diagnostics';
    }
    return null;
  }

  String? _suggestActionKey(String question) {
    final q = question.toLowerCase();
    if (_suggestActionLabel(question) == null) return null;
    if (q.contains('server') || q.contains('recommend') || q.contains('best')) {
      return 'servers';
    }
    return 'diagnostics';
  }

  void _runAction(String? actionKey) {
    if (actionKey == 'servers') widget.onOpenServers?.call();
    if (actionKey == 'diagnostics') widget.onOpenDiagnostics?.call();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  void _resetConversation() {
    setState(() {
      _messages
        ..clear()
        ..add(
          _AssistantMessage(
            text:
                'Hi! I’m DēGlitch Assistant. What would you like help with?',
            fromUser: false,
            time: DateTime.now(),
          ),
        );
      _showSuggestions = true;
      _errorText = null;
      _isTyping = false;
    });
    _scrollToBottom();
  }

  String _timeLabel(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: _deepBlue,
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Assistance',
              style: TextStyle(
                color: _deepBlue,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            Text(
              'Your connectivity companion',
              style: TextStyle(
                color: _mutedBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'New conversation',
            onPressed: _resetConversation,
            icon: const Icon(Icons.add_comment_outlined),
            color: _deepBlue,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: _ModeBanner(isDemoMode: _isDemoMode),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount:
                    _messages.length + (_isTyping ? 1 : 0) + (_showSuggestions ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_showSuggestions && index == _messages.length) {
                    return _QuickPrompts(onSelected: _send);
                  }
                  if (_isTyping && index == _messages.length + (_showSuggestions ? 1 : 0)) {
                    return const _TypingBubble();
                  }
                  final message = _messages[index];
                  return _MessageBubble(
                    message: message,
                    timeLabel: _timeLabel(message.time),
                    onAction: () => _runAction(message.actionKey),
                  );
                },
              ),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _send(_messages.lastWhere((m) => m.fromUser).text),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _Composer(
              controller: _composer,
              focusNode: _focusNode,
              isBusy: _isTyping,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeBanner extends StatelessWidget {
  const _ModeBanner({required this.isDemoMode});

  final bool isDemoMode;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0878F9);
    const deepBlue = Color(0xFF12447F);
    const line = Color(0xFFDCEBFA);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: line),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: blue, size: 20),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Ask about connection quality, servers or settings',
              style: TextStyle(
                color: deepBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isDemoMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1D9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Preview',
                style: TextStyle(
                  color: Color(0xFF8B5A0B),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickPrompts extends StatelessWidget {
  const _QuickPrompts({required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _prompts = <String>[
    'Why is my connection slow?',
    'Recommend a server',
    'Explain my diagnostics',
    'How can I save data?',
  ];

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0878F9);
    const deepBlue = Color(0xFF12447F);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'SUGGESTED QUESTIONS',
              style: TextStyle(
                color: Color(0xFF7093B9),
                letterSpacing: 0.8,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _prompts
                .map(
                  (prompt) => ActionChip(
                    label: Text(prompt),
                    avatar: const Icon(Icons.auto_awesome, size: 15, color: blue),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFDCEBFA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    labelStyle: const TextStyle(
                      color: deepBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () => onSelected(prompt),
                  ),
                )
                .toList(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12, left: 4),
            child: Text(
              'You can also type your own question below.',
              style: TextStyle(color: Color(0xFF7093B9), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.timeLabel,
    required this.onAction,
  });

  final _AssistantMessage message;
  final String timeLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0878F9);
    const deepBlue = Color(0xFF12447F);
    const muted = Color(0xFF7093B9);
    const assistantBubble = Color(0xFFE8F3FF);
    const line = Color(0xFFDCEBFA);
    final isUser = message.fromUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF51C8FF), blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? blue : assistantBubble,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 5),
                      bottomRight: Radius.circular(isUser ? 5 : 18),
                    ),
                    border: isUser ? null : Border.all(color: line),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : deepBlue,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
                if (!isUser && message.actionLabel != null) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: onAction,
                    icon: Icon(
                      message.actionKey == 'servers'
                          ? Icons.dns_outlined
                          : Icons.health_and_safety_outlined,
                      size: 16,
                    ),
                    label: Text(message.actionLabel!),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blue,
                      side: const BorderSide(color: line),
                      backgroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  timeLabel,
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: line),
              ),
              child: const Icon(Icons.person_rounded, color: muted, size: 19),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFF0878F9),
            child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 17),
          ),
          SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFE8F3FF),
              borderRadius: BorderRadius.all(Radius.circular(18)),
              border: Border.fromBorderSide(BorderSide(color: Color(0xFFDCEBFA))),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: SizedBox(
                width: 42,
                height: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TypingDot(),
                    _TypingDot(),
                    _TypingDot(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  const _TypingDot();

  @override
  Widget build(BuildContext context) => Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFF7093B9),
          shape: BoxShape.circle,
        ),
      );
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.isBusy,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isBusy;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0878F9);
    const deepBlue = Color(0xFF12447F);
    const line = Color(0xFFDCEBFA);

    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        10 + MediaQuery.of(context).viewInsets.bottom * 0.02,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: onSend,
                decoration: InputDecoration(
                  hintText: 'Ask DēGlitch Assistant…',
                  hintStyle: const TextStyle(color: Color(0xFF8AA6C6), fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFF3F8FD),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: blue, width: 1.4),
                  ),
                ),
                style: const TextStyle(color: deepBlue, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              width: 48,
              child: IconButton.filled(
                tooltip: 'Send message',
                onPressed: isBusy ? null : () => onSend(controller.text),
                style: IconButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFB8D8FB),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
