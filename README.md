Neovim config, mainly to write mathematics using typst.

## Version de Tinymist

Le LSP et la prévisualisation utilisent **Tinymist 0.15.2** (Typst embarqué
0.15.0), installé séparément du paquet système. Les versions 0.15.4, 0.15.6
et 0.15.8 reproduisent une saturation mémoire pendant la frappe dans le projet
Bible ; 0.15.2 termine le même essai de quatre minutes avec la coloration
sémantique active.

Sur Arch Linux x86_64, y compris sous WSL, depuis ce dépôt :

```sh
bash scripts/install_tinymist.sh
```

Le script télécharge le paquet Arch archivé, vérifie son SHA-256 et installe
uniquement le binaire dans le répertoire de données Neovim
(`~/.local/share/nvim/tinymist_0_15_2/tinymist` par défaut). Il respecte
`XDG_DATA_HOME` et `NVIM_APPNAME`. Il nécessite `curl`, `tar`, `zstd` et
`sha256sum`, ainsi que les bibliothèques système Arch utilisées par Tinymist.
Un paquet déjà téléchargé peut être passé en argument. Relancer Neovim après
l'installation ; aucun repli vers le Tinymist système n'est prévu.

Le modèle local `mathdoc:0.2.0` doit déclarer `compiler = "0.15.0"` dans son
`typst.toml`. Le programme `typst` autonome peut rester en version 0.15.1.

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
