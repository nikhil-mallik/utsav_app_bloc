import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/fetch_role_view_model.dart';

class FetchRoleData extends StatefulWidget {
  final String? flushBarMessage;

  const FetchRoleData({super.key, this.flushBarMessage});

  @override
  State<FetchRoleData> createState() => _FetchRoleDataState();
}

class _FetchRoleDataState extends State<FetchRoleData> {
  late FetchRoleViewModel fetchRoleViewModel;
  final future = FirebaseFirestore.instance.collection('Users').get();
  @override
  void initState() {
    super.initState();
    fetchRoleViewModel = FetchRoleViewModel(context);
// Check if flushBarMessage is not null, then display FlushBar
    if (widget.flushBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Utils.customFlushBar(context, widget.flushBarMessage!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
          title: roleDetailLabelText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: Container(
        color: AppColors.bgColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: GlobalWidthValues.multiplyWidth(.98, context),
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: future,
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
                    return Center(
                      child: Text(noResultFound),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> role =
                            snapshot.data!.docs[index].data();
                        role['key'] = snapshot.data!.docs[index].id;
                        return fetchRoleViewModel.listItem(user: role);
                      });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
