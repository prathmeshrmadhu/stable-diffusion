#!/bin/bash 
#SBATCH --job-name=stabdiff_CA
#SBATCH --ntasks=1 
#SBATCH --gres=gpu:a100:8
#SBATCH --time=24:00:00
#SBATCH --mail-user=prathmesh.madhu@fau.de --mail-type=FAIL

source ~/.bashrc
conda activate ldm
echo "Job is running on" $(hostname)
nvidia-smi

echo "Images are now being extracted"
mkdir -p ./custom_datafiles/classarch_narrative
# Timing the image's extraction 
SECONDS=0
unzip -q -d ./custom_datafiles/classarch_narrative /home/vault/iwi5/iwi5064h/classarch_narrative.zip
duration=$SECONDS
echo "Images extracted in $(($duration/60)) minutes and $(($duration % 60)) seconds"
echo "Total Files:"
ls -R $TMPDIR | wc -l


python main.py -t --base configs/stable-diffusion/classarch_narrative.yaml --gpus 0,1 --scale_lr False --num_nodes 1 --check_val_every_n_epoch 10 --finetune_from models/ldm/stable-diffusion-v1/model.ckpt