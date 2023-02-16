import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/msg.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/firestore/support.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  TextEditingController msgController = TextEditingController();

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('خدمة العملاء'),
        ),
        body: const Center(child: Text('حدثت مشكلة اثناء التحميل')),
      );
    }
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const FaIcon(FontAwesomeIcons.plus),
            onPressed: (() {
              showDialog(
                  context: context,
                  builder: (cotext) {
                    return AlertDialog(
                      title: const Text(
                        'رسالة جديدة لخدمة العملاء',
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: msgController,
                              maxLines: 5,
                              minLines: 1,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'كيف يمكننا المساعدة'),
                            ),
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          ElevatedButton(
                            child: const Text('ارسال'),
                            onPressed: () async {
                              if (msgController.text.isEmpty) {
                                return;
                              }
                              await locator
                                  .get<Support>()
                                  .addMsg(user.uid, msgController.text, '', '');
                              msgController.text = '';
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  });
            })),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: (() {
                  final Uri callLaunchUri = Uri(
                    scheme: 'tel',
                    path: '+964770 8821 009',
                  );
                  launchUrl(callLaunchUri);
                }),
                icon: const FaIcon(FontAwesomeIcons.phone))
          ],
          centerTitle: true,
          title: const Text('خدمة العملاء'),
        ),
        body: StreamBuilder<dynamic>(
          stream: locator.get<Support>().watchMsgs(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<Msg> msgs = snapshot.data;

              if (msgs.isEmpty) {
                return const Center(child: Text('تواصل مع خدمة العملاء'));
              }
              return Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  itemCount: msgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: msgs[index].supportId == ''
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      Methods.formatTime(
                                          msgs[index].time, 'en'),
                                      style: TextStyle(
                                        color: msgs[index].supportId == ''
                                            ? Colors.white
                                            : null,
                                      )),
                                  Text(
                                      Methods.formatDate(
                                          msgs[index].time, 'en'),
                                      style: TextStyle(
                                        color: msgs[index].supportId == ''
                                            ? Colors.white
                                            : null,
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(msgs[index].content,
                                  style: TextStyle(
                                    color: msgs[index].supportId == ''
                                        ? Colors.white
                                        : null,
                                  )),
                            ),
                          ],
                        ));
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('حدثت مشكلة اثناء التحميل'));
            }

            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
          },
        ));
  }
}
