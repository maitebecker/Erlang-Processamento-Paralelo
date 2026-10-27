# Erlang - Processamento Paralelo

## Sobre o projeto

Esse projeto tem como objetivo planejar, implementar e analisar um pequeno experimento prático envolvendo processamento paralelo.

O programa compara a execução sequencial e a execução paralela de um cálculo computacional aplicado a uma sequência de números. Na execução paralela, o trabalho é dividido entre múltiplos processos Erlang, que calculam resultados parciais e os enviam ao processo principal para obter o resultado final.

## Como executar

### 1. Acessar a pasta do projeto

No Erlang Shell, acesse a pasta `src` do projeto, por exemplo:

```erlang
cd("C:/Erlang-Processamento-Paralelo/src").
```

**Observação:** ajuste o caminho conforme a localização do projeto no seu computador.

### 2. Compilar o programa

Compile o arquivo `paralelo.erl`:

```erlang
c(paralelo).
```

Se a compilação for concluída com sucesso, o shell retornará ` {ok, paralelo}`.

### 4. Executar o programa

O código apresentado atualmente exporta a função `executar/3`, que recebe três parâmetros:

- `N`: quantidade de números processados.
- `P`: quantidade de processos utilizados na execução paralela.
- `Iter`: quantidade de iterações realizadas para cada número.

Para executar, por exemplo, com 1.000 números, 4 processos e 100 iterações por número:

```erlang
paralelo:executar(1000, 4, 100).
```

## Métricas analisadas

- **Tempo de execução:** tempo necessário para concluir o cálculo, medido em microssegundos.
- **Speedup:** relação entre o tempo sequencial e o tempo paralelo. Valores maiores que 1 indicam que a execução paralela foi mais rápida.
- **Eficiência:** relação entre o speedup e a quantidade de processos utilizados, expressa em porcentagem.
