import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:typed_data';

import 'package:multi_image_picker/multi_image_picker.dart';

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient _client;

  CloudApi(String json)
  : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name , Uint8List imgBytes) async
  {
    if(_client == null)
      _client = await auth.clientViaServiceAccount(_credentials,
          Storage.SCOPES);

    var storage = Storage(_client, 'QrManagement');
    var bucket = storage.bucket('bucket-images-qr');

//    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgBytes, metadata: ObjectMetadata(
      contentType: type,
//      custom: {
//        'timestamp': '$timestamp',
//      }
    ));
  }

//  Future<ObjectInfo> delete(String name) async{
//    var storage = Storage(_client, 'QrManagement');
//    var bucket01 = storage.bucket('bucket-images-qr');
//
//    return await bucket01.delete(name);
//  }


}