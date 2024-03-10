
def epsilonDeMaquina ():
    eps = 1.0
    while eps + 1 > 1:
        eps /= 2
    eps *= 2
    return eps

eps = epsilonDeMaquina()

def triangularInferior(A):
    n = len(A)
    for linha in A:
        if len(linha) != n:
            return False
        
    for i in range(n):
        for j in range(i+1, n):
            if abs(A[i][j]) > eps:         # epsilon de maquina aqui
                return False
    return True

def substituicaoDireta(A, b):
    if len(A) != len (b):
        raise ValueError(f"A matirz A é {len(A)}X{len(A)} e a matriz b tem dimensões incompatíveis")
    
    n = len(A)
    x = [0] * n
    
    # Resolvendo o sistema triangular inferior
    for i in range(n):
        soma = 0
        for j in range(i):
            soma += A[i][j] * x[j]
        x[i] = (b[i] - soma) / A[i][i]
    
    return x

def triangularSuperior(A):
    n = len(A)
    for linha in A:
        if len(linha) != n:
            return False

    n = len(A)
    for i in range(n):
        for j in range(i):
            if abs(A[i][j]) > eps:
                return False
    return True

def substituicaoInversa(A, b): 
    if len(A) != len (b):
        raise ValueError(f"A matirz A é {len(A)}X{len(A)} e a matriz b tem dimensões incompatíveis")
    
    n = len(A)
    x = [0] * n
    
    # Resolvendo o sistema triangular superior
    for i in range(n-1, -1, -1):
        soma = 0
        for j in range(i+1, n):
            soma += A[i][j] * x[j]
        x[i] = (b[i] - soma) / A[i][i]
    
    return x

def eliminacaoGaussiana(A, b):
    n = len(b)
    
    # Fase de eliminação
    for i in range(n):
        # Pivoteamento parcial
        max_index = i
        for j in range(i+1, n):
            if abs(A[j][i]) > abs(A[max_index][i]):
                max_index = j
        A[i], A[max_index] = A[max_index], A[i]
        b[i], b[max_index] = b[max_index], b[i]
        
        # Zerando os elementos abaixo do pivô
        for j in range(i+1, n):
            razao = A[j][i] / A[i][i]
            for k in range(i, n):
                A[j][k] -= razao * A[i][k]
            b[j] -= razao * b[i]
    
    # Resolvendo o sistema triangular superior
    x = [0] * n
    for i in range(n-1, -1, -1):
        x[i] = b[i] / A[i][i]
        for j in range(i):
            b[j] -= A[j][i] * x[i]
    return x

def numeroInteiro (numero):
    try:
        numero = float(numero)
        if numero == int(numero):
            return True
        return False
    except:
        return False

def numeroFloat (numero):
    try:
        numero = float(numero)
        return True
    except:
        return False
    
def criarMatrizA (tamanho):
    linha = [0 for i in range(tamanho)]
    A = [linha.copy() for i in range(tamanho)]
    return A

def printarMatriz(matriz):
    for linha in matriz:
        print (linha)

def main():
    print("\n")
    print("--------------------------------------------")
    print("- Solução exercício 6 da Lista 1 de MAT-55 -")
    print("--------------------------------------------")
    print("\n")
    n = input("Insira a dimensão do seu sistema linear: ")
    print("\n")
    while not numeroInteiro (n):
        print("A dimensão do seu sistema linear precisa ser um número inteiro.")
        n = input("Insira a dimensão do seu sistema linear novamente: ")
        print("\n")
    n = int(n)
    A = criarMatrizA(n)
    print(f"Agora vamos construir a matriz A {n}x{n}")

    for i in range (n):
        for j in range (n):
            numero = input(f"Insira o valor da posição A[{i + 1}][{j + 1}]: ")
            while not numeroFloat (numero):
                print("\n")
                print("O seu input precisa ser um número real")
                numero = input(f"Insira o valor da posição A[{i + 1}][{j + 1}] novamente: ")

            A[i][j] = float(numero)
            print("\n")

            printarMatriz(A)

    print("\n")
    print(f"Agora vamos construir a matriz b {n}x1")

    b = [0 for i in range(n)]
    for i in range (n):
        numero = input(f"Insira o valor da posição b[{i + 1}][1]: ")
        while not numeroFloat (numero):
            print("\n")
            print("O seu input precisa ser um número real")
            numero = input(f"Insira o valor da posição b[{i + 1}][1] novamente: ")

        b[i] = float(numero)
        print("\n")

        print(b)

    print("\n")
    print(f"Agora selecione o método de resolução desejado: ")
    # print(f"Digite 1 para selecionar o Algoritmo de Substituição Direta")
    # print(f"Digite 2 para selecionar o Algoritmo de Substituição Inversa")
    # print(f"Digite 3 para selecionar o Algoritmo de Eliminação Gaussian")
    # opcao = input(f"Insira a opção desejada: ")
    # print("\n")
    opcao = 0
    while not numeroInteiro (opcao) or not (int(opcao) <= 3 and int(opcao) >= 1) :
        print(f"Digite 1 para selecionar o Algoritmo de Substituição Direta")
        print(f"Digite 2 para selecionar o Algoritmo de Substituição Inversa")
        print(f"Digite 3 para selecionar o Algoritmo de Eliminação Gaussian")
        opcao = input(f"Insira a opção desejada: ")
        print("\n")

        if opcao  == '1':
            if not triangularInferior(A):
                print("A matriz inserida não é triangular inferior e portanto não condiz com o método da Substituição Direta")
                print("\n")
                opcao = 0
            else:
                print ("Solução: ")
                try:
                    print(substituicaoDireta(A, b))
                except:
                    print('A matriz inserida é singular')
                
        elif opcao  == '2':
            if not triangularSuperior (A):
                print("A matriz inserida não é triangular superior e portanto não condiz com o método da Substituição Inversa")
                print("\n")
                opcao = 0
            else:
                print ("Solução: ")
                try:
                    print(substituicaoInversa(A, b))
                except:
                    print('A matriz inserida é singular')
        elif opcao  == '3':
            print ("Solução: ")
            try:
                print(eliminacaoGaussiana(A, b))
            except:
                print('A matriz inserida é singular')
        else:
            print("Opção inválida, tente novamente")
            print("\n")
            
    print("\n")
    print ("Fim")    

main ()