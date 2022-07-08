module source.e91;

import source.defaults;

struct Point
{
    int x;
    int y;

    this(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    int DistanceSquared(in Point p) const pure
    {
        int dx;
        int dy;

        dx = p.x - this.x;
        dy = p.y - this.y;

        return dx * dx + dy * dy;
    }

    string toString() const
    {
        return format("(%s %s)", x, y);
    }

    bool Above(in Point p) const pure
    {
        return this.y > p.y;
    }

    bool Rigtwards(in Point p) const pure
    {
        return this.x > p.x;
    }

    bool Leftwards(in Point p) const pure
    {
        return this.x < p.x;
    }
}

bool CheckTriange(in Point a, in Point b, in Point c)
{
    int[] distances;

    distances.length = 3;
    distances[0] = a.DistanceSquared(b);
    distances[1] = b.DistanceSquared(c);
    distances[2] = a.DistanceSquared(c);

    sort(distances);

    return all!("a > 0")(distances) && (distances[2] == (distances[0] + distances[1]));
}

Point[] GetPoints(int x_max, int y_max)
{
    Point[] points;

    foreach (x; 0 .. x_max + 1)
    {
        foreach (y; 0 .. y_max + 1)
        {
            points ~= Point(x, y);
        }
    }

    return points;
}

enum N = 50;

void e91()
{
    Point[] points;
    uint count;

    points = GetPoints(N, N);
    points = points[1 .. $];
    auto origin = Point(0, 0);

    foreach (p; points)
    {
        foreach (q; points)
        {
            if (q.Leftwards(p) || q.Above(p))
                continue ;
                
            if (CheckTriange(origin, p, q))
            {
                // writeln(p, q);
                ++ count;
            }
        }
    }

    writeln(count);
}