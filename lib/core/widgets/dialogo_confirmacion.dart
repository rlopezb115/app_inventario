import 'package:flutter/material.dart';

class DialogoConfirmacion extends StatelessWidget {
    final String _titulo;
    final Widget _contenido;
    final String _textoConfirmar;
    final VoidCallback _onConfirmar;

    const DialogoConfirmacion._({
        required this._titulo,
        required this._contenido,
        required this._textoConfirmar,
        required this._onConfirmar,
    });

    static Future<void> mostrar(
        BuildContext context, {
        required String titulo,
        required Widget contenido, // Recibe cualquier estructura visual (Texto, RichText, Row, etc.)
        String textoConfirmar = 'Confirmar',
        required VoidCallback onConfirmar,
    }) {
        return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) => DialogoConfirmacion._(
                titulo: titulo,
                contenido: contenido,
                textoConfirmar: textoConfirmar,
                onConfirmar: onConfirmar,
            ),
        );
    }

    @override
    Widget build(BuildContext context)
    {
        final theme = Theme.of(context);

        return AlertDialog(
            title: Text(_titulo),
            content: SingleChildScrollView(
                child: ListBody(
                    children: [_contenido],
                ),
            ),
            actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                        'Cancelar',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                    ),
                    onPressed: () {
                        Navigator.of(context).pop();
                        _onConfirmar();
                    },
                    child: Text(_textoConfirmar),
                ),
            ],
        );
    }
}