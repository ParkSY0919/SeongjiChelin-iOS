/**
 * Kakao Local API 클라이언트
 *
 * 카카오맵 장소 검색 API를 사용하여 식당 정보를 조회합니다.
 * https://developers.kakao.com/docs/latest/ko/local/dev-guide
 */

const axios = require("axios");
const config = require("../config");
const { extractDistrict, normalizeName } = require("./utils");

/**
 * 키워드로 장소 검색
 * @param {string} query - 검색 키워드
 * @param {Object} options - 검색 옵션
 * @param {number} options.x - 경도 (longitude)
 * @param {number} options.y - 위도 (latitude)
 * @param {number} options.radius - 검색 반경 (미터, 최대 20000)
 * @param {string} options.sort - 정렬 기준 (distance 또는 accuracy)
 * @returns {Promise<Object[]|null>} 검색 결과 배열
 */
async function searchPlace(query, options = {}) {
  if (!config.kakao.apiKey) {
    console.warn("[Kakao] API 키가 설정되지 않았습니다.");
    return null;
  }

  try {
    const params = {
      query: query,
      size: 5, // 여러 결과 중 최적 선택을 위해 증가
    };

    // 좌표 기반 검색 옵션 추가
    if (options.x && options.y) {
      params.x = options.x;
      params.y = options.y;
      if (options.radius) {
        params.radius = options.radius;
      }
      params.sort = options.sort || "distance";
    }

    const response = await axios.get(`${config.kakao.baseUrl}/v2/local/search/keyword.json`, {
      headers: {
        Authorization: `KakaoAK ${config.kakao.apiKey}`,
      },
      params: params,
    });

    const documents = response.data.documents;
    if (!documents || documents.length === 0) {
      return null;
    }

    return documents.map((place) => ({
      id: place.id,
      placeName: place.place_name,
      addressName: place.address_name,
      roadAddressName: place.road_address_name,
      phone: place.phone || null,
      placeUrl: place.place_url,
      categoryName: place.category_name,
      x: place.x,
      y: place.y,
    }));
  } catch (error) {
    console.error(`[Kakao] 검색 오류 (${query}):`, error.message);
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
    const normalizedResult = normalizeName(r.placeName);
    return normalizedResult === normalizedTarget || normalizedResult.includes(normalizedTarget) || normalizedTarget.includes(normalizedResult);
  });

  return exactMatch || results[0];
}

/**
 * 식당 정보 검증
 * @param {Object} restaurant - 검증할 식당 정보
 * @returns {Promise<Object>} 검증 결과
 */
async function validateRestaurant(restaurant) {
  let result = null;

  // 1차 시도: 이름만 + 좌표 500m 반경
  if (restaurant.longitude && restaurant.latitude) {
    const results = await searchPlace(restaurant.name, {
      x: restaurant.longitude,
      y: restaurant.latitude,
      radius: 500,
      sort: "distance",
    });
    result = findBestMatch(results, restaurant.name);
  }

  // 2차 시도: 이름 + 구/동 정보 + 좌표 2km 반경
  if (!result) {
    const district = extractDistrict(restaurant.address);
    const query = district ? `${restaurant.name} ${district}` : restaurant.name;
    const results = await searchPlace(query, {
      x: restaurant.longitude,
      y: restaurant.latitude,
      radius: 2000,
    });
    result = findBestMatch(results, restaurant.name);
  }

  // 3차 시도: 좌표 없이 이름 + 주소 (폴백)
  if (!result) {
    const results = await searchPlace(`${restaurant.name} ${restaurant.address}`);
    result = findBestMatch(results, restaurant.name);
  }

  if (!result) {
    return {
      platform: "kakao",
      found: false,
      placeUrl: null,
      reviewUrl: null,
      verifiedInfo: null,
    };
  }

  return {
    platform: "kakao",
    found: true,
    placeId: result.id,
    placeUrl: result.placeUrl,
    reviewUrl: result.placeUrl ? `${result.placeUrl}#comment` : null,
    verifiedInfo: {
      address: result.roadAddressName || result.addressName,
      phone: result.phone,
    },
  };
}

module.exports = {
  searchPlace,
  validateRestaurant,
};
