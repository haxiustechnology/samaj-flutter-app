part of 'member_bloc.dart';

abstract class MemberState {}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MyMembersLoaded extends MemberState {
  final List<Member> members;
  MyMembersLoaded({required this.members});
}

/// Loading the NEXT page (previous members are still valid).
class AllMembersPageLoading extends MemberState {
  final List<Member> currentMembers;
  AllMembersPageLoading({required this.currentMembers});
}

class AllMembersLoaded extends MemberState {
  final List<Member> members;
  final int? nextCursor;   // null = no more pages
  final bool hasMore;

  AllMembersLoaded({
    required this.members,
    required this.nextCursor,
    required this.hasMore,
  });
}

class VillagesLoaded extends MemberState {
  final List<Village> villages;
  VillagesLoaded({required this.villages});
}

class MemberDetailLoading extends MemberState {}

class MemberDetailLoaded extends MemberState {
  final Member member;
  MemberDetailLoaded({required this.member});
}

class FcmTokenSaved extends MemberState {}

class MemberError extends MemberState {
  final String message;
  MemberError({required this.message});
}
