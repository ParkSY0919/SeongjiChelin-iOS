/**
 * Naver Search API 클라이언트
 *
 * 네이버 지역 검색 API를 사용하여 식당 정보를 조회합니다.
 * https://developers.naver.com/docs/serviceapi/search/local/local.md
 */

const axios = require("axios");
const config = require("../config");
const { extractDistrict, normalizeName } = require("./utils");

/**
 * 지역 검색
 * @param {string} query - 검색 키워드
 * @returns {Promise<Object[]|null>} 검색 결과 배열
 */
async function searchLocal(query) {
  if (!config.naver.clientId || !config.naver.clientSecret) {
    console.warn("[Naver] API 키가 설정되지 않았습니다.");
    return null;
  }

  try {
    const response = await axios.get(`${config.naver.baseUrl}/v1/search/local.json`, {
      headers: {
        "X-Naver-Client-Id": config.naver.clientId,
        "X-Naver-Client-Secret": config.naver.clientSecret,
      },
      params: {
        query: query,
        display: 5, // 여러 결과 중 최적 선택을 위해 증가
      },
    });

    const items = response.data.items;
    if (!items || items.length === 0) {
      return null;
    }

    return items.map((item) => ({
      title: item.title.replace(/<[^>]*>/g, ""), // HTML 태그 제거
      link: item.link,
      category: item.category,
      description: item.description,
      telephone: item.telephone || null,
      address: item.address,
      roadAddress: item.roadAddress,
      mapx: item.mapx,
      mapy: item.mapy,
    }));
  } catch (error) {
    console.error(`[Naver] 검색 오류 (${query}):`, error.message);
    return null;
  }
}

/**
 * 검색 결과 중 가장 적합한 항목 선택
 * @param {Object[]} results - 검색 결과 배열
 * @param {string} restaurantName - 원본 식당 이름
 * @returns {Object|null} 가장 적합한 결과
 */
function findBestMatch(results, restaurantName) {
  if (!results || results.length === 0) return null;

  const normalizedTarget = normalizeName(restaurantName);

  // 이름이 정확히 일치하거나 포함된 결과 우선
  const exactMatch = results.find((r) => {
    const normalizedResult = normalizeName(r.title);
    return normalizedResult === normalizedTarget || normalizedResult.includes(normalizedTarget) || normalizedTarget.includes(normalizedResult);
  });

  return exactMatch || results[0];
}

/**
 * 네이버 지도 URL인지 확인
 * @param {string} url - 검사할 URL
 * @returns {boolean}
 */
function isNaverMapUrl(url) {
  if (!url) return false;
  return url.includes("map.naver.com") || url.includes("naver.me") || url.includes("place.naver.com");
}

/**
 * 네이버 지도 검색 URL 생성
 * @param {string} name - 식당 이름
 * @param {string} district - 구/동 정보 (선택)
 * @returns {string} 네이버 지도 검색 URL
 */
function createNaverMapSearchUrl(name, district = "") {
  const query = district ? `${name} ${district}` : name;
  return `https://map.naver.com/v5/search/${encodeURIComponent(query)}`;
}

/**
 * 식당 정보 검증
 * @param {Object} restaurant - 검증할 식당 정보
 * @returns {Promise<Object>} 검증 결과
 */
async function validateRestaurant(restaurant) {
  let result = null;
  const district = extractDistrict(restaurant.address);

  // 1차 시도: 이름 + 구/동 정보
  if (district) {
    const results = await searchLocal(`${restaurant.name} ${district}`);
    result = findBestMatch(results, restaurant.name);
  }

  // 2차 시도: 이름만
  if (!result) {
    const results = await searchLocal(restaurant.name);
    result = findBestMatch(results, restaurant.name);
  }

  if (!result) {
    return {
      platform: "naver",
      found: false,
      placeUrl: null,
      reviewUrl: null,
      verifiedInfo: null,
    };
  }

  // 네이버 지도 URL 생성 (외부 링크 무시)
  const searchUrl = createNaverMapSearchUrl(restaurant.name, district);

  // result.link가 네이버 지도 URL인 경우에만 사용, 아니면 검색 URL 사용
  const placeUrl = isNaverMapUrl(result.link) ? result.link : searchUrl;

  return {
    platform: "naver",
    found: true,
    placeUrl: placeUrl,
    reviewUrl: searchUrl, // 리뷰 URL은 항상 검색 URL 사용
    externalLink: !isNaverMapUrl(result.link) ? result.link : null, // 외부 링크 별도 저장
    verifiedInfo: {
      address: result.roadAddress || result.address,
      phone: result.telephone,
    },
  };
}

module.exports = {
  searchLocal,
  validateRestaurant,
};
