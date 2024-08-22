class Probability {
  num? neg;
  num? neutral;
  num? pos;

  Probability({this.neg, this.neutral, this.pos});

  Probability.fromJson(Map<String, dynamic> json) {
    neg = json['neg'];
    neutral = json['neutral'];
    pos = json['pos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['neg'] = neg;
    data['neutral'] = neutral;
    data['pos'] = pos;
    return data;
  }

  @override
  String toString() {
    return 'Probability{neg: $neg, neutral: $neutral, pos: $pos}';
  }
}

class HeadlineSentiment {
  Probability? probability;
  String? label;

  HeadlineSentiment({this.probability, this.label});

  HeadlineSentiment.fromJson(Map<String, dynamic> json) {
    probability = json['probability'] != null ? Probability?.fromJson(json['probability']) : null;
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['probability'] = probability!.toJson();
    data['label'] = label;
    return data;
  }

  @override
  String toString() {
    return 'HeadlineSentiment{probability: $probability, label: $label}';
  }
}
