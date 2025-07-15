import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_favourite_visit/model/placemodel.dart';
import 'package:my_favourite_visit/screens/add_place.dart';
import 'package:my_favourite_visit/screens/placedetail.dart';

class ListOfPlaces extends StatelessWidget {
  const ListOfPlaces({super.key, required this.placeList});
  final List<PlaceModel> placeList;

  void _navigateToAddplaces(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (cts) => const AddPlace(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "No Places Added yet !!",
        style:
            Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue),
      ),
    );

    if (placeList.isNotEmpty) {
      content = ListView.builder(
        itemCount: placeList.length,
        itemBuilder: (ctx, index) => Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(40),
          //   color: Colors.green.shade200,
          // ),
          // foregroundDecoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(40),
          //   color: Colors.green.shade200,
          //   border: Border.all(
          //     color: Colors.black26,
          //     width: 2,
          //   ),
          // ),
          margin: EdgeInsets.all(2),
          child: ListTile(
            tileColor: Colors.deepPurple.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              backgroundImage: FileImage(placeList[index].image),
            ),
            title: Text(
              placeList[index].name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.cyan),
            ),
            subtitle: Text(
              placeList[index].location.address,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.amberAccent),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) =>
                      PlaceDetailScreen(place: placeList[index])));
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Places"),
        actions: [
          IconButton(
            onPressed: () {
              _navigateToAddplaces(context);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      ),
    );
  }
}
