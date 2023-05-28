# Taskoo

Taskoo é uma lista de tarefas com divisão entre Tarefas e Categorias

## Resumo & Motivos

Esse projeto foi criado com o intuito de testar meus conhechimentos básicos em Flutter, tendo em vista que app de Todo List são ideias para iniciantes,
já que seu desenvolvimento, a princípio simples, possuem desafios que serão recorrentes na carreira de um desenvolvedor, tais como :
  - Compreensão e aplicabilidade do CRUD
  - Greneciamento de Estado
  - Design de UI
  - Interação com o usuário
  - Permanência de dados

## Tecnologias Utilizadas

-Gerencia de Estado do prórpio Flutter:
  Apesar do Flutter possui excelentes pacotes de gerência de estado, como [MobX](https://pub.dev/packages/mobx), [BLOC](https://pub.dev/packages/bloc) e etc, 
  aprender a trabalhar com o pacote padrão de gerência do Flutter é essencial para a compreensão do comportamento do Flutter mediante mudanças de estado.

-Replicação de UI com algumas modificações:
  O Design escolhido para me inspirar foi criado por [Alex Arutuynov](https://dribbble.com/shots/14100356-ToDo-App-UI) 
  
  -Modificações Relativas ao Design:
    - O Drawer não foi criado, tendo em vista que o Mockup não demonstra o que seriam essa funções ou páginas
    - A animação ao deletar um tarefa não foi criada, pois o objetivo desse app são conhecimentos básicos
    - A edição e remoção de tarefas ou categorias foram embutidas em um Slidable Widget, proveniente da biblioteca [flutter_slidable](https://pub.dev/packages/flutter_slidable)
    - Foi criado um botão de Deletar todas as tarefas marcadas como "Realizado", esse por sua vez simbolizado por uma lixeira com seta apontando para cima
  
-Permanência de Dados com Uso do pacote SQFLITE:
  Desdo início o app foi pensado com permanência de dados local e a escolha do [Sqflite](https://pub.dev/packages/flutter_slidable) se deu pela sua capacidade de fazer 
  consultas avançadas e estruturar dados mais complexos, além de requisitar conhecimento de sintaxe da linguagem SQL, conhecimento esse fundamental para qualquer desenvolvedor. 
  
