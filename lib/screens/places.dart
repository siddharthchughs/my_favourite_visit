import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/place_visited_notifier.dart';
import 'listofplaces.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late Future<void> _loadVisitedFuture;

  @override
  void initState() {
    super.initState();
    _loadVisitedFuture = ref.read(userPlaceProvider.notifier).loadOffline();
  }

  @override
  Widget build(BuildContext context) {
    final userPLaces = ref.watch(userPlaceProvider);

    return FutureBuilder(
      future: _loadVisitedFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListOfPlaces(placeList: userPLaces),
    );
  }
}
