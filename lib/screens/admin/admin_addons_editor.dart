import 'package:flutter/material.dart';
import 'package:mars/models/addon.dart';

class AdminAddonsEditor extends StatefulWidget {
  final Addon? addon;
  const AdminAddonsEditor({Key? key, required this.addon}) : super(key: key);

  @override
  _AdminAddonsEditorState createState() => _AdminAddonsEditorState();
}

class _AdminAddonsEditorState extends State<AdminAddonsEditor> {
  String? type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addon == null ? 'Add Addon' : 'Edit Addon'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(),
              DropdownButton<String>(
                  value: type,
                  hint: Text('Select Type'),
                  items: [
                    DropdownMenuItem(
                      value: 'Quantity',
                      child: Text('Quantity'),
                    ),
                    DropdownMenuItem(
                      value: 'Options',
                      child: Text('Options'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
