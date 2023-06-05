import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AestheticLoaderButton extends StatefulWidget {
  const AestheticLoaderButton({
    Key? key,
    this.size,
    required this.label,
    required this.onPressed,
    this.checkConnectivity = true,
    this.isLoading,
    this.hapticFeedback = true,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.statesController,
  }) : super(key: key);

  final Size? size;
  final Widget label;
  final bool? isLoading;
  final Function()? onPressed;
  final bool checkConnectivity;
  final bool hapticFeedback;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus = false;
  final Clip clipBehavior = Clip.none;
  final MaterialStatesController? statesController;

  @override
  State<AestheticLoaderButton> createState() => _AestheticLoaderButtonState();
}

class _AestheticLoaderButtonState extends State<AestheticLoaderButton> {
  ConnectivityResult connectionStatus = ConnectivityResult.wifi;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isLoading ?? false;
    if (widget.checkConnectivity) {
      connectivity.checkConnectivity().then((value) {
        setState(() {
          connectionStatus = value;
        });
      });
      connectivitySubscription = connectivity.onConnectivityChanged
          .listen((ConnectivityResult result) {
        setState(() {
          connectionStatus = result;
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant AestheticLoaderButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      setState(() {
        isLoading = widget.isLoading ?? false;
      });
    }
  }

  @override
  void dispose() {
    if (widget.checkConnectivity) {
      connectivitySubscription.cancel();
    }
    super.dispose();
  }

  void executeFunction() async {
    if (widget.hapticFeedback) {
      await HapticFeedback.mediumImpact();
    }
    setState(() {
      isLoading = true;
    });
    await widget.onPressed?.call();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: ElevatedButton(
        onLongPress: connectionStatus == ConnectivityResult.none
            ? null
            : widget.onLongPress,
        onPressed: connectionStatus == ConnectivityResult.none
            ? null
            : isLoading
                ? null
                : executeFunction,
        style: widget.style != null
            ? widget.style!.copyWith(
                foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimary),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return Theme.of(context).colorScheme.primary;
                }),
              )
            : ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimary),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return Theme.of(context).colorScheme.primary;
                }),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
        statesController: widget.statesController,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        onHover: widget.onHover,
        onFocusChange: widget.onFocusChange,
        child: renderButtonChild(),
      ),
    );
  }

  Widget renderButtonChild() {
    if (isLoading) {
      return const SpinKitChasingDots(
        color: Colors.white,
        size: 25,
      );
    } else {
      if (widget.checkConnectivity) {
        if (connectionStatus == ConnectivityResult.none) {
          return const Text('NO INTERNET');
        } else {
          return widget.label;
        }
      } else {
        return widget.label;
      }
    }
  }
}
