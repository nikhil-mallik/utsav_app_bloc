// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/user_fetch_room_view_model.dart';

class User_FetchRoomData extends StatefulWidget {
  const User_FetchRoomData({super.key});

  @override
  State<User_FetchRoomData> createState() => _User_FetchRoomDataState();
}

class _User_FetchRoomDataState extends State<User_FetchRoomData> {
  late UserFetchRoomViewModel userFetchRoom;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    userFetchRoom = UserFetchRoomViewModel(context);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.getWidth(context),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.only(left: 0.5, top: 38)),
              Text(roomListText,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appbartextColor,
                      wordSpacing: 2.2)),
            ]),
            const GlobalSizedBox(height: 5),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: userFetchRoom.dbRef,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text(someErrorOccurred));
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return Center(child: Text(noResultFound));
                          }
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> user =
                                    snapshot.data!.docs[index].data();
                                Map<String, dynamic> employee =
                                    snapshot.data!.docs[index].data();
                                user['key'] = snapshot.data!.docs[index].id;
                                employee['key'] = snapshot.data!.docs[index].id;
                                return userFetchRoom.listItem(
                                    user: user, employee: employee);
                              });
                        }),
                    // child: FirebaseAnimatedList(
                    //   query: userFetchRoom.dbRef,
                    //   itemBuilder: (BuildContext context,
                    //       DataSnapshot snapshot,
                    //       Animation<double> animation,
                    //       int index) {
                    //     Map user = snapshot.value as Map;
                    //     user['key'] = snapshot.key;
                    //     Map employee = snapshot.value as Map;
                    //     employee['key'] = snapshot.key;
                    //     return userFetchRoom.listItem(
                    //       user: user,
                    //       employee: employee,
                    //     );
                    //   },
                    // ),
                  ),
          ]),
        ),
      ),
    );
  }
}
