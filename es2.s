# Title: Scheduler di processi                  Filename: es2.s
# Author: ???-???-???                           Date: 26/05/2016
# Description:  Gestione dello scheduling di processi
# Input: chiamate.txt
# Output: traccia delle chiamate su console

################# Data segment #####################
.data
buffer:                     .space  1024
tab:                        .asciiz "\t"
newline:                    .asciiz "\n"
insert_command:             .asciiz "Inserire un comando (INVIO stampa il menu): "
menu:                       .asciiz "  Menu:\n    1. Inserisci un nuovo task;\n    2. Esegui il task in testa alla coda;\n    3. Esegui un task specifico;\n    4. Elimina un task specifico;\n    5. Modifica la priorità di un task specifico;\n    6. Cambia poitica di scheduling;\n    7. Termina il programma.\n\n"
exiting:                    .asciiz "  Programma terminato."
insert_task_msg:            .asciiz "  Inserimento di un nuovo task.\n"
insert_id_msg:              .asciiz "    Inserire l'ID del task: "
insert_name_msg:            .asciiz "    Inserire il nome del task (max 8 caratteri): "
insert_prio_msg:            .asciiz "    Inserire la priorità del task (min 0, max 9): "
insert_cycles_msg:          .asciiz "    Inserire il numero di cicli di CPU del task (min 1, max 99): "
insert_task_done_msg:       .asciiz "  Task correttamente inserito!\n\n"
run_first_msg:              .asciiz "  Esecuzione del primo task.\n"
empty_msg:                  .asciiz "    Coda vuota.\n"
task_msg:                   .asciiz "    Task con ID "
executed_msg:               .asciiz " eseguito.\n"
completed_msg:              .asciiz " terminato!\n"
run_done_msg:               .asciiz "  Task correttamente eseguito!\n\n"
run_not_done_msg:           .asciiz "  Nessun task eseguito!\n\n"
run_id_msg:                 .asciiz "  Esecuzione di un task specifico.\n"
choose_id_msg:              .asciiz "    Inserire l'ID del task da "
choose_id_run_msg:          .asciiz "eseguire: "
id_not_found_msg:           .asciiz " non trovato.\n"
id_duplicate_msg:           .asciiz " già presente.\n"
delete_id_msg:              .asciiz "  Eliminazione di un task specifico.\n"
choose_id_delete_msg:       .asciiz "eliminare: "
new_prio_msg:               .asciiz "    Inserire la nuova priorità del task (min 0, max 9): "
delete_id_done_msg:         .asciiz "  Task correttamente eliminato!\n\n"
delete_id_not_done_msg:     .asciiz "  Nessun task eliminato!\n\n"
change_prio_msg:            .asciiz "  Modifica della priorità di un task specifico.\n"
choose_id_change_prio_msg:  .asciiz "modificare: "
change_prio_done_msg:       .asciiz "  Priorità del task correttamente modificata!\n\n"
change_prio_not_done_msg:   .asciiz "  Nessun task modificato!\n\n"
change_sched_msg:           .asciiz "  Cambio della politica di scheduling.\n"
change_sched_old_msg:       .asciiz "    Politica di scheduling attuale: su "
change_sched_new_msg:       .asciiz "    Nuova politica di scheduling: su "
change_sched_done_msg:      .asciiz "  Politica di scheduling correttamente cambiata!\n\n"
scheduling_msg:             .asciiz "  Scheduling su "
sched_prio_msg:             .asciiz "PRIORITÀ\n"
sched_cycles_msg:           .asciiz "ESECUZIONI RIMANENTI\n"
print_delim:                .asciiz "  +----+-----------+-----------+-------------------+\n"
print_header:               .asciiz "  | ID | PRIORITA' | NOME TASK | ESECUZ. RIMANENTI |\n"
print_empty_queue:          .asciiz "  |                  Coda vuota!                   |\n"
print_row_start:            .asciiz "  /"
print_row_five_spaces:      .asciiz "     "
print_row_eight_spaces:     .asciiz "        "

################# Code segment #####################
.text
.globl main

### insert ###
insert:             # procedura per l'inserimento di un task nelle liste
    move $t0, $a0   # primo parametro: puntatore al task da inserire
    move $t8, $a1   # secondo: puntatore alla lista A
    move $t9, $a2   # terzo: puntatore alla lista B
    
    beq $t8, $zero, insert_first    # se il puntatore d'inizio è nullo (coda vuota), salta all'inserimento del primo task nella coda
    
    lw $t1, 20($t0) # carica la priorità
    lw $t2, 24($t0) # e le esecuzioni rimanenti del task da inserire
    
    move $t3, $t8   # carica il puntatore d'inizio della lista A
    
insert_prio_loop:
    lw $t4, 20($t3)                         # carica la priorità del task attuale
    bgt $t4, $t1, insert_prio_next          # se la il task attuale ha priorità maggiore del task da inserire, passa al prossimo task
    beq $t4, $t1, insert_prio_cycles_loop   # se la priorità è uguale, inizia a scorrere comparando le esecuzioni rimanenti
    j insert_prio_found                     # altrimenti, si è trovato il punto in cui inserire il task
    
insert_prio_next:                       # istruzioni per passare al prossimo task della lista A
    lw $t4, 28($t3)                     # carica il puntatore al prossimo task della lista A
    beq $t4, $zero, insert_prio_last    # se il puntatore è nullo, il task è da inserire come ultimo della lista
    move $t3, $t4                       # altrimenti, passa al prossimo
    j insert_prio_loop                  # ed esegue un altro ciclo del loop
    
insert_prio_cycles_loop:                    # ciclo per la comparazione su esecuzioni rimanenti sulla lista A
    lw $t4, 20($t3)                         # carica la priorità del task attuale
    blt $t4, $t1, insert_prio_found         # se la priorità è minore, la sfilza di task con priorità uguale è terminata e si è trovato dove inserire il task
    lw $t4, 24($t3)                         # altrimenti, carica le esecuzioni rimanenti del task attuale
    blt $t4, $t2, insert_prio_cycles_next   # se le esecuzioni rimanenti del task attuale sono minori (strettamente) del task da inserire, continua a cercare comparando le esec. rimanenti
    j insert_prio_found                     # altrimenti, si è trovato dove inserire il task
    
insert_prio_cycles_next:
    lw $t4, 28($t3)                     # carica il prossimo elemento della lista A
    beq $t4, $zero, insert_prio_last    # se il puntatore è nullo, inserisce il task come ultimo della lista
    move $t3, $t4                       # altrimenti, passa al prossimo
    j insert_prio_cycles_loop           # ed esegue un altro ciclo (comparando su esecuzioni rimanenti)
    
insert_prio_found:                      # quando il task è stato trovato
    sw $t3, 28($t0)                     # salva il task attuale come prossimo del task da inserire
    lw $t4, 0($t3)                      # carica il task precedente al task attuale
    sw $t0, 0($t3)                      # imposta il task da inserire come nuovo precedente del task attuale
    beq $t4, $zero, insert_prio_first   # se il vecchio precedente è nullo, allora il task è da inserire come primo della lista
    sw $t4, 0($t0)                      # altrimenti, imposta il task precedente al task attuale come precedente del task da inserire
    sw $t0, 28($t4)                     # ed imposta il task da inserire come successivo del precedente del task attuale
    j insert_cycles                     # infine salta alle istruzioni per l'inserimento nella lista B
    
insert_prio_first:      # se il task è da inserire come primo della lista
    sw $zero, 0($t0)    # salva un puntatore nullo come precedente del task da inserire
    move $t8, $t0       # ed imposta il puntatore d'inizio della lista A al task da inserire
    j insert_cycles     # quindi passa alla lista B
    
insert_prio_last:       # se il task è da inserire come ultimo della lista
    sw $t0, 28($t3)     # salva il task da inserire come successivo del task attuale
    sw $t3, 0($t0)      # salva il task attuale come precedente del task da inserire
    sw $zero, 28($t0)   # ed salve un puntatore nullo come successivo del task da inserire
    
insert_cycles:      # le istruzioni per l'inserimento nella lista B sono speculari a quelle per la lista A
    move $t3, $t9
    
insert_cycles_loop:
    lw $t4, 24($t3)
    blt $t4, $t2, insert_cycles_next
    beq $t4, $t2, insert_cycles_prio_loop
    j insert_cycles_found
    
insert_cycles_next:
    lw $t4, 32($t3)
    beq $t4, $zero, insert_cycles_last
    move $t3, $t4
    j insert_cycles_loop
    
insert_cycles_prio_loop:
    lw $t4, 24($t3)
    bgt $t4, $t2, insert_cycles_found
    lw $t4, 20($t3)
    bgt $t4, $t1, insert_cycles_prio_next
    j insert_cycles_found
    
insert_cycles_prio_next:
    lw $t4, 32($t3)
    beq $t4, $zero, insert_cycles_last
    move $t3, $t4
    j insert_cycles_prio_loop
    
insert_cycles_found:
    sw $t3, 32($t0)
    lw $t4, 4($t3)
    sw $t0, 4($t3)
    beq $t4, $zero, insert_cycles_first
    sw $t4, 4($t0)
    sw $t0, 32($t4)
    j insert_done
    
insert_cycles_first:
    sw $zero, 4($t0)
    move $t9, $t0
    j insert_done
    
insert_cycles_last:
    sw $t0, 32($t3)
    sw $t3, 4($t0)
    sw $zero, 32($t0)
    j insert_done
    
insert_first:       # se la coda è vuota
    move $t8, $t0   # fa puntare entrambi i puntatori d'inizio (delle due liste)
    move $t9, $t0   # al task da inserire
    
insert_done:        # al termine dell'inserimento
    move $v0, $t8   # imposta i nuovi puntatori d'inizio delle due liste
    move $v1, $t9   # come valori di ritorno
    jr $ra          # quindi, ritorna al chiamante
### insert end ###

### detach ###
detach:             # procedura per rimuovere un task dalle liste
    move $t0, $a0   # primo parametro: puntatore al task da rimuovere
    move $t8, $a1   # secondo: puntatore alla lista A
    move $t9, $a2   # terzo: puntatore alla lista B
    
    lw $t1, 28($t8)                     # carica il successivo del primo task nella lista A
    beq $t1, $zero, detach_only_task    # se è nullo, allora c'è un solo task nella coda (rimuoverlo equivale a svuotare la coda)
                                        # altrimenti
    lw $t1, 0($t0)                      # carica il precedente del task da rimuovere
    lw $t2, 28($t0)                     # ed il successivo
    beq $t1, $zero, detach_first_prio   # se il puntatore al precedente è nullo, allora è da rimuovere il primo task della lista A
    beq $t2, $zero, detach_last_prio    # se è nullo il puntatore al successivo, allora è l'ultimo
    sw $t2, 28($t1)                     # altrimenti, imposta il successivo come successivo del precedente
    sw $t1, 0($t2)                      # ed il precedente come precedente del successivo
    
    j detach_cycles # salta alla rimozione del task dalla lista B
    
detach_first_prio:      # se il task da rimuovere è il primo della lista A
    move $t8, $t2       # fa puntare il puntatore d'inizio di A al task successivo (ovvero il secondo)
    sw $zero, 0($t2)    # ed imposta il precedente del successivo come puntatore nullo
    
    j detach_cycles     # quindi salta alla rimozione dalla lista B
    
detach_last_prio:       # se il task da rimuovere è l'ultimo della lista A
    sw $zero, 28($t1)   # basta impostare il successivo del task precedente come puntatore nullo
    
detach_cycles:                          # la rimozione dalla lista B è del tutto analoga a quella della lista A
    lw $t1, 4($t0)
    lw $t2, 32($t0)
    beq $t1, $zero, detach_first_cycles
    beq $t2, $zero, detach_last_cycles
    sw $t2, 32($t1)
    sw $t1, 4($t2)
    
    j detach_done
    
detach_first_cycles:
    move $t9, $t2
    sw $zero, 4($t2)
    
    j detach_done
    
detach_last_cycles:
    sw $zero, 32($t1)

    j detach_done
    
detach_only_task:   # se il task da rimuovere è l'unico presente nelle due code
    move $t8, $zero # imposta i due puntatori iniziali delle liste A e B
    move $t9, $zero # a puntatori nulli (coda vuota)
    
detach_done:            # una volta terminata l'eliminazione dalle due liste
    sw $zero, 0($t0)    # imposta a puntatore nullo il precedente, nella lista A, del task rimosso
    sw $zero, 4($t0)    # il puntatore al precedente nella lista B
    sw $zero, 28($t0)   # il puntatore al successivo nella lista A
    sw $zero, 32($t0)   # ed il puntatore al successivo nella lista B

    move $v0, $t8       # imposta il puntatore d'inizio A come primo valore di ritorno
    move $v1, $t9       # ed il puntatore d'inizio B come secondo valore di ritorno
    jr $ra              # torna alla procedura chiamante
### detach end ###

### run ###
run:                # procedura per l'esecuzione di un task
    move $t0, $a0   # primo parametro: puntatore al task da eseguire
    move $t8, $a1   # secondo: puntatore alla lista A
    move $t9, $a2   # terzo: puntatore alla lista B
    
    lw $t1, 24($t0)     # carica le esecuzioni rimanenti del task
    addi $t1, $t1, -1   # le decrementa
    sw $t1, 24($t0)     # e salva il nuovo valore nel record del task
    
    addi $sp, $sp, -12  # alloca spazio nello stack per 12 byte (3 word)
    sw $ra, 8($sp)      # salva nello stack l'indirizzo di ritorno
    sw $t0, 4($sp)      # il puntatore al task da eseguire
    sw $t1, 0($sp)      # ed il numero di esecuzioni rimanenti dopo la sua esecuzione
    
    jal detach  # chiama la funzione detach, per rimuovere il task dalle liste
    
    lw $t0, 4($sp)  # recupera dallo stack il puntatore al task da eseguire
    lw $t1, 0($sp)  # e le esecuzioni rimanenti dopo l'esecuzione
    move $t8, $v0   # come valori di ritorno di detach recupera il puntatore d'inizio A
    move $t9, $v1   # ed il puntatore d'inizio B
    
    li $v0, 4           # stampa "Task con ID "
    la $a0, task_msg
    syscall
    
    li $v0, 1       # stampa l'ID del task
    lw $a0, 8($t0)
    syscall
    
    beq $t1, $zero, run_completed   # se le esecuzioni rimanenti sono zero, stampa "task terminato"
                                    # altrimenti
    li $v0, 4               # stampa "task eseguito"      
    la $a0, executed_msg
    syscall
    
    move $a0, $t0   # prepara il primo parametro: puntatore al task eseguito
    move $a1, $t8   # secondo: puntatore d'inizio della lista A
    move $a2, $t9   # terzo: puntatore d'inizio della lista B
    
    jal insert  # chiama la procedura insert, per reinserire il task eseguito al posto giusto
    
    move $t8, $v0   # recupera come valori di ritorno il puntatore d'inizio A
    move $t9, $v1   # ed il puntatore d'inizio B
    
    j run_done  # salta alla fine dell'esecuzione
    
run_completed:              # se il task è terminato (0 esecuzioni rimanenti)
    li $v0, 4               # stampa "task terminato"
    la $a0, completed_msg
    syscall
                            # e non lo reinserisce nelle liste (eliminazione logica definitiva)
run_done:               # al termine dell'esecuzione
    lw $ra, 8($sp)      # recupera l'indirizzo di ritorno dallo stack
    addi $sp, $sp, 12   # dealloca lo stack frame
    
    move $v0, $t8   # imposta come valori di ritorno il puntatore d'inizio A
    move $v1, $t9   # ed il puntatore d'inizio B
    jr $ra          # torna al chiamante
### run end ###

### find_id ###
find_id:            # procedura per recuperare un task con un ID specifico
    move $t0, $a0   # primo argomento: ID del task da recuperare
    move $t8, $a1   # secondo: puntatore d'inizio della lista A
    
    move $t1, $zero # puntatore al task con ID cercato, inizializzato come nullo
    
find_id_loop:
    lw $t2, 8($t8)              # carica l'ID del task attuale
    beq $t2, $t0, find_id_found # se gli ID coincidono, allora il task è stato trovato
    lw $t2, 28($t8)             # altrimenti, carica il puntatore al task successivo
    beq $t2, $zero, find_id_end # se è nullo, allora si è raggiunta la fine senza trovare il task
    move $t8, $t2               # altrimenti passa al successivo
    j find_id_loop              # ed esegue un altro ciclo
    
find_id_found:      # se il task è stato trovato
    move $t1, $t8   # salva il puntatore al task
    
find_id_end:        # alla fine della procedura
    move $v0, $t1   # restituisce il puntatore al task trovato, o null se non è stato trovato
    jr $ra          # torna al chiamante
### find_id end ###

### insert_task ###
insert_task:
    move $t8, $a1
    move $t9, $a2
    
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $t8, 12($sp)
    sw $t9, 8($sp)

    li $v0, 4               # stampa la stringa per l'inserimento di un task
    la $a0, insert_task_msg
    syscall
    
    li $v0, 9   # chiamata sbrk
    li $a0, 36  # 36 byte totali
    syscall     # puntatore al precedente A (4 byte, 0-4)
                # puntatore al precedente B (4 byte, 4-8)
                # ID (4 byte, 8-12)
                # nome (8 byte, 12-20)
                # priorità (4 byte, 20-24)
                # esecuzioni rimanenti (4 byte, 24-28)
                # puntatore al successivo A (4 byte, 28-32)
                # puntatore al successivo B (4 byte, 32-36)
                
    move $t0, $v0   # salva l'indirizzo d'inizio dei 36 byte allocati
    sw $t0, 4($sp)
    
    sw $zero, 0($t0)    # salva i puntatori al precedente
    sw $zero, 4($t0)    # nell'heap
    
insert_task_id:
    li $v0, 4
    la $a0, insert_id_msg
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    beq $t8, $zero, insert_task_id_store
    
    sw $t1, 0($sp)
    
    move $a0, $t1
    move $a1, $t8
    
    jal find_id
    
    move $t2, $v0
    lw $t1, 0($sp)
    lw $t0, 4($sp)
    lw $t8, 12($sp)
    lw $t9, 8($sp)
    
    bne $t2, $zero, insert_task_id_duplicate
    j insert_task_id_store
    
insert_task_id_duplicate:
    li $v0, 4
    la $a0, task_msg
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall
    
    li $v0, 4
    la $a0, id_duplicate_msg
    syscall
    
    j insert_task_id
    
insert_task_id_store:
    sw $t1, 8($t0)
    
insert_task_name:
    li $v0, 4
    la $a0, insert_name_msg
    syscall
    
    li $v0, 8
    la $a0, buffer
    li $a1, 1024
    syscall
    
    li $t1, 0
    
insert_task_name_loop:
    li $t2, 8
    beq $t1, $t2, insert_task_prio
    la $t2, buffer
    add $t2, $t2, $t1
    lb $t3, 0($t2)
    li $t4, 32
    blt $t3, $t4, insert_task_name_spaces
    add $t2, $t0, $t1
    addi $t2, $t2, 12
    sb $t3, 0($t2)
    addi $t1, $t1, 1
    j insert_task_name_loop
    
insert_task_name_spaces:
    li $t2, 8
    beq $t1, $t2, insert_task_prio
    add $t2, $t0, $t1
    addi $t2, $t2, 12
    li $t3, ' '
    sb $t3, 0($t2)
    addi $t1, $t1, 1
    j insert_task_name_spaces
    
insert_task_prio:
    li $v0, 4
    la $a0, insert_prio_msg
    syscall
    
    li $v0, 5
    syscall
    
    li $t1, 0                           # se si è inserita una priorità minore di 0
    blt $v0, $t1, insert_task_prio
    li $t1, 9                           # o se si è inserita una priorità maggiore di 9
    bgt $v0, $t1, insert_task_prio      # chiedi nuovamente la priorità del task
    sw $v0, 20($t0)                     # altrimenti salva nell'heap
    
insert_task_cycles:
    li $v0, 4
    la $a0, insert_cycles_msg
    syscall
    
    li $v0, 5
    syscall
    
    li $t1, 1                           # se si sono inseriti meno di 1 ciclo
    blt $v0, $t1, insert_task_cycles
    li $t1, 99                          # o se si sono inseriti più di 99 cicli
    bgt $v0, $t1, insert_task_cycles    # chiedi nuovamente i cicli del task
    sw $v0, 24($t0)                     # altrimenti salva nell'heap
    
    sw $zero, 28($t0)
    sw $zero, 32($t0)
    
    move $a0, $t0
    move $a1, $t8
    move $a2, $t9
    
    jal insert
    
    move $t8, $v0
    move $t9, $v1

    li $v0, 4
    la $a0, insert_task_done_msg
    syscall
    
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    
    move $v0, $t8
    move $v1, $t9
    
    jr $ra
### insert_task end ###

### run_first ###
run_first:
    move $t7, $a0
    move $t8, $a1
    move $t9, $a2

    li $v0, 4               # stampa la stringa per l'esecuzione del primo task
    la $a0, run_first_msg
    syscall
    
    li $t0, 'a'
    bne $t7, $t0, run_first_cycles
    move $t1, $t8
    
    j run_first_check_empty
    
run_first_cycles:
    move $t1, $t9
    
run_first_check_empty:
    beq $t1, $zero, run_first_empty
    
run_first_loop:
    bne $t7, $t0, run_first_load_next_cycles
    lw $t2, 28($t1)
    
    j run_first_check_next
    
run_first_load_next_cycles:
    lw $t2, 32($t1)
    
run_first_check_next:
    beq $t2, $zero, run_first_found
    move $t1, $t2
    j run_first_loop

run_first_found:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $a0, $t1
    move $a1, $t8
    move $a2, $t9
    
    jal run
    
    move $t8, $v0
    move $t9, $v1
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    j run_first_done
        
run_first_empty:
    li $v0, 4
    la $a0, empty_msg
    syscall
    
    li $v0, 4
    la $a0, run_not_done_msg
    syscall
    
    j run_first_return

run_first_done:
    li $v0, 4
    la $a0, run_done_msg
    syscall
    
run_first_return:
    move $v0, $t8
    move $v1, $t9

    jr $ra
### run_first end ###

### run_id ###
run_id:
    addi $sp, $sp, -16
    sw $ra, 12($sp)

    move $t7, $a0
    move $t8, $a1
    move $t9, $a2
    
    sw $t8, 8($sp)
    sw $t9, 4($sp)

    li $v0, 4               # stampa la stringa per l'esecuzione di un task specifico
    la $a0, run_id_msg
    syscall
    
    beq $t8, $zero, run_id_empty
    
run_id_choose:
    li $v0, 4
    la $a0, choose_id_msg
    syscall
    
    li $v0, 4
    la $a0, choose_id_run_msg
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    sw $t0, 0($sp)
    
    move $a0, $t0
    move $a1, $t8
    
    jal find_id
    
    move $t1, $v0
    lw $t8, 8($sp)
    lw $t9, 4($sp)
    
    beq $t1, $zero, run_id_not_found

    move $a0, $t1
    move $a1, $t8
    move $a2, $t9
    
    jal run
    
    move $t8, $v0
    move $t9, $v1
    
    j run_id_done

run_id_not_found:
    li $v0, 4
    la $a0, task_msg
    syscall
    
    li $v0, 1
    lw $a0, 0($sp)
    syscall
    
    li $v0, 4
    la $a0, id_not_found_msg
    syscall
    
    j run_id_choose
    
run_id_empty:
    li $v0, 4
    la $a0, empty_msg
    syscall
    
    li $v0, 4
    la $a0, run_not_done_msg
    syscall
    
    j run_id_return
    
run_id_done:
    li $v0, 4
    la $a0, run_done_msg
    syscall

run_id_return:
    move $v0, $t8
    move $v1, $t9
    
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    
    jr $ra
### run_id end ###

### delete_id ###
delete_id:
    addi $sp, $sp, -16
    sw $ra, 12($sp)

    move $t7, $a0
    move $t8, $a1
    move $t9, $a2
    
    sw $t8, 8($sp)
    sw $t9, 4($sp)

    li $v0, 4
    la $a0, delete_id_msg
    syscall
    
    beq $t8, $zero, delete_id_empty
    
delete_id_choose:
    li $v0, 4
    la $a0, choose_id_msg
    syscall
    
    li $v0, 4
    la $a0, choose_id_delete_msg
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    sw $t0, 0($sp)
    
    move $a0, $t0
    move $a1, $t8
    
    jal find_id
    
    move $t1, $v0
    lw $t8, 8($sp)
    lw $t9, 4($sp)
    
    beq $t1, $zero, delete_id_not_found

    move $a0, $t1
    move $a1, $t8
    move $a2, $t9
    
    jal detach
    
    move $t8, $v0
    move $t9, $v1
    
    j delete_id_done

delete_id_not_found:
    li $v0, 4
    la $a0, task_msg
    syscall
    
    li $v0, 1
    lw $a0, 0($sp)
    syscall
    
    li $v0, 4
    la $a0, id_not_found_msg
    syscall
    
    j delete_id_choose
    
delete_id_empty:
    li $v0, 4
    la $a0, empty_msg
    syscall
    
    li $v0, 4
    la $a0, delete_id_not_done_msg
    syscall
    
    j delete_id_return
    
delete_id_done:
    li $v0, 4
    la $a0, delete_id_done_msg
    syscall

delete_id_return:
    move $v0, $t8
    move $v1, $t9
    
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    
    jr $ra
### delete_id end ###
    
### change_prio ###
change_prio:
    addi $sp, $sp, -20
    sw $ra, 16($sp)

    move $t7, $a0
    move $t8, $a1
    move $t9, $a2
    
    sw $t8, 12($sp)
    sw $t9, 8($sp)

    li $v0, 4
    la $a0, change_prio_msg
    syscall
    
    beq $t8, $zero, change_prio_empty
    
change_prio_choose:
    li $v0, 4
    la $a0, choose_id_msg
    syscall
    
    li $v0, 4
    la $a0, choose_id_change_prio_msg
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    sw $t0, 4($sp)
    
    move $a0, $t0
    move $a1, $t8
    
    jal find_id
    
    move $t1, $v0
    sw $t1, 0($sp)
    lw $t8, 12($sp)
    lw $t9, 8($sp)
    
    beq $t1, $zero, change_prio_not_found
    
change_prio_insert_new:
    li $v0, 4
    la $a0, new_prio_msg
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $t3, 0                               # se si è inserita una priorità minore di 0
    blt $t2, $t3, change_prio_insert_new
    li $t3, 9                               # o se si è inserita una priorità maggiore di 9
    bgt $t2, $t3, change_prio_insert_new    # chiedi nuovamente la priorità del task
    sw $t2, 20($t1)                         # altrimenti aggiorna nell'heap

    move $a0, $t1
    move $a1, $t8
    move $a2, $t9
    
    jal detach
    
    lw $t1, 0($sp)
    move $t8, $v0
    move $t9, $v1
    
    move $a0, $t1
    move $a1, $t8
    move $a2, $t9
    
    jal insert
    
    move $t8, $v0
    move $t9, $v1
    
    j change_prio_done

change_prio_not_found:
    li $v0, 4
    la $a0, task_msg
    syscall
    
    li $v0, 1
    lw $a0, 4($sp)
    syscall
    
    li $v0, 4
    la $a0, id_not_found_msg
    syscall
    
    j change_prio_choose
    
change_prio_empty:
    li $v0, 4
    la $a0, empty_msg
    syscall
    
    li $v0, 4
    la $a0, change_prio_not_done_msg
    syscall
    
    j change_prio_return
    
change_prio_done:
    li $v0, 4
    la $a0, change_prio_done_msg
    syscall

change_prio_return:
    move $v0, $t8
    move $v1, $t9
    
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    
    jr $ra
### change_prio end ###

### change_sched ###
change_sched:
    move $t7, $a0
    
    li $v0, 4                   # stampa la stringa per il cambio della politica di scheduling
    la $a0, change_sched_msg
    syscall
    
    li $v0, 4
    la $a0, change_sched_old_msg
    syscall
    
    li $t0, 'a'
    bne $t7, $t0, change_sched_to_prio
    
    li $v0, 4
    la $a0, sched_prio_msg
    syscall
    
    li $t7, 'b'
    
    li $v0, 4
    la $a0, change_sched_new_msg
    syscall
    
    li $v0, 4
    la $a0, sched_cycles_msg
    syscall
    
    j change_sched_end
    
change_sched_to_prio:
    li $v0, 4
    la $a0, sched_cycles_msg
    syscall

    li $t7, 'a'
    
    li $v0, 4
    la $a0, change_sched_new_msg
    syscall
    
    li $v0, 4
    la $a0, sched_prio_msg
    syscall
    
change_sched_end:
    li $v0, 4
    la $a0, change_sched_done_msg
    syscall
    
    move $v0, $t7
    
    jr $ra
### change_sched end ###

### Main ###
main:
    li $t7, 'a'     # inizializza la politica di scheduling ad A (scheduling su priorità)
    move $t8, $zero # ed il puntatore alla coda A
    move $t9, $zero # e alla coda B a 0 (nessun elemento in coda)

command_selection:
    li $v0, 4               # stampa la stringa per la selezione del comando
    la $a0, insert_command
    syscall
    
    li $v0, 5       # legge un intero in input
    syscall
    move $t0, $v0   # salva l'intero letto in $t0
    
    li $v0, 4       # stampa una newline
    la $a0, newline
    syscall
    
    move $a0, $t7   # prepara il primo parametro (politica di scheduling)
    move $a1, $t8   # il secondo (puntatore ad A)
    move $a2, $t9   # ed il terzo (puntatore a B)
    
    li $t1, 1                       # se l'intero letto è 1
    beq $t0, $t1, jump_insert_task  # il comando da eseguire è l'inserimento di un nuovo task
    li $t1, 2                       # se è 2
    beq $t0, $t1, jump_run_first    # il comando da eseguire è l'esecuzione del primo task
    li $t1, 3                       # se è 3
    beq $t0, $t1, jump_run_id       # il comando da eseguire è l'esecuzione di un task specifico
    li $t1, 4                       # se è 4
    beq $t0, $t1, jump_delete_id    # il comando da eseguire è l'eminazione di un task specifico
    li $t1, 5                       # se è 5
    beq $t0, $t1, jump_change_prio  # il comando da eseguire è la modifica della priorità di un task specifico
    li $t1, 6                       # se è 6
    beq $t0, $t1, jump_change_sched # il comando da eseguire è il cambio della politica di scheduling
    li $t1, 7                       # se è 7
    beq $t0, $t1, exit              # il comando da eseguire è la terminazione del programma
                    #altrimenti
    li $v0, 4       # stampa il menu
    la $a0, menu
    syscall
    
    j command_selection # e torna alla selezione del comando
    
jump_insert_task:       # prepara il necessario per il salto al comando d'inserimento
    addi $sp, $sp, -4   # alloca 4 byte nello stack frame
    sb $t7, 0($sp)      # salva la politica di scheduling nello stack
    
    jal insert_task # salta alla procedura per l'inserimento di un task
                    # recupera i risultati della procedura
    move $t8, $v0   # ovvero il puntatore ad A
    move $t9, $v1   # ed il puntatore a B
    
    lb $t7, 0($sp)      # recupera la politica di scheduling dallo stack
    addi $sp, $sp, 4    # dealloca i 4 byte dallo stack
    
    j print_queue   # salta alle istruzioni per la stampa della coda
    
jump_run_first:         # jump_run_first, jump_run_id, jump_delete_id e jump_change_prio analoghi a jump_insert_task
    addi $sp, $sp, -4
    sb $t7, 0($sp)
    
    jal run_first
    
    move $t8, $v0
    move $t9, $v1
    
    lb $t7, 0($sp)
    addi $sp, $sp, 4
    
    j print_queue
    
jump_run_id:
    addi $sp, $sp, -4
    sb $t7, 0($sp)
    
    jal run_id
    
    move $t8, $v0
    move $t9, $v1
    
    lb $t7, 0($sp)
    addi $sp, $sp, 4
    
    j print_queue
    
jump_delete_id:
    addi $sp, $sp, -4
    sb $t7, 0($sp)
    
    jal delete_id
    
    move $t8, $v0
    move $t9, $v1
    
    lb $t7, 0($sp)
    addi $sp, $sp, 4
    
    j print_queue
    
jump_change_prio:
    addi $sp, $sp, -4
    sb $t7, 0($sp)
    
    jal change_prio
    
    move $t8, $v0
    move $t9, $v1
    
    lb $t7, 0($sp)
    addi $sp, $sp, 4
    
    j print_queue
    
jump_change_sched:      # analogo agli altri jump
    addi $sp, $sp, -8   # con la differenza che nello stack si salvano i due puntatori
    sw $t8, 4($sp)      # e la procedura ritorna la nuova politica di scheduling
    sw $t9, 0($sp)
    
    jal change_sched
    
    move $t7, $v0
    
    lw $t8, 4($sp)
    lw $t9, 0($sp)
    addi $sp, $sp, 8
    
    j print_queue
    
print_queue:                # istruzioni per la stampa della coda
    li $v0, 4               # stampa "Scheduling su"
    la $a0, scheduling_msg  # il nome effettivo viene poi stampato a seconda dello scheduling attuale
    syscall

    li $t0, 'a'                             # carica il carattere 'a', per poterlo comparare con la politica attuale
    bne $t7, $t0, print_queue_cycles_begin  # se la politica non è A, esegui l'inizializzazione per la politica B
                                            # altrimenti
    move $t1, $t8   # inizializza il puntatore $t1 col puntatore di A
    
    li $v0, 4               # stampa "PRIORITÀ"
    la $a0, sched_prio_msg
    syscall
    
    j print_queue_header    # salta alla stampa dell'header della tabella
    
print_queue_cycles_begin:   # se la politica è B
    move $t1, $t9           # inizializza il puntatore $t1 col puntatore di B

    li $v0, 4                   # stampa "ESECUZIONI RIMANENTI"
    la $a0, sched_cycles_msg
    syscall
    
print_queue_header:
    
    li $v0, 4           # stampa un delimitatore
    la $a0, print_delim
    syscall
    
    li $v0, 4               # stampa l'header
    la $a0, print_header
    syscall
    
    li $v0, 4           # stampa un delimitatore
    la $a0, print_delim
    syscall
    
    beq $t1, $zero, print_queue_empty   # se il puntatore d'inizio è zero, salta alla stampa della coda vuota
    
print_queue_loop:
    li $v0, 4               # stampa l'inizio di una riga
    la $a0, print_row_start
    syscall
    
    lw $t2, 8($t1)                  # carica l'ID del task attuale
    li $t3, 9                       # se è composto da due cifre
    bgt $t2, $t3, print_queue_id    # stampa subito l'ID
                                    # altrimenti
    li $v0, 11  # stampa prima uno spazio extra
    li $a0, ' '
    syscall
    
print_queue_id:
    li $v0, 11  # stampa uno spazio
    li $a0, ' '
    syscall

    li $v0, 1       # stampa l'ID
    move $a0, $t2
    syscall
    
    li $v0, 11  # stampa uno spazio
    li $a0, ' '
    syscall
    
    li $v0, 11  # ed un separatore
    li $a0, '/'
    syscall
    
    li $v0, 4                       # stampa cinque spazi
    la $a0, print_row_five_spaces
    syscall
    
    li $v0, 1       # stampa la priorità
    lw $a0, 20($t1)
    syscall
    
    li $v0, 4                       # stampa altri cinque spazi
    la $a0, print_row_five_spaces
    syscall
    
    li $v0, 11  # stampa un separatore
    li $a0, '/'
    syscall
    
    li $v0, 11  # ed uno spazio
    li $a0, ' '
    syscall
    
    li $t2, 12  # carica 12 (offset d'inizio del nome)
    li $t3, 19  # e 19 (offset di fine)
    
print_queue_name_loop:
    add $t4, $t2, $t1   # puntatore al carattere attuale (indirizzo base $t1 + offset attuale $t2)
    
    li $v0, 11      # stampa il carattere
    lb $a0, 0($t4)
    syscall
    
    addi $t2, $t2, 1                    # incrementa l'offset
    ble $t2, $t3, print_queue_name_loop # se l'offset è minore o uguale dell'offset massimo, esegue un altro ciclo
    
    li $v0, 11  # stampa due spazi
    li $a0, ' '
    syscall
    syscall
    
    li $v0, 11  # ed un separatore
    li $a0, '/'
    syscall
    
    li $v0, 4                       # stampa otto spazi
    la $a0, print_row_eight_spaces
    syscall
    
    lw $t2, 24($t1)                     # carica il numero di cicli rimanenti
    li $t3, 9                           # se è composto da due cifre
    bgt $t2, $t3, print_queue_cycles    # stampa subito il numero di cicli
                                        # altrimenti
    li $v0, 11  # stampa prima uno spazio extra
    li $a0, ' '
    syscall
    
print_queue_cycles:
    li $v0, 1       # stampa il numero di esecuzioni rimanenti
    move $a0, $t2
    syscall
    
    li $v0, 4                       # stampa otto spazi
    la $a0, print_row_eight_spaces
    syscall
    
    li $v0, 11  # stampa uno spazio extra
    li $a0, ' '
    syscall
    
    li $v0, 11  # stampa un separatore
    li $a0, '/'
    syscall
    
    li $v0, 4       # va a capo
    la $a0, newline
    syscall
    
    li $v0, 4           # stampa un delimitatore
    la $a0, print_delim
    syscall
    
    bne $t7, $t0, print_queue_load_next_cycles  # controlla la politica di scheduling attuale
    lw $t1, 28($t1)                             # se è A, carica il prossimo elemento della lista A
    j print_queue_check_next                    # e salta al controllo del prossimo elemento
                                # altrimenti
print_queue_load_next_cycles:
    lw $t1, 32($t1)             # carica il prossimo elemento della lista B
    
print_queue_check_next:
    bne $t1, $zero, print_queue_loop    # se il prossimo elemento non è nullo, esegui un altro ciclo
    j print_end                         # altrimenti, salta alla fine della stampa
    
print_queue_empty:              # in caso di coda vuota
    li $v0, 4                   # stampa una riga dedicata
    la $a0, print_empty_queue
    syscall
    
    li $v0, 4                   # e stampa un delimitatore
    la $a0, print_delim
    syscall
    
print_end:          # alla fine della coda
    li $v0, 4       # stampa una newline
    la $a0, newline
    syscall
    
    j command_selection # e torna alla selezione del comando
    
exit:
    li $v0, 4       # stampa il messaggio di terminazione
    la $a0, exiting
    syscall
    
    li $v0, 10  # uscita dal programma
    syscall
### Main end ###