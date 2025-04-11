import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showHeader = true;
  final GlobalKey _loginSectionKey = GlobalKey();

  // متحكمات الرسوم المتحركة
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late AnimationController _statsController;
  late Animation<double> _statsFade;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundFade;
  late AnimationController _licensesController;
  late Animation<double> _licensesFade;

  // بيانات ديناميكية
  double _usersCount = 100000;
  double _tradingVolume = 1000000;
  double _btcPrice = 65432.50;
  double _ethPrice = 3200.75;
  double _bnbPrice = 580.20;
  Timer? _statsTimer;

  @override
  void initState() {
    super.initState();

    // تهيئة الرسوم المتحركة
    _headerController = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );

    _statsController = AnimationController(vsync: this, duration: Duration(milliseconds: 2500))..forward();
    _statsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.easeIn),
    );

    _backgroundController = AnimationController(vsync: this, duration: Duration(seconds: 5))..repeat(reverse: true);
    _backgroundFade = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _licensesController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000))..forward();
    _licensesFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _licensesController, curve: Curves.easeIn),
    );

    // تحديث البيانات ديناميكيًا
    _statsTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _usersCount += Random().nextDouble() * 50;
        _tradingVolume += Random().nextDouble() * 6000;
        _btcPrice += (Random().nextBool() ? 1 : -1) * Random().nextDouble() * 150;
        _ethPrice += (Random().nextBool() ? 1 : -1) * Random().nextDouble() * 70;
        _bnbPrice += (Random().nextBool() ? 1 : -1) * Random().nextDouble() * 20;
      });
    });

    // التحكم في إظهار/إخفاء العنوان عند التمرير
    _scrollController.addListener(() {
      setState(() {
        _showHeader = _scrollController.offset <= 50;
      });
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _statsController.dispose();
    _backgroundController.dispose();
    _licensesController.dispose();
    _statsTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_validateInputs()) return;
    setState(() => _isLoading = true);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    var response = await _authService.login(email, password);
    setState(() => _isLoading = false);
    if (response['success']) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Login Failed'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  bool _validateInputs() {
    if (!Validators.isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email'), backgroundColor: Colors.redAccent),
      );
      return false;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password too short'), backgroundColor: Colors.redAccent),
      );
      return false;
    }
    return true;
  }

  void _scrollToLoginSection() {
    final context = _loginSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildElegantBackground(),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: 100),
                _buildDescription(),
                SizedBox(height: 80),
                _buildMarketStats(),
                SizedBox(height: 80),
                _buildLicensesSection(), // استبدال Market Trends
                SizedBox(height: 80),
                Container(
                  key: _loginSectionKey,
                  child: _buildInputSection(),
                ),
                SizedBox(height: 80),
                _buildActionButtons(),
                SizedBox(height: 50),
                _buildFooter(),
                SizedBox(height: 80),
                _buildMarketOverview(),
                SizedBox(height: 80),
                _buildFeatureHighlights(),
                SizedBox(height: 80),
                _buildMarketNews(),
                SizedBox(height: 80),
                _buildPlatformStats(),
                SizedBox(height: 80),
                _buildTradingVolumeSection(),
                SizedBox(height: 80),
                _buildSecurityFeatures(),
                SizedBox(height: 80),
                _buildUserTestimonials(),
                SizedBox(height: 80),
                _buildSupportSection(),
                SizedBox(height: 80),
                _buildFinalDivider(),
                SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildFixedHeader(),
          ),
        ],
      ),
    );
  }

  // خلفية أنيقة
  Widget _buildElegantBackground() {
    return AnimatedBuilder(
      animation: _backgroundFade,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Color.fromARGB(255, 0, 0, 0).withOpacity(0.1 * _backgroundFade.value),
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
      },
    );
  }

  // الشريط العلوي المحسن
  Widget _buildFixedHeader() {
    return AnimatedOpacity(
      opacity: _showHeader ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF0B90B).withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border(bottom: BorderSide(color: Color(0xFFF0B90B).withOpacity(0.2))),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF0B90B),
                  ),
                  child: Center(
                    child: Text(
                      'T',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Tredr Pro',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _scrollToLoginSection,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF0B90B),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF0B90B).withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Login / Sign Up',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نص الوصف
  Widget _buildDescription() {
    return FadeTransition(
      opacity: _statsFade,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          'Trade with Precision\nYour Gateway to Financial Freedom',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // إحصائيات السوق
  Widget _buildMarketStats() {
    return FadeTransition(
      opacity: _statsFade,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black.withOpacity(0.9),
          border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard('Users', '${_usersCount.toStringAsFixed(0)}+'),
            _buildStatCard('24h Volume', '\$${_tradingVolume.toStringAsFixed(0)}M'),
            _buildStatCard('BTC', '\$${_btcPrice.toStringAsFixed(2)}'),
            _buildStatCard('ETH', '\$${_ethPrice.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFFF0B90B),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  // قسم التراخيص والشهادات (جديد)
  Widget _buildLicensesSection() {
    return FadeTransition(
      opacity: _licensesFade,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black.withOpacity(0.9),
          border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Licenses & Certifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLicenseItem(
                  'Google Certified',
                  'Verified by Google for secure trading.',
                  'assets/google_certified.png', // صورة Google
                  Color(0xFFF0B90B),
                ),
                _buildLicenseItem(
                  'Binance Partner',
                  'Official partnership with Binance.',
                  'assets/binance_partner.png', // صورة Binance
                  Colors.white,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Trusted by millions, regulated by top authorities.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseItem(String title, String description, String imagePath, Color color) {
    return Container(
      width: 220,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // قسم الإدخال
  Widget _buildInputSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 30),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF0B90B).withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Color(0xFFF0B90B)),
          filled: true,
          fillColor: Colors.black.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFFF0B90B), width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        ),
      ),
    );
  }

  // أزرار الإجراءات (الزر ثابت)
  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: _isLoading
          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFF0B90B)))
          : Column(
              children: [
                Hero(
                  tag: 'login_button',
                  child: CustomButton(
                    text: 'Login',
                    onPressed: _login,
                    width: 300,
                    color: Color(0xFFF0B90B),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: RichText(
                    text: TextSpan(
                      text: 'New User? ',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'Montserrat'),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFF0B90B),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // تذييل الصفحة
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Divider(color: Color(0xFFF0B90B).withOpacity(0.1)),
          SizedBox(height: 20),
          Text(
            'Powered by Tredr Pro',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: Color(0xFFF0B90B), size: 16),
              SizedBox(width: 8),
              Text(
                'Secure | Fast | Reliable',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // نظرة عامة على السوق
  Widget _buildMarketOverview() {
    final marketData = _generateMarketData();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Trading Pairs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          ...marketData.map((data) => _buildMarketRow(data)).toList(),
        ],
      ),
    );
  }

  Widget _buildMarketRow(MarketData data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data.pair,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Montserrat',
            ),
          ),
          Row(
            children: [
              Text(
                '\$${data.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Color(0xFFF0B90B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(width: 20),
              Text(
                'Vol: \$${data.volume.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ميزات المنصة
  Widget _buildFeatureHighlights() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose Us?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          _buildFeatureItem(Icons.speed, 'High Speed', 'Lightning-fast trades.'),
          _buildFeatureItem(Icons.security, 'Top Security', 'Your funds are safe.'),
          _buildFeatureItem(Icons.bar_chart, 'Advanced Tools', 'Pro-level analytics.'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFF0B90B), size: 30),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // أخبار السوق
  Widget _buildMarketNews() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Updates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          _buildNewsItem('BTC Hits \$65K', 'April 06, 2025'),
          _buildNewsItem('ETH Gains Momentum', 'April 05, 2025'),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  // إحصائيات المنصة
  Widget _buildPlatformStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Performance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          _buildStatRow('Total Trades', '3M+'),
          _buildStatRow('Uptime', '99.99%'),
          _buildStatRow('Pairs', '400+'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFFF0B90B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  // قسم حجم التداول
  Widget _buildTradingVolumeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trading Volume',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 150,
            child: CustomPaint(
              painter: EnhancedChartPainter(
                data: [_tradingVolume, _tradingVolume * 0.98, _tradingVolume * 1.02, _tradingVolume * 0.99],
                color: Color(0xFFF0B90B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ميزات الأمان
  Widget _buildSecurityFeatures() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Features',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          _buildSecurityItem('2FA', 'Two-Factor Authentication enabled.'),
          _buildSecurityItem('Encryption', 'End-to-end data protection.'),
          _buildSecurityItem('Cold Storage', '95% of funds offline.'),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFFF0B90B), size: 25),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // شهادات المستخدمين
  Widget _buildUserTestimonials() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What Users Say',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          _buildTestimonial('Fast and reliable platform!', 'Ahmed, Trader'),
          _buildTestimonial('Best trading experience ever.', 'Sara, Investor'),
          _buildTestimonial('Secure and intuitive.', 'Khaled, Pro Trader'),
        ],
      ),
    );
  }

  Widget _buildTestimonial(String quote, String author) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$quote"',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 5),
          Text(
            '- $author',
            style: TextStyle(
              color: Color(0xFFF0B90B),
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  // قسم الدعم
  Widget _buildSupportSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support Center',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 20),
          _buildSupportItem('24/7 Live Chat', 'Get help anytime.'),
          _buildSupportItem('Email Support', 'support@tredrpro.com'),
          _buildSupportItem('FAQ', 'Visit our help center.'),
        ],
      ),
    );
  }

  Widget _buildSupportItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(Icons.support_agent, color: Color(0xFFF0B90B), size: 25),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // فاصل نهائي
  Widget _buildFinalDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      height: 1,
      color: Color(0xFFF0B90B).withOpacity(0.1),
    );
  }
}

// رسام الشارت المحسن (مستخدم في قسم Trading Volume)
class EnhancedChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  EnhancedChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double step = size.width / (data.length - 1);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double range = maxY - minY;
    final double heightScale = range > 0 ? size.height * 0.9 / range : 1;

    double startY = size.height - ((data[0] - minY) * heightScale);
    path.moveTo(0, startY.clamp(0, size.height));
    for (int i = 1; i < data.length; i++) {
      final x = i * step;
      final y = size.height - ((data[i] - minY) * heightScale);
      final controlX = (i - 0.5) * step;
      final controlY = size.height - (((data[i - 1] + data[i]) / 2 - minY) * heightScale);
      path.quadraticBezierTo(
        controlX,
        controlY.clamp(0, size.height),
        x,
        y.clamp(0, size.height),
      );
    }

    canvas.drawPath(path, paint);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// كائن إضافي للإحصائيات
class MarketData {
  final String pair;
  final double price;
  final double volume;

  MarketData(this.pair, this.price, this.volume);
}

// دالة لإنشاء بيانات السوق
List<MarketData> _generateMarketData() {
  return [
    MarketData('BTC/USDT', 65432.50, 1200000),
    MarketData('ETH/USDT', 3200.75, 850000),
    MarketData('BNB/USDT', 580.20, 450000),
  ];
}
