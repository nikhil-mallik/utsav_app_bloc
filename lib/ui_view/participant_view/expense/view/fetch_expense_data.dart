// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/expense/view/insert_expense_data.dart';
import '../../../global_screen_ui/total_sum_card_ui.dart';
import '../view_model/user_fetch_expense_view_model.dart';

class User_FetchExpenseData extends StatefulWidget {
  const User_FetchExpenseData({super.key});

  @override
  State<User_FetchExpenseData> createState() => _User_FetchExpenseDataState();
}

class _User_FetchExpenseDataState extends State<User_FetchExpenseData> {
  late UserFetchExpenseViewModel userFetchExpense;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    userFetchExpense = UserFetchExpenseViewModel(context);
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
      appBar: CustomAppBar(
          title: expenseLabelText,
          trailingIcon: Icons.add_circle_outline_sharp,
          trailingOnPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InsertExpenseData()));
          }),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.getWidth(context),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * .9,
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(
                  //           5.0,
                  //         ),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.alertColor,
                  //           width: 2.0,
                  //         ),
                  //       ),
                  //       hintText: "Search by expense title or date",
                  //     ),
                  //     onChanged: (String value) {
                  //       setState(() {});
                  //     },
                  //     controller: searchFilter,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Card(
                    elevation: 8.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0))),
                    child: Container(
                      width: GlobalWidthValues.getWidth(context),
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(120.0)),
                          color: AppColors.cardColor),
                      padding: const EdgeInsets.all(10),
                      child: TotalSumCardUI(
                          future: DataManager.getTotalCurrentUserExpense(
                              currentLoginUserId)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: userFetchExpense.dbRef,
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
                                Map<String, dynamic> expense =
                                    snapshot.data!.docs[index].data();
                                expense['key'] = snapshot.data!.docs[index].id;
                                String roomid = snapshot.data!.docs[index].id;
                                return userFetchExpense.listItem(
                                    expense: expense, roomsId: roomid);
                              });
                        }),
                  ),
                ]),
        ),
      ),
    );
  }
}
