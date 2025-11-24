import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Salary Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SalaryHelperPage(),
    );
  }
}

class SalaryHelperPage extends StatefulWidget {
  const SalaryHelperPage({super.key});

  @override
  State<SalaryHelperPage> createState() => _SalaryHelperPageState();
}

class _SalaryHelperPageState extends State<SalaryHelperPage> {
  final TextEditingController baseSalaryController = TextEditingController();
  final TextEditingController overtimeHoursController = TextEditingController();
  final TextEditingController overtimeRateController = TextEditingController();
  final TextEditingController extraIncomeController = TextEditingController();
  final TextEditingController essentialsController = TextEditingController();
  final TextEditingController savingsPercentController =
      TextEditingController(text: '20');
  final TextEditingController targetFreeMoneyController =
      TextEditingController();

  String selectedTaxBand = 'Choose tax band';
  String resultText = '';

  final List<String> taxBands = [
    'Choose tax band',
    'Student job (5%)',
    'Standard (12%)',
    'High (20%)',
  ];

  @override
  void dispose() {
    baseSalaryController.dispose();
    overtimeHoursController.dispose();
    overtimeRateController.dispose();
    extraIncomeController.dispose();
    essentialsController.dispose();
    savingsPercentController.dispose();
    targetFreeMoneyController.dispose();
    super.dispose();
  }

  void calculatePlan() {
    final baseSalary =
        double.tryParse(baseSalaryController.text.trim()) ?? 0;
    final overtimeHours =
        double.tryParse(overtimeHoursController.text.trim()) ?? 0;
    final overtimeRate =
        double.tryParse(overtimeRateController.text.trim()) ?? 0;
    final extraIncome =
        double.tryParse(extraIncomeController.text.trim()) ?? 0;
    final essentials =
        double.tryParse(essentialsController.text.trim()) ?? 0;
    double savingsPercent =
        double.tryParse(savingsPercentController.text.trim()) ?? 0;
    final targetFreeMoney =
        double.tryParse(targetFreeMoneyController.text.trim()) ?? 0;

    if (baseSalary <= 0) {
      setState(() {
        resultText = 'Please enter a base salary greater than zero.';
      });
      return;
    }

    if (selectedTaxBand == 'Choose tax band') {
      setState(() {
        resultText = 'Please choose a tax band.';
      });
      return;
    }

    if (savingsPercent < 0) {
      savingsPercent = 0;
    } else if (savingsPercent > 80) {
      savingsPercent = 80;
    }

    final overtimePay = overtimeHours * overtimeRate;
    final grossIncome = baseSalary + overtimePay + extraIncome;

    double taxRate = 0;
    if (selectedTaxBand == 'Student job (5%)') {
      taxRate = 0.05;
    } else if (selectedTaxBand == 'Standard (12%)') {
      taxRate = 0.12;
    } else if (selectedTaxBand == 'High (20%)') {
      taxRate = 0.20;
    }

    final taxAmount = grossIncome * taxRate;
    final afterTax = grossIncome - taxAmount;

    String essentialsWarning = '';
    if (essentials < 0) {
      essentialsWarning = 'Warning: essentials cannot be negative.\n';
    } else if (essentials > afterTax) {
      essentialsWarning =
          'Warning: essentials are higher than income after tax.\n';
    }

    final savingsAmount = afterTax * (savingsPercent / 100);
    final moneyAfterEssentials = afterTax - essentials;
    final freeMoney = moneyAfterEssentials - savingsAmount;

    String status;
    String message;

    if (freeMoney <= 0) {
      status = 'Tight month';
      message =
          'Your plan is very tight. Try to reduce essentials or lower savings for this month.';
    } else if (freeMoney < afterTax * 0.15) {
      status = 'Balanced plan';
      message =
          'You cover essentials and savings, but fun money is limited. Spend carefully.';
    } else {
      status = 'Comfortable plan';
      message =
          'You have room for savings and some free spending. Good balance for a student.';
    }

    final yearlyAfterTax = afterTax * 12;
    final yearlySavings = savingsAmount * 12;

    String savingsLevel;
    if (savingsPercent < 10) {
      savingsLevel = 'Low savings level';
    } else if (savingsPercent < 25) {
      savingsLevel = 'Medium savings level';
    } else {
      savingsLevel = 'High savings level';
    }

    String targetMessage = '';
    if (targetFreeMoney > 0) {
      if (freeMoney >= targetFreeMoney) {
        targetMessage =
            'You reach your target free money for this month.';
      } else {
        targetMessage =
            'You are below your target free money. Adjust expenses or savings.';
      }
    }

    setState(() {
      resultText =
          'Gross income: ${grossIncome.toStringAsFixed(2)}\n'
          'Tax: ${taxAmount.toStringAsFixed(2)}\n'
          'After tax: ${afterTax.toStringAsFixed(2)}\n'
          'Essentials: ${essentials.toStringAsFixed(2)}\n'
          'Planned savings (${savingsPercent.toStringAsFixed(0)}%): ${savingsAmount.toStringAsFixed(2)}\n'
          'Free money left: ${freeMoney.toStringAsFixed(2)}\n\n'
          '$essentialsWarning'
          'Status: $status\n$message\n\n'
          'Yearly after-tax income: ${yearlyAfterTax.toStringAsFixed(2)}\n'
          'Yearly planned savings: ${yearlySavings.toStringAsFixed(2)}\n'
          '$savingsLevel\n'
          '$targetMessage';
    });
  }

  void resetForm() {
    baseSalaryController.clear();
    overtimeHoursController.clear();
    overtimeRateController.clear();
    extraIncomeController.clear();
    essentialsController.clear();
    savingsPercentController.text = '20';
    targetFreeMoneyController.clear();

    setState(() {
      selectedTaxBand = 'Choose tax band';
      resultText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Salary Helper'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Monthly Salary & Budget Planner',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Form card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: baseSalaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Base monthly salary',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: overtimeHoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Overtime hours this month',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: overtimeRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Overtime rate per hour',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: extraIncomeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Extra income (freelance, tutoring...)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: essentialsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Essentials (rent, food, transport...)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: savingsPercentController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Savings target % (per month)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetFreeMoneyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target free money per month (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedTaxBand,
                      decoration: const InputDecoration(
                        labelText: 'Tax band',
                        border: OutlineInputBorder(),
                      ),
                      items: taxBands
                          .map(
                            (band) => DropdownMenuItem<String>(
                              value: band,
                              child: Text(band),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTaxBand = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: calculatePlan,
                        child: const Text(
                          'Calculate plan',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: resetForm,
                        child: const Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (resultText.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    resultText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student tips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Pay essentials first every month.'),
                    SizedBox(height: 4),
                    Text('• A small savings % is better than none.'),
                    SizedBox(height: 4),
                    Text('• Keep some free money for breaks.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
