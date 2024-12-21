import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class FilterDialog extends StatefulWidget {
  final bool initialUserDeckFilter;
  final bool initialPublicDeckFilter;
  final bool initialCardFilter;
  final Function(bool, bool, bool) onFiltersChanged;

  FilterDialog({
    required this.initialUserDeckFilter,
    required this.initialPublicDeckFilter,
    required this.initialCardFilter,
    required this.onFiltersChanged,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late bool userDeckFilter;
  late bool publicDeckFilter;
  late bool cardFilter;

  @override
  void initState() {
    super.initState();
    userDeckFilter = widget.initialUserDeckFilter;
    publicDeckFilter = widget.initialPublicDeckFilter;
    cardFilter = widget.initialCardFilter;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Lọc kết quả tìm kiếm'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Bộ thẻ người dùng'),
            subtitle: Text('Hiển thị các bộ thẻ của người dùng'),
            value: userDeckFilter,
            contentPadding: EdgeInsets.only(left: 15, right: 10.0),
            onChanged: (bool value) {
              setState(() {
                userDeckFilter = value;
              });
            },
            secondary: const Iconify(
              Ic.baseline_lock_person,
              color: Colors.grey,
            ),
          ),
          SwitchListTile(
            title: const Text('Bộ thẻ công khai'),
            subtitle: Text('Hiển thị các bộ thẻ công khai'),
            value: publicDeckFilter,
            contentPadding: EdgeInsets.only(left: 15, right: 10.0),
            onChanged: (bool value) {
              setState(() {
                publicDeckFilter = value;
              });
            },
            secondary: const Iconify(Ic.baseline_public, color: Colors.blue),
          ),
          SwitchListTile(
            title: const Text('Thẻ'),
            subtitle: Text('Hiển thị các thẻ'),
            value: cardFilter,
            contentPadding: EdgeInsets.only(left: 15, right: 10.0),
            onChanged: (bool value) {
              setState(() {
                cardFilter = value;
              });
            },
            secondary: const Iconify(Mdi.cards_playing_club, color: Colors.red),
          )
        ],
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: EdgeInsets.only(left: 5, right: 15, bottom: 10),
      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'HỦY',
            style: TextStyle(
                fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            // Call the callback to pass the updated values
            widget.onFiltersChanged(
                userDeckFilter, publicDeckFilter, cardFilter);
            Navigator.of(context).pop();
          },
          child: Text(
            'CHẤP NHẬN',
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

void showFilterDialog(
  BuildContext context,
  bool initialUserDeckFilter,
  bool initialPublicDeckFilter,
  bool initialCardFilter,
  Function(bool, bool, bool) onFiltersChanged,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FilterDialog(
        initialUserDeckFilter: initialUserDeckFilter,
        initialPublicDeckFilter: initialPublicDeckFilter,
        initialCardFilter: initialCardFilter,
        onFiltersChanged: onFiltersChanged,
      );
    },
  );
}

void applyFilters(
  bool userDeckFilter,
  bool publicDeckFilter,
  bool cardFilter,
) {
  // Implement your logic to apply the selected filters
  print('User Deck Filter: $userDeckFilter');
  print('Public Deck Filter: $publicDeckFilter');
  print('Card Filter: $cardFilter');
}
