import 'package:company_admin100/data/data_sources/remote_data_source.dart';
import 'package:company_admin100/data/repositories/admin_repository_impl.dart';
import 'package:company_admin100/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/login_bloc.dart';
import '../widgets/admin_widget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dependency injection
    final remoteDataSource = RemoteDataSource();
    final adminRepository = AdminRepositoryImpl(remoteDataSource);
    final loginUseCase = LoginUseCase(adminRepository);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => LoginBloc(loginUseCase),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // Left Side: Form Section
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: LoginForm(),
                  ),
                ),

                // Right Side: Image Section
                // Display only if screen width is larger than 600 pixels
                if (constraints.maxWidth >= 600)
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/login_image2.png', // Your image path here
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController(text: "admin");
  final _passwordController = TextEditingController(text: "12345");

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          print('Login Success: ${state.admin}');
          print('Navigating to home page');

          // Navigate to home on login success
          context.go('/home');
        } else if (state is LoginFailure) {
          print('Login Failure: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AdminWidget.errorText(state.error)),
          );
        } else if (state is LoginLoading) {
          print('Loading...');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return AdminWidget.loadingIndicator();
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Logo
                Image.network(
                  'https://imgs.search.brave.com/YqsWcA-Tq0jMMCad5FV6KWALYUJPDEMGlpvMod9X3Qo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAxLzc1LzY3LzQz/LzM2MF9GXzE3NTY3/NDM2Ml9IUnYza3Nt/dThncTlqMmt0OGpB/U2RFOHR6OTI5UTdk/WC5qcGc', // Your logo path here
                  height: 150, // Adjust the height accordingly
                ),
                SizedBox(height: 20),
                Text(
                  "Sign in to your account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Email address",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Forgot password?"),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print(
                          'Sending Login Request: ${_usernameController.text}, ${_passwordController.text}');
                      context.read<LoginBloc>().login(
                            _usernameController.text,
                            _passwordController.text,
                          );
                    },
                    child: Text("Sign in"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
