module source.e87;

import source.defaults;
import source.lib;

enum N = 50_000_000;
// enum N = 50;

private ulong _max_prime(ulong n)
{
    return to!ulong(sqrt(to!(real)(n))) + 1;
}

void e87()
{
    ulong max;
    ulong value;
    ulong[] primes;
    ulong m;
    ulong n;
    ulong k;
    ulong count;
    bool[ulong] seen;

    max = _max_prime(N);
    primes = PrimesUpTo(max);

    k = 0;
    while (k < primes.length)
    {
        m = 0;
        while (m < primes.length)
        {
            n = 0;
            while (n < primes.length)
            {
                value = primes[k] ^^ 2 + primes[m] ^^ 3 + primes[n] ^^ 4;
                if (value > N)
                    break ;

                if (value !in seen)
                    ++ count;

                seen[value] = true;

                ++ n;
            }
            ++ m;
        }
        ++ k;
    }

    writeln(count);
}