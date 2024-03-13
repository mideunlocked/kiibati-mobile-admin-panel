import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/sermons.dart';
import '../../widgets/general_widgets/custom_text_field.dart';

class CRUDSermonScreen extends StatefulWidget {
  static const routeName = '/CRUDSermonScreen';

  const CRUDSermonScreen({super.key});

  @override
  State<CRUDSermonScreen> createState() => _CRUDSermonScreenState();
}

class _CRUDSermonScreenState extends State<CRUDSermonScreen> {
  String action = '';
  Sermon sermon = Sermon.nullSermon();

  var titleCtr = TextEditingController();
  var referenceCtr = TextEditingController();
  List<TextEditingController> sermonTextCtr = [
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, init);
  }

  @override
  void dispose() {
    super.dispose();

    titleCtr.dispose();
    referenceCtr.dispose();
    for (var element in sermonTextCtr) {
      element.dispose();
    }
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$action sermon'),
      ),
      body: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),
                    CustomTextField(
                      controller: titleCtr,
                      hint: 'Enter sermon text',
                      label: 'Title',
                    ),
                    CustomTextField(
                      controller: referenceCtr,
                      hint: 'Enter scriptural reference',
                      label: 'Scriptural Reference',
                    ),
                    SizedBox(height: 3.h),
                    const Text(
                      'Sermon Text',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sermonTextCtr.length,
                      itemBuilder: (ctx, index) {
                        return CustomTextField(
                          controller: sermonTextCtr[index],
                          hint: '',
                          label: 'Paragaraph ${index + 1}',
                          suffixIcon: Visibility(
                            visible: sermonTextCtr.length > 1,
                            child: IconButton(
                              onPressed: () {
                                if (sermonTextCtr.length > 1) {
                                  setState(() {
                                    sermonTextCtr.removeAt(index);
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade900,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          sermonTextCtr.add(
                            TextEditingController(),
                          );
                        });
                      },
                      label: const Text('Add paragraph'),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void init() {
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    action = args['action'] as String;
    sermon = args['sermon'] as Sermon;

    if (sermon.id.isNotEmpty) {
      setState(() {
        titleCtr = TextEditingController(text: sermon.title);
        referenceCtr = TextEditingController(
          text: sermon.scripturalReference,
        );
        sermonTextCtr = sermon.sermonText
            .map((e) => TextEditingController(text: e.toString()))
            .toList();
      });
    }
  }
}
