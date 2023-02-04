For ablation studies, we used the following functions:

- - Supplementary Results / Experiments: Fixed-Length Targets vs. Varying-Length Targets

1. Testing reverse-complement - single-length target: run_train_RC_singlelength.R
- uses loss_function_singlelength.R, ../pretraining/train.R

- - Supplementary Results / Experiments: Using Reverse-Complement Neighbor Sequences as Targets to Predict

2. Testing forward - varying-length target: run_train_forward_multilength.R:
- uses loss_function_forward_multilength.R, train_Self_GenomeNet_forward_multilength.R

3. Testing reverse - varying-length target: run_train_reverse_multilength.R
- uses ../pretraining/loss_function.R, train_Self_GenomeNet_reverse.R

4. Testing reverse-complement - varying-length target: ../pretraining/train.R
- uses ../pretraining/loss_function.R, ../pretraining/train.R

Please note that the last one is our proposed method: Self-GenomeNet.

All of them also use encoder and decoder functions in datasets in the folder "../pretraining/".
