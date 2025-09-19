import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fitgen/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/constants.dart';

// ignore: must_be_immutable
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

// ignore: library_private_types_in_public_api
class _SignUpFormState extends State<SignUpForm> {
  String _userName = '', _email = '', _phoneNumber = '';
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void handleSignUp() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();
      try {
        final result = await AuthController.register(
          username: _userName,
          email: _email,
          password: _passwordController.text,
          phone: _phoneNumber,
        );
        // Optionally auto-login after signup
        final prefs = await SharedPreferences.getInstance();
        if (result['token'] != null) {
          await prefs.setString('jwt_token', result['token']);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up successful! Please log in.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldName(text: "Username"),
          TextFormField(
            decoration: const InputDecoration(hintText: "theflutterway"),
            validator: RequiredValidator(
              errorText: "Username is required",
            ).call,
            onSaved: (username) => _userName = username!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Email"),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "test@email.com"),
            validator: EmailValidator(errorText: "Use a valid email!").call,
            onSaved: (email) => _email = email!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Phone"),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "+123487697"),
            validator: RequiredValidator(
              errorText: "Phone number is required",
            ).call,
            onSaved: (phoneNumber) => _phoneNumber = phoneNumber!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Password"),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "******"),
            validator: passwordValidator.call,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Confirm Password"),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "*****"),
            validator: (pass) {
              if (pass == null || pass.isEmpty) {
                return 'Please confirm your password';
              }
              if (pass != _passwordController.text) {
                return 'Password does not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class TextFieldName extends StatelessWidget {
  const TextFieldName({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 3),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
      ),
    );
  }
}
