class Car {
  final int? model;
  final int? variant;
  final String? engineType;

  Car({this.model, this.variant, this.engineType});

  Car copyWith({int? model, int? variant, String? engineType}) {
    return Car(
      model: model ?? this.model,
      variant: variant ?? this.variant,
      engineType: engineType ?? this.engineType,
    );
  }
}
