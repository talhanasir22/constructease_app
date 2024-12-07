import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'PolicyScreen.dart';
import 'PrimaryContainer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        title: const Text(
          'ConstructEase',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Privacy Policy') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PolicyScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Privacy Policy',
                  child: Text('Privacy Policy'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 15),
            Center(child: PrimaryContainer(text: 'Area Calculator', image: 'assets/Images/Area.png')),
            const SizedBox(height: 15),
            Center(child: PrimaryContainer(text: 'Volume Calculator', image: 'assets/Images/Volume.png')),
            const SizedBox(height: 15),
            Center(child: PrimaryContainer(text: 'Concrete Calculator', image: 'assets/Images/Concrete.png')),
            const SizedBox(height: 15),
            Center(child: PrimaryContainer(text: 'Material Cost', icon: Icons.monetization_on)),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
