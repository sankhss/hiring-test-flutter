import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/pages/list_coins/list_coins_controller.dart';
import 'package:foxbit_hiring_test_template/app/widgets/coin_tile.dart';
import 'package:foxbit_hiring_test_template/domain/entities/coin.dart';

class ListCoinsPage extends View {
  @override
  State<StatefulWidget> createState() => ListCoinsState();
}

class ListCoinsState extends ViewState<ListCoinsPage, ListCoinsController> {
  ListCoinsState() : super(ListCoinsController());

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: const Text('Cotação'),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: ControlledWidgetBuilder<ListCoinsController>(
            builder: (context, controller) {
          return StreamBuilder<List<Coin>>(
              stream: controller.coinsListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                final coins = snapshot.data;
                return ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: (ctx, i) {
                    return CoinTile(coins[i]);
                  },
                );
                } else {
                  return Container();
                }
              });
        }),
      );
}
