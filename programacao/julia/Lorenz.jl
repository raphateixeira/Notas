using DifferentialEquations
using LinearAlgebra
using Plots

# Sistema de Lorenz:
# dx/dt = σ(y - x)
# dy/dt = x(ρ - z) - y
# dz/dt = xy - βz

function lorenz!(du, u, p, t)
    x, y, z = u
    σ, ρ, β = p
    
    du[1] = σ * (y - x)
    du[2] = x * (ρ - z) - y
    du[3] = x * y - β * z
end

# ============================================
# GRÁFICO 1: Trajetória 3D + Série Temporal
# ============================================

p = [10.0, 28.0, 8/3]  # σ=10, ρ=28, β=8/3
u0 = [1.0, 1.0, 1.0]
tspan = (0.0, 100.0)

prob = ODEProblem(lorenz!, u0, tspan, p)
sol = solve(prob, Tsit5())

p1 = plot(sol, idxs=(1, 2, 3), xlabel="x", ylabel="y", zlabel="z", 
         title="Atrator de Lorenz 3D", legend=false, size=(600, 500))

p2 = plot(sol, xlabel="Tempo", ylabel="Valor",
         title="Série Temporal", label=["x(t)" "y(t)" "z(t)"])

plot_1 = plot(p1, p2, layout=(1, 2), size=(1200, 500))
savefig(plot_1, "1_lorenz_basico.png")

# ============================================
# GRÁFICO 2: Diferentes Valores de ρ
# ============================================

σ, β = 10.0, 8/3
rhos = [15.0, 28.0, 45.0]
u0 = [1.0, 1.0, 1.0]
tspan = (0.0, 50.0)

plots_rho = []
for ρ in rhos
    p = [σ, ρ, β]
    prob = ODEProblem(lorenz!, u0, tspan, p)
    sol = solve(prob, Tsit5())
    
    pl = plot(sol, idxs=(1, 2), title="ρ = $ρ", 
             xlabel="x", ylabel="y", legend=false, size=(500, 400))
    push!(plots_rho, pl)
end

plot_2 = plot(plots_rho..., layout=(1, 3), size=(1500, 400))
savefig(plot_2, "2_lorenz_parametros.png")

# ============================================
# GRÁFICO 3: Sensibilidade às Condições Iniciais
# ============================================

p = [10.0, 28.0, 8/3]
tspan = (0.0, 30.0)

# Duas condições iniciais muito próximas
u0_1 = [1.0, 1.0, 1.0]
u0_2 = [1.0001, 1.0, 1.0]

prob1 = ODEProblem(lorenz!, u0_1, tspan, p)
prob2 = ODEProblem(lorenz!, u0_2, tspan, p)

sol1 = solve(prob1, Tsit5())
sol2 = solve(prob2, Tsit5())

# Plotar trajetórias sobrepostas
p3a = plot(sol1, idxs=(1, 2), label="u₀ = (1, 1, 1)", 
          title="Trajetórias Divergentes", xlabel="x", ylabel="y", 
          alpha=0.7, linewidth=2)
plot!(p3a, sol2, idxs=(1, 2), label="u₀ = (1.0001, 1, 1)", 
     alpha=0.7, linewidth=2)

# Plotar divergência das trajetórias
distancia = [norm(sol1(t) - sol2(t)) for t in sol1.t]
p3b = plot(sol1.t, distancia, xlabel="Tempo", ylabel="Distância ||u₁ - u₂||", 
          title="Sensibilidade às Condições Iniciais", label="", 
          linewidth=2, color=:red)

plot_3 = plot(p3a, p3b, layout=(1, 2), size=(1200, 400))
savefig(plot_3, "3_lorenz_sensibilidade.png")

# ============================================
# Resumo
# ============================================

println("✓ Gráficos gerados:")
println("  1_lorenz_basico.png")
println("  2_lorenz_parametros.png")
println("  3_lorenz_sensibilidade.png")