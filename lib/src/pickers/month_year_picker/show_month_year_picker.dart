import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'elements/common.dart';
import 'elements/locale_utils.dart';
import 'elements/month_selector.dart';
import 'elements/year_selector.dart';

/// Displays month picker dialog.
/// [initialDate] is the initially selected month.
/// [firstDate] is the optional lower bound for month selection.
/// [lastDate] is the optional upper bound for month selection.
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Locale? locale,
}) async {
  final localizations = locale == null
      ? MaterialLocalizations.of(context)
      : await GlobalMaterialLocalizations.delegate.load(locale);
  return await showDialog<DateTime>(
    context: context,
    builder: (context) => Center(
      child: _MonthPickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        locale: locale,
        localizations: localizations,
      ),
    ),
  );
}

class _MonthPickerDialog extends StatefulWidget {
  final DateTime? initialDate, firstDate, lastDate;
  final MaterialLocalizations localizations;
  final Locale? locale;

  const _MonthPickerDialog({
    Key? key,
    required this.initialDate,
    required this.localizations,
    this.firstDate,
    this.lastDate,
    this.locale,
  }) : super(key: key);

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  final GlobalKey<YearSelectorState> _yearSelectorState = GlobalKey();
  final GlobalKey<MonthSelectorState> _monthSelectorState = GlobalKey();

  PublishSubject<UpDownPageLimit>? _upDownPageLimitPublishSubject;
  PublishSubject<UpDownButtonEnableState>?
      _upDownButtonEnableStatePublishSubject;

  Widget? _selector;
  DateTime? selectedDate, _firstDate, _lastDate;

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateTime(widget.initialDate!.year, widget.initialDate!.month);
    if (widget.firstDate != null) {
      _firstDate = DateTime(widget.firstDate!.year, widget.firstDate!.month);
    }
    if (widget.lastDate != null) {
      _lastDate = DateTime(widget.lastDate!.year, widget.lastDate!.month);
    }
    _upDownPageLimitPublishSubject = PublishSubject();
    _upDownButtonEnableStatePublishSubject = PublishSubject();

    _selector = MonthSelector(
      key: _monthSelectorState,
      openDate: selectedDate!,
      selectedDate: selectedDate!,
      upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
      upDownButtonEnableStatePublishSubject:
          _upDownButtonEnableStatePublishSubject!,
      firstDate: _firstDate,
      lastDate: _lastDate,
      onMonthSelected: _onMonthSelected,
      locale: widget.locale,
    );
  }

  @override
  void dispose() {
    _upDownPageLimitPublishSubject!.close();
    _upDownButtonEnableStatePublishSubject!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var locale = getLocale(context, selectedLocale: widget.locale);
    var header = buildHeader(theme, locale);
    var pager = buildPager(theme, locale);
    var content = Material(
      color: theme.cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [pager, buildButtonBar(context)],
      ),
    );
    return Theme(
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Colors.transparent),
      child: Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(27.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Builder(
                builder: (context) {
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    return IntrinsicWidth(
                      child: Column(children: [header, content]),
                    );
                  }
                  return IntrinsicHeight(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [header, content]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonBar(
    BuildContext context,
  ) {
    return ButtonBar(
      children: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Text(widget.localizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedDate),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Text(widget.localizations.okButtonLabel),
        )
      ],
    );
  }

  Widget buildHeader(ThemeData theme, String locale) {
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat.yMMM(locale).format(selectedDate!),
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _selector is MonthSelector
                    ? GestureDetector(
                        onTap: _onSelectYear,
                        child: StreamBuilder<UpDownPageLimit>(
                          stream: _upDownPageLimitPublishSubject,
                          initialData: const UpDownPageLimit(0, 0),
                          builder: (_, snapshot) => Text(
                            DateFormat.y(locale)
                                .format(DateTime(snapshot.data!.upLimit)),
                            style: theme.textTheme.headlineMedium!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    : StreamBuilder<UpDownPageLimit>(
                        stream: _upDownPageLimitPublishSubject,
                        initialData: const UpDownPageLimit(0, 0),
                        builder: (_, snapshot) => Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              DateFormat.y(locale)
                                  .format(DateTime(snapshot.data!.upLimit)),
                              style: theme.textTheme.headlineMedium!.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              ' - ',
                              style: theme.textTheme.headlineMedium!.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              DateFormat.y(locale)
                                  .format(DateTime(snapshot.data!.downLimit)),
                              style: theme.textTheme.headlineMedium!.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                StreamBuilder<UpDownButtonEnableState>(
                  stream: _upDownButtonEnableStatePublishSubject,
                  initialData: const UpDownButtonEnableState(true, true),
                  builder: (_, snapshot) => Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_up,
                          color: snapshot.data!.upState
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        onPressed:
                            snapshot.data!.upState ? _onUpButtonPressed : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: snapshot.data!.downState
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        onPressed: snapshot.data!.downState
                            ? _onDownButtonPressed
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPager(ThemeData theme, String locale) {
    return SizedBox(
      height: 230.0,
      width: 300.0,
      child: Theme(
        data: theme.copyWith(
          buttonTheme: const ButtonThemeData(
            padding: EdgeInsets.all(2.0),
            shape: CircleBorder(),
            minWidth: 4.0,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: _selector,
        ),
      ),
    );
  }

  void _onSelectYear() => setState(() => _selector = YearSelector(
        key: _yearSelectorState,
        initialDate: selectedDate!,
        firstDate: _firstDate,
        lastDate: _lastDate,
        onYearSelected: _onYearSelected,
        upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
        upDownButtonEnableStatePublishSubject:
            _upDownButtonEnableStatePublishSubject!,
      ));

  void _onYearSelected(final int year) => setState(() {
        selectedDate = DateTime(year, selectedDate!.month);
        _selector = MonthSelector(
          key: _monthSelectorState,
          openDate: DateTime(year),
          selectedDate: selectedDate!,
          upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
          upDownButtonEnableStatePublishSubject:
              _upDownButtonEnableStatePublishSubject!,
          firstDate: _firstDate,
          lastDate: _lastDate,
          onMonthSelected: _onMonthSelected,
          locale: widget.locale,
        );
      });

  void _onMonthSelected(final DateTime date) => setState(() {
        selectedDate = date;
        _selector = MonthSelector(
          key: _monthSelectorState,
          openDate: selectedDate!,
          selectedDate: selectedDate!,
          upDownPageLimitPublishSubject: _upDownPageLimitPublishSubject!,
          upDownButtonEnableStatePublishSubject:
              _upDownButtonEnableStatePublishSubject!,
          firstDate: _firstDate,
          lastDate: _lastDate,
          onMonthSelected: _onMonthSelected,
          locale: widget.locale,
        );
      });

  void _onUpButtonPressed() {
    if (_yearSelectorState.currentState != null) {
      _yearSelectorState.currentState!.goUp();
    } else {
      _monthSelectorState.currentState!.goUp();
    }
  }

  void _onDownButtonPressed() {
    if (_yearSelectorState.currentState != null) {
      _yearSelectorState.currentState!.goDown();
    } else {
      _monthSelectorState.currentState!.goDown();
    }
  }
}
