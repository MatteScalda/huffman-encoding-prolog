% Gruppo:
% Scaldaferri Matteo - 912001
% Iudice Samuele - 912002

% Predicato per generare l'albero di Huffman da una lista di simboli e pesi
hucodec_generate_huffman_tree(SymbolsAndWeights, HuffmanTree) :-
    % Converti la lista di sw in una lista di nodi foglia
    convert_to_leaf_nodes(SymbolsAndWeights, Nodes),
    % Ordina i nodi per peso
    sort_nodes_by_weight(Nodes, SortedNodes),
    % Costruisci l'albero
    build_huffman_tree(SortedNodes, HuffmanTree).

% Converti lista di sw in lista di nodi foglia
convert_to_leaf_nodes([], []).
convert_to_leaf_nodes([sw(Sym, W)|Rest], [node(W, leaf(Sym))|Nodes]) :-
    convert_to_leaf_nodes(Rest, Nodes).

% Ordina i nodi per peso
sort_nodes_by_weight(Nodes, SortedNodes) :-
    sort_nodes(Nodes, SortedNodes).

% Implementazione del bubble sort per i nodi
sort_nodes(Nodes, SortedNodes) :-
    bubble_sort(Nodes, SortedNodes).

bubble_sort(List, Sorted) :- 
    bubble_sort_step(List, [], Sorted).

bubble_sort_step([], Acc, Acc).
bubble_sort_step([X], Acc, Sorted) :- !,
    append(Acc, [X], Sorted).
bubble_sort_step([X,Y|Rest], Acc, Sorted) :-
    compare_and_swap(X, Y, MinNode, MaxNode),
    append(Acc, [MinNode], NewAcc),
    bubble_sort_step([MaxNode|Rest], NewAcc, Sorted).

% Confronta due nodi e li ordina per peso
compare_and_swap(node(W1,T1), node(W2,T2), node(W1,T1), node(W2,T2)) :-
    W1 =< W2, !.
compare_and_swap(node(W1,T1), node(W2,T2), node(W2,T2), node(W1,T1)).

% Costruisce l'albero di Huffman da una lista ordinata di nodi
build_huffman_tree([Node], Node) :- !.
build_huffman_tree([Node1, Node2|Rest], FinalTree) :-
    Node1 = node(W1, Tree1),
    Node2 = node(W2, Tree2),
    NewWeight is W1 + W2,
    NewNode = node(NewWeight, tree(node(W1, Tree1), node(W2, Tree2))),
    insert_node(NewNode, Rest, UpdatedNodes),
    build_huffman_tree(UpdatedNodes, FinalTree).

% Inserisce un nuovo nodo mantenendo l'ordinamento per peso
insert_node(Node, [], [Node]) :- !.
insert_node(Node, [H|T], [Node,H|T]) :-
    Node = node(W1, _),
    H = node(W2, _),
    W1 =< W2, !.
insert_node(Node, [H|T], [H|Rest]) :-
    insert_node(Node, T, Rest).

% Genera la tabella di codifica simbolo-bits
hucodec_generate_symbol_bits_table(HuffmanTree, SymbolBitsTable) :-
    generate_codes(HuffmanTree, [], [], SymbolBitsTable).

% Genera i codici per ogni simbolo nell'albero
generate_codes(node(_, leaf(Symbol)), Bits, Acc, [sb(Symbol, Bits)|Acc]) :- 
    !.
generate_codes(node(_, tree(Left, Right)), Bits, Acc, Result) :-
    append(Bits, [0], LeftBits),
    append(Bits, [1], RightBits),
    generate_codes(Left, LeftBits, Acc, TempResult),
    generate_codes(Right, RightBits, TempResult, Result).

% Codifica un messaggio usando l'albero di Huffman
hucodec_encode(_, node(_, leaf(_)), _) :- 
    write('Errore: Non e` possibile codificare un messaggio con 
    un albero di una sola foglia'), nl,
    !, fail.
hucodec_encode(Message, HuffmanTree, Bits) :-
    hucodec_generate_symbol_bits_table(HuffmanTree, SymbolBitsTable),
    encode_message(Message, SymbolBitsTable, Bits).

% Codifica un messaggio usando la tabella di codifica
encode_message([], _, []) :- !.
encode_message([Symbol|Rest], SymbolBitsTable, Bits) :-
    member(sb(Symbol, SymbolBits), SymbolBitsTable),
    encode_message(Rest, SymbolBitsTable, RestBits),
    append(SymbolBits, RestBits, Bits).

% Decodifica una sequenza di bit usando l'albero di Huffman
hucodec_decode(Bits, HuffmanTree, Message) :-
    decode_bits(Bits, HuffmanTree, HuffmanTree, Message).

% Decodifica i bit in simboli
decode_bits([], _, _, []) :- !.
decode_bits(Bits, OrigTree, CurrentNode, [Symbol|RestMessage]) :-
    decode_symbol(Bits, OrigTree, CurrentNode, Symbol, RemainingBits),
    decode_bits(RemainingBits, OrigTree, OrigTree, RestMessage).

% Decodifica un singolo simbolo
decode_symbol([0|Rest], _, node(_, tree(Left, _)), Symbol, Rest) :-
    get_symbol(Left, Symbol), !.
decode_symbol([1|Rest], _, node(_, tree(_, Right)), Symbol, Rest) :-
    get_symbol(Right, Symbol), !.
decode_symbol([0|Rest], Tree, node(_, tree(L, _)), Symbol, RemainingBits) :-
    decode_symbol(Rest, Tree, L, Symbol, RemainingBits).
decode_symbol([1|Rest], Tree, node(_, tree(_, R)), Symbol, RemainingBits) :-
    decode_symbol(Rest, Tree, R, Symbol, RemainingBits).

% Ottiene il simbolo da un nodo foglia
get_symbol(node(_, leaf(Symbol)), Symbol) :- !.

% Codifica un file usando l'albero di Huffman
hucodec_encode_file(Filename, HuffmanTree, Bits) :-
    % Leggi il contenuto del file
    open(Filename, read, Stream),
    read_string(Stream, _, String),
    close(Stream),
    % Converti la stringa in lista di caratteri
    string_chars(String, Chars),
    % Codifica la lista di caratteri
    hucodec_encode(Chars, HuffmanTree, Bits).

% Stampa l'albero di Huffman
hucodec_print_huffman_tree(Tree) :-
    write('Albero di Huffman:'), nl,
    print_node(Tree, 0).

print_node(node(Weight, SubTree), Level) :-
    print_spaces(Level),
    format('Peso: ~w~n', [Weight]),
    NextLevel is Level + 2,
    print_subtree(SubTree, NextLevel).

print_subtree(leaf(Symbol), Level) :-
    print_spaces(Level),
    format('Foglia: ~w~n', [Symbol]), !.
print_subtree(tree(Left, Right), Level) :-
    print_node(Left, Level),
    print_node(Right, Level).

print_spaces(0) :- !.
print_spaces(N) :-
    write(' '),
    N1 is N - 1,
    print_spaces(N1).