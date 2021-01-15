import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_management/models/user.dart';
import 'package:qr_management/services/database.dart';
import 'package:qr_management/shared/constants.dart';
import 'package:qr_management/shared/loading.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({this.email, this.name,this.reference,this.date,this.index});
  final String email;
  final String name;
  final String reference;
  final index;
  final DateTime date;
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _datePrj;
  String _dateText;
  String name;
  String reference;

TextEditingController ctrName;
TextEditingController ctrRef;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datePrj = widget.date;
    _dateText = "${_datePrj.day}/${_datePrj.month}/${_datePrj.year}";
    ctrName = new TextEditingController(text: widget.name);
    ctrRef = new TextEditingController(text: widget.reference);
    name = widget.name;
    reference = widget.reference;
  }

  Future<Null> _selectDatePrj(BuildContext context) async {
    final picked = await showDatePicker(context: context,
        initialDate: _datePrj,
        firstDate: DateTime(2012),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _datePrj = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _editProject(){
    Firestore.instance.runTransaction((Transaction transaction) async{
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "name": name,
        "reference": reference,
        "date": _datePrj
      });
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your project data.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: ctrName,
                      decoration: textInputDecoration,
//                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      onChanged: ( String val) => setState(() => name = val),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: ctrRef,
                      decoration: textInputDecoration,
//                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      onChanged: (String val2) => setState(() => reference = val2),
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                          child: Text(_dateText, style: TextStyle(color: Colors.grey[600],fontSize: 16)),
                        ),
                        new IconButton(
                          icon: Icon(Icons.date_range,color: Color(0xff3282b8)),
                          onPressed: () => _selectDatePrj(context),
                        ),
                      ],
                    ),
                    // dropDown
//                DropdownButtonFormField(
//                    decoration: textInputDecoration,
//                    value: _currentReference ?? dataQr.reference,
//                    items: references.map((reference){
//                      return DropdownMenuItem(
//                        value: reference,
//                        child: Text('$reference'),
//                      );
//                    }).toList(),
//                    onChanged: (val) => setState(() => _currentReference = val)
//                ),
                    // slider
//                SizedBox(height: 20.0),
//                Slider(
//                  value: (_currentProjId ?? userData.projId).toDouble(),
//                  activeColor: Colors.cyan[_currentProjId ?? userData.projId],
//                  inactiveColor: Colors.cyan[_currentProjId ?? userData.projId],
//                  min : 100.0,
//                  max : 900.0,
//                  divisions: 8,
//                  onChanged: (val) => setState(() => _currentProjId = val.round()),
//                ),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                          _editProject();
                          }
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
//        } else {
//            return Loading();
//        }

//      }
//    );
  }
}
