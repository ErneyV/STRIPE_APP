part of 'pagar_bloc.dart';

@immutable
class PagarState {
  final double montoPagar;
  final String moneda;
  final bool targetaActiva;
  final TarjetaCredito targeta;

  String get montoPagarString => '${(this.montoPagar * 100).floor()}';

  PagarState({
    this.montoPagar = 375.55,
    this.moneda = 'USD',
    this.targetaActiva = false,
    this.targeta,
  });

  PagarState copyWith({
    double montoPagar,
    String moneda,
    bool targetaActiva,
    TarjetaCredito targeta,
  }) =>
      PagarState(
        montoPagar: montoPagar ?? this.montoPagar,
        moneda: moneda ?? this.moneda,
        targetaActiva: targetaActiva ?? this.targetaActiva,
        targeta: targeta ?? this.targeta,
      );
}
