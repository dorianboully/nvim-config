-- `name` est le nom du dossier d'installation, pas celui du module : le dépôt
-- s'appelle copilot.lua mais le module est `copilot`. D'où la fonction config
-- explicite plutôt que `config = true`, qui ferait un require("copilot.lua").
-- Ça évite aussi d'écraser le dossier `copilot` de l'ancien copilot.vim, qui
-- devient inactif et partira au prochain :packdel ++all.
return {
  src = "https://github.com/zbirenbaum/copilot.lua",
  name = "copilot.lua",

  opts = {
    suggestion = {
      auto_trigger = true,

      -- Avec 'autocomplete', le menu est ouvert très souvent. Ces deux réglages
      -- décident du partage de <C-y> :
      --   la suggestion se masque tant que le menu est visible…
      hide_during_completion = true,
      --   …et `accept` ne se déclenche que sur une suggestion réellement
      --   affichée. Sinon (valeur par défaut true) il capterait la touche même
      --   sans suggestion, et <C-y> ne retomberait plus sur l'acceptation
      --   native du menu. Le mapping laisse repasser la touche quand son
      --   gestionnaire renvoie false — voir register_keymap_with_passthrough.
      trigger_on_accept = false,

      -- Les touches de l'ancienne configuration copilot.vim, à l'identique.
      keymap = {
        accept = "<C-y>",
        accept_word = "<C-l>",
        accept_line = "<C-S-l>",
        next = "<C-down>",
        prev = "<C-up>",
        dismiss = "<C-z>",
      },
    },
  },

  config = function(opts)
    require("copilot").setup(opts)
  end,
}
