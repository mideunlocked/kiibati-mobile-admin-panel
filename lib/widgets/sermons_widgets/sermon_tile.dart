import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../helpers/date_formatting.dart';
import '../../models/sermons.dart';
import 'sermon_detail.dart';

class SermonListTile extends StatelessWidget {
  const SermonListTile({
    super.key,
    required this.sermon,
  });

  final Sermon sermon;

  @override
  Widget build(BuildContext context) {
    var of = Theme.of(context);
    var textTheme = of.textTheme;
    var primaryColor = of.primaryColor;
    var dateTimeFormatting = DateTimeFormatting();
    var dateTime = dateTimeFormatting.formatTimeDate(sermon.timestamp);
    var sizedBox = SizedBox(
      height: 0.5.h,
    );

    var borderRadius = BorderRadius.circular(20);

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/CRUDSermonScreen',
        arguments: {
          'action': 'Edit',
          'sermon': sermon,
        },
      ),
      borderRadius: borderRadius,
      child: Container(
        height: 18.h,
        width: 100.w,
        margin: EdgeInsets.only(
          bottom: 1.h,
          left: 3.w,
          right: 3.w,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
        ),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            colors: [
              primaryColor,
              primaryColor.withOpacity(0.5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // sermon display image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  sermon.imageUrl,
                  height: 15.h,
                  width: 30.w,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 15.h,
                      width: 30.w,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.grey,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return SizedBox(
                      height: 5.h,
                      width: 28.w,
                      child: Icon(
                        Icons.error_rounded,
                        color: Colors.grey.shade300,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),

            // sermon detail widget
            SermonDetailWidget(
              textTheme: textTheme,
              sizedBox: sizedBox,
              dateTime: dateTime,
              sermon: sermon,
            ),
          ],
        ),
      ),
    );
  }
}
