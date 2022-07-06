module source.heap;

import std.algorithm;
import std.format;
import std.array;
import std.range;
import std.container;
import std.exception;

class Heap(T, string S = "<")
{
    private T[] elements;

    T[] GetElements() pure
    {
        return elements;
    }

    T Peek() pure
    {
        return elements[0];
    }

    void Insert(T[] values...)
    {
        foreach (value; values)
        {
            elements ~= value;
            _heapify_up(elements.length - 1);
        }
    }

    T PopLast()
    {
        T element;

        enforce(elements.length);

        element = elements[_last];
        elements.popBack();

        return element;
    }

    T PopRoot()
    {
        T element;

        enforce(elements.length);

        swap(elements[0], elements[_last]);
        element = elements[_last];
        elements.popBack();
        _heapify_down(0);

        return element;
    }

    ulong Size() const pure @property
    {
        return elements.length;
    }

    T[] Sort()
    {
        T[] array;

        array = elements;
        while (elements.length)
        {
            swap(elements[0], elements[_last]);
            elements = elements[0 .. $ - 1];
            _heapify_down(0);
        }

        elements = array;

        return array; 
    }

    private ulong _left(ulong n) pure const
    {
        return 2 * n + 1;
    }

    private ulong _right(ulong n) pure const @property
    {
        return 2 * n + 2;
    }

    private ulong _root(ulong n) pure const @property
    {
        return (n - 1) / 2;
    }

    private ulong _last() pure const @property
    {
        return elements.length - 1;
    }

    private bool _compare(in T lhs, in T rhs) const
    {
        return mixin("lhs" ~ S ~ "rhs");
    }

    private ulong _minmax_index(ulong lhs, ulong rhs)
    {
        return _compare(elements[lhs], elements[rhs]) ? lhs : rhs;
    }

    private void _heapify_up(ulong n)
    {
        ulong root_index;

        if (n == 0)
            return ;
        
        root_index = _root(n);
        if (_compare(elements[n], elements[root_index]))
        {
            swap(elements[n], elements[root_index]);

            return _heapify_up(root_index);
        }
    }

    private void _heapify_down(ulong n)
    {
        ulong left_index;
        ulong right_index;
        ulong minmax_index;

        left_index = _left(n);
        right_index = _right(n);

        if (left_index >= elements.length && right_index >= elements.length)
            return ;
        
        if (right_index >= elements.length)
        {
            if (_compare(elements[left_index], elements[n]))
            {
                swap(elements[left_index], elements[n]);
            }
        }
        else
        {
            minmax_index = _minmax_index(left_index, right_index);
            if (_compare(elements[minmax_index], elements[n]))
            {
                swap(elements[n], elements[minmax_index]);

                return _heapify_down(minmax_index);
            }
        }

    }

    override string toString() const
    {
        return format("%s", elements);
    }
}

class PriorityQueue(T, string S = "<")
{
    Heap!(T, S) heap;

    this()
    {
        heap = new Heap!(T, S)();
    }

    bool Empty() const pure @property
    {
        return heap.Size == 0;
    }

    void Insert(T[] values...)
    {
        return heap.Insert(values);
    }

    T Remove()
    {
        return heap.PopRoot();
    }

    T Peek()
    {
        return heap.Peek();
    }

    override string toString() const
    {
        return heap.toString();
    }
}