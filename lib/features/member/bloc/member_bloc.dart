import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/models/member_model.dart';
import '../../../data/models/village_model.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository repository;

  // ── Internal cursor pagination state ──────────────────────────────────────
  final List<Member> _allMembers = [];
  int? _nextCursor;   // null = no more pages
  bool _hasMore = true;

  // ── Active filters (kept for "load more" calls) ───────────────────────────
  String? _activeSearch;
  int?    _activeVillageId;
  String? _activeGender;
  String? _activeJobType;

  // ── Debounce: tracks the latest typed query + search generation ─────────────
  // _latestSearchQuery: exit early if user typed more chars before 400ms passed
  // _searchGen: even if two handlers reach the API call, only the LATEST one
  //             is allowed to write to _allMembers (prevents duplicate records)
  String _latestSearchQuery = '';
  int    _searchGen = 0;

  MemberBloc({required this.repository}) : super(MemberInitial()) {
    on<FetchMyMembers>(_onFetchMyMembers);
    on<FetchAllMembers>(_onFetchAllMembers);
    on<SearchQueryChanged>(_onSearchQueryChanged); // concurrent (default)
    on<FetchVillages>(_onFetchVillages);
    on<FetchMemberDetail>(_onFetchMemberDetail);
    on<SaveFcmToken>(_onSaveFcmToken);
    on<DeleteFcmToken>(_onDeleteFcmToken);
  }


  // ── Debounced Search ──────────────────────────────────────────────────────

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<MemberState> emit,
  ) async {
    // Track most-recent query so older concurrent handlers exit early
    _latestSearchQuery = event.query;

    // Immediately emit — clear (✕) button shows/hides without setState
    emit(SearchBarUpdated(event.query));

    // ── Debounce: 400ms wait ──────────────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 400));

    // If a newer keystroke arrived during the wait → bail out (stale)
    if (_latestSearchQuery != event.query) return;

    // ── Generation guard: prevents race-condition duplicates ──────────────
    // Even if two handlers both pass the debounce check, only the one that
    // holds the CURRENT generation is allowed to commit results.
    final myGen = ++_searchGen;

    _activeSearch = event.query.trim().isEmpty ? null : event.query.trim();
    emit(MemberLoading());

    final resp = await repository.allMembers(
      lastId:    0,
      limit:     10,
      search:    _activeSearch,
      villageId: _activeVillageId,
      gender:    _activeGender,
      jobType:   _activeJobType,
    );

    // Another search started while we were awaiting → discard these results
    if (_searchGen != myGen) return;

    if (resp.isSuccess) {
      final payload = resp.data as Map<String, dynamic>;
      final rawList = (payload['members'] as List<dynamic>? ?? []);
      final fetched = rawList
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList();
      _nextCursor = payload['next_cursor'] as int?;
      _hasMore    = payload['has_more'] as bool? ?? false;

      // Clear & addAll in the same sync block — no interleaving possible
      _allMembers
        ..clear()
        ..addAll(fetched);

      emit(AllMembersLoaded(
        members:    List.unmodifiable(_allMembers),
        nextCursor: _nextCursor,
        hasMore:    _hasMore,
      ));
    } else {
      emit(MemberError(message: resp.message));
    }
  }


  // ── My Members ────────────────────────────────────────────────────────────

  Future<void> _onFetchMyMembers(
    FetchMyMembers event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberLoading());
    final resp = await repository.myMembers();
    if (resp.isSuccess) {
      emit(MyMembersLoaded(members: resp.data!));
    } else {
      emit(MemberError(message: resp.message));
    }
  }


  // ── All Members — Cursor Pagination ───────────────────────────────────────

  Future<void> _onFetchAllMembers(
    FetchAllMembers event,
    Emitter<MemberState> emit,
  ) async {
    try {
      final isFirstPage = event.lastId == 0 || event.reset;

      if (isFirstPage) {
        // Reset internal state on fresh load / filter change
        _allMembers.clear();
        _nextCursor = null;
        _hasMore = true;
        _activeSearch    = event.search;
        _activeVillageId = event.villageId;
        _activeGender    = event.gender;
        _activeJobType   = event.jobType;
        emit(MemberLoading());
      } else {
        // Loading next page — don't wipe existing members from UI
        if (!_hasMore) return;
        emit(AllMembersPageLoading(currentMembers: List.unmodifiable(_allMembers)));
      }

      final resp = await repository.allMembers(
        lastId:    isFirstPage ? 0 : (_nextCursor ?? 0),
        limit:     event.limit,
        search:    _activeSearch,
        villageId: _activeVillageId,
        gender:    _activeGender,
        jobType:   _activeJobType,
      );

      if (resp.isSuccess) {
        final payload   = resp.data as Map<String, dynamic>;
        final rawList   = (payload['members'] as List<dynamic>? ?? []);
        final fetched   = rawList.map((e) => Member.fromJson(e as Map<String, dynamic>)).toList();
        _nextCursor = payload['next_cursor'] as int?;
        _hasMore    = payload['has_more'] as bool? ?? false;

        _allMembers.addAll(fetched);

        emit(AllMembersLoaded(
          members:    List.unmodifiable(_allMembers),
          nextCursor: _nextCursor,
          hasMore:    _hasMore,
        ));
      } else {
        emit(MemberError(message: resp.message));
      }
    } catch (e) {
      emit(MemberError(message: e.toString()));
    }
  }

  // ── Villages ──────────────────────────────────────────────────────────────

  Future<void> _onFetchVillages(
    FetchVillages event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberLoading());
    final resp = await repository.getVillages();
    if (resp.isSuccess) {
      emit(VillagesLoaded(villages: resp.data!));
    } else {
      emit(MemberError(message: resp.message));
    }
  }

  // ── Member Detail ─────────────────────────────────────────────────────────

  Future<void> _onFetchMemberDetail(
    FetchMemberDetail event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberDetailLoading());
    final resp = await repository.memberDetail(event.id);
    if (resp.isSuccess) {
      emit(MemberDetailLoaded(member: resp.data!));
    } else {
      emit(MemberError(message: resp.message));
    }
  }

  // ── FCM Token Management ──────────────────────────────────────────────────

  Future<void> _onSaveFcmToken(
    SaveFcmToken event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.saveFcmToken(event.fcmToken, deviceInfo: event.deviceInfo);
      emit(FcmTokenSaved());
    } catch (_) {
      // Silently fail — FCM token save should not block the user flow
    }
  }

  Future<void> _onDeleteFcmToken(
    DeleteFcmToken event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.deleteFcmToken(fcmToken: event.fcmToken);
    } catch (_) {
      // Silently fail
    }
  }
}
