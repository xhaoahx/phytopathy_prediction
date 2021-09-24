typedef ErrorHandler(Object e,StackTrace s);

void errorPrintHandler(Object e,StackTrace s){
  print('an error<$e> has happened');
  print('there is call stack:$s');
}