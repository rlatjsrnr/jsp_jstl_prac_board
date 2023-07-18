DROP TABLE IF EXISTS digital_member;
CREATE TABLE IF NOT EXISTS digital_member(
	u_num INT primary key auto_increment, 	-- 회원번호
	u_id VARCHAR(30) unique,			  	-- 회원아이디
	u_pass VARCHAR(30) NOT NULL,			-- 비밀번호
	u_age int,								-- 나이
	u_gender VARCHAR(10), 				    -- 성별
	u_join char(1) default 'Y',				-- 회원탈퇴 여부 Y == 가입상태
	u_regdate TIMESTAMP default now() 		-- 회원가입일	 
);

-- 회원 가입 시
INSERT INTO digital_member(u_id,u_pass,u_age,u_gender) 
VALUES('admin', 'admin' , 20, 'male');

-- 회원탈퇴 시
-- UPDATE digital_member SET u_join = 'N' WHERE u_num = 회원번호;
commit;
SELECT * FROM digital_member;
-- 관리자가 아니고 탈퇴한 회원이 아닌 정보 출력
SELECT * FROM digital_member 
WHERE u_id != 'admin' AND u_join = 'Y' 
ORDER BY u_num DESC

/*
 	공지형 게시판 테이블 
 */
CREATE TABLE IF NOT EXISTS notice_board(
	notice_num INT PRIMARY KEY AUTO_INCREMENT,	-- 공지 번호
	notice_category VARCHAR(20) NOT NULL, 		-- 공지 분류
	notice_author VARCHAR(50) NOT NULL,			-- 작성자
	notice_title VARCHAR(50) NOT NULL, 			-- 제목
	notice_content TEXT NOT NULL, 				-- 내용
	notice_date	TIMESTAMP DEFAULT now()			-- 작성시간
);

DESC notice_board;
SELECT * FROM notice_board;
INSERT INTO notice_board(notice_category, notice_author, notice_title, notice_content) VALUES('공지', '관리자','안녕하세요','처음입니다 우리사이트를 방문해주셔서 갑사합니다.');
INSERT INTO notice_board VALUES(null, '공지', '관리자', '방문해주셔서 감사합니다. 제곧내', '냉무',now());

-- 페이징 처리 확인 용 sample data 추가
INSERT INTO notice_board(notice_category, notice_author, notice_title, notice_content) 
SELECT 
	notice_category, notice_author, notice_title, notice_content 
FROM notice_board;

DROP TABLE qna_board;

-- 질문과 답변 - 자유게시판 table
CREATE TABLE IF NOT EXISTS qna_board(
	qna_num INT PRIMARY KEY AUTO_INCREMENT,	-- 글 번호
	qna_name VARCHAR(20) NOT NULL,			-- 작성자 이름
	qna_title VARCHAR(50) NOT NULL,			-- 글 제목
	qna_content TEXT NOT NULL,				-- 글 내용
	qna_writer_num INT NOT NULL,			-- 글 작성자 회원 번호
	qna_readcount INT DEFAULT 0,			-- 조회수
	qna_date TIMESTAMP DEFAULT now()		-- 작성 시간
);

-- 원본글(질문글)일 경우 자신의 게시글 번호를 저장하여 동일한 qna_re_ref값일 경우 묶어서 출력할 수 있도록 저장
ALTER TABLE qna_board ADD COLUMN qna_re_ref INT NOT NULL DEFAULT 0 AFTER qna_content;

-- view화며에서 출력될 답변 글의 깊이
ALTER TABLE qna_board ADD COLUMN qna_re_lev INT NOT NULL DEFAULT 0 AFTER qna_re_ref;

-- 답변 글 끼리의 정렬 순서
ALTER TABLE qna_board ADD COLUMN qna_re_seq INT NOT NULL DEFAULT 0 AFTER qna_re_lev;


UPDATE qna_board SET qna_re_ref = qna_num;


DESC qna_board;

ALTER TABLE qna_board ADD CONSTRAINT fk_qna_writer FOREIGN KEY(qna_writer_num) REFERENCES digital_member(u_num);

INSERT INTO qna_board(qna_name, qna_title, qna_content, qna_writer_num) SELECT qna_name, qna_title, qna_content, qna_writer_num FROM qna_board; 

INSERT INTO qna_board VALUES(null, '김선국', '테스트용', '내용', 0,0,0,1,0,now());

SELECT * FROM qna_board ORDER BY qna_re_ref DESC;

SELECT LAST_INSERT_ID();

UPDATE qna_board SET qna_re_ref = LAST_INSERT_ID() WHERE qna_num = LAST_INSERT_ID();

commit;


