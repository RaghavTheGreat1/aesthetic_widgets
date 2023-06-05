import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AestheticLoaderButton extends StatefulWidget {
  const AestheticLoaderButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.checkConnectivity = true,
    this.isLoading,
    this.hapticFeedback = true,
  }) : super(key: key);

  final Widget label;
  final bool? isLoading;
  final Function onPressed;
  final bool checkConnectivity;
  final bool hapticFeedback;

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
    await widget.onPressed.call();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onLongPress: connectionStatus == ConnectivityResult.none ? null : () {},
      onPressed: connectionStatus == ConnectivityResult.none
          ? null
          : isLoading
              ? null
              : executeFunction,
      style: ButtonStyle(
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return Theme.of(context).colorScheme.primary;
        }),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
      child: renderButtonChild(),
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
