import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/app_logo.dart';
import 'package:salesdocket_mobile/features/auth/view_model/auth_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'ForgotPasswordRoute')
class ForgotPasswordScreen extends SalesdocketConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  SalesdocketConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends SalesdocketConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App Logo
                    const AppLogo(),
                    verticalSpacing(6.h),

                    // Reset Password Title
                    Text(
                      LocaleKeys.lblResetPassword.tr(),
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: appColors.disabled),
                    ),
                    verticalSpacing(4.h),

                    // Email Input Field
                    SalesDocketInputWidget(
                      maxLength: 50,
                      inputType: TextInputType.emailAddress,
                      validator: validateForgotPasswordEmail,
                      label: LocaleKeys.lblEnterYourRegisteredEmailAddress.tr(),
                      hint: LocaleKeys.lblEnterYourRegisteredEmailAddress.tr(),
                      controller: _emailController,
                    ),
                    verticalSpacing(2.h),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel Button
                        Expanded(
                          child: SalesDocketButtonWidget(
                            text: LocaleKeys.lblCancel.tr(),
                            onPressed: _onCancelClicked,
                            isOutlined: true,
                          ),
                        ),
                        horizontalSpacing(2.w),

                        // Submit Button
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final isSubmitting = ref.watch(
                                forgotPasswordLoadingProvider,
                              );
                              return SalesDocketButtonWidget(
                                text:
                                    isSubmitting
                                        ? LocaleKeys.lblSubmittingIn.tr()
                                        : LocaleKeys.btnSubmit.tr(),
                                isDisabled: isSubmitting,
                                onPressed: _onSubmitClicked,
                              );
                            },
                          ),
                        ),
                      ],
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

  void _onCancelClicked() {
    context.router.back();
  }

  void _onSubmitClicked() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      _submitForm();
    }
  }

  void _submitForm() {
    final loadingNotifier = ref.read(forgotPasswordLoadingProvider.notifier);
    final email = _emailController.text.trim();

    loadingNotifier.setLoading(true);
    ref.read(authViewModelProvider.notifier).forgotPassword(email: email).then((
      res,
    ) {
      loadingNotifier.setLoading(false);
      res.when(
        success: (response) {
          final responseData = response.data;
          final status = responseData['status'] ?? 1;
          final message =
              responseData['error'] ??
              LocaleKeys.reset_password_success_message.tr();

          if (status == 0) {
            context.showSnackBar(message, type: SnackBarType.error);
          } else {
            context.showSnackBar(message, type: SnackBarType.success);
          }
          context.router.back();
        },
        failure: (error) {
          final errorData = error;
          final errorMessage =
              (errorData is Map<String, dynamic>)
                  ? errorData.message ?? LocaleKeys.defaultErrorMessage.tr()
                  : LocaleKeys.defaultErrorMessage.tr();

          context.showSnackBar(errorMessage, type: SnackBarType.error);
        },
      );
    });
  }
}
