import 'dart:async';
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

  // Global error handling to capture uncaught exceptions and print full stack
  FlutterError.onError = (FlutterErrorDetails details) {
    // Flutter framework errors
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
  };

  runZonedGuarded(() {
    runApp(const presentation.PresentationApp());
  }, (error, stack) {
    // Print stacktrace so user can paste it here
    // In release you might report this to a logging backend
    // Keep minimal handling to avoid crashing silently
    // ignore: avoid_print
    print('Uncaught error: $error');
    // ignore: avoid_print
    print(stack);
  });
}