import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/size_preset.dart';
import 'package:mars/services/firestore/sizes.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

class AdminSizes extends StatefulWidget {
  const AdminSizes({Key? key}) : super(key: key);

  @override
  _AdminSizesState createState() => _AdminSizesState();
}

class _AdminSizesState extends State<AdminSizes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sizes'),
        actions: [
          IconButton(
              onPressed: () {
                showSizesDialog();
                // showBottomSheet(
                //     context: context,
                //     builder: (c) {
                //       return Scaffold();
                //     });
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Sizes>().watchSizes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<SizePreset> sizes = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: sizes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      sizes[index].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/imgs/cup.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          Methods.formatPrice(Methods.roundPriceWithDiscountIQD(
                                price: sizes[index].price,
                                discount: sizes[index].discount,
                              )) +
                              ' IQD',
                          overflow: TextOverflow.ellipsis,
                        ),
                        sizes[index].discount != 0
                            ? Row(
                                children: [
                                  Text(
                                    Methods.formatPrice(
                                          sizes[index].price,
                                        ) +
                                        ' IQD',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '-' +
                                        Methods.formatPrice(
                                          sizes[index].discount,
                                        ) +
                                        '%',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            sizes[index].amount.toStringAsFixed(0) +
                                ' ' +
                                sizes[index].unit,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onLongPress: () {
                    Methods.showConfirmDialog(context, 'حذف هذا العنصر؟', () {
                      locator.get<Sizes>().deleteSize(sizes[index].fid);
                    }, confirmActionText: 'حذف');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  showSizesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? unit;
        TextEditingController nameController = TextEditingController();
        TextEditingController amountController = TextEditingController();
        TextEditingController priceController = TextEditingController();
        TextEditingController discountController = TextEditingController();
        bool error = false;
        bool loading = false;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.all(8),
          content: StatefulBuilder(builder: (context, dialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Amount'),
                        )),
                        SizedBox(
                          width: 70,
                          child: DropdownButton(
                              value: unit,
                              isExpanded: true,
                              alignment: Alignment.center,
                              icon: Container(
                                width: 0,
                              ),
                              hint: const Text(
                                'Unit',
                              ),
                              underline: Container(),
                              items: SizeUnit.values.map((e) {
                                return DropdownMenuItem(
                                    value: e.name,
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      e.name,
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                dialogState(
                                  () {
                                    unit = value;
                                  },
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Price'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Discount'),
                    ),
                  ),
                  error
                      ? const Text(
                          'Complete required fields',
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                            onPressed: () async {
                              double? amount =
                                  double.tryParse(amountController.text);
                              int? price = int.tryParse(priceController.text);
                              int? discount =
                                  int.tryParse(discountController.text);
                              if (nameController.text == '' ||
                                  amount == null ||
                                  unit == null ||
                                  price == null ||
                                  price == 0) {
                                dialogState(
                                  () {
                                    error = true;
                                  },
                                );
                                return;
                              }
                              if (loading) {
                                return;
                              }

                              dialogState(
                                () {
                                  loading = true;
                                  error = false;
                                },
                              );

                              await locator.get<Sizes>().addSize(
                                  name: nameController.text,
                                  amount: amount,
                                  unit: unit!,
                                  price: price,
                                  discount: discount ?? 0);
                              nameController.text = '';
                              amountController.text = '';
                              priceController.text = '';
                              discountController.text = '';

                              dialogState(
                                () {
                                  unit = null;
                                  loading = false;
                                },
                              );
                            },
                            child: loading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Save')),
                      ))
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
