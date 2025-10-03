# Convenções e Sistema de Tags

## Visão Geral

Este documento descreve o sistema de versionamento e tagging usado no projeto PJE CLI Assistant, baseado no Versionamento Semântico (SemVer) 2.0.0.

## Versionamento Semântico (SemVer) 2.0.0

O projeto segue o padrão de versionamento semântico com o formato: `MAJOR.MINOR.PATCH`

### Definições

- **MAJOR**: Mudanças incompatíveis com versões anteriores
- **MINOR**: Adição de funcionalidades compatíveis com versões anteriores
- **PATCH**: Correções de bugs compatíveis com versões anteriores

### Exemplos

- `1.0.0` - Primeira versão estável
- `1.0.1` - Correções de bugs na versão 1.0.0
- `1.1.0` - Novas funcionalidades compatíveis com 1.0.x
- `2.0.0` - Mudanças incompatíveis com versões anteriores

## Convenções de Tags

### Formato de Tag

Todas as tags seguem o formato: `vX.Y.Z`

Exemplos:
- `v1.0.0`
- `v1.2.3`
- `v2.0.0`

### Pré-lançamentos

Para versões pré-lançamento, usar o formato: `vX.Y.Z-tipo.numero`

Exemplos:
- `v1.0.0-alpha.1`
- `v1.0.0-beta.2`
- `v1.0.0-rc.1`

### Nomenclatura de Tipos de Pré-lançamento

- `alpha`: Versão para testes internos
- `beta`: Versão para testes externos
- `rc`: Release Candidate (versão candidata a estável)

## Política de Criação de Tags

### Critérios para Criação de Tags

1. **Patch Release (vX.Y.Z)**:
   - Correções de bugs
   - Pequenas melhorias
   - Atualizações de segurança
   - Nenhuma mudança incompatível

2. **Minor Release (vX.Y.0)**:
   - Novas funcionalidades compatíveis
   - Melhorias de desempenho
   - Novas APIs mantendo compatibilidade
   - Pode incluir correções de patches

3. **Major Release (vX.0.0)**:
   - Mudanças incompatíveis com versões anteriores
   - Reescritas significativas
   - Mudanças na arquitetura
   - Pode incluir todas as outras categorias

### Processo de Criação de Tags

1. **Preparação**:
   - Garantir que todos os testes estejam passando
   - Atualizar o CHANGELOG.md com as mudanças
   - Atualizar o arquivo VERSION com o novo número
   - Garantir que `main` esteja em dia com `develop`

2. **Criação da Tag**:
   - Criar a tag localmente: `git tag -a vX.Y.Z -m "Descrição da versão"`
   - Fazer push da tag: `git push origin vX.Y.Z`

3. **Criação do Release**:
   - Criar release no GitHub com base na tag
   - Incluir descrição detalhada das mudanças
   - Adicionar artefatos do build (se aplicável)

## Scripts de Apoio

### Script de Criação de Release

O script `scripts/release.sh` automatiza o processo de criação de releases:

```bash
# Criar novo patch release
./scripts/release.sh patch

# Criar novo minor release
./scripts/release.sh minor

# Criar novo major release
./scripts/release.sh major

# Criar pré-release
./scripts/release.sh pre alpha|beta|rc
```

### Script de Validação de Tag

O script verifica:
- Se o formato da tag está correto
- Se há commits desde a última tag
- Se os testes estão passando
- Se o CHANGELOG foi atualizado

## Workflow de Integração Contínua

### Validação Automática

- Verificar se todas as tags seguem o padrão SemVer
- Validar mensagem de tag
- Verificar conformidade com convenções de commit
- Garantir que testes estejam passando antes de criar tags

### Criação Automática de Releases

- Workflow do GitHub Actions cria automaticamente releases a partir de tags
- Gera changelog automático a partir de commits
- Publica artefatos de build (se configurado)

## Boas Práticas

### Planejamento de Releases

- Planejar releases com antecedência
- Criar milestones no GitHub para cada versão
- Associar issues e PRs às releases correspondentes
- Manter um roadmap de versões futuras

### Comunicação de Releases

- Manter CHANGELOG.md atualizado
- Escrever release notes claras e descritivas
- Comunicar mudanças significativas e breaking changes
- Atualizar documentação conforme necessário

### Gestão de Versões

- Não modificar tags após criadas
- Para correções em versões antigas, criar novas patches
- Manter branches de suporte para versões antigas (se necessário)
- Remover pré-releases após lançamento estável

## Exceções

- Em casos de emergência, pode-se criar tags diretamente
- Breaking changes em pré-releases não requerem nova major version
- Correções críticas podem justificar lançamentos fora do ciclo normal