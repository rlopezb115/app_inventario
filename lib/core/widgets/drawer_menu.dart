import 'package:flutter/material.dart';

class DrawerOption
{
	final IconData _icon;
	final String _title;
	final Widget _targetScreen; // Pasamos la pantalla como parámetro de destino
	final bool _isSelected;

  	const DrawerOption({
    	required this._icon,
    	required this._title,
    	required this._targetScreen,
    	this._isSelected = false,
  	});
}

class DrawerMenu extends StatelessWidget
{
	final List<DrawerOption> options;
	
	const DrawerMenu({
    	super.key,
    	required this.options, // <-- Exigimos las opciones dinámicamente
  	});

  	@override
  	Widget build(BuildContext context)
	{
    	return Drawer(
      		child: Column(
        		children: [
          			const DrawerHeader(
            			decoration: BoxDecoration(color: Colors.blue),
            			child: Center(
              				child: Text(
                				'Menú de Inventario',
                				style: TextStyle(color: Colors.white, fontSize: 24),
              				),
            			),
          			),
          			Expanded(
            			child: ListView.builder(
              				padding: EdgeInsets.zero,
              				itemCount: options.length,
              				itemBuilder: (context, index)
							{
                				final option = options[index];
                				return ListTile(
                  					leading: Icon(option._icon),
									title: Text(option._title),
                  					selected: option._isSelected,
                  					onTap: ()
									{
                    					Navigator.pop(context); // Cierra el Drawer
                    					if (!option._isSelected)
										{
                      						Navigator.pushReplacement(
                        						context,
                        						MaterialPageRoute(builder: (context) => option._targetScreen),
                      						);
                    					}
                  					},
                				);
              				},
            			),
          			),
        		],
      		),
    	);
  	}
}