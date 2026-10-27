# Trabalho prático — DevSecOps

Repositório: https://github.com/Thiagoferreira13/hello-devops

## Estado inicial

Aplicação Java 25 / Spring Boot, Maven e Docker. O workflow existente
`.github/workflows/docker.yml` executa em pull requests e pushes na main,
constrói a imagem, testa `/hello` e publica no GHCR em pushes.
O build Docker usa `-DskipTests`; os testes Maven precisam de uma etapa explícita.
As evidências das atividades anteriores permanecem em `docs/evidencias/`.

## Sequência de execução

- [x] Ler enunciado, slides e configuração atual do projeto.
- [x] Criar/importar projeto no SonarCloud e preparar secret e identificadores (secret informado como salvo pelo usuário).
- [ ] Integrar Gitleaks com histórico completo e falha por segredo detectado.
- [ ] Executar testes Maven e análise Sonar com espera pelo Quality Gate.
- [ ] Configurar Quality Gate sobre código novo e cobertura das alterações.
- [ ] Varrer dependências e imagem Docker com Trivy.
- [ ] Guardar relatórios completos; bloquear HIGH/CRITICAL com correção disponível.
- [ ] Gerar SBOM da imagem com Syft e disponibilizar como artifact.
- [ ] Condicionar publicação da imagem aprovada ao sucesso de todos os checks.
- [ ] Obter uma execução inicial e configurar checks obrigatórios na main.
- [ ] Abrir PR em branch de teste com dependência Java de CVE conhecida e corrigível.
- [ ] PAUSA: capturar relatório, checks falhando e merge bloqueado antes da correção.
- [ ] Corrigir a dependência no mesmo PR sem desabilitar gates.
- [ ] PAUSA: capturar execução aprovada e baixar SBOM.
- [ ] Atualizar README com regras, links e evidências reais; conferir entregáveis.

A versão vulnerável deve ficar restrita ao PR: sem merge e sem publicação.
Não introduzir credenciais reais para testar Gitleaks. Uma demonstração com
segredo fictício, se feita, deve usar uma branch separada: remover o arquivo
não remove o segredo do histórico que o Gitleaks analisa.

## Evidências mínimas para entrega

Não solicitar novas capturas de configuração. As três capturas Sonar já
coletadas em `docs/evidencias/` podem ser reaproveitadas.

1. PR bloqueado: captura com check reprovado e merge bloqueado, antes da correção.
2. Vulnerabilidade: trecho do relatório Trivy mostrando biblioteca, CVE,
   severidade, versão instalada e versão corrigida (artifact ou captura).
3. Execução após correção: captura com os três checks obrigatórios aprovados.
4. SBOM: baixar `sbom.spdx.json` do artifact da execução; não precisa de print extra.

Registrar URLs do repositório, PR e execuções com falha/sucesso e respectivos SHAs.
Guardar os arquivos em `docs/evidencias/`. Não marcar etapas como comprovadas
antes das execuções reais. Se proteção de branch estiver indisponível, registrar
a limitação em vez de afirmar que o merge foi bloqueado.

## Preparação do SonarCloud

1. Acessar https://sonarcloud.io com a conta GitHub e importar `hello-devops`.
2. Escolher análise via GitHub Actions para Maven. Desabilitar análise automática
   se estiver ativada, para usar a análise feita pelo pipeline.
3. Anotar Organization Key, Project Key e URL do projeto.
4. Gerar token de análise e salvá-lo diretamente em GitHub → repositório →
   Settings → Secrets and variables → Actions → New repository secret,
   com o nome `SONAR_TOKEN`. Não colocar o valor no chat, no Git ou em capturas.
5. Conferir a configuração de Quality Gate e New Code no projeto. Os critérios
   concretos serão registrados após verificar o que está disponível na conta.

Referências oficiais consultadas:
- https://www.sonarsource.com/resources/library/analyze-java-code-using-sonarcloud/
- https://github.com/SonarSource/sonarqube-scan-action (recomenda scanner Maven para projetos Maven)

## Etapa Sonar preparada localmente

- Organização: `thiagoferreira13`.
- Projeto: `Thiagoferreira13_hello-devops`.
- Testes e cobertura JaCoCo configurados no Maven.
- Workflow aguarda o Quality Gate e impede o job Docker se Sonar falhar.
- Pendente: execução remota, confirmação dos critérios do gate e definição de código novo.
- Não considerar a primeira análise automática como prova do pipeline Actions.

## Limite de atuação

Alterações e verificações do assistente são locais. Commit, push, criação de PR,
configurações no GitHub e merge serão realizados pelo usuário com orientação.

## Integração local das ferramentas

Gitleaks, Trivy e Syft foram adicionados ao workflow. Publicação depende dos três
checks e transporta a mesma imagem analisada entre jobs. Ainda é necessário
validar Sonar e permissões do GHCR na primeira execução remota.

## Envio manual da implementação

O usuário enviará os arquivos locais em uma branch de implementação e abrirá
PR para main. Primeiro validar os três checks sem a dependência vulnerável de
demonstração. Não fazer merge enquanto houver check obrigatório falhando.
Depois configurar a proteção, integrar a implementação aprovada e abrir outro
PR para a demonstração com a dependência vulnerável. Pausar antes de corrigir
esse segundo PR, para capturar o bloqueio real.

A base foi atualizada de Spring Boot 4.1.1 para 4.1.2 porque o Trivy encontrou
vulnerabilidades corrigíveis já existentes. Não foram adicionadas exceções.

Validação da imagem corrigida: build concluído, gate Trivy aprovado e SBOM
SPDX JSON gerado localmente. A imagem ainda registra vulnerabilidades não
bloqueantes; não afirmar que ela está livre de todas as vulnerabilidades.
