import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:smartrr/utils/colors.dart';

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

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile(
            path: "assets/credentials.json", projectId: "smartrr-eddx")
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
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
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
    setState(() {
      messages.add({
        'message': message.text.text[0],
        'isUserMessage': isUserMessage,
      });
    });

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

  final List<Map<String, dynamic>> messages;
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
                                    Navigator.of(context).pushNamed("/about"),
                                child: Text("Read about SMHR")),
                            OutlinedButton(
                                onPressed: () {}, child: Text("Report a case"))
                          ],
                        )
                      ],
                    )
                  : ChatMessage(
                      message: widget.messages[index],
                    )),
          itemCount: widget.messages.length,
        ));
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key key, this.message}) : super(key: key);

  final Map<String, dynamic> message;
  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message["isUserMessage"];
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
            : Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: lightGrey, borderRadius: BorderRadius.circular(12)),
                child: Text("${message['message']}"),
              )
      ],
    );
  }
}
