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
    return Container(
      
      height: 300,
      width: MediaQuery.of(context).size.width * 0.915,
      child: Column(
        children: <Widget>[
          Divider(thickness: 0.2, color: Color(0xff2A353F),),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Assessment Results',
                style: TextStyle(
                  fontFamily: 'Proxima Nova',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 25, 19, 8),
                    ),
                  ),
                  trailing: Text(
                    '${compRaList[i].percentage}',
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffc54134),
                    ),
                  ),
                );
              },
              itemCount: compRaList.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
