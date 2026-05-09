import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/app_logo.dart';
import 'package:salesdocket_mobile/features/auth/view_model/auth_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'AuthRoute')
class AuthScreen extends SalesdocketConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  SalesdocketConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends SalesdocketConsumerState<AuthScreen>
    with UiLoggy {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = ref.watch(passwordVisibleProvider);
    final isLoggingIn = ref.watch(loginLoadingProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appColors.primary,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(),
                    verticalSpacing(6.h),
                    // Email Input Field
                    SalesDocketInputWidget(
                      maxLength: 50,
                      inputType: TextInputType.emailAddress,
                      validator: validateEmail,
                      label: LocaleKeys.lblEmail.tr(),
                      hint: LocaleKeys.lblEmail.tr(),
                      controller: _emailController,
                    ),
                    verticalSpacing(2.h),
                    // Password Input Field
                    SalesDocketInputWidget(
                      maxLength: 15,
                      inputType: TextInputType.visiblePassword,
                      validator: validateEmptyInput,
                      label: LocaleKeys.lblPassword.tr(),
                      hint: LocaleKeys.lblPassword.tr(),
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                      suffix: GestureDetector(
                        onTap: () {
                          final provider = ref.read(
                            passwordVisibleProvider.notifier,
                          );
                          if (isPasswordVisible) {
                            provider.hide();
                          } else {
                            provider.show();
                          }
                        },
                        child: Icon(
                          size: 4.w,
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    verticalSpacing(2.h),
                    // Submit Button
                    SalesDocketButtonWidget(
                      text:
                          isLoggingIn
                              ? LocaleKeys.lblLoggingIn.tr()
                              : LocaleKeys.lblLogIn.tr(),
                      onPressed: _onLoginClicked,
                      isDisabled: isLoggingIn,
                    ),
                    // Forgot Password Link
                    TextButton(
                      onPressed: _onForgetPasswordClicked,
                      child: Text(
                        "${LocaleKeys.lblForgotPassword.tr()}?",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onForgetPasswordClicked() {
    context.router.push(const ForgotPasswordRoute());
  }

  void _onLoginClicked() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      _submitForm();
    } else {
      _formKey.currentState?.reset();
    }
  }

  void _submitForm() async {
    final loadingNotifier = ref.read(loginLoadingProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final request = SignInRequest(username: email, password: password);

    loadingNotifier.setLoading(true);
    await CacheManager.setString(keyToken, request.generateToken);

    ref.read(authViewModelProvider.notifier).signIn(request).then((res) {
      loadingNotifier.setLoading(false);
      res.when(
        success: (data) {
          if (data != null && data.status == '1') {
            _setupProfile(data);
            _navigateToHome();
          } else {
            // Clear cache on unauthorized/invalid credentials
            _clearAuthCache();
            context.showSnackBar(LocaleKeys.msgUnauthorizedUser);
          }
        },
        failure: (error) {
          // Clear cache on login failure (e.g., wrong credentials, changed base URL)
          _clearAuthCache();
          context.showSnackBar(error.message ?? '');
        },
      );
    });
  }

  void _clearAuthCache() {
    CacheManager.remove(keyToken);
    CacheManager.remove(keyProfile);
  }

  void _setupProfile(User data) async {
    CacheManager.setModel(keyProfile, data);
    ref.read(profileProvider.notifier).update((profile) => profile = data);

    // Print FCM token at login
    _registerFcmToken();
  }

  Future<void> _registerFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        loggy.info("========================================");
        loggy.info("FCM TOKEN AT LOGIN:");
        loggy.info(token);
        loggy.info("========================================");
        ref
            .read(authViewModelProvider.notifier)
            .updateAppId(UpdateAppIdRequest(appId: token));
      } else {
        loggy.warning("FCM Token is null at login");
      }
    } catch (e) {
      loggy.error("Failed to get FCM token at login: $e");
    }
  }

  void _navigateToHome() {
    context.router.replace(const HomeRoute());
  }
}
