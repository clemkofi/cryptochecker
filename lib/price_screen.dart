import 'package:cryptochecker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:rflutter_alert/rflutter_alert.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrencyValue = currenciesList[0];
  String coinPrice = '?';
  var cryptoPriceDict = new Map();
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    getCoinPrice(selectedCurrencyValue);
  }

  void getCoinPrice(String currency) async {
    try {
      String cryptoToUse =
          cryptoList.reduce((value, element) => value + ',' + element);
      var coinData = await CoinData().getCoinData(cryptoToUse, currency);

      if (coinData == 'no connection') {
        showErrorDialog();
        return;
      }

      setState(() {
        for (String crypto in cryptoList) {
          cryptoPriceDict[crypto] = coinData['$crypto$selectedCurrencyValue']
                  ['last']
              .toInt()
              .toString();
        }
      });
    } catch (e) {
      print(e);
      // showErrorDialog();
      return;
    }
  }

  void showErrorDialog() {
    // show the alert if there is no data
    Alert(
      context: context,
      title: "Something Went Wrong",
      desc: "Check your internet connection and try again!",
      image: Image.asset('images/error.png'),
      buttons: [
        DialogButton(
          child: Text(
            "Try Again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  // picker to show in iOS
  Widget iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.teal,
      itemExtent: 36.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrencyValue = currenciesList[selectedIndex];
        });
        getCoinPrice(selectedCurrencyValue);
      },
      children: currenciesList.map((currency) => new Text(currency)).toList(),
    );
  }

  // picker to show in android
  Widget androidPicker() {
    return DropdownButton(
      value: selectedCurrencyValue,
      items: currenciesList
          .map((currency) => new DropdownMenuItem(
                child: Text(currency),
                value: currency,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrencyValue = value;
        });
        getCoinPrice(selectedCurrencyValue);
      },
    );
  }

  List<Widget> cardGenerator() {
    return cryptoList
        .map(
          (crypto) => new CardCrypto(
            crypto: crypto,
            cryptoPrice: cryptoPriceDict[crypto],
            currencyValue: selectedCurrencyValue,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryto Price Checker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cardGenerator(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.teal,
            child: Platform.isIOS ? iOSPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}

class CardCrypto extends StatelessWidget {
  const CardCrypto({
    this.crypto,
    this.cryptoPrice,
    this.currencyValue,
  });

  final String crypto;
  final String cryptoPrice;
  final String currencyValue;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color(0xFFF44F03),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'images/$crypto.png',
                height: 80.0,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                '1 $crypto',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    '$cryptoPrice ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$currencyValue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
