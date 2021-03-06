use strict;
use warnings;
use Test::More;
use Coro;

BEGIN { use AnyEvent::Impl::Perl }

my $class = 'Coro::ProcessPool::Process';

SKIP: {
    skip 'does not run under MSWin32' if $^O eq 'MSWin32';

    use_ok($class) or BAIL_OUT;

    my $proc = new_ok($class);

    ok($proc->spawn, 'spawn');

    foreach my $i (1 .. 10) {
        ok(my $id = $proc->send(sub { $_[0] * 2 }, [$i]), "send ($i)");
        ok(my $reply = $proc->recv($id), "recv ($i)");
        is($reply, $i * 2, "receives expected result ($i)");
    }

    ok($proc->terminate, 'terminate');
};

done_testing;
