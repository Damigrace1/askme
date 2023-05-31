import 'package:chatgpt_app/utilities/keys.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../chat/domain/model.dart';

class ConnectivityService {

  ConnectivityService() {
    // Initialize the connectivity plugin

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Handle the connectivity change event
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(mainKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Oops! It seems you have lost internet connection.'),
          backgroundColor: Colors.deepPurple,
        ));
        print('No internet connection');
      } else {
        notify ? {

        ScaffoldMessenger.of(mainKey.currentContext!).showSnackBar(
        const SnackBar(
        content: Text('Yay! Internet Connection restored'),
        backgroundColor: Colors.deepPurple,
        ))
        } : {
          notify = true
        };
        print('Internet connection available');
      }
    });
  }
}
