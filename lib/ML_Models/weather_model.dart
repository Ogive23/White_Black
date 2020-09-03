import 'dart:io';
import 'package:stats/stats.dart';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';

class ClothesDecideModel {
  List<String> outlookData = [
    'sunny',
    'sunny',
    'clouds',
    'rain',
    'rain',
    'snow',
    'clouds',
    'sunny',
    'sunny',
    'rain',
    'sunny',
    'clouds',
    'clouds',
    'extreme',
    'clouds',
    'sunny',
    'clouds'
  ];
  List<double> temperatureData = [
    27.3,
    30.1,
    25.2,
    19.3,
    18.5,
    10.4,
    21.7,
    29.5,
    23.1,
    17.3,
    27.8,
    20.1,
    19.8,
    7.1,
    17.85,
    20.0,
    32.0
  ];
  List<double> humidityData = [
    0.55,
    0.25,
    0.35,
    0.08,
    0.40,
    0.49,
    0.88,
    0.8,
    0.44,
    0.41,
    0.31,
    0.9,
    0.44,
    0.89,
    0.68,
    0.4,
    0.7
  ];
  List<double> windData = [
    5.7056,
    14.176,
    4.7056,
    5.7056,
    6.7056,
    13.176,
    12.176,
    3.7056,
    2.7056,
    6.7056,
    12.176,
    13.176,
    6.7056,
    14.176,
    2.6,
    5.0,
    4.0
  ];
  List<String> decision = [
    'yes',
    'yes',
    'no',
    'no',
    'no',
    'no',
    'yes',
    'yes',
    'yes',
    'no',
    'yes',
    'yes',
    'no',
    'no',
    'no',
    'no',
    'yes'
  ]; //wear white?

  readPreviousData() async {
    List<String> fileNames = [
      'outlook',
      'temperature',
      'humidity',
      'windSpeed',
      'decision'
    ];
    try {
      final directory = await getApplicationDocumentsDirectory();
      for (int fileIndex = 0; fileIndex < fileNames.length; fileIndex++) {
        final file =
            File('${directory.path}/${fileNames.elementAt(fileIndex)}.txt');
        String text = await file.readAsString();
        List<String> values = text.split(' ');
        values.removeLast(); //remove last space
        switch (fileIndex) {
          case 0:
            values.forEach((value) {
              outlookData.add(value);
            });
            break;
          case 1:
            values.forEach((value) {
              temperatureData.add(double.parse(value));
            });
            break;
          case 2:
            values.forEach((value) {
              humidityData.add(double.parse(value));
            });
            break;
          case 3:
            values.forEach((value) {
              windData.add(double.parse(value));
            });
            break;
          case 4:
            values.forEach((value) {
              decision.add(value);
            });
            break;
        }
      }
    } catch (e) {
      print("thing Couldn't read file");
    }
  }

  /// get probability for outlook
  List<double> getOutlookProbability(
      outlookTestValue, double totalYes, double totalNo) {
    double yesCounter = 0;
    double noCounter = 0;
    for (int i = 0; i < outlookData.length; i++) {
      if (outlookTestValue == outlookData.elementAt(i) &&
          decision.elementAt(i) == 'yes') {
        yesCounter++;
      } else if (outlookTestValue == outlookData.elementAt(i) &&
          decision.elementAt(i) == 'no') {
        noCounter++;
      }
    }
    return [yesCounter / totalYes, noCounter / totalNo];
  }

  getProbability(list, testValue) {
    final stats = Stats.fromData(list);
    return (1 / (math.sqrt(2 * math.pi) * (stats.standardDeviation))) *
        (math.exp(-math.pow((testValue - stats.average), 2) /
            (2 * (math.pow(stats.standardError, 2)))));
  }

  Future<String> test(outlookTestValue, temperatureTestValue, humidityTestValue,
      windTestValue) async {
    await readPreviousData();
    List<List<double>> allData = // to prevent looping 3 times
        [temperatureData, humidityData, windData];
    List<double> testList = [
      temperatureTestValue,
      humidityTestValue,
      windTestValue
    ];
    List<double> yesProbability =
        new List<double>(); //yes probability for each criteria
    List<double> noProbability =
        new List<double>(); //no probability for each criteria

    double totalYes = 0;
    double totalNo = 0;

    for (int i = 0; i < decision.length; i++) {
      if (decision.elementAt(i) == 'yes') {
        totalYes++;
      } else if (decision.elementAt(i) == 'no') {
        totalNo++;
      }
    }

    List<double> outlookProbability =
        getOutlookProbability(outlookTestValue, totalYes, totalNo);
    yesProbability.add(outlookProbability.elementAt(0));
    noProbability.add(outlookProbability.elementAt(1));

    // for each criteria divide elements based on decision
    List<List<double>> decisionYes = new List<List<double>>();
    List<List<double>> decisionNo = new List<List<double>>();

    //for each of data in each criteria get referred decision
    allData.forEach((criteria) {
      List<double> listOfYes = new List<double>();
      List<double> listOfNo = new List<double>();
      for (int index = 0; index < criteria.length; index++) {
        if (decision.elementAt(index) == 'yes') {
          listOfYes.add(criteria.elementAt(index));
        } else if (decision.elementAt(index) == 'no') {
          listOfNo.add(criteria.elementAt(index));
        }
      }
      decisionYes.add(listOfYes);
      decisionNo.add(listOfNo);
    });

    // get the probabilities for the other criteria [windSpeed ,etc..]
    for (int i = 0; i < allData.length; i++) {
      yesProbability
          .add(getProbability(decisionYes.elementAt(i), testList.elementAt(i)));
      noProbability
          .add(getProbability(decisionNo.elementAt(i), testList.elementAt(i)));
    }

    double resultYes = 1;
    double resultNo = 1;
    yesProbability.forEach((element) {
      resultYes =
          resultYes * (element == 0 ? (1 / 4) / (totalYes + 1) : element);
    });
    noProbability.forEach((element) {
      resultNo = resultNo * (element == 0 ? (1 / 4) / (totalNo + 1) : element);
    });
    if (resultYes > resultNo)
      return 'yes';
    else
      return 'no';
  }
}
