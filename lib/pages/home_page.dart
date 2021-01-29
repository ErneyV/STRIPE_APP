import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_app/data/targetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/targeta_page.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Pagos'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  // mostrarLoading(context);
                  // await Future.delayed(Duration(milliseconds: 2000));
                  // Navigator.pop(context);
                  mostrarAlerta(context, 'Hola', 'Que mas señor Herney');
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
