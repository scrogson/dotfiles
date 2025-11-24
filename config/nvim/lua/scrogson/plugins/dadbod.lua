-- Basic dadbod configuration
-- K8s integration is in k8s-db.lua
return {
  { 'tpope/vim-dadbod', lazy = true },
  { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
}
