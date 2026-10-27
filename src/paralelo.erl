
-module(paralelo).

-export([executar/3]).

%% N = quantidade de numeros
%% P = quantidade de processos
%% Iter = quantidade de iteracoes por numero
executar(N, P, Iter)
        when N > 0, P > 0, Iter > 0 ->

    Numeros = lists:seq(1, N), %% Cria uma lista com os números inteiros de 1 até N

    {TempoSeq, ResultadoSeq} =
        medir(fun() -> calcular(Numeros, Iter) end),

    {TempoPar, ResultadoPar} =
        medir(fun() -> soma_paralela(Numeros, P, Iter) end),

    Speedup = TempoSeq / max(TempoPar, 1),
    Eficiencia = Speedup / P * 100,

    io:format("~nEntrada: ~p numeros~n", [N]), %% ~p exibe o valor e ~n insere uma quebra de linha
    io:format("Processos: ~p~n", [P]),
    io:format("Iteracoes por numero: ~p~n", [Iter]),
    io:format("Resultado sequencial: ~p~n", [ResultadoSeq]),
    io:format("Resultado paralelo: ~p~n", [ResultadoPar]),
    io:format("Tempo sequencial: ~p us~n", [TempoSeq]),
    io:format("Tempo paralelo: ~p us~n", [TempoPar]),
    io:format("Speedup: ~.3f~n", [Speedup]),
    io:format("Eficiencia: ~.2f%~n", [Eficiencia]);

executar(_, _, _) ->
    io:format("N, P e Iter devem ser maiores que zero.~n").

%% Mede o tempo em microssegundos.
medir(Fun) ->
    Inicio = erlang:monotonic_time(microsecond),
    Resultado = Fun(),
    Fim = erlang:monotonic_time(microsecond),
    {Fim - Inicio, Resultado}.

%% Calcula uma funcao mais custosa para cada numero recursivamente
calcular([], _) ->
    0;
calcular([N | Restantes], Iter) -> %% separa o primeiro elemento (N) do restante da lista (Restantes)
    custo(N, Iter) + calcular(Restantes, Iter).

%% Realiza Iter operacoes dependentes entre si.
custo(N, Iter) ->
    custo(N, Iter, 1).

custo(_, 0, Acumulador) ->
    Acumulador;
custo(N, Iter, Acumulador) ->
    Novo = (Acumulador * 1103515245 + N + Iter)
           rem 2147483647,
    custo(N, Iter - 1, Novo).

%% Divide o trabalho entre processos.
soma_paralela(Numeros, P, Iter) ->
    Blocos = dividir(Numeros, P),
    Pai = self(),

    Pids = [
        spawn(fun() ->
            Soma = calcular(Bloco, Iter),
            Pai ! {resultado, self(), Soma}
        end)
        || Bloco <- Blocos
    ],

    coletar(Pids, 0).

dividir([], _) ->
    [];
dividir(Numeros, P) ->
    Tamanho = (length(Numeros) + P - 1) div P,
    {Bloco, Restante} = separar(Numeros, Tamanho),
    [Bloco | dividir(Restante, P)].

separar(Lista, Tamanho) ->
    lists:split(min(Tamanho, length(Lista)), Lista).

%% Coleta os resultados dos processos.
coletar([], Total) ->
    Total;
coletar([Pid | Restantes], Total) ->
    receive
        {resultado, Pid, Soma} ->
            coletar(Restantes, Total + Soma)
    end.
