import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_line/features/cab/data/model/route.dart' as my_route;
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';


class BottomPadItem extends ConsumerWidget {
  final String imageAddress;
  final String itemName;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomPadItem({
    Key? key,
    required this.imageAddress,
    required this.itemName,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.read(cabControllerProvider).direction!.routes.first;
    final price = determinePriceBaseItemName(route);
    return Expanded(
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
            borderRadius: isSelected ? BorderRadius.circular(10) : null,
            border: isSelected
                ? Border.all(color: Theme.of(context).primaryColor,width: 2)
                : null),
        child: ListTile(
            leading: CircleAvatar(
                foregroundImage: AssetImage(imageAddress), radius: 25),
            title: Text(itemName),
            subtitle: Text(route.distanceAsKM.toStringAsFixed(2) +
                'KM' +
                '\n' +
                route.durationAs.inMinutes.toString() +
                'Minutes'),
            trailing: Text('\$' + price.toStringAsFixed(2)),
            onTap: onTap
            ),
      ),
    );
  }

  double determinePriceBaseItemName(my_route.Route route) {
    switch (itemName) {
      case 'Uber':
        return route.calculateRegularPrice();
      case 'UberPlus':
        return route.calculatePlusUerPrice();
      case 'UberVan':
        return route.calculateVanUberPirce();
      default:
        return 0;
    }
  }
}
