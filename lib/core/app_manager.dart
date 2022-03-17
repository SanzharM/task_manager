import 'package:flutter/material.dart';

class AppManager extends StatefulWidget {
  final Widget child;
  const AppManager({Key? key, required this.child}) : super(key: key);

  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('State is $state');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
