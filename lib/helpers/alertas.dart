part of 'helpers.dart';

mostrarLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            title: Text('Espere.....'),
            content: LinearProgressIndicator(),
          ));
}

mostrarAlerta(BuildContext context, String titulo, String content) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(content),
      actions: [
        MaterialButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ),
  );
}
