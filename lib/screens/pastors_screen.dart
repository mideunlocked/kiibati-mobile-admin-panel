import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/pastor.dart';
import '../../providers/pastor_provider.dart';
import '../widgets/pastors_widgets/pastor_tile.dart';

class PastorsScreen extends StatefulWidget {
  static const routeName = '/PastorsScreen';

  const PastorsScreen({super.key});

  @override
  State<PastorsScreen> createState() => _PastorsScreenState();
}

class _PastorsScreenState extends State<PastorsScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, getPastors);
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pastors"),
      ),
      body: ScaffoldMessenger(
        key: _scaffoldKey,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => getPastors(),
            color: primaryColor,
            child: Consumer<PastorProvider>(
              builder: (context, pastorPvr, child) {
                return Column(
                  children: [
                    Visibility(
                      visible: pastorPvr.isLoading,
                      child: const LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.white30,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 1.h,
                          left: 5.w,
                          right: 5.w,
                        ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              PastorTile(
                                height: 40.h,
                                width: 100.w,
                                pastor: pastorPvr.bishop,
                              ),
                              child!,
                              GridView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 2.h,
                                  crossAxisSpacing: 4.w,
                                  mainAxisExtent: 30.h,
                                ),
                                children: pastorPvr.pastors
                                    .map(
                                      (Pastor pastor) => PastorTile(
                                        height: 40.h,
                                        width: 100.w,
                                        pastor: pastor,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: SizedBox(
                height: 2.h,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sizedBox(Widget widget) {
    return SizedBox(
      height: 40.h,
      width: 100.w,
      child: Center(
        child: widget,
      ),
    );
  }

  void getPastors() async {
    var sermonPvr = Provider.of<PastorProvider>(context, listen: false);

    await sermonPvr.getPastors(
      scaffoldKey: _scaffoldKey,
    );
  }
}
