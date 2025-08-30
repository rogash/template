import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    resolve: {
        alias: {
            '@': '/src',
        },
    },
    server: {
        hmr: {
            host: 'localhost',
        },
    },
    build: {
        // Configuração para template sem assets
        rollupOptions: {
            input: {
                main: './src/main.js'
            }
        }
    }
});
