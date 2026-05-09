import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/providers/text_editing_controller_notifier.dart';

part 'products_view_model.g.dart';

@riverpod
class ProductsViewModel extends _$ProductsViewModel {
  @override
  FutureOr<void> build() {}

  Future<Result<BrandResponse?>> getBrandsName({GetProductsRequest? request}) {
    return ref.read(productRepositoryProvider).getBrands(request: request);
  }

  Future<Result<ProductsResponse?>> getProductsName({
    GetProductsRequest? request,
  }) {
    return ref.read(productRepositoryProvider).getProducts(request: request);
  }

  Future<Result<ApiResponse<Product?>>> getProduct(int variantId) {
    return ref.read(productRepositoryProvider).getProduct(productId: variantId);
  }

  Future<Result<ApiResponse<List<CompetitionProduct>?>?>>
  getCompetitionProducts(GetCompetitionProductsRequest? req) {
    return ref
        .read(productRepositoryProvider)
        .getCompetitionProducts(request: req);
  }

  Future<Result<ApiResponse<List<CompetitionProduct>?>?>> getCompetitionModels(
    int brandId,
    GetCompetitionProductsRequest? req,
  ) {
    return ref
        .read(productRepositoryProvider)
        .getCompetitionModels(brandId: brandId, request: req);
  }

  Future<Result<ApiResponse<ProductPrice?>?>> getProductPrices(
    int productId,
    GetProductsRequest? req,
  ) {
    return ref
        .read(productRepositoryProvider)
        .getProductPrices(productId: productId, request: req);
  }

  Future<Result<ApiResponse<QuotationConfig?>?>>
  getProductPricesConfigurable() {
    return ref.read(productRepositoryProvider).getProductPricesConfigurable();
  }

  Future<Result<ApiResponse<ExchangeProduct?>?>> createExchange({
    ExchangeProduct? req,
  }) {
    return ref.read(productRepositoryProvider).createExchange(request: req);
  }

  Future<Result<ApiResponse<ExchangeProduct?>?>> updateExchange(
    int exchangeId, {
    ExchangeProduct? req,
    String? method,
  }) {
    return ref
        .read(productRepositoryProvider)
        .updateExchange(exchangeId: exchangeId, request: req, method: method);
  }

  Future<Result<ApiResponse<ExchangeProduct?>?>> updateExchangeMultipart(
    int exchangeId, {
    ExchangeProduct? req,
    String? method,
  }) {
    return ref
        .read(productRepositoryProvider)
        .updateExchangeMultipart(
          exchangeId: exchangeId,
          request: req,
          method: method,
        );
  }

  Future<Result<ApiResponse<Brokerage?>?>> createBroker({Brokerage? req}) {
    return ref.read(productRepositoryProvider).createBroker(request: req);
  }

  Future<Result<ApiResponse<Brokerage?>?>> updateBroker(
    int brokerId, {
    Brokerage? req,
  }) {
    return ref
        .read(productRepositoryProvider)
        .updateBroker(brokerId: brokerId, request: req);
  }

  Future<Result> deleteBroker(int brokerId) {
    return ref.read(productRepositoryProvider).deleteBroker(brokerId: brokerId);
  }

  Future<Result<ApiResponse<List<Discount>?>?>> getDiscounts(int variantId) {
    return ref.read(productRepositoryProvider).getDiscounts(variantId);
  }
}

final productProvider = StateProvider<Product?>((ref) => null);
final engineTypesProvider = StateProvider<List<Product>>((ref) => []);
final modelsProvider = StateProvider<List<Product>>((ref) => []);
final variantsProvider = StateProvider<List<Product>>((ref) => []);
final competitionProductsProvider = StateProvider<List<CompetitionProduct>>(
  (ref) => [],
);
final competitionModelsProvider = StateProvider<List<CompetitionProduct>>(
  (ref) => [],
);
final brandsProvider = StateProvider<List<Product>>((ref) => []);
final brandModelsProvider = StateProvider<List<Product>>((ref) => []);

final offerPricesProvider = StateProvider<List<Price>>((ref) => []);
final offerDiscountTextFieldControllerProvider = StateNotifierProvider<
  TextFieldControllerNotifier,
  List<TextEditingController>
>((ref) => TextFieldControllerNotifier());
final newOfferPricesProvider = StateProvider<List<Price>>((ref) => []);
final quotationConfigProvider = StateProvider<QuotationConfig?>((ref) => null);
