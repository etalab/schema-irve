Pour faire une release:
- Mettre à jour le CHANGELOG.md
- Modifier le champ `"version": "vx.y.z"` et `"lastModified"` dans les trois schémas (`statique`, `dynamique`, `tarifs`)
- Modifier la version mentionnée dans les liens en `raw.githubusercontent.com`
- Régénérer les annexes (`elixir docs/generer_annexes.exs`)
- Commiter, créer le tag `vx.y.z` sur ce commit, puis pousser (les checks de liens ont besoin du tag)
- Puis créer une release (voir les précédentes) avec auto-génération
- Vérifier que les checks sont en verts après le merge
- Créer une PR eg https://github.com/etalab/schema.data.gouv.fr/pull/298 pour exclure les versions précédentes de la consolidation
- Sur `schema.data.gouv.fr`, les schémas sont rescannés le matin, la nouvelle version IRVE doit apparaître à l'issue
