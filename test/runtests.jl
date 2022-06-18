using OpenMapLayers, Test

@testset "Testing utils" begin
    @testset "Testing maxspeed" begin
        @test OpenMapLayers.parse_maxspeed(nothing) === nothing
        @test OpenMapLayers.parse_maxspeed("13knots") === 24.08
        @test OpenMapLayers.parse_maxspeed("13.3 mph") === 21.4
    end
end
