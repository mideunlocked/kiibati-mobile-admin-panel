import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/pastor.dart';
import '../../models/sermons.dart';
import '../../providers/pastor_provider.dart';

class SermonDetailWidget extends StatelessWidget {
  const SermonDetailWidget({
    super.key,
    required this.textTheme,
    required this.sizedBox,
    required this.dateTime,
    required this.sermon,
  });

  final Sermon sermon;
  final TextTheme textTheme;
  final SizedBox sizedBox;
  final List<String> dateTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // sermon title
          Text(
            sermon.title,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          sizedBox,
          sizedBox,

          // sermon taking by

          Consumer<PastorProvider>(builder: (context, pastorPvr, _) {
            Pastor? pastor = pastorPvr.getPastor(id: sermon.by);

            return Text(
              'By: ${pastor?.pastorAddress() ?? sermon.by}',
              style: const TextStyle(
                color: Colors.white,
              ),
            );
          }),

          sizedBox,
          sizedBox,

          // sermon date
          Text(
            dateTime[1],
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
