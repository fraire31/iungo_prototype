import 'package:flutter/material.dart';
import 'package:iungo_prototype/constants.dart';

import '../../../enums.dart' as enums;
import '../../../widgets/grids/requests/requests_stream_builder.dart';

class ProviderHomeView extends StatefulWidget {
  const ProviderHomeView({Key? key}) : super(key: key);

  @override
  _ProviderHomeViewState createState() => _ProviderHomeViewState();
}

class _ProviderHomeViewState extends State<ProviderHomeView> {
  final enums.providerView _view = enums.providerView.requests;

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                child: Text(
                  'Peticiones',
                  style: _view == enums.providerView.requests
                      ? kActiveOption
                      : kOption,
                ),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Cotizas',
                  style: _view == enums.providerView.quotes
                      ? kActiveOption
                      : kOption,
                ),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          // toggle requestBuilder and quoteBuilder
          child: RequestsStreamBuilder(),
        ),
      ],
    );
  }
}
