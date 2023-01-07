import 'package:quizsystem/constant/message.dart';

validInput(String val, int min, int max) {
  if (val.isEmpty) {
    return messageInputEmpty;
  }
  if (val.length > max) {
    return "$messageInputMax $max";
  }
  if (val.length < min) {
    return "$messageInputMin $min";
  }
}

validInputSign(String valinput /*name of variable with text*/,
    String input /*Type of feild : email , password... */, int min, int max) {
  if (input.isEmpty) {
    return "$input cannot be empty";
  }
  if (valinput.length > max) {
    return "$valinput cannot be bigger than $max";
  }
  if (valinput.length < min) {
    return "$valinput cannot be smaller than $min";
  }
}
validInputQuestion(String valinput, int min, int max) {
  if (valinput.isEmpty) {
    return "This feild cannot be empty";
  }
  if (valinput.length > max) {
    return "Cannot be bigger than $max";
  }
  if (valinput.length < min) {
    return "Cannot be smaller than $min";
  }
}

