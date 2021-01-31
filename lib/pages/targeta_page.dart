import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TargetaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final targeta = context.read<PagarBloc>().state.targeta;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.read<PagarBloc>().add(OnDesactivarTarjeta());
              Navigator.of(context).pop();
            }),
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
