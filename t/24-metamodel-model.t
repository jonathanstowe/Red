use Test;
my $*RED-DB = database "SQLite";

use-ok "Red";

use Red;

model Bla {
    has Str $.column is column;
}

Bla.^create-table;

is Bla.^column-names, < column >;

is model :: { has $.a is column; has $.b is column; has $.c is column<d> }.^column-names, <a b d>;

# TODO: fix
#is-deeply model :: {
#    has $.a is column{ :unique };
#    has $.b is column{ :unique };
#    has $.c is column{ :unique, :name<d> }
#}.^constraints>>.name, <a b d>;

model Ble:ver<1.2.3> is table<not-ble> is nullable {
    has $.a is referencing{ ::?CLASS.b }
    has $.b is referencing{ ::?CLASS.c }
    has $.c is column{:references{ ::?CLASS.a }, :name<d>}
    has $.e is referencing{:model<Bla>, :column<column>}
}

is-deeply Ble.^references.keys.Set, set < a b c e >;
is-deeply Ble.^references.values>>.name.Set, set < a b d e >;

is-deeply Ble.^references.values.map(*.ref().attr.package.^table).Set, set < bla not-ble >;
is-deeply Ble.^references.values.map(*.ref().name).Set, set < column a b d >;

is Bla.^table, "bla";
is Ble.^table, "not-ble";
is model :: is table<bli> {}.^table, "bli";

is Bla.^as, "bla";
is Ble.^as, "not-ble";
is model :: is table<bli> {}.^as, "bli";

is Bla.^alias("not-bla").^as, "not_bla";
is Ble.^alias("not-not-ble").^as, "not_not_ble";
is model :: is table<bli> {}.^alias("not-bli").^as, "not_bli";

is Bla.^alias("not-bla").^orig, Bla;
is Ble.^alias("not-not-ble").^orig, Ble;

is Bla.^rs-class-name, "Bla::ResultSeq";
is Ble.^rs-class-name, "Ble::ResultSeq";

is-deeply Bla.^columns>>.name.Set, set < $!column >;
is-deeply Ble.^columns>>.name.Set, set < $!a $!b $!c $!e >;

is Bla.^migration-hash<columns>.elems, 1;
is Bla.^migration-hash<name>, "bla";
is Bla.^migration-hash<version>, v0;

is Ble.^migration-hash<columns>.elems, 4;
is Ble.^migration-hash<name>, "not-ble";
is Ble.^migration-hash<version>, v1.2.3;

is-deeply model :: {}.new.^id-values, ();
is-deeply model :: { has $.id is id }.new(:42id).^id-values, (42,);
is-deeply model :: { has $.id1 is id; has $!id2 is id = 13 }.new(:42id1).^id-values, (42, 13);

todo "default-nullable returning false by default";
ok not Bla.^default-nullable;
ok Ble.^default-nullable;

is-deeply model :: { has Int $.a is column{ :unique } }.^unique-constraints>>.name, (('$!a',),);

is-deeply Bla.^attr-to-column, %('$!column' => "column");
is-deeply Ble.^attr-to-column, %('$!a' => "a", '$!b' => "b", '$!c' => "d", '$!e' => "e");


is Bla.^rs, Bla.^all;


use Red::ResultSeq;
class MyRS does Red::ResultSeq {}
my $rs = model :: is rs-class<MyRS> {}.^rs;
isa-ok $rs, MyRS;
does-ok $rs, Red::ResultSeq;

done-testing;
