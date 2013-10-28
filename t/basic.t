use strict;
use Test::More;
use lib 't/lib';
use Search::ServerX::Automobil;
use DDP;
use JSON::XS;
use File::Slurp;
use Path::Class;

my $index_path        = 'index'; #TODO set as atribute

## CONFIG

# replace with the actual test
my $automobil         = Search::ServerX::Automobil->new( 
  index_path => $index_path 
);

my $data              = decode_json( read_file( file( 't', '_somedata', 'fipe.json' ) ) );
#warn p $data;

# Indexer
$automobil->indexer(
  Lucy::Index::Indexer->new(
    index     => $index_path,
    schema    => $automobil->schema,
    create    => 1,
    truncate  => 1,
  )
);

#     ano              1996,
#     cod_fipe         "827002-3",
#     data             "domingo, 26 de maio de 2013 12:33",
#     marca            "YAMAHA",
#     mes_referencia   "Maio de 2013",
#     modelo           "AXIS 90",
#     preco            "R$ 1.776,00",
#     tipo             "moto"

foreach my $item ( @$data ) {
# warn p $item;
  my $doc = {
    id        => $item->{ cod_fipe },
    brand     => $item->{ marca },
    year      => sub {
              my ( $year )   = $item->{ ano } =~ m/(\d{4})/ig; 
              return ( defined $year ) ? $year:2013
    }->(),
    model     => $item->{ modelo },
    type      => $item->{ tipo },
    updated   => $item->{ data }, 
    price     => sub {
              my ( $valor )  = $item->{ preco } =~ m/R\$ (.+),00$/ig; 
              $valor =~ s/\.//ig if $valor;
              return ( defined $valor ) ? $valor:0  
    }->(),
  };
# warn p $doc;
  $automobil->indexer->add_doc( $doc );
}

$automobil->indexer->commit;





# Add some stuff
# $automobil->add( {} );

#my $results = $automobil->search( { q => 'something' } );

# foreach my $r ( @$results ) {
#   warn p $r;
# }

my $index_path = 'index';
#my $ss = Search::ServerX::Automobil->new( index_path => $index_path );

QUERY1: {

  my $q           = 'xtz AND 250x'; # 250x
  my $offset      = 0;
  my $page_size   = 50;

  my $hits = $automobil->search( {
    query       => $q,
    offset      => $offset,
    num_wanted  => $page_size,
  } );

  if ( $hits ) {
    my $hit_count = $hits->total_hits;
    warn "Total items: $hit_count";
    warn "Hits: ";
    while ( my $hit = $hits->next ) {
      warn p $hit->dump; 
      warn $hit->{ brand };
    }
  }

}

warn '==================================================================';

QUERY2: {
  #PROBLEM: 250 does not match 250x
  #solution: ..

  my $q           = 'xtz AND 250';  # (250 without the x)
  my $offset      = 0;
  my $page_size   = 50;

  my $hits = $automobil->search( {
    query       => $q,
    offset      => $offset,
    num_wanted  => $page_size,
  } );

  if ( $hits ) {
    my $hit_count = $hits->total_hits;
    warn "Total items: $hit_count";
    warn "Hits: ";
    while ( my $hit = $hits->next ) {
      warn p $hit->dump; 
      warn $hit->{ brand };
    }
  }
}



done_testing;
