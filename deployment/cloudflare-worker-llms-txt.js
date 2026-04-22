/**
 * claudeheadlines.com /llms.txt → GitHub raw 프록시
 *
 * 목적:
 *   https://claudeheadlines.com/llms.txt 요청을 GitHub raw 콘텐츠로 투명하게 프록시.
 *   CH 본체(WP)를 건드리지 않고 llms.txt 를 서빙 + 업데이트는 git push 만으로 반영.
 *
 * 배포 방법:
 *   1. Cloudflare 대시보드 → claudeheadlines.com 선택
 *   2. 좌측 메뉴 Workers & Pages → "Create Application" → "Create Worker"
 *   3. 이름: "ch-llms-txt" → Deploy
 *   4. 배포 후 "Edit Code" → 아래 코드 붙여넣기 → Save and Deploy
 *   5. 다시 도메인 대시보드 → Workers Routes → Add Route
 *      - Route: `claudeheadlines.com/llms.txt`
 *      - Worker: `ch-llms-txt`
 *   6. 검증: `curl -I https://claudeheadlines.com/llms.txt` → HTTP 200, content-type text/plain
 *
 * 업데이트 방법:
 *   /tmp/harness-recipes/llms-ch.txt 를 갱신 후 git push main → 자동 반영 (Cloudflare Worker 는 5분 캐시)
 */

const SOURCE_URL =
  'https://raw.githubusercontent.com/haeineeeee/claude-code-harness-recipes/main/llms-ch.txt';

export default {
  async fetch(request, env, ctx) {
    const upstream = await fetch(SOURCE_URL, {
      cf: {
        cacheEverything: true,
        cacheTtl: 300, // 5분
      },
    });

    if (!upstream.ok) {
      return new Response('llms.txt source unavailable', {
        status: 502,
        headers: { 'content-type': 'text/plain; charset=utf-8' },
      });
    }

    const body = await upstream.text();
    return new Response(body, {
      status: 200,
      headers: {
        'content-type': 'text/plain; charset=utf-8',
        'cache-control': 'public, max-age=300, s-maxage=300',
        'x-source': 'github:haeineeeee/claude-code-harness-recipes:llms-ch.txt',
        'access-control-allow-origin': '*',
      },
    });
  },
};
