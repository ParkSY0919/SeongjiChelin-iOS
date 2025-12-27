/**
 * Google Places API 클라이언트
 *
 * Google Places API를 사용하여 식당 정보, 평점, 리뷰를 조회합니다.
 * https://developers.google.com/maps/documentation/places/web-service
 */

const axios = require("axios");
const config = require("../config");

/**
 * Text Search로 장소 검색
 * @param {string} query - 검색 키워드
 * @returns {Promise<Object|null>} 검색 결과
 */
async function textSearch(query) {
  if (!config.google.apiKey) {
    console.warn("[Google] API 키가 설정되지 않았습니다.");
    return null;
  }

  try {
    const response = await axios.get(`${config.google.baseUrl}/textsearch/json`, {
      params: {
        query: query,
        key: config.google.apiKey,
        language: "ko",
      },
    });

    const results = response.data.results;
    if (!results || results.length === 0) {
      return null;
    }

    return results[0];
  } catch (error) {
    console.error(`[Google] Text Search 오류 (${query}):`, error.message);
    return null;
  }
}

/**
 * Place Details 조회
 * @param {string} placeId - Google Place ID
 * @returns {Promise<Object|null>} 상세 정보
 */
async function getPlaceDetails(placeId) {
  if (!config.google.apiKey) {
    return null;
  }

  try {
    const response = await axios.get(`${config.google.baseUrl}/details/json`, {
      params: {
        place_id: placeId,
        fields: "name,formatted_address,formatted_phone_number,opening_hours,rating,user_ratings_total,url,reviews",
        key: config.google.apiKey,
        language: "ko",
      },
    });

    return response.data.result || null;
  } catch (error) {
    console.error(`[Google] Place Details 오류 (${placeId}):`, error.message);
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

  const searchResult = await textSearch(query);
  if (!searchResult) {
    return {
      platform: "google",
      found: false,
      placeUrl: null,
      reviewUrl: null,
      rating: null,
      reviewCount: null,
      verifiedInfo: null,
    };
  }

  const details = await getPlaceDetails(searchResult.place_id);
  if (!details) {
    return {
      platform: "google",
      found: true,
      placeId: searchResult.place_id,
      placeUrl: null,
      reviewUrl: null,
      rating: searchResult.rating || null,
      reviewCount: searchResult.user_ratings_total || null,
      verifiedInfo: null,
    };
  }

  let businessHours = null;
  if (details.opening_hours?.weekday_text) {
    businessHours = parseBusinessHours(details.opening_hours.weekday_text);
  }

  return {
    platform: "google",
    found: true,
    placeId: searchResult.place_id,
    placeUrl: details.url,
    reviewUrl: details.url,
    rating: details.rating || null,
    reviewCount: details.user_ratings_total || null,
    reviews: details.reviews?.slice(0, 3).map((r) => ({
      author: r.author_name,
      rating: r.rating,
      text: r.text,
      time: r.relative_time_description,
    })),
    verifiedInfo: {
      address: details.formatted_address,
      phone: details.formatted_phone_number,
      businessHours: businessHours,
    },
  };
}

/**
 * Google 영업시간 형식을 앱 형식으로 변환
 * @param {string[]} weekdayText - Google 영업시간 배열
 * @returns {Object} 요일별 영업시간
 */
function parseBusinessHours(weekdayText) {
  const dayMap = {
    월요일: "월",
    화요일: "화",
    수요일: "수",
    목요일: "목",
    금요일: "금",
    토요일: "토",
    일요일: "일",
  };

  const result = {};

  for (const text of weekdayText) {
    const match = text.match(/^(\S+):\s*(.+)$/);
    if (match) {
      const dayKor = dayMap[match[1]];
      if (dayKor) {
        result[dayKor] = match[2];
      }
    }
  }

  return result;
}

module.exports = {
  textSearch,
  getPlaceDetails,
  validateRestaurant,
};
