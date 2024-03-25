import 'package:bluetooth_app/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage>
    with WidgetsBindingObserver {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> pairedDevices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getBTState();
    btStateListener();
  }

  getPairedDevices() {
    FlutterBluetoothSerial.instance.getBondedDevices().then((devices) {
      pairedDevices = devices;
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  getBTState() async {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
      setState(() {});
      if (state.isEnabled) {
        getPairedDevices();
      }
    });
  }

  btStateListener() {
    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      bluetoothState = state;

      if (state.isEnabled) {
        getPairedDevices();
      } else {
        pairedDevices.clear();
      }
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (bluetoothState.isEnabled) {
      Future.delayed(const Duration(milliseconds: 2500), getPairedDevices);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Enable Bluetooth'),
          value: bluetoothState.isEnabled,
          onChanged: (val) async {
            if (val) {
              await FlutterBluetoothSerial.instance.requestEnable();
            } else {
              await FlutterBluetoothSerial.instance.requestDisable();
            }
            setState(() {});
          },
        ),
        ListTile(
          title: const Text('Bluetooth Status'),
          subtitle: Text(bluetoothState.toString()),
          trailing: InkWell(
            onTap: () {
              FlutterBluetoothSerial.instance.openSettings();
            },
            child: const SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Settings'),
                ),
              ),
            ),
          ),
        ),
        if (pairedDevices.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Paired Devices:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pairedDevices.length,
            itemBuilder: (context, index) {
              var device = pairedDevices[index];
              return ListTile(
                onTap: () {
                  if (device.isConnected) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(device: device)));
                  }
                },
                title: Text(device.name!),
                subtitle: Text(device.address),
                trailing: device.isConnected
                    ? const Icon(Icons.link)
                    : const SizedBox(),
              );
            },
          ),
        ),
      ],
    );
  }
}
