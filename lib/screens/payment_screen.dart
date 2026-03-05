import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 1; // 0=PayPal, 1=Credit, 2=Wallet
  bool _saveCard = true;

  final _cardNumber = TextEditingController();
  final _validUntil = TextEditingController();
  final _cvv = TextEditingController();
  final _holder = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumber.text = '****  ****  ****  ****';
    _validUntil.text = 'Month / Year';
    _cvv.text = '***';
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF2F4F8);
    const fieldBg = Color(0xFFF5F7FB);
    const primary = Color(0xFF5B6CFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Payment data',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Total price (You can pass total via arguments)
              Text(
                '\$${ModalRoute.of(context)?.settings.arguments is num ? (ModalRoute.of(context)!.settings.arguments as num).toStringAsFixed(2) : '2,280.00'}',
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: Color(0xFF5166FF),
                  letterSpacing: .3,
                ),
              ),
              const SizedBox(height: 22),

              // Payment method label
              Text('Payment Method',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
              const SizedBox(height: 12),

              // Methods row
              Row(
                children: [
                  _MethodPill(
                    label: 'PayPal',
                    selected: _selectedMethod == 0,
                    onTap: () => setState(() => _selectedMethod = 0),
                  ),
                  const SizedBox(width: 10),
                  _MethodPill(
                    label: 'Credit',
                    selected: _selectedMethod == 1,
                    onTap: () => setState(() => _selectedMethod = 1),
                  ),
                  const SizedBox(width: 10),
                  _MethodPill(
                    label: 'Wallet',
                    selected: _selectedMethod == 2,
                    onTap: () => setState(() => _selectedMethod = 2),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _Label('Card number'),
              const SizedBox(height: 8),
              _FieldContainer(
                background: fieldBg,
                child: Row(
                  children: [
                    const _CardBrandDots(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cardNumber,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 2.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label('Valid until'),
                        const SizedBox(height: 8),
                        _FieldContainer(
                          background: fieldBg,
                          child: TextField(
                            controller: _validUntil,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label('CVV'),
                        const SizedBox(height: 8),
                        _FieldContainer(
                          background: fieldBg,
                          child: TextField(
                            controller: _cvv,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _Label('Card holder'),
              const SizedBox(height: 8),
              _FieldContainer(
                background: fieldBg,
                child: TextField(
                  controller: _holder,
                  decoration: const InputDecoration(
                    hintText: 'Your name and surname',
                    hintStyle: TextStyle(color: Color(0xFFB3B9C5)),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Save card data for future payments',
                    style: TextStyle(color: Color(0xFF727B8C), fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    value: _saveCard,
                    activeColor: Colors.white,
                    activeTrackColor: primary,
                    onChanged: (v) => setState(() => _saveCard = v),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              _PrimaryButton(
                label: 'Proceed to confirm',
                onPressed: () {
                  // Simulate success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment processed successfully')),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF7B8597),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FieldContainer extends StatelessWidget {
  final Widget child;
  final Color background;
  const _FieldContainer({required this.child, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _MethodPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MethodPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedGradient = const LinearGradient(
      colors: [Color(0xFF6F86FF), Color(0xFF4F66FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: selected ? null : const Color(0xFFE4E8F0),
          gradient: selected ? selectedGradient : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F66FF).withOpacity(.35),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF7D8796),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CheckIcon(selected: selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool selected;
  const _CheckIcon({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: selected ? Colors.white70 : const Color(0xFFBBC3D1), width: 2),
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: selected ? Colors.white : const Color(0xFFD9DFEA),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: 10,
            color: selected ? const Color(0xFF4F66FF) : const Color(0xFF9AA3B2),
          ),
        ),
      ],
    );
  }
}

class _CardBrandDots extends StatelessWidget {
  const _CardBrandDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Row(
        children: const [
          _Dot(color: Color(0xFFE84142)),
          SizedBox(width: 4),
          _Dot(color: Color(0xFFF5A623)),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF6F86FF), Color(0xFF4F66FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334F66FF),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
