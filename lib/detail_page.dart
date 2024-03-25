import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.device,
  });

  final BluetoothDevice device;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  BluetoothConnection? _connection;
  bool get isConnected => _connection != null && _connection!.isConnected;

  List<String> bluetoothData = [];

  @override
  void initState() {
    super.initState();
    getBluetoothConnection();
  }

  @override
  void dispose() {
    if (isConnected) {
      _connection!.dispose();
      _connection = null;
    }
    super.dispose();
  }

  getBluetoothConnection() {
    BluetoothConnection.toAddress(widget.device.address).then((connection) {
      _connection = connection;
      bluetoothData = [...bluetoothData, 'Connected...'];
      setState(() {});
      _connection!.input!.listen(onDateReceived).onDone(() {
        if (mounted) setState(() {});
        Navigator.pop(context);
      });
    }).catchError((e) {
      debugPrint('catchError :: ${e.toString()}');
      // Navigator.pop(context);
    });
  }

  removeConnection() {
    _connection!.close().then((value) {
      bluetoothData = [...bluetoothData, 'Disonnected...'];
      setState(() {});
    });
  }

  onDateReceived(Uint8List data) {
    var str = 'Received Data : ${String.fromCharCodes(data)}';
    bluetoothData = [...bluetoothData, str];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name!),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: TextButton(
              onPressed: isConnected
                  ? () {
                      removeConnection();
                    }
                  : () {
                      getBluetoothConnection();
                    },
              child: Text(
                isConnected ? 'disconnect' : 'connect',
                style: TextStyle(
                  color: isConnected ? Colors.red.shade400 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bluetoothData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              bluetoothData[index],
              textAlign: TextAlign.left,
            ),
          );
        },
      ),
    );
  }
}
