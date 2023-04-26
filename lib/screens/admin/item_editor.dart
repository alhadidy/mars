import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mars/models/addon.dart';
import 'package:mars/models/category.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/cup_size.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

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
  List<CupSize> sizes = [];
  List<Addon> addons = [];
  @override
  void initState() {
    widget.item == null ? update = false : update = true;

    if (update) {
      nameController.text = widget.item!.name;
      descController.text = widget.item!.desc;
      sizes = widget.item!.sizes;
      addons = widget.item!.addons;

      selectedCategory = widget.item!.category;
      bestSeller = widget.item!.bestSeller;
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
                      sizes: sizes,
                      addons: addons,
                      image: image == '' ? null : File(image),
                      updateImage: image.isNotEmpty,
                      bestSeller: bestSeller);
                } else {
                  await locator.get<Items>().addItem(
                      name: nameController.text,
                      desc: descController.text,
                      category: selectedCategory,
                      sizes: sizes,
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
            future: locator.get<Categories>().getCategoriesFuturer(),
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
                                ? Colors.amber
                                : null,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.black),
              onPressed: () {
                sizesDialog();
              },
              icon: const FaIcon(FontAwesomeIcons.plus),
              label: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'اضافة حجم',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: sizes.map((size) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      sizesDialog(size: size);
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
                          sizes.remove(size);
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

  sizesDialog({CupSize? size}) {
    if (size != null) {
      sizeNameController.text = size.name;
      sizePriceController.text = size.price.toString();
      sizeDiscountController.text = size.discount.toString();
    }
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Directionality(
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
                        controller: sizeNameController,
                        decoration: const InputDecoration(labelText: 'الاسم'),
                      ),
                    ),
                  ),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width / 2,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: sizePriceController,
                        decoration: const InputDecoration(labelText: 'السعر'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width / 2,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: sizeDiscountController,
                        decoration: const InputDecoration(labelText: 'الخصم'),
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
                          if (size != null) {
                            sizes.remove(size);
                          }
                          sizes.add(CupSize(
                              sizeNameController.text,
                              int.tryParse(sizePriceController.text) ?? 0,
                              int.tryParse(sizeDiscountController.text) ?? 0));
                        });
                      },
                      child: Text(size != null ? 'تعديل' : 'اضافة'))
                ],
              ),
            ),
          );
        })).then((value) {
      sizeNameController.text = '';
      sizePriceController.text = '';
      sizeDiscountController.text = '';
    });
  }

  addonsDialog({Addon? addon}) {
    if (addon != null) {
      addonNameController.text = addon.name;
      addonPriceController.text = addon.price.toString();
    }
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Directionality(
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
                          addons.add(Addon(
                            addonNameController.text,
                            int.tryParse(addonPriceController.text) ?? 0,
                          ));
                        });
                      },
                      child: Text(addon != null ? 'تعديل' : 'اضافة'))
                ],
              ),
            ),
          );
        })).then((value) {
      addonNameController.text = '';
      addonPriceController.text = '';
    });
  }
}
