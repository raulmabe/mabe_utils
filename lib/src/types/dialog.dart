/// Represents the possible values usually used in Dialogs.
enum AppDialogAction {
  /// Represents the user has confirmed the action
  confirm,

  /// Represents the user has canceled the action
  cancel;

  /// Returns `true` if this == confirm.
  bool get hasConfirmed => this == confirm;
}

/// Returns a String based on the [AppDialogAction] passed through parameters
typedef AppDialogActionTextBuilder = String Function(AppDialogAction action);
