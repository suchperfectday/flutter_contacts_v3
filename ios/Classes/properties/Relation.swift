import Contacts

@available(iOS 9.0, *)
struct Relation {
    var name: String
    // Raw CNLabeledValue label, e.g. _$!<Spouse>!$_ or a custom string. Kept
    // verbatim so entries the app does not own round-trip unchanged.
    var label: String = ""

    init(fromMap m: [String: Any]) {
        name = m["name"] as! String
        label = m["label"] as! String
    }

    init(fromRelation r: CNLabeledValue<CNContactRelation>) {
        name = r.value.name
        label = r.label ?? ""
    }

    func toMap() -> [String: Any] { [
        "name": name,
        "label": label,
    ]
    }

    func addTo(_ c: CNMutableContact) {
        c.contactRelations.append(
            CNLabeledValue<CNContactRelation>(
                label: label,
                value: CNContactRelation(name: name)
            )
        )
    }
}
