// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../components/using_func.dart';
import 'params_bottom.dart';

class ParamsBody extends StatefulWidget {
  Map<String, dynamic> responseList;
  int index;
  String type;
  ParamsBody(this.responseList, this.index, this.type, {Key key})
      : super(key: key);

  @override
  State<ParamsBody> createState() => _ParamsBodyState();
}

class _ParamsBodyState extends State<ParamsBody> {
  List<String> form = <String>['', '', '', '', '', '', '', '', '', ''];
  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss.S');
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 150,
        ),
        Image.network(
          widget.responseList['logo'],
          scale: 3,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          widget.responseList['${widget.type}s'][widget.index]['desc'],
          style: GoogleFonts.montserrat(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        if (widget.responseList['${widget.type}s'][widget.index]['params'] !=
            null)
          Container(
            height: 380,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  itemCount: widget
                      .responseList['${widget.type}s'][widget.index]['params']
                      .length,
                  itemBuilder: (BuildContext context, int index_) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            widget.responseList['${widget.type}s'][widget.index]
                                ['params'][index_]['desc'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.responseList['${widget.type}s'][widget.index]
                                ['params'][index_]['type'] ==
                            'datetime')
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: DateTimeField(
                              format: format,
                              onShowPicker: (BuildContext context,
                                  DateTime currentValue) async {
                                final DateTime date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  final TimeOfDay time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
                                  );
                                  form.insert(
                                      index_,
                                      DateTimeField.combine(date, time)
                                          .toUtc()
                                          .toString());
                                  return DateTimeField.combine(date, time);
                                } else {
                                  return currentValue;
                                }
                              },
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              onChanged: (String value) {
                                form[index_] = value;
                              },
                              cursorColor: Colors.white,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: getColorFromHex('222222'),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  borderSide: BorderSide(
                                      color: getColorFromHex('2f3239')),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  borderSide: BorderSide(
                                      color: getColorFromHex('2f3239'),
                                      width: 0.5),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }))
        else
          Container(),
        Expanded(
          child: ParamsBottom(
              widget.type, form, widget.responseList, widget.index),
        ),
      ],
    );
  }
}
