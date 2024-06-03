import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/view_detail_expense_view_model.dart';

class ViewExpenseDetails extends StatefulWidget {
  const ViewExpenseDetails({
    super.key,
    required this.expenseKey,
    required this.roomId,
  });

  final String expenseKey;
  final String roomId;

  @override
  State<ViewExpenseDetails> createState() => _ViewExpenseDetailsState();
}

class _ViewExpenseDetailsState extends State<ViewExpenseDetails> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;

  late ViewDetailsExpenseModel viewDetailsExpenseModel;

  @override
  void initState() {
    super.initState();
    viewDetailsExpenseModel = ViewDetailsExpenseModel();
    _stream = FirebaseFirestore.instance
        .collection('Expense')
        .doc(widget.expenseKey)
        .snapshots();
    viewDetailsExpenseModel.currentUser();
  }

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
                    Map<String, dynamic> expense = snapshot.data!.data()!;
                    expense['key'] = snapshot.data!.id;
                    return viewDetailsExpenseModel.listItem(
                        expense: expense, roomsId: snapshot.data!.id);
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
