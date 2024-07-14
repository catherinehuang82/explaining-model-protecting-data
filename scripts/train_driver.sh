#!/bin/bash
# create "outputs" folder if it doesn't exist
if [ ! -d "attack_data/outputs" ]; then
    mkdir "attack_data/outputs"
    echo "Created 'outputs' folder."
fi

# create "errors" folder if it doesn't exist
if [ ! -d "attack_data/errors" ]; then
    mkdir "attack_data/errors"
    echo "Created 'errors' folder."
fi

# iterate through the settings
experiment_nos=( {0..32} )

epsilons=(0.5 1.0 2.0 8.0)

epochs=(30)

# other model_types: "vit_small_patch16_224" "vit_base_patch16_224" "vit_relpos_base_patch16_224.sw_in1k" "vit_relpos_small_patch16_224.sw_in1k"
# model_types=("vit_relpos_small_patch16_224.sw_in1k")
model_types=("vit_small_patch16_224")

# train non-DP models
for exp_no in "${experiment_nos[@]}"; do
    for epoch_count in "${epochs[@]}"; do
        for model_type in "${model_types[@]}"; do
            clipping_mode="nonDP"
            eps=0.0
            sbatch train.sh $exp_no $clipping_mode $eps $epoch_count $model_type
            sleep 0.5
#         model_dir="attack_data/model_state_dicts_CIFAR10/model=${model_type}_mode=${clipping_mode}_epochs=${epoch_count}/${exp_no}.pt"
#             echo "Model Directory: $model_dir"
#             if [ -e "$model_dir" ]; then
#                 echo "File exists. Job already ran."
#             else
#                 sbatch --account=hlakkaraju_lab lira_training_cifar10.sh $exp_no $clipping_mode $eps $epoch_count $model_type
#                 sleep 0.5
            fi
        done
    done
done

sleep 0.5

# train models with DP
# experiment_nos=( {0..16} )
# for exp_no in "${experiment_nos[@]}"; do
#     for eps in "${epsilons[@]}"; do
#         for epoch_count in "${epochs[@]}"; do
#             clipping_mode="BK-MixOpt"
#             sbatch train.sh $exp_no $clipping_mode $eps $epoch_count $model_type
#             sleep 0.5
#         done
#     done
# done