class CheckPhone {
  CheckPhone({
    this.exist,
  });

  int exist;

  factory CheckPhone.fromJson(Map<String, dynamic> json) => CheckPhone(
    exist: json["exist"],
  );

  Map<String, dynamic> toJson() => {
    "exist": exist,
  };
}
