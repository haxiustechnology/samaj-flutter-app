part of 'member_bloc.dart';

abstract class MemberEvent {}

class FetchMyMembers extends MemberEvent {}

/// Fetch members with cursor-based pagination and optional filters.
/// Pass [reset] = true (or lastId = 0) to start fresh (new search / filter change).
class FetchAllMembers extends MemberEvent {
  final int lastId;       // cursor — 0 means first page
  final int limit;
  final String? search;
  final int? villageId;
  final String? gender;   // 'male' | 'female' | 'other' | null
  final String? jobType;  // 'private' | 'government' | 'none' | null
  final bool? isDoingJob; // true (doing job/business) | false (not doing job) | null
  final String? jobPost;  // specific designation / post
  final bool reset;       // true → clears existing list

  FetchAllMembers({
    this.lastId = 0,
    this.limit = 10,
    this.search,
    this.villageId,
    this.gender,
    this.jobType,
    this.isDoingJob,
    this.jobPost,
    this.reset = false,
  });
}

/// Fired on every keystroke in the search field.
/// The BLoC debounces this for 400 ms before actually fetching.
class SearchQueryChanged extends MemberEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class FetchVillages extends MemberEvent {}

class FetchMemberDetail extends MemberEvent {
  final int id;
  FetchMemberDetail({required this.id});
}

/// Save or update the device FCM token on the server.
class SaveFcmToken extends MemberEvent {
  final String fcmToken;
  final String? deviceInfo;
  SaveFcmToken({required this.fcmToken, this.deviceInfo});
}

/// Delete device FCM token from the server (on logout / opt-out).
class DeleteFcmToken extends MemberEvent {
  final String? fcmToken; // null = delete all tokens for user
  DeleteFcmToken({this.fcmToken});
}