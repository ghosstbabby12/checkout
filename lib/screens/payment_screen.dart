import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'payment_summary_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;

  const PaymentScreen({super.key, required this.product});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'Credit';
  bool _saveCard = true;

  final _cardNumberController = TextEditingController();
  final _validUntilController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with masked sample for demo
    _cardNumberController.text = '**** **** **** 1234';
    _validUntilController.text = '06/28';
    _cvvController.text = '***';
    _cardHolderController.text = 'Your name and surname';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _validUntilController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Widget _buildPaymentMethodPills() {
    final methods = ['PayPal', 'Credit', 'Wallet'];
    return Row(
      children: methods.map((m) {
        final selected = m == _selectedMethod;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(m),
            selected: selected,
            onSelected: (_) => setState(() => _selectedMethod = m),
            selectedColor: const Color(0xFF5B6EFF),
            backgroundColor: const Color(0xFFF3F5FB),
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black54,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration({Widget? prefix, String? hint}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceText = '\$${widget.product.price.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          'Payment data',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Total price', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(
              priceText,
              style: const TextStyle(
                fontSize: 36,
                color: Color(0xFF5B6EFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'Payment Method',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodPills(),
            const SizedBox(height: 18),

            const Text('Card number', style: TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              controller: _cardNumberController,
              decoration: _inputDecoration(
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFA726), Color(0xFFFF5252)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                hint: '**** **** **** ****',
              ).copyWith(prefixIcon: null),
              style: const TextStyle(letterSpacing: 2.0),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valid until',
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _validUntilController,
                        decoration: _inputDecoration(hint: 'Month / Year'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CVV',
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cvvController,
                        decoration: _inputDecoration(hint: '***'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Text('Card holder', style: TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              controller: _cardHolderController,
              decoration: _inputDecoration(hint: 'Your name and surname'),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Save card data for future payments',
                  style: TextStyle(color: Colors.black87),
                ),
                Switch(
                  value: _saveCard,
                  onChanged: (v) => setState(() => _saveCard = v),
                ),
              ],
            ),

            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B6EFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentSummaryScreen(
                        cardMasked: _cardNumberController.text,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Proceed to confirm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
