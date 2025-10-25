# Snailer 기여 가이드

> 🎯 **Snailer Public Repository 기여 가이드**
> 오픈소스 기여 프로세스를 경험하세요.

**환영합니다!** 이 저장소는 Snailer CLI의 **배포, 문서, 패키징**을 위한 공개 저장소입니다. 핵심 에이전트 코드는 비공개이지만, 여러분의 기여로 Snailer를 더 많은 사용자에게 전달할 수 있습니다.

---

## 📚 목차

1. [Snailer Public Repo란?](#snailer-public-repo란)
2. [기여 가능 영역](#기여-가능-영역)
3. [시작하기](#시작하기)
4. [개발 워크플로우](#개발-워크플로우)
5. [영역별 기여 가이드](#영역별-기여-가이드)
6. [코드 리뷰 & 병합](#코드-리뷰--병합)
7. [커뮤니티 & 인정](#커뮤니티--인정)

---

## Snailer Public Repo란?

### 🏗️ 저장소 구조

```
snailer-cli/  (Public Repository)
├── 📦 packaging/         # 배포 패키지 (npm, Homebrew)
├── 📚 docs/              # 사용자 문서 & 아키텍처 가이드
├── ⚙️ .github/           # CI/CD, 이슈 템플릿, PR 템플릿
├── 🔧 Formula/           # Homebrew 설치 스크립트
├── 📄 README.md          # 프로젝트 소개
├── 📋 CHANGELOG.md       # 릴리스 노트
└── 🛡️ SECURITY.md        # 보안 정책
```

**Private Repository** (접근 불가):
```
snailer/  (Private - Core Implementation)
├── src/                  # Rust 에이전트 코어
├── tests/                # 단위/통합 테스트
└── benches/              # 성능 벤치마크
```

### 🎯 Public Repo의 역할

| 역할 | 설명 | 기여 예시 |
|-----|------|----------|
| 📦 **배포 (Distribution)** | 사용자가 쉽게 설치할 수 있도록 패키징 | npm 설치 스크립트 개선, Homebrew Formula 업데이트 |
| 📚 **문서 (Documentation)** | 사용법, 아키텍처, 기여 가이드 작성 | 튜토리얼 작성, 다국어 번역, 예제 추가 |
| 🔧 **도구 (Tooling)** | CI/CD, 릴리스 자동화, 이슈 관리 | GitHub Actions 워크플로우, 이슈 템플릿 |
| 🌍 **커뮤니티 (Community)** | 사용자 지원, 피드백 수집, 에코시스템 | 예제 프로젝트, 플러그인 가이드 |


**왜 Private인가요?**
- 🔒 독점 알고리즘 및 최적화 보호
- 🎯 제품 품질 및 일관성 유지
- 🚀 빠른 프로토타이핑 및 실험

---

## 기여 가능 영역

### 🟢 초급 (Good First Issue)

완전 초보자도 기여할 수 있는 영역입니다!

#### 1. 📝 문서 개선

**난이도**: ⭐☆☆☆☆

**무엇을 하나요?**
- 오타 및 문법 오류 수정
- 불명확한 설명 개선
- 예제 코드 추가
- 스크린샷 및 다이어그램 추가

**예시 기여**:
```markdown
# Before (불명확)
Snailer는 AI 에이전트입니다.

# After (명확)
Snailer는 터미널에서 자연어 명령을 받아 코드 작성, 파일 수정,
검색 등을 자동으로 수행하는 AI 개발 도우미입니다.

예시:
$ snailer "모든 .rs 파일에서 TODO 주석 찾아줘"
```

**어디서 시작할까요?**
- [ ] [docs/README.md](./docs/README.md) 읽고 개선점 찾기
- [ ] [docs/AGENT_ARCHITECTURE.md](./docs/AGENT_ARCHITECTURE.md) 다이어그램 추가
- [ ] [docs/TOOL_SYSTEM.md](./docs/TOOL_SYSTEM.md) 예제 코드 추가

**라벨**: `good-first-issue`, `documentation`

---

#### 2. 🌍 다국어 번역

**난이도**: ⭐⭐☆☆☆

**무엇을 하나요?**
- README, 문서를 다른 언어로 번역
- 한국어, 일본어, 중국어, 스페인어 등

**예시 기여**:
```bash
docs/
├── README.md          # 영어 (기본)
├── README.ko.md       # 한국어 ← 추가!
├── README.ja.md       # 일본어 ← 추가!
└── README.zh.md       # 중국어 ← 추가!
```

**가이드라인**:
- 기술 용어는 원어 유지 (예: "Agent", "Tool", "ACE")
- 코드 예제는 번역하지 않음
- 링크는 모두 유효한지 확인

**어디서 시작할까요?**
- [ ] 이슈 열기: "Add Korean translation for README"
- [ ] `README.ko.md` 생성 및 번역
- [ ] PR 제출

**라벨**: `translation`, `good-first-issue`

---

### 🟡 중급 (Needs Help)

약간의 기술적 지식이 필요한 영역입니다.

#### 3. 📦 패키징 개선

**난이도**: ⭐⭐⭐☆☆

**무엇을 하나요?**
- npm 설치 스크립트 개선
- Homebrew Formula 업데이트
- Windows 설치 프로그램 개선
- 플랫폼별 버그 수정

**예시 기여**:

**npm 설치 개선** (`packaging/npm/postinstall.js`):
```javascript
// Before
const platform = process.platform;
if (platform === 'darwin') {
  downloadBinary('macos');
}

// After - Apple Silicon vs Intel 구분
const platform = process.platform;
const arch = process.arch;

if (platform === 'darwin') {
  if (arch === 'arm64') {
    downloadBinary('macos-arm64');  // M1/M2/M3
  } else {
    downloadBinary('macos-x64');    // Intel
  }
}
```

**Homebrew Formula 업데이트** (`Formula/snailer.rb`):
```ruby
class Snailer < Formula
  desc "AI-Powered Development Agent"
  homepage "https://snailer.ai"
  version "0.1.15"  # ← 버전 업데이트

  # SHA256 체크섬 업데이트
  url "https://github.com/your-org/snailer/releases/download/v0.1.15/snailer-macos.tar.gz"
  sha256 "abc123..."  # ← 새 릴리스 체크섬
end
```

**어디서 시작할까요?**
- [ ] 이슈 확인: `packaging` 라벨
- [ ] 로컬에서 설치 테스트 (`npm install`, `brew install`)
- [ ] 버그 재현 및 수정

**라벨**: `packaging`, `npm`, `homebrew`

---

#### 4. 🔧 CI/CD 워크플로우

**난이도**: ⭐⭐⭐☆☆

**무엇을 하나요?**
- GitHub Actions 워크플로우 개선
- 릴리스 자동화
- 테스트 자동화 (문서 링크 체크 등)

**예시 기여**:

**문서 링크 체크 워크플로우** (`.github/workflows/docs-check.yml`):
```yaml
name: Check Documentation Links

on:
  pull_request:
    paths:
      - 'docs/**'
      - 'README.md'

jobs:
  check-links:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check Markdown links
        uses: gaurav-nelson/github-action-markdown-link-check@v1
        with:
          use-quiet-mode: 'yes'
          config-file: '.github/markdown-link-check.json'

      - name: Comment on PR
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '⚠️ 일부 문서 링크가 깨졌습니다. 확인해주세요!'
            })
```

**어디서 시작할까요?**
- [ ] `.github/workflows/` 디렉토리 탐색
- [ ] 기존 워크플로우 이해하기
- [ ] 개선점 찾기 (예: 빌드 시간 단축, 캐싱 추가)

**라벨**: `ci-cd`, `github-actions`

---

### 🔴 고급 (Advanced)

깊은 이해와 경험이 필요한 영역입니다.

#### 5. 🎓 튜토리얼 & 예제

**난이도**: ⭐⭐⭐⭐☆

**무엇을 하나요?**
- 실전 사용 예제 작성
- 단계별 튜토리얼 제작
- 비디오 가이드 제작
- 블로그 포스트 작성

**예시 기여**:

**튜토리얼: "Snailer로 Rust 프로젝트 리팩토링하기"** (`docs/tutorials/rust-refactoring.md`):

```markdown
# Snailer로 Rust 프로젝트 리팩토링하기

> 🎯 목표: unwrap() 사용을 Result<?> 패턴으로 전환하기

## 1. 문제 파악

많은 Rust 초보자는 에러 처리에 `unwrap()`을 남발합니다:

STEP 1: 문제 있는 코드 찾기
$ snailer "모든 .rs 파일에서 unwrap() 사용 찾아줘"

🤖 Snailer:
찾았습니다! 15개 파일에서 총 47개의 unwrap() 발견:
- src/main.rs: 12개
- src/agent.rs: 8개
...


## 2. 리팩토링 시작

STEP 2: 개별 파일 리팩토링
$ snailer "src/main.rs에서 unwrap()을 Result<?> 패턴으로 바꿔줘"

🤖 Snailer:
리팩토링 완료! 변경 사항:
✅ 12개 unwrap() → ? 연산자로 변경
✅ main() 함수 시그니처: fn main() -> Result<()>
✅ 컴파일 테스트: 통과


## 3. 테스트 실행

STEP 3: 모든 테스트 통과 확인
$ cargo test

🎉 결과: 모든 테스트 통과!
```

**어디서 시작할까요?**
- [ ] 본인의 Snailer 사용 경험 정리
- [ ] 다른 사람이 겪을 만한 문제 파악
- [ ] 단계별 해결 과정 문서화

**라벨**: `tutorial`, `documentation`, `examples`

---

#### 6. 🎨 디자인 & UX

**난이도**: ⭐⭐⭐⭐☆

**무엇을 하나요?**
- 터미널 출력 개선 (색상, 포맷)
- 에러 메시지 개선
- 진행 상황 표시 개선
- 로고, 아이콘 디자인

**예시 기여**:

**에러 메시지 개선**:

```bash
# Before (불친절)
Error: API key not found

# After (친절 + 해결책 제시)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ API 키가 설정되지 않았습니다

Snailer는 AI 모델을 사용하기 위해 API 키가 필요합니다.

💡 해결 방법:

1. 환경 변수 설정:
   export ANTHROPIC_API_KEY=sk-ant-xxxxx

2. 또는 .env 파일 생성:
   echo "ANTHROPIC_API_KEY=sk-ant-xxxxx" > .env

🔗 API 키 발급: https://console.anthropic.com/
📖 상세 가이드: https://snailer.ai/docs/setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**어디서 시작할까요?**
- [ ] Snailer 사용 중 불편했던 점 정리
- [ ] 에러 메시지 개선안 제안
- [ ] 프로토타입 작성 (텍스트/스크린샷)

**라벨**: `ux`, `design`, `enhancement`

---

#### 7. 🔌 에코시스템 & 통합

**난이도**: ⭐⭐⭐⭐⭐

**무엇을 하나요?**
- VS Code 확장 개발
- IDE 플러그인 개발
- 다른 도구와의 통합 (예: Docker, Kubernetes)
- 템플릿 & 프리셋 제작

**예시 기여**:

**VS Code 확장** (`vscode-snailer/`):

```typescript
// extension.ts
import * as vscode from 'vscode';
import { exec } from 'child_process';

export function activate(context: vscode.ExtensionContext) {
  // 커맨드: 선택한 코드에 Snailer 적용
  let disposable = vscode.commands.registerCommand(
    'snailer.refactorSelection',
    async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) return;

      const selection = editor.selection;
      const text = editor.document.getText(selection);

      // 사용자에게 프롬프트 입력받기
      const prompt = await vscode.window.showInputBox({
        placeHolder: '무엇을 할까요? (예: 이 함수를 async/await으로 바꿔줘)',
        prompt: 'Snailer에게 요청할 작업을 입력하세요'
      });

      if (!prompt) return;

      // Snailer CLI 실행
      vscode.window.withProgress({
        location: vscode.ProgressLocation.Notification,
        title: 'Snailer 실행 중...',
        cancellable: false
      }, async (progress) => {
        return new Promise((resolve, reject) => {
          exec(`snailer "${prompt}"`, (error, stdout, stderr) => {
            if (error) {
              vscode.window.showErrorMessage(`Snailer 에러: ${stderr}`);
              reject(error);
            } else {
              vscode.window.showInformationMessage('✅ 완료!');
              resolve(stdout);
            }
          });
        });
      });
    }
  );

  context.subscriptions.push(disposable);
}
```

**어디서 시작할까요?**
- [ ] VS Code Extension API 학습
- [ ] 간단한 프로토타입 제작
- [ ] 이슈 열어 아이디어 공유

**라벨**: `ecosystem`, `integration`, `vscode`

---

## 시작하기

### 필수 준비물

#### 1. Git & GitHub 계정

```bash
# Git 설치 확인
git --version  # 2.x 이상

# GitHub 계정 설정
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

#### 2. 텍스트 에디터

**추천**:
- **VS Code** (가장 인기)
  - 확장: Markdown All in One, Prettier
- **Sublime Text**
- **Vim/Neovim**

#### 3. 패키징 기여 시 필요

```bash
# Node.js (npm 패키징)
node --version  # v18 이상
npm --version

# Homebrew (macOS/Linux 패키징)
brew --version
```

### 저장소 Fork & Clone

#### Step 1: Fork

1. https://github.com/your-org/snailer-cli 방문
2. 우측 상단 "Fork" 버튼 클릭
3. 본인 계정으로 Fork 생성

#### Step 2: Clone

```bash
# 본인의 fork를 clone
git clone https://github.com/YOUR_USERNAME/snailer-cli.git
cd snailer-cli

# Upstream 리모트 추가 (원본 저장소)
git remote add upstream https://github.com/your-org/snailer-cli.git

# 확인
git remote -v
# origin    https://github.com/YOUR_USERNAME/snailer-cli.git (fetch)
# origin    https://github.com/YOUR_USERNAME/snailer-cli.git (push)
# upstream  https://github.com/your-org/snailer-cli.git (fetch)
# upstream  https://github.com/your-org/snailer-cli.git (push)
```

---

## 개발 워크플로우

### GitHub Flow (간단한 워크플로우)

```
main 브랜치 (항상 배포 가능한 상태)
  │
  ├─ feat/add-korean-translation  ← 기능 브랜치
  │   └─ PR → 리뷰 → 병합
  │
  ├─ fix/npm-install-windows  ← 버그 수정 브랜치
  │   └─ PR → 리뷰 → 병합
  │
  └─ docs/improve-readme  ← 문서 브랜치
      └─ PR → 리뷰 → 병합
```

### 브랜치 명명 규칙

```
<타입>/<이슈번호>-<간단한-설명>
```

**타입**:
- `docs/` - 문서 변경
- `feat/` - 새 기능
- `fix/` - 버그 수정
- `ci/` - CI/CD 변경
- `packaging/` - 패키징 관련

**예시**:
```bash
git checkout -b docs/123-add-korean-readme
git checkout -b fix/456-npm-install-windows
git checkout -b packaging/789-update-homebrew-formula
```

### 커밋 메시지 (Conventional Commits)

**형식**:
```
<타입>(<스코프>): <제목>

<본문>

<푸터>
```

**타입**:
- `docs` - 문서 변경
- `feat` - 새 기능
- `fix` - 버그 수정
- `ci` - CI/CD 변경
- `chore` - 기타 (빌드, 패키지 등)

**예시**:

```bash
# ✅ 좋은 커밋 메시지
docs(readme): add Korean translation

Add Korean version of README.md for Korean-speaking users.
Includes all sections from the original English README.

Closes #123

# ✅ 좋은 커밋 메시지
fix(npm): resolve Windows installation path issue

Fixed issue where npm postinstall script failed on Windows
due to incorrect path separator. Changed from '/' to path.join().

Fixes #456

# ❌ 나쁜 커밋 메시지
update readme
fix bug
WIP
```

### 개발 사이클

#### 1️⃣ 이슈 찾기 또는 생성

```bash
# Good First Issue 찾기
# https://github.com/your-org/snailer-cli/labels/good-first-issue

# 또는 새 이슈 생성
# https://github.com/your-org/snailer-cli/issues/new
```

#### 2️⃣ 브랜치 생성 및 작업

```bash
# upstream에서 최신 코드 가져오기
git checkout main
git pull upstream main

# 새 브랜치 생성
git checkout -b docs/123-add-korean-readme

# 작업 진행
# (파일 수정...)

# 변경 사항 확인
git status
git diff

# 커밋
git add README.ko.md
git commit -m "docs(readme): add Korean translation

Add Korean version of README for Korean users.

Closes #123"
```

#### 3️⃣ Push 및 PR 생성

```bash
# 본인 fork에 push
git push origin docs/123-add-korean-readme

# GitHub에서 PR 생성
# (자동으로 "Compare & pull request" 버튼이 나타남)
```

#### 4️⃣ 리뷰 받기

```bash
# 리뷰어의 피드백을 받으면...

# 수정 작업
# (파일 수정...)

# 추가 커밋
git add .
git commit -m "docs(readme): address review feedback"
git push origin docs/123-add-korean-readme

# PR이 자동으로 업데이트됨
```

---

## 영역별 기여 가이드

### 📚 문서 기여

#### 문서 구조

```
docs/
├── README.md                    # 문서 인덱스
├── AGENT_ARCHITECTURE.md        # 에이전트 아키텍처
├── TOOL_SYSTEM.md               # 도구 시스템
├── ACE_SYSTEM.md                # ACE 자기학습 시스템
├── CONTRIBUTING.md              # 기여 가이드 (이 문서!)
├── DOCUMENTATION_STATUS.md      # 구현 상태 분석

```

#### 문서 작성 가이드

**1. Markdown 스타일**

```markdown
# 제목 1 (H1) - 문서당 1개만

## 제목 2 (H2) - 주요 섹션

### 제목 3 (H3) - 하위 섹션

**굵게**
*기울임*
`코드`

```

**2. 코드 블록**

````markdown
```bash
# 주석은 # 사용
snailer "명령어"
```

```rust
// Rust 코드
fn main() {
    println!("Hello!");
}
```
````

**3. 링크**

```markdown
# 상대 링크 (같은 저장소)
[CONTRIBUTING.md](./CONTRIBUTING.md)

# 절대 링크 (외부)
[Rust Book](https://doc.rust-lang.org/book/)

# 앵커 링크 (같은 문서 내)
[시작하기](#시작하기)
```

**4. 이미지**

```markdown
# 스크린샷 추가
![Snailer Demo](./images/demo.png)

# 외부 이미지
![Logo](https://snailer.ai/logo.png)
```

#### 문서 체크리스트

PR 제출 전 확인하세요:

- [ ] 모든 링크가 작동하는가?
- [ ] 코드 블록에 언어 지정했는가? (```bash, ```rust)
- [ ] 스크린샷이 선명한가?
- [ ] 오타가 없는가?
- [ ] 목차가 업데이트되었는가?

---

### ⚙️ CI/CD 기여

#### GitHub Actions 워크플로우

**파일 위치**: `.github/workflows/`

**기존 워크플로우**:
- `docs-check.yml` - 문서 링크 검증
- `release.yml` - 릴리스 자동화

**새 워크플로우 추가 예시**:

**목표**: PR에 자동으로 파일 변경 통계 코멘트 추가

`.github/workflows/pr-stats.yml`:
```yaml
name: PR Statistics

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  stats:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Calculate changed files
        id: stats
        run: |
          FILES_CHANGED=$(git diff --name-only origin/main...HEAD | wc -l)
          LINES_ADDED=$(git diff --numstat origin/main...HEAD | awk '{s+=$1} END {print s}')
          LINES_REMOVED=$(git diff --numstat origin/main...HEAD | awk '{s+=$2} END {print s}')

          echo "files=$FILES_CHANGED" >> $GITHUB_OUTPUT
          echo "added=$LINES_ADDED" >> $GITHUB_OUTPUT
          echo "removed=$LINES_REMOVED" >> $GITHUB_OUTPUT

      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const files = '${{ steps.stats.outputs.files }}';
            const added = '${{ steps.stats.outputs.added }}';
            const removed = '${{ steps.stats.outputs.removed }}';

            const body = `## 📊 PR 통계

            - 📁 변경된 파일: ${files}개
            - ➕ 추가된 줄: ${added}줄
            - ➖ 삭제된 줄: ${removed}줄

            ${files > 20 ? '⚠️ 변경된 파일이 많습니다. PR을 나누는 것을 고려해보세요.' : '✅ 적절한 크기의 PR입니다!'}
            `;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: body
            });
```

**테스트**:
1. 브랜치에서 PR 생성
2. Actions 탭에서 워크플로우 실행 확인
3. PR에 코멘트가 추가되는지 확인

---

## 코드 리뷰 & 병합

### PR 템플릿

PR 생성 시 자동으로 나타나는 템플릿:

```markdown
## 📝 변경 사항

<!-- 무엇을 변경했는지 간단히 설명해주세요 -->

## 🔗 관련 이슈

Closes #(이슈 번호)

## 🎯 변경 유형

- [ ] 📚 문서 (Documentation)
- [ ] 📦 패키징 (Packaging)
- [ ] 🔧 CI/CD
- [ ] 🎨 디자인/UX
- [ ] 🌍 번역 (Translation)

## ✅ 체크리스트

- [ ] 로컬에서 테스트했습니다
- [ ] 문서 링크가 모두 작동합니다
- [ ] 커밋 메시지가 Conventional Commits 형식입니다
- [ ] 관련 문서를 업데이트했습니다

## 📸 스크린샷 (선택)

<!-- UI/UX 변경인 경우 Before/After 스크린샷 추가 -->
```

### 리뷰 프로세스

**1. 자동 체크** (CI)
```
✅ Markdown 링크 체크
✅ 파일 크기 제한 (> 1MB 경고)
✅ PR 크기 체크 (> 500줄 경고)
```

**2. 코드 리뷰** (메인테이너)
- 문서: 명확성, 정확성, 문법
- 패키징: 플랫폼 호환성, 에러 처리
- CI/CD: 보안, 효율성

**3. 승인 & 병합**
```
✅ Approve → Squash & Merge
```

### 리뷰 받는 팁

**좋은 PR**:
- ✅ 작은 크기 (< 300줄)
- ✅ 명확한 설명
- ✅ 스크린샷 포함 (UI 변경)
- ✅ 테스트 완료

**나쁜 PR**:
- ❌ 여러 기능을 한 PR에 (분리하세요!)
- ❌ 설명 없음
- ❌ 테스트 안 함
- ❌ 무관한 파일 변경

---

## 커뮤니티 & 인정

### 기여자 인정

**README.md에 이름 추가**:
```markdown
## 🙏 기여자

특별히 감사드립니다:

- [@your-username](https://github.com/your-username) - 한국어 번역
- [@contributor2](https://github.com/contributor2) - npm 패키징 개선

```
**Contributors**:

#### 뱃지 & 레벨

| 기여 횟수 | 레벨 | 뱃지 |
|----------|------|------|
| 1-5 PR | 🥉 브론즈 | Bronze Contributor |
| 6-15 PR | 🥈 실버 | Silver Contributor |
| 16-30 PR | 🥇 골드 | Gold Contributor |
| 31+ PR | 💎 다이아몬드 | Diamond Contributor |

#### 개인 이력서에 추가
기여한 사항에 대해 이력서에 추가하여 오픈소스 활동을 채용담당자에게 어필할 수 있습니다. 

#### 스레드, Substack SNS 에 소개 
스레드 3.3k + 오픈소스 활동에 대해 상위 기여자를 선정하여 동의하에 
이름과 링크드인, 이력서 등을 원하는 정보를 공개할 수 있습니다. 

#### 미국 실리콘밸리 팔로알토 현지 인턴십 6개월 채용 공고 (2026년 2월전까지 서류 지원후 인터뷰 진행)   

- Job Title: Software Engineering Intern – 6-Month (Paid)
- Location: Palo Alto, California, USA (On-site)
- Duration: 6 months internship, starting 2026 Fall 
- Working Hours: ~ 40 hours/week (flexible between 30–40 hrs)
- Compensation: Hourly wage commensurate with Bay Area intern market (~USD $ 45 per hour)
- Visa Sponsorship: J1 Visa 
- Apply Timeline: ~ Feb 2026

- Proficiency in at least one systems language: Rust, Go, C++, or Swift (iOS).
- Prior experience or strong interest in CLI tool development and/or iOS app development.
- Clear English communication ability (spoken & written) and ability to collaborate with fast-paced teams.
- Enrolled in or recently graduated from a bachelor’s or master’s degree program in Computer Science, Software Engineering or related field.
- Completed or currently enrolled in the “Silicon Valley Survivor / Inflearn System Design” lecture series (or equivalent) — demonstrating your system-- design mindset and readiness for startup-scale engineering. (인프런 미국 달팽이 / 시스템 디자인 강의 수강생일 것)

### 커뮤니티 채널

- **GitHub Discussions**: 질문, 아이디어 공유
- **Discord**: 실시간 채팅 (준비 중)
---

## 자주 묻는 질문 (FAQ)

### Q: 코어 코드를 수정하고 싶은데요?

**A**: 코어 코드는 비공개입니다. 하지만 기능 제안은 환영합니다!

1. GitHub Issues에서 "Feature Request" 템플릿 사용
2. 상세한 사용 사례 및 예시 제공
3. 메인테이너가 검토 후 구현 여부 결정

### Q: 첫 기여로 무엇을 하면 좋을까요?

**A**: `good-first-issue` 라벨부터 시작하세요!

추천 순서:
1. 문서 오타 수정 (5분)
2. 예제 코드 추가 (30분)
3. 간단한 번역 (1-2시간)
4. 패키징 버그 수정 (2-4시간)

### Q: PR이 거절되면 어떡하나요?

**A**: 괜찮습니다! 배움의 기회입니다.

1. 거절 사유를 읽어보세요
2. 질문이 있으면 코멘트로 물어보세요
3. 수정 후 다시 제출하거나, 새로운 이슈를 시도하세요

### Q: 리뷰가 오래 걸려요

**A**: 보통 2-3일 내 리뷰됩니다.

- 1주일 이상: PR에 친절하게 핑(ping) 해주세요
- 긴급한 경우: 인프런 커뮤니티 또는 이메일

---

## 행동 강령

### 우리의 약속

모든 기여자가 존중받고 환영받는 환경을 만듭니다.

**✅ 권장**:
- 다양한 관점 존중
- 건설적 피드백
- 초보자 도움
- 실수 인정

**❌ 금지**:
- 차별적 언어
- 괴롭힘
- 개인 정보 무단 공개

**위반 신고**: opensource@snailer.ai

---

## 리소스

### 학습 자료

**Git & GitHub**:
- [GitHub Skills](https://skills.github.com/) - 무료 튜토리얼
- [Pro Git Book](https://git-scm.com/book/ko/v2) - Git 완벽 가이드

**Markdown**:
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)

**오픈소스 기여**:
- [First Contributions](https://github.com/firstcontributions/first-contributions)
- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)

### Snailer 문서

- [README.md](../README.md) - 프로젝트 소개
- [AGENT_ARCHITECTURE.md](./AGENT_ARCHITECTURE.md) - 아키텍처
- [TOOL_SYSTEM.md](./TOOL_SYSTEM.md) - 도구 시스템
- [ACE_SYSTEM.md](./ACE_SYSTEM.md) - 자기학습 시스템

---

## 마치며

**🎉 기여를 환영합니다!**

작은 기여도 큰 영향을 줍니다. 오타 수정 하나도, 번역 한 문장도 모두 소중합니다.
궁금한 점이 있으면 언제든 이슈를 열거나 Inflearn 인프런 또는 Github, 이메일에서 물어보세요!

---

<div align="center">

**Made with ❤️ by Snailer Contributors**

[Website](https://snailer.ai) • [Documentation](./README.md) • [Issues](https://github.com/your-org/snailer-cli/issues)

</div>
