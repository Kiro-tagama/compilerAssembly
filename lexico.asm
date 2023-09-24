section .bss
buffer resb 100      ; Buffer para armazenar tokens
token_len equ $ - buffer  ; Comprimento do token

section .data
file_name db 'teste.cont',0   ; Nome do arquivo a ser lido
file_descriptor dd 0   ; Descritor de arquivo

section .text
global _start
extern exit, read, write, open, close

_start:
    ; Abre o arquivo para leitura
    mov eax, 5         ; Código da syscall para open (5)
    mov ebx, file_name
    mov ecx, 0         ; Modo de abertura (O_RDONLY)
    mov edx, 0o666     ; Permissões (rw-rw-rw-)
    int 0x80           ; Chama sys_open

    ; Verifica se o arquivo foi aberto com sucesso
    cmp eax, 0
    jl .error

    mov [file_descriptor], eax   ; Salva o descritor de arquivo

.read_line:
    ; Lê o arquivo linha por linha
    mov eax, 3         ; Código da syscall para read (3)
    mov ebx, [file_descriptor]
    mov ecx, buffer
    mov edx, token_len
    int 0x80           ; Chama sys_read

    ; Verifica se chegou ao final do arquivo
    cmp eax, 0
    jle .end

    ; O resultado está no buffer (linha lida)
    ; Você pode chamar o analisador léxico aqui para processar a linha

    ; Exemplo: escreve a linha no console
    mov eax, 4         ; Código da syscall para write (4)
    mov ebx, 1         ; Descritor de arquivo para stdout (1)
    mov ecx, buffer    ; Endereço do buffer
    int 0x80           ; Chama sys_write

    jmp .read_line

.end:
    ; Fecha o arquivo
    mov eax, 6         ; Código da syscall para close (6)
    mov ebx, [file_descriptor]
    int 0x80           ; Chama sys_close

    ; Encerra o programa
    mov eax, 1         ; Código da syscall para exit (1)
    xor ebx, ebx       ; Código de saída 0
    int 0x80

.error:
    ; Tratamento de erro ao abrir o arquivo
    ; Coloque aqui o código de tratamento de erro adequado
