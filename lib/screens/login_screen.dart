import 'package:flutter/material.dart';
import 'package:productos_app/providers/provider_form.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'package:productos_app/services/notifications_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
              child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 10),
                ChangeNotifierProvider(
                  create: (context) => ProviderForm(),
                  child: const _LoginForm(),
                )
              ]),
            ),
            const SizedBox(height: 50),
            TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                child: const Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(height: 50),
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginForm = Provider.of<ProviderForm>(context);
    return SizedBox(
      child: Form(
          key: _loginForm.globalKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'exampl@mail.com',
                    labelText: 'Email',
                    icon: Icons.alternate_email_sharp),
                validator: (value) {
                  _loginForm.email = value ?? '';
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Formato de email no válido';
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '*****',
                    labelText: 'Password',
                    icon: Icons.password),
                validator: (value) {
                  _loginForm.password = value ?? '';
                  if (value != null && value.length >= 6) return null;
                  return 'Debe ser mayor a 6 caracteres';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                onPressed: _loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        !_loginForm.isValidForm()
                            ? null
                            : _loginForm.isLoading = true;
                        final String? errorMesage = await authService.authUser(
                            _loginForm.email, _loginForm.password);
                        if (errorMesage == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          NotificationsService.showSnackBar(
                              'Credenciales inválidas');
                          _loginForm.isLoading = false;
                        }
                      },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    _loginForm.isLoading ? 'Espere' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
