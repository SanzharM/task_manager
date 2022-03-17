import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:task_manager/pages/login_page/bloc/login_bloc.dart';
import 'package:task_manager/pages/login_page/verify_code_page.dart';
import 'package:task_manager/pages/navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = LoginBloc();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final inputFormatter = MaskTextInputFormatter(mask: Utils.phoneMask);

  String _phone = '';
  bool isLoading = false;

  void _toMainPage() {
    final route = CupertinoPageRoute(builder: (context) => NavigationBar());
    Navigator.of(context).pushReplacement(route);
  }

  void _tryGetAuth() {
    if (_phone.isNotEmpty) _bloc.add(GetAuth(phone: _phone));
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).hasFocus ? FocusScope.of(context).unfocus() : null,
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: BlocListener<LoginBloc, LoginState>(
              bloc: _bloc,
              listener: (context, state) {
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
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VerifyCodePage(onVerify: (code) => _bloc.verifySMS(state.phone, code)),
                  ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const EmptyBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'login'.tr(),
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const EmptyBox(height: 12),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'please_authorize'.tr(),
                          style: const TextStyle(fontSize: 14),
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: AppButton(
                          color: AppColors.yellow,
                          title: 'sign_in/sign_up'.tr(),
                          onTap: _tryGetAuth,
                        ),
                      ),
                      const EmptyBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
