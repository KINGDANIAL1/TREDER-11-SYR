import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/trading_service.dart';
import '../../widgets/custom_button.dart';
import '../../utils/validators.dart';

class TradingScreen extends StatefulWidget {
  @override
  _TradingScreenState createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  final TradingService _tradingService = TradingService();
  String selectedPair = 'BTC/USDT';
  double currentPrice = 0.0;
  final _amountController = TextEditingController();
  bool _isLoading = true;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _fetchMarketData();
    _initTradingView();
  }

  void _initTradingView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>body { margin: 0; padding: 0; }</style>
        </head>
        <body>
          <div id="tradingview_chart"></div>
          <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
          <script type="text/javascript">
            new TradingView.widget({
              "width": "100%",
              "height": "100%",
              "symbol": "BINANCE:${selectedPair.replaceAll('/', '')}",
              "interval": "D",
              "timezone": "Etc/UTC",
              "theme": "dark",
              "style": "1",
              "locale": "en",
              "toolbar_bg": "#f1f3f6",
              "enable_publishing": false,
              "allow_symbol_change": true,
              "container_id": "tradingview_chart"
            });
          </script>
        </body>
        </html>
      ''');
  }

  Future<void> _fetchMarketData() async {
    try {
      var data = await _tradingService.getMarketData(selectedPair);
      setState(() {
        currentPrice = data['price'] ?? 0.0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load market data')));
    }
  }

  void _placeOrder(String type) async {
    if (!_validateInputs()) return;
    setState(() => _isLoading = true);
    String amount = _amountController.text.trim();
    var response = await _tradingService.placeOrder(selectedPair, type, amount);
    setState(() => _isLoading = false);
    if (response['success']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Order placed successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'] ?? 'Order failed')));
    }
  }

  bool _validateInputs() {
    if (!Validators.isValidAmount(_amountController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid amount')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trading'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.yellow)))
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trade', style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: DropdownButton<String>(
                          value: selectedPair,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: ['BTC/USDT', 'ETH/USDT', 'BTC/ETH']
                              .map((pair) => DropdownMenuItem(
                                    value: pair,
                                    child: Text(pair, style: TextStyle(color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPair = value!;
                              _isLoading = true;
                              _initTradingView();
                              _fetchMarketData();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: WebViewWidget(controller: _webViewController),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price:', style: TextStyle(fontSize: 18)),
                            Text('$currentPrice USDT',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                          ],
                       ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[800],
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          text: 'Buy',
                          onPressed: () => _placeOrder('buy'),
                          width: 120,
                          color: Colors.green[700],
                        ),
                        CustomButton(
                          text: 'Sell',
                          onPressed: () => _placeOrder('sell'),
                          width: 120,
                          color: Colors.red[700],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}