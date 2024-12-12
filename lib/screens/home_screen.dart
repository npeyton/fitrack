import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/config/colors.dart';
import 'package:fittrack/controllers/exercise_controller.dart';
import 'package:fittrack/models/day_model.dart';
import 'package:fittrack/screens/add_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/exercise_model.dart';
import '../models/graph_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ExerciseController _exerciseController;
  List<Graph> _graphs = [];
  List<RecordedDay> _days = [];
  bool _isLoading = true;

  @override
  void initState() {
    _exerciseController = context.read<ExerciseController>();
    getGraphs();
    _exerciseController.getExercises();
    _exerciseController.getDays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed("home.routine");
              },
              icon: const Icon(Icons.directions_run)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _exerciseController,
        builder: (a, b) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: _graphs.map((graph) {
                          return AspectRatio(
                            aspectRatio: 1.70,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 18,
                                left: 12,
                                top: 24,
                                bottom: 12,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        graph.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddGraph(
                                                        isEditing: true,
                                                        graph: graph,
                                                      )));
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: LineChart(
                                      mainData(graph),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //context.pushNamed("home.addRoutine");
          context.pushNamed("home.addGraph");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, int monthInterval) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    final now = DateTime.now();
    List<String> labels = [];

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    int currentMonth = now.month;

    // Generate month labels based on the interval
    if (monthInterval == 12) {
      // Last 12 months
      for (int i = 0; i < 12; i++) {
        int monthIndex = (currentMonth - i - 1) % 12;
        labels.insert(0, months[(monthIndex + 12) % 12]);
      }
      // Display labels at 0, 3, 6, and 11
      final displayIndices = [0, 120, 240, 360];

      Map<int, String> labelMap = {
        0: labels[0],
        120: labels[4],
        240: labels[8],
        360: labels[11],
      };

      int index = value.floor();
      Widget text = labelMap.containsKey(index)
          ? Text(labelMap[index]!, style: style)
          : const Text('', style: style); // Empty if out of bounds

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    } else if (monthInterval == 6) {
      // Last 6 months
      for (int i = 0; i < 6; i++) {
        int monthIndex = (currentMonth - i - 1) % 12;
        labels.insert(0, months[(monthIndex + 12) % 12]);
      }

      Map<int, String> labelMap = {
        0: labels[0],
        35: labels[1],
        65: labels[2],
        95: labels[3],
        130: labels[4],
        180: labels[5],
      };

      int index = value.floor();
      Widget text = labelMap.containsKey(index)
          ? Text(labelMap[index]!, style: style)
          : const Text('', style: style); // Empty if out of bounds

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    } else if (monthInterval == 3) {
      // Define the overall start and end date (90 days back to today)
      DateTime startDate = DateTime.now().subtract(Duration(days: 90));
      DateTime endDate = DateTime.now();

      labels = getMonthsBetween(startDate, endDate);

      // Last 3 months
      // for (int i = 0; i < 3; i++) {
      //   int monthIndex = (currentMonth - i - 1) % 12;
      //   labels.insert(0, months[(monthIndex + 12) % 12]);
      // }

      Map<int, String> labelMap = {
        10: labels[0],
        45: labels[1],
        80: labels[2],
      };

      int index = value.floor();
      Widget text = labelMap.containsKey(index)
          ? Text(labelMap[index]!, style: style)
          : const Text('', style: style); // Empty if out of bounds

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    } else if (monthInterval == 1) {
      // Last month - show date labels in "Month Day" format
      final startDate = DateTime(now.year, now.month - 1, now.day);
      final endDate = now;

      // Calculate total days and select key days for labels
      int totalDays = endDate.difference(startDate).inDays + 1;
      int step = (totalDays / 4).ceil();

      for (int i = 0; i < totalDays; i += step) {
        DateTime date = startDate.add(Duration(days: i));
        labels.add('${months[date.month - 1]} ${date.day}');
      }
      if (labels.length < 5) {
        DateTime date = startDate.add(Duration(days: totalDays));
        labels.add('${months[date.month - 1]} ${date.day}');
      }

      Map<int, String> labelMap = {
        0: labels[0],
        9: labels[1],
        18: labels[3],
        27: labels.last, // Ensure we have the last date as well
      };

      int index = value.floor();
      Widget text = labelMap.containsKey(index)
          ? Text(labelMap[index]!, style: style)
          : const Text('', style: style); // Empty if out of bounds

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    } else {
      // If monthInterval is not 1, 3, 6, or 12, return an empty widget
      return const SizedBox.shrink();
    }
  }

  List<String> getMonthsBetween(DateTime startDate, DateTime endDate) {
    List<String> months = [];
    DateTime currentDate = DateTime(startDate.year, startDate.month);

    // Iterate until we reach the end date
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      String monthYear =
          '${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}';
      months.add(monthYear);

      // Move to the next month
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    return months;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0KG';
        break;
      case 40:
        text = '40KG';
        break;
      case 80:
        text = '80KG';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(Graph g) {
    List<FlSpot> spots = [];

    List<DateTime> dates = [];
    List<int> values = [];

    for (var day in _days) {
      if (DateTime.now().difference(day.createdAt).inDays <
          g.timeFrameInMonth * 30) {
        if (day.recordedDataList
            .where((data) => data.id == g.exerciseId)
            .isNotEmpty) {
          values.add(day.recordedDataList
              .singleWhere((data) => data.id == g.exerciseId)
              .weightVal);
          dates.add(day.createdAt);
        }
      }
    }

    DateTime startDate =
        DateTime.now().subtract(Duration(days: g.timeFrameInMonth * 30));
    DateTime endDate = DateTime.now();
    int totalDays = endDate.difference(startDate).inDays;

    dates.sort();
    // Normalize the dates within the range [startDate, endDate] to values between 0 and 90
    List<FlSpot> spotLocal = dates.asMap().entries.map((entry) {
      int index = entry.key;
      DateTime date = entry.value;

      // Calculate the xPosition for the date, scaled to fit within 0-90
      int daysFromStart = date.difference(startDate).inDays;
      double xPosition = (daysFromStart / totalDays) *
          g.timeFrameInMonth *
          30; // Scales to 0-90 range

      return FlSpot(xPosition, values[index] + 0.0);
    }).toList();

    spots = spotLocal;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black45,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black.withOpacity(.05),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (a, meta) =>
                bottomTitleWidgets(a, meta, g.timeFrameInMonth),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: g.timeFrameInMonth * 30,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots.map((spot) {
            return spot;
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: Colors.blue, end: Colors.indigo).lerp(0.2)!,
              ColorTween(begin: Colors.blue, end: Colors.indigo).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: Colors.blue, end: Colors.indigo).lerp(0.2)!,
                ColorTween(
                        begin: Colors.blue.withOpacity(.3),
                        end: Colors.indigo.withOpacity(.2))
                    .lerp(0.2)!,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getGraphs() async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance
        .collection("DayLogEntries")
        .where("user", isEqualTo: userRef)
        .get()
        .then((snapshots) {
      for (var doc in snapshots.docs) {
        RecordedDay day = RecordedDay.fromJson(doc.data());
        _days.add(day);
      }
      debugPrint(_days.last.recordedDataList.first.name);
    });

    FirebaseFirestore.instance
        .collection("Graphs")
        .where("user_ref", isEqualTo: userRef)
        .snapshots()
        .listen((documentSnapshot) {
      _graphs.clear();
      for (var doc in documentSnapshot.docs) {
        Graph graph = Graph.fromMap(doc);
        _graphs.add(graph);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
}
