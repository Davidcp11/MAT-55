import numpy as np


def triangularInfOrSup(matriz: list[list[int]], type: str = "superior") -> bool:
    n = len(matriz)
    if type == "superior":
        for i in range(n):
            if matriz[i][i] == 0:
                return False
            for j in range(0, i):
                if matriz[i][j] != 0:
                    return False
        return True
    elif type == "inferior":
        for i in range(n):
            if matriz[i][i] == 0:
                return False
            for j in range(i + 1, n):
                if matriz[i][j] != 0:
                    return False
        return True


A = [
    [1, 2, 3],
    [5, 2, 1],
    [1, 3, 4]
]
b = [14, 12, 19]


def solverLinearSistem(matriz_A: list[list[int]], vetor_b: list[int], algoritmo: str = "eliminacao gaussiana") -> list:
    """
    :param matriz_A:
    :param vetor_b:
    :param algoritmo:
    :return:
    """
    if algoritmo == "substituicao direta":
        if triangularInfOrSup(matriz_A, type="inferior"):
            n = len(vetor_b)
            x = [0] * n
            for i in range(n):
                soma = sum(matriz_A[i][j] * x[j] for j in range(i))
                x[i] = (vetor_b[i] - soma) / matriz_A[i][i]
            return x
        else:
            print("A matriz informada nao e' triangular inferior")
    elif algoritmo == "substituicao reversa":
        if triangularInfOrSup(matriz_A):
            n = len(vetor_b)
            x = [0] * n
            for i in range(n - 1, -1, -1):
                soma = sum(matriz_A[i][j] * x[j] for j in range(i + 1))
                x[i] = (vetor_b[i] - soma) / matriz_A[i][i]
            return x
        else:
            print("A matriz informada nao e' triangular superior")
    else:
        n = len(vetor_b)
        for i in range(n):
            max_index = i
            for j in range(i+i,n):
                if abs(matriz_A[j][i]) > abs(matriz_A[max_index][i]):
                    max_index = j
            matriz_A[i], matriz_A[max_index] = matriz_A[max_index], matriz_A[i]
            vetor_b[i], vetor_b[max_index] = vetor_b[max_index], vetor_b[i]

            # Eliminacao gaussiana
            for j in range(i+1, n):
                fator = (matriz_A[j][i]) / matriz_A[i][i]
                for k in range(i, n):
                    matriz_A[j][k] -= fator * matriz_A[i][k]
                vetor_b[j] -= fator * vetor_b[i]
        # Substituicao reversa
        x = [0] * n
        for i in range(n - 1, -1, -1):
            soma = sum(matriz_A[i][j] * x[j] for j in range(i + 1, n))
            x[i] = (vetor_b[i] - soma) / matriz_A[i][i]
        return x


print(solverLinearSistem(A, b))
