import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_chat/controller/chat_controller.dart';
import 'chat_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    final ChatController chatController = Get.put(ChatController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "USER"
          ),
        ),
        body:Center(
          child: Card(
            elevation: 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 TextField(
                  controller: nameController,
                   textDirection: TextDirection.ltr,
                   decoration: const InputDecoration(
                    hintText: "Your Name"
                  ),
                ),
                ElevatedButton(onPressed: (){
                  chatController.addUser(nameController.text);
                  Get.off(()=> const ChatScreen());
                }, child: const Text("Join Chat"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
