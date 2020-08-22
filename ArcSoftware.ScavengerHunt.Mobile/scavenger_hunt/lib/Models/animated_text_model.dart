import 'dart:convert';

List<AnimatedText> animatedTextFromJson(String str) => List<AnimatedText>.from(json.decode(str).map((x) => AnimatedText.fromJson(x)));

class AnimatedText {
    AnimatedText({
      this.text,
      this.textSpeed
    });

    String text;
    int textSpeed;

    factory AnimatedText.fromJson(Map<String, dynamic> json) => AnimatedText(
        text: json["text"],
        textSpeed: json["textSpeed"]
    );
}