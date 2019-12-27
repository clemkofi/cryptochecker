import 'package:cryptochecker/services/networking.dart';
import 'package:cryptochecker/utilities/constants.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(String crypto, String currency) async {
    // Network Helper to do network requests
    NetworkHelper networkHelper = NetworkHelper('$kBitAverageApi?crypto=$crypto&fiat=$currency');

    // check internet connection before returning any results
    var checkConnectivity = await networkHelper.checkInternetConnection();
    if(checkConnectivity == 'connected'){
      var coinInfo = await networkHelper.getData();
      return coinInfo;
    } else {
      return checkConnectivity;
    }
    
  }
}
