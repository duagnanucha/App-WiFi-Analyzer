import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/permission_provider.dart';
import '../../features/permission/permission_screen.dart';

class PermissionGate extends StatefulWidget {
  final Widget child;

  const PermissionGate({super.key, required this.child});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionProvider>().checkPermission();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check permissions when app comes back from settings
      context.read<PermissionProvider>().checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionState = context.watch<PermissionProvider>().state;

    switch (permissionState) {
      case PermissionState.granted:
        return widget.child;
      case PermissionState.unknown:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case PermissionState.denied:
      case PermissionState.permanentlyDenied:
        return const PermissionScreen();
    }
  }
}
