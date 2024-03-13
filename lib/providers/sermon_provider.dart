import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/scaffold_messenger_helper.dart';
import '../models/sermons.dart';

class SermonProvider with ChangeNotifier {
  final List<Sermon> _sermons = [];
  List<Sermon> get sermons => _sermons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getSermons({
    required GlobalKey<ScaffoldMessengerState> scaffoldKey,
  }) async {
    _initLoad();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sermons')
          .orderBy('timestamp', descending: true)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Sermon sermon = Sermon.fromJson(
          json: data,
        );

        if (!_sermons.contains(sermon)) {
          _sermons.add(sermon);
        }
      }

      notifyListeners();

      _dispLoad();
    } catch (e) {
      print('Get sermons error: $e');
      _dispLoad();
      showScaffoldMessenger(
        scaffoldKey: scaffoldKey,
        textContent: 'Error trying to get sermons, please try again',
      );
    }
  }

  Future<void> addSermons({
    required Sermon sermon,
    required GlobalKey<ScaffoldMessengerState> scaffoldKey,
  }) async {
    _initLoad();

    try {
      var collection = FirebaseFirestore.instance.collection('sermons');

      await collection
          .add(
        sermon.toJSon(),
      )
          .then((value) async {
        collection.doc(value.id).set(
          {
            'id': value.id,
          },
          SetOptions(merge: true),
        );
      }).then((_) {
        _sermons.setAll(
          0,
          [sermon],
        );

        showScaffoldMessenger(
          scaffoldKey: scaffoldKey,
          textContent: 'Sermon added succesfully',
          bkgColor: Colors.green,
        );
      });

      _dispLoad();
    } catch (e) {
      print('Add sermon error: $e');
      _dispLoad();
      showScaffoldMessenger(
        scaffoldKey: scaffoldKey,
        textContent: 'Error adding sermon, please try again',
      );
    }
  }

  Future<void> editSermons() async {}

  void _initLoad() {
    _isLoading = true;

    notifyListeners();
  }

  void _dispLoad() {
    _isLoading = false;

    notifyListeners();
  }
}
