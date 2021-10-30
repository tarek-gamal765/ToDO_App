import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/drop_down_button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController? _titleController = TextEditingController();
  final TextEditingController? _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now());
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));

  String selectRemind = '5';
  List<String> remindList = ['5', '10', '15', '20'];
  String selectRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int selectedColor = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: customAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InputField(
                  title: 'Title',
                  hint: 'Enter title here',
                  controller: _titleController,
                  validate: (value) {
                    if (value.toString().trim().isEmpty) {
                      return 'required field';
                    }
                  },
                ),
                InputField(
                  title: 'Note',
                  hint: 'Enter note here',
                  controller: _noteController,
                  validate: (value) {
                    if (value.toString().trim().isEmpty) {
                      return 'required field';
                    }
                  },
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(selectedDate),
                  widget: IconButton(
                    onPressed: getDateFromUser,
                    icon: const Icon(Icons.calendar_today_outlined),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: startTime,
                        widget: IconButton(
                          onPressed: ()=>getTimeFromUser(isStartTime: true),
                          icon: const Icon(Icons.access_time_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: endTime,
                        widget: IconButton(
                          onPressed:()=> getTimeFromUser(isStartTime: false),
                          icon: const Icon(Icons.access_time_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                InputField(
                  title: 'Remind',
                  hint: '$selectRemind minutes early',
                  widget: dropDownButton(
                    color: context.theme.backgroundColor,
                    list: remindList,
                    select: selectRemind,
                    onChanged: (value) {
                      setState(() {
                        selectRemind = value!;
                      });
                    },
                  ),
                ),
                InputField(
                  title: 'Repeat',
                  hint: selectRepeat,
                  widget: dropDownButton(
                    color: context.theme.backgroundColor,
                    list: repeatList,
                    select: selectRepeat,
                    onChanged: (value) {
                      setState(() {
                        selectRepeat = value!;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    colorPalette(),
                    MyButton(
                      text: 'Create Task',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addTaskToDatabase();
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar customAppBar() => AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0.0,
        actions: const [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              'images/person.jpeg',
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      );

  Row colorPalette() => Row(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
              },
              child: CircleAvatar(
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                child: selectedColor == index
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ),
      );


  getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2014),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        print(pickedDate.toString());
        selectedDate = pickedDate;
      });
    } else{
      return selectedDate;
    }
  }

  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    if (pickedTime != null) {
      setState(() {
        isStartTime
            ? startTime = pickedTime.format(context)
            : endTime = pickedTime.format(context);
      });
    }
  }
  addTaskToDatabase() async {
    TaskController().addTask(Task(
      title: _titleController!.text,
      note: _noteController!.text,
      startTime: startTime,
      endTime: endTime,
      color: selectedColor,
      isCompleted: 0,
      remind: int.parse(selectRemind),
      repeat: selectRepeat,
      date: selectedDate.toString(),
    ));
  }

}
