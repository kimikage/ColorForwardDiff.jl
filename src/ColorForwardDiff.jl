module ColorForwardDiff

using ColorTypes
using ForwardDiff
using ForwardDiff: Dual, Partials, value, partials

_partials(N, p::Dual) = partials(p)
_partials(N, k::Real) = ntuple(i->zero(k), N)

ForwardDiff.can_dual(::Type{<:Gray}) = true
ForwardDiff.can_dual(::Type{<:RGB}) = true

function dual_rgb(Tag, T, N, r, g, b)
    Dual{Tag, RGB{T}, N}(
        RGB{T}(value(r), value(g), value(b)),
        Partials(Tuple(RGB{T}.(_partials(N, r), _partials(N, g), _partials(N, b))))
    )
end

ColorTypes.RGB{T}(r::Dual{Tag,T,N}, g::Real, b::Real) where {Tag, T<:Real, N} =
    dual_rgb(Tag, T, N, r, g, b)
ColorTypes.RGB{T}(r::T, g::Dual{Tag, T, N}, b::Real) where {Tag, T<:Real, N} =
    dual_rgb(Tag, T, N, r, g, b)
ColorTypes.RGB{T}(r::T, g::T, b::Dual{Tag, T, N}) where {Tag, T<:Real, N} =
    dual_rgb(Tag, T, N, r, g, b)

ColorTypes.RGB(r::Dual{Tag,T,N}, g::Real, b::Real) where {Tag, T<:Real, N} =
    dual_rgb(Tag, T, N, r, g, b)
ColorTypes.RGB(r::T, g::Dual{Tag,T,N}, b::Real) where {Tag, T<:Real, N} =
    dual_rgb(Tag, T, N, r, g, b)
ColorTypes.RGB(r::T, g::T, b::Dual{Tag,T,N}) where {Tag, T<:Real, N} =
    dual_rgb(Tag, T, N, r, g, b)


function dual_gray(Tag, T, N, v)
    Dual{Tag, Gray{T}, N}(
        Gray{T}(value(d)),
        Partials(Tuple(Gray{T}.(partials(d))))
    )
end

ColorTypes.Gray{T}(v::Dual{Tag, T, N}) where {Tag, T, N} = dual_gray(Tag, T, N, v)

ColorTypes.Gray(v::Dual{Tag, T, N}) where {Tag, T, N} = dual_gray(Tag, T, N, v)


for f in (:red, :green, :blue)
    @eval begin
        ColorTypes.$f(c::Dual{Tag, C, N}) where {T, Tag, C<:AbstractRGB{T}, N} =
            Dual{Tag, T, N}($f(value(c)), Partials(Tuple($f.(partials(c)))))
    end
end

ColorTypes.gray(c::Dual{Tag, C, N}) where {T, Tag, C<:AbstractGray{T}, N} =
    Dual{Tag, T, N}(gray(value(c)), Partials(Tuple(gray.(partials(c)))))

end # module
