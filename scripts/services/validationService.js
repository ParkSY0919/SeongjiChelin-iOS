/**
 * 식당 검증 서비스
 *
 * 3사 API를 사용하여 식당 정보를 검증합니다.
 */

const kakaoClient = require("../api/kakaoClient");
const naverClient = require("../api/naverClient");
const googleClient = require("../api/googleClient");

/**
 * 모든 식당에 대해 검증 실행
 * @param {Object[]} restaurants - 검증할 식당 목록
 * @returns {Promise<Object[]>} 검증 결과 목록
 */
async function validateAllRestaurants(restaurants) {
  const results = [];

  for (let i = 0; i < restaurants.length; i++) {
    const restaurant = restaurants[i];
    console.log(`[${i + 1}/${restaurants.length}] 검증 중: ${restaurant.name}`);

    try {
      const result = await validateSingleRestaurant(restaurant);
      results.push(result);

      // Rate limiting 방지를 위한 딜레이
      await delay(300);
    } catch (error) {
      console.error(`검증 실패 (${restaurant.name}):`, error.message);
      results.push({
        storeID: restaurant.storeID,
        status: "failed",
        error: error.message,
      });
    }
  }

  return results;
}

/**
 * 단일 식당 검증
 * @param {Object} restaurant - 검증할 식당
 * @returns {Promise<Object>} 검증 결과
 */
async function validateSingleRestaurant(restaurant) {
  // 3사 API 병렬 호출
  const [kakaoResult, naverResult, googleResult] = await Promise.allSettled([
    kakaoClient.validateRestaurant(restaurant),
    naverClient.validateRestaurant(restaurant),
    googleClient.validateRestaurant(restaurant),
  ]);

  const kakao = kakaoResult.status === "fulfilled" ? kakaoResult.value : null;
  const naver = naverResult.status === "fulfilled" ? naverResult.value : null;
  const google = googleResult.status === "fulfilled" ? googleResult.value : null;

  return mergeValidationResults(restaurant, { kakao, naver, google });
}

/**
 * 3사 검증 결과 병합
 * @param {Object} restaurant - 원본 식당 정보
 * @param {Object} results - 각 플랫폼 검증 결과
 * @returns {Object} 병합된 결과
 */
function mergeValidationResults(restaurant, { kakao, naver, google }) {
  const foundCount = [kakao?.found, naver?.found, google?.found].filter(Boolean).length;

  let status = "pending";
  if (foundCount >= 2) {
    status = "verified";
  } else if (foundCount === 1) {
    status = "partial";
  } else {
    status = "failed";
  }

  const externalLinks = {
    kakaoPlaceUrl: kakao?.placeUrl || null,
    kakaoReviewUrl: kakao?.reviewUrl || null,
    naverPlaceUrl: naver?.placeUrl || null,
    naverReviewUrl: naver?.reviewUrl || null,
    googlePlaceUrl: google?.placeUrl || null,
    googleReviewUrl: google?.reviewUrl || null,
  };

  const aggregatedRating = {
    kakaoRating: null,
    kakaoReviewCount: null,
    naverRating: null,
    naverReviewCount: null,
    googleRating: google?.rating || null,
    googleReviewCount: google?.reviewCount || null,
  };

  const verifiedInfo = {
    verifiedAddress: kakao?.verifiedInfo?.address || naver?.verifiedInfo?.address || google?.verifiedInfo?.address || null,
    verifiedNumber: kakao?.verifiedInfo?.phone || naver?.verifiedInfo?.phone || google?.verifiedInfo?.phone || null,
    verifiedBusinessHours: google?.verifiedInfo?.businessHours || null,
  };

  return {
    storeID: restaurant.storeID,
    status: status,
    externalLinks: externalLinks,
    aggregatedRating: aggregatedRating,
    verifiedInfo: verifiedInfo,
  };
}

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports = {
  validateAllRestaurants,
  validateSingleRestaurant,
  mergeValidationResults,
};
