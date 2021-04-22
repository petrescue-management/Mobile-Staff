import 'package:prs_staff/model/finder_form/finder_form_base_model.dart';
import 'package:prs_staff/model/finder_form/finder_form_processing.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class FinderBloc {
  final _repo = Repository();
  final _waitingList = BehaviorSubject<FinderFormBaseModel>();
  final _processingList = BehaviorSubject<FinderFormProcessingModel>();
  final _deliveringList = BehaviorSubject<FinderFormProcessingModel>();

  Observable<FinderFormBaseModel> get waitingList => _waitingList.stream;
  Observable<FinderFormProcessingModel> get processingList => _processingList.stream;
  Observable<FinderFormProcessingModel> get deliveringList => _deliveringList.stream;

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

  dispose() {
    _waitingList.close();
    _processingList.close();
    _deliveringList.close();
  }
}

final finderBloc = FinderBloc();
