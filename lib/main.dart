import 'dart:io';

import 'package:flutter/material.dart';
import 'presentation/main.dart' as presentation;

class DevHttpOverrides extends HttpOverrides {
  final Set<String> trustedHosts = const {
    'picsum.photos',
    'i.picsum.photos',
  };

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      return trustedHosts.contains(host);
    };
    return client;
  }
}

void main() {
  HttpOverrides.global = DevHttpOverrides();
  runApp(const presentation.PresentationApp());
}