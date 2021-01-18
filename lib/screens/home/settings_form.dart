

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_management/models/user.dart';
import 'package:qr_management/services/database.dart';
import 'package:qr_management/shared/constants.dart';
import 'package:qr_management/shared/loading.dart';
import 'package:qr_management/widgets/textfield_widget.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({this.email, this.name,this.reference,this.date,this.index,this.localisation,
  this.mo, this.moDelegate, this.bet, this.topograph, this.customer, this.phase, this.clues, this.comments, this.manager, this.details});
  final String email;
  final String name;
  final String reference;
  final index;
  final DateTime date;
  final String localisation;
  final String mo;
  final String moDelegate;
  final String bet;
  final String topograph;
  final String customer;
  final String phase;
  final String clues;
  final String comments;
  final String manager;
  final String details;

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _datePrj;
  String _dateText;
  String name;
  String reference;
  String localisation;
   String mo;
   String moDelegate;
   String bet;
   String topograph;
   String customer;
   String phase;
   String clues;
   String comments;
   String manager;
   String details;

TextEditingController ctrName;
TextEditingController ctrRef;
TextEditingController ctrLocal;
TextEditingController ctrMo;
TextEditingController ctrMoD;
TextEditingController ctrBet;
TextEditingController ctrTopo;
TextEditingController ctrCust;
TextEditingController ctrPhase;
TextEditingController ctrClu;
TextEditingController ctrComm;
TextEditingController ctrManager;
TextEditingController ctrDetails;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrName = new TextEditingController(text: widget.name);
    ctrRef = new TextEditingController(text: widget.reference);
    ctrLocal = new TextEditingController(text: widget.localisation);
    ctrBet = new TextEditingController(text: widget.bet);
    ctrClu = new TextEditingController(text: widget.clues);
    ctrComm = new TextEditingController(text: widget.comments);
    ctrCust = new TextEditingController(text: widget.customer);
    ctrManager= new TextEditingController(text: widget.manager);
    ctrMo = new TextEditingController(text: widget.mo);
    ctrMoD = new TextEditingController(text: widget.moDelegate);
    ctrPhase = new TextEditingController(text: widget.phase);
    ctrTopo = new TextEditingController(text: widget.topograph);
    ctrDetails = new TextEditingController(text: widget.details);


    _datePrj = widget.date;
    _dateText = "${_datePrj.day}/${_datePrj.month}/${_datePrj.year}";
    name = widget.name;
    reference = widget.reference;
    localisation = widget.localisation;
    bet = widget.bet;
    clues = widget.clues;
    comments = widget.comments;
    customer = widget.customer;
    manager = widget.manager;
    mo = widget.mo;
    moDelegate = widget.moDelegate;
    phase = widget.phase;
    topograph = widget.topograph;
    details = widget.details;


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
        "date": _datePrj,
        "location": localisation,
        "bet" : bet,
        "clues" : clues,
        "comments": comments,
        "customer": customer,
        "responsible" : manager,
        "mo" : mo,
        "moDelegate" : moDelegate,
        "phase" : phase,
        "topo" : topograph,
        "details" : details
      });
    });
    Navigator.pop(context);
  }

  Widget _showImages(){

}
  @override
  Widget build(BuildContext context) {
return Scaffold(
            appBar: AppBar(
              title: Text("Update your project data"),
              backgroundColor: Color(0xff0f4c75),
            ),
            body:  Form(
              key: _formKey,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: ctrName,
                        decoration:new InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                           labelText: 'Name project',
                         ),
                         validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                         onChanged: ( String val) => setState(() => name = val),
                       ),

                           SizedBox(height: 15.0),
//                                       new Padding(
//                                         padding: const EdgeInsets.all(16.0),
                               TextFormField(
                                controller: ctrRef,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Reference',
                                ),
                                onChanged: (String val2) => setState(() => reference = val2),
                            ),
                                   SizedBox(height: 15.0),
                         TextFormField(
                                controller: ctrLocal,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Localisation',
                                ),
                                onChanged: (String val) => setState(() => localisation = val),
                            ),
                                   SizedBox(height: 15.0),
                        TextFormField(
                                controller: ctrMo,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Mo',
                                ),
                                onChanged: (String val2) => setState(() => mo = val2),
                            ),
                                   SizedBox(height: 15.0),
                         TextFormField(
                                controller: ctrMoD,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'MoDelegate',
                                ),
                                onChanged: (String val2) => setState(() => moDelegate = val2),
                            ),
                                   SizedBox(height: 15.0),
                          TextFormField(
                                controller: ctrCust,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Customer',
                                ),
                                onChanged: (String val2) => setState(() => customer = val2),
                            ),
                                   SizedBox(height: 15.0),
                           TextFormField(
                                controller: ctrBet,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'BET',
                                ),
                                onChanged: (String val2) => setState(() => bet = val2),
                            ),
                                   SizedBox(height: 15.0),
                          TextFormField(
                                controller: ctrTopo,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Topographer',
                                ),
                                onChanged: (String val2) => setState(() => topograph = val2),
                            ),
                                   SizedBox(height: 15.0),
                          TextFormField(
                                controller: ctrPhase,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Phase',
                                ),
                                onChanged: (String val2) => setState(() => phase = val2),
                            ),
                                   SizedBox(height: 15.0),
                         TextFormField(
                                controller: ctrClu,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Clues',
                                ),
                                onChanged: (String val2) => setState(() => clues = val2),
                            ),
                                   SizedBox(height: 15.0),
                           TextFormField(
                                controller: ctrManager,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Manager',
                                ),
                                onChanged: (String val2) => setState(() => manager = val2),
                            ),
                                   SizedBox(height: 15.0),
                          TextFormField(
                                controller: ctrDetails,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Details',
                                ),
                                onChanged: (String val2) => setState(() => details = val2),
                            ),
                                   SizedBox(height: 15.0),
                          TextFormField(
                                controller: ctrComm,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                  labelText: 'Comments',
                                ),
                                onChanged: (String val2) => setState(() => comments = val2),
                            ),
                                   SizedBox(height: 15.0),
                         Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: TextFormField(
                                        initialValue: _dateText,
                                    decoration:InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                      labelText: 'Date project',
                                      suffixIcon: new IconButton(
                                        icon: Icon(Icons.date_range,color: Color(0xff3282b8)),
                                        onPressed: () => _selectDatePrj(context),
                                      ),
                                    ) ,
                                    ),
                                  ),

                                ],
                            ),
                                   SizedBox(height: 15.0),
                          _showImages(),

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
                    color: Color(0xff0f4c75),
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
            ),
                  );
}
}
