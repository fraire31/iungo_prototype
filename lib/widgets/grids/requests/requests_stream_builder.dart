import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iungo_prototype/constants.dart';
import 'package:iungo_prototype/extensions/string.dart';
import 'package:iungo_prototype/models/requests/peticion.dart';

import '../../../screens/provider/request_detail_screen.dart';

class RequestsStreamBuilder extends StatefulWidget {
  const RequestsStreamBuilder({Key? key}) : super(key: key);

  @override
  _RequestsStreamBuilderState createState() => _RequestsStreamBuilderState();
}

class _RequestsStreamBuilderState extends State<RequestsStreamBuilder> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('peticiones')
            .where(
              'providers',
              arrayContains: _auth.currentUser!.uid,
            )
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          List<Widget> children;

          if (snapshot.hasError) {
            children = [
              Text('${snapshot.error}'),
            ];
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                children = const [
                  Text('Fetching Data'),
                  CircularProgressIndicator.adaptive(),
                ];

                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  children = [
                    Flexible(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final _data =
                              docs[index].data() as Map<String, dynamic?>;

                          final _request = Peticion.fromJson(_data);

                          // --- DATE FORMATTING - START-----
                          final _dateInSeconds = _request.fecha!.seconds * 1000;
                          final _date = DateTime.fromMillisecondsSinceEpoch(
                              _dateInSeconds);
                          final _dateFormattedMonth =
                              DateFormat.M().format(_date);
                          final _dateFormattedDay =
                              DateFormat.d().format(_date);
                          final _dateFormattedYear =
                              DateFormat.y().format(_date);

                          final _weekday = DateFormat.EEEE().format(_date);
                          late String _weekdayTrans;

                          switch (_weekday) {
                            case 'Monday':
                              _weekdayTrans = 'Lunes';
                              break;
                            case 'Tuesday':
                              _weekdayTrans = 'Martes';
                              break;
                            case 'Wednesday':
                              _weekdayTrans = 'Miercoles';
                              break;
                            case 'Thursday':
                              _weekdayTrans = 'Jueves';
                              break;
                            case 'Friday':
                              _weekdayTrans = 'Viernes';
                              break;
                            case 'Saturday':
                              _weekdayTrans = 'Sabado';
                              break;
                            case 'Sunday':
                              _weekdayTrans = 'Domingo';
                              break;

                            default:
                              _weekdayTrans = _weekday;
                              break;
                          }
                          // --- DATE FORMATTING - END-----

                          return GestureDetector(
                            onDoubleTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => RequestDetailScreen(
                                    petitionData: _data,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        )),
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12.0,
                                      left: 12.0,
                                      right: 12.0,
                                      bottom: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _request.tipoDeServicio!
                                                  .capitalizeEveryFirstLetter(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            kSizedBoxH10,
                                            Text(
                                              _request.nombreDeParte!
                                                  .capitalizeEveryFirstLetter(),
                                            ),
                                            Text(
                                              '${_request.vehiculo!['marca']} ${_request.vehiculo!['modelo']} ${_request.vehiculo!['ano']}'
                                                  .capitalizeEveryFirstLetter(),
                                            ),
                                            Text(
                                              '${_request.nombreDeUsuario}'
                                                  .capitalizeEveryFirstLetter(),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '$_weekdayTrans, $_dateFormattedDay/$_dateFormattedMonth/$_dateFormattedYear',
                                          style: const TextStyle(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 0,
                                        right: 12.0,
                                        bottom: 6.0,
                                      ),
                                      child: Text(
                                        _request.abierto as bool
                                            ? 'abierto'
                                            : 'cerrado',
                                        style: TextStyle(
                                          color: _request.abierto as bool
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ];
                } else {
                  children = const [
                    CircularProgressIndicator.adaptive(),
                  ];
                }

                break;
            }
          }
          return Center(
            child: Padding(
              padding: kScreenPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          );
        });
  }
}
