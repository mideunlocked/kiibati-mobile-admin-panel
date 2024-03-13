import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double horizontalPadding = 10.sp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiibati Mobile Admin Panel'),
      ),
      body: GridView(
        padding: EdgeInsets.only(
          top: 1.5.h,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: const [
          PanelGridTile(
            label: 'Sermons',
            routeName: 'SermonsScreen',
          ),
          PanelGridTile(
            label: 'Pastors',
            routeName: 'PastorsScreen',
          ),
        ],
      ),
    );
  }
}

class PanelGridTile extends StatelessWidget {
  const PanelGridTile({
    super.key,
    required this.routeName,
    required this.label,
  });

  final String routeName;
  final String label;

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(20);

    return InkWell(
      onTap: () => routeName.isNotEmpty
          ? Navigator.pushNamed(
              context,
              '/$routeName',
            )
          : null,
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).primaryColor,
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.sp),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
