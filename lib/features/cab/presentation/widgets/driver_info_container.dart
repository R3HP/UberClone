import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/driver_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';

class DriverInfoContainer extends StatelessWidget {
  final Trip trip;

  const DriverInfoContainer({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DriverController driverController = sl();
    final TripController tripController = sl();
    final size = MediaQuery.of(context).size;
    return Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.81,
              left: 0,
              right: 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 2,
                        color: Colors.grey,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(-2, 2))
                  ],
                  border: Border.all(
                    color: Colors.grey.shade700,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              child: FutureBuilder(
                  future: driverController.getDriverDetails(trip.driverId!),
                  builder: (ctx, AsyncSnapshot<Driver> driverSnapshot) {
                    if (driverSnapshot.hasData) {
                      return Column(
                        children: [
                          ListTile(
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(
                                    driverSnapshot.data!.profilePictureUrl),
                                radius: 25,
                              ),
                              title: Text(driverSnapshot.data!.userName),
                              subtitle: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: driverSnapshot.data!.carModel +
                                          ': ' +
                                          driverSnapshot.data!.plateNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontStyle: FontStyle.italic)),
                                  const TextSpan(text: '\n'),
                                  TextSpan(
                                      text:
                                          '\$ ${trip.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(color: Colors.teal))
                                ]),
                              )),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(width: 2,),
                              Expanded(
                                  child: Consumer(
                                builder: (ctx, ref, child) => ElevatedButton(
                                    onPressed: () async {
                                      await tripController
                                          .deleePendingTrip(trip.id!);
                                      ref.read(cabControllerProvider).cancel();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                              )),
                              const SizedBox(width: 2,),
                              Expanded(
                                  child: Consumer(
                                    builder: (ctx, ref, child) =>
                                        ElevatedButton(
                                            onPressed: () async {
                                              await tripController
                                                  .finishPendingTrip(trip);
                                              final newCredit =
                                                  driverSnapshot.data!.credit +
                                                      trip.price;
                                              await driverController
                                                  .updateDriverCredit(
                                                      trip.driverId!, newCredit);
                                              ref
                                                  .read(cabControllerProvider)
                                                  .cancel();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Finish Trip')),
                                  ),
                                  flex: 2),
                              const SizedBox(width: 2,),
                            ],
                          )
                        ],
                      );
                    } else {
                      if (driverSnapshot.hasError) {
                        return Center(
                          child: Text(driverSnapshot.error.toString()),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    }
                  }),
            ),
          );
  }
}
