Neovim config, mainly to write mathematics using typst.

## Typst snippets

`snippets/typst/data.json` is the single source of truth. LuaSnip reads it at
runtime; HyperSnips uses the generated `snippets/hsnips/typst.hsnips` file.

```sh
node scripts/generate_typst_snippets.mjs         # regenerate
node scripts/generate_typst_snippets.mjs --check # verify synchronization
```

## Projets Typst multi-fichiers

Rien ne distingue une entrée d'un chapitre inclus : tous sont des `.typ`. La
config déduit donc le document principal par convention, en remontant depuis le
fichier ouvert jusqu'au premier dossier qui porte :

1. un `main.typ` — c'est le principal ;
2. ou un `typst.toml` — son `entrypoint` est le principal.

Sans rien de tel, le fichier est son propre document. Ce principal est épinglé
auprès de tinymist à chaque entrée dans un buffer, et c'est lui que visent
`<localleader>c` (export), `<localleader>v` (PDF) et `<localleader>p` (preview) :
éditer `chapitres/ch1.typ` compile bien `main.typ`.

Pour une entrée qui ne suit pas la convention, `<localleader>m` impose le fichier
courant comme principal de son projet, et `<localleader>M` revient à la détection.

Le mode `projectResolution = "lockDatabase"` de tinymist vise le même but, mais il
ne relie un chapitre à son document qu'après un export réussi, via une table de
routes stockée dans le cache utilisateur ; tant qu'elle est vide, chaque fichier
redevient son propre document, et un export lancé depuis un chapitre y écrase la
route du projet. La convention est retenue à sa place.
