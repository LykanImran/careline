import 'package:flutter/material.dart';

class MemberList extends StatelessWidget {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member List')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Add Member"),
        icon: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: Text(
            'This is the Member List screen.',
            style: TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }
}
