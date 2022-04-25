import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:task_manager/pages/login_page/bloc/login_bloc.dart';
import 'package:task_manager/pages/navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  final String? companyCode;
  const LoginPage({Key? key, this.companyCode}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _bloc = LoginBloc();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final inputFormatter = MaskTextInputFormatter(mask: Utils.phoneMask);

  late AnimationController _animationControllerPhone;
  late Animation<double> _animationPhone;
  late AnimationController _animationControllerSms;
  late Animation<double> _animationSms;

  late TextEditingController _smsController;

  String _phone = '';
  String _code = '';
  bool isLoading = false;

  void _toMainPage() async {
    await Application.setPin(null);
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => NavigationBar()));
  }

  void _tryGetAuth() {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
    if (_phone.isNotEmpty) _bloc.add(GetAuth(phone: _phone, companyCode: widget.companyCode));
  }

  @override
  void initState() {
    super.initState();
    _animationControllerPhone = AnimationController(vsync: this, duration: const Duration(milliseconds: 250), value: 1.0);
    _animationPhone = CurvedAnimation(parent: _animationControllerPhone, curve: Curves.easeInOut);
    _animationControllerSms = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _animationSms = CurvedAnimation(parent: _animationControllerSms, curve: Curves.easeInOut);
    _smsController = TextEditingController(text: _code);
  }

  @override
  void dispose() {
    _bloc.close();
    _animationControllerPhone.dispose();
    _animationControllerSms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).hasFocus ? FocusScope.of(context).unfocus() : null,
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(CupertinoIcons.xmark),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginBloc, LoginState>(
            bloc: _bloc,
            listener: (context, state) {
              isLoading = state is Loading;
              if (state is AuthVerifySuccess) _toMainPage();
              if (state is ErrorState) {
                _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.fixed,
                    duration: const Duration(milliseconds: 1400),
                    content: Container(
                      color: AppColors.darkGrey,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(state.error),
                    ),
                  ),
                );
              }
              if (state is PhoneAuthSuccess) {
                _phone = state.phone;
                _animationControllerPhone.reverse();
                _animationControllerSms.forward();
              }
              setState(() {});
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'please_authorize'.tr(),
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const EmptyBox(height: 24),
                  AppTextField(
                    label: 'phone_number'.tr(),
                    initialText: '+7',
                    text: inputFormatter.getMaskedText(),
                    onTap: () => setState(() {}),
                    onChanged: (value) {
                      _phone = Utils.numbersOnly(inputFormatter.getMaskedText()) ?? '';
                    },
                    onSubmit: (value) => _tryGetAuth(),
                    inputFormatters: [inputFormatter],
                    keyboardType: TextInputType.number,
                  ),
                  const EmptyBox(height: 24),
                  SizeTransition(
                    sizeFactor: _animationPhone,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AppButton(
                        color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
                        title: 'sign_in/sign_up'.tr(),
                        onTap: _tryGetAuth,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _animationSms,
                    child: Column(
                      children: [
                        const EmptyBox(height: 56),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 200),
                          child: PinCodeTextField(
                            controller: _smsController,
                            autoDisposeControllers: true,
                            mainAxisAlignment: MainAxisAlignment.center,
                            appContext: context,
                            length: 4,
                            keyboardType: TextInputType.number,
                            hapticFeedbackTypes: HapticFeedbackTypes.vibrate,
                            autoDismissKeyboard: true,
                            animationCurve: Curves.easeInOut,
                            animationDuration: const Duration(milliseconds: 250),
                            animationType: AnimationType.slide,
                            autoFocus: false,
                            enablePinAutofill: true,
                            showCursor: false,
                            pinTheme: PinTheme(
                              activeColor: AppColors.success,
                              selectedColor: AppColors.success,
                              disabledColor: AppColors.defaultGrey,
                              inactiveColor: AppColors.defaultGrey,
                              fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            onChanged: (value) => _code = value,
                            onTap: () => setState(() {}),
                            onCompleted: (value) {
                              if (_code.length == 4) _bloc.verifySMS(_phone, _code, widget.companyCode!);
                            },
                          ),
                        ),
                        AppButton(
                          color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
                          isLoading: isLoading,
                          title: 'send'.tr(),
                          onTap: () {
                            if (_code.length == 4) _bloc.verifySMS(_phone, _code, widget.companyCode!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
