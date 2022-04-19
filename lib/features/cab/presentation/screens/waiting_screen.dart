import 'package:flutter/material.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';
import 'package:taxi_line/features/cab/presentation/widgets/test_widget.dart';
import 'package:taxi_line/features/cab/presentation/widgets/trip_accepted_bottom_sheet.dart';
import 'package:taxi_line/features/cab/presentation/widgets/waiting_bottom_sheet.dart';

class WaitingScreen extends StatelessWidget {
  static const routeName = '/waiting_screen';

  const WaitingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TripController tripController = sl();
    final trip = ModalRoute.of(context)!.settings.arguments as Trip;

    return Scaffold(
      body: FutureBuilder(
        future: tripController.getPendedTrip(trip),
        builder: (ctx, AsyncSnapshot<Trip> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              print('waiting screen');
              print(snapshot.data!.route.geometryCordinates);
              print(trip.route.geometryCordinates);
              // return TestWidget(trip: snapshot.data!);
              return TripAcceptedBottomSheet(
                  trip: snapshot.data!);
            }
          } else {
            return WaitingBottomSheet(trip: trip);
          }
        },
      ),
    );
  }
}
