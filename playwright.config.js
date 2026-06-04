// @ts-check
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,

  reporter: [
    ['html',  { open: 'never' }],                          // Relatório padrão do Playwright
    ['junit', { outputFile: 'results.xml' }],              // XML (opcional, bom para CI)
    ['allure-playwright', { outputFolder: 'allure-results' }] // Dados para o Allure
  ],

  use: {
    baseURL: 'https://pgats-ci-example.netlify.app',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
