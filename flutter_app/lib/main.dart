import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String _htmlContent = '';

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final momentkh = await rootBundle.loadString('assets/web/momentkh.js');
    final css = await rootBundle.loadString('assets/web/taskpane.css');
    final js = await rootBundle.loadString('assets/web/app.js');

    // Build self-contained HTML with all assets inlined
    setState(() {
      _htmlContent = '''<!DOCTYPE html>
<html lang="km">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1"/>
  <title>ថ្ងៃចន្ទគតិខ្មែរ</title>
  <style>$css</style>
</head>
<body>
  <header class="header"><h1>ថ្ងៃចន្ទគតិខ្មែរ</h1></header>
  <main>
    <div class="layout">
      <div class="col-left">
        <div class="cal-card">
          <div class="cal-nav">
            <button id="prev-month" class="nav-btn">&#8249;</button>
            <span id="cal-month-label" class="cal-month-label"></span>
            <button id="next-month" class="nav-btn">&#8250;</button>
          </div>
          <div class="cal-weekdays">
            <span>អា</span><span>ច</span><span>អ</span><span>ព</span>
            <span>ព្រ</span><span>សុ</span><span>ស</span>
          </div>
          <div id="cal-grid" class="cal-grid"></div>
        </div>
      </div>
      <div class="col-right">
        <div class="result-card">
          <span class="kd-lunar" id="kd-lunar"></span>
          <span class="kd-solar" id="kd-solar"></span>
        </div>
        <div class="fmt-section">
          <div class="fmt-label">Format</div>
          <div class="fmt-pills">
            <button class="pill active" data-fmt="1">ចន្ទ</button>
            <button class="pill" data-fmt="2">សុរិយ</button>
            <button class="pill" data-fmt="3">២ជួរ</button>
            <button class="pill" data-fmt="4">ពាក្យ</button>
          </div>
          <div id="label-row" class="label-row hidden">
            <input id="custom-label" type="text" value="ផ្លូវមាស" maxlength="80"/>
          </div>
        </div>
        <div class="preview-card"><pre id="preview" class="preview"></pre></div>
        <div class="actions">
          <button id="copy-btn" class="btn-primary">Copy</button>
          <button id="share-btn" class="btn-secondary">Share</button>
        </div>
        <p id="status" class="status"></p>
      </div>
    </div>
  </main>
  <script>$momentkh</script>
  <script>$js</script>
</body>
</html>''';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_htmlContent.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F0E8),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFB45309))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialData: InAppWebViewInitialData(
                data: _htmlContent,
                mimeType: 'text/html',
                encoding: 'utf-8',
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportZoom: false,
                disableVerticalScroll: false,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                // Flutter bridge: JS calls this to copy text to clipboard
                controller.addJavaScriptHandler(
                  handlerName: 'copyText',
                  callback: (args) async {
                    if (args.isNotEmpty) {
                      await Clipboard.setData(ClipboardData(text: args[0].toString()));
                    }
                  },
                );
                // Flutter bridge: JS calls this to share text
                controller.addJavaScriptHandler(
                  handlerName: 'shareText',
                  callback: (args) async {
                    // share_plus would be used here
                  },
                );
              },
              onLoadStop: (controller, url) {
                setState(() => _isLoading = false);
              },
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFFB45309))),
          ],
        ),
      ),
    );
  }
}
