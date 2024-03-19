using LinearAlgebra

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
#  Algoritmo de Fatoração LU - sem pivoteamento - com pivoteamento parcial
# =====================================================================
# ---------------------------------------------------------------------
# Dados de entrada:
# A     matriz nxn triangular superior, não singular
# b     vetor n
# ---------------------------------------------------------------------
# Saída:
# b     se A é não singular, b é a solução do sistema linear Ax = b
function matrizesLUSemPivoteamento(A::Array{Float64,2})
    n = size(A, 1)
    L = Matrix{Float64}(I, n, n)
    U = copy(A)

    for k in 1:n-1
        for j in k+1:n
            m = U[j, k] / U[k, k]
            L[j, k] = m
            U[j, k:end] -= m * U[k, k:end]
        end
    end

    return L, U
end

function matrizesLUComPivoteamentoParcial(A::Array{Float64,2})
    tol = 1e-12
    n = size(A, 1)
    L = zeros(n, n)
    U = copy(A)
    P = zeros(n, n)

    for i in 1:n
        L[i, i] = 1
        P[i, i] = 1
    end


    for i in 1:n-1
        # verificar qual linha tem o elemento U[i, i] de maior modulo
        max = abs(U[i,i])
        linhaMax = i
        for j in i:n
            if abs(U[j, i]) > max
                max = abs(U[j, i])
                linhaMax = j
            end
        end
        if max < tol
            error("Matriz singular")
        end

        # permutar linhas
        if linhaMax !=i
            U[i, :], U[linhaMax, :] = U[linhaMax, :], U[i, :]
            L[i, 1:i-1], L[linhaMax, 1:i-1] = L[linhaMax, 1:i-1], L[i, 1:i-1]
            P[i, :], P[linhaMax, :] = P[linhaMax, :], P[i, :]
        end
        # Fazer a eliminação gaussiana
        for j = i+1:n
            factor = U[j, i] / U[i, i]
            L[j, i] = factor
            U[j, i:n] -= factor * U[i, i:n]
        end
    end

    return L, U, P
    
end

function solverFatoracaoLUSemPivoteamento(A::Array{Float64,2}, b::Array{Float64,1})
    L, U = matrizesLUSemPivoteamento(A)
    d = sub_direta(L, b)
    x = sub_inversa(U, d)

    return x

end

function solverFatoracaoLUComPivoteamentoParcial(A::Array{Float64,2}, b::Array{Float64,1})
    L, U, P = matrizesLUComPivoteamentoParcial(A)
    b = P*b
    d = sub_direta(L, b)
    x = sub_inversa(U, d)

    return x

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
# c: Eliminação Gaussiana.
function solverLinearSystem(A::Array{Float64,2}, b::Array{Float64,1})
    println("Escolha o método para resolver o sistema linear:")
    println("a: Algoritmo de Substituição Direta.")
    println("b: Algoritmo de Substituição Inversa.")
    println("c: Eliminação Gaussiana.")
    println("d: Fatoração LU sem pivoteamento.")
    println("e: Fatoração LU com pivoteamento parcial.")
    metodo = readline()
    metodo = metodo[1]
    
    if metodo == 'a'
        return sub_direta(A, b)
    elseif metodo == 'b'
        return sub_inversa(A, b)
    elseif metodo == 'c'
        return elim_gauss(A, b)
    elseif metodo == 'd'
        return solverFatoracaoLUSemPivoteamento(A, b)
    elseif metodo == 'e'
        return solverFatoracaoLUComPivoteamentoParcial(A, b)
    else
        return "Método inválido"
    end
end



# Dados do sistema
#Digite aqui os dados do sistema linear


b = [4.0, 8, 10]

A = [
    4.0 10 0;
    7 7 1;
    0 0 10
]

println(solverLinearSystem(A, b))  




