using ModelingToolkit
using Test

@parameters t
@variables x(t) y(t) # test multi-arg
@variables z(t) # test single-arg
x1 = Variable(:x)(t)
y1 = Variable(:y)(t)
z1 = Variable(:z)(t)
@test isequal(x1, x)
@test isequal(y1, y)
@test isequal(z1, z)

@parameters begin
    t
    s
end
@parameters σ(..)

t1 = Variable(:t; known = true)()
s1 = Variable(:s; known = true)()
σ1 = Variable(:σ; known = true)
@test isequal(t1, t)
@test isequal(s1, s)
@test isequal(σ1, σ)

@derivatives D'~t
D1 = Differential(t)
@test D1 == D

@test isequal(x ≤ y + 1, (x < y + 1) | (x == y + 1))

@test @macroexpand(@parameters x, y, z(t)) == @macroexpand(@parameters x y z(t))
@test @macroexpand(@variables x, y, z(t)) == @macroexpand(@variables x y z(t))

convert(Expression, :($x == 0 ? $y : $x))

# Test array expressions
@parameters begin
    t[1:2]
    s[1:2:4,1:2]
end
@parameters σ[1:2](..)

t1 = [Variable(:t, 1; known = true)(),
      Variable(:t, 2; known = true)()]
s1 = [Variable(:s, 1, 1; known = true)() Variable(:s, 1, 2; known = true)()
      Variable(:s, 3, 1; known = true)() Variable(:s, 3, 2; known = true)()]
σ1 = [Variable(:σ, 1; known = true),
      Variable(:σ, 2; known = true)]
@test isequal(t1, t)
@test isequal(s1, s)
@test isequal(σ1, σ)

@parameters t
@variables x[1:2](t)
x1 = [Variable(:x, 1)(t), Variable(:x, 2)(t)]
@test isequal(x1, x)

@variables a[1:11,1:2]
@variables a()
