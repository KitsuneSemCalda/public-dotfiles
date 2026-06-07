# Arquivo `enviroment_config`

O arquivo `enviroment_config` atua como a **Fonte da Verdade** (Single Source of Truth) para o comportamento do seu sistema. O script `Pop-os/acts/update_profile.sh` lê esse arquivo e injeta as regras dinamicamente em toda a sua sessão gráfica (`.profile`) e no nível global do Linux (`/etc/environment.d/`).

Abaixo está o "dicionário" das camadas de otimização aplicadas à sua máquina:

## 1. 🎥 GPU Gráfica e Vídeo (Intel Iris Xe)
- **`GALLIUM_DRIVER=iris` / `LIBVA_DRIVER_NAME=iHD`:** Forçam o uso dos drivers modernos e rápidos da Intel de código-aberto (Iris) para aceleração de vídeo, entregando eficiência energética.
- **`ANV_ENABLE_PIPELINE_CACHE=1`:** Ativa o cache de shaders nativo do driver Vulkan da Intel (ANV). É o que impede *stutters* (engasgos) em jogos pesados no Steam e Lutris ao entrar num cenário pela segunda vez.
- **`FFMPEG_HW_ACCEL=vaapi`:** Obriga que ferramentas visuais como o OBS Studio e codificadores de vídeo usem a GPU fisicamente, retirando toda a carga pesada do seu processador.

## 2. ⚡ Processamento e Compilação
- **`OMP_NUM_THREADS=8` / `MAKEFLAGS=-j8`:** Destrava todo o potencial de multi-threading do Intel i5-1135G7 garantindo que compilações em C++, Rust, ou empacotamentos de sistema façam uso imediato dos seus 8 threads lógicos em paralelo.
- **`CFLAGS` / `CXXFLAGS` (`-O3 -march=native`):** Configuração de "Bare Metal". Ao compilar qualquer coisa a partir da fonte, o compilador vai olhar especificamente para a arquitetura do seu chip TigerLake e espremer a melhor performance (`O3`).

## 3. 🛡️ Cinto de Segurança de Memória (8GB RAM e ZRAM)
- **`MALLOC_CONF=metadata_thp:always,thp:default`:** Refina como os blocos de alocação de memória do Linux se comportam. Essencial para estabilidade em máquinas com menos de 16GB.
- **Limites Rígidos (`_JAVA_OPTIONS`, `CONTAINER_MAX_MEMORY`):** Sem essas travas de 2GB e 5GB respectivamente, ferramentas famintas do ecossistema Java (Gradle, IDEs) e contêineres do Podman secariam a memória física do seu sistema em segundos, fazendo com que a compressão extrema e *Swap* derrubassem a fluidez do Wayland (OOM Kill).

## 4. 🕹️ Gaming e Ferramentas (DXVK/Proton)
- **`DXVK_STATE_CACHE=1`:** Permite que o Proton e Wine guardem e leiam o estado das APIs de Windows do DirectX (convertidas para Vulkan), gerando inicializações instantâneas de jogos de Windows no seu Pop!_OS.
- **`STEAM_FRAME_FORCE_CLOSE=1`:** Pequeno "hack" que força janelas pop-up inconvenientes da Steam a respeitarem e fecharem corretamente no ambiente Wayland moderno.

## 5. 🎨 Criação de Conteúdo (Kdenlive / OBS)
- **`MLT_MOVIT_HW_RENDER=1`:** A variável mágica do Kdenlive! Ela sinaliza para a engine (MLT) utilizar o Movit via OpenCL. Isso significa que as transições e efeitos dos seus vídeos serão mastigados nativamente pela GPU da Iris Xe e não pelo CPU.
- **`OBS_USE_WAYLAND=1`:** Faz o OBS Studio espelhar e gravar sua tela fluidamente sem depender das antigas emulações limitadas do servidor de display X11.

## 6. 🌐 Navegadores (Firefox, Chromium e Node.js)
- **`MOZ_ENABLE_WAYLAND=1` / `ELECTRON_OZONE_PLATFORM_HINT=auto`:** Asseguram que o seu navegador principal, Edge/Chromium e ferramentas baseadas em Electron (como VSCode e Discord) interajam de forma cristalina no novo protocolo do Wayland, sem cintilações e cravados em 60 FPS com decode de vídeo pela GPU.
