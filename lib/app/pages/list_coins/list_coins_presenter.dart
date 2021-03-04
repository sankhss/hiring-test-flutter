import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/coins_repository.dart';
import 'package:foxbit_hiring_test_template/domain/entities/coin.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/list_coins_usecase.dart';

class ListCoinsPresenter extends Presenter {

  Function listCoinsOnComplete;
  Function(dynamic) listCoinsOnError;
  Function(List<Coin>) listCoinsOnNext;

  final ListCoinsUseCase _listCoinsUseCase = ListCoinsUseCase(CoinsRepository());

  void list(FoxbitWebSocket ws) {
    _listCoinsUseCase.execute(_ListCoinsObserver(this), ws);
  }


  @override
  void dispose() {
    _listCoinsUseCase.dispose();
  }
}

class _ListCoinsObserver implements Observer<ListCoinsUseCaseResponse> {
  ListCoinsPresenter presenter;

  _ListCoinsObserver(this.presenter);

  @override
  void onNext(ListCoinsUseCaseResponse response) {
    assert(presenter.listCoinsOnNext != null);
    presenter.listCoinsOnNext(response.coins);
  }

  @override
  void onComplete() {
    assert(presenter.listCoinsOnComplete != null);
    presenter.listCoinsOnComplete();
  }

  @override
  void onError(dynamic e) {
    assert(presenter.listCoinsOnError != null);
    presenter.listCoinsOnError(e);
  }
}