/*
* This class is responsible for discovering peripherals and connecting them
* */

import 'package:flutter/material.dart';
/*we need flutter_blue package to implement ble communication*/
import 'package:flutter_blue/flutter_blue.dart';
import 'DeviceDetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter BLE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*create FlutterBlue instance*/
  FlutterBlue flutterBlue = FlutterBlue.instance;

  /*use set so that you get unique devices*/
  Set<ScanResult> listScannedDevice = Set<ScanResult>();

  /*default value when a device is discovered*/
  String connectStatus = "CONNECT";

  /*start discovery of nearby devices*/
  void scanForDevices() async {
    flutterBlue
        .scan(allowDuplicates: false, scanMode: ScanMode.balanced)
        .listen((scanResult) async {
      print("found device");
      //Assigning bluetooth device
      setState(() {
        listScannedDevice.add(scanResult);
      });
      //After that we stop the scanning for device
      endDiscoveringPeripheral();
    });
  }

  /*stop scanning nearby devices*/
  void endDiscoveringPeripheral() {
    flutterBlue.stopScan();
  }

  /*connect scanned/discovered nearby device*/
  void connect(BluetoothDevice device) async {
    await device.connect();
  }

  /*disconnect connected device*/
  void disConnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  /*start scanning peripherals only if bluetooth is on*/
  void beginDiscoveringPeripheral() {
    //checks bluetooth current state
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.on) {
        scanForDevices();
      } else {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("ERROR!!!"),
              content: new Text("Your bluetooth is off please turn on to continue"),
            )
        );
      }
    });
  }

  /*This method is called when user want to connect or disconnect.
  if device is connected , disconnect it and otherwise. Accordingly update title also*/

  handleConnectDisconnect(ScanResult item) async {
    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;

    if (connectedDevices.contains(item.device)) {
      disConnect(item.device);
      setState(() {
        connectStatus = "CONNECT";
      });
    } else {
      connect(item.device);
      setState(() {
        connectStatus = "DISCONNECT";
      });
    }
  }

  /*
  Below is relevant to build and UI set up
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body:
          getBodyWig(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding getBodyWig() {
    return Padding(
      padding: EdgeInsets.all(8.00),
      child: Center(
        child: getColumnWig(),
      ),
    );
  }

  Column getColumnWig() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getDiscoverDevicesButton(),
        Expanded(
          child: setUpListViewBuilderWig(),
        ),
      ],
    );
  }

  ListView setUpListViewBuilderWig() {
    return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: listScannedDevice.toList().length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = listScannedDevice.toList()[index];

        return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: buildListTile(item, context),
        );
      },
    );
  }

  RaisedButton getDiscoverDevicesButton() {
    return RaisedButton(
      color: Colors.lightBlue,
      child: Text(
        "DISCOVER DEVICES",
        style: new TextStyle(
          fontSize: 25.0,
          color: Colors.white,
        ),
      ),
      onPressed: beginDiscoveringPeripheral,
    );
  }

  ListTile buildListTile(ScanResult item, BuildContext context) {
    return ListTile(
      trailing: Column(
        children: [
          Expanded(
            child: getConDisconButtonWig(item),
          ),
        ],
      ),
      title: getTitleWig(item),
      onTap: () {
        openDetailScreen(item, context);
      },
    );
  }

  RaisedButton getConDisconButtonWig(ScanResult item) {
    return RaisedButton(
      child: Text(
        connectStatus,
        style: new TextStyle(
          fontSize: 16.0,
          color: connectStatus == "CONNECT" ? Colors.green : Colors.red,
        ),
      ),
      onPressed: () {
        handleConnectDisconnect(item);
      },
    );
  }

  openDetailScreen(ScanResult item, BuildContext context) async {
    List<BluetoothService> services = await item.device.discoverServices();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetail(),
        settings: RouteSettings(
          arguments: item.device,
        ),
      ),
    );
  }
}

Text getTitleWig(ScanResult item) {
  return Text(
    item.device.name,
    style: new TextStyle(
      fontSize: 15.0,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
  );
}
