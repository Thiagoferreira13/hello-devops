# Hello-devops
Atividade prática de DevOps com Spring Boot, Docker, GitHub Actions e publicação de imagens no GHCR.

## Endpoint

```text
GET /hello

```

# Evidências

## Versão 1.0 — Hello World

### Build local

A imagem da versão 1.0 foi construída localmente a partir do `Dockerfile`.

```console
$ docker build -t hello-devops-local:1.0 .
[+] Building 1.4s (14/14) FINISHED
...
=> [builder 5/5] RUN mvn clean package -DskipTests
=> [stage-1 3/3] COPY --from=builder /app/target/*.jar app.jar
=> naming to docker.io/library/hello-devops-local:1.0
```

Imagem criada:

```console
$ docker images
IMAGE                    ID             DISK USAGE   CONTENT SIZE
hello-devops-local:1.0   20afd9a495c9        523MB          138MB
```

### Execução local da versão 1.0

```console
$ docker run --rm -d --name hello-devops-local-v1 -p 8080:8080 hello-devops-local:1.0

d5121bd07c67cd09e6ce3adce197a5d4907f9b9b0947727d2577a958fcf50987
```

Container em execução:

```console
$ docker ps
CONTAINER ID   IMAGE                    COMMAND               STATUS         PORTS                                         NAMES
d5121bd07c67   hello-devops-local:1.0   "java -jar app.jar"   Up 6 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   hello-devops-local-v1
```

Teste do endpoint:

```console
$ curl http://localhost:8080/hello
Hello World
```

---

## Pipeline GitHub Actions — versão 1.0

O push para a branch principal disparou automaticamente o workflow do GitHub Actions, responsável pelo build, teste e publicação da imagem no GitHub Container Registry.

![Pipeline da versão 1.0](docs/evidencias/pipeline-v1-1.png)
![Pipeline da versão 1.0](docs/evidencias/pipeline-v1-2.png)

![Publicação da versão 1.0](docs/evidencias/push-v1.png)

---

## Imagem 1.0 no GitHub Container Registry

Imagem publicada:

```text
ghcr.io/thiagoferreira13/hello-devops:1.0
```

Download da imagem publicada:

```console
$ docker pull ghcr.io/thiagoferreira13/hello-devops:1.0
1.0: Pulling from thiagoferreira13/hello-devops
Digest: sha256:a91fd0052ec2d07a72fb8a205231d396e6b137a9e0b9c2d7635fae998c978399
Status: Image is up to date for ghcr.io/thiagoferreira13/hello-devops:1.0
ghcr.io/thiagoferreira13/hello-devops:1.0
```

### Execução da imagem 1.0 baixada do Registry

```console
$ docker run --rm -d --name hello-devops-registry-v1 -p 8080:8080 ghcr.io/thiagoferreira13/hello-devops:1.0

18a631f19a319d6893e32bb8a2432df471642aff73f1a19c0fce25edd0b170ae
```

Container em execução:

```console
$ docker ps
CONTAINER ID   IMAGE                                       COMMAND               STATUS         PORTS                                         NAMES
18a631f19a31   ghcr.io/thiagoferreira13/hello-devops:1.0   "java -jar app.jar"   Up 4 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   hello-devops-registry-v1
```

Teste do endpoint:

```console
$ curl http://localhost:8080/hello
Hello World
```

---

# Versão 2.0 — Hello World 2

Após a alteração da aplicação, uma nova versão foi criada com a tag `2.0`.

### Build local

Imagem criada localmente:

```console
$ docker images
IMAGE                    ID             DISK USAGE   CONTENT SIZE
hello-devops-local:2.0   a3aa199b3f23        523MB          138MB
```

### Execução local da versão 2.0

```console
$ docker run --rm -d --name hello-devops-local-v2 -p 8080:8080 hello-devops-local:2.0

a50593cb26c84992f58d651bd29a02021ebfb36bfd53547664d776d122924e2f
```

Teste do endpoint:

```console
$ curl http://localhost:8080/hello
Hello World 2
```

---

## Pipeline GitHub Actions — versão 2.0

O novo push após a alteração da aplicação disparou novamente o workflow, construindo, testando e publicando a versão `2.0`.

![Pipeline da versão 2.0](docs/evidencias/pipeline-v2-1.png)
![Pipeline da versão 2.0](docs/evidencias/pipeline-v2-2.png)

![Publicação da versão 2.0](docs/evidencias/push-v2.png)

---

## Imagem 2.0 no GitHub Container Registry

Imagem publicada:

```text
ghcr.io/thiagoferreira13/hello-devops:2.0
```

Download da imagem publicada:

```console
$ docker pull ghcr.io/thiagoferreira13/hello-devops:2.0
2.0: Pulling from thiagoferreira13/hello-devops
Digest: sha256:170b28e80ff9d455ecb606f6a38fd7fa86af324cb644be375d53c44a094d1042
Status: Image is up to date for ghcr.io/thiagoferreira13/hello-devops:2.0
ghcr.io/thiagoferreira13/hello-devops:2.0
```

### Execução da imagem 2.0 baixada do Registry

```console
$ docker run --rm -d --name hello-devops-registry-v2 -p 8080:8080 ghcr.io/thiagoferreira13/hello-devops:2.0

e3a0fa70502658fdd315a1622ac48bb78c1da136eac6a882faaf2a68079fe2b5
```

Container em execução:

```console
$ docker ps
CONTAINER ID   IMAGE                                       COMMAND               STATUS         PORTS                                         NAMES
e3a0fa705026   ghcr.io/thiagoferreira13/hello-devops:2.0   "java -jar app.jar"   Up 5 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   hello-devops-registry-v2
```

Teste do endpoint:

```console
$ curl http://localhost:8080/hello
Hello World 2
```

---

## Versões publicadas no GHCR

O GitHub Container Registry contém as duas versões exigidas pela atividade:

```text
ghcr.io/thiagoferreira13/hello-devops:1.0
ghcr.io/thiagoferreira13/hello-devops:2.0
```

![Versões 1.0 e 2.0 no GHCR](docs/evidencias/ghcr-versoes.png)

---

## Pipeline DevSecOps

O workflow `.github/workflows/docker.yml` roda na abertura e atualização de PRs
e em pushes na `main`. Preserva construção Docker, teste HTTP de `/hello` e
publicação no GHCR. A implementação local precisa ser confirmada pelas execuções
remotas; resultados das ferramentas não são presumidos como aprovados.

| Check | Verificação e regra de bloqueio |
| --- | --- |
| Gitleaks | Histórico completo (`fetch-depth: 0`, `git --log-opts="--all"`). Segredo detectado reprova; relatório com valores ocultados. |
| SonarCloud Quality Gate | Testes Maven com Java 25, cobertura JaCoCo, análise SAST e espera pelo resultado do gate. Falha de testes, análise ou gate impede publicação. |
| Docker, Trivy e SBOM | Build, teste HTTP, Syft e Trivy nas dependências Maven e na imagem. HIGH/CRITICAL com correção disponível bloqueiam. |
| Publicar GHCR | Somente push na main, após sucesso de todos os checks. Publica a mesma imagem analisada, sem reconstruí-la. Nunca publica imagens de PR. |

Trivy gera relatórios JSON completos, incluindo LOW/MEDIUM e vulnerabilidades
sem correção. Os gates usam `--severity HIGH,CRITICAL --ignore-unfixed --exit-code 1`.
LOW/MEDIUM e vulnerabilidades sem correção são registradas, mas não bloqueiam.
Erros de execução das ferramentas também fazem o job falhar.
Não há exceções de CVEs nem `continue-on-error` nos checks.

Gitleaks, Trivy e Syft são instalados por `scripts/install-security-tools.sh`
com versões e SHA-256 fixos dos arquivos oficiais. Syft gera SPDX JSON a partir
da imagem Docker construída, incluindo componentes e versões.

### SonarCloud

Organização: `thiagoferreira13`. Projeto: `Thiagoferreira13_hello-devops`.
O repository secret `SONAR_TOKEN` fornece a credencial; nenhum token é versionado.
A análise automática deve estar desativada para usar a análise via CI.

Gate selecionado: **Sonar way**, com condições sobre código novo:
segurança, confiabilidade e manutenibilidade A; hotspots revisados 100%;
cobertura >= 80%; duplicação <= 3%. O projeto mantém a opção padrão que ignora
cobertura/duplicação para mudanças com menos de 20 linhas novas. As demais
condições continuam valendo. Definição de código novo: **Previous version**.
A versão Maven em `pom.xml` é a referência de versão da análise; o arquivo
`VERSION` controla a tag Docker. Em PRs, a análise considera as alterações do PR.

Para testes e cobertura locais: `./mvnw -B clean verify`.
Relatórios: `target/site/jacoco/index.html` e `target/site/jacoco/jacoco.xml`.

### Artifacts e publicação

- `gitleaks-report`: relatório de segredos com valores ocultados.
- `testes-e-cobertura`: testes Maven e cobertura JaCoCo.
- `trivy-reports`: relatórios completos e tabelas dos gates, inclusive em reprovação.
- `sbom-<sha>`: arquivo `sbom.spdx.json` gerado com Syft.
- `imagem-aprovada`: transporte da imagem entre jobs em pushes; retenção de 1 dia.

O GHCR usa o `GITHUB_TOKEN` automático, com `packages: write` apenas no job de
publicação. O pacote `hello-devops` precisa permitir acesso a este repositório
em suas configurações de Actions. Os antigos secrets `REGISTRY_USERNAME` e
`REGISTRY_TOKEN` não são utilizados pelo workflow novo.
Tags publicadas: conteúdo de `VERSION` e `sha-<commit>`.

### Proteção e demonstração — pendentes

Depois da primeira execução, configurar a main para exigir PR e os três checks:
`Gitleaks`, `SonarCloud Quality Gate` e `Docker, Trivy e SBOM`.
A regra deve estar ativa e sem bypass usado na demonstração. Se o recurso não
estiver disponível, documentar a limitação conforme o enunciado.

A demonstração será feita em branch de teste: adicionar uma dependência Java
com CVE HIGH/CRITICAL e correção disponível, abrir PR, registrar falha e bloqueio,
e atualizar a dependência no mesmo PR. A versão vulnerável não será mesclada.
A escolha da dependência será confirmada na base Trivy antes da demonstração.

Evidências finais e links serão registrados em
[docs/devsecops/roteiro.md](docs/devsecops/roteiro.md) após execução real.
As capturas da atividade Docker anterior foram preservadas acima.

### Validação local da implementação

O Trivy identificou vulnerabilidades HIGH/CRITICAL corrigíveis em Tomcat e
Jackson herdadas do Spring Boot 4.1.1. O parent foi atualizado para 4.1.2;
a nova análise do `pom.xml` não encontrou vulnerabilidades. Os testes Maven
passaram, o workflow passou no actionlint e o histórico local passou no Gitleaks.
Essas verificações locais não substituem as evidências do GitHub Actions.
