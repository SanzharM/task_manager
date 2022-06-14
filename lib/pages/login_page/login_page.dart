import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/shake_widget.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:task_manager/pages/authorization/authorization_controller.dart';
import 'package:task_manager/pages/login_page/bloc/login_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/pages/pin_page/pin_page.dart';
import 'package:task_manager/pages/voice_authentication/bloc/voice_authentication_bloc.dart' as voice;

class LoginPage extends StatefulWidget {
  final String? companyCode;
  const LoginPage({Key? key, this.companyCode}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _voiceBloc = voice.VoiceAuthenticationBloc();
  final _bloc = LoginBloc();
  final _shakeKey = GlobalKey<ShakeWidgetState>();
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
  bool isVoiceLoading = false;

  void _toPinPage() async {
    await Application.setPin(null);
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => PinPage(shouldSetupPin: true),
    ));
  }

  void _tryGetAuth() {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
    if (_phone.isNotEmpty && !isLoading) _voiceBloc.hasRecordedVoice(phone: _phone);
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
              onPressed: () async {
                await Application.clearStorage();
                Navigator.of(context).pop();
              },
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: MultiBlocListener(
            listeners: [
              BlocListener<LoginBloc, LoginState>(
                bloc: _bloc,
                listener: (context, state) {
                  isLoading = state is Loading;
                  if (state is AuthVerifySuccess) _toPinPage();
                  if (state is ErrorState) {
                    AlertController.showResultDialog(context: context, message: state.error, isSuccess: null);
                  }
                  if (state is WrongSMS) {
                    _shakeKey.currentState?.shake();
                  }
                  if (state is PhoneAuthSuccess) {
                    _phone = state.phone;
                    _animationControllerPhone.reverse();
                    _animationControllerSms.forward();
                  }
                  setState(() {});
                },
              ),
              BlocListener(
                bloc: _voiceBloc,
                listener: (context, state) async {
                  isVoiceLoading = state is voice.Loading;
                  if (state is voice.ErrorState) {
                    AlertController.showResultDialog(context: context, message: state.error, isSuccess: null);
                  }
                  if (state is voice.RecordedVoiceChecked) {
                    if (state.hasVoice) {
                      await Application.setPhone(_phone);
                      await _toAuthController();
                      return;
                    }
                    if (_phone.isNotEmpty && (widget.companyCode?.isNotEmpty ?? false)) {
                      _bloc.getAuth(_phone, widget.companyCode!);
                    }
                  }
                  setState(() {});
                },
              ),
            ],
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
                        title: 'next'.tr(),
                        onTap: _tryGetAuth,
                        isLoading: isLoading || isVoiceLoading,
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _animationSms,
                    child: Column(
                      children: [
                        const EmptyBox(height: 56),
                        ShakeWidget(
                          key: _shakeKey,
                          shakeCount: 3,
                          shakeOffset: 10,
                          child: ConstrainedBox(
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
                                activeColor: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
                                selectedColor: Application.isDarkMode(context)
                                    ? AppColors.darkAction.withOpacity(0.2)
                                    : AppColors.lightAction.withOpacity(0.2),
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

  Future<void> _toAuthController() async {
    // await Application.setUseVoiceAuth(true);
    await Application.setUsePinCode(true);

    final bool shouldSetupPin = await Application.getPin() == null;
    // final bool hasVoice = (await ApiClient.checkRecordedVoice(_phone)).success == true;

    await Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => AuthController(
        authOrder: const [AuthType.pin],
        shouldSetupPin: shouldSetupPin,
        // shouldSetupVoice: !hasVoice,
      ),
    ));
  }
}
