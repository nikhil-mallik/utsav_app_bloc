import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/particular_expense_view_model.dart';

class ShowExpenseDetails extends StatefulWidget {
  final String employeeKey;
  final String roomKey;

  const ShowExpenseDetails(
      {required this.employeeKey, required this.roomKey, super.key});

  @override
  State<ShowExpenseDetails> createState() => _ShowExpenseDetailsState();
}

class _ShowExpenseDetailsState extends State<ShowExpenseDetails> {
  late ParticularExpenseViewModel particularExpenseViewModel;

  @override
  void initState() {
    super.initState();
    particularExpenseViewModel = ParticularExpenseViewModel();
    particularExpenseViewModel.getExpensesDetails(widget.roomKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
          title: expenseListText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.getWidth(context),
          child: Column(children: [
            const GlobalSizedBox(height: 10),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: particularExpenseViewModel
                      .getExpensesDetails(widget.roomKey),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return Text('$someErrorOccurred ${snapshot.error}');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> expense =
                                snapshot.data!.docs[index].data();
                            expense['key'] = snapshot.data!.docs[index].id;
                            return particularExpenseViewModel.listItem(
                                expense: expense, roomkey: widget.roomKey);
                          });
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
