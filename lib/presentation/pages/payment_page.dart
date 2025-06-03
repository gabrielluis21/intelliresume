// lib/pages/payment_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/user_provider.dart';
import '../../services/payment_service.dart';
import '../../core/utils/app_localizations.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/update_plan_usecase.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});
  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  bool _loading = false;

  Future<void> _upgrade() async {
    setState(() => _loading = true);
    try {
      await PaymentService.instance.purchasePremium();
      // após confirmação, atualiza plano no perfil
      final user = ref.read(userProfileProvider).value;
      var profile = await UpdatePlanUseCase().call(
        user!.uid!,
        PlanType.premium,
      );
      print(profile);
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
