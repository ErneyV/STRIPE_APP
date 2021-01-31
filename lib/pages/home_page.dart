import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/data/targetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/targeta_page.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final stripeService = new StripeService();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: close_sinks
    final pagarBloc = context.read<PagarBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Pagos'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  mostrarLoading(context);
                  final amount = pagarBloc.state.montoPagarString;
                  final currency = pagarBloc.state.moneda;
                  final resp = await stripeService.pagarTarjetaNueva(
                    amount: amount,
                    currency: currency,
                  );
                  Navigator.of(context).pop();
                  if (resp.ok) {
                    mostrarAlerta(context, 'Tarjeta ok', 'Todo bello');
                  } else {
                    mostrarAlerta(context, 'algo salio mal', resp.msg);
                  }
                })
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              width: size.width,
              height: size.height,
              top: 150,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: PageController(viewportFraction: 0.8),
                itemCount: tarjetas.length,
                itemBuilder: (_, int index) {
                  final targeta = tarjetas[index];

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<PagarBloc>()
                          .add(OnSeleccionarTarjeta(targeta));
                      Navigator.push(
                          context, navegarFadeIn(context, TargetaPage()));
                    },
                    child: Hero(
                      tag: targeta.cardNumber,
                      child: CreditCardWidget(
                        cardNumber: targeta.cardNumber,
                        expiryDate: targeta.expiracyDate,
                        cardHolderName: targeta.cardHolderName,
                        cvvCode: targeta.cvv,
                        showBackView: false,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(bottom: 0, child: TotalPayButton())
          ],
        ));
  }
}
