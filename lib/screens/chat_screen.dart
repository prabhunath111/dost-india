import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_chat/constants/image_strings.dart';
import 'package:new_chat/constants/urls.dart';
import 'package:new_chat/controller/chat_controller.dart';
import 'package:new_chat/utils/utils_class.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController msgController = TextEditingController();
  final ChatController chatController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    setUpSocketListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()=>UtilsClass.showExitPopup(context),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: false,
          appBar: AppBar(title: const Text("Group-Chat")),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(chatBg, width: width,height: height,fit: BoxFit.cover),
              SizedBox(height: height*0.80,
              child: GetBuilder<ChatController>(
                builder: (logic) {
                  return (logic.getMessages.isNotEmpty)?Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                        controller: logic.getScrollController,
                        shrinkWrap: true,
                        itemCount: logic.getMessages.length,
                        itemBuilder: (context, index){
                          bool isMe = logic.getMessages[index]['sentByMe']==socket.id;
                          return Column(
                            crossAxisAlignment: (isMe)?CrossAxisAlignment.end:CrossAxisAlignment.start,
                            children:  [
                              Container(
                                decoration: BoxDecoration(
                                    color: (isMe)?const Color(0xff9cb8a3):Colors.white,
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(logic.getMessages[index]['name'], style: const TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.w600),),
                                          const SizedBox(width: 4.0),
                                          const Icon(Icons.account_circle),
                                        ],
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(logic.getMessages[index]['message']),
                                      const SizedBox(height: 6.0),
                                      Text(logic.getMessages[index]['time'], style: const TextStyle(color: Colors.blueGrey, fontSize: 12),textScaleFactor: 1.0)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0,)
                            ],
                          );
                        }),
                  ):Container();
                },
              ),
              ),
              Positioned(
                bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Container(
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Center(
                        child: TextField(
                          controller: msgController,
                          textDirection: TextDirection.ltr,
                          cursorColor: Colors.grey,
                          cursorHeight: 2,
                          decoration: InputDecoration(
                              hintText: "Message",
                              border: InputBorder.none,
                              suffixIcon: IconButton(onPressed: (){
                                var msgJson = {"message": msgController.text, "sentByMe": socket.id, "name": chatController.getUser, "time": UtilsClass.getDateTime(DateTime.now().toLocal())};
                                chatController.sendMessage(msgJson, socket, context);
                                msgController.clear();
                              }, icon: const Icon(Icons.send, color: Colors.grey,))
                          ),
                        ),
                      ),
                    ),
                  )
              )

            ],
          ),
        ),
      ),
    );
  }
  void setUpSocketListener() {
    socket.on('message-receive', (data) {
      chatController.addMessage(data);
      chatController.scroll();
    });
  }
}
