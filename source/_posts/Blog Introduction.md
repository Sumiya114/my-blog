---
title: Blog创建说明
date: 2026-11-26 16:00:00
tags:
  - 说明
  - 博客
  - 技术
categories:
  - 说明
---

这里详细记录了个人博客 **SumiyaのBlog** 从零开始搭建、配置优化并上线的完整流程。整套方案**零成本、免服务器运维，支持 Obsidian 本地 Markdown 写作与独立图床**。

## 所使用的 AI 大模型及智能体

- **建站引导与流程规划**：Gemini（Hydrogen 模型）
- **代码调试与样式优化**：Antigravity（调用 Gemini 3.8 Flash (High) 与 Gemini 4 Hydrogen 模型）

---

## 一、整体架构与核心优势

本项目采用经典的 **Jamstack（静态站点架构）**，所有文章内容由本地 Markdown 与 Git 掌控，依托全球边缘节点分发：

| 模块 | 采用方案 | 核心作用 | 参考链接 |
| :--- | :--- | :--- | :--- |
| 博客框架 | **Hexo 8.1.2** | 将本地 `.md` 文章编译为纯静态网页 | [Hexo 中文官网](https://hexo.io/zh-cn/) |
| 外观主题 | **Butterfly 5.7.2** | 提供卡片式排版、暗黑模式、目录、搜索与评论支持 | [Butterfly 文档](https://butterfly.js.org/) |
| 代码托管 | **GitHub** | 托管源码与文章，推送即触发自动构建 | [GitHub](https://github.com/) |
| 网站托管 | **Cloudflare Pages** | 免费全球 CDN 加速、自动 HTTPS，不限静态流量 | [Cloudflare Pages](https://www.cloudflare.com/products/pages/) |
| 图床存储 | **Cloudflare R2** | 兼容 S3 协议，每月 10 GB 免费存储且出站零流量费 | [Cloudflare R2 定价](https://developers.cloudflare.com/r2/pricing/) |
| 写作与传图 | **Obsidian + PicGo** | 本地实时预览编写 `.md`，粘贴图片自动上传至 R2 | [Obsidian](https://obsidian.md/) / [PicGo](https://github.com/Molunerfinn/picgo) |

### 此架构的优势
1. **完全零成本**：GitHub 托管、Cloudflare Pages 构建分发与 R2 图床在个人博客用量内均免费，且 R2 出站流量零费用，无需担心恶意刷流量欠费。
2. **高安全与零运维**：纯静态 HTML/CSS/JS 部署，无数据库与后端服务，不存在注入漏洞，无需维护服务器与证书续期。
3. **极佳的访问性能**：依托 Cloudflare 全球边缘 CDN 节点，自带 HTTP/3 与 TLS 1.3，首屏加载迅速。
4. **数据完全自主**：所有文章均为本地纯文本 Markdown，未来可随时无痛迁移至 Hugo、Astro 或 VitePress 等其他框架。
5. **丝滑的写作流**：在 Obsidian 中写完文章后，双击脚本即可完成「本地编译校验 → 自动提交 Git → 推送 GitHub → Cloudflare 自动部署」。

---

## 二、第一阶段：准备基础环境与本地工具

### 1. 账号与运行环境
- 注册 **GitHub** 与 **Cloudflare** 账号。
- 安装 **Git** 客户端与 **Node.js（LTS 长期支持版）**（前往 [Node.js 官网](https://nodejs.org/zh-cn/download) 默认安装即可）。
- 在终端验证安装结果：
  ```powershell
  node -v
  npm -v
  git --version
  ```

### 2. 配置写作工具 Obsidian
1. 下载安装 [Obsidian](https://obsidian.md/)。
2. 进入 **设置 → 文件与链接**：关闭 **「使用 Wiki 链接（Use [[Wikilinks]]）」**，确保图片和内部引用生成 Hexo 通用的标准 Markdown 链接。
3. 安装自动传图插件：进入 **设置 → 第三方插件**，关闭安全模式并安装 **`Image auto upload plugin`**。
   - *备选方案*：若插件市场无法直连，可前往其 [GitHub Releases](https://github.com/renmu123/obsidian-image-auto-upload-plugin/releases) 下载 `main.js` 和 `manifest.json`，放入库目录的 `.obsidian/plugins/obsidian-image-auto-upload-plugin/` 下再启用。

### 3. 配置传图工具 PicGo
1. 下载安装最新版 [PicGo](https://github.com/molunerfinn/picgo/releases)。
2. 打开左侧 **Settings（设置）** 切换为简体中文，并确认 **`Set PicGo Server`** 已开启（默认监听 `127.0.0.1:36677`，用于接收 Obsidian 的自动上传请求）。

---

## 三、第二阶段：初始化 Hexo 与 Butterfly 主题

### 1. 初始化博客项目
在目标目录（如 `D:\Blog`）打开 PowerShell，依次执行（旧版 PowerShell 不支持 `&&` 拼接，建议逐行执行）：
```powershell
npm install -g hexo-cli
hexo init my-blog
cd my-blog
npm install
```

### 2. 安装主题与常用功能插件
在 `my-blog` 目录安装 Butterfly 主题、渲染器以及搜索、SEO、RSS 与字数统计插件：
```powershell
npm install hexo-theme-butterfly hexo-renderer-pug hexo-renderer-stylus --save
npm install hexo-generator-searchdb hexo-generator-sitemap hexo-generator-feed hexo-wordcount --save
cp node_modules/hexo-theme-butterfly/_config.yml _config.butterfly.yml
```
*(在 PowerShell 中 `cp` 执行成功时不会输出提示信息，无报错即表示复制成功。)*

### 3. 修改基础配置
打开根目录 **`_config.yml`**：
- 填写站点信息：`title`、`subtitle`、`description`、`keywords`、`author`、`language: zh-CN`、`url: https://sumiya-blog.pages.dev`。
- 将底部的 `theme: landscape` 改为 `theme: butterfly`。
- 在末尾补充搜索、Sitemap 与 RSS 插件配置：
  ```yaml
  search:
    path: search.xml
    field: post
    content: true
    format: html

  sitemap:
    path: sitemap.xml

  feed:
    type: atom
    path: atom.xml
    limit: 20
  ```

> **YAML 语法提醒**：所有冒号 `:` 后面**必须留一个英文空格**；缩进统一使用两个空格（不可用 Tab）；字符串若包含冒号等特殊符号需加引号。

### 4. 本地预览验证
```powershell
hexo clean
hexo s
```
浏览器访问 `http://localhost:4000/` 确认主题生效后，按 `Ctrl + C` 停止服务。

---

## 四、第三阶段：托管至 GitHub 与 Cloudflare Pages

### 1. 推送源码到 GitHub
在 GitHub 新建一个空仓库（如 `my-blog`，勿勾选 README），在本地执行：
```powershell
git init
git add .
git commit -m "init hexo blog"
git branch -M main
git remote add origin https://github.com/你的用户名/my-blog.git
git push -u origin main
```
- **常见避坑（`GH007` 邮箱隐私拦截）**：若 GitHub 开启了邮箱隐私保护导致推送被拒，可前往 [GitHub 邮箱设置](https://github.com/settings/emails) 复制 `@users.noreply.github.com` 隐私邮箱，执行以下命令修正作者信息后重新推送：
  ```powershell
  git config --global user.email "你的隐私邮箱@users.noreply.github.com"
  git commit --amend --reset-author --no-edit
  git push -u origin main
  ```

### 2. 绑定 Cloudflare Pages 自动部署
1. 登录 [Cloudflare 控制台](https://dash.cloudflare.com/) → **Workers 和 Pages → 创建应用程序**。
2. 点击页面下方的 **「继续前往 Pages」** 入口（注意区分 Workers 与 Pages），连接你的 GitHub 仓库 `my-blog`。
3. 填写构建配置：
   - **生产分支**：`main`
   - **框架预设**：`无`
   - **构建命令**：`npx hexo generate`
   - **构建输出目录**：`public`
4. 点击 **保存并部署**，等待约 1 分钟即可通过 `https://你的项目名.pages.dev` 访问站点。此后每次向 `main` 分支推送代码，均会自动触发更新。

---

## 五、第四阶段：配置 Cloudflare R2 图床与 PicGo 联动

### 1. 开通 R2 存储桶与 API 令牌
1. 在 Cloudflare 后台进入 **R2 对象存储**（需绑定外币卡或 PayPal 完成免费额度验证），新建存储桶（如 `blog-images`）。
2. 进入存储桶 **设置 → 公共开发 URL**，启用后记下生成的 `https://pub-xxxxxxxx.r2.dev` 域名。
3. 回到 R2 首页点击 **管理 R2 API 令牌 → 创建 API 令牌**，权限选择「对象读与写」，保存好 `Access Key ID`、`Secret Access Key` 和 S3 终结点地址。

> **提示**：`r2.dev` 属于官方提供的测试公开域名，存在访问速率限制。如果后续购买了独立域名，推荐在 R2 后台绑定自定义域名（如 `img.yourdomain.com`），即可解除限流并获得完整的 CDN 边缘缓存。

### 2. 配置 PicGo (`picgo-plugin-s3`)
1. 在 PicGo 的 **Plugins（插件设置）** 搜索并安装 `s3`（`picgo-plugin-s3`）。
2. 进入 **图床设置 → Amazon S3 → 新建配置**：
   - **应用密钥 ID / 应用密钥**：填入刚才保存的 API 令牌
   - **桶名**：`blog-images`
   - **上传文件路径**：`{year}/{month}/{md5}.{extName}`
   - **地区**：`auto`
   - **自定义节点**：`https://<你的AccountID>.r2.cloudflarestorage.com`（填写纯域名即可，末尾不要带桶名）
   - **ForcePathStyle**：设为 **`no`**（开启会导致 URL 多出一层桶名路径从而 404）
   - **自定义输出 URL 模板**：`https://pub-xxxxxxxx.r2.dev/{path}`
   - **Bucket 前缀**：`no`
3. 保存并设为默认图床。在 PicGo 底部将复制链接格式保持为 `Markdown`，即可在 Obsidian 中粘贴图片并自动替换为图床外链。
   - *关于图片压缩*：R2 拥有 10 GB 免费容量，个人博客传原图完全够用；若希望上传前自动压缩为 WebP，可改用原生支持压缩的 [PicList](https://github.com/Kuingsmile/PicList)。

---

## 六、第五阶段：内容管理与一键发布工作流

### 1. 隔离 Obsidian 配置，防止污染 Git 历史
无论将 Obsidian 仓库打开在 `my-blog/source` 还是 `my-blog/source/_posts`，都必须避免编辑器工作区状态（如 `workspace.json`）被反复提交到 Git 或被 Hexo 当成页面编译：
1. 在根目录 **`.gitignore`** 末尾追加：
   ```gitignore
   .obsidian/
   **/.obsidian/
   ```
2. 在根目录 **`_config.yml`** 的 `skip_render` 中添加：
   ```yaml
   skip_render:
     - "admin/**"
     - "**/.obsidian/**"
   ```

### 2. 规范文章 Front-Matter 与页面组织
- **文章写作规范**：在 `source/_posts/` 中新建 `.md` 文章时，**所有元数据（`title`、`date`、`tags`、`categories`）必须写在顶部的两道 `---` 之间**，否则会被 Hexo 当成正文渲染：
  ```yaml
  ---
  title: 文章标题
  date: 2026-11-26 19:45:00
  categories:
    - 技术折腾   # 分类建议每篇选 1 个互斥大栏目
  tags:
    - Hexo       # 标签每篇贴 2~4 个关键词即可
    - 建站
  ---
  ```
- **独立页面创建**：使用 `hexo new page <名称>` 创建不占首页文章流的独立页面，并在对应 `index.md` 的 Front-Matter 中指定 `type`：
  - 标签页：`source/tags/index.md`（`type: "tags"`）
  - 分类页：`source/categories/index.md`（`type: "categories"`）
  - 关于页：`source/about/index.md`（`type: "about"`）
  - 友链页：`source/link/index.md`（`type: "link"`），友链列表维护在 `source/_data/link.yml`

### 3. Windows 一键本地校验与发布脚本
在根目录新建 **`publish.ps1`**（先执行本地构建测试，确认无语法错误后再自动提交推送）：
```powershell
Set-Location $PSScriptRoot

Write-Host "1. Testing Hexo build locally..." -ForegroundColor Cyan
npx hexo clean
npx hexo generate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Please fix the error above before pushing." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes detected. Nothing to push." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

$msg = Read-Host "Enter commit note (or press Enter for auto timestamp)"
if ([string]::IsNullOrWhiteSpace($msg)) {
    $msg = "update blog $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

Write-Host "2. Pushing to GitHub..." -ForegroundColor Cyan
git add .
git commit -m "$msg"
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done! Cloudflare Pages will update in ~1 minute." -ForegroundColor Green
} else {
    Write-Host "Push failed! Check the message above." -ForegroundColor Red
}

Read-Host "Press Enter to exit"
```
同目录创建 **`推送github.bat`**，写入以下内容并可发送快捷方式到桌面，实现双击一键发布：
```bat
powershell -ExecutionPolicy Bypass -File "%~dp0publish.ps1"
```

---

## 七、进阶功能配置与后续扩展

### 1. 已启用的核心增强特性（`_config.butterfly.yml`）
- **导航与社交**：`menu` 已开启首页、归档、标签、分类、友链、关于；`social` 已挂载 GitHub 与 `/atom.xml` RSS 订阅。
- **Giscus 评论系统**：将 GitHub 仓库设为 Public 并在仓库 Settings 开启 **Discussions**，即可在 `_config.butterfly.yml` 中配置 `comments.use: Giscus` 与对应的 `repo_id` / `category_id` 实现零后端评论区。
- **站内本地搜索**：配合 `hexo-generator-searchdb`，设置 `search.use: local_search` 即可实现秒级前端关键词检索。
- **阅读体验与性能优化**：
  - 开启 `wordcount`（显示文章字数与预计阅读耗时）与 `subtitle` 打字机副标题特效；
  - 开启 `preloader`（顶部 Pace 进度条）、`pjax`（无刷新切页）、`instantpage`（悬停预加载）与 `lazyload`（图片懒加载），大幅提升访问流畅度；
  - 在 `font:` 中指定全局正文字号 `16px`、代码字号 `14px`，并在侧边栏开启 `runtime_date` 统计建站天数；
  - 在 `source/robots.txt` 中声明爬虫规则并关联 `sitemap.xml`，方便搜索引擎收录。

### 2. 未来可按需扩展的方向
- **自定义独立域名**：在 Cloudflare Pages 绑定自购域名后，记得同步更新 `_config.yml` 中的 `url:` 与 `source/robots.txt` 中的 Sitemap 地址。
- **固定短链接防乱码**：中文文件名默认会被编码成 `%E6%...` 形式，未来若文章增多，可安装 `hexo-abbrlink` 插件为每篇文章生成永久短数字链接。
- **网页端轻量编辑**：临时在外没有电脑环境时，直接在浏览器访问 `https://github.dev/Sumiya114/my-blog` 即可使用网页版 VS Code 在线改稿提交，或按需接入 [Decap CMS](https://decapcms.org/docs/intro/)。
- **音乐与媒体嵌入**：可在 `_config.butterfly.yml` 的 `inject:` 中引入 [APlayer](https://github.com/diygod/aplayer)（需为 R2 配置 CORS），或在文章中直接粘贴 Spotify / 网易云的官方嵌入代码（Embed）。
