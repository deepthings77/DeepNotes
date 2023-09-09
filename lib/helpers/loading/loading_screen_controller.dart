import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingscreen = bool Function();
typedef UpdateLoadingscreen = bool Function(String text);


@immutable
class LoadingScreenController {
  final CloseLoadingscreen close;
  final UpdateLoadingscreen update;

  const  LoadingScreenController({required this.close,required this.update});
  

  
}