import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mars/models/addon.dart';
import 'package:mars/models/category.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/size_preset.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/firestore/sizes.dart';

class ItemEditor extends StatefulWidget {
  final Item? item;
  const ItemEditor({Key? key, this.item}) : super(key: key);

  @override
  State<ItemEditor> createState() => _ItemEditorState();
}

class _ItemEditorState extends State<ItemEditor> {
  late bool update;
  TextEditingController nameController = TextEditingController();

  TextEditingController descController = TextEditingController();
  TextEditingController sizeNameController = TextEditingController();
  TextEditingController sizePriceController = TextEditingController();
  TextEditingController sizeDiscountController = TextEditingController();
  TextEditingController addonNameController = TextEditingController();
  TextEditingController addonPriceController = TextEditingController();
  String image = '';
  bool bestSeller = false;
  String selectedCategory = '';
  late List<SizePreset> cupSizes;
  List<Addon> addons = [];

  Future sizesFuture = locator.get<Sizes>().getSizes();
  Future categoriesFuturer = locator.get<Categories>().getCategoriesFuturer();
  @override
  void initState() {
    inspect(widget.item);
    widget.item == null ? update = false : update = true;

    if (update) {
      nameController.text = widget.item!.name;
      descController.text = widget.item!.desc;
      cupSizes = [...widget.item!.sizes];

      addons = widget.item!.addons;

      selectedCategory = widget.item!.category;
      bestSeller = widget.item!.bestSeller;
    } else {
      cupSizes = [];
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    sizeNameController.dispose();
    sizePriceController.dispose();
    sizeDiscountController.dispose();
    addonNameController.dispose();
    addonPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(update ? 'Edit Item' : 'Add Item'),
        actions: [
          update
              ? IconButton(
                  onPressed: () async {
                    Methods.showLoaderDialog(context);

                    await locator.get<Items>().deleteItem(widget.item!.fid);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.trash))
              : Container(),
          IconButton(
              onPressed: () async {
                Methods.showLoaderDialog(context);

                if (update) {
                  await locator.get<Items>().updateItem(
                      id: widget.item!.fid,
                      name: nameController.text,
                      desc: descController.text,
                      category: selectedCategory,
                      sizes: cupSizes,
                      addons: addons,
                      image: image == '' ? null : File(image),
                      updateImage: image.isNotEmpty,
                      bestSeller: bestSeller);
                } else {
                  await locator.get<Items>().addItem(
                      name: nameController.text,
                      desc: descController.text,
                      category: selectedCategory,
                      sizes: cupSizes,
                      addons: addons,
                      image: image == '' ? null : File(image),
                      bestSeller: bestSeller);
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk)),
        ],
      ),
      body: SingleChildScrollView(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(children: [
          InkWell(
            onTap: () async {
              PickedFile? file = await ImagePicker.platform
                  .pickImage(source: ImageSource.gallery);
              if (file != null) {
                setState(() {
                  image = file.path;
                });
              }
            },
            child: update
                ? image.isNotEmpty
                    ? Image.file(
                        File(image),
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        imageUrl: widget.item!.imgUrl,
                        errorWidget: ((context, url, error) {
                          return Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.image,
                                size: 100,
                              ),
                            ),
                          );
                        }),
                      )
                : image.isNotEmpty
                    ? Image.file(
                        File(image),
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.image,
                            size: 100,
                          ),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            bestSeller = !bestSeller;
                          });
                        },
                        icon: bestSeller
                            ? const FaIcon(FontAwesomeIcons.solidStar)
                            : const FaIcon(FontAwesomeIcons.star)),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'الأسم'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'الوصف'),
            ),
          ),
          FutureBuilder(
            future: categoriesFuturer,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              List<Category> categories = snapshot.data;
              return SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        onTap: () {
                          setState(() {
                            selectedCategory = categories[index].name;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            color: selectedCategory == categories[index].name
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.5)
                                : Colors.grey.shade200,
                          ),
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      imageUrl: categories[index].imgUrl,
                                      errorWidget: (context, url, error) {
                                        return const CircleAvatar();
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      categories[index].name,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: sizesFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                List<SizePreset> sizePresets = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: sizePresets.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      bool selected = cupSizes.where(((element) {
                        return element.fid == sizePresets[index].fid;
                      })).isNotEmpty;
                      return InkWell(
                        highlightColor: Colors.amber.withOpacity(0.2),
                        splashColor: Colors.amber.withOpacity(0.2),
                        focusColor: Colors.amber.withOpacity(0.2),
                        hoverColor: Colors.amber.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: selected
                            ? () {
                                setState(() {
                                  cupSizes.removeWhere(
                                    (element) {
                                      return element.fid ==
                                          sizePresets[index].fid;
                                    },
                                  );
                                });
                              }
                            : () {
                                setState(() {
                                  cupSizes.add(sizePresets[index]);
                                });
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5)
                                    : Colors.grey.shade200),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/imgs/cup.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      sizePresets[index].name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    Methods.formatPrice(
                                            Methods.roundPriceWithDiscountIQD(
                                          price: sizePresets[index].price,
                                          discount: sizePresets[index].discount,
                                        )) +
                                        ' IQD',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  sizePresets[index].discount != 0
                                      ? Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Row(
                                            children: [
                                              Text(
                                                Methods.formatPrice(
                                                      sizePresets[index].price,
                                                    ) +
                                                    ' IQD',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '-' +
                                                    Methods.formatPrice(
                                                      sizePresets[index]
                                                          .discount,
                                                    ) +
                                                    '%',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      sizePresets[index]
                                              .amount
                                              .toStringAsFixed(0) +
                                          ' ' +
                                          sizePresets[index].unit,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: cupSizes.map((size) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      // sizesDialog(size: size);
                    },
                    title: Text(size.name),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${size.discount.toString()}%-'),
                            Text(size.price.toString()),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                          child: Divider(
                            thickness: 2,
                            height: 4,
                          ),
                        ),
                        Text(
                          Methods.roundPriceWithDiscountIQD(
                                  price: size.price, discount: size.discount)
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          cupSizes.remove(size);
                        });
                      },
                      icon: const FaIcon(FontAwesomeIcons.xmark),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.black),
              onPressed: () {
                addonsDialog();
              },
              icon: const FaIcon(FontAwesomeIcons.plus),
              label: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'الإضافات',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: addons.map((addon) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      addonsDialog(addon: addon);
                    },
                    title: Text(addon.name),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          addon.price.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          addons.remove(addon);
                        });
                      },
                      icon: const FaIcon(FontAwesomeIcons.xmark),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ]),
      )),
    );
  }

  // sizesDialog({SizePreset? size}) {
  //   if (size != null) {
  //     sizeNameController.text = size.name;
  //     sizePriceController.text = size.price.toString();
  //     sizeDiscountController.text = size.discount.toString();
  //   }
  //   showDialog(
  //       context: context,
  //       builder: ((context) {
  //         return AlertDialog(
  //           contentPadding: const EdgeInsets.all(0),
  //           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //           content: SingleChildScrollView(
  //             child: Directionality(
  //               textDirection: TextDirection.rtl,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   SizedBox(
  //                     height: 100,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         autofocus: true,
  //                         textAlign: TextAlign.center,
  //                         controller: sizeNameController,
  //                         decoration: const InputDecoration(labelText: 'الاسم'),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     // width: MediaQuery.of(context).size.width / 2,
  //                     height: 100,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         textAlign: TextAlign.center,
  //                         controller: sizePriceController,
  //                         decoration: const InputDecoration(labelText: 'السعر'),
  //                         keyboardType: TextInputType.number,
  //                         inputFormatters: <TextInputFormatter>[
  //                           FilteringTextInputFormatter.digitsOnly
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     // width: MediaQuery.of(context).size.width / 2,
  //                     height: 100,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         textAlign: TextAlign.center,
  //                         controller: sizeDiscountController,
  //                         decoration: const InputDecoration(labelText: 'الخصم'),
  //                         keyboardType: TextInputType.number,
  //                         inputFormatters: <TextInputFormatter>[
  //                           FilteringTextInputFormatter.digitsOnly
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         setState(() {
  //                           if (size != null) {
  //                             sizes.remove(size);
  //                           }
  //                           sizes.add(SizePreset(
  //                               null,
  //                               sizeNameController.text,
  //                               0,
  //                               '',
  //                               int.tryParse(sizePriceController.text) ?? 0,
  //                               int.tryParse(sizeDiscountController.text) ??
  //                                   0));
  //                         });
  //                       },
  //                       child: Text(size != null ? 'تعديل' : 'اضافة'))
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       })).then((value) {
  //     sizeNameController.text = '';
  //     sizePriceController.text = '';
  //     sizeDiscountController.text = '';
  //   });
  // }

  addonsDialog({Addon? addon}) {
    if (addon != null) {
      addonNameController.text = addon.name;
      addonPriceController.text = addon.price.toString();
    }
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          controller: addonNameController,
                          decoration: const InputDecoration(labelText: 'الاسم'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: addonPriceController,
                          decoration: const InputDecoration(labelText: 'السعر'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          setState(() {
                            if (addon != null) {
                              addons.remove(addon);
                            }
                            // addons.add(Addon(
                            //   addonNameController.text,
                            //   int.tryParse(addonPriceController.text) ?? 0,
                            // ));
                          });
                        },
                        child: Text(addon != null ? 'تعديل' : 'اضافة'))
                  ],
                ),
              ),
            ),
          );
        })).then((value) {
      addonNameController.text = '';
      addonPriceController.text = '';
    });
  }
}
