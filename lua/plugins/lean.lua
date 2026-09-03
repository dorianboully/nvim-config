-- lean.nvim s'active tout seul à l'ouverture d'un fichier Lean : plus de
-- setup() à appeler. La configuration passe par vim.g.lean_config, posé ici au
-- niveau module — donc avant vim.pack.add, et avant que plugin/ ne soit sourcé.
vim.g.lean_config = { mappings = true }

return {
  src = "https://github.com/Julian/lean.nvim",
  name = "lean",
}
