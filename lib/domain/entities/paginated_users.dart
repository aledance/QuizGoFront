import 'user.dart';

class PaginatedUsers {
  final List<User> data;
  final int page;
  final int limit;
  final int totalCount;
  final int totalPages;

  PaginatedUsers({required this.data, required this.page, required this.limit, required this.totalCount, required this.totalPages});
}
