import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_app/payment_intents_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  //singleton
  StripeService._privateContructor();
  static final StripeService _instance = StripeService._privateContructor();
  factory StripeService() => _instance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51IFRS3LpJ1TFCP2nOUgrxpjmNFL0rx4aIk1thBzg5yipBQAhNInS46hZ7pRfBB4U7q58Gvrqq7WxHeSKJYlXvpJ1006KpwSZz7';

  String _apiKey =
      'pk_test_51IFRS3LpJ1TFCP2nLNXVLI3kyDL8E8t9eYHt5GtEfcM3YDv2qlmacKBu8BgyIUl3sp4mRl8GOLQvkJHifDT8Gzkb009bSBRT1u';

  final headersOptions =
      new Options(contentType: Headers.formUrlEncodedContentType, headers: {
    'Authorization': 'Bearer ${StripeService._secretKey}',
  });

  void init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: this._apiKey,
      androidPayMode: 'test',
      merchantId: 'test',
    ));
  }

  Future<StripeCustomResponse> pagarTarjetaExiste({
    @required String amount,
    @required String currency,
    @required CreditCard card,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );
      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  /////////////////////////////////////////////////////////////
  Future<StripeCustomResponse> pagarTarjetaNueva({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );
      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }
  /////////////////////////////////////////////////////////////

  Future<StripeCustomResponse> pagarAppleplayGooglePlay({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          currencyCode: currency,
          totalPrice: amount,
        ),
        applePayOptions: ApplePayPaymentOptions(
          currencyCode: currency,
          countryCode: 'US',
          items: [
            ApplePayItem(
              amount: '$newAmount',
              label: 'Super Producto 1',
            )
          ],
        ),
      );

      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: CreditCard(token: token.tokenId),
        ),
      );

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      await StripePayment.completeNativePayRequest();
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  /////////////////////////////////////////////////////////7
  Future<PaymentInetntResponse> _crearPaymentIntent(
      {@required String amount, @required String currency}) async {
    try {
      final dio = new Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };

      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headersOptions,
      );
      return PaymentInetntResponse.fromJson(resp.data);
    } catch (e) {
      print('Error en intento : ${e.toString()}');
      return PaymentInetntResponse(
        status: '400',
      );
    }
  }

  Future<StripeCustomResponse> _realizarPago({
    @required String amount,
    @required String currency,
    @required PaymentMethod paymentMethod,
  }) async {
    try {
      // crear el inetnt
      final paymentIntenet = await this._crearPaymentIntent(
        amount: amount,
        currency: currency,
      );
      final paymentResult =
          await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntenet.clientSecret,
        paymentMethodId: paymentMethod.id,
      ));

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
            ok: false, msg: 'Algo Fallo: ${paymentResult.status}');
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }
}
