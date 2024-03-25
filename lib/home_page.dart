import 'package:bluetooth_app/bluetooth_page.dart';
import 'package:bluetooth_app/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PageController pageController;
  List<String> titles = ['Bluetooth Devices', 'Camera', 'Table'];
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[pageIndex]),
        centerTitle: true,
        elevation: 5,
      ),
      body: PageView(
        controller: pageController,
        // physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          pageIndex = index;
          setState(() {});
        },
        children: [
          const BluetoothPage(),
          const CamerPage(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Table(
                border: TableBorder.all(width: 2),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.red.shade300),
                    children: const [
                      TableCell(
                        child: SizedBox(
                          height: 30,
                          child: Center(child: Text('Column 1')),
                        ),
                      ),
                      TableCell(
                        child: SizedBox(
                          height: 30,
                          child: Center(child: Text('Column 2')),
                        ),
                      ),
                      TableCell(
                        child: SizedBox(
                          height: 30,
                          child: Center(child: Text('Column 3')),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    5,
                    (index) => TableRow(
                      children: [
                        TableCell(
                          child: SizedBox(
                            height: 30,
                            child: Center(child: Text('Data ${index + 1}')),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            height: 30,
                            child: Center(child: Text('Data ${index + 1}')),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            height: 30,
                            child: Center(child: Text('Data ${index + 1}')),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
