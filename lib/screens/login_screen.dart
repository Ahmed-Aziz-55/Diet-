import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';
import 'forget_password.dart';
import 'signup_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State Variables
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _errorMessage = '';

  // Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Social Media Colors
  final Color _facebookColor = Color(0xFF3b5998);
  final Color _googleColor = Color(0xFFDB4437);
  final Color _appleColor = Colors.black;

  // Check if fields are valid
  bool get _isValid {
    return _emailController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.isNotEmpty;
  }

  // Login Function
  Future<void> _loginWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Clear any previous focus
      FocusScope.of(context).unfocus();

      // Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Success - Navigate to Dashboard
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userId: userCredential.user!.uid),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Try again later';
          break;
        default:
          errorMessage = 'Login failed. Please try again';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google Login (Placeholder - You'll need to implement Firebase Google Auth)
  Future<void> _loginWithGoogle() async {
    // Implement Google Sign In
    // You'll need to add firebase_auth and google_sign_in packages
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Google login coming soon!')),
    // );
  }

  // Facebook Login (Placeholder)
  Future<void> _loginWithFacebook() async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Facebook login coming soon!')),
    // );
  }

  // Apple Login (Placeholder)
  Future<void> _loginWithApple() async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Apple login coming soon!')),
    // );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xff1a1a1a),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  // Header Section
                  _buildHeader(),

                  // Form Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          _buildEmailField(),
                          SizedBox(height: 20),

                          // Password Field
                          _buildPasswordField(),
                          SizedBox(height: 10),

                          // Forgot Password & Error Message
                          _buildForgotPasswordAndError(),
                          SizedBox(height: 30),

                          // Login Button
                          _buildLoginButton(),
                          SizedBox(height: 30),

                          // OR Divider
                          _buildOrDivider(),
                          SizedBox(height: 30),

                          // Social Login Buttons
                          _buildSocialLoginButtons(),
                          SizedBox(height: 40),

                          // Sign Up Link
                          _buildSignUpLink(),
                          SizedBox(height: 40),
                        ],
                      ),
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

  // Header with Logo
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 30),
      child: Column(
        children: [
          // Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.restaurant_menu,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),

          // App Name
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Log in to continue your fitness journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Email Field
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'you@example.com',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.email_outlined, color: Colors.orange),
              filled: true,
              fillColor: Color(0xff2d2d2d),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              errorStyle: TextStyle(color: Colors.red),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // Password Field
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.orange),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.orange,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              filled: true,
              fillColor: Color(0xff2d2d2d),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              errorStyle: TextStyle(color: Colors.red),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // Forgot Password & Error Message
  Widget _buildForgotPasswordAndError() {
    return Column(
      children: [
        // Error Message
        if (_errorMessage.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (_errorMessage.isNotEmpty) SizedBox(height: 10),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Login Button
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading || !_isValid ? null : _loginWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: Colors.orange.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          'Log In',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // OR Divider
  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white24,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white24,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // Social Login Buttons
  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        // Google Button
        _buildSocialButton(
          icon: Icons.g_translate,
          label: 'Continue with Google',
          color: _googleColor,
          textColor: Colors.white,
          onPressed: _loginWithGoogle,
        ),
        SizedBox(height: 15),

        // Facebook Button
        _buildSocialButton(
          icon: Icons.facebook,
          label: 'Continue with Facebook',
          color: _facebookColor,
          textColor: Colors.white,
          onPressed: _loginWithFacebook,
        ),
        SizedBox(height: 15),

        // Apple Button
        if (Theme.of(context).platform == TargetPlatform.iOS)
          _buildSocialButton(
            icon: Icons.apple,
            label: 'Continue with Apple',
            color: _appleColor,
            textColor: Colors.white,
            onPressed: _loginWithApple,
          ),
      ],
    );
  }

  // Individual Social Button
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sign Up Link
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            );
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}