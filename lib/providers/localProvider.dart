
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalProvider extends ChangeNotifier {
  String local = 'ar';

  setLocal(String newlocal)async{
    final prefs = await SharedPreferences.getInstance();
    if(newlocal == 'ar'){
      local = newlocal;
      await prefs.setString('local', newlocal);
    }else{
      local = 'en' ;
      await prefs.setString('local', 'en');
    }
    notifyListeners();
  }

  getStoredLocal()async{
    final prefs = await SharedPreferences.getInstance();
    local = await prefs.getString('local') ?? '';
    notifyListeners();
  }
}
