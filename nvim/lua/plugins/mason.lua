local ok, mason = pcall(require, "mason")
if not ok then
  return
end

mason.setup({
  registries = {
    -- Official
    "github:mason-org/mason-registry",

    -- For roslyn
    "github:Crashdummy/mason-registry",
  },
})
