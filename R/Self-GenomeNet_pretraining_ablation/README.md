For ablation studies, we used the following functions:

1. Forward-single length target: loss_function_forward_singlelength.R, train_Self_GenomeNet_forward_singlelength.R
2. Reverse-single length target: loss_function_reverse_singlelength.R, train_Self_GenomeNet_reverse.R
3. Reverse-complement - single length target: loss_function_reverse_singlelength.R, ../Self-GenomeNet_pretraining/train_Self_GenomeNet.R
4. Forward-varying length target: loss_function_forward_multilength.R, train_Self_GenomeNet_forward_multilength.R
5. Reverse-varying length target: ../Self-GenomeNet_pretraining/loss_function.R, train_Self_GenomeNet_reverse.R
6. Reverse-complement-varying length target: ../Self-GenomeNet_pretraining/loss_function.R, ../Self-GenomeNet_pretraining/train_Self_GenomeNet.R

You can use encoder and decoder functions for virus datasets as in "../Self-GenomeNet_pretraining/".
