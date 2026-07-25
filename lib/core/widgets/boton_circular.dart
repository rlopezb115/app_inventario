import 'package:flutter/material.dart';

class BotonCircular extends StatelessWidget
{
    final IconData _icon;
    final String _label;
    final VoidCallback _onPressed;

    const BotonCircular({
        super.key,
        required this._icon,
        required this._label,
        required this._onPressed,
    });

    @override
    Widget build(BuildContext context)
    {
        final theme = Theme.of(context);
        final colorIcono = theme.colorScheme.primary;
        final colorFondo = theme.colorScheme.surfaceContainer;

        return InkWell(
            onTap: _onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                color: colorFondo,
                                shape: BoxShape.circle,
                            ),
                            child: Icon(
                                _icon,
                                color: colorIcono,
                                size: 26,
                            ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            _label,
                            style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ],
                ),
            ),
        );
    }
}