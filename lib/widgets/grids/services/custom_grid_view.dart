import 'package:flutter/material.dart';
import 'package:iungo_prototype/extensions/string.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../enums.dart' as enums;
import '../../../models/services/servicio.dart';
import '../../../providers/services/services_provider.dart';
import '../../../screens/user/request/parts_request_screen.dart';

class CustomGridView extends StatefulWidget {
  const CustomGridView({Key? key}) : super(key: key);

  @override
  _CustomGridViewState createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  enums.serviceOptions _serviceOption = enums.serviceOptions.parts;
  String? _serviceSelected;
  List<Servicio>? _options;

  void _updateList(enums.serviceOptions option) {
    setState(() {
      _serviceOption = option;
      _options = Provider.of<ServicesProvider>(context, listen: false)
          .getServicesByOption(_serviceOption);
    });
  }

  void _startRequest() {
    Navigator.pushNamed(context, PartsRequestScreen.screenId,
        arguments: {'serviceName': _serviceSelected});
  }

  @override
  Widget build(BuildContext context) {
    final _services = Provider.of<ServicesProvider>(context, listen: false);
    _options = _services.getServicesByOption(_serviceOption);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.tertiary,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () {
                    _updateList(enums.serviceOptions.parts);
                  },
                  child: Text(
                    'Partes',
                    style: _serviceOption == enums.serviceOptions.parts
                        ? kActiveOption
                        : kOption,
                  ),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: MaterialStateProperty.all(0),
                  )),
              TextButton(
                  onPressed: () {
                    _updateList(enums.serviceOptions.services);
                  },
                  child: Text(
                    'Servicios',
                    style: _serviceOption == enums.serviceOptions.services
                        ? kActiveOption
                        : kOption,
                  ),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: MaterialStateProperty.all(0),
                  )),
            ],
          ),
        ),
        Flexible(
          child: Padding(
            padding: kScreenPadding,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _options?.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Theme.of(context).colorScheme.tertiary,
                  onDoubleTap: () {
                    _serviceSelected = _options![index].nombre;
                    _startRequest();
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Image.asset(
                            'assets/images/placeholders/blue_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            _options![index]
                                .nombre
                                .capitalizeEveryFirstLetter(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
