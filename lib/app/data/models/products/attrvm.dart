class AttrVM {
  final int attrId;
  final String attrName;
  final Map<int, String> options; // optionId -> name
  AttrVM({
    required this.attrId,
    required this.attrName,
    required this.options,
  });
}
