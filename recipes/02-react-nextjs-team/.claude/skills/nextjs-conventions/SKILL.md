---
name: nextjs-conventions
description: Next.js 13+ App Router 프로젝트에서 컴포넌트·라우팅·데이터 페칭·성능 규약을 일관되게 적용하도록 가이드
trigger:
  - "Next.js"
  - "Next"
  - "app router"
  - "서버 컴포넌트"
  - "server component"
  - "client component"
  - "use client"
  - "route handler"
  - "app/"
---

# Next.js App Router 작성 규약

## 컴포넌트 분류

- **기본은 서버 컴포넌트.** `"use client"` 지시어는 필요할 때만 **최상위**에 1줄로 명시
- Client 전환이 필요한 경우: 이벤트 핸들러, `useState`/`useEffect`, 브라우저 전용 API(`window`, `localStorage`)
- 서버 컴포넌트에서만 `async/await` 허용. Client 컴포넌트는 Suspense/Promise 사용
- 폼은 가능하면 Server Actions로 (`"use server"`)

## 파일 구조

```
app/
├── layout.tsx        — 루트 레이아웃
├── page.tsx          — / 루트 페이지
├── loading.tsx       — 로딩 상태 (Suspense fallback)
├── error.tsx         — 에러 경계 (Client component 필수)
├── not-found.tsx
├── (group)/          — 라우트 그룹 (URL에 미반영)
└── api/*/route.ts    — Route Handlers

components/           — 재사용 UI, 도메인별 하위 디렉토리
lib/                  — 순수 함수·스키마·유틸
server/               — server-only (DB, 외부 API, secrets)
```

- 경로 alias는 `@/` 로 통일 (tsconfig `paths`)
- `server/` 모듈은 `"server-only"` 패키지 import로 보호

## 데이터 페칭

- 서버 컴포넌트에서 `fetch` 직접 호출. `{ next: { revalidate: N } }` 로 ISR 제어
- 전역 캐시 정책 통일을 위해 `lib/fetch.ts` 래퍼 구축 권장
- Dynamic 페이지는 `export const dynamic = 'force-dynamic'` 명시
- Static은 `export const revalidate = 3600` (또는 원하는 초)

## 상태 관리

- 전역 상태 최소화. URL 쿼리 파라미터 + Server Actions + React `useFormState` 조합 선호
- 필요 시 Zustand (가벼움) 또는 Jotai (원자형)
- Redux는 신규 프로젝트에서 지양

## 성능

- 이미지: `next/image` — `sizes`, `priority` 속성 활용
- 폰트: `next/font/local`, `next/font/google` — CLS 방지
- 코드 분할: `next/dynamic` + `{ ssr: false }` (Client 전용 컴포넌트)
- 번들 분석: `@next/bundle-analyzer` 로 주기 체크

## 린트·포맷·타입

- `eslint-config-next` + Prettier + TypeScript strict 조합
- 커밋 전 `.claude/hooks/pre-commit-check.sh` 가 자동 검증
- `any` 금지 — 필요하면 `unknown` 후 타입 가드

## 금지 항목

- Page Router (`pages/*`) 혼용 (신규는 App Router만)
- `getServerSideProps`, `getStaticProps` (App Router에서는 fetch 옵션으로 대체)
- 서버 컴포넌트에서 브라우저 API 접근
- Client 컴포넌트에서 비밀 값·env 접근 (`NEXT_PUBLIC_` 외는 모두 서버 전용)
