import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/payment.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/firestore/payments.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

class AdminPayments extends StatefulWidget {
  const AdminPayments({Key? key}) : super(key: key);

  @override
  _AdminPaymentsState createState() => _AdminPaymentsState();
}

class _AdminPaymentsState extends State<AdminPayments> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payments'),
          actions: [
            IconButton(
                onPressed: () async {
                  controller.text = '';
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                            builder: (context, setDialogState) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: controller,
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: 'قيمة الطلب'),
                                    onChanged: (value) {
                                      setDialogState(() {});
                                    },
                                  ),
                                  controller.text.isEmpty
                                      ? Container()
                                      : Expanded(
                                          child: Center(
                                            child: Text(
                                              Methods.formatPrice(int.tryParse(
                                                      controller.text)) +
                                                  ' IQD',
                                              style:
                                                  const TextStyle(fontSize: 22),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            actions: [
                              Center(
                                child: ElevatedButton.icon(
                                    onPressed: controller.text.isEmpty
                                        ? null
                                        : () async {
                                            String barcodeScanRes =
                                                await FlutterBarcodeScanner
                                                    .scanBarcode(
                                                        '#ff6666',
                                                        'Cancel',
                                                        true,
                                                        ScanMode.QR);
                                            if (barcodeScanRes == '-1') {
                                              return;
                                            }
                                            int? amount =
                                                int.tryParse(controller.text);
                                            if (amount == null || amount == 0) {
                                              return;
                                            }
                                            Methods.showLoaderDialog(context);
                                            await locator
                                                .get<Payments>()
                                                .addPayment(
                                                    barcodeScanRes, amount);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                    icon: const FaIcon(FontAwesomeIcons.qrcode),
                                    label: const Text('مسح رمز المستخدم')),
                              )
                            ],
                          );
                        });
                      });
                },
                icon: const FaIcon(FontAwesomeIcons.plus)),
          ],
        ),
        body: StreamBuilder(
          stream: locator.get<Payments>().watchPayments(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
              ));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No Payments Found'));
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            List<Payment> payments = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: payments.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RoundIconButton(
                                onTap: null,
                                size: 32,
                                icon: payments[index].status == 'pendding'
                                    ? FontAwesomeIcons.solidHourglass
                                    : payments[index].status == 'completed'
                                        ? FontAwesomeIcons.checkDouble
                                        : FontAwesomeIcons.xmark,
                                color: payments[index].status == 'pendding'
                                    ? Colors.amber
                                    : payments[index].status == 'completed'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  Methods.formatPrice(payments[index].amount) +
                                      ' IQD'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(Methods.formatDate(
                                  payments[index].timestamp, 'en')),
                              Text(Methods.formatTime(
                                  payments[index].timestamp, 'en')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    payments[index].error == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              payments[index].error!,
                              // textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                  ],
                );
              },
            );
          },
        ));
  }
}
