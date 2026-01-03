import 'package:flutter/material.dart';
import '../app_services.dart';
import 'camera_company_screen.dart';
import 'add_file_company_screen.dart';

class ChatCompanyScreen extends StatefulWidget {
  final int conversationId;
  final String title;
  final String subtitle;
  final bool canSend;

  const ChatCompanyScreen({
    super.key,
    required this.conversationId,
    required this.title,
    required this.subtitle,
    required this.canSend,
  });

  @override
  State<ChatCompanyScreen> createState() => _ChatCompanyScreenState();
}

class _ChatCompanyScreenState extends State<ChatCompanyScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showAttachmentMenu = false;
  bool _loadingMessages = true;
  String? _error;
  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _loadingMessages = true;
      _error = null;
    });
    try {
      final data = await AppServices.chat.getMessages(widget.conversationId);
      if (!mounted) return;
      setState(() {
        _messages = data;
        _loadingMessages = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loadingMessages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Tap detector για να κλείσει το menu
          if (_showAttachmentMenu)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAttachmentMenu = false;
                });
              },
              child: Container(color: Colors.transparent),
            ),

          Column(
            children: [
              SafeArea(bottom: false, child: _buildHeader()),

              Expanded(child: _buildMessagesList()),
            ],
          ),

          // Input bar pinned κάτω
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildInputBar(),
          ),

          // Attachment menu overlay
          if (_showAttachmentMenu)
            Positioned(
              bottom: 110,
              left: 16,
              child: _buildAttachmentMenu(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFFAFD9F),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20), size: 28),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'UnIntern',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                      fontFamily: 'Trirong',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Row(
        children: [
          // plus
          GestureDetector(
            onTap: () {
              setState(() {
                _showAttachmentMenu = !_showAttachmentMenu;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1B5E20), width: 2),
                color: const Color(0xFFFAFD9F),
              ),
              child: const Icon(Icons.add, color: Color(0xFF1B5E20)),
            ),
          ),
          const SizedBox(width: 10),

          // text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFD9F),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF1B5E20), width: 2),
              ),
              child: Center(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Write here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // send
          GestureDetector(
            onTap: widget.canSend ? _send : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conversation not accepted yet')),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1B5E20), width: 2),
                color: widget.canSend ? const Color(0xFFFAFD9F) : Colors.grey[300],
              ),
              child: Icon(
                Icons.send,
                color: widget.canSend ? const Color(0xFF1B5E20) : Colors.grey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentMenu() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFD9F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B5E20), width: 2),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Camera option
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraCompanyScreen()),
              );
              setState(() {
                _showAttachmentMenu = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1B5E20), width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Color(0xFF1B5E20),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // File/Document option
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFileCompanyScreen()),
              );
              setState(() {
                _showAttachmentMenu = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1B5E20), width: 2),
              ),
              child: const Icon(
                Icons.description,
                color: Color(0xFF1B5E20),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_loadingMessages) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Failed to load messages:\n$_error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Trirong', color: Color(0xFF1B5E20)),
              ),
            ),
            ElevatedButton(
              onPressed: _loadMessages,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet',
          style: TextStyle(fontFamily: 'Trirong', color: Color(0xFF1B5E20)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 110, top: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final m = _messages[index] as Map;
        final String text = (m['text'] ?? m['message'] ?? '') as String;
        final bool isSystem = (m['isSystem'] == true) ||
            (m['type']?.toString().toUpperCase() == 'SYSTEM');
        final bool isMe = (m['fromCompany'] == true) ||
          (m['isMine'] == true) ||
          (m['fromMe'] == true) ||
          (m['isMe'] == true);

        return _ChatBubble(
          text: text,
          isMe: isMe,
          isSystem: isSystem,
        );
      },
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.canSend) return;

    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
      });
    });
    _controller.clear();

    try {
      await AppServices.chat.sendMessage(widget.conversationId, text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $e')),
      );
    }
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isSystem;

  const _ChatBubble({required this.text, required this.isMe, this.isSystem = false});

  @override
  Widget build(BuildContext context) {
    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1B5E20), width: 1.5),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1B5E20),
                fontFamily: 'Trirong',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    final bubbleColor = isMe
        ? const Color(0xFFFAFD9F)
        : const Color(0xFFC9D3C9);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(
            color: bubbleColor,
            border: Border.all(color: const Color(0xFF1B5E20), width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
        ),
      ],
    );
  }
}
