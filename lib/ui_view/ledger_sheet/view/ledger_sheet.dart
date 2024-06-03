import 'package:flutter/material.dart';

import '../../../../helper/global_width.dart';
import '../view_model/ledger_sheet_view_model.dart';

class LedgerSheet extends StatefulWidget {
  const LedgerSheet({super.key});

  @override
  State<LedgerSheet> createState() => _LedgerSheetState();
}

class _LedgerSheetState extends State<LedgerSheet> {
  late LedgerSheetViewModel ledgerSheetViewModel;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    ledgerSheetViewModel = LedgerSheetViewModel(context);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Data'),
      ),
      body: SizedBox(
        width: GlobalWidthValues.multiplyWidth(.9, context),
        child: Column(children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: ledgerSheetViewModel.getCombinedData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data![index];
                          return ledgerSheetViewModel.listDemoItem(data: data);
                        });
                  }
                }),
          ),
        ]),
      ),
    );
  }
}
