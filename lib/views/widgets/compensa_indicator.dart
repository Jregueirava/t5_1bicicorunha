import 'package:flutter/material.dart';

//Widget que muestra visualmente si "compensa bajar" a por una bici
//Recibe un mensaje de texto y un color que indica el estado
class CompensaIndicator extends StatelessWidget {
  //Texto que se mostrará (ej: "Sí - Hay 3 e-bike(s) disponible(s)")
  final String message;
  
  //Color de fondo y borde (verde, naranja o rojo según el caso)
  final Color color;

  const CompensaIndicator({
    super.key,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //spaciado interno del contenedor
      padding: const EdgeInsets.all(12),
      
      //Decoración visual: fondo con color semi-transparente y borde
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Fondo con 20% de opacidad
        borderRadius: BorderRadius.circular(8), // Esquinas redondeadas
        border: Border.all(color: color, width: 2), // Borde sólido del mismo color
      ),
      
      child: Row(
        children: [
          //Icono visual según el color
          Icon(_getIcon(), color: color, size: 32),
          
          const SizedBox(width: 12), // Espacio entre icono y texto
          
          //Texto explicativo
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Devuelve el icono apropiado según el color:
  //Verde → check_circle (✓)
  //Naranja → warning (⚠)
  //Rojo → cancel (✗)
  IconData _getIcon() {
    if (color == Colors.green) return Icons.check_circle;
    if (color == Colors.orange) return Icons.warning;
    return Icons.cancel;
  }
}
