import 'package:flutter/material.dart';

extension ScaffoldMessengerStateUtils on ScaffoldMessengerState {
  void toast(String message) {
    showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void toastButton(String message, onPressed) {
    showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Text(
                message,
                maxLines: 6,
              ),
            ),
            IconButton(onPressed: onPressed, icon: const Icon(Icons.refresh)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
