//bibliotecas
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <cs50.h>
#define TAM 26

//declaração das funções
void criptografia();
int erro_caracteres_duplos();
int nao_letra();
int nao_26();
int nao_umachave();
int nao_chave();

// declaração do vetor alfabeto
char ALFABETO[26] ={"abcdefghijklmnopqrstuvwxyz"};

//inicio
int main(int argc, string argv[])
{

    // mensagens de erro
    if(nao_chave(argc) == 1)
    {
        printf("Use: ./substitution *26letters key*\n");
        return 1;
    }

    if(nao_umachave(argc) == 1)
    {
        printf("Only one key must be detected.\n");
        return 1;
    }

    if(nao_26(argv[1]) == 1)
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }

    if(nao_letra(argv[1]) == 1)
    {
        printf("Only letters\n");
        return 1;
    }

    if(erro_caracteres_duplos(argv[1]) == 1)
    {
        printf("The letter cant repeat\n");
        return 1;
    }


    //inserir texto
    string msg = get_string("plaintext: ");


    //criptografia
    criptografia(msg, argv[1]);


    //imprimir texto criptografado
    printf("ciphertext: %s\n", msg);

    return 0;
}
//fim

//inicio das funções

//confere se existe chave
int nao_chave(int argc)
{
    if(argc == 1)
    {
        return 1;
    }

    return 0;
}

//confere se existe apenas uma chave
int nao_umachave(int argc)
{
    if(argc > 2)
    {
        return 1;
    }

    return 0;
}

//confere se existe 26 letras na chave
int nao_26(string argv)
{
    if(strlen(argv) != 26)
    {
        return 1;
    }

    return 0;
}

//confere se existe apenas letras na chave
int nao_letra(string argv)
{
    int i;

    for(i = 0; i < TAM; i++)
    {
        //se o item é uma letra
        if(isalpha(argv[i]) == 0)
        {
            return 1;
        }
    }
    return 0;
}

//confere se n existe repetição de caracteres
int erro_caracteres_duplos(string argv)
{
    char copy_argv[TAM];
    strcpy(copy_argv, argv);
    int i, j, menor;
    char aux;

    //converte a chave inteira para minusculo
    for(i = 0; i < TAM; i++)
    {
        copy_argv[i] = tolower(copy_argv[i]);
    }

    //ordena a chave em ordem alfabetica
    for(i = 0; i < TAM; i++)
    {
        menor = i;
        for(j = i + 1; j < TAM; j++)
        {
            if(copy_argv[j] < copy_argv[menor])
            {
                menor = j;
            }
        }
        if(menor != i)
        {
            aux = copy_argv[i];
            copy_argv[i] = copy_argv[menor];
            copy_argv[menor] = aux;
        }
    }

    //compara a chave ordenada com o alfabeto para conferir se n existe nenhuma letra faltando
    if(strcmp(copy_argv, ALFABETO) != 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//criptografar texto
void criptografia(string msg, string argv)
{

    //criptografia
    int len = strlen(msg);

    //passa item por item para substituilo pelo correspondente na chave
    for(int i = 0; i < len; i++)
    {
        for(int j = 0; j < TAM; j++)
        {
            if(tolower(msg[i]) == ALFABETO[j])
            {
                if(msg[i] == tolower(msg[i]))
                {
                    msg[i] = tolower(argv[j]);
                }
                else
                {
                    msg[i] = toupper(argv[j]);
                }
                break;
            }
        }
    }
 }
//fim
