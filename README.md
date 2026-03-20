# nixvim

- Set `typescript.backend = "typescript-tools"` or `"tsgo"` to switch TS backends.
- `typescript-tools` is the default backend.
- When `tsgo` is enabled, project-local `node_modules/.bin/tsgo` overrides the Nix fallback and should provide its own `node` runtime.
