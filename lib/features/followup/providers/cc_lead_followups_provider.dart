import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'cc_lead_followups_provider.g.dart';

/// Provider for fetching CC lead followup history
/// Returns the 4 latest followups for the given CC lead ID
/// (1 current + 3 past followups to display)
@riverpod
class CCLeadFollowups extends _$CCLeadFollowups {
  @override
  FutureOr<List<CCLeadFollowup>> build(int ccLeadId) async {
    return _fetchFollowups(ccLeadId);
  }

  /// Fetch CC lead followup data from the repository
  Future<List<CCLeadFollowup>> _fetchFollowups(int ccLeadId) async {
    final repository = ref.read(ccLeadRepositoryProvider);
    final useCase = GetCCLeadFollowupsUseCase(repository);

    final result = await useCase(ccLeadId);

    return result.when(
      success: (data) {
        final ccLead = data?.data?.firstOrNull;
        if (ccLead == null || ccLead.followups == null) {
          return [];
        }

        // Return the 4 latest followups (1 current + 3 past to display)
        // The followups are already sorted by ID descending from the API
        return ccLead.followups!.take(4).toList();
      },
      failure: (error) {
        // Log error and return empty list
        return [];
      },
    );
  }

  /// Refresh the followup data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
