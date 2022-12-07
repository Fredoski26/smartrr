import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Helper {
  void containerForSheet<T>(
      {required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {});
  }

  // void showBottomSheet(BuildContext context, String title, String message, List<String> actionStringList, List<Function> actionList) {
  //   containerForSheet<String>(
  //     context: context,
  //     child: ActionBar(
  //       title: title,
  //       message: message,
  //       actionStringList: actionStringList,
  //       actionList: actionList,
  //     ),
  //   );
  // }

  void helperShowDialog(BuildContext context, String title, String message,
      List<TextButton> actionList) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: actionList,
        );
      },
    );
  }

  // logout(BuildContext context) {
  //   Helper().saveCurrentUser(null);
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
  //       (Route<dynamic> route) => false);
  // }

  // Future<User> getCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'current_user';
  //   final value = prefs.getString(key);
  //   User currentUser;
  //   if (value != null) {
  //     var jsonValue = jsonDecode(value);
  //     print("Json value of current user: $jsonValue");
  //     currentUser = User.toObject(jsonValue);
  //   }
  //   print("Got current user: $currentUser");
  //   return currentUser;
  // }

  Future showModal(
    BuildContext context,
    Widget bottomString,
    Function bottomFunction,
    List<Widget> actions,
    List<Function> actionFunctions,
  ) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new ListView(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: List.generate(actions.length, (index) {
                  if (actions.length == 1) {
                    return InkWell(
                      onTap: actionFunctions[index] as dynamic,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        height: 70,
                        child: Center(child: actions[index]),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFE8E8E8)),
                      ),
                    );
                  } else {
                    if (index == 0) {
                      //top corner
                      return InkWell(
                        onTap: actionFunctions[index] as dynamic,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1.5, horizontal: 20),
                          height: 70,
                          child: Center(child: actions[index]),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Color(0xFFE8E8E8)),
                        ),
                      );
                    } else if (index == actions.length - 1) {
                      //bottom corners
                      return InkWell(
                        onTap: actionFunctions[index] as dynamic,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1.5, horizontal: 20),
                          height: 70,
                          child: Center(child: actions[index]),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Color(0xFFE8E8E8)),
                        ),
                      );
                    } else {
                      //no corners
                      return InkWell(
                        onTap: actionFunctions[index] as dynamic,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1.5, horizontal: 20),
                          height: 70,
                          child: Center(child: actions[index]),
                          decoration: BoxDecoration(color: Color(0xFFE8E8E8)),
                        ),
                      );
                    }
                  }
                }),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: bottomFunction as dynamic,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 70,
                  child: Center(child: bottomString),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFE8E8E8)),
                ),
              ),
              SizedBox(
                height: 80,
              )
            ],
          );
        });
  }

// saveCurrentUser(User currentUser) async {
//   final prefs = await SharedPreferences.getInstance();
//   final key = 'current_user';
//   var value;
//   if (currentUser != null)
//     value = json.encode(currentUser.convertToJSON());
//   else
//     value = currentUser;

//   print("Storing value: $value");
//   prefs.setString(key, value);
// }
}
