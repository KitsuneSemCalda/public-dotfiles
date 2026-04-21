# Pop!_OS Optimization for Samsung 550XDA-KF2BR

**Perfil de Uso Focado:** Criação de Conteúdo | Gaming | Virtualização | Desenvolvimento

**Especificações de Hardware:**
- **CPU:** Intel Core i5-1135G7 (TigerLake) - 4 Cores / 8 Threads
- **RAM:** 8GB DDR4 + 7.5GB ZRAM
- **GPU:** Intel Iris Xe Graphics (TGL GT2)
- **Armazenamento:** 256GB NVMe

---

## 🚀 Quick Start

Para rodar todo o ambiente de forma orquestrada, basta executar o script principal:

```bash
cd SamsungBook-Np550XDA-KF2BR/Pop-os/acts
chmod +x main.sh
sudo ./main.sh
```

---

## 📂 Como os Scripts Funcionam (Background)

A pasta `Pop-os/acts/` divide as tarefas em pequenos scripts granulares. O `main.sh` executa eles em ordem lógica.

| Script | O Que Faz por Trás dos Panos |
|--------|---------|
| `main.sh` | **Orquestrador**. Chama os scripts abaixo validando as permissões e dependências de cada um. |
| `install_new_things.sh` | **Gestor de Pacotes**. Instala ferramentas de sistema e desenvolvimento via APT, e isola as aplicações gráficas pesadas (Kdenlive, OBS, Blender) em Flatpaks para ter os drivers mais recentes sempre atualizados. |
| `sysctl-tuning.sh` | **Afinador de Kernel**. Injeta parâmetros de otimização no nível do Kernel do Linux, focado em agressividade do NVMe, rede (TCP BBR) e gestão do ZRAM. |
| `start-services.sh` | **Gestor de Daemons**. Ativa ferramentas base de hardware como TLP, thermald e irqbalance. |
| `update_profile.sh` | **Injetor de Variáveis**. Ele lê o arquivo mestre `Config/enviroment_config` e constrói dinamicamente as variáveis de ambiente dentro do `.profile` e `/etc/environment.d/` de forma idempotente (segura para rodar múltiplas vezes). |
| `clean-system.sh` | **Faxina**. Remove bloatwares e pacotes em excesso que não condizem com a instalação mínima (ex: LibreOffice e velhas instalações Firefox). |

---

## 🧠 Otimizações de Hardware Aplicadas

Devido às limitações de **8GB de memória física** combinada a uma **Iris Xe (que compartilha memória com o sistema)**, aplicamos um perfil rígido de "Cinto de Segurança OOM (Out Of Memory)", extraindo alta performance sem causar crashes na máquina.

### 🛡️ Proteção OOM (8GB RAM Constraints)
- **Java:** Limite global máximo fixado em `2GB` (`-Xmx2G`). Isso permite que ambientes pesados (Gradle, Maven, LSPs e IDEs) rodem soltos sem "engolirem" todos os seus recursos de RAM, prevenindo o congelamento do Pop!_OS.
- **Containers (Podman/Docker):** Limitados a `5GB` por container. Garante que o Kernel sempre terá fôlego mesmo sob extresse de docker-compose.
- **ZRAM:** Compressão ativa trabalhando dinamicamente em até 7.5GB para dobrar virtualmente o espaço em memória rápida.

### 🎥 Criação de Conteúdo e Kdenlive (Intel Iris Xe)
- **Kdenlive (Flatpak):** O pesado e antigo DaVinci Resolve foi substituído pelo Kdenlive (Flatpak). O Kdenlive consome drasticamente menos recursos. Ele utiliza a flag `MLT_MOVIT_HW_RENDER=1` para processar e renderizar efeitos visuais e cortes diretamente por hardware via OpenCL na Iris Xe.
- **VAAPI e FFmpeg:** Utilização dos drivers nativos `iHD` e `i965` (Intel) com aceleração transparente configurada por hardware (`FFMPEG_HW_ACCEL=vaapi`) para transcodificações em velocidade relâmpago.

### 🎮 Gaming e Vulkan
- **Intel Vulkan Pipeline Cache:** Variavel `ANV_ENABLE_PIPELINE_CACHE=1` explicitamente adicionada para que o driver de código aberto Intel (ANV) reaja perfeitamente guardando *shaders* previamente compilados, reduzindo travamentos ou quedas de frames bruscas em jogos no Lutris/Steam.
- **Mesa Intel:** Limpamos as otimizações defasadas focadas em drivers da AMD (`RADV`) e ativamos uma diretriz mais voltada para Wayland.

### 💻 Desenvolvimento e VM's (i5-1135G7)
- Compilação paralelizada habilitada em força bruta com `MAKEFLAGS=-j8`, `CARGO_BUILD_JOBS=8` e `OMP_NUM_THREADS=8` usando o processador da 11ª Gen de forma integral para builds em Rust/C++.
- KVM e libvirt pré-engatados para virtualização, limitados aos mesmos recursos da regra de OOM.

---

## 🛠️ Pós-Instalação / Rotina de Manutenção

Caso você altere qualquer regra mestra no arquivo `Config/enviroment_config`, apenas recarregue os scripts para ele injetar o novo perfil de proteção no sistema:

```bash
# Injeta as variáveis no perfil atual
cd ~/Work/public-dotfiles/SamsungBook-Np550XDA-KF2BR/Pop-os/acts
./update_profile.sh

# Verifica a resposta do driver de vídeo em Hardware:
vainfo
```
