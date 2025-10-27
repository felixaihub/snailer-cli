# Repository 설정 체크리스트

> ✅ **메인테이너 전용** - 새로운 Snailer CLI Public Repository를 설정할 때 확인하세요

---

## 🚀 초기 설정 (한 번만)

### 1. Repository Settings

#### General
- [ ] Repository name: `snailer-cli`
- [ ] Description: "AI-Powered Development Agent - Distribution & Documentation"
- [ ] Website: `https://snailer.ai`
- [ ] Topics: `ai`, `cli`, `rust`, `agent`, `developer-tools`
- [ ] Default branch: `main`

#### Features
- [ ] ✅ Issues
- [ ] ✅ Discussions
- [ ] ❌ Projects (선택사항)
- [ ] ❌ Wiki (문서는 `/docs`에서 관리)

#### Pull Requests
- [ ] ✅ Allow squash merging
- [ ] ❌ Allow merge commits
- [ ] ❌ Allow rebase merging
- [ ] ✅ Always suggest updating pull request branches
- [ ] ✅ Automatically delete head branches

---

### 2. Branch Protection (⚠️ 필수!)

**Settings → Branches → Add branch protection rule**

#### Branch name pattern
```
main
```

#### 필수 설정

##### Protect matching branches
- [x] **Require a pull request before merging**
  - Required approvals: **1**
  - [x] Dismiss stale pull request approvals when new commits are pushed
  - [x] Require review from Code Owners

- [x] **Require status checks to pass before merging**
  - [x] Require branches to be up to date before merging
  - Status checks:
    - `check-links` (Documentation Check)
    - `check-format` (Documentation Check)
    - `pr-size` (Pull Request Checks)
    - `file-size-check` (Pull Request Checks)
    - `conventional-commits` (Pull Request Checks)

- [x] **Require conversation resolution before merging**

- [x] **Require linear history**

- [x] **Do not allow bypassing the above settings**

##### Additional Rules
- [x] **Restrict who can push to matching branches**
  - Add: `@your-org/maintainers` 또는 개인 계정

##### Dangerous Actions (금지!)
- [ ] ❌ Allow force pushes
- [ ] ❌ Allow deletions

#### 저장
- [ ] **Create** 또는 **Save changes** 클릭

---

### 3. Code Owners

#### `.github/CODEOWNERS` 파일 확인
- [ ] 파일이 존재하는지 확인
- [ ] 팀/사용자 이름이 올바른지 확인

```bash
# 팀 이름 형식
@your-org/maintainers  # 조직 팀
@username              # 개인 사용자
```

#### 팀 생성 (조직 계정인 경우)
- [ ] Organization Settings → Teams
- [ ] **New team** 클릭
- [ ] Team name: `maintainers`
- [ ] Members 추가

---

### 4. GitHub Actions

#### Secrets 설정 (필요한 경우)
- [ ] Settings → Secrets and variables → Actions
- [ ] `NPM_TOKEN` (npm 배포용)
- [ ] `HOMEBREW_TOKEN` (Homebrew 릴리스용)

#### Workflow 권한
- [ ] Settings → Actions → General
- [ ] Workflow permissions: **Read and write permissions**
- [ ] [x] Allow GitHub Actions to create and approve pull requests

---

### 5. 이슈 템플릿

#### 확인할 파일
- [ ] `.github/ISSUE_TEMPLATE/bug_report.yml`
- [ ] `.github/ISSUE_TEMPLATE/feature_request.yml`

#### 테스트
- [ ] Issues → New issue
- [ ] 템플릿이 올바르게 표시되는지 확인

---

### 6. PR 템플릿

#### 확인할 파일
- [ ] `.github/pull_request_template.md`

#### 테스트
- [ ] 테스트 브랜치 생성
- [ ] PR 생성 시 템플릿이 자동으로 로드되는지 확인

---

### 7. CI/CD Workflows

#### 확인할 파일
- [ ] `.github/workflows/docs-check.yml`
- [ ] `.github/workflows/pr-checks.yml`
- [ ] `.github/workflows/npm-publish.yml`

#### 첫 실행
- [ ] 테스트 PR 생성
- [ ] Actions 탭에서 워크플로우 실행 확인
- [ ] 모든 체크가 통과하는지 확인

---

## 🧪 테스트 체크리스트

### 1. Branch Protection 테스트

#### A. Direct Push 차단 확인
```bash
git checkout main
echo "test" >> README.md
git commit -am "test: direct push"
git push origin main
```

**예상 결과**: ❌ Push 거부
```
remote: error: GH006: Protected branch update failed for refs/heads/main.
```

#### B. PR 승인 없이 병합 시도
- [ ] 테스트 PR 생성
- [ ] 승인 없이 "Merge" 버튼 클릭 시도

**예상 결과**: 🔒 Merge 버튼 비활성화
```
Merging is blocked
Review required: At least 1 approving review
```

#### C. CI 실패 시 병합 시도
- [ ] 테스트 PR에서 링크 깨트리기
- [ ] CI 실패 확인
- [ ] "Merge" 버튼 상태 확인

**예상 결과**: ❌ CI 통과 필요
```
Required status checks must pass
```

#### D. Force Push 차단 확인
```bash
git checkout main
git commit --amend -m "amended"
git push -f origin main
```

**예상 결과**: ❌ Force push 거부

---

### 2. CODEOWNERS 테스트

#### PR 생성 시 자동 리뷰어 지정
- [ ] 문서 파일 변경 PR 생성
- [ ] 자동으로 리뷰어가 지정되는지 확인

**예상 결과**:
```
Reviewers
@your-org/maintainers (requested)
```

---

### 3. CI Workflows 테스트

#### docs-check.yml
- [ ] 문서 파일 변경
- [ ] PR 생성
- [ ] "Check Markdown Links" 통과 확인

#### pr-checks.yml
- [ ] PR 생성
- [ ] "Check PR Size" 코멘트 확인
- [ ] PR 통계가 정확한지 확인

---

## ✅ 최종 확인

### Repository 상태
- [ ] main 브랜치 보호 활성화
- [ ] PR 템플릿 작동
- [ ] 이슈 템플릿 작동
- [ ] CODEOWNERS 작동
- [ ] CI Workflows 통과

### 문서 확인
- [ ] README.md 링크 작동
- [ ] /docs/ 디렉토리 정리
- [ ] CONTRIBUTING.md 최신화
- [ ] BRANCH_PROTECTION.md 존재

### 권한 확인
- [ ] Maintainers 팀 생성
- [ ] 적절한 사용자 추가
- [ ] 각 멤버 권한 확인 (Write/Admin)

---

## 🚨 문제 해결

### "Required status check is not enabled"
```bash
# 해결: CI를 최소 1번 실행해야 함
1. 테스트 PR 생성
2. CI 실행 대기
3. Settings → Branches → Edit rule
4. Status checks 선택
```

### CODEOWNERS 작동 안 함
```bash
# 확인 사항
1. 파일 위치: .github/CODEOWNERS ✅
2. 팀 이름 형식: @org/team ✅
3. 파일 권한: 읽기 가능 ✅
```

### CI Workflows 실행 안 됨
```bash
# 확인 사항
1. Settings → Actions → General
2. "Allow all actions" 활성화 ✅
3. Workflow permissions: Read and write ✅
```

---

## 📚 참고 문서

- [BRANCH_PROTECTION.md](.github/BRANCH_PROTECTION.md) - 상세한 브랜치 보호 설정
- [CONTRIBUTING.md](docs/CONTRIBUTING.md) - 기여 가이드
- [GitHub Docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)

---

**마지막 업데이트**: 2025-01-24
**확인자**: _______________
**날짜**: _______________
