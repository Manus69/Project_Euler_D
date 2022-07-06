module source.lib;

import source.defaults;
import source.rational;

bool[] Sieve(ulong N)
{
    bool[] sieve;
    ulong   p;
    ulong   current;

    sieve.length = N;
    sieve[] = true;
    sieve[0] = false;
    sieve[1] = false;
    p = 2;

    while (p < N)
    {
        current = p + p;
        while (current < N)
        {
            sieve[current] = false;
            current += p;
        }

        ++ p;
        while (p < N && (sieve[p] == false))
            ++ p;
    }

    return sieve;
}

ulong[] PrimesUpTo(ulong N)
{
    bool[] sieve;
    ulong[] primes;

    sieve = Sieve(N);
    foreach (n, value; sieve)
    {
        if (value)
            primes ~= n;
    }

    return primes;
}