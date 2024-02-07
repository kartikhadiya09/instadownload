import 'dart:isolate';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReelFinderScreen extends StatefulWidget {
  const ReelFinderScreen({Key? key}) : super(key: key);

  @override
  State<ReelFinderScreen> createState() => _ReelFinderScreenState();
}

class _ReelFinderScreenState extends State<ReelFinderScreen>
    with SingleTickerProviderStateMixin {
  FlutterInsta flutterInsta = FlutterInsta();

  TextEditingController copyTextController = TextEditingController();
  bool downloading = false;
  ReceivePort receivePort = ReceivePort();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: copyTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FlutterClipboard.paste()
                      .then((value) => copyTextController.text = value);

                  print("DATA : ${copyTextController.text}");
                  setState(() {});
                },
                child: Card(
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.blue,
                    child: const Center(
                      child: Text("Past"),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  download(reelUrl: copyTextController.text);
                },
                child: Card(
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.blue,
                    child: const Center(
                      child: Text("Past"),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  _downloadFile();
                },
                child: Card(
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.blue,
                    child: const Center(
                      child: Text("Url"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadFile() async {
    final permission = await Permission.storage.request();
    if (permission.isGranted) {
      final baseStorage = await await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
        url: copyTextController.text,
        savedDir: baseStorage!.path,
        fileName: "File"
      );
    }
  }

  void download({required String reelUrl}) async {
    var myVideoUrl = await flutterInsta.downloadReels(reelUrl);

    await FlutterDownloader.enqueue(
      url: myVideoUrl,
      savedDir: '/sdcard/Download',
      showNotification: true,
      openFileFromNotification: true,
    ).whenComplete(() {
      setState(() {
        downloading = false;
      });
    });
  }
}
