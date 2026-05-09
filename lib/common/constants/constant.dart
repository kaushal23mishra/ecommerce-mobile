abstract class Constant<T> {
  final T _value;

  const Constant(this._value);

  T get value => _value;
}
