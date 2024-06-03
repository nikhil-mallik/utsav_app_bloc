// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/Dashboard/dashboard.dart';
import '../view_model/user_fetch_celebration_view_model.dart';

class User_FetchCeleData extends StatefulWidget {
  const User_FetchCeleData({super.key});

  @override
  State<User_FetchCeleData> createState() => _User_FetchCeleDataState();
}

class _User_FetchCeleDataState extends State<User_FetchCeleData> {
  late UserFetchCelebrationViewModel userFetchCele;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    userFetchCele = UserFetchCelebrationViewModel(context);
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
        title: celebrationListText,
        leadingOnPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Dashboard(initialSelectedIndex: 3))),
      ),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.multiplyWidth(.98, context),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)), // SizedBox(
              //   width: MediaQuery.of(context).size.width * .9,
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           5.0,
              //         ),
              //         borderSide: const BorderSide(
              //           color: AppColors.deletebuttonColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       hintText: "Search by celebration title or date",
              //     ),
              //     onChanged: (String value) {
              //       setState(
              //         () {},
              //       );
              //     },
              //     controller: searchFilter,
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: userFetchCele.dbRef,
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
                              Map<String, dynamic> celebrate =
                                  snapshot.data!.docs[index].data();
                              celebrate['key'] = snapshot.data!.docs[index].id;
                              String roomId = snapshot.data!.docs[index].id;
                              return userFetchCele.listItem(
                                  celebrate: celebrate, roomsId: roomId);
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
