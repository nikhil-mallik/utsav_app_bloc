// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/data_manager.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/contribution/view/insert_celebration_ui.dart';
import '../../../global_screen_ui/total_sum_card_ui.dart';
import '../view_model/user_fetch_contribution_view_model.dart';

class User_FetchPaymentData extends StatefulWidget {
  const User_FetchPaymentData({super.key});

  @override
  State<User_FetchPaymentData> createState() => _User_FetchPaymentDataState();
}

class _User_FetchPaymentDataState extends State<User_FetchPaymentData> {
  bool loading = true;
  late UserFetchContributionViewModel userFetchContribution;

  @override
  void initState() {
    super.initState();
    userFetchContribution = UserFetchContributionViewModel(context);
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
        title: contributionLabelText,
        trailingIcon: Icons.add_circle_outline_rounded,
        trailingOnPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InsertPaymentData(),
            ),
          );
        },
      ),
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.multiplyWidth(.98, context),
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
                  //       hintText: "Search by contribution title or date",
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
                        future: DataManager.getTotalCurrentUserContribution(
                            currentLoginUserId),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: userFetchContribution.dbRef,
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
                                Map<String, dynamic> contribution =
                                    snapshot.data!.docs[index].data();
                                contribution['key'] =
                                    snapshot.data!.docs[index].id;
                                String roomId = snapshot.data!.docs[index].id;
                                return userFetchContribution.listItem(
                                    contribution: contribution,
                                    roomsId: roomId);
                              });
                        }),
                  ),
                ]),
        ),
      ),
    );
  }
}
