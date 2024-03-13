import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/scaffold_messenger_helper.dart';
import '../models/pastor.dart';

class PastorProvider with ChangeNotifier {
  Pastor _bishop = Pastor.pastor();
  Pastor get bishop => _bishop;

  final List<Pastor> _pastors = [];
  List<Pastor> get pastors => _pastors;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getPastors({
    required GlobalKey<ScaffoldMessengerState> scaffoldKey,
  }) async {
    _initLoad();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pastors')
          .orderBy('timestamp')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Pastor pastor = Pastor.fromJson(
          json: data,
        );

        if (!_pastors.contains(pastor)) {
          if (pastor.id == 'bishop') {
            _bishop = pastor;
          } else {
            _pastors.add(pastor);
          }
        }
      }

      notifyListeners();

      _dispLoad();
    } catch (e) {
      print('Get pastors error: $e');
      _dispLoad();
      showScaffoldMessenger(
        scaffoldKey: scaffoldKey,
        textContent: 'Error trying to get pastors, please try again',
      );
    }
  }

  Future<void> addPastors({
    required Pastor pastor,
    required GlobalKey<ScaffoldMessengerState> scaffoldKey,
  }) async {
    _initLoad();

    try {
      var collection = FirebaseFirestore.instance.collection('pastors');

      await collection
          .add(
        pastor.toJson(),
      )
          .then((value) async {
        collection.doc(value.id).set(
          {
            'id': value.id,
          },
          SetOptions(merge: true),
        );
      }).then((_) {
        _pastors.add(pastor);

        showScaffoldMessenger(
          scaffoldKey: scaffoldKey,
          textContent: 'pastor added succesfully',
          bkgColor: Colors.green,
        );
      });

      _dispLoad();
    } catch (e) {
      print('Add pastor error: $e');
      _dispLoad();
      showScaffoldMessenger(
        scaffoldKey: scaffoldKey,
        textContent: 'Error adding pastor, please try again',
      );
    }
  }

  Pastor? getPastor({
    required String id,
  }) {
    if (id == 'bishop') {
      return _bishop;
    } else if (_pastors.any((e) => e.id == id)) {
      return _pastors.firstWhere((e) => e.id == id);
    } else {
      return null;
    }
  }

  void _initLoad() {
    _isLoading = true;

    notifyListeners();
  }

  void _dispLoad() {
    _isLoading = false;

    notifyListeners();
  }
}
