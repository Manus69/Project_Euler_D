module source.e92;

import source.defaults;

ubyte[ulong] TABLE;

ulong SquareDigits(ulong n)
{
    ulong result;
    ulong rem;

    while (n)
    {
        rem = n % 10;
        result += rem * rem;
        n = n / 10;
    }

    return result;
}

ubyte FindLoop2(ulong n)
{
    if (n in TABLE)
        return TABLE[n];
    
    if (n == 1 || n == 89)
    {
        return to!ubyte(n);
    }

    ubyte result;

    result = FindLoop2(SquareDigits(n));
    TABLE[n] = result;

    return result;
}

ubyte FindLoop(ulong n)
{
    // ulong[] chain;
    // ubyte result;
    ulong result;

    if (n in TABLE)
        return TABLE[n];
    
    result = n;
    // chain ~= n;
    while (n != 1 && n != 89)
    {
        n = SquareDigits(n);
        // if (n in TABLE)
        // {
        //     result = TABLE[n];
        //     break ;
        // }
        // chain ~= n;
    }

    // foreach (number; chain)
    //     TABLE[number] = to!ubyte(n);

    TABLE[result] = to!ubyte(n);

    return TABLE[result];
}

enum N = 1000_000_0;

void e92()
{
    ulong count;

    TABLE[1] = 1;
    TABLE[89] = 89;

    foreach (n; 1 .. N)
    {
        if (FindLoop2(n) == 89)
            ++ count;
    }

    // FindLoop(44);

    writeln(count);
}