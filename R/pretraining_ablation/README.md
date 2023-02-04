You can run the code used for the ablation analysis as below:

1. Supplementary Results / Experiments: Fixed-Length Targets vs. Varying-Length Targets

```
Rscript R/pretraining_ablation/run_train_RC_singlelength.R 
```

2. Supplementary Results / Experiments: Using Reverse-Complement Neighbor Sequences as Targets to Predict

- Forward:

```
Rscript R/pretraining_ablation/run_train_forward_multilength.R
```

- Reverse
 
```
Rscript R/pretraining_ablation/run_train_reverse_multilength.R
```

- Reverse-complement:
 
```
Rscript R/pretraining/train.R
```

Please note that the last one is our proposed method: Self-GenomeNet.
