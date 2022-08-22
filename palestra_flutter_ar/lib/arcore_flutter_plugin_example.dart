import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArCoreFlutterPluginExample extends StatefulWidget {
  const ArCoreFlutterPluginExample({Key? key}) : super(key: key);

  @override
  State<ArCoreFlutterPluginExample> createState() =>
      _ArCoreFlutterPluginExampleState();
}

class _ArCoreFlutterPluginExampleState
    extends State<ArCoreFlutterPluginExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ArCoreFaceView(
        enableAugmentedFaces: true,
        onArCoreViewCreated: (arCoreController) async {
          final ByteData textureBytes =
              await rootBundle.load('assets/fox_face_mesh_texture.png');

          arCoreController.loadMesh(
            textureBytes: textureBytes.buffer.asUint8List(),
            skin3DModelFilename: 'fox_face.sfb',
          );
        },
      ),
    );
  }
}
