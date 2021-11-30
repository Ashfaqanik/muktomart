import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/profile_model.dart';
import 'package:mukto_mart/repo/profile_repo.dart';

class ProfileProvider extends ChangeNotifier{
  ProfileRepo _profileRepo=ProfileRepo();
  Customers _userProfile;

  get profileRepo => _profileRepo;
  Customers get userProfile => _userProfile;

  Future<void> fetch(String userId)async {
    var result = await _profileRepo.getProfileData(userId);
    _userProfile=result;
    notifyListeners();
  }
  Future<void> fetchProfileData(String phone)async {
    var result = await _profileRepo.getProfileDataByPhone(phone);
    _userProfile=result;
    notifyListeners();
  }

  Future<void> fetchProfileDataByEmail(String email)async {
    var result = await _profileRepo.getProfileDataByEmail(email);
    _userProfile=result;
    print(_userProfile.user.email);
    notifyListeners();
  }
}