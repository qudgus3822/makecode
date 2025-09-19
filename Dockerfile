# Multi-stage build for React + Vite frontend
FROM node:20-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app


#pxt 설치
RUN npm install -g pxt
# package.json과 package-lock.json 복사하여 의존성 설치
COPY package*.json ./
RUN npm ci

# 소스 코드 복사
COPY . .

WORKDIR /pxt-microbit

CMD ["pxt", "staticpkg"]

# Production stage with nginx
FROM nginx:alpine AS production

# 빌드된 파일을 nginx 정적 파일 디렉토리로 복사
COPY --from=builder /app/pxt-microbit/built/packaged /usr/share/nginx/html

# 포트 80 노출
EXPOSE 80

# nginx 시작
CMD ["nginx", "-g", "daemon off;"]