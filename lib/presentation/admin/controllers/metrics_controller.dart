import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/presentation/admin/services/admin_service.dart';

class MetricsController extends ChangeNotifier {
  final AdminService _service;
  bool loading = false;
  String? error;

  // metrics
  int kahootsTotal = 0;
  List<Map<String, dynamic>> recentKahoots = [];
  // topic breakdown
  Map<String, int> topicsCounts = {};
  List<Map<String, dynamic>> topTopics = [];

  int usersTotal = 0;
  int usersActive = 0;
  int usersBlocked = 0;
  List<Map<String, dynamic>> recentUsers = [];
  // role breakdown
  Map<String, int> usersByRoleCounts = {};
  Map<String, double> usersByRolePercent = {};

  int authorsTotal = 0;
  List<Map<String, dynamic>> recentAuthors = [];

  MetricsController({required AdminService service}) : _service = service;

  Future<void> loadMetrics() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final json = await _service.getMetrics();
      final kah = json['kahoots'] as Map<String, dynamic>? ?? {};
      final us = json['users'] as Map<String, dynamic>? ?? {};
      final au = json['authors'] as Map<String, dynamic>? ?? {};

      kahootsTotal = (kah['total'] is int) ? kah['total'] as int : int.tryParse((kah['total'] ?? '0').toString()) ?? 0;
      recentKahoots = (kah['recent'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  final topics = (kah['topics'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  topicsCounts = (topics['counts'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v is int ? v : int.tryParse(v.toString()) ?? 0)) ?? {};
  topTopics = (topics['top'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

      usersTotal = (us['total'] is int) ? us['total'] as int : int.tryParse((us['total'] ?? '0').toString()) ?? 0;
      usersActive = (us['active'] is int) ? us['active'] as int : int.tryParse((us['active'] ?? '0').toString()) ?? 0;
      usersBlocked = (us['blocked'] is int) ? us['blocked'] as int : int.tryParse((us['blocked'] ?? '0').toString()) ?? 0;
      recentUsers = (us['recent'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  final byRole = (us['byRole'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  usersByRoleCounts = (byRole['counts'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v is int ? v : int.tryParse(v.toString()) ?? 0)) ?? {};
  usersByRolePercent = (byRole['percent'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0)) ?? {};

      authorsTotal = (au['total'] is int) ? au['total'] as int : int.tryParse((au['total'] ?? '0').toString()) ?? 0;
      recentAuthors = (au['recent'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Trigger server-side seed and reload metrics. Returns a summary map on success.
  Future<Map<String, dynamic>?> seedAndReload() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final res = await _service.seed();
      // after seeding, reload metrics
      await loadMetrics();
      return res;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
