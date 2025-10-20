import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:virtusize/virtusize_sdk/virtusize_sdk.dart';

import 'animated_effects.dart';
import 'login_page.dart';
import 'splash_screen.dart';

// 20.10

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VirtusizeDemoApp());
}

enum _AppStage { initializing, splash, login, home }

class VirtusizeDemoApp extends StatefulWidget {
  const VirtusizeDemoApp({super.key});

  @override
  State<VirtusizeDemoApp> createState() => _VirtusizeDemoAppState();
}

class _VirtusizeDemoAppState extends State<VirtusizeDemoApp> {
  _AppStage _stage = _AppStage.initializing;
  String? _initError;
  bool _initialUserSignedIn = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    if (_isInitializing) {
      return;
    }
    _isInitializing = true;
    if (mounted) {
      setState(() {
        _initError = null;
        _stage = _AppStage.initializing;
      });
    }

    try {
      await Firebase.initializeApp();
      final user = FirebaseAuth.instance.currentUser;
      _initialUserSignedIn = user != null;
      if (!mounted) {
        return;
      }
      setState(() {
        _stage = _AppStage.splash;
      });
    } catch (err, stack) {
      debugPrint('Firebase initialization failed: $err');
      if (kDebugMode) {
        debugPrintStack(stackTrace: stack);
      }
      if (mounted) {
        setState(() {
          _initError = err.toString();
          _stage = _AppStage.initializing;
        });
      }
    } finally {
      _isInitializing = false;
    }
  }

  void _handleSplashFinished() {
    if (!mounted) {
      return;
    }
    if (_initialUserSignedIn) {
      _showHome();
    } else {
      _showLogin();
    }
  }

  void _showLogin() {
    if (!mounted) return;
    _initialUserSignedIn = false;
    setState(() => _stage = _AppStage.login);
  }

  void _showHome() {
    if (!mounted) return;
    _initialUserSignedIn = true;
    setState(() => _stage = _AppStage.home);
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (err, stack) {
      debugPrint('Failed to sign out: $err');
      if (kDebugMode) {
        debugPrintStack(stackTrace: stack);
      }
    } finally {
      if (!mounted) {
        return;
      }
      _initialUserSignedIn = false;
      setState(() => _stage = _AppStage.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtusize SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        transitionBuilder: (child, animation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
        child: _buildStage(),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case _AppStage.initializing:
        if (_initError != null) {
          return _InitializationErrorView(
            key: const ValueKey('firebase-error'),
            message: _initError!,
            onRetry: _initializeFirebase,
          );
        }
        return const _FirebaseInitializingView(
          key: ValueKey('firebase-loading'),
        );
      case _AppStage.splash:
        return SplashScreen(
          key: const ValueKey('splash'),
          onFinished: _handleSplashFinished,
        );
      case _AppStage.login:
        return LoginPage(
          key: const ValueKey('login'),
          onLoginSuccess: _showHome,
        );
      case _AppStage.home:
        return VirtusizeDemoScreen(
          key: const ValueKey('home'),
          onLogout: () {
            _handleLogout();
          },
        );
    }
  }
}

class VirtusizeDemoScreen extends StatelessWidget {
  const VirtusizeDemoScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF0F172A),
        Color(0xFF312E81),
        Color(0xFF7C3AED),
        Color(0xFF0EA5E9),
      ],
      duration: const Duration(seconds: 18),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Virtusize SDK Sample App'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: onLogout,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 32),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: VirtusizeRecommendationView(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedGradientText(
          text: 'Virtusize Size Recommendation',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your height (cm) and weight (kg) to get a recommended clothing size based on BMI.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}

class _FirebaseInitializingView extends StatelessWidget {
  const _FirebaseInitializingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF0F172A),
        Color(0xFF1E293B),
        Color(0xFF312E81),
        Color(0xFF5046E5),
      ],
      duration: const Duration(seconds: 14),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Connecting to Firebase...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InitializationErrorView extends StatelessWidget {
  const _InitializationErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF450A0A),
        Color(0xFF7F1D1D),
        Color(0xFF9A3412),
        Color(0xFF92400E),
      ],
      duration: const Duration(seconds: 16),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 56,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Firebase setup error',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      onRetry();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry initialization'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
