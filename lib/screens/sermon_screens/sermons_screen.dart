import 'package:flutter/material.dart';
import 'package:kiibati_mobile_admin/providers/pastor_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/sermons.dart';
import '../../providers/sermon_provider.dart';
import '../../widgets/sermons_widgets/sermon_tile.dart';

class SermonsScreen extends StatefulWidget {
  static const routeName = '/SermonsScreen';

  const SermonsScreen({super.key});

  @override
  State<SermonsScreen> createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<SermonsScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, getSermons);
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sermons'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => getSermons(),
          color: primaryColor,
          child: ScaffoldMessenger(
            key: _scaffoldKey,
            child:
                Consumer<SermonProvider>(builder: (context, sermonPvr, child) {
              return Column(
                children: [
                  Visibility(
                    visible: sermonPvr.isLoading,
                    child: const LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white30,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: sermonPvr.sermons.length,
                      itemBuilder: (ctx, index) {
                        Sermon sermon = sermonPvr.sermons[index];

                        return Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 2.h : 0),
                          child: SermonListTile(
                            sermon: sermon,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/CRUDSermonScreen',
          arguments: {
            'action': 'Add',
            'sermon': Sermon.nullSermon(),
          },
        ),
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
    );
  }

  void getSermons() async {
    var sermonPvr = Provider.of<SermonProvider>(context, listen: false);
    var pastorPvr = Provider.of<PastorProvider>(context, listen: false);

    await sermonPvr.getSermons(
      scaffoldKey: _scaffoldKey,
    );

    pastorPvr.getPastors(
      scaffoldKey: _scaffoldKey,
    );
  }
}
