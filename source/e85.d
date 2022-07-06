module source.e85;

import source.defaults;

struct Rectangle
{
    ulong width;
    ulong height;

    this(ulong width, ulong height)
    {
        this.width = width;
        this.height = height;
    }
}

ulong CountWays(in Rectangle big, in Rectangle small) pure
{
    ulong horizontal;
    ulong vertical;

    if (big.height < small.height || big.width < small.width)
        return 0;

    horizontal = big.width - small.width + 1;
    vertical = big.height - small.height + 1;

    return horizontal * vertical;
}

ulong CountAllWays(in Rectangle rect)
{
    Rectangle small;
    ulong total;

    foreach (width; 1 .. rect.width + 1)
    {
        foreach (height; 1 .. rect.width + 1)
        {
            small = Rectangle(width, height);
            total += CountWays(rect, small);
        }
    }

    return total;
}

void e85()
{
    int N = 2_000_000;
    int n_ways;
    int diff;
    ulong min;
    Rectangle rect;
    Rectangle min_rect;

    // rect = Rectangle(3, 2);
    // writeln(CountAllWays(rect));

    min = ulong.max;
    int n = 100;
    foreach (w; 1 .. n)
    {
        foreach (h; 1 .. n / 2)
        {
            rect = Rectangle(w, h);
            n_ways = to!int(CountAllWays(rect));

            diff = abs(N - n_ways);
            if (diff < min)
            {
                min = diff;
                min_rect = rect;
            }
        }
    }

    writeln(min_rect.width * min_rect.height);
}