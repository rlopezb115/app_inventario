import 'package:flutter/material.dart';

class DrawerOption
{
	final IconData icon;
	final String title;
	final Widget targetScreen; // Pasamos la pantalla como parámetro de destino
	final bool isSelected;

  	const DrawerOption({
    	required this.icon,
    	required this.title,
    	required this.targetScreen,
    	this.isSelected = false,
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
                  					leading: Icon(option.icon),
									title: Text(option.title),
                  					selected: option.isSelected,
                  					onTap: ()
									{
                    					Navigator.pop(context); // Cierra el Drawer
                    					if (!option.isSelected)
										{
                      						Navigator.pushReplacement(
                        						context,
                        						MaterialPageRoute(builder: (context) => option.targetScreen),
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