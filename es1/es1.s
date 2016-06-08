# Title: Simulatore di chiamate a procedura     Filename: es1.s
# Author1: ??? ?????    ???????     ???.?????@stud.unifi.it
# Author2: ??? ?????    ???????     ???.?????@stud.unifi.it
# Author3: ??? ?????    ???????     ???.?????@stud.unifi.it
# Date: ??/??/????
# Description:  Chiamate a procedura per l'esecuzione di operazioni aritmetiche
# Input: chiamate.txt
# Output: traccia delle chiamate su console

################# Data segment #####################
.data
file:           .asciiz "chiamate.txt"
tab:            .asciiz "\t"
newline:        .asciiz "\n"
arrow_r:        .asciiz "-->"
arrow_l:        .asciiz "<--"
buffer:         .space  1024
sum_return:     .asciiz "somma-return"
sub_return:     .asciiz "sottrazione-return"
prod_return:    .asciiz "prodotto-return"
div_return:     .asciiz "divisione-return"

################# Code segment #####################
.text
.globl main

### Print call ###
print_call:
    move $t0, $a0   # copia i tre parametri in registri temporanei
    move $t1, $a1
    move $t2, $a2
    
print_call_tabs:
    beq $t2, $zero, print_call_arrow    # se la profondità ha è 0, allora procede a stampare la stringa
                                        # altrimenti
    li $v0, 4   # stampa una tabulazione
    la $a0, tab
    syscall
    
    addi $t2, $t2, -1   # decrementa la profondità
    
    j print_call_tabs   # ed esegue un altro ciclo
    
print_call_arrow:
    li $v0, 4       # stampa la freccia verso destra
    la $a0, arrow_r
    syscall
    
print_call_string:
    li $v0, 11      # stampa il carattere puntato da $a0
    lb $a0, 0($t0)
    syscall
    
    beq $t0, $t1, print_call_done   # se i puntatori d'inizio e di fine coincidono allora la stringa è finita
    
    addi $t0, $t0, 1    # altrimenti incrementa il puntatore d'inizio (scorre al prossimo carattere)
    
    j print_call_string # ed esegue un altro ciclo
    
print_call_done:
    li $v0, 4       # alla fine stampa una newline (a capo)
    la $a0, newline
    syscall
    
    jr $ra  # e torna al chiamante
### Print call end ###

### Print return ###
print_return:
    move $t0, $a0   # copia i tre parametri in registri temporanei
    move $t1, $a1
    move $t2, $a2
    
print_return_tabs:  # analogo a print_call_tabs
    beq $t2, $zero, print_return_string
    
    li $v0, 4
    la $a0, tab
    syscall
    
    addi $t2, $t2, -1
    
    j print_return_tabs
    
print_return_string:
    li $v0, 4       # stampa la freccia verso sinistra
    la $a0, arrow_l
    syscall
    move $a0, $t0   # stampa la stringa di ritorno relativa all'operazione
    syscall
    li $v0, 11      # stampa il simbolo di aperta parentesi
    li $a0, '('
    syscall
    li $v0, 1       # stampa il risultato dell'operazione
    move $a0, $t1
    syscall
    li $v0, 11      # stampa il simbolo di chiusa parentesi
    li $a0, ')'
    syscall
    li $v0, 4       # stampa una newline (a capo)
    la $a0, newline
    syscall
    
    jr $ra  # infine torna al chiamante
### Print return end ###

### Get operands ###
get_operands:
    addi $sp, $sp, -20  # alloca spazio per 5 words nello stack frame
    sw $ra, 16($sp)     # salva l'indirizzo di ritorno
    sw $a1, 12($sp)     # il puntatore di fine
    addi $a2, $a2, 1    # e la profondità della chiamata incrementata di 1
    sw $a2, 8($sp)
    
    move $t0, $a0   # inizializza $t0 con il puntatore d'inizio
    move $t1, $zero # e $t1 con 0 ($t1 indica il numero di parentesi aperte ma non ancora chiuse)
    
get_operands_search:
    lb $t3, 0($t0)                      # carica il carattere puntato da $t0
    li $t4, '('
    beq $t3, $t4, get_operands_open     # controlla se è una parentesi aperta
    li $t4, ')'
    beq $t3, $t4, get_operands_close    # una parentesi chiusa
    li $t4, ','
    beq $t3, $t4, get_operands_comma    # oppure una virgola
    j get_operands_advance              # altrimenti va avanti senza fare niente
    
get_operands_open:
    addi $t1, $t1, 1        # se si trova una parentesi aperta si incremente $t1
    j get_operands_advance  # e si passa al prossimo carattere
    
get_operands_close:
    addi $t1, $t1, -1       # se si trova una parentesi chiusa si decremente $t1
    j get_operands_advance  # e si passa al prossimo carattere
    
get_operands_comma:
    beq $t1, $zero, get_operands_found  # se si trova una virgola e le parentesi sono bilanciate, allora si è trovato il punto di divisione
    j get_operands_advance              # altrimenti si passa al prossimo carattere
    
get_operands_advance:
    addi $t0, $t0, 1        # incrementa di 1 il puntatore $t0
    j get_operands_search   # e continua la ricerca
    
get_operands_found:
    sw $t0, 4($sp)  # salva il puntatore alla virgola nello stack
    
    addi $t0, $t0, -1   # decrementa il puntatore $t0 (carattere subito prima della virgola)
    move $a1, $t0       # e lo imposta come secondo parametro per analyze
    
    jal analyze # invoca analyze sul primo operando con profondità incrementata di 1
    
    sw $v0, 0($sp)  # salva il valore del primo operando nello stack
    
    lw $a0, 4($sp)      # recupera il puntatore alla virgola
    addi $a0, $a0, 1    # e lo imposta come primo parametro (puntatore d'inizio) incrementandolo di 1 (primo carattere dopo la virgola)
    lw $a1, 12($sp)     # recupera il puntatore di fine
    lw $a2, 8($sp)      # recupera la profondità incrementata di 1
    
    jal analyze # invoca analyze sul primo operando con profondità incrementata di 1
    
    move $v1, $v0   # salva il valore del secondo operando come secondo risultato
    lw $v0, 0($sp)  # recupera il valore del primo operando e lo imposta come primo risultato
    
    lw $ra, 16($sp)     # recupera l'indirizzo di ritorno
    addi $sp, $sp, 20   # dealloca lo stack frame
    jr $ra              # ritorna al chiamante
### Get operands end ###

### Call sum ###
call_sum:
    addi $sp, $sp, -20  # alloca spazio per cinque words nello stack frame
    sw $ra, 16($sp)     # salva l'indirizzo di ritorno
    sw $a0, 12($sp)     # il puntatore d'inizio
    sw $a1, 8($sp)      # il puntatore di fine
    sw $a2, 4($sp)      # e la profondità della chiamata
    
    jal print_call      # invoca la procedura per la stampa dell'invocazione (con gli stessi parametri)
    
    lw $a0, 12($sp)     # recupera il puntatore d'inizio dallo stack
    addi $a0, $a0, 6    # salta la stringa "somma(" (6 caratteri)
    lw $a1, 8($sp)      # recupera il puntatore di fine
    addi $a1, $a1, -1   # scarta l'ultima parentesi chiusa
    lw $a2, 4($sp)      # recupera la profondità della chiamata
    
    jal get_operands    # invoca la procedura per ottenere gli operandi
    
    add $v0, $v0, $v1   # somma i due operandi ottenuti
    sw $v0, 0($sp)      # salva il risultato nello stack
    
    la $a0, sum_return  # carica l'indirizzo della stringa sum_return (primo parametro)
    move $a1, $v0       # imposta il risultato dell'operazione come secondo parametro
    lw $a2, 4($sp)      # recupera la profondità della chiamata (terzo parametro)
    
    jal print_return    # invoca la stampa del risultato con questi tre parametri
    
    lw $v0, 0($sp)      # recupera il risultato dell'operazione
    lw $ra, 16($sp)     # recupera l'indirizzo di ritorno
    addi $sp, $sp, 20   # dealloca lo stack frame
    jr $ra              # torna al chiamante
### Call sum end ###

### Call subtraction ###
call_sub:               # call_sub, call_prod e call_div analoghe a call_sum
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $a0, 12($sp)
    sw $a1, 8($sp)
    sw $a2, 4($sp)
    
    jal print_call
    
    lw $a0, 12($sp)
    addi $a0, $a0, 12   # salta la stringa "sottrazione(" (12 caratteri)
    lw $a1, 8($sp)
    addi $a1, $a1, -1
    lw $a2, 4($sp)
    
    jal get_operands
    
    sub $v0, $v0, $v1   # sottrae il secondo operando al primo
    sw $v0, 0($sp)
    
    la $a0, sub_return  # carica l'indirizzo della stringa sub_return (primo parametro)
    move $a1, $v0
    lw $a2, 4($sp)
    
    jal print_return
    
    lw $v0, 0($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra
### Call subtraction end ###

### Call product ###
call_prod:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $a0, 12($sp)
    sw $a1, 8($sp)
    sw $a2, 4($sp)
    
    jal print_call
    
    lw $a0, 12($sp)
    addi $a0, $a0, 9    # salta la stringa "prodotto(" (9 caratteri)
    lw $a1, 8($sp)
    addi $a1, $a1, -1
    lw $a2, 4($sp)
    
    jal get_operands
    
    mul $v0, $v0, $v1   # moltiplica i due operandi ottenuti
    sw $v0, 0($sp)
    
    la $a0, prod_return # carica l'indirizzo della stringa prod_return (primo parametro)
    move $a1, $v0
    lw $a2, 4($sp)
    
    jal print_return
    
    lw $v0, 0($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra
### Call product end ###

### Call division ###
call_div:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $a0, 12($sp)
    sw $a1, 8($sp)
    sw $a2, 4($sp)
    
    jal print_call
    
    lw $a0, 12($sp)
    addi $a0, $a0, 10   # salta la stringa "divisione(" (10 caratteri)
    lw $a1, 8($sp)
    addi $a1, $a1, -1
    lw $a2, 4($sp)
    
    jal get_operands
    
    div $v0, $v0, $v1   # divide (operazione quoziente) il primo operando per il secondo
    sw $v0, 0($sp)
    
    la $a0, div_return  # carica l'indirizzo della stringa div_return (primo parametro)
    move $a1, $v0
    lw $a2, 4($sp)
    
    jal print_return
    
    lw $v0, 0($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra
### Call division end ###
    
### Analyze ###
analyze:
    addi $sp, $sp, -4  # alloca spazio per una word nello stack frame
    sw $ra, 0($sp)     # salva l'indirizzo di ritorno del chiamante
    
    lb $t0, 0($a0)                  # carica il primo carattere della stringa
    li $t1, 's'                     # se è 's'
    beq $t0, $t1, analyze_sum_sub   # allora è una somma o una sottrazione
    li $t1, 'p'                     # se è 'p'
    beq $t0, $t1, jump_prod         # allora è un prodotto
    li $t1, 'd'                     # se è 'd'
    beq $t0, $t1, jump_div          # allora è una divisione
    j analyze_int                   # altrimenti è già un intero
    
analyze_sum_sub:
    lb $t0, 2($a0)           # carica il terzo carattere della stringa
    li $t1, 'm'              # se è 'm'
    beq $t0, $t1, jump_sum   # allora è una somma
    j jump_sub               # altrimenti è una sottrazione
    
jump_sum:
    jal call_sum    # invoca la procedura relativa alla somma
    j analyze_end   # quando ritorna invoca la fine dell'analisi (comune a tutte le operazioni)
    
jump_sub:           # sub, prod e div analoghe a sum
    jal call_sub
    j analyze_end
    
jump_prod:
    jal call_prod
    j analyze_end
    
jump_div:
    jal call_div
    j analyze_end
    
analyze_int:
    move $v0, $zero #inizializza il valore dell'intero a 0
    
analyze_int_loop:
    lb $t1, 0($a0)      # carica il carattere puntato da $a0
    addi $t1, $t1, -48  # sottrae 48 (parsing da codifica ASCII a intero)
    add $v0, $v0, $t1   # somma la cifra ottenuta ($t1) col valore fin'ora calcolato ($v0)
    
    beq $a0, $a1, analyze_end   # se i puntatori d'inizio e fine coincidono allora era l'ultimo carattere
                                # altrimenti
    li $t2, 10
    mul $v0, $v0, $t2   # moltiplica il valore fin'ora calcolato per 10
    addi $a0, $a0, 1    # incrementa il puntatore di 1 (prossimo carattere)
    
    j analyze_int_loop  # ed esegue un altro ciclo
    
analyze_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
### Analyze end ###

### Main ###
main:
    li $v0, 13      # apre il file (syscall)
    la $a0, file    # carica il nome del file
    li $a1, 0       # sola lettura
    li $a2, 0
    syscall
    move $t0, $v0   # salva il file descriptor
    
    li $v0, 14      # lettura (syscall)
    move $a0, $t0   # carica il file descriptor
    la $a1, buffer  # carica il buffer
    li $a2, 1024    # specifica la dimensione
    syscall
    move $t1, $v0   # salva la lunghezza della stringa
    
    li $v0, 16      # chiusura del file (syscall)
    move $a0, $t0   # carica il file descriptor
    syscall

    la $a0, buffer      # prepara il primo argomento (puntatore d'inizio)
    addi $a0, $a0, 1
    la $a1, buffer      # il secondo argomento (puntatore di fine)
    add $a1, $a1, $t1
    addi $a1, -2
    li $a2, 0           # ed il terzo (profondità delle chiamate)
    
    jal analyze # inizia analizzando l'intera stringa
    
    li $v0, 10  # uscita dal programma (syscall)
    syscall
### Main end ###
