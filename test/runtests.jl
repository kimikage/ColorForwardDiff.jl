using Test
using ColorForwardDiff
using ForwardDiff
using ForwardDiff: derivative, gradient
using ColorTypes

@testset "derivative" begin
    @test derivative(x->RGB(0.5x, x^2, sin(x)), 0.5) ≈ RGB{Float64}(0.5, 1.0, cos(0.5))
end

@testset "gradient" begin
    @test gradient(x->RGB(0.5 * x[1], 0.2, 0.3), [0.5])[1] ≈ RGB{Float64}(0.5, 0.0, 0.0)
    @test gradient(x->RGB(0.1, x[1]^2, 0.3), [0.5])[1] ≈ RGB{Float64}(0.0, 1.0, 0.0)
    @test gradient(x->RGB(0.1, 0.2, sin(x[1])), [0.5])[1] ≈ RGB{Float64}(0.0, 0.0, cos(0.5))

    rgb_xy = gradient(x->RGB(x[1], x[2]^2, 0.3), [0.5, 0.5])
    @test rgb_xy[1] ≈ RGB{Float64}(1.0, 0.0, 0.0)
    @test rgb_xy[2] ≈ RGB{Float64}(0.0, 1.0, 0.0)

    rgb_xyz = gradient(x->RGB(x[1] + x[3], x[2]^2 - x[1], x[2] * x[3]), [0.5, 0.5, 0.5])
    @test rgb_xyz[1] ≈ RGB{Float64}(1.0, -1.0, 0.0)
    @test rgb_xyz[2] ≈ RGB{Float64}(0.0, 1.0, 0.5)
    @test rgb_xyz[3] ≈ RGB{Float64}(1.0, 0.0, 0.5)
end

@testset "traits" begin
    @test gradient(x->red(RGB(0.5 * x[1], 0.2, 0.3)) + x[1], [0.5])[1] ≈ 1.5
end
