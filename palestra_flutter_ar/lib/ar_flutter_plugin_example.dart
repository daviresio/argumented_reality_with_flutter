import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArFlutterPluginExample extends StatefulWidget {
  const ArFlutterPluginExample({Key? key}) : super(key: key);

  @override
  State<ArFlutterPluginExample> createState() => _ArFlutterPluginExampleState();
}

class _ArFlutterPluginExampleState extends State<ArFlutterPluginExample> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  final List<ARNode> nodes = [];
  final List<ARAnchor> anchors = [];

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: true,
      handlePans: true,
      handleRotation: true,
    );

    arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onPanStart = onPanStarted;
    this.arObjectManager.onPanChange = onPanChanged;
    this.arObjectManager.onPanEnd = onPanEnded;
    this.arObjectManager.onRotationStart = onRotationStarted;
    this.arObjectManager.onRotationChange = onRotationChanged;
    this.arObjectManager.onRotationEnd = onRotationEnded;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    final index = hitTestResults
        .indexWhere((hitResult) => hitResult.type == ARHitTestResultType.plane);

    if (index == -1) {
      return;
    }

    final hitTestResult = hitTestResults[index];
    final newAnchor =
        ARPlaneAnchor(transformation: hitTestResult.worldTransform);

    final didAnchor = await arAnchorManager.addAnchor(newAnchor);

    if (didAnchor == null || !didAnchor) {
      return;
    }

    anchors.add(newAnchor);

    final newNode = ARNode(
      type: NodeType.webGLB,
      uri:
          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
      scale: vector.Vector3(0.2, 0.2, 0.2),
      position: vector.Vector3.zero(),
      rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
    );

    final didNodeToAnchor =
        await arObjectManager.addNode(newNode, planeAnchor: newAnchor);

    if (didNodeToAnchor!) {
      nodes.add(newNode);
    }
  }

  onPanStarted(String nodeName) {
    debugPrint("Started panning node $nodeName");
  }

  onPanChanged(String nodeName) {
    debugPrint("Continued panning node $nodeName");
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    debugPrint("Ended panning node $nodeName");

    final index = nodes.indexWhere((element) => element.name == nodeName);
    nodes[index].transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    debugPrint("Started rotating node $nodeName");
  }

  onRotationChanged(String nodeName) {
    debugPrint("Continued rotating node $nodeName");
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    debugPrint("Ended rotating node $nodeName");

    final index = nodes.indexWhere((element) => element.name == nodeName);
    if (index != -1) {
      nodes[index].transform = newTransform;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      ),
    );
  }
}
