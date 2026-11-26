---
title: Blog创建说明
date: 2026-11-26 16:00:00
tags:
  - 说明
categories:
  - 说明
---
# ***这里是博客创建说明*** 
我在这里会详细介绍此博客是如何创建的（待完成中）
## **1：所使用的AI大模型及智能体**
引导步骤及过程的为 ==🟠Gemini(Hydrogen 模型)==
进行实际代码与样式优化的为 ==🟠Antigravity（调用 Gemini 3.8 Flash High）==

## **2：构建技术方案**
Jamstack(静态站点架构)

| 维度    | 当前配置与技术方案                                                      | 说明                                     |
| ----- | -------------------------------------------------------------- | -------------------------------------- |
| 博客框架  | Hexo `v8.1.2` (Node.js 静态站点生成器)                                | 纯静态渲染，速度极快                             |
| 博客主题  | Butterfly `v5.7.2`                                             | 极高可定制性、生态成熟、颜值高                        |
| 托管平台  | Cloudflare Pages (`https://sumiya-blog.pages.dev/`)            | 全球 CDN 边缘加速，免备案，零成本                    |
| 代码托管  | GitHub (`https://github.com/Sumiya114/my-blog`)                | `main` 分支触发 Cloudflare 自动构建            |
| 写作与图床 | Obsidian + `obsidian-image-auto-upload-plugin` + Cloudflare R2 | 本地 Markdown 写作 + 粘贴自动上传 R2 独立对象存储，非常规范 |
| 发布流程  | publish.ps1 / 推送github.bat                                     | 本地一键构建校验、提交并推送到 GitHub                 |
| 构建状态  | 验证通过 (`hexo generate` 8 个页面耗时 ~57ms)                           | 零报错，配置语法正确                             |
### 此架构的优势
- **1：0 成本**：
    - GitHub 免费私有/公有代码托管；
    - Cloudflare Pages 免费无限构建流量与全球 CDN 加速；
    - Cloudflare R2 享有 10GB 免费存储且**出站流量费完全为 0**（对比阿里云 OSS / 腾讯云 COS / AWS S3，完全不用担心恶意刷流量欠费）；
    - 你不需要掏任何钱去买云服务器（VPS）或域名就能稳定运行。
- **2：极高的安全性与零运维**：
    - 页面都是纯静态 HTML/CSS/JS，没有后端 PHP、Java 服务，也没有 MySQL 数据库，根本不存在 SQL 注入或服务器被入侵挖矿的风险。
    - 不需要维护 Linux 系统、Nginx 证书更新或 Docker 容器。
- **3：极佳的性能体验**：
    - 经由 Cloudflare 全球边缘 CDN 节点加速，自动配备 HTTP/3、TLS 1.3，首屏打开速度极快。
- **4：数据所有权与防绑架**：
    - 所有博文都是本地纯文本 Markdown 文件，所有素材都在自己手里。即便未来你想换成 Hugo、Astro 或 VitePress，文章内容也可以无缝平迁。
- **5：工作流顺畅**：
    - 搭配 publish.ps1 和 推送github.bat，在 Obsidian 中写完文章后双击即可完成“本地编译验证 →\to→ 自动提交 Git →\to→ 推送到 GitHub →\to→ Cloudflare 自动部署更新”，使用体验非常丝滑。