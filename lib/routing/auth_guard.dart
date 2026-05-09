import 'package:auto_route/auto_route.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (CacheManager.getString(keyToken).isEmpty) {
      router.replaceAll([const AuthRoute()]);
    } else {
      resolver.next();
    }
  }
}
