module e86_fail;

import source.defaults;

ulong M = 7;

bool MinIsInt(double a, double b, double c)
{
    double[] results;

    results.length = 12;
    results[0] = (a * b) / (b - c);
    results[1] = (a * b) / (a - c);
    results[2] = (a * c) / (a - b);
    results[3] = (b * c) / (b - a);
    results[4] = (b * c) / (b - a);
    results[5] = (a * c) / (c - b);

    results[6] = (a * b) / (b + c);
    results[7] = (a * b) / (a + c);
    results[8] = (a * c) / (a + b);
    results[9] = (b * c) / (b + a);
    results[10] = (b * c) / (b + a);
    results[11] = (a * c) / (c + b);

    // writeln(results);


    double min;

    min = results.filter!((a) => !a.isNaN && a > 0).minElement(double.nan);

    return isClose(min, nearbyint(min), 1e-10);
}

void e86()
{
    ulong n_solutions;

    ulong count;
    foreach (w; 1 .. M)
    {
        foreach (l; w .. M)
        {
            foreach (h; l .. M)
            {
                writefln("%s %s %s", w, l, h);

                count += MinIsInt(w, l, h);
            }
        }
    }

    writeln(count);   
}