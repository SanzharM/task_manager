import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/shake_widget.dart';
import 'package:task_manager/pages/login_page/bloc/login_bloc.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _bloc = LoginBloc();
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  final _companyCodeController = TextEditingController();
  bool isLoading = false;

  bool _sendOnCompleted = true;

  void _tryGetCompanyCode() async {
    _companyCodeController.text = await Application.getCompanyCode() ?? '';
    _sendOnCompleted = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tryGetCompanyCode();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).hasFocus ? () => FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, leading: null),
        body: BlocListener(
          bloc: _bloc,
          listener: (context, state) async {
            isLoading = state is Loading;

            if (state is ErrorState) {
              _shakeKey.currentState?.shake();
              AlertController.showSnackbar(context: context, message: state.error);
            }

            if (state is CodeCompanyVerified) {
              await Application.saveCompanyCode(state.code);
              AppRouter.toLoginPage(context, state.code);
            }

            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'app_name'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightAction,
                    ),
                  ),
                ),
                const EmptyBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'app_slogan'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Application.isDarkMode(context) ? AppColors.defaultGrey.withOpacity(0.5) : AppColors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                const EmptyBox(height: 56),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'enter_company_code'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const EmptyBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ShakeWidget(
                        key: _shakeKey,
                        shakeCount: 3,
                        shakeOffset: 10,
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _companyCodeController,
                          onChanged: (value) => _companyCodeController.text = value,
                          onTap: () => setState(() {}),
                          textCapitalization: TextCapitalization.characters,
                          autoDismissKeyboard: true,
                          onCompleted: (value) =>
                              _sendOnCompleted ? _bloc.verifyCodeCompany(_companyCodeController.text.toUpperCase()) : null,
                          hapticFeedbackTypes: HapticFeedbackTypes.light,
                          useHapticFeedback: true,
                          animationCurve: Curves.easeInOut,
                          animationType: AnimationType.slide,
                          autoFocus: !kIsWeb,
                          enablePinAutofill: false,
                          showCursor: false,
                          pinTheme: PinTheme(
                            activeColor: AppColors.lightAction,
                            selectedColor: AppColors.lightAction.withOpacity(0.2),
                            disabledColor: AppColors.defaultGrey,
                            inactiveColor: AppColors.defaultGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 24.0)),
                AppButton(
                  title: 'next'.tr(),
                  isLoading: isLoading,
                  onTap: () {
                    if (isLoading) return;
                    _bloc.verifyCodeCompany(_companyCodeController.text.toUpperCase());
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 48.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
