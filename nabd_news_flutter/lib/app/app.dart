import 'package:flutter/material.dart';

import '../screens/shell_screen.dart';
import 'app_state.dart';
import 'theme.dart';

class NabdApp extends StatefulWidget {
  const NabdApp({super.key});

  @override
  State<NabdApp> createState() => _NabdAppState();
}

class _NabdAppState extends State<NabdApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState.seeded();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'نبض نيوز',
        debugShowCheckedModeBanner: false,
        theme: buildNabdTheme(),
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: NabdShell(),
        ),
      ),
    );
  }
}
