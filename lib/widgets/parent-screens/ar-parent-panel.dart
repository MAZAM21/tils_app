import 'package:flutter/material.dart';
import 'package:tils_app/service/ranking-service.dart';

class ARParentPanel extends StatelessWidget {
  const ARParentPanel({
    Key key,
    @required this.compRaList,
  }) : super(key: key);

  final List<AssessmentResult> compRaList;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 5),
            ],
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 196, 187, 175).withOpacity(0.3),
                Color.fromARGB(255, 40, 48, 68).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Text(
                'Assessment Results',
                style: TextStyle(
                  fontFamily: 'Proxima Nova',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 25, 19, 8),
                ),
              ),
              Container(
                height: 175,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      leading: Text(
                        '${compRaList[i].title}',
                        style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 25, 19, 8),
                        ),
                      ),
                      trailing: Text(
                        '${compRaList[i].percentage}',
                        style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 25, 19, 8),
                        ),
                      ),
                    );
                  },
                  itemCount: compRaList.length ?? 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
