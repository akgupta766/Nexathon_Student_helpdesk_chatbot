import 'package:flutter/material.dart';
import 'message.dart';
import 'chat_api.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ChatAPI _chatAPI = ChatAPI(userId: "student_123");
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addMessage(
      Message(
        text: "Hello! I'm your student helpdesk assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
    // Scroll to bottom when new message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    
    _textController.clear();
    
    // Add user message
    Message userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _addMessage(userMessage);
    
    // Set loading state
    setState(() {
      _isLoading = true;
    });
    
    // Send message to backend
    _chatAPI.sendMessage(text).then((response) {
      setState(() {
        _isLoading = false;
      });
      
      // Add bot response
      Message botMessage = Message(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _addMessage(botMessage);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      Message errorMessage = Message(
        text: "Sorry, I'm having trouble connecting. Please try again later.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      _addMessage(errorMessage);
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message...",
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.isUser
            ? _buildUserMessage(message)
            : _buildBotMessage(message),
      ),
    );
  }

  List<Widget> _buildUserMessage(Message message) {
    return [
      Expanded(
        child: Container(),
      ),
      Container(
        margin: EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text("You", style: TextStyle(color: Colors.white, fontSize: 10)),
        ),
      ),
      Flexible(
        flex: 3,
        child: Container(
          margin: EdgeInsets.only(left: 8.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          child: Text(message.text),
        ),
      ),
    ];
  }

  List<Widget> _buildBotMessage(Message message) {
    return [
      Container(
        margin: EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.school, color: Colors.white, size: 20),
        ),
      ),
      Flexible(
        flex: 3,
        child: Container(
          margin: EdgeInsets.only(right: 8.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          child: Text(message.text),
        ),
      ),
      Expanded(
        child: Container(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Helpdesk Chatbot'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("About"),
                    content: Text(
                        "This chatbot can help with admissions, exams, fees, courses, and campus information."),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(8.0),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index < _messages.length) {
                    return _buildMessage(_messages[index]);
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.school, color: Colors.white, size: 20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 8.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 10),
                                Text("Thinking..."),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}