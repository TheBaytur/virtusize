import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'animated_effects.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _authError;

  @override
  void initState() {
    super.initState();
    _emailController.text = '123';
    _passwordController.text = '123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF111827),
        Color(0xFF1F2937),
        Color(0xFF3B82F6),
        Color(0xFF9333EA),
      ],
      duration: const Duration(seconds: 20),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Log In'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedGradientBackground(
              colors: const [
                Color(0xFF2563EB),
                Color(0xFF7C3AED),
                Color(0xFFEC4899),
                Color(0xFF14B8A6),
              ],
              borderRadius: BorderRadius.circular(32),
              padding: const EdgeInsets.all(1.8),
              duration: const Duration(seconds: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedGradientText(
                          text: 'Welcome Back',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Log in with your email and password to view your personalized size recommendations.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.85),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (value.trim() != '123') {
                              return 'Email must be 123';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value != '123') {
                              return 'Password must be 123';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 28),
                        AnimatedActionButton(
                          onPressed: _submit,
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text('Log In'),
                          loadingLabel: const Text('Signing In...'),
                          isLoading: _isSubmitting,
                          colors: const [
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                            Color(0xFFFBBF24),
                            Color(0xFF34D399),
                          ],
                        ),
                        if (_authError != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _authError!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.redAccent[200],
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 16),
                        AnimatedPulse(
                          child: TextButton(
                            onPressed: _isSubmitting ? null : () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _authError = null;
    });

    if (Firebase.apps.isEmpty) {
      const message = 'Firebase is not initialized yet. Please try again.';
      if (mounted) {
        setState(() {
          _authError = message;
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(message)));
      }
      return;
    }

    try {
      await FirebaseAuth.instance.signInAnonymously();
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged in successfully!')));

      await Future<void>.delayed(const Duration(milliseconds: 600));

      if (!mounted) {
        return;
      }

      widget.onLoginSuccess();
    } on FirebaseAuthException catch (err) {
      final message = err.message ?? 'Failed to authenticate with Firebase.';
      if (mounted) {
        setState(() {
          _authError = message;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase auth error: $message')),
        );
      }
    } on FirebaseException catch (err) {
      final message = err.message ?? 'Firebase is unavailable right now.';
      if (mounted) {
        setState(() {
          _authError = message;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (err) {
      final message = 'Unexpected error: $err';
      if (mounted) {
        setState(() {
          _authError = message;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
