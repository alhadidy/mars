import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mars/models/transaction.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    UserData userData = ref.watch(userDataProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة'),
        centerTitle: true,
        actions: [
          Center(
              child: Text(
            '${Methods.formatPrice(userData.cash)} د.ع',
            style: const TextStyle(height: 2),
          )),
          IconButton(
              onPressed: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.QR);
                if (barcodeScanRes == '-1') {
                  return;
                }
                locator
                    .get<Users>()
                    .scanGiftCard(user.uid, barcodeScanRes)
                    .then((value) => Methods.showSnackHome(
                        context: context,
                        title: 'تم التعرف على البطاقة',
                        tip: 'جاري معالجة الطلب',
                        icon: FontAwesomeIcons.checkDouble))
                    .catchError((err) {
                  print(err);
                  Methods.showSnackHome(
                      context: context,
                      title: 'لم تتم اضافة البطاقة',
                      icon: FontAwesomeIcons.xmark);
                });
              },
              icon: const FaIcon(FontAwesomeIcons.qrcode)),
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Users>().watchTransactions(user),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          List<Transaction>? transactions = snapshot.data;

          if (transactions == null || transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'لا توجد نشاطات في المحفظة',
                    style: GoogleFonts.tajawal(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        'اضغط على الزر الموجود في اعلى اليمين من اجل اضافة رصيد الى المحفظة',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),
                  const FaIcon(FontAwesomeIcons.qrcode)
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: transactions.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      toBeginningOfSentenceCase(transactions[index].type) ??
                          ''),
                ),
                trailing: transactions[index].type == 'deposit'
                    ? RoundIconButton(
                        size: 36,
                        iconSize: 18,
                        onTap: () {},
                        icon: FontAwesomeIcons.solidCircleDown,
                      )
                    : transactions[index].type == 'withdrawal'
                        ? RoundIconButton(
                            size: 36,
                            color: Colors.red.shade900,
                            iconSize: 18,
                            onTap: () {},
                            icon: FontAwesomeIcons.solidCircleUp,
                          )
                        : Container(),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Amount: ${Methods.formatPrice(transactions[index].amount)} IQD'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Before Trans: ${Methods.formatPrice(transactions[index].before)} IQD'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'After Trans: ${Methods.formatPrice(transactions[index].after)} IQD'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Date: ${Methods.formatDate(transactions[index].timestamp, 'en')}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Time: ${Methods.formatTime(transactions[index].timestamp, 'en')}'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
