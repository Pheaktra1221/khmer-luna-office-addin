import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// Web platform registration
import 'package:webview_flutter_web/webview_flutter_web.dart';

const String _appUrl =
    'https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register web platform
  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }
  runApp(const KhmerLunaApp());
}

class KhmerLunaApp extends StatelessWidget {
  const KhmerLunaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ថ្ងៃចន្ទគតិខ្មែរ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C2D12)),
        useMaterial3: true,
      ),
      home: const KhmerCalendarPage(),
    );
  }
}

class KhmerCalendarPage extends StatefulWidget {
  const KhmerCalendarPage({super.key});
  @override
  State<KhmerCalendarPage> createState() => _KhmerCalendarPageState();
}

class _KhmerCalendarPageState extends State<KhmerCalendarPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (!kIsWeb && WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) =>
            setState(() { _isLoading = false; _hasError = false; }),
        onWebResourceError: (_) =>
            setState(() { _isLoading = false; _hasError = true; }),
      ))
      ..loadRequest(Uri.parse(_appUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFFB45309)),
              ),
            if (_hasError)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text('No internet connection',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() { _isLoading = true; _hasError = false; });
                        _controller.loadRequest(Uri.parse(_appUrl));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
