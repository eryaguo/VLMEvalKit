#!/bin/bash 
#SBATCH --job-name=vlm-evaluation
#SBATCH --container-writable
#SBATCH --environment=my_eval_env
#SBATCH --time=02:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=288
#SBATCH --exclude=nid0020[26,38]

# Add huggingface token
mkdir -p ~/.cache/huggingface
echo "ADD_YOUR_TOKEN_HERE" > ~/.cache/huggingface/token

# Navigate to the directory where the evaluation code is located
cd VLMEvalKit

# Install necessary dependencies
pip install --upgrade setuptools==69.5.0
pip install .

# Run the VLM evaluation with VLMEvalKit
torchrun --nproc-per-node=8 run.py \
  --data MMStar MMMU_TEST MathVista_MINI AI2D_TEST ChartQA_TEST DocVQA_TEST \
  --model idefics2_8b \
  --verbose

# Summarize the results
python summarize_results.py idefics2_8b