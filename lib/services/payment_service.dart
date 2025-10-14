import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

/// Serviço de pagamento que lida com os fluxos de compra para web e mobile.
class PaymentService {
  PaymentService._();
  static final instance = PaymentService._();

  // TODO: Substituir pela URL de produção da sua função na Vercel.
  final String _mobileBackendUrl =
      'http://localhost:3000/api/create-payment-intent';
  final String _webBackendUrl =
      'http://localhost:3000/api/create-checkout-session';

  /// Inicia o processo de compra, adaptando-se à plataforma (web ou mobile).
  Future<void> purchasePremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado. Faça login para continuar.');
    }

    try {
      if (kIsWeb) {
        // --- FLUXO PARA WEB ---
        await _handleEnableWeb(user);
      } else {
        // --- FLUXO PARA MOBILE ---
        await _handleMobile(user);
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        debugPrint('Pagamento cancelado pelo usuário.');
      } else {
        debugPrint('Erro do Stripe: ${e.error.localizedMessage}');
        throw Exception(
          'Erro ao processar pagamento: ${e.error.localizedMessage}',
        );
      }
    } catch (e) {
      debugPrint('Erro ao iniciar a compra: $e');
      rethrow;
    }
  }

  /// Lida com o fluxo de pagamento para plataformas móveis usando PaymentSheet.
  Future<void> _handleMobile(User user) async {
    final paymentIntentData = await _createPaymentIntent(user);

    if (paymentIntentData == null) {
      throw Exception('Falha ao obter os dados de pagamento do servidor.');
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'IntelliResume',
        paymentIntentClientSecret: paymentIntentData['paymentIntent'],
        customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
        customerId: paymentIntentData['customer'],
      ),
    );

    await Stripe.instance.presentPaymentSheet();
    debugPrint('PaymentSheet apresentado com sucesso.');
  }

  /// Lida com o fluxo de pagamento para a web usando Stripe Checkout (redirecionamento).
  Future<void> _handleEnableWeb(User user) async {
    final sessionData = await _createCheckoutSession(user);
    final checkoutUrl = sessionData?['url'];

    if (checkoutUrl == null) {
      throw Exception('Não foi possível obter a URL de pagamento.');
    }

    if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
      await launchUrl(Uri.parse(checkoutUrl), webOnlyWindowName: '_self');
    } else {
      throw 'Não foi possível abrir a URL de pagamento: $checkoutUrl';
    }
  }

  /// Chama o backend para criar um PaymentIntent (para mobile).
  Future<Map<String, dynamic>?> _createPaymentIntent(User user) async {
    final idToken = await user.getIdToken();
    final response = await http.post(
      Uri.parse(_mobileBackendUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'userId': user.uid, 'email': user.email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw 'Erro do servidor: ${errorData['error'] ?? response.body}';
    }
  }

  /// Chama o backend para criar uma Checkout Session (para web).
  Future<Map<String, dynamic>?> _createCheckoutSession(User user) async {
    final idToken = await user.getIdToken();
    final response = await http.post(
      Uri.parse(_webBackendUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'userId': user.uid, 'email': user.email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw 'Erro do servidor: ${errorData['error'] ?? response.body}';
    }
  }
}
