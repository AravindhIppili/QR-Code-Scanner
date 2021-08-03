import 'package:flutter/material.dart';
import 'package:qrcode_scanner/data/scan_data.dart';

class ViewScans extends StatefulWidget {
  const ViewScans({Key? key}) : super(key: key);

  @override
  _ViewScansState createState() => _ViewScansState();
}

class _ViewScansState extends State<ViewScans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: scannedData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                scannedData[index].text,
                style: TextStyle(
                  fontSize: 20
                ),),
              trailing: Text(scannedData[index].time),
            );
          },
        ),
      ),
    );
  }
}
