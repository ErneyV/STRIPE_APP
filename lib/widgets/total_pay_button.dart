import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/data/targetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final pagarBloc = context.read<PagarBloc>().state;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      width: width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${pagarBloc.montoPagar} ${pagarBloc.moneda}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          BlocBuilder<PagarBloc, PagarState>(
            builder: (context, state) {
              return _BtnPay(state);
            },
          )
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  final PagarState state;

  const _BtnPay(this.state);
  @override
  Widget build(BuildContext context) {
    return state.targetaActiva
        ? buildButtonTaget(context)
        : buildApleAndGoogle(context);
  }

  Widget buildApleAndGoogle(BuildContext context) {
    return MaterialButton(
      minWidth: 150,
      height: 45,
      shape: StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      onPressed: () async {
        final stripeService = StripeService();
        final state = context.read<PagarBloc>().state;

        final resp = await stripeService.pagarAppleplayGooglePlay(
          amount: state.montoPagarString,
          currency: state.moneda,
        );
      },
      child: Row(
        children: [
          Icon(
              !Platform.isAndroid
                  ? FontAwesomeIcons.google
                  : FontAwesomeIcons.apple,
              color: Colors.white),
          Text('  Pay',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
        ],
      ),
    );
  }

  Widget buildButtonTaget(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        mostrarLoading(context);
        final stripeService = StripeService();
        final pagarBloc = context.read<PagarBloc>().state;
        final tarjeta = state.targeta;
        final mesAnio = tarjeta.expiracyDate.split('/');
        final resp = await stripeService.pagarTarjetaExiste(
          amount: pagarBloc.montoPagarString,
          currency: pagarBloc.moneda,
          card: CreditCard(
            number: tarjeta.cardNumber,
            expMonth: int.parse(mesAnio[0]),
            expYear: int.parse(mesAnio[1]),
          ),
        );
        Navigator.of(context).pop();
        if (resp.ok) {
          mostrarAlerta(context, 'Tarjeta ok', 'Todo bello');
        } else {
          mostrarAlerta(context, 'algo salio mal', resp.msg);
        }
      },
      minWidth: 170,
      height: 45,
      shape: StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.solidCreditCard,
            color: Colors.white,
          ),
          Text('  Pagar',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
        ],
      ),
    );
  }
}
