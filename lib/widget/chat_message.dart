import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;

  const ChatMessage({super.key, required this.text, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sender,
        )
            .text
            .subtitle1(context)
            .make()
            .box
            .color(sender == 'User' ? Vx.red200 : Vx.green200)
            .rounded
            .p16
            .alignCenter
            .makeCentered(),
        Expanded(child: text.trim().text.bodyText1(context).make().px8())
      ],
    ).py8();
  }
}
