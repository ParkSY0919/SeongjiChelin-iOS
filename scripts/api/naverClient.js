/**
 * Naver Search API 클라이언트
 *
 * 네이버 지역 검색 API를 사용하여 식당 정보를 조회합니다.
 * https://developers.naver.com/docs/serviceapi/search/local/local.md
 */

const axios = require("axios");
const config = require("../config");

/**
 * 지역 검색
 * @param {string} query - 검색 키워드
 * @returns {Promise<Object|null>} 검색 결과
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
        display: 1,
      },
    });

    const items = response.data.items;
    if (!items || items.length === 0) {
      return null;
    }

    const item = items[0];
    const cleanTitle = item.title.replace(/<[^>]*>/g, "");

    return {
      title: cleanTitle,
      link: item.link,
      category: item.category,
      description: item.description,
      telephone: item.telephone || null,
      address: item.address,
      roadAddress: item.roadAddress,
      mapx: item.mapx,
      mapy: item.mapy,
    };
  } catch (error) {
    console.error(`[Naver] 검색 오류 (${query}):`, error.message);
    return null;
  }
}

/**
 * 식당 정보 검증
 * @param {Object} restaurant - 검증할 식당 정보
 * @returns {Promise<Object>} 검증 결과
 */
async function validateRestaurant(restaurant) {
  const result = await searchLocal(restaurant.name);

  if (!result) {
    return {
      platform: "naver",
      found: false,
      placeUrl: null,
      reviewUrl: null,
      verifiedInfo: null,
    };
  }

  const placeUrl = `https://map.naver.com/v5/search/${encodeURIComponent(restaurant.name)}`;

  return {
    platform: "naver",
    found: true,
    placeUrl: result.link || placeUrl,
    reviewUrl: placeUrl,
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
