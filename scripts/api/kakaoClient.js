/**
 * Kakao Local API 클라이언트
 *
 * 카카오맵 장소 검색 API를 사용하여 식당 정보를 조회합니다.
 * https://developers.kakao.com/docs/latest/ko/local/dev-guide
 */

const axios = require("axios");
const config = require("../config");

/**
 * 키워드로 장소 검색
 * @param {string} query - 검색 키워드 (식당 이름 + 주소)
 * @returns {Promise<Object|null>} 검색 결과
 */
async function searchPlace(query) {
  if (!config.kakao.apiKey) {
    console.warn("[Kakao] API 키가 설정되지 않았습니다.");
    return null;
  }

  try {
    const response = await axios.get(`${config.kakao.baseUrl}/v2/local/search/keyword.json`, {
      headers: {
        Authorization: `KakaoAK ${config.kakao.apiKey}`,
      },
      params: {
        query: query,
        size: 1,
      },
    });

    const documents = response.data.documents;
    if (!documents || documents.length === 0) {
      return null;
    }

    const place = documents[0];
    return {
      id: place.id,
      placeName: place.place_name,
      addressName: place.address_name,
      roadAddressName: place.road_address_name,
      phone: place.phone || null,
      placeUrl: place.place_url,
      categoryName: place.category_name,
      x: place.x,
      y: place.y,
    };
  } catch (error) {
    console.error(`[Kakao] 검색 오류 (${query}):`, error.message);
    return null;
  }
}

/**
 * 식당 정보 검증
 * @param {Object} restaurant - 검증할 식당 정보
 * @returns {Promise<Object>} 검증 결과
 */
async function validateRestaurant(restaurant) {
  const query = `${restaurant.name} ${restaurant.address}`;
  const result = await searchPlace(query);

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
