import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const String _appUrl =
    'https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_appUrl),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportZoom: false,
                cacheEnabled: true,
                // Cache for offline use after first load
                cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
              ),
              onWebViewCreated: (controller) {
                // Bridge: JS calls this to copy text natively
                controller.addJavaScriptHandler(
                  handlerName: 'copyText',
                  callback: (args) async {
                    if (args.isNotEmpty) {
                      await Clipboard.setData(
                          ClipboardData(text: args[0].toString()));
                    }
                  },
                );
              },
              onLoadStop: (_, __) {
                setState(() { _isLoading = false; _hasError = false; });
              },
              onReceivedError: (_, __, ___) {
                setState(() { _isLoading = false; _hasError = true; });
              },
              onConsoleMessage: (_, msg) => debugPrint('JS: ${msg.message}'),
            ),

            // Loading spinner
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFFB45309)),
              ),

            // Offline error
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
