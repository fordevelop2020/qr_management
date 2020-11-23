import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_management/models/user.dart';
import 'package:qr_management/services/database.dart';
import 'package:qr_management/shared/constants.dart';
import 'package:qr_management/shared/loading.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> references = ['1', '2', '3', '4','5','Project 3'];

  //from values
  String _currentName;
  String _currentReference;
  String _currentImage ;
  int _currentProjId ;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      // ignore: missing_return
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your project settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0),
                // dropDown
                DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentReference ?? userData.reference,
                    items: references.map((reference){
                      return DropdownMenuItem(
                        value: reference,
                        child: Text('$reference'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentReference = val)
                ),
                // slider
                SizedBox(height: 20.0),
                Slider(
                  value: (_currentProjId ?? userData.projId).toDouble(),
                  activeColor: Colors.cyan[_currentProjId ?? userData.projId],
                  inactiveColor: Colors.cyan[_currentProjId ?? userData.projId],
                  min : 100.0,
                  max : 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentProjId = val.round()),
                ),
                RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentName ?? userData.name,
                            _currentReference ?? userData.reference,
                            _currentImage ?? userData.image,
                            _currentProjId ?? userData.projId
                        );
                        Navigator.pop(context);
                      }
                    }
                ),
              ],
            ),
          );
        } else {
            return Loading();
        }

      }
    );
  }
}
