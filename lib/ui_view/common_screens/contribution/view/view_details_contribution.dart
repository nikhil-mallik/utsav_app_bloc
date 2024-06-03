import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/global_width.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/view_details_contribution_view_model.dart';

class ViewContributionDetails extends StatefulWidget {
  final String contributionKey;
  final String roomId;
  const ViewContributionDetails({
    super.key,
    required this.contributionKey,
    required this.roomId,
  });

  @override
  State<ViewContributionDetails> createState() =>
      _ViewContributionDetailsState();
}

class _ViewContributionDetailsState extends State<ViewContributionDetails> {
  late DetailsContributionViewModel detailsContributionViewModel;

  @override
  void initState() {
    super.initState();
    detailsContributionViewModel = DetailsContributionViewModel();
    detailsContributionViewModel.contributionData(widget.contributionKey);
    super.initState();
  }

  final searchFilter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
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
                  stream: detailsContributionViewModel.stream,
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
                    Map<String, dynamic> contribution = snapshot.data!.data()!;
                    contribution['key'] = snapshot.data!.id;
                    return detailsContributionViewModel.listItem(
                        contribution: contribution, roomsId: snapshot.data!.id);
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
