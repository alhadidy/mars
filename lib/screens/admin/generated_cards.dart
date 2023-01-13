import 'package:flutter/material.dart';
import 'package:mars/models/card.dart' as card;
import 'package:mars/services/firestore/cards.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_widget/ticket_widget.dart';

class GeneratedCards extends StatefulWidget {
  const GeneratedCards({Key? key}) : super(key: key);

  @override
  State<GeneratedCards> createState() => _GeneratedCardsState();
}

class _GeneratedCardsState extends State<GeneratedCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Cards'),
      ),
      body: StreamBuilder(
        stream: locator.get<Cards>().getActiveCards(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text('Network Error'),
            );
          }
          List<card.Card> cards = snapshot.data;
          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cards[index].name),
                ),
                trailing: Text(Methods.formatDateShorter(
                  cards[index].time,
                )),
                subtitle: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(Methods.formatPrice(cards[index].amount)),
                ),
                onTap: () {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  QrImage(
                                      errorCorrectionLevel:
                                          QrErrorCorrectLevel.H,
                                      data: cards[index].id,
                                      version: QrVersions.auto,
                                      size: 250,
                                      gapless: false,
                                      foregroundColor: Colors.amber,
                                      dataModuleStyle: const QrDataModuleStyle(
                                          dataModuleShape:
                                              QrDataModuleShape.circle),
                                      eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.circle)),
                                  Text(
                                    cards[index].id.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                              Text(
                                cards[index].name.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 24),
                              ),
                              Text(Methods.formatPrice(cards[index].amount),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
