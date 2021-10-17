import 'package:flutter/material.dart';

class UtilsClass {
  static String _getHours(DateTime _dateTime) {
    String minute = _dateTime.minute.toString();
    if(_dateTime.hour>12){
      String hour = (_dateTime.hour - 12).toString();
      return ((hour.length>1)?hour:("0"+hour)) + ":"+ (minute.length>1?minute:"0"+minute) + " PM";
    }else if(_dateTime.hour == 12){
      return _dateTime.hour.toString() + ":"+ (minute.length>1?minute:"0"+minute) + " PM";
    }
    else{
      String hour = _dateTime.hour.toString();
      return ((hour.length>1)?hour:("0"+hour)) + ":"+ (minute.length>1?minute:"0"+minute) + " AM";
    }
  }
  static String getDateTime(DateTime dateTime) {
    return _getHours(dateTime);
  }
  static Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:const Text('Yes')
          ),
        ],
      ),
    )??false;
  }

  static Future<bool> showExitPopup(BuildContext context) async{
    return await _showExitPopup(context);
  }
}