import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';

class CancelButton extends ConsumerWidget {
  const CancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabController = ref.read(cabControllerProvider);
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        margin: EdgeInsets.only(
            top: 
                 MediaQuery.of(context).size.height * 0.125,
            left: MediaQuery.of(context).size.width * 0.035),
        child: Card(
          elevation: 12,
          color: Colors.grey[350],
          shape: const CircleBorder(
              side: BorderSide(width: 1, color: Colors.transparent)),
          child: IconButton(
            onPressed: cabController.cancel,
            icon: const Icon(
              Icons.cancel_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
