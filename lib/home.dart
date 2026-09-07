import 'package:bmicalculator_1/navbar.dart';
import 'package:bmicalculator_1/share.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum Gender { male, female }

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  Gender? _selectedGender;
  double? bmi;
  String? name;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final savedName = await PreferencesService.getName();
    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        _nameController.text = savedName;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Color getBMIColor() {
    if (bmi == null) return Colors.teal;
    if (bmi! < 18.5) {
      return Colors.lightBlue;
    } else if (bmi! < 25) {
      return Colors.green;
    } else if (bmi! < 29.9) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String getBMICategory() {
    if (bmi == null) return '';
    if (bmi! < 18.5) {
      return 'Under weight';
    } else if (bmi! < 25) {
      return 'Normal';
    } else if (bmi! < 29.9) {
      return 'Over weight';
    } else {
      return 'Obese';
    }
  }

  static const teal = Color(0xFF0E7C8C);
  static const bg = Color(0xFFF0F5F6);

  Future<void> _calculateBmi() async {
    final enteredName = _nameController.text.trim();
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    if (enteredName.isEmpty ||
        height == null ||
        weight == null ||
        height <= 0 ||
        weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return;
    }

    final calculatedBmi = weight / ((height / 100) * (height / 100));

    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    await PreferencesService.saveHistory(
      date: formattedDate,
      weight: weight,
      height: height,
      bmi: double.parse(calculatedBmi.toStringAsFixed(1)),
    );

    if (!mounted) return;

    setState(() {
      name = enteredName;
      bmi = calculatedBmi;
      showResult = true;
    });
  }

  // ---------- reusable: a white rounded card ----------
  Widget _card(String title, Widget content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: teal,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  // ---------- reusable: a labeled text field ----------
  Widget _field(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F6F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ---------- reusable: one tappable gender box ----------
  Widget _genderBox(Gender gender, IconData icon, String label) {
    final selected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFBEE3F0) : const Color(0xFFF3F6F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? teal : Colors.transparent),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? teal : Colors.black54),
              const SizedBox(height: 6),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.monitor_heart_outlined, color: teal),
            SizedBox(width: 8),
            Text(
              'BMI',
              style: TextStyle(color: teal, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate your BMI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Precision insights for a balanced life.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            _card(
              'Personal Details',
              Column(
                children: [
                  _field('Full Name', _nameController),
                  const SizedBox(height: 14),
                  _field('Age', _ageController, isNumber: true),
                ],
              ),
            ),

            _card(
              'Gender',
              Row(
                children: [
                  _genderBox(Gender.male, Icons.male, 'Male'),
                  const SizedBox(width: 10),
                  _genderBox(Gender.female, Icons.female, 'Female'),
                ],
              ),
            ),

            _card(
              'Height',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('Value', _heightController, isNumber: true),
                  const SizedBox(height: 8),
                  const Text(
                    'CENTIMETERS',
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),

            _card(
              'Weight',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('Value', _weightController, isNumber: true),
                  const SizedBox(height: 8),
                  const Text(
                    'KILOGRAMS',
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _calculateBmi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5D6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  'Calculate BMI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (showResult && bmi != null) ...[
              SizedBox(height: 25),
              SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.symmetric(
                  vertical: 35,
                  horizontal: 20,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.12),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 30,
                            startAngle: 180,
                            endAngle: 0,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 30,
                              cornerStyle: CornerStyle.bothCurve,
                            ),
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 18.5,
                                color: Colors.lightBlue,
                                startWidth: 30,
                                endWidth: 30,
                              ),
                              GaugeRange(
                                startValue: 18.5,
                                endValue: 24.9,
                                color: Colors.green,
                                startWidth: 30,
                                endWidth: 30,
                              ),
                              GaugeRange(
                                startValue: 25,
                                endValue: 29.9,
                                color: Colors.yellow,
                                startWidth: 30,
                                endWidth: 30,
                              ),
                              GaugeRange(
                                startValue: 29.9,
                                endValue: 30,
                                color: Colors.red,
                                startWidth: 30,
                                endWidth: 30,
                              ),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: (bmi ?? 0).clamp(0, 30),
                                needleColor: Colors.black,
                                needleLength: 0.65,
                                needleStartWidth: 1,
                                needleEndWidth: 6,
                                knobStyle: KnobStyle(
                                  color: Colors.black,
                                  knobRadius: 0.08,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Column(
                        children: [
                          Text(
                            'Your BMI',
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            (bmi ?? 0).toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF007F9F),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: getBMIColor(),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              getBMICategory(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 231, 249, 246),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Color(0xFF168EAA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sentiment_satisfied_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        'Your BMI is in the ${getBMICategory()} range. Keep taking care of your health',
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.4,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsetsGeometry.fromLTRB(25, 25, 25, 25),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.10),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BMI Category',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.lightBlue,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Under weight',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Text('<18.5', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(radius: 7, backgroundColor: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Normal weight',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Text('18.5-24.9', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(radius: 7, backgroundColor: Colors.yellow),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Over weight',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Text('25-29.9', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(radius: 7, backgroundColor: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Obese', style: TextStyle(fontSize: 16)),
                        ),
                        Text('≥30', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
