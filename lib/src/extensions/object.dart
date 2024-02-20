import 'dart:developer' as devtools show log;

/// Sets an Ansii style to the following text.
const kAnsiiRedBackground = '\x1b[101m';

/// Sets an Ansii style to the following text.
const kAnsiiGreenBackground = '\x1b[102m';

/// Sets an Ansii style to the following text.
const kAnsiiBlackText = '\x1b[30m';

/// Sets an Ansii style to the following text.
const kAnsiiDefault = '\x1b[0m';

/// Adds a method to easily log the value of this object.
extension Logger on Object? {
  /// Logs the value of this object. When null a red background is painted.
  void log([String? s]) {
    final intro = s ?? '';
    String value;

    if (this == null) {
      value = '$kAnsiiRedBackground$kAnsiiBlackText NULL $kAnsiiDefault';
    } else {
      value = '$kAnsiiGreenBackground$kAnsiiBlackText $this $kAnsiiDefault';
    }

    devtools.log('$intro $value');
  }
}



// In text terminals and shells that support ANSI escape codes, you can configure text and background colors using specific sequences. These sequences typically start with an escape character followed by a sequence of numbers that specify the color and formatting options. The basic ANSI colors and their corresponding codes for foreground (text) and background are as follows:

// ### Standard Text Colors (Foreground)
// - **Black:** `\x1b[30m`
// - **Red:** `\x1b[31m`
// - **Green:** `\x1b[32m`
// - **Yellow:** `\x1b[33m`
// - **Blue:** `\x1b[34m`
// - **Magenta:** `\x1b[35m`
// - **Cyan:** `\x1b[36m`
// - **White:** `\x1b[37m`

// ### Standard Background Colors
// - **Black Background:** `\x1b[40m`
// - **Red Background:** `\x1b[41m`
// - **Green Background:** `\x1b[42m`
// - **Yellow Background:** `\x1b[43m`
// - **Blue Background:** `\x1b[44m`
// - **Magenta Background:** `\x1b[45m`
// - **Cyan Background:** `\x1b[46m`
// - **White Background:** `\x1b[47m`

// ### Bright Colors
// For brighter colors, you can use the following codes, which are often supported by modern terminals:

// #### Bright Text Colors (Foreground)
// - **Bright Black (Gray):** `\x1b[90m`
// - **Bright Red:** `\x1b[91m`
// - **Bright Green:** `\x1b[92m`
// - **Bright Yellow:** `\x1b[93m`
// - **Bright Blue:** `\x1b[94m`
// - **Bright Magenta:** `\x1b[95m`
// - **Bright Cyan:** `\x1b[96m`
// - **Bright White:** `\x1b[97m`

// #### Bright Background Colors
// - **Bright Black (Gray) Background:** `\x1b[100m`
// - **Bright Red Background:** `\x1b[101m`
// - **Bright Green Background:** `\x1b[102m`
// - **Bright Yellow Background:** `\x1b[103m`
// - **Bright Blue Background:** `\x1b[104m`
// - **Bright Magenta Background:** `\x1b[105m`
// - **Bright Cyan Background:** `\x1b[106m`
// - **Bright White Background:** `\x1b[107m`

// To reset the color to the terminal's default, you use `\x1b[0m`. 

// These codes can be combined to style text in various ways. For example, to print text in bright yellow on a blue background, you would use `\x1b[93m\x1b[44mYour Text Here\x1b[0m`.

// Keep in mind that support for these codes and the appearance of these colors can vary between different terminal emulators and systems.