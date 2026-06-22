#!/bin/bash
# install_blurball_cpu_clean.sh

echo "Instalando BlurBall para CPU (sem NVIDIA)..."

# 1. Limpa cache
pip cache purge

# 2. Desinstala versões anteriores
pip uninstall torch torchvision torchaudio -y

# 3. Instala PyTorch CPU sem dependências
pip install torch==2.5.0 --index-url https://download.pytorch.org/whl/cpu --no-deps --no-cache-dir
pip install torchvision==0.20.0 --index-url https://download.pytorch.org/whl/cpu --no-deps --no-cache-dir
pip install torchaudio==2.5.0 --index-url https://download.pytorch.org/whl/cpu --no-deps --no-cache-dir

# 4. Instala as outras dependências
pip install -r requirements-cpu.txt --break-system-packages

# 5. Verifica
python -c "
import torch
print(f'PyTorch: {torch.__version__}')
print(f'CPU: {torch.cpu.is_available()}')
print(f'CUDA: {torch.cuda.is_available()}')
# Verifica se há pacotes NVIDIA
import subprocess
result = subprocess.run(['pip', 'list'], capture_output=True, text=True)
if 'nvidia' in result.stdout.lower():
    print('⚠️  Pacotes NVIDIA encontrados!')
else:
    print('✅ Sem pacotes NVIDIA')
"
