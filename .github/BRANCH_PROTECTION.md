# 브랜치 보호 설정 가이드

> 🔒 **메인테이너 전용** - main 브랜치 보호 규칙 설정 방법

이 문서는 GitHub Repository 관리자가 main 브랜치를 보호하고, PR 승인 없이는 병합할 수 없도록 설정하는 방법을 안내합니다.

---

## 🎯 목표

- ✅ main 브랜치에 직접 push 금지
- ✅ PR 병합 전 반드시 maintainer 승인 필요
- ✅ CI 체크 통과 필수
- ✅ Force push 금지
- ✅ 브랜치 삭제 금지

---

## 📋 설정 방법

### 1. Repository Settings 접근

1. GitHub에서 `snailer-cli` 저장소 이동
2. **Settings** 탭 클릭
3. 왼쪽 사이드바에서 **Branches** 클릭

### 2. Branch Protection Rule 추가

**Add branch protection rule** 클릭

#### Branch name pattern
```
main
```

#### 필수 설정 (Protect matching branches)

##### ✅ Require a pull request before merging
- **체크**: 필수!
- **Require approvals**: **1** (최소 1명의 승인 필요)
- **Dismiss stale pull request approvals when new commits are pushed**: 체크 ✅
  - 새 커밋 push 시 기존 승인 무효화
- **Require review from Code Owners**: 체크 ✅ (CODEOWNERS 파일이 있는 경우)

##### ✅ Require status checks to pass before merging
- **체크**: 필수!
- **Require branches to be up to date before merging**: 체크 ✅

**Status checks to require:**
- `docs-check` (문서 링크 체크)
- `pr-stats` (PR 통계)
- 기타 CI 워크플로우 추가

##### ✅ Require conversation resolution before merging
- **체크**: 필수!
- 모든 리뷰 코멘트가 resolve되어야 병합 가능

##### ✅ Require signed commits
- **체크**: 선택사항
- 서명된 커밋만 허용 (보안 강화)

##### ✅ Require linear history
- **체크**: 권장!
- Merge commit 금지, Squash & Merge 또는 Rebase 강제

##### ✅ Do not allow bypassing the above settings
- **체크**: 필수!
- 관리자도 규칙을 우회할 수 없음

##### ✅ Restrict who can push to matching branches
- **체크**: 권장!
- **사람/팀 추가**:
  - `@maintainers` (메인테이너 팀)
  - 또는 특정 사용자만 지정

##### ✅ Require deployments to succeed before merging
- **체크**: 선택사항
- Staging 배포 성공 후 병합

#### 추가 보호 옵션

##### ✅ Allow force pushes
- **체크 해제**: ❌ (force push 금지)

##### ✅ Allow deletions
- **체크 해제**: ❌ (브랜치 삭제 금지)

### 3. 저장

**Create** 또는 **Save changes** 클릭

---

## 🔐 CODEOWNERS 파일 추가 (선택사항)

특정 파일/디렉토리 변경 시 자동으로 리뷰어 지정

### `.github/CODEOWNERS` 파일 생성

```
# Snailer CLI Code Owners
# 이 파일은 PR 생성 시 자동으로 리뷰어를 지정합니다

# 전체 저장소 - 메인테이너 팀
* @your-org/maintainers

# 문서 - 문서 팀
/docs/ @your-org/doc-team
*.md @your-org/doc-team

# 패키징 - 릴리스 팀
/packaging/ @your-org/release-team
/Formula/ @your-org/release-team

# CI/CD - DevOps 팀
/.github/workflows/ @your-org/devops-team

# 보안 관련 - 보안 팀
SECURITY.md @your-org/security-team
```

---

## ✅ 설정 확인

### 1. 테스트 PR 생성

```bash
# 테스트 브랜치 생성
git checkout -b test/branch-protection
echo "test" >> README.md
git add README.md
git commit -m "docs: test branch protection"
git push origin test/branch-protection
```

### 2. PR 생성 후 확인

GitHub에서 PR을 생성하면:

#### 예상 동작:
```
❌ Merging is blocked
   The following requirements must be met:

   □ Review required
     At least 1 approving review is required by reviewers with write access.

   □ Status checks must pass
     - docs-check (pending...)
     - pr-stats (pending...)

   □ Conversations must be resolved
     All conversations on code must be resolved.
```

#### Merge 버튼 상태:
```
🔒 Merge pull request (disabled)
   This branch has not been approved
```

### 3. Maintainer 승인 후

메인테이너가 **Approve** 하면:

```
✅ All checks have passed
   1 approving review by someone with write access

✅ Status checks passed
   - docs-check ✓
   - pr-stats ✓

✅ Conversations resolved

🟢 Squash and merge (enabled)
```

---

## 🚫 Force Push 차단 확인

### 테스트

```bash
# main 브랜치에서 force push 시도
git checkout main
git commit --amend -m "test"
git push -f origin main
```

### 예상 결과:
```
remote: error: GH006: Protected branch update failed for refs/heads/main.
remote: error: Cannot force-push to this branch
To github.com:your-org/snailer-cli.git
 ! [remote rejected] main -> main (protected branch hook declined)
error: failed to push some refs to 'github.com:your-org/snailer-cli.git'
```

---

## 📊 권장 설정 요약

| 설정 | 상태 | 이유 |
|-----|------|------|
| **Require PR** | ✅ 필수 | Direct push 방지 |
| **Require 1+ approval** | ✅ 필수 | 코드 품질 보장 |
| **Require status checks** | ✅ 필수 | CI 통과 강제 |
| **Require conversation resolution** | ✅ 필수 | 리뷰 코멘트 해결 |
| **Require linear history** | ✅ 권장 | 깔끔한 히스토리 |
| **Restrict push access** | ✅ 권장 | 메인테이너만 병합 |
| **Block force push** | ✅ 필수 | 히스토리 보호 |
| **Block branch deletion** | ✅ 필수 | 실수 방지 |
| **Require signed commits** | ⚠️ 선택 | 보안 강화 (팀 정책에 따라) |

---

## 🔧 문제 해결

### Q: "Required status check is not enabled"

**A**: CI 워크플로우가 최소 1번 실행되어야 합니다.

```bash
# 해결 방법
1. 테스트 PR 생성
2. CI가 실행될 때까지 대기
3. Settings → Branches에서 status check 선택
```

### Q: Maintainer도 병합할 수 없어요

**A**: "Do not allow bypassing" 설정을 확인하세요.

```
Settings → Branches → Edit rule
→ "Do not allow bypassing the above settings" 체크 해제
→ Save changes
```

### Q: CODEOWNERS가 작동하지 않아요

**A**: 파일 위치와 팀 이름을 확인하세요.

```
# 올바른 위치
.github/CODEOWNERS  ✅

# 잘못된 위치
CODEOWNERS  ❌
.github/workflows/CODEOWNERS  ❌

# 팀 이름 확인
@your-org/maintainers  ✅ (조직 팀)
@username  ✅ (개인)
```

---

## 📚 관련 문서

- [GitHub Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [CODEOWNERS 파일](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Required Status Checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks)

---

**마지막 업데이트**: 2025-01-24
**작성자**: Snailer Maintainers
