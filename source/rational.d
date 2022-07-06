module source.rational;


struct Rational(T)
{
    T top;
    T bot;

    this(T top, T bot)
    {
        T d;

        enforce(bot != 0);
        if (bot < 0)
        {
            top = -top;
            bot = -bot;
        }

        d = gcd(abs!T(top), abs!T(bot));
        this.top = top / d;
        this.bot = bot / d;
    }

    private Rational _add(in Rational rhs) const
    {
        T _lcm;

        _lcm = lcmT(bot, rhs.bot);

        return Rational((_lcm / bot) * top + (_lcm / rhs.bot) * rhs.top, _lcm); 
    }

    private Rational _subt(in Rational rhs) const
    {
        Rational _rhs;

        _rhs = rhs.scale(T(-1));

        return this._add(_rhs);
    }

    private Rational _mult(in Rational rhs) const
    {
        return Rational(top * rhs.top, bot * rhs.bot);
    }

    private Rational _div(in Rational rhs) const
    {
        return Rational(top * rhs.bot, bot * rhs.top);
    }

    Rational opBinary(string op)(const Rational rhs) const
    {
        static if (op == "+")
            return this._add(rhs);
        else static if (op == "*")
            return this._mult(rhs);
        else static if (op == "/")
            return this._div(rhs);
        else static if (op == "-")
            return this._subt(rhs);
        else static assert (0);
    }

    private T _common_denom(in Rational rhs) const
    {
        return lcm(bot, rhs.bot);   
    }

    int opCmp(const Rational rhs) const
    {
        T left;
        T right;
        T denom;

        denom = _common_denom(rhs);
        left = (denom / bot) * top;
        right = (denom / rhs.bot) * rhs.top;

        return left < right ? -1 : left > right;
    }

    Rational invert() const
    {   
        return Rational(bot, top);
    }

    Rational scale(T value) const
    {
        return Rational(top * value, bot);
    }

    double value() const pure @property
    {
        return to!double(top) / to!double(bot);
    }

    override string toString() const
    {
        return format("%s / %s", top, bot);
    }
}