import 'package:flutter/material.dart';
import '../notifier/walkthrough_notifier.dart';
import '../feature_discovery/walkthrough_util.dart';


class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Testing Walkthrough')),
      body: Center(
          child: ElevatedButton(
            onPressed: () async => WalkThroughNotifier.instance.setId('Home'),
            child: const Text('start'),
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            activeIcon: WalkthroughWidget(
              childWidget: Icon(Icons.home, color: Colors.blue),
              id: 'Home',
              nextId: 'Mail',
              title: 'Home',
              desc: 'This is home info. Here hebvhb dcgvhdbh  jhvhvbhi  hjvehvhb hebcbehff',
            ),
            backgroundColor: Colors.white,
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: WalkthroughWidget(
              childWidget: Icon(Icons.mail, color: Colors.black),
              highlightedWidget: Icon(Icons.mail, color: Colors.blue),
              id: 'Mail',
              nextId: 'Account',
              title: 'Mail',
              desc: 'This is mail info. Here hebvhb dcgvhdbh  jhvhvbhi  hjvehvhb hebcbehff',

            ),
            activeIcon: Icon(Icons.mail, color: Colors.blue),
            backgroundColor: Colors.white,
            label: 'Mail',
          ),

          BottomNavigationBarItem(
            icon: WalkthroughWidget(
              childWidget: Icon(Icons.account_circle, color: Colors.black),
              highlightedWidget: Icon(Icons.account_circle, color: Colors.blue),
              id: 'Account',
              nextId: 'Edit',
              title: 'Account',
              desc: 'This is account info. Here hebvhb dcgvhdbh  jhvhvbhi  hjvehvhb hebcbehff',

            ),
            activeIcon: Icon(Icons.account_circle, color: Colors.blue),
            backgroundColor: Colors.white,
            label: 'Account',
          ),

          BottomNavigationBarItem(
            icon: WalkthroughWidget(
              childWidget: Icon(Icons.text_fields, color: Colors.black),
              highlightedWidget: Icon(Icons.text_fields, color: Colors.blue),
              id: 'Edit',
              title: 'Edit',
              desc: 'This is edit info. Here hebvhb dcgvhdbh  jhvhvbhi  hjvehvhb hebcbehff',

            ),
            activeIcon: Icon(Icons.text_fields, color: Colors.blue),
            backgroundColor: Colors.white,
            label: 'Edit',
          ),
        ],
      ),
    );
  }
}
