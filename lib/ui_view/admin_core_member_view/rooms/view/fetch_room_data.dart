import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/fetch_room_view_model.dart';

class FetchRoomData extends StatefulWidget {
  const FetchRoomData({super.key});

  @override
  State<FetchRoomData> createState() => _FetchRoomDataState();
}

class _FetchRoomDataState extends State<FetchRoomData> {
  late FetchRoomViewModel fetchRoomViewModel;

  @override
  void initState() {
    super.initState();
    fetchRoomViewModel = FetchRoomViewModel(context);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 0.5, top: 38)),
                Text(roomListText,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appbartextColor,
                        wordSpacing: 2.2)),
              ],
            ),
            const GlobalSizedBox(height: 5),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: fetchRoomViewModel.dbRef,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(someErrorOccurred);
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text(noResultFound));
                    }
                    List<DocumentSnapshot<Map<String, dynamic>>> documents =
                        snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> employee =
                              documents[index].data() as Map<String, dynamic>;
                          employee['key'] = documents[index].id;
                          String roomId = documents[index].id;
                          return fetchRoomViewModel.listItem(
                              employee: employee, roomId: roomId);
                        });
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
