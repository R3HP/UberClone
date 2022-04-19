import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/address.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/geo_code_controller.dart';


class SearchBar extends ConsumerWidget {
  final FocusNode searchTextFieldFocusNode;
  final GeoCodeController geoController = sl();

  SearchBar({
    Key? key,
    required this.searchTextFieldFocusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final searchTextFieldController = TextEditingController();
    final Size size = MediaQuery.of(context).size;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 20),
      curve: Curves.ease,
      padding: EdgeInsets.only(
          top: 35.0,
          left: searchTextFieldFocusNode.hasFocus
              ? size.width / 12
              : size.width / 6.8,
          right: searchTextFieldFocusNode.hasFocus ? size.width / 15 : size.width / 6.8),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                focusNode: searchTextFieldFocusNode,
                controller: searchTextFieldController,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) async {
                  final addresses =
                      await geoController.geoCodeAddressToLatLng(value);
                  showSearchAddressesDialog(context, addresses,ref);
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  label:
                      Row(children: const [Icon(Icons.search), Text('Search')]),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  constraints:
                      BoxConstraints(maxHeight: 50, maxWidth: size.width * 0.7),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            
            if (searchTextFieldFocusNode.hasFocus)
              IconButton(
                onPressed: () async {
                  final addresses = await geoController
                      .geoCodeAddressToLatLng(searchTextFieldController.text);
                  showSearchAddressesDialog(context, addresses,ref);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              )
          ],
        ),
      ),
    );
  }

  
  Future<dynamic> showSearchAddressesDialog(BuildContext context, List<Address> addresses,WidgetRef ref) {
    return showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                        alignment: Alignment.center,
                        elevation: 16,
                        child: ListView.builder(
                          itemCount: addresses.length,
                          itemBuilder: (ctx, index) => ListTile(
                            title: Text(
                              addresses[index].placeAddress,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              final cabController = ref.read(cabControllerProvider);
                              if (cabController.startTripAddress == null) {
                                cabController.startTripAddress= addresses[index];
                                Navigator.of(context).pop();
                              } else {
                                cabController.finishTripAddress = addresses[index];
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ));
  }
}
