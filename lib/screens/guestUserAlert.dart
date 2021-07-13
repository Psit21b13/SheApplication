import 'package:flutter/material.dart';
import 'package:womenCare/utils/constants.dart';
import 'package:womenCare/widgets/customeDrawer.dart';

class GustUserAlert extends StatefulWidget {
  final bool prescription;

  const GustUserAlert({Key key, this.prescription}) : super(key: key);
  @override
  _GustUserAlertState createState() => _GustUserAlertState();
}

class _GustUserAlertState extends State<GustUserAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomeDrawer(),
      appBar: AppBar(
        title: Text(widget.prescription
            ? "prescription Report"
            : "pregnancy information"),
        centerTitle: false,
        backgroundColor: Constants.primaryDark,
      ),
      body: Center(
        child: Text("Please register to use this feature"),
      ),
    );
  }
}
