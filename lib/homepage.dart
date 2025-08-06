import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DangerAanalloHomepage extends StatefulWidget {
  const DangerAanalloHomepage({Key? key}) : super(key: key);

  @override
  State<DangerAanalloHomepage> createState() => _DangerAanalloHomepageState();
}

class _DangerAanalloHomepageState extends State<DangerAanalloHomepage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isChecking = false;
  String _status = '';
  String _cookieCount = 'Unknown';
  bool _collectsPersonalData = false;

  Future<void> _checkWebsite() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _isChecking = true;
      _status = '';
    });

    final isSafe = await _checkGoogleSafeBrowsing(url);
    final ipqData = await _checkIPQuality(url);
    final vtScore = await _checkVirusTotal(url);

    setState(() {
      _status = (!isSafe || vtScore > 3)
          ? 'danger'
          : ipqData['suspicious']
              ? 'suspicious'
              : 'safe';

      _cookieCount = ipqData['cookies']?.toString() ?? 'Unknown';
      _collectsPersonalData = ipqData['tracking'] || ipqData['sensitive'];
      _isChecking = false;
    });
  }

  Future<bool> _checkGoogleSafeBrowsing(String url) async {
    final apiKey = dotenv.env['GOOGLE_SAFE_BROWSING_API'];
    final body = jsonEncode({
      "client": {
        "clientId": "danger-aanallo",
        "clientVersion": "1.0"
      },
      "threatInfo": {
        "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE"],
        "platformTypes": ["ANY_PLATFORM"],
        "threatEntryTypes": ["URL"],
        "threatEntries": [{"url": url}]
      }
    });

    final response = await http.post(
      Uri.parse('https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    final data = json.decode(response.body);
    return data.isEmpty;
  }

  Future<Map<String, dynamic>> _checkIPQuality(String url) async {
    final apiKey = dotenv.env['IP_QUALITY_API'];
    final encodedUrl = Uri.encodeComponent(url);
    final response = await http.get(
      Uri.parse('https://ipqualityscore.com/api/json/url/$apiKey/$encodedUrl'),
    );

    final result = json.decode(response.body);
    print("IPQualityScore Result: $result"); 
    return {
      'suspicious': result['suspicious'] ?? false,
      'cookies': result['domain_rank'] ?? 'Unknown',
      'tracking': result['tracking'] ?? false,
      'sensitive': result['sensitive'] ?? false,
    };
  }

  Future<int> _checkVirusTotal(String url) async {
    final apiKey = dotenv.env['VIRUS_TOTAL_API'];
    final response = await http.post(
      Uri.parse('https://www.virustotal.com/api/v3/urls'),
      headers: {
        'x-apikey': apiKey!,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'url': url},
    );

    final data = json.decode(response.body);
    final analysisId = data['data']['id'];

    final report = await http.get(
      Uri.parse('https://www.virustotal.com/api/v3/analyses/$analysisId'),
      headers: {'x-apikey': apiKey},
    );

    final analysis = json.decode(report.body);
    final maliciousCount = analysis['data']['attributes']['stats']['malicious'] ?? 0;
    return maliciousCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.white)),
          Positioned.fill(child: Container(color: Colors.yellow.withOpacity(0.5))),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildCard(
                  icon: Icons.link,
                  title: 'Check Website Safety',
                  subtitle: 'Enter any website URL to check for safety, cookies, and tracking',
                ),
                const SizedBox(height: 20),
                _buildInputCard(),
                const SizedBox(height: 20),
                if (_isChecking) _buildLoading(),
                if (_status.isNotEmpty) _buildResultCard(),
                const SizedBox(height: 20),
                _buildDangerMeter(),
                const SizedBox(height: 20),
                _buildInfoCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Image.asset("assets/images/logo.png", width: 45, height: 45),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Danger Aanallo 🚨',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const Icon(Icons.info_outline, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'https://example.com',
                prefixIcon: const Icon(Icons.language),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkWebsite,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('CHECK WEBSITE 🔍', style: TextStyle(fontSize: 18,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text('Analyzing website...', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    IconData icon;
    Color color;
    String title;
    String message;

    switch (_status) {
      case 'safe':
        icon = Icons.verified_user;
        color = Colors.green;
        title = 'Safe Website';
        message = 'This site looks secure!';
        break;
      case 'suspicious':
        icon = Icons.warning;
        color = Colors.orange;
        title = 'Suspicious Website';
        message = 'Proceed with caution!';
        break;
      default:
        icon = Icons.dangerous;
        color = Colors.red;
        title = 'Dangerous Website';
        message = 'Avoid this site!';
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(message),
            const SizedBox(height: 20),
            const Divider(),
            Text('🍪 Cookies Used: $_cookieCount'),
            const SizedBox(height: 8),
            Text(_collectsPersonalData
                ? '🛑 May collect personal data'
                : '✅ No personal data collection detected'),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerMeter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('🎮 Danger Meter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _status == 'safe'
                  ? 0.2
                  : _status == 'suspicious'
                      ? 0.6
                      : 0.9,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                _status == 'safe'
                    ? Colors.green
                    : _status == 'suspicious'
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('🔍 What This App Does', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('• Analyzes website security'),
            Text('• Detects cookies and tracking'),
            Text('• Warns about suspicious sites'),
            Text('• Keeps your browsing safe'),
            SizedBox(height: 10),
            Text('💡 Tip: "Browseril vandi poyalum, njan back seat-il und 👀"', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
