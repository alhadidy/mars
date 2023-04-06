import 'package:flutter/material.dart';

class StarsStepper extends StatelessWidget {
  final List<int> steps;
  final int userPoints;
  const StarsStepper({super.key, required this.steps, this.userPoints = 0});

  @override
  Widget build(BuildContext context) {
    double width = double.infinity;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 55,
        width: width,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 3,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
              ),
            ),
            Center(
              child: SizedBox(
                width: width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: steps.map((step) {
                      return SizedBox(
                        width: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CircleAvatar(
                              radius: 6,
                              backgroundColor: userPoints >= step
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey[500],
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: userPoints >= step
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey[50],
                              ),
                            ),
                            SizedBox(
                                height: 20,
                                child: Text(
                                  step.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      height: 1.3,
                                      fontSize: 12),
                                ))
                          ],
                        ),
                      );
                    }).toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
