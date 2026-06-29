import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'shared_prefs.dart';
import '../../app/app_router.dart';
import 'package:samaj/generated/l10n.dart';

/// Returns true if the user is logged in (allowed to proceed).
/// If not logged in, shows a localized dialog prompting to login.
/// If the user confirms, navigates to the LoginRoute.
Future<bool> ensureLoggedIn(BuildContext context) async {
  final isLogin = await SharedPrefs.getLoginStatus();
  if (isLogin) return true;

  final shouldLogin = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(S.of(ctx).loginPromptTitle),
      content: Text(S.of(ctx).loginPromptMessage),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(S.of(ctx).loginPromptCancel)),
        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(S.of(ctx).loginPromptOk)),
      ],
    ),
  );

  if (shouldLogin == true) {
    context.router.push(const LoginRoute());
  }
  return false;
}
