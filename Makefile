# KHH 챗봇 관리 Makefile

.PHONY: stop start restart reload status log deploy clean help

# 서비스 중지
stop:
	sudo systemctl stop khh-bot

# 서비스 시작
start:
	sudo systemctl start khh-bot

# 서비스 재시작 (stop + start)
restart: stop reload start

# systemd 데몬 리로드
reload:
	sudo systemctl daemon-reload

# 서비스 상태 확인
status:
	sudo systemctl status khh-bot

# 실시간 로그 확인
log:
	sudo journalctl -u khh-bot -f

# 로그 보기 (최근 50줄)
logs:
	sudo journalctl -u khh-bot -n 50

# 전체 배포 (stop + reload + start)
deploy: stop reload start
	@echo "✅ 크하학 봇 배포 완료!"

# 서비스 활성화 (부팅시 자동 시작)
enable:
	sudo systemctl enable khh-bot

# 서비스 비활성화
disable:
	sudo systemctl disable khh-bot

# 빠른 업데이트 (git pull + restart)
update:
	git pull origin main
	make restart
	@echo "✅ 업데이트 완료!"

# 개발용 - 로컬 실행
dev:
	python3 app.py

# 의존성 설치
install:
	pip3 install -r requirements.txt

# 서비스 파일 다시 로드
install-service:
	sudo cp khh-bot.service /etc/systemd/system/
	sudo systemctl daemon-reload
	sudo systemctl enable khh-bot

# 로그 파일 정리
clean:
	sudo rm -f /var/log/khh-bot.log
	sudo journalctl --vacuum-time=7d

# 도움말
help:
	@echo "🤖 크하학 봇 관리 명령어:"
	@echo ""
	@echo "기본 관리:"
	@echo "  make stop     - 서비스 중지"
	@echo "  make start    - 서비스 시작"
	@echo "  make restart  - 서비스 재시작"
	@echo "  make reload   - systemd 리로드"
	@echo "  make status   - 서비스 상태 확인"
	@echo ""
	@echo "로그 관리:"
	@echo "  make log      - 실시간 로그 보기"
	@echo "  make logs     - 최근 로그 보기"
	@echo "  make clean    - 로그 파일 정리"
	@echo ""
	@echo "배포/업데이트:"
	@echo "  make deploy   - 전체 배포"
	@echo "  make update   - git pull + restart"
	@echo ""
	@echo "개발:"
	@echo "  make dev      - 로컬에서 실행"
	@echo "  make install  - 의존성 설치"
	@echo ""
	@echo "서비스 설정:"
	@echo "  make enable   - 부팅시 자동 시작"
	@echo "  make disable  - 자동 시작 해제"