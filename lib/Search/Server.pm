package Search::Server;
#ABSTRACT: Provides a search rest server
use Moo;
use 5.008_005;
our $VERSION = '0.01';
use Lucy::Index::Indexer;
use Lucy::Search::IndexSearcher;

has index_path => (
  is        => 'rw',
); 

has searcher => (
  is        => 'rw',
);

has indexer => ( is => 'rw' );

sub BUILD {
  my ( $self ) = @_; 
  $self->searcher( Lucy::Search::IndexSearcher->new( index => $self->index_path ) ) 
      if defined $self->index_path 
   and ! defined $self->searcher;
}

sub add {
    my ( $self, $args ) = @_; 
}

sub search {
    my ( $self, $args ) = @_; 
#use DDP;    warn p %$args;
    return $self->searcher->hits( %$args );
}



1;
__END__

=encoding utf-8

=head1 NAME

Search::Server - Work in progress... 

=head1 SYNOPSIS

  use Search::Server;

=head1 DESCRIPTION

Search::Server is a TEST to learn Apache Lucy.

=head1 AUTHOR

Hernan Lopes E<lt>hernan@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Hernan Lopes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
