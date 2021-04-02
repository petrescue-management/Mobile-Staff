import 'package:prs_staff/model/user_model.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc {
  final _repo = Repository();
  final _userDetails = BehaviorSubject<UserModel>();
  final _accountJWT = BehaviorSubject<String>();
  final _updateUserDetails = BehaviorSubject<bool>();

  Observable<UserModel> get userDetail => _userDetails.stream;
  Observable<String> get accountJWT => _accountJWT.stream;
  Observable<bool> get updateUserDetails => _updateUserDetails.stream;

  getJWT(String fbToken, String deviceToken) async {
    String jwt = await _repo.getJWT(fbToken, deviceToken);
    _accountJWT.sink.add(jwt);
  }

  getDetail() async {
    UserModel user = await _repo.getUserDetails();
    _userDetails.sink.add(user);
  }

  updateUserDetail(UserModel user) async {
    bool result = await _repo.updateUserDetails(user);
    _updateUserDetails.sink.add(result);
  }

  dispose() {
    _userDetails.close();
    _accountJWT.close();
    _updateUserDetails.close();
  }
}

final accountBloc = AccountBloc();
