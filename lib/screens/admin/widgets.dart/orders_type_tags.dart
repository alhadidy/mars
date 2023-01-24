import 'package:flutter/material.dart';

typedef OnTypeSelected = void Function(String type);

class OrderTypeTags extends StatelessWidget {
  final OnTypeSelected onTypeSelected;
  final String selectedType;
  const OrderTypeTags(
      {Key? key, required this.selectedType, required this.onTypeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> types = [
      'Pending',
      'Confirmed',
      'Delivering',
      'Delivered',
      'Canceled'
    ];
    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: 50,
      child: ListView(
          reverse: false,
          scrollDirection: Axis.horizontal,
          children: types.map((type) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (() {
                  onTypeSelected(type);
                }),
                child: Container(
                    decoration: BoxDecoration(
                        color: selectedType == type
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                              color: selectedType == type
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    )),
              ),
            );
          }).toList()),
    );
  }
}
