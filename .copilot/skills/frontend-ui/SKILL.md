# frontend-ui

Start up the frontend UI for visual verification and testing.

## Description

This skill knows how to start the frontend UI application so users can visually verify changes. Before starting the dev server, it ensures dependencies are installed by running the appropriate package manager install command first.

## Usage

- ALWAYS run `yarn install` or `pnpm install` before starting the dev server to ensure dependencies are up to date.
- Check which package manager is used by looking for `yarn.lock` (yarn) or `pnpm-lock.yaml` (pnpm).
- Start the dev server with `yarn start` or `pnpm start` depending on the package manager.
- If neither lock file exists, prefer yarn as the default.
- Wait for the dev server to be ready before prompting the user to check visually.
- Provide the local URL (typically http://localhost:3000) for the user to access.

## Package Manager Detection

1. If `pnpm-lock.yaml` exists → use `pnpm`
2. If `yarn.lock` exists → use `yarn`
3. If neither exists → default to `yarn`

## Steps

1. Detect the package manager by checking for lock files
2. Run `yarn install` or `pnpm install` to ensure dependencies are installed
3. Run `yarn start` or `pnpm start` to start the dev server
4. Wait for the server to indicate it's ready (look for "Compiled successfully" or similar)
5. Inform the user of the local URL to check visually

## Commands

**Using Yarn:**
```bash
# Install dependencies
yarn install

# Start dev server
yarn start
```

**Using pnpm:**
```bash
# Install dependencies
pnpm install

# Start dev server
pnpm start
```

## Examples

**Start the frontend so I can check my changes:**
First run `yarn install` (or `pnpm install` if pnpm-lock.yaml exists), then run `yarn start` (or `pnpm start`). Once the server is ready, inform the user to open http://localhost:3000 to visually verify their changes.

**I need to see the UI:**
Detect package manager, run install command, start the dev server, and provide the URL for visual verification.

**Launch the frontend for testing:**
Ensure dependencies are installed with `yarn install` or `pnpm install`, then start with `yarn start` or `pnpm start`.

## Notes

- Always run the install command first to ensure dependencies are current, especially after pulling new changes.
- The dev server typically runs on port 3000, but check the output for the actual URL.
- If the install or start command fails, check for Node.js version requirements in the project.
- Some projects may use `yarn dev` or `pnpm dev` instead of `start` - check package.json scripts if start fails.
