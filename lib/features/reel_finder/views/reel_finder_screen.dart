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
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterClipboard.paste()
        .then((value) => download(reelUrl: value));
  }

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
                height: 70,
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
            ],
          ),
        ),
      ),
    );
  }

  void download({required String reelUrl}) async {
    copyTextController.text = reelUrl;
    var status = await Permission.storage.status;
    if (status.isGranted) {
      var myVideoUrl = await flutterInsta.downloadReels(reelUrl);
      final storage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: myVideoUrl,
        savedDir: storage!.path,
        // savedDir: "/storage/emulated/0/Download/",
        showNotification: true,
        openFileFromNotification: true,
      ).whenComplete(() {
        setState(() {
          downloading = false;
        });
      });
    }
  }
}
