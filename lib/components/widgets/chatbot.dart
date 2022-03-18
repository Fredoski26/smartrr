import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:smartrr/components/screens/user/consent_form_page.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile(
            path: "assets/credentials.json", projectId: "smartrr-d5615")
        .then((instance) => dialogFlowtter = instance)
        .then((value) => sendMessage("Hi"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Smart RR Bot"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: AppBody(
                messages: messages,
                sendMessage: sendMessage,
                scrollController: _scrollController,
              )),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                color: Color(0xFFFFF2DF),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: darkGrey),
                        controller: _controller,
                        onSubmitted: (val) {
                          sendMessage(val);
                          _controller.clear();
                        },
                        // style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      color: primaryColor,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
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
    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    // dialogFlowtter.projectId = "deimos-apps-0905";

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message == null) return;
    addMessage(response.message);
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    if (message.payload != null) {
      setState(() {
        messages.add({
          'type': "payload",
          'counsellors': message.payload["counsellors"],
          'isUserMessage': isUserMessage,
        });
      });
    } else {
      setState(() {
        messages.add({
          'type': "text",
          'message': message.text.text[0],
          'isUserMessage': isUserMessage,
        });
      });
      if (message.text.text[0] == "Talk to a counsellor") {
        setState(() {
          messages.add({
            'type': "notification",
            'message':
                "You will now be automatically connected to any available counsellor",
            'isUserMessage': false,
          });
        });
      }
    }
    // always scroll to buttom
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}

class AppBody extends StatefulWidget {
  const AppBody(
      {Key key, this.messages, this.sendMessage, this.scrollController})
      : super(key: key);

  final List<Map> messages;
  final Function sendMessage;
  final ScrollController scrollController;

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
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
                            OutlinedButton(
                                onPressed: () =>
                                    widget.sendMessage("Talk to a counsellor"),
                                child: Text("Talk to a counsellor")),
                            OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(context).pushNamed("/srhr"),
                                child: Text("Read about SRHR")),
                            OutlinedButton(
                                onPressed: () async {
                                  await setUserTypePref(userType: true)
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
                                child: Text("Report a case for yourself")),
                            OutlinedButton(
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
                                child: Text("Report a case for someone"))
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
  Notification({@required this.text});
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
  const ChatMessage({Key key, this.message}) : super(key: key);
  final Map message;
  @override
  Widget build(BuildContext context) {
    final User _currentUser = FirebaseAuth.instance.currentUser;

    final _random = Random();
    final counsellor = message["type"] == "payload"
        ? message["counsellors"][_random.nextInt(message["counsellors"].length)]
        : null;
    final bool isUserMessage = message["isUserMessage"];

    Widget _botMessage({type = "text"}) {
      if (type == "payload") {
        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 2,
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
              color: lightGrey, borderRadius: BorderRadius.circular(12)),
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
                  launch(url.toString());
                },
              )
            ],
          ),
        );
      } else {
        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 2,
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
              color: lightGrey, borderRadius: BorderRadius.circular(12)),
          child: Text("${message['message']}"),
        );
      }
    }

    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isUserMessage
            ? Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  "${message['message']}",
                  style: TextStyle().copyWith(color: Colors.white),
                ),
              )
            : _botMessage(type: message["type"])
      ],
    );
  }
}
