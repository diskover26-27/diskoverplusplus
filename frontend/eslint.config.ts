import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import pluginVue from 'eslint-plugin-vue';
import skipFormatting from 'eslint-config-prettier';
import globals from 'globals';

export default [
  {
    name: 'app/files-to-lint',
    files: ['**/*.{js,mjs,cjs,jsx,ts,mts,cts,tsx,vue}'],
  },
  {
    name: 'app/files-to-ignore',
    ignores: ['**/dist/**', '**/node_modules/**', 'src/plugins/clamp.min.js'],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  ...pluginVue.configs['flat/recommended'],
  {
    name: 'app/browser-globals',
    files: ['**/*.{js,mjs,cjs,jsx,vue}'],
    languageOptions: {
      globals: {
        ...globals.browser,
        L: 'readonly',
        $clamp: 'readonly',
      },
    },
  },
  {
    name: 'app/rules',
    rules: {
      'vue/multi-word-component-names': 'off',
      'vue/valid-v-slot': ['error', { allowModifiers: true }],
    },
  },
  skipFormatting,
];
