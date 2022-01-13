class CodePo {
  final int id;
  final String name;
  final String code;

  CodePo(this.id, this.name, this.code);

  CodePo deepCopy() {
    return new CodePo(id, name, code);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}
