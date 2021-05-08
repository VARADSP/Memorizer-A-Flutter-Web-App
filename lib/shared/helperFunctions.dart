import 'package:shared_preferences/shared_preferences.dart';
class HelperFunctions{

  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey="USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //saving data to sharedPreference
  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }


  static Future<bool> saveUserNameInSharedPreference(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailInSharedPreference(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //getting data from shared preference
  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }


  static Future<String> getUserNameInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  //clearing sharedPreference
  static Future<bool> clearSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

}