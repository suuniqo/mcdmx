import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/domain/line.dart';
import 'package:mcdmx/domain/network.dart';
import 'package:mcdmx/domain/station.dart';

class Bgcard extends StatelessWidget {
  final Station parada;
  final Line linea;
  final TextStyle? style;
  final Color? color;
  final bool foward;


  Bgcard({required this.parada, this.style, this.color,required this.linea,required this.foward});
  
  @override
  Widget build(BuildContext context) {
  Direction direccion=linea.forwardDir;
  if(!foward){
    direccion=linea.backwardDir;
  }
    return Card(
      margin: EdgeInsets.zero,
      elevation: Format.elevation,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginCard),
        child:Column(
          children: [
            Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(parada.name, style: style),
                      SizedBox(width: 12),
                      SizedBox(width: 40,height: 40,child: Image.asset(parada.logo)),
                    ],
                  ),
            Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${direccion.nextArrivalDuration(parada)} min",style: style,),
                      SizedBox(width: 12),
                      Text("${direccion.nextArrivalDuration(parada)+Duration(minutes:linea.trainFreq)} min",style: style,),
                      SizedBox(width: 12),
                      Text("${direccion.nextArrivalDuration(parada)+Duration(minutes:2*linea.trainFreq)} min",style: style,),
                    ],
            ),
          ],
        ),
      ),                
    );
  }
}
