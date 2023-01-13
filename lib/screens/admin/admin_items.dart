import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/item.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

class AdminItems extends StatefulWidget {
  const AdminItems({Key? key}) : super(key: key);

  @override
  State<AdminItems> createState() => _AdminItemsState();
}

class _AdminItemsState extends State<AdminItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/itemEditor',
                    arguments: {'item': null});
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder(
          stream: locator.get<Items>().getItems(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot);
            if (snapshot.data == null) {
              return Container();
            }
            List<Item> items = snapshot.data;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/itemEditor',
                        arguments: {'item': items[index]});
                  },
                  title: Text(items[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[index].category),
                      items[index].sizes.isEmpty
                          ? Container()
                          : const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('الاحجام:'),
                            ),
                      Wrap(
                        children: items[index].sizes.map((size) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.amber),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Text(
                                  size.name,
                                  style: const TextStyle(height: 1.5),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  leading: ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                      imageUrl: items[index].imgUrl,
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
