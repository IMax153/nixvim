# nixvim

- TypeScript uses `tsgo` for all JS/TS projects.
- Project-local `node_modules/.bin/tsgo` overrides the Nix fallback when present, and should provide its own `node` runtime.
