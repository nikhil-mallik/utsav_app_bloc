// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/color.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/particular_contribution_view_model.dart';

class Show_Contribution_Details extends StatefulWidget {
  final String employeeKey;
  final String roomKey;

  const Show_Contribution_Details({
    required this.employeeKey,
    required this.roomKey,
    super.key,
  });

  @override
  _Show_Contribution_DetailsState createState() =>
      _Show_Contribution_DetailsState();
}

class _Show_Contribution_DetailsState extends State<Show_Contribution_Details> {
  late ParticularContributionViewModel particularContributionViewModel;

  @override
  void initState() {
    super.initState();
    particularContributionViewModel = ParticularContributionViewModel();
    particularContributionViewModel.getContributionDetails(widget.roomKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: contributionListText,
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
                  future: particularContributionViewModel
                      .getContributionDetails(widget.roomKey),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> contribution =
                                snapshot.data!.docs[index].data();
                            contribution['key'] = snapshot.data!.docs[index].id;
                            return particularContributionViewModel.listItem(
                                contribution: contribution);
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
