part of 'pagar_bloc.dart';

@immutable
abstract class PagarEvent {}

class OnSeleccionarTarjeta extends PagarEvent {
  final TarjetaCredito targeta;

  OnSeleccionarTarjeta(this.targeta);
}

class OnDesactivarTarjeta extends PagarEvent {}
