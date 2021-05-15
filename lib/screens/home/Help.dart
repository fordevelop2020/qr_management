

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help ?"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Administrator area (architect):",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.start, style:TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold,fontSize: 16.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Authentication:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.start,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("You can connect either after creating new identifiers or with an existing email address, and in case of forgetting you can always click on the link "
                  'Forget password'" and you will receive a link on your inbox to reset the password. password from your account.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15.0,),
              Text("After authentication, please add your company logo, your signature and your website (optional) in the 'My profile' section.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("My projects :",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("In order to consult the details of your created projects, and to view them in PDF format with "
                  "the possibility of saving and printing with your logo, and your signature (My profile),"
                  " and with a QR code automatically generated for each project created."
                "To delete a project, all you have to do is swipe the target project to the left and confirm the deletion.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Scan QR Code:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("By clicking on 'Scan QR Code' "
                  "you scan the generated and printed QR code of a project, and you view the results by clicking on",
                overflow:TextOverflow.ellipsis,
                maxLines: 10,textAlign: TextAlign.justify,
              ),
              Icon(Icons.remove_red_eye),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Project tile:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("For consulting a project, and viewing all plan and 3ds images of the project, "
                  "and downloading documents and attachments, and modify it if necessary using the button.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              Icon(Icons.edit),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("New Project:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("In order to add a new project in three fundamental phases, it is necessary to click on 'Continue' in each step to validate the data.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("My files:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("Here you find all the uploaded documents concerning all the projects in order to download them if necessary.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Client Area :",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold,fontSize: 16.0)
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Authentication:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("No authentication required to access the application. All you have to do is click on 'Client Area'.",
                overflow:TextOverflow.ellipsis,
                maxLines: 50,textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Scan QR Code:",
                    overflow:TextOverflow.ellipsis,
                    maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0) ,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Text("By clicking on 'Scan QR Code' "
                  "you scan the generated and printed QR code of a project, and you view the results by clicking on",
                overflow:TextOverflow.ellipsis,
                maxLines: 10,textAlign: TextAlign.justify,
              ),
              Icon(Icons.remove_red_eye),
              SizedBox(height: 15.0,),
//            Text("PS: as a client, you cannot modify, add or delete a project,"
//                " you have the right to consult the given project through a QR code from your architect (admin).",
//              overflow:TextOverflow.ellipsis,
//              maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 14.0) ,
//            ),
//              SizedBox(height: 25.0,),

            Text("For any informations or suggestions please contact us by email via: fordevelop2020@gmail.com",
              overflow:TextOverflow.ellipsis,
              maxLines: 50,textAlign: TextAlign.justify,style:TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 14.0) ,
            ),
              SizedBox(height: 25.0,),
            ],
          ),

        ),
      ),
    );
  }
}
