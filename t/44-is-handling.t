use Test;

use Red < is-handling >;

my $*RED-DEBUG          = $_ with %*ENV<RED_DEBUG>;
my $*RED-DEBUG-RESPONSE = $_ with %*ENV<RED_DEBUG_RESPONSE>;
my @conf                = (%*ENV<RED_DATABASE> // "SQLite").split(" ");
my $driver              = @conf.shift;
my $*RED-DB             = database $driver, |%( @conf.map: { do given .split: "=" { .[0] => val .[1] } } );

model Bla is handling<map grep> { has Int $.a is column }
lives-ok { schema(Bla).drop.create }
Bla.^create: :a($_) for ^10;
is Bla.map(*.a), ^10;
is Bla.grep(*.a < 5).map(*.a), ^5;

model Ble is handling(map => "update", grep => "where") { has Int $.a is column }
lives-ok { schema(Ble).drop.create }
Ble.^create: :a($_) for ^10;
is Ble.update(*.a), ^10;
is Ble.where(*.a < 5).map(*.a), ^5;

model Bli is handling<grep> { has Int $.a is column }
lives-ok { schema(Bli).drop.create }
Bli.^create: :a($_) for ^10;
is Bli.grep(*.a < 5).map(*.a), ^5;

model Blo is handling(map => "update") { has Int $.a is column }
lives-ok { schema(Blo).drop.create }
Blo.^create: :a($_) for ^10;
is Blo.update(*.a), ^10;

done-testing;
