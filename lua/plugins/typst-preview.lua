return {
  src = "https://github.com/chomosuke/typst-preview.nvim",
  name = "typst-preview",
  opts = {
    -- La preview lance son propre `tinymist preview` sur le fichier qu'on lui
    -- donne, sans passer par le serveur de langage ni par son épinglage. Sans
    -- ce détour, <localleader>p depuis un chapitre prévisualise le chapitre nu.
    get_main_file = function(path)
      return require("typst.project").main(path)
    end,
  },
  config = true,
}
