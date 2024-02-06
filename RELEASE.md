Pour faire une release:
- Mettre à jour le CHANGELOG.md
- Modifier le champ `"version": "x.y.z"` dans `schema-dynamique.json` et `schema-statique.json`
- Modifier la version mentionnée dans les liens en `raw.githubusercontent.com` 
- Puis créer une release (voir les précédentes) avec auto-génération
- Vérifier que les checks sont en verts après le merge
- Créer une PR eg https://github.com/etalab/schema.data.gouv.fr/pull/298 pour exclure les versions précédentes de la consolidation
- Sur `schema.data.gouv.fr`, les schémas sont rescannés le matin, la nouvelle version IRVE doit apparaître à l'issue