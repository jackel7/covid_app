import 'package:covid_app/Model/world_states_model.dart';
import 'package:covid_app/View/countries_list.dart';
import 'package:covid_app/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = [
    const Color(0xff4205F4),
    const Color(0xff1aa268),
    const Color(0xffde5246),
  ];
  StatesServices _services = StatesServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              FutureBuilder(
                future: _services.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  if (!snapshot.hasData) {
                    return Expanded(
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(
                              snapshot.data!.cases!.toString(),
                            ),
                            "Recovered": double.parse(
                              snapshot.data!.recovered!.toString(),
                            ),
                            "Death": double.parse(
                              snapshot.data!.deaths!.toString(),
                            ),
                          },
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          ringStrokeWidth: 10,
                          chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          animationDuration: Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                          legendOptions: LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                ReuseableRow(
                                  title: 'Total Cases',
                                  value: snapshot.data!.cases!.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Death',
                                  value: snapshot.data!.deaths!.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered!.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Active',
                                  value: snapshot.data!.active!.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Critical',
                                  value: snapshot.data!.critical!.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Today Deaths',
                                  value: snapshot.data!.todayDeaths!.toString(),
                                ),
                                ReuseableRow(
                                  title: 'Today recovered',
                                  value: snapshot.data!.todayRecovered!
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountriesList(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Track Countries",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title, value;
  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [Text(title), Text(value)],
          ),

          SizedBox(height: 5),
          Divider(color: Colors.red),
        ],
      ),
    );
  }
}
