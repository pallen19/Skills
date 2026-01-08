---
name: frontend-ui
description: Start the frontend UI for visual verification. Use this when asked to start the frontend, launch the UI, or when the user needs to visually check their changes.
---

To start the frontend UI for visual verification, follow this process:

1. Detect the package manager by checking for lock files:
   - If `pnpm-lock.yaml` exists → use `pnpm`
   - If `yarn.lock` exists → use `yarn`
   - If neither exists → default to `yarn`

2. Install dependencies first (ALWAYS do this before starting):
   ```bash
   # Using yarn
   yarn install

   # Using pnpm
   pnpm install
   ```

3. Start the development server:
   ```bash
   # Using yarn
   yarn start

   # Using pnpm
   pnpm start
   ```

4. Wait for the server to indicate it's ready (look for "Compiled successfully" or similar output)

5. Inform the user of the local URL to check visually (typically http://localhost:3000)

**Notes:**
- Always run the install command first to ensure dependencies are current, especially after pulling new changes
- Some projects may use `yarn dev` or `pnpm dev` instead of `start` - check package.json scripts if start fails
- If the install or start command fails, check for Node.js version requirements in the project
