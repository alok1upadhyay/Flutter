/*
* This class is responsible for discovering services & characteristics of already connected devices
* */

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDetail extends StatefulWidget {
  @override
  _DeviceDetailState createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  String detail = "";
  @override
  Widget build(BuildContext context) {
    final BluetoothDevice device = ModalRoute.of(context).settings.arguments;
//    final List<BluetoothService> services = ModalRoute.of(context).settings.arguments;
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("DETAIL"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              RaisedButton(
                color: Colors.lightBlue,
                child: Text(
                  'Discover Services',
                  style: new TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  discoverServicesAndCharacteristics(device);
                },
              ),
              Text(detail)
            ],
          ),
        ),
      ),
    );
  }

  discoverServicesAndCharacteristics(BluetoothDevice device) async {
    String detail1 = "";

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) {
        detail1 +=
            '\n********************************* [[VALUE is]] $characteristic.value \n [[DESCRIPTION IS]] $characteristic.descriptors *********************************\n';
      });
    });
    setState(() {
      detail = detail1;
    });
  }
}
