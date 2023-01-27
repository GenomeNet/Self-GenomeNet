For ablation studies, we used the following functions:

1. Reverse-complement - single length target: loss_function_reverse_singlelength.R, ../Self-GenomeNet_pretraining/train_Self_GenomeNet.R
2. Forward-varying length target: loss_function_forward_multilength.R, train_Self_GenomeNet_forward_multilength.R
3. Reverse-varying length target: ../Self-GenomeNet_pretraining/loss_function.R, train_Self_GenomeNet_reverse.R
4. Reverse-complement-varying length target: ../Self-GenomeNet_pretraining/loss_function.R, ../Self-GenomeNet_pretraining/train_Self_GenomeNet.R

Please note that the last one is our proposed method: Self-GenomeNet.

You can use encoder and decoder functions in datasets as in "../Self-GenomeNet_pretraining/".
