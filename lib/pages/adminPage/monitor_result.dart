import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MonitorResult extends StatefulWidget {
  const MonitorResult({super.key});

  @override
  State<MonitorResult> createState() => _MonitorResult();
}

class _MonitorResult extends State<MonitorResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context));
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Monitor Result",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/admin');
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/arrow-left-solid.svg'),
        ),
      ),
    );
  }
}
