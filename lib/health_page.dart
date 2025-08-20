import 'package:flutter/material.dart';
import 'health_service.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final _svc = HealthService();
  bool _loading = false;
  int _steps = 0;
  String? _error;

  Future<void> _initAndFetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ok = await _svc.requestPermissions();
      if (!ok) {
        setState(() => _error = '未获得授权或权限被拒绝');
      } else {
        final steps = await _svc.getTodaySteps();
        setState(() => _steps = steps);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Fit / Health Connect Demo')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Today steps: $_steps'),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _initAndFetch,
                    child: const Text('授权并获取今天步数'),
                  ),
                ],
              ),
      ),
    );
  }
}
