/**
 * 식당 검증 메인 스크립트
 *
 * 초기 데이터를 읽어 3사 API로 검증하고 결과 JSON을 생성합니다.
 * GitHub Actions에서 매일 00시 (KST)에 실행됩니다.
 */

const fs = require("fs");
const path = require("path");
const { validateAllRestaurants } = require("./services/validationService");

const DATA_FILE = path.join(__dirname, "data", "initial_restaurants.json");
const OUTPUT_DIR = path.join(__dirname, "output");
const OUTPUT_FILE = path.join(OUTPUT_DIR, "restaurants_latest.json");

async function main() {
  console.log("========================================");
  console.log("SeongjiChelin 식당 검증 시작");
  console.log(`시작 시간: ${new Date().toISOString()}`);
  console.log("========================================\n");

  // 1. 초기 데이터 로드
  if (!fs.existsSync(DATA_FILE)) {
    console.error(`데이터 파일을 찾을 수 없습니다: ${DATA_FILE}`);
    process.exit(1);
  }

  const initialData = JSON.parse(fs.readFileSync(DATA_FILE, "utf8"));
  console.log(`로드된 테마 수: ${initialData.themes.length}`);

  // 2. 모든 식당 추출
  const allRestaurants = [];
  for (const theme of initialData.themes) {
    for (const restaurant of theme.restaurants) {
      allRestaurants.push({
        ...restaurant,
        themeType: theme.themeType,
      });
    }
  }
  console.log(`총 식당 수: ${allRestaurants.length}\n`);

  // 3. 검증 실행
  console.log("검증 시작...\n");
  const validationResults = await validateAllRestaurants(allRestaurants);

  // 4. 결과 병합
  const resultMap = new Map();
  for (const result of validationResults) {
    resultMap.set(result.storeID, result);
  }

  // 5. 최종 JSON 생성
  const version = generateVersion();
  const outputData = {
    version: version,
    lastUpdated: new Date().toISOString(),
    themes: initialData.themes.map((theme) => ({
      themeType: theme.themeType,
      displayName: theme.displayName,
      restaurants: theme.restaurants.map((restaurant) => {
        const validation = resultMap.get(restaurant.storeID);
        return {
          ...restaurant,
          externalLinks: validation?.externalLinks || null,
          aggregatedRating: validation?.aggregatedRating || null,
          lastVerified: new Date().toISOString(),
          verificationStatus: validation?.status || "pending",
        };
      }),
    })),
  };

  // 6. 결과 저장
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(outputData, null, 2), "utf8");

  // 7. 요약 출력
  const stats = {
    total: validationResults.length,
    verified: validationResults.filter((r) => r.status === "verified").length,
    partial: validationResults.filter((r) => r.status === "partial").length,
    failed: validationResults.filter((r) => r.status === "failed").length,
  };

  console.log("\n========================================");
  console.log("검증 완료");
  console.log(`버전: ${version}`);
  console.log(`결과 파일: ${OUTPUT_FILE}`);
  console.log("----------------------------------------");
  console.log(`총 식당: ${stats.total}`);
  console.log(`검증 완료 (2개 이상 API): ${stats.verified}`);
  console.log(`부분 검증 (1개 API): ${stats.partial}`);
  console.log(`검증 실패: ${stats.failed}`);
  console.log("========================================");

  // 검증 리포트 저장
  const reportFile = path.join(OUTPUT_DIR, "validation_report.json");
  fs.writeFileSync(
    reportFile,
    JSON.stringify(
      {
        timestamp: new Date().toISOString(),
        version: version,
        stats: stats,
        details: validationResults,
      },
      null,
      2
    ),
    "utf8"
  );
  console.log(`리포트 저장: ${reportFile}`);
}

/**
 * 버전 번호 생성 (YYYYMMDD.N 형식)
 */
function generateVersion() {
  const now = new Date();
  const dateStr = now.toISOString().slice(0, 10).replace(/-/g, "");
  return `${dateStr}.1`;
}

main().catch((error) => {
  console.error("검증 실패:", error);
  process.exit(1);
});
