

import 'package:deepnotes/utilities/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog( BuildContext context){

return showGenericDialog<void>(context: context, title: 'Sharing', content: 'You cannot share Empty note!', optionBuilder: () => {
  'OK' : null,
});
}