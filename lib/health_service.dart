// // import 'package:health/health.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // class HealthService {
// //   final Health _health = Health();
// //
// //   Future<bool> requestPermissions({bool includeSensors = false}) async {
// //     await _health.configure(); // v11+ 先配置
// //
// //     final ar = await Permission.activityRecognition.request();
// //     if (!ar.isGranted) return false;
// //     if (includeSensors) {
// //       await Permission.sensors.request();
// //     }
// //
// //     // 这里只读步数
// //     final types = <HealthDataType>[HealthDataType.STEPS];
// //
// //     // v11+ 这里 permissions 可不传（默认按 READ 处理）
// //     // 如果你需要精确控制，再传一个与 types 等长的权限列表
// //     final ok = await _health.requestAuthorization(types);
// //     return ok;
// //   }
// //
// //   Future<int> getTodaySteps() async {
// //     final now = DateTime.now();
// //     final start = DateTime(now.year, now.month, now.day);
// //
// //     // ✅ 使用命名参数，types 必填
// //     final data = await _health.getHealthDataFromTypes(
// //       types: const [HealthDataType.STEPS],
// //       startTime: start,
// //       endTime: now,
// //       // recordingMethodsToFilter: const [], // 可选
// //     );
// //
// //     var sum = 0;
// //     for (final d in data) {
// //       if (d.type == HealthDataType.STEPS) {
// //         sum += (d.value as num).toInt();
// //       }
// //     }
// //     return sum;
// //   }
// // }
// import 'package:health/health.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class HealthService {
//   final Health _health = Health();
//
//   Future<bool> requestPermissions() async {
//     // 1) Health 初始化
//     await _health.configure();
//
//     // 2) 系统运行时权限（Physical activity）
//     final ar = await Permission.activityRecognition.request();
//     if (!ar.isGranted) {
//       // 可选：打开系统设置让用户手动授予
//       await openAppSettings();
//       return false;
//     }
//
//     // 3) 只请求步数（确保和清单匹配）
//     const types = [HealthDataType.STEPS];
//
//     // 4) 申请 Health Connect 权限
//     final ok = await _health.requestAuthorization(types);
//
//     // 5) 立刻二次核对（很多“看起来允许了但其实没勾上”的场景靠它能查出来）
//     final has = await _health.hasPermissions(types);
//     final granted = (has ?? false) && ok;
//
//     // 调试日志
//     // ignore: avoid_print
//     print('DEBUG HC request ok=$ok, has=${has ?? false}');
//
//     return granted;
//   }
//
//   Future<int> getTodaySteps() async {
//     final now = DateTime.now();
//     final start = DateTime(now.year, now.month, now.day);
//     final data = await _health.getHealthDataFromTypes(
//       types: const [HealthDataType.STEPS],
//       startTime: start,
//       endTime: now,
//     );
//     var sum = 0;
//     for (final d in data) {
//       if (d.type == HealthDataType.STEPS) sum += (d.value as num).toInt();
//     }
//     return sum;
//   }
// }

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health _health = Health();

  Future<bool> requestPermissions() async {
    // 打印可用性（可选调试）
    try {
      final status = await _health.getHealthConnectSdkStatus();
      // ignore: avoid_print
      print('DEBUG HC status=$status'); // e.g. AVAILABLE
    } catch (_) {}

    // 1) 必须先 configure
    await _health.configure();

    // 2) 系统运行时权限（Physical activity）
    final ar = await Permission.activityRecognition.request();
    if (!ar.isGranted) {
      // ignore: avoid_print
      print('DEBUG HC runtime ACTIVITY_RECOGNITION denied');
      await openAppSettings(); // 打开系统设置（不是 HC 设置）
      return false;
    }

    // 3) 只请求“步数”，要跟 Manifest 完全匹配
    const types = [HealthDataType.STEPS];

    final ok = await _health.requestAuthorization(types);
    final has = await _health.hasPermissions(types);
    // ignore: avoid_print
    print('DEBUG HC request ok=$ok, has=${has ?? false}');

    return ok && (has ?? false);
  }

  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final data = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.STEPS],
      startTime: start,
      endTime: now,
    );
    var sum = 0;
    for (final d in data) {
      if (d.type == HealthDataType.STEPS) sum += (d.value as num).toInt();
    }
    return sum;
  }
}


