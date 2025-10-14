# WANderer - Monitoramento de Gateways pfSense com Notificações no Telegram

O **WANderer** é uma solução de monitoramento simples e eficaz para administradores de redes que utilizam pfSense. Composto por três scripts em shell, ele verifica o status dos gateways de internet e envia alertas em tempo real para um bot do Telegram sempre que um link fica online ou offline.

## Arquitetura

O projeto é dividido em três scripts modulares:

1.  `check-gateway-status.sh`: Responsável por verificar o estado de um gateway específico. Ele determina se o link está **UP** ou **DOWN** através de uma lógica condicional (`if/else`).
2.  `telegram-notify.sh`: Contém a função básica para enviar a mensagem formatada para a API do Telegram, utilizando o token do bot e o chat ID configurados.
3.  `gateway-monitor.sh`: O script principal (core) do sistema. Ele orquestra os outros dois, consolidando as informações, montando a mensagem completa de status e acionando o `telegram-notify.sh` para enviar o alerta.

## Funcionalidades

* **Monitoramento Ativo**: Verifica continuamente o status dos seus links de WAN.
* **Notificações Instantâneas**: Alerta sobre mudanças de status (quedas e restabelecimentos) diretamente no Telegram.
* **Simples e Leve**: Scripts em shell puro, sem necessidade de dependências complexas.
* **Fácil de Agendar**: Perfeito para ser executado via Cron no próprio pfSense.

## Pré-requisitos

* Um firewall pfSense com múltiplos gateways configurados.
* Acesso de administrador à interface web (WebUI) do pfSense.
* Um bot do Telegram criado e seu respectivo **token de API**.
* O **Chat ID** do canal, grupo ou usuário que receberá as notificações.

## Instalação (via pfSense WebUI)

A instalação é feita diretamente pela interface gráfica do pfSense, sem a necessidade de acesso SSH.

1.  **Crie os Scripts no pfSense:**
    * Acesse a interface do seu pfSense.
    * Vá para o menu **Diagnostics > Edit File**.
    * No campo **"Path to file"**, digite o caminho completo onde o primeiro script será salvo. Exemplo: `/root/wanderer/check-gateway-status.sh`.
    * Abra o arquivo `check-gateway-status.sh` no seu computador com um editor de texto (Bloco de Notas, VSCode, etc.), copie todo o conteúdo.
    * Cole o conteúdo na caixa de texto **"File Contents"** dentro do pfSense.
    * Clique em **Save**.
    * **Repita este processo** para os outros dois scripts, `telegram-notify.sh` e `gateway-monitor.sh`, salvando-os no mesmo diretório `/root/wanderer/`.

2.  **Dê Permissão de Execução:**
    * Ainda na interface do pfSense, vá para **Diagnostics > Command Prompt**.
    * No campo **"Execute Shell Command"**, cole o comando abaixo para tornar os três scripts executáveis:
        ```bash
        chmod +x /root/wanderer/*.sh
        ```
    * Clique em **Execute**.

Pronto! Os scripts estão instalados e prontos para serem configurados.

## Configuração

Para configurar, edite os arquivos diretamente na interface do pfSense.

1.  Navegue até **Diagnostics > Edit File**.
2.  No campo **"Path to file"**, digite o caminho do script a ser editado (ex: `/root/wanderer/gateway-monitor.sh`) e clique em **Load**.
3.  O conteúdo do arquivo aparecerá na caixa de texto. Altere as seguintes variáveis:
    * **`TELEGRAM_BOT_TOKEN`**: Cole o token de API do seu bot do Telegram.
    * **`TELEGRAM_CHAT_ID`**: Insira o ID do chat de destino.
    * **`GATEWAY_NAMES`**: Defina os nomes dos gateways que deseja monitorar, exatamente como aparecem no pfSense (ex: `"WAN1" "WAN_FIBRA"`).
4.  Clique em **Save** para aplicar as alterações.

## Uso e Agendamento (Cron)

O script que deve ser executado é o `gateway-monitor.sh`. A maneira mais recomendada de usá-lo é agendando sua execução através do pacote Cron.

1.  Na interface web do pfSense, instale o pacote `Cron` (se ainda não tiver) em **System > Package Manager**.
2.  Vá para **Services > Cron**.
3.  Clique em **Add** para criar uma nova tarefa.
4.  Preencha os campos da seguinte forma:
    * **Minute**: `*` (para executar todo minuto).
    * **Hour**: `*`
    * **Day of Month**: `*`
    * **Month**: `*`
    * **Day of Week**: `*`
    * **User**: `root`
    * **Command**: Insira o caminho completo para o script principal: `/root/wanderer/gateway-monitor.sh`

5.  Salve a tarefa. O monitoramento já está ativo!

## Contribuição

Sinta-se à vontade para abrir uma *issue* para relatar problemas ou sugerir melhorias. *Pull requests* são muito bem-vindos!

## Licença

Este projeto é distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
