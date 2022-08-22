import 'package:flutter/material.dart';
import 'package:palestra_flutter_ar/ar_flutter_plugin_example.dart';
import 'package:palestra_flutter_ar/arcore_flutter_plugin_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final examples = [
      Example(
        'Ar Flutter Plugin Example',
        'Example with gestures',
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ArFlutterPluginExample())),
      ),
      Example(
        'ArCore Flutter Plugin Example',
        'Example with argumented face',
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ArCoreFlutterPluginExample())),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView(
          children:
              examples.map((example) => ExampleCard(example: example)).toList(),
        ),
      ),
    );
  }
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({Key? key, required this.example}) : super(key: key);
  final Example example;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          example.onTap();
        },
        child: ListTile(
          title: Text(example.name),
          subtitle: Text(example.description),
        ),
      ),
    );
  }
}

class Example {
  const Example(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}
