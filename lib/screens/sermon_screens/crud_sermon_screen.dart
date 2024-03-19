import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/pastor.dart';
import '../../models/sermons.dart';
import '../../providers/pastor_provider.dart';
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

  Pastor by = Pastor.pastor();
  String imageUrl = '';
  String category = '';
  String audioLink = '';
  String videoLink = '';
  ServiceType serviceType = ServiceType.Others;

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
                    const CustomLabelText(
                      labelText: 'Sermon Text',
                    ),
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
                    SizedBox(height: 2.h),
                    const CustomLabelText(labelText: 'Service type'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: DropdownButton<ServiceType>(
                        value: serviceType,
                        onChanged: (newValue) {
                          setState(() {
                            serviceType = newValue!;
                          });
                        },
                        items: ServiceType.values.map((ServiceType type) {
                          String typeName = type.name;

                          if (typeName.contains('_')) {
                            List strings = typeName.split('_');
                            typeName = '${strings.first} ${strings.last}';
                          }

                          return DropdownMenuItem<ServiceType>(
                            value: type,
                            child: Text(typeName.toUpperCase()),
                          );
                        }).toList(),
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                      ),
                    ),
                    const CustomLabelText(labelText: 'Service type'),
                    Consumer<PastorProvider>(builder: (context, pastorPvr, _) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: DropdownButton<Pastor>(
                          value: by,
                          onChanged: (newValue) {
                            setState(() {
                              by = newValue!;
                            });
                          },
                          items: pastorPvr.allClergy.map((Pastor pastor) {
                            return DropdownMenuItem<Pastor>(
                              value: pastor,
                              child: Text(
                                pastor.pastorAddress(),
                              ),
                            );
                          }).toList(),
                          borderRadius: BorderRadius.circular(20),
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                        ),
                      );
                    }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CustomLabelText(labelText: 'Sermon Image'),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            imageUrl.isEmpty
                                ? Icons.add_rounded
                                : Icons.delete_rounded,
                            color: imageUrl.isEmpty ? null : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(sermon.imageUrl,
                            width: 100.w, fit: BoxFit.cover, loadingBuilder:
                                (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.grey,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }, errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                          return sermon.imageUrl.isEmpty
                              ? const Center(child: Text('No image'))
                              : Icon(
                                  Icons.error_rounded,
                                  color: Colors.grey.shade300,
                                );
                        }),
                      ),
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
    var pastorPvr = Provider.of<PastorProvider>(context, listen: false);

    setState(() {
      action = args['action'] as String;
      sermon = args['sermon'] as Sermon;
    });

    if (sermon.id.isNotEmpty) {
      setState(() {
        titleCtr = TextEditingController(text: sermon.title);
        referenceCtr = TextEditingController(
          text: sermon.scripturalReference,
        );
        sermonTextCtr = sermon.sermonText
            .map((e) => TextEditingController(text: e.toString()))
            .toList();

        audioLink = sermon.audioLink;
        videoLink = sermon.videoLink;
        imageUrl = sermon.imageUrl;
        by = pastorPvr.allClergy.firstWhere((pastor) => pastor.id == sermon.by);
        serviceType = sermon.serviceType;
        category = sermon.category;
      });
    }
  }
}

class CustomLabelText extends StatelessWidget {
  const CustomLabelText({
    super.key,
    required this.labelText,
  });

  final String labelText;

  @override
  Widget build(BuildContext context) {
    var sizedBox = SizedBox(height: 1.5.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox,
        sizedBox,
        const Divider(),
        sizedBox,
        sizedBox,
        Text(
          labelText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        sizedBox,
      ],
    );
  }
}
