-- 0.15.4 à 0.15.8 provoquent une croissance mémoire rapide sur le projet Bible.
-- Le LSP et la preview partagent le binaire installé par scripts/install_tinymist.sh.
return vim.fs.joinpath(vim.fn.stdpath("data"), "tinymist_0_15_2", "tinymist")
