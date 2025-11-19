import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/presentation/admin/services/admin_service.dart';

class UsersController extends ChangeNotifier {
  final AdminService _service;
  List<User> users = [];
  bool loading = false;
  int page = 1;
  int limit = 20;
  int totalPages = 1;
  int totalCount = 0;
  String? search;
  String? roleFilter;
  String? statusFilter;
  String? orderBy;
  String? order;
  String? error;

  UsersController({required AdminService service}) : _service = service;

  void setSearch(String? s) {
    search = s?.trim().isEmpty == true ? null : s;
    page = 1;
  }

  void setRoleFilter(String? role) {
    roleFilter = role?.trim().isEmpty == true ? null : role;
    page = 1;
  }

  void setStatusFilter(String? status) {
    statusFilter = status?.trim().isEmpty == true ? null : status;
    page = 1;
  }

  void setOrder(String? o) {
    order = o?.trim().isEmpty == true ? null : o;
    page = 1;
  }

  void setOrderBy(String? by) {
    orderBy = by?.trim().isEmpty == true ? null : by;
    page = 1;
  }

  void setLimit(int l) {
    limit = l;
    page = 1;
  }

  void nextPage() {
    page += 1;
  }

  void prevPage() {
    if (page > 1) page -= 1;
  }

  Future<void> updateUser(String id, User u) async {
    try {
      await _service.updateUser(id, u);
      await loadUsers();
      error = null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    loading = true;
    notifyListeners();
    try {
  final pageResult = await _service.getUsers(page: page, limit: limit, search: search, role: roleFilter, orderBy: orderBy, order: order, status: statusFilter);
      users = pageResult.data;
      totalPages = pageResult.totalPages;
      totalCount = pageResult.totalCount;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(User u) async {
    // For MVP we call the remote and reload
    try {
      await _service.createUser(u);
      await loadUsers();
      error = null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeUser(String id) async {
    try {
      await _service.deleteUser(id);
      users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleActive(String id) async {
    final idx = users.indexWhere((u) => u.id == id);
    if (idx == -1) return;
    final old = users[idx].active;
    users[idx].active = !old;
    notifyListeners();
    try {
  // Use PATCH to change only the canonical 'active' flag instead of full PUT
      await _service.patchUser(id, {'active': users[idx].active});
    } catch (e) {
      // revert
      users[idx].active = old;
      error = e.toString();
      notifyListeners();
    }
  }

  /// Block/unblock user explicitly using PATCH; optimistic update performed by caller patterns
  Future<void> blockUser(String id, {required bool block}) async {
    final idx = users.indexWhere((u) => u.id == id);
    if (idx == -1) return;
    final oldActive = users[idx].active;
  users[idx].active = !block;
    notifyListeners();
    try {
      await _service.patchUser(id, {'blocked': block});
    } catch (e) {
      // revert
      users[idx].active = oldActive;
      error = e.toString();
      notifyListeners();
    }
  }
}
