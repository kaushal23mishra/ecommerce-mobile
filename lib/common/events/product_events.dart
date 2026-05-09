import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/features/quotation/view_model/quotation_view_model.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin ProductEvents on UiComponentWidget {
  Future getCompetitionProducts({GetCompetitionProductsRequest? req}) async {
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getCompetitionProducts(req);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onCompetitionProductsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getCompetitionModels({
    int? brandId,
    GetCompetitionProductsRequest? req,
  }) async {
    if (brandId == null) {
      return;
    }

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getCompetitionModels(brandId, req);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onCompetitionModelsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getBrands({
    GetProductsRequest req = const GetProductsRequest(),
  }) async {
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getBrandsName(
          request: req.copyWith(
            // currentOrganizationOnly: "no",
            // returnType: 'brand',
          ),
        );
    if (!isMounted) return;

    result.when(
      success: (data) {
        onBrandsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getBrandModels({
    GetProductsRequest req = const GetProductsRequest(),
  }) async {
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getProductsName(
          request: req.copyWith(
            currentOrganizationOnly: "no",
            returnType: 'product',
          ),
        );
    if (!isMounted) return;

    result.when(
      success: (data) {
        onBrandModelsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getProductPrices({
    int? productId,
    GetProductsRequest req = const GetProductsRequest(),
  }) async {
    if (productId == null) {
      showSnackBar("Get Product Prices: product id can't be null!");
      return;
    }

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getProductPrices(productId, req);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onProductPriceFetched(data?.data?.prices ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future createExchangeProduct({ExchangeProduct? request}) async {
    showLoader();
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .createExchange(req: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onExchangeCreated(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateExchangeProduct({ExchangeProduct? request}) async {
    final exchangeId = request?.id;
    if (exchangeId == null) {
      showSnackBar("Update Exchange Product: exchange id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .updateExchange(exchangeId, req: request, method: "PATCH");
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onExchangeUpdated(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future uploadExchangeDocuments({
    int? exchangeId,
    ExchangeProduct? request,
    String method = "PATCH",
  }) async {
    if (exchangeId == null) {
      showSnackBar("Upload Exchange Documents: exchange id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .updateExchangeMultipart(exchangeId, req: request, method: method);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          Loggy("uploadBookingDocuments").debug("Uploaded Successfully");
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future createQuotation({required CreateQuotationRequest request}) async {
    showLoader();
    final result = await eventRef
        .read(quotationViewModelProvider.notifier)
        .createQuotation(req: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onQuotationCreated(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getProductPricesConfigurable() async {
    showLoader();
    final result =
        await eventRef
            .read(productsViewModelProvider.notifier)
            .getProductPricesConfigurable();
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onProductPricesConfigurableFetched(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future createBroker(Brokerage broker) async {
    eventRef.read(brokerLoadingProvider.notifier).setLoading(true);
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .createBroker(req: broker);
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef.read(brokerLoadingProvider.notifier).setLoading(false);
        onBrokerCreated(data?.data);
      },
      failure: (error) {
        eventRef.read(brokerLoadingProvider.notifier).setLoading(false);
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateBroker({int? brokerId, Brokerage? broker}) async {
    if (brokerId == null) {
      showSnackBar("Update Broker: broker id can't be null!");
      return;
    }

    eventRef.read(brokerLoadingProvider.notifier).setLoading(true);
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .updateBroker(brokerId, req: broker);
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef.read(brokerLoadingProvider.notifier).setLoading(false);
        onBrokerUpdated(data?.data);
      },
      failure: (error) {
        eventRef.read(brokerLoadingProvider.notifier).setLoading(false);
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future deleteBroker({int? brokerId}) async {
    if (brokerId == null) {
      onBrokerDeleted();
      return;
    }

    eventRef.read(brokerLoadingProvider.notifier).setLoading(true);
    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .deleteBroker(brokerId);
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef.read(brokerLoadingProvider.notifier).setLoading(false);
        onBrokerDeleted();
      },
      failure: (error) {
        eventRef.read(brokerLoadingProvider.notifier).setLoading(false);
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getDiscounts({int? variantId}) async {
    if (variantId == null) {
      showSnackBar("Get Discount: variant id can't be null!");
      return;
    }

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getDiscounts(variantId);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onDiscountsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onBrokerCreated(Brokerage? data) {}

  void onBrokerUpdated(Brokerage? data) {}

  void onBrokerDeleted() {}

  void onLeadHistoryFetched(List<LeadHistory> history) {}

  void onCompetitionProductsFetched(List<CompetitionProduct> list) {}

  void onCompetitionModelsFetched(List<CompetitionProduct> list) {}

  void onBrandsFetched(List<Product> list) {}

  void onBrandModelsFetched(List<Product> list) {}

  void onProductPriceFetched(List<Price> prices) {}

  void onProductPricesConfigurableFetched(QuotationConfig? data) {}

  void onExchangeCreated(ExchangeProduct? exchangeProduct) {}

  void onExchangeUpdated(ExchangeProduct? exchangeProduct) {}

  void onQuotationCreated(Quotation? data) {}

  void onDiscountsFetched(List<Discount> list) {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
