import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  final ScrollController _scrollController = ScrollController();
  String user = '';
  List messages = [];

  List get getMessages => messages;
  String get getUser => user;
  ScrollController get getScrollController => _scrollController;

  addMessage(dynamic data){
    messages.add(data);
    update();
  }

  addUser(String userName) {
    user = userName;
    update();
  }

  void sendMessage(dynamic data, IO.Socket socket, BuildContext context){
    addMessage(data);
    socket.emit('message', data);
    if(MediaQuery.of(context).viewInsets.bottom!=0){
      FocusScope.of(context).requestFocus(FocusNode());
     }
    scroll();
    update();
  }
  void scroll(){
    if(_scrollController.hasClients){
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }else{
    }
    update();
  }
}
