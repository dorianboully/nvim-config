Neovim config, mainly to write mathematics using typst.

## Typst snippets

`snippets/typst/data.json` is the single source of truth. LuaSnip reads it at
runtime; HyperSnips uses the generated `snippets/hsnips/typst.hsnips` file.

```sh
node scripts/generate_typst_snippets.mjs         # regenerate
node scripts/generate_typst_snippets.mjs --check # verify synchronization
```
