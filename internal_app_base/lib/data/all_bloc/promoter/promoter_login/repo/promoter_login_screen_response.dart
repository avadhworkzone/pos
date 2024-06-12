/// token_type : "Bearer"
/// expires_in : 31622400
/// access_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5OTZhY2ZjNS0xMjYxLTQ0ZDUtYjQ0NC1kMjdmYThlNGZkMTciLCJqdGkiOiIwZDBhMjQ0YjA5YjNlYjZiNmYxYzZkOGNjMDVhMDk2Zjc4ZWFhNjU4MWJmYjAwODQwZmJiMzZkNjczYTgwNGJmZGQxNWE2YWFmMzhjNzg5YiIsImlhdCI6MTY4NzQwODY4My44MzU3OCwibmJmIjoxNjg3NDA4NjgzLjgzNTc4MSwiZXhwIjoxNzE5MDMxMDgzLjgyOTM3NSwic3ViIjoiMSIsInNjb3BlcyI6WyIqIl19.XVS9kXwm500UB5XN42SsDzUIWfbALYo6AjqI5c4heqqA4F8lOGqWlNo_UzV4C1hZyoBDfKSL8isjxS9oWQuWe4PnLGtPQX2snvX0kXSWlv31nF-VBPw620AJrBd-hTl_OU-biZFdGkypeoYA891emlNjlEiaiFSk5zCZQWG8D2jT7yQzVGJqilFyX7QT9cDtSBkvjM_OLJS8XLHzMwdhSnCieFRizstJ5infhSw8JcT8UAFrGo7MHz38-7bDjutZ8PKUHYIoX_8px4qoDdovXQbb35YjwDaaSkHX8_HmNJdCJyGKHlmGYPPk_pZCFgOJu21AY0ASkcFsWBdh106LNf083Z0K2Iq8wNSz4omR0kWnmKGaBoG6moDGOZ8EfN5BU_34xfAkei-qT-Je6QCXvQJCSTdHZX7gzYMpfsav0X4JKW5-jimL4xCI3zsF-gW-xxY5cG-8rn3R-hO7nBXGxm4x_X6JNojOc_Foll44oR1hPwshXx6HW9Ts-hGhk4QopgdXVo4-zuzHIBa-v0meROHPxthP0Ez8vei3deYC0TdlmJ-bkSu1kf-B52CkyCEynF1nRqZD4qW4xH6-TuFmJdfabiifMTnaqBdgKJkJPalD6YWK9JZSkZZWlled67lfhdD7QMsQxl-jf9t2A7LgdcZCFF7MkyfV2shqeUPNBx0"
/// refresh_token : "def50200b50ccfd983dc589b3f1ad42f2b454aa2f8ec0f8266e27de3d4825ecdfa396cc9d746aa071dc1ab912b4720c37ec196c92c27cc8ada2e78ff5e234d96e562fc69215d66acab606546a3a713c70d3dadb85ac49e064f479aee5f0f954259882fb6c7157edf705e0ebc29d682c607f3a0c4b657f94c1586f646e1537ab980440a24aa248c673104e232e8976400d8d32387292fe069b47928d5a4e4a1927ff5829331b18eb4a08cc8f85b405a7812f0d0af59c6ce9aa4a8d8e480eb2c9468060e9468a3b66395e42ef0d61f225780a1d7ba84ef9736b48d8054d64732300eea8e5be932f32f055c17f76cc5b08f3ea5751f1453dfad76cb109b466abd404c6b0225d79bc340233779d650406bb1c2432a3665f52094cb177ebfc898be6e8583eed2820f9aec41361db0aeaf11f40a286e1755e270413066d883be725cb9172d6635cbe5f47c6a92652108839665e3d8b2c7baecdccc92ba12c43b6e959db97e60f3d8cfc4b9d495273ead6d698cf335bc9b10a02be9b4319987ab620604ab476e0676f0d5"

class PromoterLoginScreenResponse {
  PromoterLoginScreenResponse({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,});

  PromoterLoginScreenResponse.fromJson(dynamic json) {
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token_type'] = tokenType;
    map['expires_in'] = expiresIn;
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    return map;
  }

}