/**
 * 환경 변수 기반 설정
 * GitHub Actions 또는 로컬 .env에서 값을 가져옵니다.
 */

module.exports = {
  kakao: {
    apiKey: process.env.KAKAO_API_KEY,
    baseUrl: "https://dapi.kakao.com",
  },
  naver: {
    clientId: process.env.NAVER_CLIENT_ID,
    clientSecret: process.env.NAVER_CLIENT_SECRET,
    baseUrl: "https://openapi.naver.com",
  },
  google: {
    apiKey: process.env.GOOGLE_API_KEY,
    baseUrl: "https://maps.googleapis.com/maps/api/place",
  },
};
