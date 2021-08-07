import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qrcode_scanner/data/scan_data.dart';

class ViewScans extends StatelessWidget {
  final _random = Random();

  Color? listColor() {
    List<Color> _colors = [
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
      Colors.red,
      Colors.brown,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];
    return _colors[_random.nextInt(_colors.length-1)];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemCount: scannedData.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white30,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: listColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.qr_code,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  minLeadingWidth: 10,
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 12,
                      ),
                      SizedBox(width: 2),
                      Text(
                        scannedData[index].time,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    scannedData[index].text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
