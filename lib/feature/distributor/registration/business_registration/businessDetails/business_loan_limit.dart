import 'package:flutter/material.dart';

class BusinessLoanLimit extends StatefulWidget {
  const BusinessLoanLimit({super.key});

  @override
  State<BusinessLoanLimit> createState() => _BusinessLoanLimitState();
}

class _BusinessLoanLimitState extends State<BusinessLoanLimit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loan limit"),
      ),
    );
  }
}
