import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/widgets/empty_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _login = '';
  String _psswd = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).hasFocus
          ? FocusScope.of(context).unfocus()
          : null,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: constraints,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EmptyBox(height: 20),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Логин',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                        ),
                        EmptyBox(height: 12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Авторизуйтесь и пользуйтесь приложением',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        EmptyBox(height: 24),
                        TextFormField(
                          controller: TextEditingController(text: _login),
                          onTap: () => setState(() {}),
                          onChanged: (value) => setState(() => _login = value),
                          decoration: InputDecoration(labelText: 'Логин'),
                        ),
                        EmptyBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(text: _psswd),
                          onTap: () => setState(() {}),
                          onChanged: (value) => setState(() => _psswd = value),
                          decoration: InputDecoration(labelText: 'Пароль'),
                        ),
                        EmptyBox(height: 24),
                        Container(
                          width: constraints.maxWidth,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text('Войти'),
                            onPressed: () => print('$_login $_psswd'),
                            color: AppColors.grey,
                          ),
                        ),
                        EmptyBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
