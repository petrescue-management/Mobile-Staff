import 'package:prs_staff/model/finder_form/finder_form_base_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_processing.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class FinderBloc {
  final _repo = Repository();
  final _waitingList = BehaviorSubject<FinderFormBaseModel>();
  final _processingList = BehaviorSubject<FinderFormProcessingModel>();
  final _deliveringList = BehaviorSubject<FinderFormProcessingModel>();
  final _doneList = BehaviorSubject<FinderFormProcessingModel>();

  Observable<FinderFormBaseModel> get waitingList => _waitingList.stream;
  Observable<FinderFormProcessingModel> get processingList => _processingList.stream;
  Observable<FinderFormProcessingModel> get deliveringList => _deliveringList.stream;
  Observable<FinderFormProcessingModel> get doneList => _doneList.stream;

  getWaitingList() async {
    FinderFormBaseModel result = await _repo.getWaitingFinderForms();
    _waitingList.sink.add(result);
  }

  getProcessingList() async {
    FinderFormProcessingModel result = await _repo.getProcessingFinderForms();
    _processingList.sink.add(result);
  }

  getDeliveringList() async {
    FinderFormProcessingModel result = await _repo.getDeliveringFinderForms();
    _deliveringList.sink.add(result);
  }

  getDoneList() async {
    FinderFormProcessingModel result = await _repo.getDoneFinderForms();
    _doneList.sink.add(result);
  }

  dispose() {
    _waitingList.close();
    _processingList.close();
    _deliveringList.close();
    _doneList.close();
  }
}

final finderBloc = FinderBloc();
