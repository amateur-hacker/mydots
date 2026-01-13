# Moodifyr — Full Annotated Review

Generated programmatically. Each section has findings, file locations, code snippets, and concrete fixes.

## package.json summary

```json
{
  "name": "moodifyr",
  "version": "0.1.0",
  "scripts": {
    "dev": "next dev --turbopack",
    "build": "next build --turbopack",
    "start": "next start",
    "lint": "biome lint ./src",
    "lint:fix": "bun run lint --fix --unsafe",
    "typecheck": "tsc --noEmit",
    "format": "biome format ./src --write",
    "lint:format": "bun run lint:fix && bun run format",
    "test": "jest",
    "test:watch": "jest --watch",
    "db:generate": "drizzle-kit generate",
    "db:migrate": "./scripts/load-env tsx ./src/db/migrate.ts",
    "db:update": "npm run db:generate && npm run db:migrate",
    "db:seed": "./scripts/load-env tsx ./src/db/seed.ts",
    "db:studio": "./scripts/load-env drizzle-kit studio",
    "vercel:dev": "vercel dev",
    "vercel:deploy": "vercel && vercel --prod"
  }
}
```

## 1) Code review — useEffect and event listeners (possible leaks / improvements)

- Found 54 files with `useEffect`. Key examples:

### File: `src/app/error.tsx` — line ~18

```tsx
reset: () => void;

}) => {

  useEffect(() => {

    console.error(error);

  }, [error]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/theme-switcher.tsx` — line ~13

```tsx
const { theme, setTheme } = useTheme();



  useEffect(() => {

    setMounted(true);

  }, []);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/app-sidebar.tsx` — line ~87

```tsx
};



  useEffect(() => {

    setOrigin(window.location.origin);

  }, []);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/signin-button.tsx` — line ~17

```tsx
const searchParams = useSearchParams();



  useEffect(() => {

    setOrigin(window.location.origin);

  }, []);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-fullscreen-player-view.tsx` — line ~156

```tsx
};



  useEffect(() => {

    setBaseUrl(window.location.origin);

  }, []);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~52

```tsx
const lastAnalyticsIdRef = useRef<string | null>(null);



  useEffect(() => {

    songsRef.current = songs;

  }, [songs]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~56

```tsx
}, [songs]);



  useEffect(() => {

    currentSongRef.current = currentSong;

  }, [currentSong]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~60

```tsx
}, [currentSong]);



  useEffect(() => {

    modeRef.current = mode;

  }, [mode]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~64

```tsx
}, [mode]);



  useEffect(() => {

    isPlayingRef.current = isPlaying;

  }, [isPlaying]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~68

```tsx
}, [isPlaying]);



  useEffect(() => {

    lastActionRef.current = lastAction;

  }, [lastAction]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~72

```tsx
}, [lastAction]);



  useEffect(() => {

    shuffleQueueRef.current = shuffleQueue;

  }, [shuffleQueue]);
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~77

```tsx
// // biome-ignore lint/correctness/useExhaustiveDependencies: <_>

  // useEffect(() => {

  //   if (!playerRef.current) return;

  //

  //   if (!playerRef.current.shuffleQueueRef) {
```

- **Observation:** This effect appears to have a cleanup (`return`). Good — but verify it removes all listeners/resources.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~355

```tsx
// biome-ignore lint/correctness/useExhaustiveDependencies: <_>

  useEffect(() => {

    clearProgressTimer();



    if (playerRef.current && isPlaying) {
```

- **Issue:** No cleanup detected in nearby lines. If this effect registers event listeners, timers, or audio objects, add cleanup to avoid memory leaks.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~414

```tsx
// biome-ignore lint/correctness/useExhaustiveDependencies: <_>

  useEffect(() => {

    if (!playerRef.current || !youtubeId) return;



    setIsLoading(true);
```

- **Observation:** This effect appears to have a cleanup (`return`). Good — but verify it removes all listeners/resources.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).

### File: `src/app/(app)/_components/song-player-engine.tsx` — line ~423

```tsx
// // biome-ignore lint/correctness/useExhaustiveDependencies: <_>

  // useEffect(() => {

  //   if (!playerRef.current || !youtubeId) return;

  //

  //   setIsLoading(true);
```

- **Observation:** This effect appears to have a cleanup (`return`). Good — but verify it removes all listeners/resources.

- **Fix:** Add `return () => { /* remove listeners, pause/stop audio, cancel timers */ }` and ensure dependencies are correct (use stable refs for handlers).


## 2) Player engine audit

- Candidate player-related files discovered:

### `package.json` (line ~49)

```tsx
"@types/react-twemoji": "^0.4.3",

    "@types/twemoji-parser": "^13.1.4",

    "@types/youtube-player": "^5.5.11",

    "@types/yt-search": "^2.10.3",

    "@upstash/redis": "^1.35.3",

    "better-auth": "^1.3.7",
```

- Recommendations:

  1. Use a single source-of-truth for playback state (context or store). Do not keep separate local states across components.

  2. Ensure all event listeners (timeupdate, ended, seeking) are removed in cleanup.

  3. Debounce frequent updates (e.g., timeupdate) before syncing to global state to reduce re-renders.

  4. For shuffle: keep full list of song IDs in memory (not UI-rendered items). Shuffle IDs, then lazily fetch/render metadata.

  5. Use `AudioContext` only when needing low-latency or visualization; otherwise `HTMLAudioElement` is simpler and lighter.

### `src/app/(app)/layout.tsx` (line ~3)

```tsx
import { headers } from "next/headers";

import { AppSidebar } from "@/app/(app)/_components/app-sidebar";

import { GlobalSongPlayer } from "@/app/(app)/_components/global-song-player";

import { Navbar } from "@/app/(app)/_components/navbar";

import { FavouriteProvider } from "@/app/(app)/_context/favourite-context";

import { UserProvider } from "@/app/(app)/_context/user-context";
```

- Recommendations:

  1. Use a single source-of-truth for playback state (context or store). Do not keep separate local states across components.

  2. Ensure all event listeners (timeupdate, ended, seeking) are removed in cleanup.

  3. Debounce frequent updates (e.g., timeupdate) before syncing to global state to reduce re-renders.

  4. For shuffle: keep full list of song IDs in memory (not UI-rendered items). Shuffle IDs, then lazily fetch/render metadata.

  5. Use `AudioContext` only when needing low-latency or visualization; otherwise `HTMLAudioElement` is simpler and lighter.

### `src/app/(app)/_components/global-song-player.tsx` (line ~6)

```tsx
import { SongQueueCleaner } from "@/app/(app)/_components/song-queue-cleaner";

import { SongShuffleQueueManager } from "@/app/(app)/_components/song-shuffle-queue-manager";

import { SongPlayerProvider } from "@/app/(app)/_context/song-player-context";

import { getUserMoodlists } from "@/app/(app)/moodlists/queries";

import {

  getUserFavouriteSongs,
```

- Recommendations:

  1. Use a single source-of-truth for playback state (context or store). Do not keep separate local states across components.

  2. Ensure all event listeners (timeupdate, ended, seeking) are removed in cleanup.

  3. Debounce frequent updates (e.g., timeupdate) before syncing to global state to reduce re-renders.

  4. For shuffle: keep full list of song IDs in memory (not UI-rendered items). Shuffle IDs, then lazily fetch/render metadata.

  5. Use `AudioContext` only when needing low-latency or visualization; otherwise `HTMLAudioElement` is simpler and lighter.

### `src/app/(app)/_components/play-header.tsx` (line ~43)

```tsx
setShuffleQueue,

    setShuffleIndex,

  } = useSongPlayer();



  const handlePlay = (mode: "shuffle" | "normal") => {

    if (!songs?.length) return;
```

- Recommendations:

  1. Use a single source-of-truth for playback state (context or store). Do not keep separate local states across components.

  2. Ensure all event listeners (timeupdate, ended, seeking) are removed in cleanup.

  3. Debounce frequent updates (e.g., timeupdate) before syncing to global state to reduce re-renders.

  4. For shuffle: keep full list of song IDs in memory (not UI-rendered items). Shuffle IDs, then lazily fetch/render metadata.

  5. Use `AudioContext` only when needing low-latency or visualization; otherwise `HTMLAudioElement` is simpler and lighter.

### `src/app/(app)/_components/song-player-engine.tsx` (line ~6)

```tsx
import { isMobile } from "react-device-detect";

import { toast } from "sonner";

import youtubePlayer from "youtube-player";

import { useSongPlayer } from "@/app/(app)/_context/song-player-context";

import type { SongWithUniqueIdSchema } from "@/app/(app)/_types";

import { saveUserPreference } from "@/app/(app)/actions";
```

- Recommendations:

  1. Use a single source-of-truth for playback state (context or store). Do not keep separate local states across components.

  2. Ensure all event listeners (timeupdate, ended, seeking) are removed in cleanup.

  3. Debounce frequent updates (e.g., timeupdate) before syncing to global state to reduce re-renders.

  4. For shuffle: keep full list of song IDs in memory (not UI-rendered items). Shuffle IDs, then lazily fetch/render metadata.

  5. Use `AudioContext` only when needing low-latency or visualization; otherwise `HTMLAudioElement` is simpler and lighter.

### `src/app/(app)/_context/song-player-context.tsx` (line ~4)

```tsx
import { createContext, useContext, useRef, useState } from "react";

import type youtubePlayer from "youtube-player";

import type {

  SongPlayerMode,

  SongWithUniqueIdSchema,
```

- Recommendations:

  1. Use a single source-of-truth for playback state (context or store). Do not keep separate local states across components.

  2. Ensure all event listeners (timeupdate, ended, seeking) are removed in cleanup.

  3. Debounce frequent updates (e.g., timeupdate) before syncing to global state to reduce re-renders.

  4. For shuffle: keep full list of song IDs in memory (not UI-rendered items). Shuffle IDs, then lazily fetch/render metadata.

  5. Use `AudioContext` only when needing low-latency or visualization; otherwise `HTMLAudioElement` is simpler and lighter.


## 3) Performance — bundle size & optimizations

- Identify large imports: search for direct imports of whole libraries (e.g., `import * as _ from 'lodash'` or heavy UI libs).
- Heuristically flagged 2 imports that may increase bundle size.

  - `src/app/(app)/_components/song-player-engine.tsx`:6 — `import youtubePlayer from "youtube-player";`

  - `src/app/(app)/_context/song-player-context.tsx`:4 — `import type youtubePlayer from "youtube-player";`


- Suggestions:

  1. Use dynamic `import()` for non-critical modules (analytics, heavy charts, youtube-player) to defer loading until needed.

  2. Use `next/image` for images (if using Next.js) to enable automatic optimization. Replace `<img>` with `Image` where possible.

  3. Avoid bundling `node_modules`—use package.json properly and let Vercel handle installs. Exclude dev-only deps from production.

  4. Tree-shakeable imports: import specific functions (e.g., `import debounce from 'lodash/debounce'`) instead of full lodash.

  5. For audio: prefer streaming and short buffers; lazy-load audio metadata and artwork.

  6. Use Lighthouse or `next build && next analyze` to get concrete bundle sizes.


## 4) Images & audio lazy-loading

- Found `next/image` usage. Good. Ensure `priority` prop is set only for LCP images; otherwise rely on lazy loading.

- Album art: use low-res blurred placeholder (LQIP) then lazy-load high-res. Use `loading='lazy'` or `next/image`.

- For long lists (history/favorites), only render visible images (virtualize lists). Avoid loading artwork for offscreen items.

- Audio: don't preload all tracks. Use `preload='metadata'` for current/next track only. Use `fetch`/streaming for large files.


## 5) Analytics & privacy (mood computation & data storage)

- Files mentioning 'mood' or 'analytics': 17. Key candidates:

  - `src/app/layout.tsx` — snippet:
```
import type { Metadata, Viewport } from "next";
import {
  Aladin,
  Geist,
  Geist_Mono,
  Lora,
  Mystery_Quest,
  Press_Start_2P,
} from "next/font/google";
import NextTopLoader from "nextjs-toploader";
import { Toaster } from "@/components/ui/sonner";
import "./globals.css";
import { NuqsAdapter } from "nuqs/adapters/next/app";
import { ThemeProvider } from "@/app/(app)/_context/theme-provider
```

  - `src/app/(app)/_components/song-player-engine.tsx` — snippet:
```
"use client";

import { useEffect, useLayoutEffect, useRef } from "react";
import { isMobile } from "react-device-detect";
import { toast } from "sonner";
import youtubePlayer from "youtube-player";
import { useSongPlayer } from "@/app/(app)/_context/song-player-context";
import type { SongWithUniqueIdSchema } from "@/app/(app)/_types";
import { saveUserPreference } from "@/app/(app)/actions";
imp
```

  - `src/app/(app)/dashboard/utils.ts` — snippet:
```
const MOOD_MESSAGES: Record<string, { present: string[]; past: string[] }> = {
  Happy: {
    present: [
      "You’re radiating happiness right now",
      "Feeling good vibes at the moment",
      "Joyful tunes are taking over your mood today",
      "Your smile is almost audible through your playlist",
      "Songs are keeping your spirits sky-high",
      "You’re in full-on happy mode today",

```

  - `src/app/(app)/dashboard/page.tsx` — snippet:
```
import { endOfDay, startOfDay, subDays } from "date-fns";
import { Dashboard } from "@/app/(app)/dashboard/_components/dashboard";
import { getUserAllPreferences, getUserSession } from "@/app/(app)/queries";
import { convertToLocalTZ } from "@/lib/utils";
import { DashboardAnalyticsProvider } from "./_context/dashboard-analytics-context";

export default async function DashboardPage() {
  const se
```

  - `src/app/(app)/dashboard/queries.tsx` — snippet:
```
"use server";

import { and, desc, eq, gte, lte, sql } from "drizzle-orm";
import z from "zod";
import { getMoodMessage } from "@/app/(app)/dashboard/utils";
import { db } from "@/db";
import { songAnalyticsPlayHistory, songs } from "@/db/schema";
import { executeQuery } from "@/db/utils";
import { convertToLocalTZ } from "@/lib/utils";

const getUserSongAnalyticsPlayHistoryByDateRange = async ({

```

  - `src/app/(app)/dashboard/_components/date-range-picker.tsx` — snippet:
```
"use client";

import { type CalendarDate, parseDate } from "@internationalized/date";
import { endOfDay, format, startOfDay } from "date-fns";
import { CalendarIcon } from "lucide-react";
import { use, useEffect, useState } from "react";
import {
  Button,
  DateRangePicker as DateRangePickerRac,
  Dialog,
  Group,
  Popover,
} from "react-aria-components";
import { DashboardAnalyticsContext } fr
```

  - `src/app/(app)/dashboard/_components/date-range-preset-select.tsx` — snippet:
```
"use client";

import {
  endOfDay,
  endOfMonth,
  endOfWeek,
  endOfYear,
  isSameDay,
  startOfDay,
  startOfMonth,
  startOfWeek,
  startOfYear,
  subDays,
} from "date-fns";
import { use, useEffect, useId, useState } from "react";
import { DashboardAnalyticsContext } from "@/app/(app)/dashboard/_context/dashboard-analytics-context";
import { Label } from "@/components/ui/label";
import {
  Se
```

  - `src/app/(app)/dashboard/_components/dashboard.tsx` — snippet:
```
"use client";

import { Pause, Play } from "lucide-react";
import Image from "next/image";
import { use, useEffect, useState } from "react";
import { isMobile, isTablet } from "react-device-detect";
import { useSongPlayer } from "@/app/(app)/_context/song-player-context";
import type { SongSchema } from "@/app/(app)/_types";
import { DateRangePicker } from "@/app/(app)/dashboard/_components/date-r
```

  - `src/app/(app)/dashboard/_context/dashboard-analytics-context.tsx` — snippet:
```
"use client";

import type React from "react";
import { createContext, useState } from "react";
import { saveUserPreference } from "@/app/(app)/actions";

type DashboardAnalyticsContextProps = {
  startDate: Date;
  setStartDate: (date: Date) => void;
  endDate: Date;
  setEndDate: (date: Date) => void;
  isPending: boolean;
  activeSource: "preset" | "picker";
  setActiveSource: (value: "preset" 
```

  - `src/app/(app)/settings/actions.ts` — snippet:
```
"use server";

import { eq } from "drizzle-orm";
import { db } from "@/db";
import {
  favouriteSongs,
  moodlistFollowers,
  moodlistSongs,
  moodlists,
  songAnalyticsPlayHistory,
  songPlayHistory,
  songSearchHistory,
  userPreferences,
  users,
} from "@/db/schema";
import { executeAction } from "@/db/utils";

const resetUserData = async () => {
  const userDataTables = [
    userPreferences,
```

  - `src/app/(app)/search/actions.ts` — snippet:
```
"use server";

import { endOfDay, startOfDay } from "date-fns";
import { and, eq, gte, lte } from "drizzle-orm";
import z from "zod";
import { classifySongCategory } from "@/app/(app)/search/fn";
import { db } from "@/db";
import {
  type SongSchema,
  songAnalyticsPlayHistory,
  songPlayHistory,
  songSchema,
  songs,
} from "@/db/schema/song";
import { executeAction } from "@/db/utils";
import {
```

  - `src/db/schema/index.ts` — snippet:
```
export {
  accounts,
  accountsRelations,
  rolesEnum,
  sessions,
  sessionsRelations,
  users,
  usersRelations,
  verifications,
} from "@/db/schema/auth";

export {
  moodlistFollowers,
  moodlistFollowersRelations,
  moodlistSongs,
  moodlistSongsRelations,
  moodlists,
  moodlistsRelations,
} from "@/db/schema/moodlists";

export {
  favouriteSongs,
  favouriteSongsRelations,
  songAnalytics
```

  - `src/db/schema/auth.ts` — snippet:
```
import { type InferSelectModel, relations } from "drizzle-orm";
import { pgEnum, pgTable } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import type z from "zod";
import {
  favouriteSongs,
  songAnalyticsPlayHistory,
  songPlayHistory,
  songSearchHistory,
} from "./song";

const rolesEnum = pgEnum("role", ["user", "admin"]);

const users = pgTable("users", (t) => 
```

  - `src/db/schema/song.ts` — snippet:
```
import type { InferSelectModel } from "drizzle-orm";
import { relations } from "drizzle-orm";
import { index, pgTable } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import z from "zod";
import { users } from "@/db/schema/auth";

const songs = pgTable("songs", (t) => ({
  id: t.text().primaryKey().notNull(),
  title: t.text().notNull(),
  thumbnail: t.text().notNull
```

  - `src/db/migrations/meta/0000_snapshot.json` — snippet:
```
{
  "id": "23de6761-dbab-4a1e-97f0-5af6e4b07450",
  "prevId": "00000000-0000-0000-0000-000000000000",
  "version": "7",
  "dialect": "postgresql",
  "tables": {
    "public.accounts": {
      "name": "accounts",
      "schema": "",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true
        },
        "account
```

  - `src/db/migrations/meta/0001_snapshot.json` — snippet:
```
{
  "id": "17833e75-c7fa-4784-ad29-50b341528e6a",
  "prevId": "23de6761-dbab-4a1e-97f0-5af6e4b07450",
  "version": "7",
  "dialect": "postgresql",
  "tables": {
    "public.accounts": {
      "name": "accounts",
      "schema": "",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true
        },
        "account
```

  - `src/db/migrations/meta/0002_snapshot.json` — snippet:
```
{
  "id": "4c3c0084-d9a8-443f-b432-a1d0db81ce03",
  "prevId": "17833e75-c7fa-4784-ad29-50b341528e6a",
  "version": "7",
  "dialect": "postgresql",
  "tables": {
    "public.accounts": {
      "name": "accounts",
      "schema": "",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true
        },
        "account
```

Recommendations:

  1. Minimize personal data: store only needed metadata for mood computation (song IDs, timestamps, basic metadata). Avoid storing IPs or raw audio or exact geolocation unless necessary.

  2. Use hashed/opaque user IDs for analytics; if users can opt-out, provide clear privacy toggles and a way to delete their data.

  3. Compute mood server-side or via background jobs to avoid heavy client calculations and to centralize privacy controls.

  4. Retention policy: keep history only for a reasonable period (e.g., 1 year) and expose deletion/export features to users.

  5. If targeting EU users, prepare for GDPR: Data processing records, ability to delete/export data, lawful basis, and a privacy policy page.


## 6) SEO — titles & meta descriptions suggestions per page

- Candidate page files: 81 found. Example pages (first 20):

  - `src/app/not-found.tsx`
  - `src/app/layout.tsx`
  - `src/app/error.tsx`
  - `src/app/api/auth/[...all]/route.ts`
  - `src/app/(app)/fn.ts`
  - `src/app/(app)/actions.ts`
  - `src/app/(app)/queries.ts`
  - `src/app/(app)/utils.ts`
  - `src/app/(app)/page.tsx`
  - `src/app/(app)/layout.tsx`
  - `src/app/(app)/_components/song-card-loader.tsx`
  - `src/app/(app)/_components/share-link-dialog.tsx`
  - `src/app/(app)/_components/theme-switcher.tsx`
  - `src/app/(app)/_components/add-to-moodlist-dialog.tsx`
  - `src/app/(app)/_components/app-sidebar.tsx`
  - `src/app/(app)/_components/global-song-player.tsx`
  - `src/app/(app)/_components/navbar.tsx`
  - `src/app/(app)/_components/play-header.tsx`
  - `src/app/(app)/_components/signin-button.tsx`
  - `src/app/(app)/_components/song-fullscreen-player-view.tsx`

- SEO suggestions (per page):

  - Home: Title: `Moodifyr — Discover & Track Your Musical Moods` Description: `Moodifyr analyzes your listening history to show your mood trends, create moodlists, and save favorites. Try personalized mood analytics.`

  - Search: Title: `Search Songs — Moodifyr` Description: `Search millions of tracks, add to favorites, and build moodlists quickly on Moodifyr.`

  - Player / Now Playing: Title: `Now Playing — <Song Name> — Moodifyr` Description: `Listen to <Song Name> by <Artist> on Moodifyr. Add to moodlists, shuffle, and view your mood history.`

  - Moodlists: Title: `Moodlists — Your Playlists by Mood` Description: `Create and share mood-based playlists. See which songs shaped your moods over time.`

  - History: Title: `Listening History — Moodifyr` Description: `View and analyze your listening history with mood analytics and playback history.`

  - Privacy/Settings: Title: `Privacy Settings — Moodifyr` Description: `Control what Moodifyr stores and how your listening data is used. Export or delete your history.`

  - Use structured data (JSON-LD) for playlists and music objects to help search engines understand content.


## 7) PWA — checks & guide (latest tips)

- No manifest/service-worker found. PWA steps:

  1. Create `manifest.webmanifest` with name, short_name, icons, start_url, display: standalone, background_color, theme_color.

  2. Add `<link rel='manifest' href='/manifest.webmanifest'/>` to your <Head>.

  3. Use Workbox or Next-PWA plugin to generate a service worker with sensible caching strategies (network-first for API, cache-first for static assets).

  4. Support offline start page and runtime caching for album art and player assets. Provide graceful fallback when offline (show offline playlist, disable play).

  5. Use `register()` with `navigator.serviceWorker` and prompt for install using `beforeinstallprompt` to show custom install CTA.

  6. Update service worker cache versioning to force refresh on major updates.

  7. Test with Lighthouse PWA audit and ensure `manifest` and secure HTTPS are configured.
