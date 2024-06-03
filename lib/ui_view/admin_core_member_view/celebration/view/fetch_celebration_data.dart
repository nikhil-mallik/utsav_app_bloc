// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/widget_string.dart';
import '../../../common_screens/dashboard/dashboard.dart';
import '../view_model/fetch_celebration_view_model.dart';
import 'insert_celebration_data.dart';

class FetchCeleData extends StatefulWidget {
  final String? flushBarMessage;

  const FetchCeleData({super.key, this.flushBarMessage});

  @override
  State<FetchCeleData> createState() => _FetchCeleDataState();
}

class _FetchCeleDataState extends State<FetchCeleData> {
  late FetchCelebrationViewModel fetchCelebrationViewModel;

  @override
  void initState() {
    super.initState();
    fetchCelebrationViewModel = FetchCelebrationViewModel(context);
    // Check if flushBarMessage is not null, then display FlushBar
    if (widget.flushBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Utils.customFlushBar(context, widget.flushBarMessage!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * .9;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: celebrationListText,
        leadingOnPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Dashboard(initialSelectedIndex: 3))),
        trailingIcon: Icons.add_circle_outline_rounded,
        trailingOnPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const InsertCeleData()));
        },
      ),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: width * .98,
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
              //   height: 10
              // ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: fetchCelebrationViewModel.docRef,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        children: [Center(child: CircularProgressIndicator())],
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(someErrorOccurred);
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(noResultFound),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> celebrate =
                            snapshot.data!.docs[index].data();
                        celebrate['key'] = snapshot.data!.docs[index].id;
                        String Roomid = snapshot.data!.docs[index].id;
                        return fetchCelebrationViewModel.listItem(
                            celebrate: celebrate, roomsId: Roomid);
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
