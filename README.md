# nixvim

- TypeScript uses Effect's `tsgo` for all JS/TS projects.
- Effect repos should add `compilerOptions.plugins = [{ "name": "@effect/language-service" }]` to `tsconfig.json` to enable the embedded Effect language service.
