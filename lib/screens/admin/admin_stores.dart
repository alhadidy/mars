import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mars/models/store.dart';
import 'package:mars/services/firestore/stores.dart';
import 'package:mars/services/locator.dart';

class AdminStores extends StatefulWidget {
  const AdminStores({Key? key}) : super(key: key);

  @override
  State<AdminStores> createState() => _AdminStoresState();
}

class _AdminStoresState extends State<AdminStores> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CarouselController carouselController = CarouselController();
  late Future<List<Store>> getStores;
  List<Store>? stores;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.4383527, 44.3762012),
    zoom: 18,
  );

  void _addMarker(String id, String name, GeoPoint location) {
    final MarkerId markerId = MarkerId(id);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        location.latitude,
        location.longitude,
      ),
      onTap: () {
        if (stores == null) {
          return;
        }
        int index = stores!.indexWhere((element) => element.fid == id);
        carouselController.animateToPage(index);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    getStores = locator.get<Stores>().getStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Stores>().watchStores(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<Store> stores = snapshot.data;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(stores[index].name),
                  subtitle: Text(stores[index].address),
                  onTap: (() {}),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
