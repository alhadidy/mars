import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/editor.dart';
import 'package:mars/services/firestore/editors.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

class AdminEditors extends StatefulWidget {
  const AdminEditors({Key? key}) : super(key: key);

  @override
  State<AdminEditors> createState() => _AdminEditorsState();
}

class _AdminEditorsState extends State<AdminEditors> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editors'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: const Text('New Editor'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration:
                                  const InputDecoration(hintText: 'Name'),
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextField(
                              controller: emailController,
                              decoration:
                                  const InputDecoration(hintText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      Methods.showLoaderDialog(context);
                                      await locator.get<Editors>().addEditor(
                                          nameController.text,
                                          emailController.text);
                                      nameController.text = '';
                                      emailController.text = '';
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Add Editor')),
                              ),
                            )
                          ],
                        ),
                      );
                    }));
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Editors>().getEditors(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return const Center(
              child: Text('No Editors'),
            );
          }

          List<Editor> editors = snapshot.data;

          return ListView.builder(
            itemCount: editors.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        editors[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(editors[index].email,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(editors[index].error),
                ),
                leading: editors[index].uid == null
                    ? const FaIcon(
                        FontAwesomeIcons.solidHourglassHalf,
                        color: Colors.amber,
                      )
                    : editors[index].uid == ''
                        ? const FaIcon(
                            FontAwesomeIcons.xmark,
                            color: Colors.red,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.checkDouble,
                            color: Colors.green,
                          ),
                trailing: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await locator
                          .get<Editors>()
                          .dropEditor(editors[index].fid);
                    }),
              );
            },
          );
        },
      ),
    );
  }
}
