/// Labeled related name, for example "spouse: Anna" or "manager: Kim".
///
/// The label is kept as the raw platform string rather than mapped onto an
/// enum, so that entries an app does not own round-trip unchanged. Apple's
/// standard labels arrive wrapped, for example `_$!<Spouse>!$_`, while a
/// custom label is its own plain text.
class Relation {
  /// Name of the related person.
  String name;

  /// Raw label, for example `_$!<Spouse>!$_` or a custom string.
  String label;

  Relation(this.name, {this.label = ''});

  factory Relation.fromJson(Map<String, dynamic> json) => Relation(
        (json['name'] as String?) ?? '',
        label: (json['label'] as String?) ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'label': label,
      };

  @override
  int get hashCode => name.hashCode ^ label.hashCode;

  @override
  bool operator ==(Object o) =>
      o is Relation && o.name == name && o.label == label;

  @override
  String toString() => 'Relation(name=$name, label=$label)';
}
