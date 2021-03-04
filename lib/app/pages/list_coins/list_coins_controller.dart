import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/pages/list_coins/list_coins_presenter.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/domain/entities/coin.dart';
import 'package:rxdart/rxdart.dart';

class ListCoinsController extends Controller {
  final ListCoinsPresenter presenter;
  final FoxbitWebSocket ws;

  final BehaviorSubject<List<Coin>> _coinsListStreamController =
      BehaviorSubject<List<Coin>>();
  Stream<List<Coin>> get coinsListStream => _coinsListStreamController.stream;

  ListCoinsController()
      : presenter = ListCoinsPresenter(),
        ws = FoxbitWebSocket() {
    ws.connect();
    presenter.list(ws);
  }

  @override
  void onDisposed() {
    ws.disconnect();
    _coinsListStreamController.close();
    super.onDisposed();
  }

  @override
  void initListeners() {
    presenter.listCoinsOnComplete = listCoinsOnComplete;
    presenter.listCoinsOnError = listCoinsOnError;
    presenter.listCoinsOnNext = listCoinsOnNext;
  }

  void listCoinsOnNext(List<Coin> coins) {
    _coinsListStreamController.add(coins);
  }

  void listCoinsOnComplete() {
    _scheduleNextUpdate();
  }

  void listCoinsOnError(dynamic e) {
    (getStateKey().currentState as ScaffoldState).showSnackBar(const SnackBar(
        duration: Duration(seconds: 10),
        content: Text('Não foi possível atualizar as moedas.')));

    _scheduleNextUpdate();
  }

  void _scheduleNextUpdate() {
    Timer(const Duration(seconds: 10), () {
      presenter.list(ws);
    });
  }
}
