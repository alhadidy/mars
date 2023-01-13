import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';
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
                        title: 'تمت العملية بنجاح',
                        icon: FontAwesomeIcons.checkDouble))
                    .catchError((err) {
                  Methods.showSnackHome(
                      context: context,
                      title: 'لم تتم اضافة البطاقة',
                      icon: FontAwesomeIcons.xmark);
                });
              },
              icon: const FaIcon(FontAwesomeIcons.qrcode)),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Text('${Methods.formatPrice(userData.cash)} د.ع'),
        ),
      ),
    );
  }
}
