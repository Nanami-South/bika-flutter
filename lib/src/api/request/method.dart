enum RequestMethod {
  get("GET"),
  post("POST"),
  put("PUT");

  final String value;

  const RequestMethod(this.value);

  @override
  String toString() => value;
}
