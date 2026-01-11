/**
 * Wiki 마크다운 리포트 생성 스크립트
 *
 * validation_report.json을 읽어 Wiki용 마크다운 리포트를 생성합니다.
 */

const fs = require("fs");
const path = require("path");

const REPORT_FILE = path.join(__dirname, "output", "validation_report.json");
const DATA_FILE = path.join(__dirname, "data", "initial_restaurants.json");
const OUTPUT_FILE = path.join(__dirname, "output", "Validation-Report.md");

function main() {
  // 1. 데이터 로드
  if (!fs.existsSync(REPORT_FILE)) {
    console.error(`리포트 파일을 찾을 수 없습니다: ${REPORT_FILE}`);
    process.exit(1);
  }

  const report = JSON.parse(fs.readFileSync(REPORT_FILE, "utf8"));
  const initialData = JSON.parse(fs.readFileSync(DATA_FILE, "utf8"));

  // 식당 이름 맵 생성
  const restaurantMap = new Map();
  for (const theme of initialData.themes) {
    for (const restaurant of theme.restaurants) {
      restaurantMap.set(restaurant.storeID, {
        name: restaurant.name,
        address: restaurant.address,
        themeType: theme.themeType,
        themeName: theme.displayName,
      });
    }
  }

  // 2. 마크다운 생성
  const md = generateMarkdown(report, restaurantMap);

  // 3. 파일 저장
  fs.writeFileSync(OUTPUT_FILE, md, "utf8");
  console.log(`Wiki 리포트 생성 완료: ${OUTPUT_FILE}`);
}

/**
 * 마크다운 리포트 생성
 */
function generateMarkdown(report, restaurantMap) {
  const { timestamp, version, stats, details } = report;
  const date = new Date(timestamp);
  const kstDate = new Date(date.getTime() + 9 * 60 * 60 * 1000);
  const dateStr = kstDate.toISOString().replace("T", " ").slice(0, 19) + " KST";

  // 플랫폼별 통계 계산
  const platformStats = calculatePlatformStats(details);

  // 실패 케이스 분류
  const failureCases = analyzeFailures(details, restaurantMap);

  let md = "";

  // 헤더
  md += `# 식당 데이터 검증 리포트\n\n`;
  md += `> **생성일**: ${dateStr}  \n`;
  md += `> **버전**: ${version}\n\n`;

  // 요약 섹션
  md += `## 📊 검증 요약\n\n`;
  md += `| 구분 | 결과 |\n`;
  md += `|------|------|\n`;
  md += `| 총 식당 수 | ${stats.total}개 |\n`;
  md += `| ✅ 완전 검증 (2개 이상 API) | ${stats.verified}개 (${percentage(stats.verified, stats.total)}) |\n`;
  md += `| ⚠️ 부분 검증 (1개 API) | ${stats.partial}개 (${percentage(stats.partial, stats.total)}) |\n`;
  md += `| ❌ 검증 실패 | ${stats.failed}개 (${percentage(stats.failed, stats.total)}) |\n\n`;

  // 플랫폼별 통계
  md += `## 🔍 플랫폼별 검색 결과\n\n`;
  md += `| 플랫폼 | 성공 | 실패 | 성공률 |\n`;
  md += `|--------|------|------|--------|\n`;
  md += `| Google | ${platformStats.google.success} | ${platformStats.google.fail} | ${percentage(platformStats.google.success, stats.total)} |\n`;
  md += `| Kakao | ${platformStats.kakao.success} | ${platformStats.kakao.fail} | ${percentage(platformStats.kakao.success, stats.total)} |\n`;
  md += `| Naver | ${platformStats.naver.success} | ${platformStats.naver.fail} | ${percentage(platformStats.naver.success, stats.total)} |\n\n`;

  // 검색 실패 케이스 상세
  if (failureCases.length > 0) {
    md += `## ⚠️ 검색 실패 케이스 분석\n\n`;
    md += `다음 식당들은 일부 또는 전체 플랫폼에서 검색에 실패했습니다.\n\n`;

    for (const failure of failureCases) {
      md += `### ${failure.name}\n\n`;
      md += `- **주소**: ${failure.address}\n`;
      md += `- **테마**: ${failure.themeName}\n`;
      md += `- **검색 결과**:\n`;

      for (const platform of ["google", "kakao", "naver"]) {
        const status = failure.platforms[platform] ? "✅ 성공" : "❌ 실패";
        md += `  - ${platform.charAt(0).toUpperCase() + platform.slice(1)}: ${status}\n`;
      }

      if (failure.possibleCause) {
        md += `- **예상 원인**: ${failure.possibleCause}\n`;
      }

      md += `\n`;
    }
  }

  // 검색 로직 설명
  md += `## 📝 검색 로직 상세\n\n`;
  md += `### Google Places API\n`;
  md += `1. Text Search: \`{이름} {주소}\`\n`;
  md += `2. 결과에서 이름 유사도 비교 후 최적 매칭\n`;
  md += `3. Place Details API로 상세 정보 조회\n\n`;

  md += `### Kakao Local API\n`;
  md += `1. 1차 검색: \`{이름} {구/동}\`\n`;
  md += `2. 2차 검색 (실패 시): \`{이름}\`만\n`;
  md += `3. 정규화된 이름으로 최적 매칭\n\n`;

  md += `### Naver Local API\n`;
  md += `1. 1차 검색: \`{이름} {구/동}\`\n`;
  md += `2. 2차 검색 (실패 시): \`{이름}\`만\n`;
  md += `3. 정규화된 이름으로 최적 매칭\n`;
  md += `4. 네이버 지도 URL 생성 (외부 링크 제외)\n\n`;

  // 전체 검증 결과 테이블
  md += `## 📋 전체 검증 결과\n\n`;
  md += `<details>\n`;
  md += `<summary>클릭하여 전체 결과 보기</summary>\n\n`;
  md += `| 식당명 | 테마 | 상태 | Google | Kakao | Naver |\n`;
  md += `|--------|------|------|--------|-------|-------|\n`;

  for (const detail of details) {
    const info = restaurantMap.get(detail.storeID) || { name: detail.storeID, themeName: "-" };
    const statusEmoji = detail.status === "verified" ? "✅" : detail.status === "partial" ? "⚠️" : "❌";

    const hasGoogle = detail.externalLinks?.googlePlaceUrl ? "✅" : "❌";
    const hasKakao = detail.externalLinks?.kakaoPlaceUrl ? "✅" : "❌";
    const hasNaver = detail.externalLinks?.naverPlaceUrl ? "✅" : "❌";

    md += `| ${info.name} | ${info.themeName} | ${statusEmoji} | ${hasGoogle} | ${hasKakao} | ${hasNaver} |\n`;
  }

  md += `\n</details>\n\n`;

  // 푸터
  md += `---\n`;
  md += `*이 리포트는 GitHub Actions에 의해 자동 생성되었습니다.*\n`;

  return md;
}

/**
 * 플랫폼별 통계 계산
 */
function calculatePlatformStats(details) {
  const stats = {
    google: { success: 0, fail: 0 },
    kakao: { success: 0, fail: 0 },
    naver: { success: 0, fail: 0 },
  };

  for (const detail of details) {
    if (detail.externalLinks?.googlePlaceUrl) {
      stats.google.success++;
    } else {
      stats.google.fail++;
    }

    if (detail.externalLinks?.kakaoPlaceUrl) {
      stats.kakao.success++;
    } else {
      stats.kakao.fail++;
    }

    if (detail.externalLinks?.naverPlaceUrl) {
      stats.naver.success++;
    } else {
      stats.naver.fail++;
    }
  }

  return stats;
}

/**
 * 실패 케이스 분석
 */
function analyzeFailures(details, restaurantMap) {
  const failures = [];

  for (const detail of details) {
    const hasGoogle = !!detail.externalLinks?.googlePlaceUrl;
    const hasKakao = !!detail.externalLinks?.kakaoPlaceUrl;
    const hasNaver = !!detail.externalLinks?.naverPlaceUrl;

    // 하나라도 실패한 경우
    if (!hasGoogle || !hasKakao || !hasNaver) {
      const info = restaurantMap.get(detail.storeID) || {};

      let possibleCause = null;

      // 실패 원인 추정
      if (!hasNaver && hasKakao && hasGoogle) {
        possibleCause = "네이버 검색어 매칭 실패 (지역명 또는 상호명 차이)";
      } else if (!hasGoogle && hasKakao && hasNaver) {
        possibleCause = "Google Places 등록 정보 없음 또는 영문명 차이";
      } else if (!hasKakao && hasGoogle && hasNaver) {
        possibleCause = "카카오맵 등록 정보 없음";
      } else if (!hasGoogle && !hasKakao && !hasNaver) {
        possibleCause = "모든 플랫폼에서 검색 실패 - 폐업 또는 상호명 변경 가능성";
      }

      failures.push({
        storeID: detail.storeID,
        name: info.name || detail.storeID,
        address: info.address || "-",
        themeName: info.themeName || "-",
        platforms: {
          google: hasGoogle,
          kakao: hasKakao,
          naver: hasNaver,
        },
        possibleCause: possibleCause,
      });
    }
  }

  return failures;
}

/**
 * 퍼센트 계산
 */
function percentage(value, total) {
  if (total === 0) return "0%";
  return `${Math.round((value / total) * 100)}%`;
}

main();
