#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <caminho-do-video>"
  exit 1
fi

VIDEO_PATH="$1"

if [[ ! -f "$VIDEO_PATH" ]]; then
  echo "Erro: arquivo de video nao encontrado: $VIDEO_PATH"
  exit 1
fi

# Inicializa o shell do conda no script para permitir `conda activate`.
CONDA_BASE="$(conda info --base 2>/dev/null || true)"
if [[ -z "$CONDA_BASE" || ! -f "$CONDA_BASE/etc/profile.d/conda.sh" ]]; then
  echo "Erro: nao foi possivel localizar a instalacao do conda."
  exit 1
fi
source "$CONDA_BASE/etc/profile.d/conda.sh"

conda activate blurball

start_time=$(date +%s)

python src/main.py \
  --config-name=inference_blurball \
  detector.model_path=blurball_models/blurball_best \
  "+input_vid=$VIDEO_PATH"

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "Tempo total de execucao: ${elapsed_time}s"
