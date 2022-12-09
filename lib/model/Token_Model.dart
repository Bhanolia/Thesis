class token_model {
  String token;

  token_model(this.token);

  Map<String, dynamic> toJson() => {"token": token};

  static token_model fromJson(Map<String, dynamic> json) => token_model(
        json['token'],
      );

  token_model.fromSnapshot(snapshot) : token = snapshot.data()['token'];
}
