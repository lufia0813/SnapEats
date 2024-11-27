// ignore_for_file: unused_element, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


String folderID = '19RodOunE2_aKMeh7ldEK_vYmRMHSBl_U';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  //variables for camera set up
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text(
          'Camera',
          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 124, 189, 220),
      ),
      body: _CameraUI(),
      );
  }


  //UI for camera page with shutter button and preview screen
  Widget _CameraUI(){
    if(cameraController == null || cameraController?.value.isInitialized == false){
      return const Center(child: CircularProgressIndicator(),);
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.60,
              width: MediaQuery.sizeOf(context).width * 0.80,
              child: CameraPreview(cameraController!,
              ),
            ),
            IconButton(
              iconSize: 80,
              //on press save the picture into file google drive? or backend databse
              onPressed: () async {
                //XFile picture = await cameraController!.takePicture();
              },
              icon: const Icon( Icons.camera, color: Colors.lightBlue,
              )
            ) 
          ],
        ),
      ),
    );
  }

  //Function for determing if Camera exist
  Future<void> _setupCameraController() async{
    //accessing camera is available 
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty){
      //proceed if camera is not empty
      setState(() {
        //set avaialbe camera into camera variable
        cameras = _cameras;
        //make and set camera controller
        //cameras.last is back camera first is front camera
        cameraController = CameraController(_cameras.last, ResolutionPreset.high);
      });
           /// Initialize the controller
      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }
}