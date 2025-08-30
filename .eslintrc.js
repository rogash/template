module.exports = {
    root: true,
    env: {
        browser: true,
        es2021: true,
        node: true,
    },
    extends: [
        'eslint:recommended',
        '@vue/eslint-config-typescript',
        '@vue/eslint-config-prettier',
        'plugin:vue/vue3-essential',
    ],
    parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
    },
    plugins: ['vue'],
    rules: {
        'vue/multi-word-component-names': 'off',
        '@typescript-eslint/no-unused-vars': 'error',
        '@typescript-eslint/no-explicit-any': 'warn',
        'prefer-const': 'error',
        'no-var': 'error',
    },
    overrides: [
        {
            files: ['*.vue'],
            rules: {
                'vue/component-name-in-template-casing': ['error', 'PascalCase'],
                'vue/component-definition-name-casing': ['error', 'PascalCase'],
            },
        },
    ],
};
