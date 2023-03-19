import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:smartrr/components/screens/user/consent_form_page.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:dart_date/dart_date.dart";

class ChatBot extends StatefulWidget {
  const ChatBot({super.key, this.title});

  final String? title;
  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late DialogFlowtter dialogFlowtter;
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late Box messageBox;

  void _clearChatHistory() {
    messageBox.clear();
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem> popupMenuItems = [
      PopupMenuItem(
        child: Text("Clear history"),
        onTap: _clearChatHistory,
      )
    ];

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text("SmartRR Bot"),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => popupMenuItems,
            ),
          ],
          backgroundColor: primaryColor,
          iconTheme: IconThemeData().copyWith(color: materialWhite),
        ),
        body: Container(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: messageBox.listenable(),
                builder: (context, _, __) => Expanded(
                  child: AppBody(
                    messages: messageBox.values
                        .map((message) => {
                              "type": message["type"],
                              "isUserMessage": message["isUserMessage"],
                              "message": message["message"],
                              "counsellors": message["counsellors"],
                              "timestamp": message["timestamp"],
                            })
                        .toList(),
                    sendMessage: sendMessage,
                    scrollController: _scrollController,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                color: materialWhite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: darkGrey),
                        controller: _messageController,
                        onSubmitted: (val) {
                          sendMessage(val);
                          _messageController.clear();
                        },
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      color: primaryColor,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        sendMessage(_messageController.text);
                        _messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    addMessage(
      Message(text: DialogText(text: [text])),
      true,
    );

    // dialogFlowtter.projectId = "deimos-apps-0905";

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message == null) return;
    addMessage(response.message!);
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    int timestamp = DateTime.now().timestamp;

    if (message.payload != null) {
      messageBox.put(timestamp.toString(), {
        'type': "payload",
        'counsellors': message.payload!["counsellors"],
        'isUserMessage': isUserMessage,
        "timestamp": timestamp,
      });
    } else {
      messageBox.put(timestamp.toString(), {
        'type': "text",
        'message': message.text!.text![0],
        'isUserMessage': isUserMessage,
        "timestamp": timestamp,
      });
      if (message.text!.text![0] == "Talk to a counsellor") {
        messageBox.put(timestamp.toString(), {
          'type': "notification",
          'message':
              "You will now be automatically connected to any available counsellor",
          'isUserMessage': false,
          "timestamp": timestamp,
        });
      }
    }
    // always scroll to buttom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    super.initState();
    messageBox = Hive.box("messages");
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    DialogFlowtter.fromFile(
      path: "assets/credentials.json",
      projectId: "smartrr-d5615",
    ).then((instance) => dialogFlowtter = instance).then((_) {
      if (messageBox.isEmpty) {
        sendMessage("Hi");
      }
    });
    // scroll to bottom
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class AppBody extends StatefulWidget {
  const AppBody({
    super.key,
    required this.messages,
    required this.sendMessage,
    required this.scrollController,
  });

  final List<Map> messages;
  final Function sendMessage;
  final ScrollController scrollController;

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final ButtonStyle actionButtonStyle = ButtonStyle().copyWith(
    backgroundColor: MaterialStatePropertyAll(
      Color(0xFFD9D9D9),
    ),
    textStyle: MaterialStatePropertyAll(TextStyle().copyWith(fontSize: 12)),
    foregroundColor: MaterialStatePropertyAll(
      darkGrey,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          controller: widget.scrollController,
          itemBuilder: (context, index) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: index == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatMessage(
                          message: widget.messages[index],
                        ),
                        Wrap(
                          spacing: 5.0,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  widget.sendMessage("Talk to a counsellor"),
                              child: Text("Talk to a counsellor"),
                              style: actionButtonStyle,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed("/srhr"),
                              child: Text("Read about SRHR"),
                              style: actionButtonStyle,
                            ),
                            TextButton(
                              onPressed: () async {
                                await setUserTypePref(userType: true).then((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ConsentFormPage(),
                                    ),
                                  );
                                });
                              },
                              child: Text("Report a case for yourself"),
                              style: actionButtonStyle,
                            ),
                            TextButton(
                              onPressed: () async {
                                await setUserTypePref(userType: false)
                                    .then((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ConsentFormPage(),
                                    ),
                                  );
                                });
                              },
                              child: Text("Report a case for someone"),
                              style: actionButtonStyle,
                            )
                          ],
                        )
                      ],
                    )
                  : widget.messages[index]["type"] == "notification"
                      ? Notification(
                          text: widget.messages[index]["message"],
                        )
                      : ChatMessage(
                          message: widget.messages[index],
                        )),
          itemCount: widget.messages.length,
        ));
  }
}

class Notification extends StatelessWidget {
  Notification({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.italic, fontSize: 12, color: lightGrey),
          ),
        )
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message});
  final Map message;

  @override
  Widget build(BuildContext context) {
    final User _currentUser = FirebaseAuth.instance.currentUser!;
    final bool isUserMessage = message["isUserMessage"];

    final TextStyle timestampStyle = TextStyle().copyWith(
      fontSize: 10,
      color: lightGrey,
      fontStyle: FontStyle.italic,
    );

    final _random = Random();
    final counsellors = message["counsellors"];

    Widget _botMessage({type = "text"}) {
      if (type == "payload") {
        final counsellor = counsellors[_random.nextInt(counsellors.length)];

        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 2,
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: materialWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Click link below to chat with a counsellor"),
              InkWell(
                child: Text(
                  counsellor["link"],
                  style:
                      TextStyle().copyWith(color: primaryColor, fontSize: 14),
                ),
                onTap: () {
                  final url = Uri.parse(
                      "${counsellor["link"]}?text=Hello,%0D%0AI am ${_currentUser.displayName}");
                  launchUrl(url);
                },
              ),
            ],
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: materialWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Text("${message['message']}"),
            ),
            Text(
              DateTime.fromMillisecondsSinceEpoch(message["timestamp"])
                  .timeago(allowFromNow: true),
              style: timestampStyle,
            ),
          ],
        );
      }
    }

    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isUserMessage
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      "${message['message']}",
                      style: TextStyle().copyWith(color: Colors.white),
                    ),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      message["timestamp"],
                    ).timeago(),
                    style: timestampStyle,
                  ),
                ],
              )
            : _botMessage(type: message["type"])
      ],
    );
  }
}
