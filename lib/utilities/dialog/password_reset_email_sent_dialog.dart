
import 'package:deepnotes/utilities/dialog/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showPasswordResetSentDialog ( BuildContext context){

  return showGenericDialog<void>(context: context, title: 'Password Reset',
   content: 'We have sent you a password reset link. Check your mail for more information.' , 

   optionBuilder: () => {
    'OK' : null,
   });


}

