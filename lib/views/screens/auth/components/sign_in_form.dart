import 'package:fitgen/views/screens/main_Dashboard.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../utils/constants.dart';
import '../../../../controllers/auth_controller.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  // Hàm xử lý đăng nhập
  Future<void> _handleSignIn() async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final result = await AuthController.login(_email, _password);
        if (result.containsKey('token')) {
          // Store token securely
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', result['token']);
          _showSuccessMessage(result['user']['role']);
          _navigateToMainApp();
        } else {
          _showErrorMessage('Email hoặc mật khẩu không đúng!');
        }
      } catch (e) {
        _showErrorMessage(e.toString());
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showSuccessMessage(String role) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đăng nhập thành công với vai trò: ${_getRoleText(role)}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'doctor':
        return 'Bác sĩ';
      case 'patient':
        return 'Bệnh nhân';
      case 'admin':
        return 'Quản trị viên';
      default:
        return 'Người dùng';
    }
  }

  void _navigateToMainApp() {
    // Navigate to main dashboard/home screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainDashboard()),
      (route) => false,
    );
  }

  // Demo accounts and related dialog removed

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demo accounts info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'App demo - Nhấn để xem tài khoản test',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                // Demo accounts button removed
              ],
            ),
          ),

          const TextFieldName(text: "Email"),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "doctor@demo.com",
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: "Email là bắt buộc"),
              EmailValidator(errorText: "Vui lòng nhập email hợp lệ!"),
            ]).call,
            onSaved: (email) => _email = email!,
            onChanged: (value) => _email = value,
          ),
          const SizedBox(height: defaultPadding),

          const TextFieldName(text: "Mật khẩu"),
          TextFormField(
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: "123456",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: "Mật khẩu là bắt buộc"),
              MinLengthValidator(
                6,
                errorText: "Mật khẩu phải có ít nhất 6 ký tự",
              ),
            ]).call,
            onSaved: (password) => _password = password!,
            onChanged: (value) => _password = value,
          ),
          const SizedBox(height: defaultPadding / 2),

          // Remember me & Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text("Ghi nhớ đăng nhập"),
                ],
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tính năng đang phát triển')),
                  );
                },
                child: const Text("Quên mật khẩu?"),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  // Quick login button builder removed
}

// Helper widget for field labels
class TextFieldName extends StatelessWidget {
  const TextFieldName({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
