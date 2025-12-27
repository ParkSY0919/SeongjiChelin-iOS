/**
 * API 클라이언트 공통 유틸리티
 */

/**
 * 주소에서 구/군/시 추출
 * @param {string} address - 전체 주소
 * @returns {string} 추출된 구/군/시 (없으면 빈 문자열)
 * @example
 * extractDistrict("서울 성북구 종암로3길 31 1층") // "성북구"
 * extractDistrict("인천 서구 가정로380번길 7") // "서구"
 */
function extractDistrict(address) {
  if (!address) return "";
  const match = address.match(/([가-힣]+[구군시])\s/);
  return match ? match[1] : "";
}

/**
 * 두 좌표 간 거리 계산 (Haversine 공식)
 * @param {number} lat1 - 위도 1
 * @param {number} lon1 - 경도 1
 * @param {number} lat2 - 위도 2
 * @param {number} lon2 - 경도 2
 * @returns {number} 거리 (미터)
 */
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371000; // 지구 반경 (미터)
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

/**
 * 식당 이름 정규화 (비교용)
 * @param {string} name - 식당 이름
 * @returns {string} 정규화된 이름
 */
function normalizeName(name) {
  if (!name) return "";
  return name.replace(/[^가-힣a-zA-Z0-9]/g, "").toLowerCase();
}

module.exports = {
  extractDistrict,
  calculateDistance,
  normalizeName,
};
