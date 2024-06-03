import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/details_celebration_view_model.dart';

class ViewCelebrationDetails extends StatefulWidget {
  const ViewCelebrationDetails({
    super.key,
    required this.celebrationKey,
    required this.roomId,
  });

  final String celebrationKey;
  final String roomId;

  @override
  State<ViewCelebrationDetails> createState() => _ViewCelebrationDetailsState();
}

class _ViewCelebrationDetailsState extends State<ViewCelebrationDetails> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late DetailsCelebrationViewModel detailsCelebrationViewModel;

  @override
  void initState() {
    super.initState();
    detailsCelebrationViewModel = DetailsCelebrationViewModel();
    _stream = FirebaseFirestore.instance
        .collection('Celebration')
        .doc(widget.celebrationKey)
        .snapshots();
  }

  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Celebration').doc('id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppColors.bgColor,
        child: SizedBox(
          width: GlobalWidthValues.getWidth(context),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton.icon(
                  icon: const Icon(Icons.cancel_outlined,
                      color: AppColors.appbariconColor),
                  label: Text(closeButtonText,
                      style: const TextStyle(color: AppColors.appbartextColor)),
                  onPressed: () => Navigator.pop(context)),
            ]),
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(someErrorOccurred);
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text(noResultFound));
                    }
                    Map<String, dynamic> celebrate = snapshot.data!.data()!;
                    celebrate['key'] = snapshot.data!.id;
                    return detailsCelebrationViewModel.listItem(
                        celebrate: celebrate, roomsId: snapshot.data!.id);
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
