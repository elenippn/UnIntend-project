import 'package:flutter/material.dart';
import 'camera_company_screen.dart';
import 'add_file_company_screen.dart';

class ChatCompanyScreen extends StatefulWidget {
  final String conversationId;
  final String title;
  final String subtitle;

  const ChatCompanyScreen({
    super.key,
    required this.conversationId,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ChatCompanyScreen> createState() => _ChatCompanyScreenState();
}

class _ChatCompanyScreenState extends State<ChatCompanyScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showAttachmentMenu = false;

  // Demo data (μετά θα έρχονται από DB)
  // Τα μηνύματα είναι αντεστραμμένα - ο company είναι "me" (true)
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Καλησπέρα σας, είδαμε ότι ενδιαφέρεστε για τη θέση... (κλπ)',
      isMe: true,
    ),
    _ChatMessage(
      text: 'Καλησπέρα σας, σας επισυνάπτω τώρα το βιογραφικό μου...',
      isMe: false,
    ),
  ];

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

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 110, top: 12),
                  itemCount: _messages.length + 1,
                  itemBuilder: (context, index) {
                    // First item: "Ready to connect?" as text with link icon
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.link, color: const Color(0xFF1B5E20), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Ready to connect?',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1B5E20),
                                fontFamily: 'Trirong',
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    // Rest of the messages
                    final m = _messages[index - 1];
                    return _ChatBubble(
                      text: m.text,
                      isMe: m.isMe,
                    );
                  },
                ),
              ),
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
            onTap: _send,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1B5E20), width: 2),
                color: const Color(0xFFFAFD9F),
              ),
              child: const Icon(Icons.send, color: Color(0xFF1B5E20), size: 20),
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

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isMe: true));
    });
    _controller.clear();

    // TODO: εδώ θα κάνεις write στη βάση (Firestore/DB)
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  _ChatMessage({required this.text, required this.isMe});
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const _ChatBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? const Color(0xFFFAFD9F) : const Color(0xFFC9D3C9);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.circular(14);

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
            borderRadius: radius,
          ),
          child: Text(text),
        ),
      ],
    );
  }
}
