import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'locality_view_model.g.dart';

@riverpod
class LocalityViewModel extends _$LocalityViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<List<City>?>> fetchLocalityCities(LocationSearchRequest req) {
    return ref.read(localityRepositoryProvider).searchCities(req: req);
  }

  Future<Result<ApiResponse<List<Location>?>>> fetchLocalityLocations(
    int cityId,
    LocationSearchRequest req,
  ) {
    return ref
        .read(localityRepositoryProvider)
        .searchLocations(cityId: cityId, req: req);
  }

  Future<Result<CreateAddressResponse?>> createAddress(
    int localityId,
    LeadAddress? req,
  ) {
    return ref
        .read(localityRepositoryProvider)
        .createAddress(localityId: localityId, req: req);
  }
}

final citiesProvider = StateProvider<List<City>>((ref) => []);
final locationsProvider = StateProvider<List<Location>>((ref) => []);

final localityProvider = StateProvider<LeadLocality?>((ref) => null);
final addressProvider = StateProvider<LeadAddress?>((ref) => null);
