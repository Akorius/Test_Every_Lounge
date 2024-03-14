import 'dart:async';

import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/lounge/flight_direction.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/search_bar.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/airport_item.dart';
import 'package:everylounge/presentation/widgets/inputs/date_picker_field.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:everylounge/presentation/widgets/inputs/time_picker_field.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class FlightStepBody extends StatefulWidget {
  final bool? isFirst;
  final String? flightDirection;
  final String? countryCode;
  final String? airportCode;
  final FlightTextFieldData data;
  final AirportDestinationType type;
  final Function? onTapForScroll;

  const FlightStepBody({
    super.key,
    required this.flightDirection,
    required this.countryCode,
    required this.airportCode,
    required this.data,
    required this.type,
    this.isFirst,
    this.onTapForScroll,
  });

  @override
  State<FlightStepBody> createState() => _FlightStepBodyState();
}

class _FlightStepBodyState extends State<FlightStepBody> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController aeroController = TextEditingController();
  var _isShowedAeroList = false;
  late StreamSubscription<bool> keyboardSubscription;
  var _isKeyboardVisible = false;

  @override
  void initState() {
    keyboardSubscription = KeyboardVisibilityController().onChange.listen((bool visible) {
      _isKeyboardVisible = visible;
      if (_isKeyboardVisible && focusNode.hasFocus) {
        widget.onTapForScroll?.call();
      }
    });
    focusNode.addListener(
      () => setState(
        () {
          _isShowedAeroList = focusNode.hasFocus;
          widget.onTapForScroll?.call();
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isFirst == null || widget.isFirst == true
              ? Text(
                  "Данные рейса",
                  style: context.textStyles.h1(color: context.colors.textBlue),
                )
              : Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: context.colors.lightDashBorder,
                ),
          if (widget.isFirst != null)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                "Рейс ${widget.isFirst == true ? '1' : '2'}",
                style: context.textStyles.textNormalRegular(color: context.colors.textDefault.withOpacity(0.6)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: DefaultTextField(
              controller: widget.data.flightNumberController,
              keyboardType: TextInputType.text,
              onChanged: (text) => onChanged(),
              errorText: widget.data.flightNumberError,
              hint: "Номер рейса",
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DatePickerField(
                  initialDate: widget.data.initialDate ?? DateTime.now(),
                  firstDate: widget.data.initialDate ?? DateTime.now(),
                  lastDate: (widget.data.initialDate ?? DateTime.now()).add(const Duration(days: 365)),
                  hint: "Дата",
                  onDateSelected: (dateTime) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.data.date = dateTime;
                    onChanged.call();
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TimePickerField(
                  hint: "Время",
                  onTimeSelected: (time) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.data.time = time;
                    onChanged.call();
                  },
                ),
              ),
            ],
          ),
          widget.data.flightDateError != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.data.flightDateError!,
                      style: context.textStyles.textNormalRegular(color: context.colors.textError),
                    )
                  ],
                )
              : const SizedBox.shrink(),
          Padding(
            padding: EdgeInsets.only(top: widget.data.flightDateError != null ? 0 : 12, bottom: 8),
            child: Text(
              widget.type == AirportDestinationType.departure ? "Куда направляетесь" : "Откуда прилетаете",
              style: context.textStyles.textNormalRegularGrey(),
            ),
          ),
          SearchBarWidget(
            hint: "Аэропорт",
            padding: EdgeInsets.zero,
            searchAirports: (trimmedValue) => context.read<SearchAirportCubit>().getSearchAirports(text: trimmedValue),
            onClearSearch: () => {
              aeroController.text = '',
              widget.data.airport = null,
              context.read<SearchAirportCubit>().getSearchAirports(),
            },
            focusNode: focusNode,
            controller: aeroController,
          ),
          BlocBuilder<SearchAirportCubit, SearchAirportState>(
            builder: (context, state) {
              List<Airport> list =
                  aeroController.text.isNotEmpty ? state.airportListSearch.toList() : state.airportListNearby.toList();
              list.removeWhere((element) => element.code == widget.airportCode);
              if (widget.flightDirection == FlightDirection.internFlightDirection) {
                list.removeWhere((element) => element.countryCode == widget.countryCode);
              }
              if (widget.flightDirection == FlightDirection.domesticFlightDirection) {
                list.removeWhere((element) => element.countryCode != widget.countryCode);
              }
              return _isShowedAeroList
                  ? Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.colors.lightDashBorder,
                        ),
                        borderRadius:
                            const BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                        color: Colors.white,
                      ),
                      height: 176,
                      child: aeroController.text.isNotEmpty && state.isLoadingSearch
                          ? const AppCircularProgressIndicator()
                          : ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                ...list.map(
                                  (e) => GestureDetector(
                                    onTap: () => {
                                      aeroController.text = '${e.name.isNotEmpty ? e.name : e.city} (${e.code})',
                                      widget.data.airport = e,
                                      onChanged.call(),
                                      focusNode.unfocus()
                                    },
                                    child: AirportItemWidget(
                                      e,
                                      backgroundColor: null,
                                      margin: const EdgeInsets.only(bottom: 0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  onChanged() {
    setState(() {
      context.read<CreateOrderPremiumCubit>().onFlightDataChanged(widget.data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    keyboardSubscription.cancel();
  }
}
