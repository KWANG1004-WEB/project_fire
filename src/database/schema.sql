-- 게시판 시스템 데이터베이스 스키마

-- 사용자 테이블
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY COMMENT '사용자 ID',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT '이메일',
    password_hash VARCHAR(255) NOT NULL COMMENT '해시된 비밀번호',
    nickname VARCHAR(50) NOT NULL COMMENT '닉네임',
    profile_image VARCHAR(500) COMMENT '프로필 이미지 경로',
    is_active BOOLEAN DEFAULT TRUE COMMENT '계정 활성화 상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    last_login_at TIMESTAMP COMMENT '마지막 로그인 일시',
    INDEX idx_email (email) COMMENT '이메일 인덱스',
    INDEX idx_nickname (nickname) COMMENT '닉네임 인덱스'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 테이블';

-- 게시글 테이블
CREATE TABLE posts (
    post_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글 고유 ID',
    user_id VARCHAR(50) NOT NULL COMMENT '작성자 ID (외부 시스템)',
    title VARCHAR(200) NOT NULL COMMENT '게시글 제목',
    content TEXT NOT NULL COMMENT '게시글 내용',
    category VARCHAR(50) DEFAULT '일반' COMMENT '게시글 카테고리',
    view_count INT DEFAULT 0 COMMENT '조회수',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    INDEX idx_created_at (created_at) COMMENT '작성일시 인덱스',
    INDEX idx_user_id (user_id) COMMENT '작성자 ID 인덱스',
    INDEX idx_category (category) COMMENT '카테고리 인덱스'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시글 테이블';

-- 댓글 테이블
CREATE TABLE comments (
    comment_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글 고유 ID',
    post_id BIGINT NOT NULL COMMENT '게시글 ID',
    user_id VARCHAR(50) NOT NULL COMMENT '작성자 ID (외부 시스템)',
    content TEXT NOT NULL COMMENT '댓글 내용',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    INDEX idx_post_id (post_id) COMMENT '게시글 ID 인덱스',
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE COMMENT '게시글 삭제시 댓글도 삭제'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='댓글 테이블';

-- 파일 첨부 테이블
CREATE TABLE attachments (
    attachment_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '첨부파일 고유 ID',
    post_id BIGINT NOT NULL COMMENT '게시글 ID',
    file_name VARCHAR(255) NOT NULL COMMENT '원본 파일명',
    file_path VARCHAR(500) NOT NULL COMMENT '저장 경로',
    file_size BIGINT NOT NULL COMMENT '파일 크기 (bytes)',
    mime_type VARCHAR(100) NOT NULL COMMENT '파일 MIME 타입',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '업로드 일시',
    INDEX idx_post_id (post_id) COMMENT '게시글 ID 인덱스',
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE COMMENT '게시글 삭제시 첨부파일도 삭제'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='첨부파일 테이블';

-- 게시글 좋아요 테이블
CREATE TABLE post_likes (
    post_id BIGINT NOT NULL COMMENT '게시글 ID',
    user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID (외부 시스템)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '좋아요 일시',
    PRIMARY KEY (user_id, post_id) COMMENT '사용자-게시글 복합 기본키',
    INDEX idx_post_id (post_id) COMMENT '게시글 ID 인덱스',
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE COMMENT '게시글 삭제시 좋아요도 삭제'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시글 좋아요 테이블';

-- 게시글 북마크 테이블
CREATE TABLE bookmarks (
    user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID (외부 시스템)',
    post_id BIGINT NOT NULL COMMENT '게시글 ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '북마크 일시',
    PRIMARY KEY (user_id, post_id) COMMENT '사용자-게시글 복합 기본키',
    INDEX idx_post_id (post_id) COMMENT '게시글 ID 인덱스',
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE COMMENT '게시글 삭제시 북마크도 삭제'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시글 북마크 테이블'; 