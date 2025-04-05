
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // وظيفة التسجيل
  void _register() async {
    if (!_validateInputs()) return;
    setState(() => _isLoading = true);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    // افتراض وجود API للتسجيل
    var response = await _authService.register(email, password);
    setState(() => _isLoading = false);
    if (response['success']) {
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration successful, please login')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'] ?? 'Registration failed')));
    }
  }

  // التحقق من المدخلات
  bool _validateInputs() {
    if (!Validators.isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid email')));
      return false;
    }
    if (!Validators.isValidPassword(_passwordController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password must be at least 6 characters')));
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                text: 'Register',
                onPressed: _register,
                width: 200,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text('Already have an account? Login', style: TextStyle(color: Colors.yellow)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}