package Search::ServerX::Automobil;
use Moose;
extends 'Search::Server';
use Lucy::Plan::Schema;
use Lucy::Analysis::PolyAnalyzer;
use Lucy::Plan::StringType;
use Lucy::Plan::FullTextType;
use Lucy::Analysis::RegexTokenizer;
use Lucy::Analysis::CaseFolder;
use Lucy::Analysis::RegexTokenizer;
use Lucy::Analysis::SnowballStemmer;
use DDP;

has schema => (
  is => 'rw',
  default => sub {
    # implements an index called 'automobil'
    my $schema            = Lucy::Plan::Schema->new;

    # Analysers
    my $tokenizer_stuff   = Lucy::Analysis::RegexTokenizer->new( pattern => ".+" );               #ex 250
    my $tokenizer_word    = Lucy::Analysis::RegexTokenizer->new( pattern => "\\w+" );               #ex \w...
# my $word_char_tokenizer = Lucy::Analysis::RegexTokenizer->new( pattern => "\w+" );
    my $tokenizer_numbers = Lucy::Analysis::RegexTokenizer->new( pattern => "\\d+" );               #ex 250
    my $tokenizer_phone   = Lucy::Analysis::RegexTokenizer->new( pattern => "\\d{2}-\\d{3}-\\d{4}" ); #ex 11-562-8837
    my $normalizer        = Lucy::Analysis::Normalizer->new( #Unicode normalization, case folding and accent stripping
           #normalization_form => 'NFKC', #more info @wikipedia: NFKC, unicode equivalence
           #case_fold          => 1,
           #strip_accents      => 1,
    );
    my $case_folder       = Lucy::Analysis::CaseFolder->new;
    my $tokenizer         = Lucy::Analysis::RegexTokenizer->new;
    my $stemmer           = Lucy::Analysis::SnowballStemmer->new( language => 'en' );

    my $polyanalyzer      = Lucy::Analysis::PolyAnalyzer->new(
#     language  => 'en',
      analyzers => [
        $case_folder, 
#       $word_char_tokenizer, 
#       $tokenizer_stuff,
#       $stemmer,
#       $tokenizer_stuff,
        $tokenizer_word,
#       $tokenizer_numbers,
#       $tokenizer_phone,
#       $normalizer,
      ]
    );

    # Types
    my $type_exact_match  = Lucy::Plan::StringType->new( stored => 0 ); #stored 0 means exact match
    my $type_fulltext     = Lucy::Plan::FullTextType->new( analyzer => $polyanalyzer );
    my $type_int32        = Lucy::Plan::Int32Type->new( indexed => 0 );



    # Fields
    $schema->spec_field( name => 'id',      type => $type_exact_match );
    $schema->spec_field( name => 'brand',   type => $type_fulltext );
    $schema->spec_field( name => 'year',    type => $type_int32 );
    $schema->spec_field( name => 'model',   type => $type_fulltext );
    $schema->spec_field( name => 'type',    type => $type_exact_match );
    $schema->spec_field( name => 'updated', type => $type_exact_match );
    $schema->spec_field( name => 'price',   type => $type_int32 );
    return $schema;
  }
);



# Searcher
#use Lucy::Search::IndexSearcher;

#my $searcher    = Lucy::Search::IndexSearcher->new( index => $index_path );
#my $q           = 'xtz AND 250x';
# see how to fix this:   'xtz AND 250x'; vs    'xtz AND 250';
# my $offset      = 0;
# my $page_size   = 50;

# my $hits = $searcher->hits(
#   query       => $q,
#   offset      => $offset,
#   num_wanted  => $page_size,
# );

# my $hit_count = $hits->total_hits;
# warn "Total items: $hit_count";
# warn "Hits: ";
# while ( my $hit = $hits->next ) {
#   warn p $hit->dump; 
#   warn $hit->{ brand };
# }






































## declara o indice ## declara os campos
## permite buscar
## permite inserir

## sort: http://search.cpan.org/~creamyg/Lucy-0.3.3/lib/Lucy/Search/SortSpec.pod
## tem que criar regras de sort para cada sort usado

#Hits  example from Cookbook custom query
#   sub hits {
#       my ( $self, $query ) = @_;
#       my $compiler = $query->make_compiler( searcher => $self );
#       my $matcher = $compiler->make_matcher(
#           reader     => $self->get_reader,
#           need_score => 1,
#       );
#       my @hits = $matcher->capture_hits;
#       return \@hits;
#   }

##my $config = {
##  index   => '',
##  fields  => {
##    ano => ''
##  }
##};

##my $ss = Search::Server->new( { config => $config } );

1;
