import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/size_config.dart';

import '../theme.dart';

class TaskTile extends StatelessWidget {
   const TaskTile({Key? key, this.task}) : super(key: key);
  final Task? task ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.orientation == Orientation.landscape ? 4 : 8),
      padding: EdgeInsets.all(
          SizeConfig.orientation == Orientation.landscape ? 8 : 10),
      width: getProportionateScreenWidth(
        SizeConfig.orientation == Orientation.landscape
            ? SizeConfig.screenWidth / 2
            : SizeConfig.screenWidth,
      ),
      decoration: BoxDecoration(
        color: task!.color == 0
            ? primaryClr
            : task!.color == 1
            ? pinkClr
            : orangeClr,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  right: SizeConfig.orientation == Orientation.landscape
                      ? 8
                      : 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task!.title}',
                    style: titleStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[100],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${task!.startTime}  -  ${task!.endTime}',
                        style: subTitleStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${task!.note}',
                    textAlign: TextAlign.justify,
                    style: subTitleStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 0 ? 'TODO' : 'Completed',
              style: subTitleStyle.copyWith(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
