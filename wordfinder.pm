package wordfinder;
use Dancer ':syntax';
our $VERSION = '0.1';

set port => 80;

# TODO: support configurable path for dictionary
my $DICT_PATH = '/usr/local/wordfinder/lib/dictionary';
my %dict;

get '/ping' => sub
{
    return 'OK';
};

get '/wordfinder/:input' => sub
{
    ensure_dict();

    my %inputs;
    vary_inputs(param('input'), \%inputs);
#   debug("inputs: " . join(',', sort(keys(%inputs))));

    my %words;
    foreach my $input (sort(keys(%inputs)))
    {
        make_words('', $input, \%words);
    }

    my $pad = ' ';
    my $output = '[';

    foreach my $word (sort(keys(%words)))
    {
        $output .= $pad . '"' . $word . '"';
        $pad = ', ';
    }

    $output .= ' ]';
    return $output;
};

####################

sub ensure_dict
{
    return if (scalar(keys(%dict)) > 0);

    if (!open(DICT, $DICT_PATH))
    {
        my $err = $!;
        error("Failed to open dictionary '" . $DICT_PATH . "': " . $err);
        return;
    }

    while (defined(my $line = <DICT>))
    {
        chomp($line);
        $dict{$line} = 1 if ($line =~ m/^[a-z][a-z]+$/); # only support lowercase & 2 letters min
    }

    close(DICT);
    info(scalar(keys(%dict)) . " words loaded from dictionary: " . $DICT_PATH);
}

#
# vary_inputs creates all possible M length inputs for each M <= N.
# (Permutations not relevant at this stage).
#
# By example, the variations of 'dgo' are:
#
#  Len 1: d, g, o
#  Len 2: dg, do, go
#  Len 3: dgo
#
sub vary_inputs
{
    my $base = $_[0];
    my $href = $_[1];
    return if (!$base || !$href);

    $href->{$base} = 1;  # hash, as to prevent dupes

    for my $i (0..length($base)-1)
    {
        my $new_base = $base;
        substr($new_base, $i, 1) = '';
        vary_inputs($new_base, $href);  # recurse
    }
}

#
# make_words checks all possible permutations of all letters.
#
# By example, the permutations of 'dgo' are:
#
#  dgo
#  dog
#  gdo
#  god
#  odg
#  ogd
#
sub make_words
{
    my $base = $_[0];
    my $residual = $_[1];
    my $href = $_[2];
    return if (!$href);

    if (!$residual)
    {
#       debug("check: " . $base);
        $href->{$base} = 1 if ($dict{$base});  # hash, as to prevent dupes
        return;
    }

    for my $i (0..length($residual)-1)
    {
        my $new_residual = $residual;
        my $new_base = $base . substr($new_residual, $i, 1);
        substr($new_residual, $i, 1) = '';
        make_words($new_base, $new_residual, $href);  # recurse
    }
}

####################

true;

