import 'dart:io';
import 'package:muscuapp/application/state.dart' as state;

getDefaultHeader() {
  return {
    HttpHeaders.authorizationHeader: state.token,
    HttpHeaders.contentTypeHeader: 'application/json'
  };
}
