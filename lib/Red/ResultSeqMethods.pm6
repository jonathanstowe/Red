use Red::AST::Function;
unit role Red::ResultSeqMethods;

method !agg(Str $func, &block) {
  my $*RED-FALLBACK = False;
  self.map({
    my @args = block $_;
    Red::AST::Function.new: :$func, :@args
  }).ast
}

method min(&block) {
  self!agg("min", &block)
}

method max(&block) {
  self!agg("max", &block)
}

method sum(&block) {
  self!agg("sum", &block)
}
