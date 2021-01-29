import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/models/targeta_credito.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class TargetaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final targeta = TarjetaCredito(
        cardNumberHidden: '4242',
        cardNumber: '4242424242424242',
        brand: 'visa',
        cvv: '213',
        expiracyDate: '01/25',
        cardHolderName: 'Fernando Herrera');

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos'),
      ),
      body: Stack(
        children: [
          Container(),
          Hero(
            tag: targeta.cardNumber,
            child: CreditCardWidget(
              cardNumber: targeta.cardNumber,
              expiryDate: targeta.expiracyDate,
              cardHolderName: targeta.cardHolderName,
              cvvCode: targeta.cvv,
              showBackView: false,
            ),
          ),
          Positioned(
            bottom: 0,
            child: TotalPayButton(),
          )
        ],
      ),
    );
  }
}
