# codigo-de-barras-MATA103
Customização ADVPL com o objetivo de transferir a responsabilidade de inclusão do código de barras para a rotina de documento de entrada (MATA103)

# Passos para o devido funcionamento
```
1 - Criar campo F1_XCODBAR e alterar o limite de caracteres para 999;
2 - Preencher neste campo todos os códigos de barras dos títulos respectivamente gerados pelo doc de entrada (Separados por ";"); 
Exemplo: 534534353153;4534343531351;9353435454354.
3 - Após a gravação, os títulos serão gerados com os campos de código de barras e linha digitável preenchidos.
````
