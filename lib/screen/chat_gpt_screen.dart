import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../threedots.dart';
import '../widget/chat_message.dart';

class ChatGPTScreen extends StatefulWidget {
  @override
  State<ChatGPTScreen> createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> messages = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;
  bool isTyping = false;
  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  sendMessage() {
    ChatMessage _message = ChatMessage(text: _controller.text, sender: "User");
    setState(() {
      messages.insert(0, _message);
      isTyping = true;
    });
    _controller.clear();

    final request = CompleteReq(
      prompt: _message.text,
      model: kTranslateModelV3,
      max_tokens: 200,
    );
    _subscription = chatGPT!
        .builder('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',
            orgId: "")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: response.choices[0].text, sender: "Bot");

      setState(() {
        isTyping = false;
        messages.insert(0, botMessage);
      });
    });
  }

  //text box editing controller
  Widget buildTextBox() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: ((value) => sendMessage()),
            decoration: const InputDecoration(hintText: 'Send a Message'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: (() {
            sendMessage();
          }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            height: 50,
            image: AssetImage('assets/logo2.png'),
            
          ),
          Image(
            height: 30,
            image: AssetImage('assets/logo.png'),
            
          ),
        ],
      )),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: ((context, index) {
                  return messages[index];
                }),
              ),
            ),
            if (isTyping) const ThreeDots(),
            const Divider(height: 1),
            Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              decoration: BoxDecoration(
                color: context.cardColor,
                // border: Border.all(width: 1),
                // borderRadius: BorderRadius.circular(20),
              ),
              child: buildTextBox(),
            ),
            SizedBox(height: 7,)
          ],
        ),
      ),
    );
  }
}
