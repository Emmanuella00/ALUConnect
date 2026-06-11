import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/colors.dart';
import '../widgets/user_avatar.dart';

// ─── Chat List ────────────────────────────────────────────────────────────────
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': 'Entrepreneurship Club',
      'preview': 'The meeting for the Pan-...',
      'time': '10:45 AM',
      'unread': 3,
      'initials': 'EC',
      'color': Color(0xFF6A7A38),
      'isOnline': true,
      'isGroup': true,
    },
    {
      'id': '2',
      'name': 'James Kamau',
      'preview': 'Did you manage to review...',
      'time': 'Yesterday',
      'unread': 1,
      'initials': 'JK',
      'color': Color(0xFF3A3A3A),
      'isOnline': false,
      'isGroup': false,
    },
    {
      'id': '3',
      'name': 'Sarah Mensah',
      'preview': 'See you at the campus hub at ...',
      'time': 'Wed',
      'unread': 0,
      'initials': 'SM',
      'color': Color(0xFF4A3A2A),
      'isOnline': false,
      'isGroup': false,
    },
    {
      'id': '4',
      'name': 'Year 2 Data Science',
      'preview': "Prof. Okoro: Please check...",
      'time': 'Monday',
      'unread': 12,
      'initials': 'DS',
      'color': Color(0xFF2A3A4A),
      'isOnline': false,
      'isGroup': true,
    },
    {
      'id': '5',
      'name': 'Nneka Kalu',
      'preview': 'That research paper was q...',
      'time': 'Oct 12',
      'unread': 0,
      'initials': 'NK',
      'color': Color(0xFF3A3A3A),
      'isOnline': false,
      'isGroup': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredChats {
    if (_searchQuery.isEmpty) return _chats;
    return _chats
        .where((c) => (c['name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const UserAvatar(size: 36),
                  const SizedBox(width: 10),
                  Text('ALUConnect',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.burgundy)),
                  const Spacer(),
                  const Icon(Icons.notifications_outlined,
                      color: Colors.black45, size: 24),
                ],
              ),
            ),
            // Title + compose
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chats',
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: Colors.black54, size: 20),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.black26),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.black26, size: 20),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            // Chat list
            Expanded(
              child: _filteredChats.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _filteredChats.length,
                      itemBuilder: (_, i) =>
                          _buildChatItem(_filteredChats[i]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.burgundy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.chat_bubble_outline_rounded,
            color: Colors.white),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final hasUnread = (chat['unread'] as int) > 0;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversationScreen(chat: chat),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xFFDDDDD0), width: 0.5)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: chat['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      chat['initials'] as String,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
                if (chat['isOnline'] as bool)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.backgroundBeige, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chat['time'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: hasUnread
                              ? AppColors.burgundy
                              : Colors.black38,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat['preview'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: hasUnread
                                ? Colors.black54
                                : Colors.black38,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.burgundy,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${chat['unread']}',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 56, color: Colors.black12),
          const SizedBox(height: 16),
          Text('No conversations found',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black26)),
        ],
      ),
    );
  }
}

// ─── Conversation ─────────────────────────────────────────────────────────────
class ConversationScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  const ConversationScreen({super.key, required this.chat});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Sarah M.',
      'text': 'Hey everyone! Has the room for the pitch session been confirmed yet? I want to set up the presentation slides.',
      'time': '10:42 AM',
      'isMe': false,
    },
    {
      'sender': 'David K.',
      'text': "It's going to be in the Innovation Hub. The projector is already tested and ready for us at 2 PM.",
      'time': '10:45 AM',
      'isMe': false,
    },
    {
      'sender': 'Me',
      'text': "Thanks Sarah and David. I'll be arriving 15 minutes early with the printed feedback forms for the judges.",
      'time': '11:02 AM',
      'isMe': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Load saved messages from SharedPreferences
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'chat_${widget.chat['id']}';
    final saved = prefs.getString(key);
    if (saved != null) {
      final loaded =
          List<Map<String, dynamic>>.from(jsonDecode(saved));
      setState(() {
        _messages.clear();
        _messages.addAll(loaded);
      });
    }
  }

  // Save messages to SharedPreferences
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'chat_${widget.chat['id']}';
    await prefs.setString(key, jsonEncode(_messages));
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'Me',
        'text': text,
        'time': TimeOfDay.now().format(context),
        'isMe': true,
      });
    });
    _messageController.clear();
    _saveMessages(); // Save messages after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: widget.chat['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.chat['initials'] as String,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chat['name'] as String,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text('342 members · 12 online',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.white54)),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.white60),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text('TODAY',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      letterSpacing: 0.8)),
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text('No messages yet. Start the conversation!',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.black26),
                        textAlign: TextAlign.center),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _buildMessage(_messages[i]),
                  ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1108),
              border: Border(
                  top: BorderSide(color: Color(0xFF2A2018), width: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file,
                    color: Colors.white54, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2018),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white38),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.burgundy,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isMe = msg['isMe'] as bool;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(
                msg['sender'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.burgundy,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.burgundy
                  : const Color(0xFFEEECE0),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isMe ? 14 : 3),
                bottomRight: Radius.circular(isMe ? 3 : 14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  msg['text'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isMe ? Colors.white : AppColors.textDark,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg['time'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: isMe
                            ? Colors.white54
                            : Colors.black38,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all,
                          size: 14, color: Colors.white54),
                    ],
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