import 'package:employee_management_app/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final bool isEndDatePicker;

  const CustomDatePicker({super.key, required this.isEndDatePicker});
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if(widget.isEndDatePicker)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickSelectButton(StringConstants.noDate, null),
                  const SizedBox(height: 16,),
                  _quickSelectButton(StringConstants.today, DateTime.now()),

                ],
              ),
            ),
            if(!widget.isEndDatePicker)
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   _quickSelectButton(StringConstants.today, DateTime.now()),
                   const SizedBox(height: 16,),
                   _quickSelectButton(StringConstants.nextTuesday, _getNextWeekday(2)),

                 ],
               ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   _quickSelectButton(StringConstants.nextMonday, _getNextWeekday(1)),
                   const SizedBox(height: 16,),
                   _quickSelectButton(StringConstants.afterOneWeek,
                       DateTime.now().add(const Duration(days: 7))),
                 ],
               ),
             ],
           ),
         ),

          // Calendar picker
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),


const Divider(),
          // Cancel and Save buttons
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Expanded(
                  child: ListTile(
                    title: Text(
                      _selectedDate != null ?
                      DateFormat('dd MMM yyyy').format(_selectedDate?? DateTime.now()): StringConstants.noDate,),
                    leading: const Icon(Icons.calendar_today,color: Colors.blue,size: 20,),
                    titleTextStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),

                ElevatedButton(
                  style:  const ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6)))),
                      backgroundColor: WidgetStatePropertyAll(Colors.lightBlue)
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(StringConstants.cancel,style: TextStyle(color: Colors.white),),
                ),
               const SizedBox(width: 10,),
                ElevatedButton(
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6)))),
                    backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(_selectedDate);
                  },
                  child: const Text(StringConstants.saveButton,style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get next Monday, Tuesday, etc.
  DateTime _getNextWeekday(int weekday) {
    DateTime date = DateTime.now();
    while (date.weekday != weekday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }


  Widget _quickSelectButton(String label, DateTime? date) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          print(_selectedDate);
        });
      },
      child: Container(
        constraints:const BoxConstraints(minHeight: 35, minWidth: 130,),
        decoration: BoxDecoration(
          border: Border.all( width: 1.0,color: Colors.transparent),
          borderRadius: BorderRadius.circular(6.0),
          color: _selectedDate == date ? Colors.blue : Colors.lightBlue,
        ),
        child: Center(child: Text(label,style: const TextStyle(color: Colors.white),)),

      ),
    );
  }
}
