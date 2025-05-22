// lib/pages/payment_page.dart

import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import '../../core/utils/app_localizations.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/update_plan_usecase.dart';
import '../../services/auth_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _loading = false;

  Future<void> _upgrade() async {
    setState(() => _loading = true);
    try {
      await PaymentService.instance.purchasePremium();
      // após confirmação, atualiza plano no perfil
      final user = AuthService.instance.currentUser!;
      var profile = await UpdatePlanUseCase().call(user.uid, PlanType.premium);
      // feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).premiumSuccess)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).paymentError)),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.payment)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(t.freePlan),
                subtitle: Text(t.freePlanDesc),
                trailing: ElevatedButton(
                  onPressed: null,
                  child: Text(t.current),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text(t.premiumPlan),
                subtitle: Text(t.premiumPlanDesc),
                trailing: ElevatedButton(
                  onPressed: _loading ? null : _upgrade,
                  child:
                      _loading
                          ? const CircularProgressIndicator.adaptive()
                          : Text(t.upgrade),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
