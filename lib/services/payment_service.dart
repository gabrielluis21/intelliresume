// lib/services/payment_service.dart

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Serviço de pagamento encapsula Stripe e Cloud Functions.
/// Em produção você apontará para suas próprias APIs.
class PaymentService {
  PaymentService._();
  static final instance = PaymentService._();

  final HttpsCallable _createPaymentIntent = FirebaseFunctions.instance
      .httpsCallable('createPaymentIntent'); // função backend

  /// Inicializa a Stripe com sua chave Publishable
  void initialize({required String publishableKey}) {
    Stripe.publishableKey = publishableKey;
  }

  /// Cria um checkout para o plano premium (por exemplo, $9.99)
  Future<void> purchasePremium() async {
    // 1) Chama função Cloud para gerar PaymentIntent
    final resp = await _createPaymentIntent.call(<String, dynamic>{
      'amount': 999, // $9.99 em cents
      'currency': 'usd',
    });
    final data = resp.data as Map<String, dynamic>;
    final clientSecret = data['clientSecret'] as String;

    // 2) Apresenta o UI do Stripe para coleta do cartão
    final billingDetails = BillingDetails(
      name: 'Cliente', // você pode usar o nome do perfil
      email: data['receipt_email'] as String?,
    );
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Meu Currículo',
        billingDetails: billingDetails,
      ),
    );
    await Stripe.instance.presentPaymentSheet();

    // Se chegar aqui sem erro, pagamento confirmado!
  }
}
