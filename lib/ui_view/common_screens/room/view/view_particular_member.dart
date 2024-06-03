// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/particular_member_view_model.dart';

class Show_Member_Details extends StatefulWidget {
  final String employeeKey;
  final String roomKey;

  const Show_Member_Details(
      {required this.employeeKey, required this.roomKey, super.key});

  @override
  _Show_Member_DetailsState createState() => _Show_Member_DetailsState();
}

class _Show_Member_DetailsState extends State<Show_Member_Details> {
  late bool _isLoading = true;
  late ParticularMemberViewModel particularMemberViewModel;
  late Stream<QuerySnapshot<Map<String, dynamic>>> dbRef;
  @override
  void initState() {
    super.initState();
    particularMemberViewModel = ParticularMemberViewModel();
    dbRef = FirebaseFirestore.instance
        .collection('Members')
        .where('r_id', isEqualTo: widget.roomKey)
        .snapshots();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    particularMemberViewModel.database(widget.roomKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: memberListText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.getWidth(context),
          child: Column(children: [
            const GlobalSizedBox(height: 10),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: dbRef,
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
                              Map<String, dynamic> user =
                                  snapshot.data!.docs[index].data();
                              user['key'] = snapshot.data!.docs[index].id;
                              return particularMemberViewModel.listItem(
                                  user: user);
                            });
                      },
                    ),
                    // child: FirebaseAnimatedList(
                    //   sort: (a, b) {
                    //     var x = a.value as Map;
                    //     var y = b.value as Map;
                    //     String aDateStr = x['cel_dte'];
                    //     String bDateStr = y['cel_dte'];
                    //     DateTime aDate = DateFormat('MMMM dd, yyyy - hh:mm a')
                    //         .parse(aDateStr);
                    //     DateTime bDate = DateFormat('MMMM dd, yyyy - hh:mm a')
                    //         .parse(bDateStr);
                    //     return bDate.compareTo(aDate);
                    //   },
                    //   query: particularMemberViewModel.dbRef
                    //       .orderByChild('r_id')
                    //       .equalTo(widget.roomKey),
                    //   itemBuilder: (BuildContext context,
                    //       DataSnapshot snapshot,
                    //       Animation<double> animation,
                    //       int index) {
                    //     Map user = snapshot.value as Map;
                    //     user['key'] = snapshot.key;
                    //     return particularMemberViewModel.listItem(user: user);
                    //   },
                    // ),
                  ),
          ]),
        ),
      ),
    );
  }
}
