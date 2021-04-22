import 'package:prs_staff/model/done_form.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class FinderBloc {
  final _repo = Repository();
  final _doneList = BehaviorSubject<DoneBaseModel>();

  Observable<DoneBaseModel> get doneList => _doneList.stream;

  getDoneList() async {
    DoneBaseModel result = await _repo.getDoneFinderForms();
    _doneList.sink.add(result);
  }

  dispose() {
    _doneList.close();
  }
}

final documentBloc = FinderBloc();
