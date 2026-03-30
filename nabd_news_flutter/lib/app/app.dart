import 'package:flutter/material.dart';

import '../screens/shell_screen.dart';
import 'app_state.dart';
import 'theme.dart';

class NabdApp extends StatefulWidget {
  const NabdApp({super.key, this.appState, this.bootstrapOnStart = true});

  final AppState? appState;
  final bool bootstrapOnStart;

  @override
  State<NabdApp> createState() => _NabdAppState();
}

class _NabdAppState extends State<NabdApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = widget.appState ?? AppState();
    if (widget.bootstrapOnStart && widget.appState == null) {
      _appState.bootstrap();
    }
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
