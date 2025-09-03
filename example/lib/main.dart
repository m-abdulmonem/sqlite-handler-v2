import 'package:flutter/material.dart';
import 'demos/encryption_demo.dart';
import 'demos/migrations_demo.dart';
import 'demos/orders_and_types_demo.dart';
import 'demos/query_demo.dart';
import 'demos/relations_demo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('sqlite_handler example'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _DemoTile(title: 'Encryption Demo', runner: runEncryptionDemo),
            _DemoTile(title: 'Query Builder Demo', runner: runQueryDemo),
            _DemoTile(title: 'Relations Demo', runner: runRelationsDemo),
            _DemoTile(
                title: 'Orders & Types Demo',
                runner: () async => runOrdersAndTypesDemo()),
            _DemoTile(
                title: 'Migrations Demo (FFI desktop)',
                runner: runMigrationsDemo),
          ],
        ),
      ),
    );
  }
}

class _DemoTile extends StatefulWidget {
  final String title;
  final Future<String> Function() runner;
  const _DemoTile({required this.title, required this.runner});

  @override
  State<_DemoTile> createState() => _DemoTileState();
}

class _DemoTileState extends State<_DemoTile> {
  String _output = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          try {
                            final result = await widget.runner();
                            setState(() => _output = result);
                          } finally {
                            setState(() => _loading = false);
                          }
                        },
                  child: Text(_loading ? 'Running...' : 'Run'),
                )
              ],
            ),
            const SizedBox(height: 8),
            if (_output.isNotEmpty) Text(_output),
          ],
        ),
      ),
    );
  }
}
