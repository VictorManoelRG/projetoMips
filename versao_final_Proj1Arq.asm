#NOME: VICTOR MANOEL RODRIGUES GUILHERME RA:20105219


.data
#------------------------------------------------------------------------ vetores que serao usados no programa

times: .space 120  					#vetor que guarda os nomes dos timee
times_ver: .space 181  					#vetor que ira guardar as partidas q ja ocorreram,e na posição 0, guarda o numero de jogos
aux_times: .word 0,1,2,3,4,5,6,7,8,9 		        #vetor q ajudara a imprimir os times de forma ordenada
timesVencedorRod1: .word 0,0,0,0,0,0,0,0,0,0            #vitorias de cada time
timesPerdedorRod1: .word 0,0,0,0,0,0,0,0,0,0            #derrotas de cada time
timesJogosRod1: .word 0,0,0,0,0,0,0,0,0,0               #jogos jogados por cada time

.eqv senha 2021  #senha para acessar o menu

#----------------------------------------------------------------------mensagens do menu inicial

msg1: .asciiz "Seja bem vindo ao menu dos jogos do CBLoL!"
msg2: .asciiz "\nDigite a senha para tomar controle do programa: "
msgRegtimes: .asciiz "\n\tDigite o nome de todos os times que jogarao: \n"
msgSenhaErrada: .asciiz "\n\tA senha esta errada! Digite novamente: "
msg3: .asciiz "\n\nA senha estava correta!\n"
msg4: .asciiz "\n\tEscolha a opcao desejada: "
msgAviso: .asciiz "\nDigite um numero valido! "
#------------------------------------------------------------------------ mensagens para cadastrar os times
msgRegTimes: .asciiz "\n\n-Digite 1 para cadastrar os times "
msgTimes: .asciiz "\nDigite o nomoe do time "
msgTimes1: .asciiz ": "

#------------------------------------------------------------------------ mensagens para cadastrar os placares
msgRegPlacar: .asciiz "\n-Digite 1 para computar os placares"
msgRegEsc: .asciiz "\n\tDigite os times que irao jogar: "
msgVencedor: .asciiz "\n\tDigite o vencedor da rodada: "
msgTime1: .asciiz "\n1- "
msgTime2: .asciiz "\n2- "
msgTime3: .asciiz "\n\tDigite 1 se o time 1 venceu, senao digite 2: "
msgTimesJogaram: .asciiz "\n\tOs times selecionados ja jogaram! Escolha novamente: \n"
#------------------------------------------------------------------------ mensagens para imprimir tabela/alterar dados
msgDados: .asciiz "\n-Digite 2 para alterar um dado ja registrado"
msgDados1: .asciiz "\n\tDigite 1 para alterar o nome dos times"
msgDados2: .asciiz "\nDigite o numero do time que deseja alterar o nome: "
msgAjuste: .asciiz "\n\tDigite o novo nome do time: "
msgDadosOrg: .asciiz "- "
msgSort: .asciiz "\n-Digite 3 para calcular o resultado final "
msgAcabar: .asciiz "\n-Digite 0 para sair do programa"
msgOrg1: .asciiz "\nTimes   -   Jogos - Vitorias - Derrotas\n"
msgOrg2: .asciiz "\n=======================================\n"
msgOrg3: .asciiz "\t"
msgOrg4: .asciiz "\t     "


msgAlt1: .asciiz "\nEscolha o times que deseja alterar a partida: "
msgAlt2: .asciiz "\nEscolha qual time que ja foi jogado contra: "
msgAlt3: .asciiz "\nInsira qual dos times ganhou (1 ou 2): "
msgAlt4: .asciiz "\n\tDigite 2 para excluir um jogo entre dois times"
msgAlt5: .asciiz "\n\tO time nao jogou contra niguem ainda! "
#------------------------------------------------------------------------ mensagens para final 
msgFinal: .asciiz "\n\t As classificacoes finais sao as seguintes:\n"
msgFinal2: .asciiz "\n\tOs times que estao nos dois primeiros lugares, respectivamente, sao: \n"
msgFinal3: .asciiz "\n\tOs times que estao nas quartas de final sao: \n"
msgFinal4: .asciiz "\n\tOs times que estao desclassificados das etapas finais sao: \n"
msgFinal5: .asciiz "\n\tos times que foram rebaixados para o circuito desafiante sao: \n"
msgFinal6: .asciiz "\n\n--Obrigador por confiar em nosso sistema!!!--"



#===========================================================================================================================

.text
.globl main

main:

    jal menu  #imprime as boas vindas ao prgrama

    move $a0,$zero

    li $v0,4
    la $a0,msg3         #mensagem de senha correta
    syscall
    
    li $v0,4
    la $a0,msgRegtimes       #mensagem de registrar os times
    syscall
    
    jal cadastroTimes      #cadastra todos os times que jogarao o campeonato

    jal menu2              #oula para o menu principal
    
    finaliza:

    li $v0,10    #encerra o programa
    syscall

menu: 
    li $v0,4
    la $a0,msg1
    syscall
    
    move $a0,$zero    #imprime as mensagens de boas vindas ao programa

    li $v0,4
    la $a0,msg2
    syscall

repet:

        li $v0,5
        syscall      #se a senha estiver errada, fica em looping
        move $s0,$v0
        bne $s0,senha,senha_errada

        jr $ra

senha_errada:

	li $v0,4
	la $a0,msgSenhaErrada     #se a senha para o acessa estiver errada, imprime um aviso
	syscall
	j repet   #pula para uma nova tentativa
menu2:
	li $t7,0	

	lb $t7,times_ver($zero)  #carrega o numero de jogos que ja aconteceram, e se for 45, quer dizer q o programa acabou
	beq $t7,45,loop      #pula para o bubble sort da tabela, e finaliza o programa

    jal imprimirTabela   #imprime a tabela toda a vez que o programa vai ao menu principal
    move $a0,$zero
    
    li $v0,4
    la $a0,msgRegPlacar      #mensagem para registrar placar
    syscall                  
    
    li $v0,4
    la $a0,msgDados      #mensagem para registrar os dados
    syscall
   
    
    li $v0,4
    la $a0,msgSort       #msg para terminar o programa, e imprimir a tabela ordenada
    syscall
    
    li $v0,4
    la $a0,msgAcabar        #volta ao main e encerra o programa
    syscall
    
    li $v0,4
    la $a0,msg4      #imprime uma mensagem sobre qual seria a escolha do usuario
    syscall
    
   

    li $v0,5
    syscall      #le o numero da opcao que o usuario deseja

    move $s0,$v0

    blt $s0,0,aviso
    bgt $s0,3,aviso    # se a opcao escolhida nao for condizente com as opcoes do menu, imprime um aviso e 
    			#permite que o usuario escolha novamente
    
escolhaloop:
    
    beq $s0,1,cadastrarPlacar       #se for 1, vai para o cadastrar placar
    beq $s0,2,alterarDados         #se for 2, alterara o dado dos times
    move $s5,$zero           #necessario zerar o $s5 para que o programa seja finalizado
    beq $s0,3,loop        #encerra o programa e imprime a tabela
    beq $s0,0,finaliza      #encerra o programa
    
    jr $ra

cadastroTimes:
    li $v0,4
    la $a0,msgTimes    #primeiro passo para come�ar o programa, que � armazenar o nome dos times
    syscall
    
    li $v0,1
    move $a0,$s1
    syscall         #imprime o numero, apenas para numerar qual time sera registrado
    
    li $v0,4
    la $a0,msgTimes1      #organiza a mensagem
    syscall
    
    li $v0,8
    la $a0,times($t1)       #armazena o time num vetor no offset $t1, que ira de 12 em 12
    li $a1,12         #tamanho sa string que sera lida
    syscall
    
    addi $t1,$t1,12     #pula para o armazenamento do proximo time
    
    addi $s1,$s1,1           #adiociona um no contador, que ira no maximo 10
    
    bne $s1,10,cadastroTimes          #pula para o cadastroTimes enquanto $s1 nao for 10
    
    
    jr $ra       #retorna para a funcao principal
    
cadastrarPlacar:

    li $t0,0
    li $t1,1          #$t1 sera o offseta da posicao da frente
    li $t2,0       #$t2 servira como o contador da funcao
    move $s0,$zero
    move $s1,$zero     #zera os registradores
    cadastrarPlacar1:
    
    li $v0,4
    la $a0,msgRegEsc   #mensagem auxiliar para saber quais times jogarao
    syscall
    
    
volta_aqui1:

    li $v0,4
    la $a0,msgTime1     #imprime o numero 1 com um traco(-)
    syscall
    
    li $v0,5  #le o numero que sera dado para o time 1
    syscall
    
    move $s0,$v0
    
    bgt $s0,10,aviso3       #se $s0 for um numero que nao esta no intervalo, pula para o aviso, e retornara para ler o numero dnv
    blt $s0,1,aviso3
    
    li $v0,4
    la $a0,msgTime2     #imprime um 2 e um traco(-)
    syscall
    
    li $v0,5    #le o numero novamente
    syscall
    
    move $s1,$v0
    beq $s0,$s1,aviso3       #verifica se o numero esta num intervalo aceitavel
    bgt $s1,10,aviso3
    blt $s1,1,aviso3
    
    addi $s0,$s0,-1    #decrementa cada numero, pois o sistema trabalhara com o numero a menos que foi lido
    addi $s1,$s1,-1
    li $t2,1     #carrega 1 ao $t2
   cont_ver:
	lb $s4,times_ver($zero)   #carrega em $s4 o numero de jogos que ja aconteceram
	mul $t8,$s4,4   #multiplica o numero de jogoso por 4, poir sera nJogos*4(posicoes que armazenam a verificacao)
	addi $t8,$t8,0#0
    lb $t4,times_ver($t2)     #carrega em $t4 a posicao para que seja comparado
    beq $s0,$t4,segunda_ver    # se o numero do time digitado for igual, pula para a segunda verificacao
 
   
    addi $t2,$t2,2  #adiociona 2 para nao comparar os times errados
    blt $t2,$t8,cont_ver    #faz isso enquanto o contador for menor que a menor posicao ja gravada de jogos
    
    
    time_n_jogou:

    li $v0,4
    la $a0,msgTime3  #imprime a mensagem para ver qual time ganhou
    syscall
marc:
    li $v0,5   #le o numero
    syscall
    
    move $s2,$v0
    bgt $s2,0,cont_ver1   #verifica se o numero esta do intervalo desejado
    blt $s2,3,cont_ver1
    
    li $v0,4
    la $a0, msgAviso  # senao imprime uma mensagem de aviso
    syscall
    j marc    #volta para ler o vencedor
    
cont_ver1:
    
    lb $s7,times_ver($zero)    #carrega quantos jogos ocorreram e incrementa 1 no numero de jogos
    addi $s7,$s7,1
    sb $s7,times_ver($zero)    #guarda novamente na primeira posicao

    move $t0,$t8    #move o $t8 para o $t0
    addi $t0,$t0,1  #adiciona um para ir para a proxima posicao #1
    move $t1,$t8   #move para o t1 e adiciona 2 para ficar numa posicao acima
    addi $t1,$t1,2 #2
    sb $s0,times_ver($t0)   #salva o time que foi escolhido no vetor de verificacao de jogos que ja aconteceram
    sb $s1,times_ver($t1)   #faz o mesmo na posicao acima
    addi $t0,$t0,2         #adiciona 2 posicioes em cada contador, e salva o inverso
    addi $t1,$t1,2
    sb $s0,times_ver($t1)
    sb $s1,times_ver($t0)
    addi $t0,$t0,2
    addi $t1,$t1,2    #adiociona duas posicioes novamente
    li $t6,0       #carrega 0 no t6

    beq $s2,1,registraPlacarVence1    #se o time 1 ganhou, incrementa vitorias no time escolhido, senao o outro time
    beq $s2,2,registraPlacarVence2
    
    
    segunda_ver:
        addi $t2,$t2,1    #adiciona uma posicao no vetor de times que ja jogaram
        lb $t7,times_ver($t2)    
	beq $s1,$t7,aviso4     #se o contador for menor que o tamanho do vetor, volta a verificar
	blt $t1,$t8,cont_ver
	
  	 j time_n_jogou   #senao o time ainda nao jogou
    

registraPlacarVence1:

	mul $t4,$s0,4     #multiplica para carregar uma posicao .word
	lw $s0,timesVencedorRod1($t4)
	addi $s0,$s0,1      #adiciona 1 nas vitorias do time escolhido
	sw $s0,timesVencedorRod1($t4)
	
	lw $s2,timesJogosRod1($t4)
	addi $s2,$s2,1     #adiciona 1 no numero de jogos
	sw $s2,timesJogosRod1($t4)
	
	mul $t5,$s1,4
	lw $s1,timesPerdedorRod1($t5)
	addi $s1,$s1,1        #adiciona 1 de perdedor no outro time
	sw $s1,timesPerdedorRod1($t5)
	
	lw $s2,timesJogosRod1($t5)
	addi $s2,$s2,1       #adiciona 1 de jogos realizados
	sw $s2,timesJogosRod1($t5)

	
	j menu2   #volta para o menu
	
registraPlacarVence2:

	mul $t4,$s0,4
	lw $s0,timesPerdedorRod1($t4)
	addi $s0,$s0,1        #incrementa 1 no time 1, derrotas no caso
	sw $s0,timesPerdedorRod1($t4)
	
	lw $s2,timesJogosRod1($t4)
	addi $s2,$s2,1         #adiciona 1 ao jogos realizados
	sw $s2,timesJogosRod1($t4)
	
	mul $t5,$s1,4
	lw $s1,timesVencedorRod1($t5)
	addi $s1,$s1,1      #incrementa a vitoria para o outro time
	sw $s1,timesVencedorRod1($t5)
	
	lw $s2,timesJogosRod1($t5)
	addi $s2,$s2,1                  #incrementa 1 nos jogos realizados
	sw $s2,timesJogosRod1($t5)
	
	j menu2    #volta ao menu
       
alterarDados:      #funcao que ira alterar os dados dos times

   
    li $v0,4
    la $a0,msgDados1
    syscall              #printa a mensagem de alteracao de dados na tela

	li $v0,4
	la $a0,msgAlt4
	syscall
    
    li $v0,4
    la $a0,msg4      #printa a opcao que o usuario deseja alterar
    syscall
    
    
   voltaDados:
    li $v0,5      #le a opcao que o usuario deseja alterar
    syscall
    
    move $s0,$v0
    
    bgt $s0,6,aviso2
    blt $s0,0,aviso2       #se nao estiver no intervalo valido, pula para o aviso e volta a ler a opcao
    
    li $t0,0
    beq $s0,1,alterarDadosNomes       #se o usuario digitar 1, pulara para a alteracao de nome dos times
	beq $s0,2,alterarDadosTimes		#exclui um jogo que ja aconteceu
    
alterarDadosNomes:    #funcao que altera os dados do nomes

    li $v0,1
    move $a0,$t0     #imprime numeros de 1 a 9 para o usuario escolher o nome que deseja alterar
    syscall
    
    li $v0,4
    la $a0,msgDadosOrg #mensagem com um traco e esoaco (- )
    syscall
    
    mul $t1,$t0,12     #multiplica o numero do array por 12 para imprimir o nome dos times
    
    li $v0,4
    la $a0,times($t1)
    li $a1,12           #imprime o nome dos times
    syscall
    
    addi $t0,$t0,1
    
    bne $t0,10,alterarDadosNomes      #enquanto nao for 10, pula para printar os nomes
    
    li $v0,4
    la $a0,msgDados2   #pergunta qual o numero do time cujo nome sera alterado
    syscall
    
    li $v0,5       #le o numero do time
    syscall
    
    move $s0,$v0
    
    li $v0,4
    la $a0,msgAjuste    #imprime uma mensagem perguntando qual sera o novo nome do time
    syscall
    
    mul $t1,$s0,12     #multiplica o nome escolhido por 12
    
    li $v0,8
    la $a0,times($t1)       # le o novo nome do time e guarda no vetor
    li $a1,12
    syscall
    
    j menu2   #volta para o menu

alterarDadosTimes: 

	li $t0,0

	imprimeTimes:

	li $v0,1
	move $a0,$t0 	#imprime o numero do time, e o nome do mesmo
	syscall

	li $v0,4
	la $a0,msgDadosOrg     #imprime um traco e espaco (- )
	syscall

	mul $t1,$t0,12		#multiplica o contador por 12, para imprimir a string dos nomes

	li $v0,4
	la $a0,times($t1) 	#imprime o time
	li $a1,12
	syscall

	addi $t0,$t0,1
	bne $t0,10,imprimeTimes		#enquanto nao imprimir os 10, fica em looping

	conf_times:
	li $v0,4
	la $a0,msgAlt1 	#imprime a mensagem de qual time o jogo sera excluido
	syscall

	li $v0,5 	#le o numero do time
	syscall

	move $s0,$v0 	#joga em s0

	blt $s0,0,conf_times 	#se nao for em um intervalo desejado, pergunta o numero do time novamnete
	bgt $s0,9,conf_times

	li $t0,1	#carrega 1 em t0
	li $s3,0

	imprimeTimesJogou_contra:

	lb $t1,times_ver($zero)
	mul $t4,$t1,4
	addi $t8,$t4,-1 	#carrega o numero de jogos que ja aocnteceram, e faz o looping rodar enquanto for menor
	repet_jogos:
	lb $t1,times_ver($t0) 	#carrega o primeiro time em t1
	beq $s0,$t1,time_jogou 	#se for igual ao time ja digitado, ira comparar com o segundo
	addi $t0,$t0,1   #senao adiciona 1 ao contador do looping
	blt $t0,$t4,repet_jogos
	beq $s3,0,timenjogou2   #se s3 for 0, o time ainda n jogou, e imprime uma mensagem(incrementa em cada verificacao)
	

	ler_seg_times:

	li $v0,4
	la $a0,msgAlt2 	#digita o numero do segundo time 
	syscall

	li $v0,5		#le o numero
	syscall

	move $s1,$v0 	#move em s1

	
	ler_quem_ganhou:

	li $v0,4
	la $a0,msgAlt3 	#pergunta qual dos times ganhou a partida(o usuario deve saber)
	syscall

	li $v0,5
	syscall #le e guarda em s5

	move $s5,$v0

	bgt $s5,2,aviso6 	#garante que s5 nao eh um numero invalido
	blt $s5,0,aviso6

	beq $s5,1,time1_ganhou   #se s5 for 1, o time 1 ganhou, senao o time 2 ganhou
	beq $s5,2,time2_ganhou

	time1_ganhou:

	mul $s4,$s0,4 #se o time 1 ganhpu, decrementara os jogos e vitorias do mesmo

	lw $t6,timesJogosRod1($s4)
	addi $t6,$t6,-1
	sw $t6,timesJogosRod1($s4) 	#decrementa os jogos jogados

	lw $t6,timesVencedorRod1($s4)
	addi $t6,$t6,-1
	sw $t6,timesVencedorRod1($s4) #decrementa as vitorias do time

	mul $s5,$s1,4 	#multiplica por 4 

	lw $t6,timesJogosRod1($s5)
	addi $t6,$t6,-1
	sw $t6,timesJogosRod1($s5) 	#decrementa os jogos do outro time 

	lw $t6,timesPerdedorRod1($s5)
	addi $t6,$t6,-1
	sw $t6,timesPerdedorRod1($s5)   #e decrementa em um que ele perdeu
	
	lb $t6,times_ver($zero) 	  #decrementa em 1 os jogos que ja ocorreram
	move $s7,$t6
	addi $t6,$t6,-1
	sb $t6,times_ver($zero)
	
	mul $s7,$s7,4  #move a quantidade de jogos 
	li $t5,1   #contador do vetor
	li $t8,12   #vetor que ira substituir por 12 o vetor de jogos que ja jogaram
	tirar_jogo1:
	lb $t6,times_ver($t5)   #carrega em t6 o time que jogou
	beq $s0,$t6,tirar_jogo1_2   #se for igual a s0, faz a segunda verificacao
	addi $t5,$t5,1   	#senao adiciona 1 e continua o looping
	blt $t5,$s7,tirar_jogo1 	#adiciona em 1 e faz isso enquanto o offset for menor que o maior jogo
	
	j menu2    #se terminar, volta para o menu
	
	
	tirar_jogo1_2:   	#se o numero for encontrado, adiciona uma posicao e compara novamente
	
	addi $t5,$t5,1		#adiciona 1
	lb $t6,times_ver($t5) 	#carrega o proximo time em t6
	beq $s0,$t6,tirar_jogo1  	#se o proximo vetor for o mesmo, quer dizer que eh outro jogo
	bne $s1,$t6,tirar_jogo1 	#se o vetor atual n for igual ao time 2, volta ao looping
	
	addi $t5,$t5,1   #senao carrega o proximo time em t6 e faz a segunda verificacao
	lb $t6,times_ver($t5)
	beq $s1,$t6,segunda_veri
	
	volta_aqui_1:
	
	addi $t5,$t5,-3
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)	#se o proximo time for de outro jogo, volta 4 posicoes e sobrescreve tudo com 12,
	addi $t5,$t5,1			#apagando que os times ja jogaram, podendo ser registrado novamente
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)
	
	j menu2   #apos isso, volta ao menu
	
	segunda_veri:
	
		addi $t5,$t5,1
		lb $t6,times_ver($t5)
		beq $s0,$t6,cont_segunda_ver     #se o proximo valor do vetor for outro jogo, voltara a funcao, 
		j volta_aqui_1				#e apagara o ultimos 4 jogos
		
		
	cont_segunda_ver:
	
	addi $t5,$t5,-3
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)   #apaga os ultimos times que jogaram se a posicao do proximo n for o time desejado
	addi $t5,$t5,1
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)
	
	
	j tirar_jogo1     #continua fazendo a verificao dos jogos
	
	time2_ganhou:

	mul $s4,$s0,4

	lw $t6,timesJogosRod1($s4)
	addi $t6,$t6,-1
	sw $t6,timesJogosRod1($s4)    #se o time 2 ganhou, eh necessario decrementar as partidas jogadasem ambos

	lw $t6,timesPerdedorRod1($s4)
	addi $t6,$t6,-1
	sw $t6,timesPerdedorRod1($s4)    #e como o time 2 ganhou, quer dizer que o 1 perdeu, e decrementa as derrotas em 1

	mul $s5,$s1,4

	lw $t6,timesJogosRod1($s5)     #decrementa em 1 os jogos jogados
	addi $t6,$t6,-1
	sw $t6,timesJogosRod1($s5)

	lw $t6,timesVencedorRod1($s5)		#e tira um valor que o time venceu
	addi $t6,$t6,-1
	sw $t6,timesVencedorRod1($s5)
	
	lb $t6,times_ver($zero)   #carrega em $t6 quantas partidas ja aconteceram
	move $s7,$t6   #move para s7, decrementa as partidas que ja aconteceram em 1, e volta a guardar
	addi $t6,$t6,-1
	sb $t6,times_ver($zero)

	mul $s7,$s7,4    #numero de vezes que o looping sera realizado
	li $t5,1   #carrega t5 na primeira posicao do jogo
	li $t8,12
	tirar_jogo2:    #rotulo que removera os jogos no vetor dos jogos que ja aocnteceram
	lb $t6,times_ver($t5)
	beq $s1,$t6,tirar_jogo2_2  #se s1 for igual ao t6, ira para a segunda verificacao
	addi $t5,$t5,1    #se nao for igual, incrementa 1 e volta a verificar
	blt $t5,$s7,tirar_jogo2    #looping
	
	j menu2   #volta para o menu
	
	tirar_jogo2_2:
	
	addi $t5,$t5,1
	lb $t6,times_ver($t5)
	beq $s1,$t6,tirar_jogo2     #adicionara 1 e vera se a proxima casa sera igual ao time 0, se for igual a ele mesmo,
	bne $s0,$t6,tirar_jogo2		#volta para a verificacao do looping,
								# e e se o proximo for igual a s0, tambem n podera ser valido
	addi $t5,$t5,1
	lb $t6,times_ver($t5)
	beq $s0,$t6,segunda_veri1    #se s0 for igaul a t6, faz a segunda verificacao
	
	volta_aqui_2:
	
	addi $t5,$t5,-3
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)    #volta 3 posicoes, e substitui todos os jogos por 12, e deixa de ser um jogo que ja aconteceu
	addi $t5,$t5,1
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)
	
	j menu2    #volta para o menu
	
	segunda_veri1:
	
		addi $t5,$t5,1
		lb $t6,times_ver($t5)
		beq $s1,$t6,cont_segunda_ver1      #faz a segunda verificacao, e se for igual ao time 2, se refere a outro jogo
		j volta_aqui_2
		
	cont_segunda_ver1:
	
	addi $t5,$t5,-3
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)
	addi $t5,$t5,1
	sb $t8,times_ver($t5)   #se for a segunda verificacao, volta 3 casas, e substitui os ultimos 4 numeros por 12,
	addi $t5,$t5,1			# e apaga os times que ja jogaram
	sb $t8,times_ver($t5)
	
	
	j tirar_jogo2   #volta para a verificacao do time 2


	aviso6:
	
	li $v0,4
	la $a0,msgAviso    #se for um numero invalido, imprime a mensagem e volta a funcao para ver o vencedor
	syscall
	j ler_quem_ganhou


	aviso5:

	li $v0,4
	la $a0,msgAviso   #se o numero do segundo time estiver em um intervalo invalido, imprime um aviso e le novamente
	syscall

	j ler_seg_times

	time_jogou:

		addi $t0,$t0,1
		lb $t2,times_ver($t0)
		beq $s0,$t2,repet_jogos   #se o time jogou, imprime para que o usuario escolha a partida que sera deletada
		bgt $t0,$t4,timenjogou2

		mul $t5,$t2,12    #multiplica o numero do time pelo vetor dos nomes, e imprime o nome do time

		li $v0,1
		move $a0,$t2    #imprime o numero do time
		syscall

		li $v0,4
		la $a0,msgDadosOrg   #imprime um traco e espaco (- )
		syscall

		li $v0,4
		la $a0,times($t5)   #imprime o nome do time
		li $a1,12
		syscall

		addi $s3,$s3,1   #adiciona a quanntidade de vezes que o time 1 jogou, para q um ontervalo valido seja lido
		

		j repet_jogos    #e volta para o looping

		timenjogou2:
		li $v0,4
		la $a0,msgAlt5   #se o time n jogou, imprime a mensagem que o time n jogou contra ninguem ainda e imprime um delay
		syscall

    		li $a2, 1000000 #move um numero de alto valor para que seja looping do delay

		mydelay:   
    		addi $a2, $a2, -1   #faz o delay, e volta para o menu
   	 	bgez $a2, mydelay

		j menu2

          
imprimirTabela:

	li $t0,0
	li $t1,0
	li $s0,0 	#registradores que serao usados para imprimir a tabela
	li $s1,1
	
	li $v0,4           #imprime a primeira mensagem da tabela
	la $a0,msgOrg1
	syscall
	
	imprimirTabela1:
	
		lw $s0,aux_times($t0)          #carrega um vetor de numero referente aos nomes, para que se imprima ordenado
		
		li $v0,1
		move $a0,$s1
		syscall                #imprime o numero do time
		
		li $v0,4
		la $a0,msgDadosOrg         # imprime um traco e espaco (- )
		syscall
		
		mul $t1,$s0,12     #multiplica o vetor de times por 12, para que se possa imprimir o time ordenadamente
		
		li $v0,4
		la $a0,times($t1)      #imprime o nome do time
		li $a1,12
		syscall
		
		li $v0,4
		la $a0,msgOrg4      #imprime um espacamento
		syscall
		
		move $t1,$zero
		
		lw $s0,timesJogosRod1($t0)      #carrega os jogos que foram jogados por cada time
		
		li $v0,1
		move $a0,$s0        #imprime o numero dos jogos
		syscall
		
		move $a0,$zero       
		
		li $v0,4
		la $a0,msgOrg4
		syscall              #imprime a tabulacao
		
		lw $s0,timesVencedorRod1($t0)      #carrega a vitoria de cada time
		
		li $v0,1
		move $a0,$s0       #imprime a vitoria do time
		syscall
		
		li $v0,4
		la $a0,msgOrg4         #imprime uma tabulacao
		syscall
		
		lw $s0,timesPerdedorRod1($t0)        #carrega o numero de derrotas que cada time teve
		
		li $v0,1
		move $a0,$s0            #imprime o numero de derrotas
		syscall
		
		li $v0,4
		la $a0,msgOrg2 			# imrprime um separamento para cada time
		syscall
		
		addi $s1,$s1,1
		addi $t0,$t0,4       #adiciona 1 no s0, e 4 no t0 para alcancar o proximo vetor
		
		bne $s1,11,imprimirTabela1   #faz isso enquanto a tabela n for impressa completamente
		  
		jr $ra


loop:     #parte do bubble sort

move $t0,$zero     #carrega 0 em $t0
j sort

sort:

	lw $s0,timesVencedorRod1($t0)       #carrega o numero de vitorias do time
	addi $t0,$t0,4
	lw $s1,timesVencedorRod1($t0)      #carrega o numero de vitorias do time que esta na frente do betpr
	bne $t0,40,cont                   #se o vetor ainda n for 40, pula pra uma continuacao
	addi $s5,$s5,1         #senao, adiciona 1 no for de fora, e volta ao looping
	bne $s5,10,loop
	j termina
	cont:
	blt $s0,$s1,sort1       #se o numero de vitorias do time 1 for maior que o do 0, inverte os vetores para que o numero com 
	j sort #pula para a funcao de inversao                             #mais vitorias fiquem em primeiro

	
	
sort1:

	addi $t0,$t0,-4         #volta uma casa do vetor
	lw $s0,aux_times($t0)
	lw $s1,timesVencedorRod1($t0)
	lw $s2,timesPerdedorRod1($t0)          #carrega todos os elementos que serao invertidos 
	lw $t2,timesJogosRod1($t0)
	addi $t0,$t0,4                 #soma uma casa 
	lw $s3,aux_times($t0)
	lw $s4,timesVencedorRod1($t0)
	lw $s6,timesPerdedorRod1($t0)           #carrega todos os elementos que serao invertidos em outros registradores
	lw $t3,timesJogosRod1($t0)
	addi $t0,$t0,-4     #volta uma casa
	sw $s3,aux_times($t0)
	sw $s4,timesVencedorRod1($t0)
	sw $s6,timesPerdedorRod1($t0)           #salva os elementos que acabaram de ser salvos no vetor de tras
	sw $t3,timesJogosRod1($t0)
	addi $t0,$t0,4       #vai uma casa para frente e salva os outros elementos
	sw $s0,aux_times($t0)
	sw $s1,timesVencedorRod1($t0)
	sw $s2,timesPerdedorRod1($t0)
	sw $t2,timesJogosRod1($t0)
	j sort              #continua no for de dentro

termina: 
	li $t9,1
	jal imprimirTabela   #se o usuario quiser finalizar o programa, ou ja fizer os 45 jogos, imprimira a tabela ordenada
				# e logo apos isso, ira imprimir os resultados finais
	li $t0,0
	li $t1,0
	li $t2,1
	
termina1:

	li $v0,4
	la $a0,msgFinal
	syscall

	li $v0,4               #imprime as mensagens do final do programa, dizendo quem esta em cada classificacao
	la $a0,msgFinal2
	syscall
	
imprimirFinais1:
	
	lw $s1,aux_times($t0)         #carrega o auxiliar de times, que ira ajudar a imprimir os nomes de forma ordenada
	
	mul $t1,$s1,12      #multiplica pelo numero de bytes que cada times possui
	
	
	li $v0,1              #imprime o numero da posicao que o time esta classificado
	move $a0,$t2
	syscall
	
	li $v0,4
	la $a0,msgDadosOrg   #imprime um traco e um espaco
	syscall
	
	li $v0,4
	la $a0,times($t1)
	li $a1,12          #imprime o nomedo do time
	syscall
	
	addi $t0,$t0,4    #incrementa os vetores
	addi $t2,$t2,1
	
	bne $t0,8,imprimirFinais1       #faz isso ate $t0 for menor que 8
	
	li $v0,4
	la $a0,msgFinal3      #imprime quem esta nas 4 de final
	syscall
	

imprimirFinais2:

	lw $s1,aux_times($t0)        #continua imprimindo os times que estao nas quartas de final
	
	mul $t1,$s1,12

	li $v0,1
	move $a0,$t2
	syscall
	
	li $v0,4
	la $a0,msgDadosOrg
	syscall
	
	li $v0,4
	la $a0,times($t1)
	li $a1,12
	syscall
	
	addi $t0,$t0,4
	addi $t2,$t2,1
	
	bne $t0,24,imprimirFinais2          # faz isso ate o vetor ser 24, ou seja, ate imprimir 4 tipos, com o mesmo processo
						# feito anteriormente
	li $v0,4
	la $a0,msgFinal4
	syscall
	
imprimirFinais3:

	lw $s1,aux_times($t0)
	
	mul $t1,$s1,12

	li $v0,1
	move $a0,$t2
	syscall
					#faz o mesmo processo ocorrido anteriormente, mostrando com esta desclassificado
	li $v0,4
	la $a0,msgDadosOrg
	syscall
	
	li $v0,4
	la $a0,times($t1)
	li $a1,12
	syscall
	
	addi $t0,$t0,4
	addi $t2,$t2,1
	
	bne $t0,32,imprimirFinais3    #imprime mais 2 times
	
	li $v0,4
	la $a0,msgFinal5
	syscall
	
imprimirFinais4:

	lw $s1,aux_times($t0)
	
	mul $t1,$s1,12

	li $v0,1
	move $a0,$t2
	syscall
	
	li $v0,4
	la $a0,msgDadosOrg
	syscall
	 			#faz o mesmo processo feito anteriormente, imprimindo quem foram os times rebaixados
	li $v0,4
	la $a0,times($t1)
	li $a1,12
	syscall
	
	addi $t0,$t0,4
	addi $t2,$t2,1
	
	bne $t0,40,imprimirFinais4	#faz isso ate ser 40
	
	li $v0,4
	la $a0,msgFinal6
	syscall

	j finaliza		#pula para o li $v0,10 e encerra o programa

aviso4:

	li $v0,4
	la $a0,msgTimesJogaram
	syscall                        #mensagem de aviso de numero invalido
	
	j volta_aqui1

aviso3:
     li $v0,4
    la $a0,msgAviso
    syscall
    				#mensagem de aviso de numero invalido
    j volta_aqui1

aviso2:

     li $v0,4
    la $a0,msgAviso
    syscall
    				#mensagem de aviso de numero invalido
    j voltaDados
  
aviso:

    li $v0,4
    la $a0,msgAviso				#mensagem de aviso de numero invalido
    syscall

    j menu2
