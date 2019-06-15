# Desafio desenvolvimento mobile

A idéia deste desafio é nos permitir avaliar melhor as habilidades de candidatos à vagas de desenvolvimento mobile.

## Instruções de entrega do desafio

Para iniciar o desenvolvimento, favor criar um fork deste repositório para sua conta pessoal. Essa será a versão utilizada para sua avaliação, portanto não esqueça de dar a permissão com role Reporter ao usuário da radix (radix.recruit) ao repositório recém criado.

## Descrição do projeto

Você deve criar um aplicativo que irá listar os repositórios públicos de um usuário buscado, usando a [API do GitHub](https://developer.github.com/v3/) para buscar os dados necessários.

O aplicativo deve exibir inicialmente uma busca com o campo para inserir o nome do usuário e um botão que levará para a lista dos repositórios do usuário encontrado, ordenados por popularidade decrescente (exemplo de chamada da API: `https://api.github.com/users/<username_buscado>/repos`).

A tela com a lista de repositório deve exibir:
* Nome
* Avatar do usuário
* Lista de repositórios
* Cada repositório da lista deve exibir Nome do repositório, Descrição truncada

Ao clicar em um repositório, o mesmo deve levar para uma tela com:

* Nome do Repositório
* Descrição completa
* Número de Stars
* Número de Forks
* Número de issues abertas e fechadas
* Data de criação do repositório

Ao tocar no ícone para abrir no github, deve abrir no browser a página do repositório em questão.

Você pode se basear neste mockup para criar as telas:

![mockup](https://gitlab.com/radix.recruit/mobile-challenger/raw/master/img.png)

Sua aplicação deve:

- estar escrita em Java e/ou Kotlin (**Candidato Android**) / Objective C ou Swift (**Candidato iOS**) / Javascript (**Candidato React Native**)
- fazer mapeamento json -> Objeto
- usar um arquivo .gitignore no seu repositório

Você ganha mais pontos se:
- possuir boa cobertura de testes unitários no projeto.
- persistir os dados localmente (app funcionando offline)
- criar testes de de interface
- fazer cache de imagens
- suportar mudanças de orientação das telas sem perder estado

Sinta-se a vontade para usar soluções diferentes e nos surpreender. O importante de fato é que os objetivos macros sejam atingidos.

## Avaliação

Seu projeto será avaliado de acordo com os seguintes critérios.

1. Sua aplicação preenche os requerimentos básicos?
1. Você documentou a maneira de rodar sua aplicação?
1. Você seguiu as instruções de envio do desafio?

Adicionalmente, tentaremos verificar a sua familiarização com as bibliotecas padrões (standard libs), bem como sua experiência com programação orientada a objetos e programação funcional, a partir da estrutura de seu projeto.