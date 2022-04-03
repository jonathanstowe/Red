unit class MetamodelX::Red::SubsetHOW is Metamodel::SubsetHOW;

method all(\model, |c) { model.^refinee.^all(|c).grep: model.^refinement }

method load(\model, |ids) {
    my $filter = model.^refinee.^id-filter: |ids;
    model.^all.grep({ $filter }).head
}
method search(\model, |c) { model.^all.grep:   |c }
method create(\model, |c) { model.^all.create: |c }
method delete(\model, |c) { model.^all.delete: |c }

#method FALLBACK(Str $name, \model, |c) { model.^refinee.HOW."$name"(model.^refinee, |c) }
