use Test;
use Red;

model TestModel {
    has Str $.name is column;
    has Int $.count is column;
}

my $*RED-DEBUG          = $_ with %*ENV<RED_DEBUG>;
my $*RED-DEBUG-RESPONSE = $_ with %*ENV<RED_DEBUG_RESPONSE>;
my @conf                = (%*ENV<RED_DATABASE> // "SQLite").split(" ");
my $driver              = @conf.shift;
my $*RED-DB             = database $driver, |%( @conf.map: { do given .split: "=" { .[0] => .[1] } } );

schema(TestModel).drop;
TestModel.^create-table;

my $b = TestModel.^all.sort(*.count).classify(*.name).Bag;

pass('sort + classify should produce correct SQL');

done-testing;
