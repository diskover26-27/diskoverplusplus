# diskover_vue3

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

## Project Setup

```sh
pnpm install
```

### Compile and Hot-Reload for Development

```sh
pnpm run dev
```

### Compile and Minify for Production

```sh
pnpm run build
```

## Reviews demo

The location details panel includes a standalone review submission form.
The frontend uses seeded mock reviews and saves submitted reviews in the browser's
`localStorage` under `diskover-reviews`, so the flow can be demonstrated without
the backend running. The `Review` type and service functions in
`src/services/reviews.ts` are the integration boundary for replacing the local
implementation with an API later. Read-only review display components are not
included in this feature.
