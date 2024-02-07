import 'package:flutter/material.dart';
import 'package:instadownload/features/reel_finder/views/reel_finder_screen.dart';
import 'package:instadownload/locator.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


void main() {
  setup();
  initializeDownloader();
  runApp(
    MaterialApp(
      home: const ReelFinderScreen(),
    ),
  );
}



void initializeDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
}