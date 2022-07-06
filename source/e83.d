module source.e83;

import source.heap;

import std.algorithm;
import std.stdio;
import std.datetime;
import std.range;
import std.exception;
import std.format;
import std.conv;
import std.string;

enum N = 80;
enum string FILE = "p083_matrix.txt";
enum string[] TEST =   ["131, 673, 234, 103, 18",
                        "201, 96, 342, 965, 150",
                        "630, 803, 746, 422, 111",
                        "537, 699, 497, 121, 956",
                        "805, 732, 524, 37, 331"];

class Matrix(int N)
{
    int[N][N] values;

    this(in string[] lines)
    {
        enforce(lines.length == N);
        foreach (row, line; lines)
        {
            foreach (col, value; split(line, ","))
            {
                values[row][col] = to!int(strip(value));
            }
        }
    }

    int At(int row, int col) pure const
    {
        if ((row >= 0 && row < N) && (col >= 0 && col < N))
            return values[row][col];
        
        return -1;
    }

    override string toString() const
    {
        return format("%s", values);
    }
}

class Point
{
    Point previous;
    int row;
    int col;
    int value;
    int distance;

    this(int row, int col, int value, int distance, Point previous)
    {
        this.row = row;
        this.col = col;
        this.value = value;
        this.previous = previous;
        this.distance = distance;
    }

    override int opCmp(const Object obj) const
    {
        Point p = cast(Point)obj;
        enforce(p);

        return this.distance < p.distance ? -1 : this.distance > p.distance;
    }

    override bool opEquals(const Object object) const
    {
        Point p = cast(Point)object;

        return this.row == p.row && this.col == p.col;
    }

    override ulong toHash() const pure
    {
        return row + col;
    }

    override string toString() const
    {
        return format("(%s, %s) %s", row, col, value);
    }
}

class Pathfinder(int N)
{
    Matrix!N            matrix;
    PriorityQueue!Point queue;
    bool[Point] visited;
    int start_row;
    int start_col;
    int end_row;
    int end_col;

    this(Matrix!N matrix, int start_row = 0, int start_col = 0,
            int end_row = N - 1, int end_col = N - 1)
    {
        this.matrix = matrix;
        this.queue = new PriorityQueue!Point();

        this.start_row = start_row;
        this.end_row = end_row;
        this.start_col = start_col;
        this.end_col = end_col;
    }

    private Point _point(int row, int col, Point previous)
    {
        int value;

        value = matrix.At(row, col);

        return value < 0 ? null :
                new Point(row, col, value, previous.distance + value, previous);
    }

    private Point _up(Point p)
    {
        return _point(p.row - 1, p.col, p);
    }

    private Point _right(Point p)
    {
        return _point(p.row, p.col + 1, p);
    }

    private Point _down(Point p)
    {
        return _point(p.row + 1, p.col, p);
    }

    private Point _left(Point p)
    {
        return _point(p.row, p.col - 1, p);
    }

    private void _visit(Point p)
    {
        Point[] points;
        
        visited[p] = true;
        points.length = 4;
        points[0] = _up(p);
        points[1] = _right(p);
        points[2] = _down(p);
        points[3] = _left(p);

        points = filter!((a) => (a !is null) && a !in visited)(points).array;

        queue.Insert(points);
    }

    private void _init()
    {
        Point   start;
        int     value;

        value = matrix.At(start_row, start_col);
        start = new Point(start_row, start_col, value, 0, null);
        _visit(start);
    }

    private Point[] _backtrack(Point p) pure const
    {
        Point[] points;

        while (p)
        {
            points ~= p;
            p = p.previous;
        }

        return points;
    }

    private bool _end(in Point p) const pure
    {
        return p.row == end_row && p.col == end_col;
    }

    Point[] FindPath()
    {
        Point current;

        _init();
        while (!queue.Empty())
        {
            current = queue.Remove();
            if (_end(current))
                return _backtrack(current);
            
            _visit(current);
        }

        return null;
    }
}

private int _sum(in Point[] points)
{
    int result;

    foreach (ref p; points)
        result += p.value;

    return result;
}

void e83()
{
    string[] lines;
    foreach (ref line; File(FILE).byLineCopy())
        lines ~= line;

    Matrix!N matrix;
    Pathfinder!N pathfinder;
    Point[] points;

    matrix = new Matrix!N(lines);
    pathfinder = new Pathfinder!N(matrix);
    points = pathfinder.FindPath();
    // writeln(points);
    writeln(_sum(points));
}