# =====================================================================
# *********************************************************************
#                    MAT-55 2024 - Lista 01 - Exercício 6 
# *********************************************************************
# =====================================================================

# =====================================================================
#                    Algoritmo de Substituição Direta
# =====================================================================
# ---------------------------------------------------------------------
# Dados de entrada:
# A     matriz nxn triangular inferior, não singular
# b     vetor n
# ---------------------------------------------------------------------
# Saída:
# b     se A é não singular, b é a solução do sistema linear Ax = b

function sub_direta(A::Array{Float64,2}, b::Array{Float64,1})

    tol = 1e-12
    n = length(b)
    
    # -----------------------------------------------------------------
    #Teste se a matriz é triangular inferior
    # Digite seu código aqui
    for i in 1:n
        if abs(A[i,i]) < tol
            error("Matriz singular")
        end
        for j in (i + 1):n
            if abs(A[i,j]) > tol
                error("A matriz não é triangular inferior")
            end
        end
    end

    # -----------------------------------------------------------------

    for i = 1:n
        s = 0.0
        for j = 1:i-1
            s = s + A[i,j]*b[j] # OU s += A[i,j]*b[j]
        end
        b[i] = ( b[i] - s ) / A[i,i]
    end
    return b
end

# =====================================================================
#                    Algoritmo de Substituição Inversa
# =====================================================================
# ---------------------------------------------------------------------
# Dados de entrada:
# A     matriz nxn triangular superior, não singular
# b     vetor n
# ---------------------------------------------------------------------
# Saída:
# b     se A é não singular, b é a solução do sistema linear Ax = b

function sub_inversa(A::Array{Float64,2}, b::Array{Float64,1})
    
    #Digite seu código aqui
    tol = 1e-12
    n = length(b)
    # teste se a matriz não é triangular superior ou singular
    for i in 1:n
        if abs(A[i,i]) < tol
            error("Matriz singular")
        end
        for j in 1:i-1
            if abs(A[i,j]) > tol
                error("A matriz não é triangular superior")
            end
        end
    end

    for i in n:-1:1
        s = 0.0
        for j = i+1:n
            s += A[i,j]*b[j] # OU s += A[i,j]*b[j]
        end
        b[i] = (b[i] - s) / A[i,i]
    end

    return b
end

# =====================================================================
#                    Algoritmo de Eliminação Gaussiana
# =====================================================================
# ---------------------------------------------------------------------
# Dados de entrada:
# A     matriz nxn triangular superior, não singular
# b     vetor n
# ---------------------------------------------------------------------
# Saída:
# b     se A é não singular, b é a solução do sistema linear Ax = b

function elim_gauss(A::Array{Float64,2}, b::Array{Float64,1})


    #Digite seu código aqui
    n = length(b)
    for i in 1:n
        # pivoteamento parcial
        max_index = i
        for j in (i+1):n
            if abs(A[j,i]) > abs(A[max_index,i])
                 max_index = j
            end
        end
        A[i, :], A[max_index, :] = A[max_index, :], A[i, :]
        b[i], b[max_index] = b[max_index], b[i]
        for j in (i+1):n
            fator = A[j,i] / A[i,i]
            for k in i:n
                A[j,k] -= fator * A[i,k]
            end
            b[j] -= fator * b[i]
        end
    end
    # Substituição inversa
    sub_inversa(A, b)
end

# =====================================================================
# =====================================================================
#			PROGRAMA PRINCIPAL
# =====================================================================
# =====================================================================

# Implemente um programa para resolver o sistema linear Ax = b, com 
#opção para o usuário fornecer a matriz A, o vetor b e escolher o método 
#utilizado, dentre as opçõe:
# a: Algoritmo de Substituição Direta.
# b: Algoritmo de Substituição Inversa. 
# C: Eliminação Gaussiana.
function solverLinearSystem(A::Array{Float64,2}, b::Array{Float64,1})
    println("Escolha o método para resolver o sistema linear:")
    println("a: Algoritmo de Substituição Direta.")
    println("b: Algoritmo de Substituição Inversa.")
    println("c: Eliminação Gaussiana.")
    metodo = readline()
    metodo = metodo[1]
    
    if metodo == 'a'
        return sub_direta(A, b)
    elseif metodo == 'b'
        return sub_inversa(A, b)
    elseif metodo == 'c'
        return elim_gauss(A, b)
    else
        return "Método inválido"
    end
end
# Dados do sistema
#Digite aqui os dados do sistema linear

b = [3.0, 4]

A = [
    1.0 0;
    2.0 -1.0 
]



