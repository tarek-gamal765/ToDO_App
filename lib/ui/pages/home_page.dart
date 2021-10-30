import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/custom_snackbar.dart';
import 'package:todo/ui/widgets/task_tile.dart';
import 'package:todo/ui/widgets/text_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    NotifyHelper().initializeNotification();
    taskController.getTasks();
    super.initState();
  }

  TaskController taskController = TaskController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            addTaskBar(),
            addDateBar(),
            taskController.taskList.isNotEmpty ? showTasks() : noTasks(),
          ],
        ),
      ),
    );
  }

  customAppBar() => AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              size: 30,
            ),
            color: Get.isDarkMode ? white : Colors.black,
            onPressed: () {
              Get.defaultDialog(
                middleText: 'Do you want to delete all tasks ?',
                title: 'Delete',
                titleStyle: TextStyle(color: Colors.red[400]!),
                actions: [
                  customTextButton(
                    color: Colors.red[400]!,
                    text: 'Cancel',
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  customTextButton(
                    color: Get.isDarkMode ? white : darkGreyClr,
                    text: 'Ok',
                    onPressed: () {
                      NotifyHelper().cancelAllNotifications();
                      taskController.deleteAllTasks();
                      Get.back();
                      if (taskController.taskList.isNotEmpty)
                        customSnackBar(
                          title: 'Done !',
                          message: 'All tasks deleted successfully',
                        );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              'images/person.jpeg',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        leading: IconButton(
          onPressed: () {
            ThemeServices().changeTheme();
          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_outlined,
          ),
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      );

  addTaskBar() => Container(
        margin: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                    style: subHeadingStyle),
                Text('Today', style: subHeadingStyle),
              ],
            ),
            MyButton(
              text: '+ Add Task',
              onPressed: () async {
                await Get.to(() => const AddTaskPage());
                taskController.getTasks();
              },
            ),
          ],
        ),
      );

  addDateBar() => Container(
        margin: const EdgeInsets.only(top: 15),
        child: DatePicker(
          DateTime.now(),
          initialSelectedDate: selectedDate,
          selectionColor: primaryClr,
          selectedTextColor: white,
          monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          height: 100,
          width: 70,
          onDateChange: (newDate) {
            setState(() {
              selectedDate = newDate;
            });
          },
        ),
      );

  noTasks() => Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 10)
                      : const SizedBox(height: 100),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 100,
                    color: primaryClr.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  Text(
                    'you don\'t have added any task yet.',
                    style: subTitleStyle.copyWith(color: Colors.grey),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 10)
                      : const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      );

  Future<void> onRefresh() async {
    await taskController.getTasks();
  }

  showTasks() => Expanded(
        child: Obx(
          () => ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: taskController.taskList.length,
            itemBuilder: (context, index) {
              var task = taskController.taskList[index];
              var taskTime = DateFormat.jm().parse(task.startTime!);
              String myDate = DateFormat('HH:mm').format(taskTime);
              NotifyHelper().scheduledNotification(
                int.parse(myDate.split(':')[0]),
                int.parse(myDate.split(':')[1]),
                task,
              );
              if ((task.repeat == 'None' &&
                      DateFormat.yMd().format(DateTime.parse(task.date!)) ==
                          DateFormat.yMd().format(selectedDate)) ||
                  (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(selectedDate)) ||
                  (task.repeat == 'Monthly' &&
                      DateTime.parse(task.date!).day == selectedDate.day) ||
                  (DateTime.parse(task.date!).difference(selectedDate).inDays %
                              7 ==
                          0 &&
                      task.repeat == 'Weekly')) {
                return InkWell(
                  onTap: () {
                    showBottomSheet(
                      task,
                    );
                  },
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(
                      milliseconds: 700,
                    ),
                    child: SlideAnimation(
                      horizontalOffset: 100,
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: TaskTile(
                          task: task,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      );

  buildBottomSheet({
    required String text,
    Color? color,
    required GestureTapCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 60,
          width: SizeConfig.screenWidth * 0.9,
          decoration: BoxDecoration(
            color: color ?? primaryClr,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Get.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!),
          ),
          child: Center(
            child: Text(
              text,
              style: titleStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      );

  showBottomSheet(Task task) => Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth * 0.9,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.6)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.3
                  : SizeConfig.screenHeight * 0.39),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              task.isCompleted == 1
                  ? Container()
                  : buildBottomSheet(
                      text: 'Task Completed',
                      onTap: () {
                        taskController.update(task.id);
                        NotifyHelper().cancelNotification(task.id!);
                        Get.back();
                      },
                    ),
              buildBottomSheet(
                text: 'Delete',
                color: Colors.red[400],
                onTap: () {
                  NotifyHelper().cancelNotification(task.id!);
                  taskController.deleteTask(task);

                  Get.back();
                  customSnackBar(
                    title: 'Done !',
                    message: '${task.title} task deleted successfully',
                  );
                },
              ),
              buildBottomSheet(
                text: 'Cancel',
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      );
}
