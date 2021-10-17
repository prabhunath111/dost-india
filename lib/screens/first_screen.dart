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
        body:Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                  controller: nameController,
                  textDirection: TextDirection.ltr,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                      hintText: "Your Name",
                      border: InputBorder.none)
                  ),
                ),
                  ElevatedButton(onPressed: (){
                    if(nameController.text.isNotEmpty){
                      chatController.addUser(nameController.text);
                    }else{}
                    Get.off(()=> const ChatScreen());
                  }, child: const Text("Join Chat"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
