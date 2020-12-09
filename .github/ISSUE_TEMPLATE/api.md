---
name: API
about: 백엔드 API 이슈 탬플릿
title: '작업 - 북마크 생성 API 구현 '
labels: BE, API
assignees: Zinyon, pjy0416, shkilo

---

## Task - Bookmark POST API
URL
```
POST /api/task/:taskId/bookmark
```

Request
```
{
    url : 'https://another...'
}
```

Request Description
| Name          | Required           | Type|  Description  | 
| :------------- |:--------------|:------------|:------------|
| grant_type | **REQUIRED** |  **CODE** | [RFC 6759#session-6](https://tools.ietf.org/html/rfc6749#section-6) 에 정의 된  인증유형에 대한 구분 값.  현재 다음의 2가지 type 만 사용가능.  <br>- 인증코드 사용시:    `authorization_code`<br>- 리프레시 토큰 사용 시:  `refresh_token`   |
| client_id  | **REQUIRED** | **STRING** | 발급 된 애플리케이션 자격증명의  Client ID 값  |
| client_secret | **REQUIRED** | **STRING** | 발급 된 애플리케이션 자격증명의  Client SECRET 값  |
| code | **CONDITIONAL** |  **STRING** | authorization code request 응답으로 부터 발급 받은 인증코드. <br>grant_type 이   `code` 일 때 만 사용. |
| refresh_token | **CONDITIONAL** |  **STRING** | 이전 토큰발급 요청을 통하여 발급 받은 리프레시 토큰.<br>grant_type 이 `refresh_token ` 일 때 만 사용. |

Response
```
{
    'message': 'ok'
}
```

Response Description
```
| Name   |    Type |     Description  |
| :-------------  |:--------------|:--------------|
| **primaryEmail** |   **STRING** |  사용자 이메일 |
```

## API 명세 링크
https://github.com/boostcamp-2020/Project04-C-Whale/wiki/Task-API

## error code
| 상태 코드  | 오류 메시지  | 설명 |
|:-----:|:------:|:-----:|
| 400 | Bad Request | 요청이 잘못된 경우 발생합니다. |
| 401 | Unauthorized  | 유효한 토큰을 header에 포함하지 않은 경우 발생합니다. |
| 403 | Forbidden | 해당 리소스에 대한 권한이 없는 요청에 대해 발생합니다. |
| 404 | Not Found | 해당 id의 bookmark나 task가 존재하지 않는 경우 발생합니다. |
| 500 | Internal Server Error | 서버에 문제가 생긴 경우 발생합니다. |
