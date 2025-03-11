CODIFICA DI HUFFMAN - Implementazione in Prolog
==========================================
Autori
------
Scaldaferri Matteo - 912001
Iudice Samuele - 912002

Questo progetto implementa l'algoritmo di codifica di Huffman in Prolog. La 
codifica di Huffman è un metodo di compressione dati che utilizza codici a 
lunghezza variabile per rappresentare i simboli del messaggio originale.

Struttura del Progetto
---------------------
Il progetto è composto da un singolo file 'huffman-codes.pl' che contiene 
tutti i predicati necessari per la codifica e decodifica di Huffman.

Strutture Dati
-------------
1. Nodi dell'albero:
   - node(Weight, SubTree): nodo generico con peso e sottoalbero
   - leaf(Symbol): foglia contenente un simbolo
   - tree(Left, Right): nodo interno con sottoalberi sinistro e destro

2. Simboli e pesi:
   - sw(Symbol, Weight): coppia simbolo-peso
   - sb(Symbol, Bits): coppia simbolo-codifica binaria

Predicati Principali
------------------
1. hucodec_generate_huffman_tree(SymbolsAndWeights, HuffmanTree)
   - Input: Lista di sw(Simbolo, Peso)
   - Output: Albero di Huffman
   - Esempio: hucodec_generate_huffman_tree([sw(a,5), sw(b,3)], Tree)

2. hucodec_generate_symbol_bits_table(HuffmanTree, SymbolBitsTable)
   - Input: Albero di Huffman
   - Output: Lista di sb(Simbolo, ListaDiBit)
   - Esempio: hucodec_generate_symbol_bits_table(Tree, Table)

3. hucodec_encode(Message, HuffmanTree, Bits)
   - Input: Lista di simboli, Albero di Huffman
   - Output: Lista di bit (codifica del messaggio) o errore se l'albero ha 
              una sola foglia
   - Esempio: hucodec_encode([a,b,a], Tree, Bits)
   - Nota: Genera un errore se l'albero ha una sola foglia, poiché la 
            codifica non avrebbe senso

4. hucodec_decode(Bits, HuffmanTree, Message)
   - Input: Lista di bit, Albero di Huffman
   - Output: Lista di simboli decodificati
   - Esempio: hucodec_decode([0,1,0], Tree, Message)

5. hucodec_encode_file(Filename, HuffmanTree, Bits)
   - Input: Path del file, Albero di Huffman
   - Output: Lista di bit (codifica del contenuto del file)
   - Esempio: hucodec_encode_file('test.txt', Tree, Bits)
   - Note: 
      - Eredita le stesse restrizioni di hucodec_encode per alberi con una
        sola foglia
      - Va inserito l'intero path del file da codificare

6. hucodec_print_huffman_tree(Tree)
   - Input: Albero di Huffman
   - Output: Visualizzazione testuale dell'albero
   - Esempio: hucodec_print_huffman_tree(Tree)

Predicati di Supporto
-------------------
1. convert_to_leaf_nodes/2: Converte lista di sw in nodi foglia
2. sort_nodes_by_weight/2: Ordina i nodi per peso
3. build_huffman_tree/2: Costruisce l'albero dai nodi ordinati
4. generate_codes/4: Genera i codici binari per ogni simbolo
5. count_chars/2: Conta le occorrenze dei caratteri
6. chars_to_weights/2: Converte conteggi in lista di pesi

Come Utilizzare
--------------
1. Caricare il file 'huffman-codes.pl' nel proprio ambiente Prolog

2. Creare un albero di Huffman con almeno due simboli:
   ```prolog
   ?- SymbolsAndWeights = [sw(a,5), sw(b,3)],
      hucodec_generate_huffman_tree(SymbolsAndWeights, Tree).
   ```

3. Codificare un messaggio (assicurarsi che l'albero abbia più di una foglia):
   ```prolog
   ?- hucodec_encode([a,b,a], Tree, Bits).
   ```

4. Decodificare un messaggio:
   ```prolog
   ?- hucodec_decode(Bits, Tree, DecodedMessage).
   ```

Gestione degli Errori
--------------------
1. Albero con una sola foglia:
   - La codifica viene rifiutata con un messaggio di errore
   - Motivazione: non ha senso codificare un messaggio quando c'è un solo 
                  simbolo possibile
   - Il predicato hucodec_encode fallirà con il messaggio:
     "Errore: Non e` possibile codificare un messaggio con un albero di 
                una sola foglia"

2. Altri controlli:
   - Controllo input vuoti o invalidi
   - Gestione errori di file non trovato
   - Validazione della struttura dell'albero
   - Controllo correttezza della sequenza di bit

