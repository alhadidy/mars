import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/firestore/cards.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_widget/ticket_widget.dart';

class AdminPoints extends ConsumerStatefulWidget {
  const AdminPoints({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminPoints> createState() => _AdminPointsState();
}

class _AdminPointsState extends ConsumerState<AdminPoints> {
  @override
  Widget build(BuildContext context) {
    SSetting? settings = ref.watch(shopSettingsProvider);
    UserModel? user = ref.watch(userProvider);
    if (settings == null || user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loyalty Program'),
        ),
        body: const Center(
          child: Text('Network Error'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty Program')),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((cardsContext) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: settings.cards.map((card) {
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(card.name),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(Methods.formatPrice(card.amount)),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Methods.showLoaderDialog(context);
                                String id = Methods.getRandomString(20);

                                locator
                                    .get<Cards>()
                                    .addNewGiftCard(
                                        id: id,
                                        name: card.name,
                                        amount: card.amount,
                                        editorId: user.uid)
                                    .then(
                                  (value) {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (ticketContext) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          content: TicketWidget(
                                            width: 350,
                                            height: 500,
                                            isCornerRounded: true,
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    QrImage(
                                                        errorCorrectionLevel:
                                                            QrErrorCorrectLevel
                                                                .H,
                                                        data: id,
                                                        version:
                                                            QrVersions.auto,
                                                        size: 250,
                                                        gapless: false,
                                                        foregroundColor:
                                                            Colors.amber,
                                                        dataModuleStyle:
                                                            const QrDataModuleStyle(
                                                                dataModuleShape:
                                                                    QrDataModuleShape
                                                                        .circle),
                                                        eyeStyle:
                                                            const QrEyeStyle(
                                                                eyeShape:
                                                                    QrEyeShape
                                                                        .circle)),
                                                    Text(
                                                      id.toUpperCase(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  card.name.toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 24),
                                                ),
                                                Text(
                                                    Methods.formatPrice(
                                                        card.amount),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).catchError((err) {
                                  Navigator.pop(context);
                                });
                              },
                            );
                          }).toList()),
                    );
                  }));
            },
            title: const Text(
              'New Gift Card',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            trailing: const FaIcon(FontAwesomeIcons.plus),
          ),
          ListTile(
            title: const Text('Cards',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            trailing: const FaIcon(FontAwesomeIcons.solidCreditCard),
            onTap: (() {
              Navigator.pushNamed(context, '/generatedCards');
            }),
          ),
        ],
      )),
    );
  }
}
