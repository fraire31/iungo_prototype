import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:iungo_prototype/extensions/string.dart';

import '../../constants.dart';
import '../../models/requests/peticion.dart';
import '../../models/vehiculo.dart';

class RequestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> petitionData;
  const RequestDetailScreen({Key? key, required this.petitionData})
      : super(key: key);

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _data = Peticion.fromJson(widget.petitionData);
    final _vehicle = Vehiculo.fromJson(_data.vehiculo!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: kScreenPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _data.tipoDeServicio!.capitalizeEveryFirstLetter(),
                style: kMediumBoldText,
              ),
              kSizedBoxH25,
              if (_data.fotos != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: LimitedBox(
                    maxHeight: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      key: UniqueKey(),
                      itemBuilder: (BuildContext context, int index) {
                        return InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: _data.fotos![index],
                            imageBuilder: (context, imageProvider) => Image(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator.adaptive()),
                            ),
                            errorWidget: (context, url, error) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.error),
                                    Text('Error al cargar imagen.')
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      itemCount: _data.fotos!.length,
                    ),
                  ),
                ),
              ],
              Row(
                children: [
                  Text(
                    _data.nombreDeUsuario!.capitalizeEveryFirstLetter(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    ' esta buscando:',
                    // style: kRegularText,
                  ),
                ],
              ),
              kSizedBoxH10,
              Row(
                children: [
                  const Text('Nombre de parte: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_data.nombreDeParte.toString()),
                ],
              ),
              Row(
                children: [
                  const Text('Cantidad: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_data.cantidad.toString()),
                ],
              ),
              Row(
                children: [
                  const Text('Marca: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    (_data.marca == null || _data.marca!.isEmpty)
                        ? 'not provided'
                        : _data.marca!,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Numero de parte: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    (_data.numeroDeParte == null ||
                            _data.numeroDeParte!.isEmpty)
                        ? 'not provided'
                        : _data.numeroDeParte!,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Descripcion: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    (_data.descripcion == null || _data.descripcion!.isEmpty)
                        ? 'not provided'
                        : _data.descripcion!,
                  ),
                ],
              ),
              kSizedBoxH25,
              Text('Informacion de vehiculo: ', style: kMediumBoldText),
              kSizedBoxH10,
              Row(
                children: [
                  const Text('Marca: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.marca),
                ],
              ),
              Row(
                children: [
                  const Text('Modelo: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.modelo),
                ],
              ),
              Row(
                children: [
                  const Text('Año: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.ano.toString()),
                ],
              ),
              Row(
                children: [
                  const Text('Version: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    (_vehicle.version == null || _vehicle.version!.isEmpty)
                        ? 'not provided'
                        : _vehicle.version!,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Transmision: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.transmission),
                ],
              ),
              Row(
                children: [
                  const Text('Traccion: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.traccion),
                ],
              ),
              Row(
                children: [
                  const Text('Numero de motor: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.numeroDeMotor),
                ],
              ),
              Row(
                children: [
                  const Text('Tipo de motor: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_vehicle.tipoDeMotor),
                ],
              ),
              Row(
                children: [
                  const Text('Vin/Serie: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    (_vehicle.vin == null || _vehicle.vin!.isEmpty)
                        ? 'not provided'
                        : _vehicle.vin!,
                  ),
                ],
              ),
              kSizedBoxH25,
              Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        textDirection: TextDirection.ltr,
                      ),
                      onPressed: () {},
                      label: Text(
                        'Cotizar',
                        style: kButtonText.copyWith(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
