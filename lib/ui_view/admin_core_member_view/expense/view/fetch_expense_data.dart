import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../../../../utils/routes/routes_name.dart';
import '../../../global_screen_ui/total_sum_card_ui.dart';
import '../view_model/fetch_expense_view_model.dart';

class FetchExpenseData extends StatefulWidget {
  const FetchExpenseData({super.key});

  @override
  State<FetchExpenseData> createState() => _FetchExpenseDataState();
}

class _FetchExpenseDataState extends State<FetchExpenseData> {
  bool loading = true;
  late FetchExpenseViewModel fetchExpenseViewModel;

  @override
  void initState() {
    super.initState();
    fetchExpenseViewModel = FetchExpenseViewModel(context);
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
          Navigator.pushNamed(context, RoutesName.insertExpense);
        },
      ),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.getWidth(context),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  /*   SizedBox(
                      width: GlobalWidthValues.getWidth(context),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.alertColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: "Search by expense title or date",
                        ),
                        onChanged: (value) async {},
                        controller: fetchExpenseViewModel.searchFilter,
                      ),
                    ),*/
                  const SizedBox(height: 10),
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
                            future: DataManager.getTotalExpense())),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: fetchExpenseViewModel.dbRef,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text(someErrorOccurred);
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
                                String roomId = snapshot.data!.docs[index].id;
                                return fetchExpenseViewModel.listItem(
                                    expense: expense, roomsId: roomId);
                              });
                        }),
                  ),
                ]),
        ),
      ),
    );
  }
}
