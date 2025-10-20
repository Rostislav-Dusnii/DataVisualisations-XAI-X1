# File Guide - Quick Reference

This guide helps you navigate the project files and understand what each one does.

## 🚀 Getting Started? Read These First

1. **README.md** - Start here! Complete overview of the application
2. **QUICKSTART.md** - Step-by-step installation and first run
3. **app.R** - The actual Shiny application (if you want to see the code)

## 📱 Application Files

| File | Purpose | When to Use |
|------|---------|-------------|
| **app.R** | Main Shiny application | Run this to start the app, or edit to customize |
| **run_app.R** | Launch script | Use this to start the app from command line |
| **validate_app.R** | Validation tool | Run before deploying to check for errors |

## 📚 Documentation Files (Read Based on Your Needs)

### For Users
| File | What It Covers | Read If... |
|------|----------------|------------|
| **README.md** | Complete feature overview | You want to understand what the app does |
| **QUICKSTART.md** | Installation & first steps | You want to get started quickly |
| **EXAMPLES.md** | Usage workflows | You want to see example analyses |
| **UI_GUIDE.md** | Interface layout | You want to understand the UI design |

### For Deployers
| File | What It Covers | Read If... |
|------|----------------|------------|
| **DEPLOYMENT.md** | All deployment options | You want to deploy to production |

### For Developers
| File | What It Covers | Read If... |
|------|----------------|------------|
| **CONTRIBUTING.md** | Code guidelines & workflow | You want to contribute or extend |
| **PROJECT_SUMMARY.md** | Complete project details | You want a comprehensive overview |

## ⚙️ Configuration Files

| File | Purpose | Should I Edit? |
|------|---------|----------------|
| **DESCRIPTION** | R package metadata | Yes, to update version/author info |
| **.Rprofile** | Project R settings | Maybe, to change defaults |
| **LICENSE** | MIT License | No, unless changing license |
| **.gitignore** | Git ignore rules | Maybe, to add more ignore patterns |

## 📁 Directories

| Directory | Contents | Purpose |
|-----------|----------|---------|
| **data/** | README.md for custom data | Place custom datasets here |

## 🎯 Common Tasks - Which File?

### I want to...

**Run the application**
- Quick: `Rscript run_app.R`
- From R: Open `app.R` in RStudio and click "Run App"
- See: **QUICKSTART.md** for details

**Understand what the app does**
- Read: **README.md** first
- Then: **EXAMPLES.md** for practical examples
- Finally: **UI_GUIDE.md** for interface details

**Deploy to production**
- Read: **DEPLOYMENT.md**
- Consider: Docker, Shinyapps.io, or Shiny Server options

**Add a new dataset**
- Edit: **app.R** (see data/README.md for instructions)
- Reference: **CONTRIBUTING.md** for code style

**Add a new visualization type**
- Edit: **app.R** in the plot section
- Reference: **CONTRIBUTING.md** for guidelines

**Check if my changes broke anything**
- Run: `Rscript validate_app.R`
- Then: Test the app manually

**Contribute to the project**
- Read: **CONTRIBUTING.md** thoroughly
- Follow: Git workflow and code style guidelines

**Deploy with Docker**
- See: **DEPLOYMENT.md** Docker section
- You'll need: Dockerfile (example provided in DEPLOYMENT.md)

**Understand the XAI features**
- Read: **README.md** XAI section
- Try: **EXAMPLES.md** for practical XAI workflows
- Code: **app.R** lines 185-268 (XAI analysis section)

## 📊 File Sizes (Approximate)

| Category | Files | Total Lines |
|----------|-------|-------------|
| Application | 3 files | ~400 lines |
| Documentation | 8 files | ~1,200 lines |
| Configuration | 4 files | ~100 lines |
| **Total** | **15 files** | **~1,700 lines** |

## 🔍 Code Structure in app.R

If you're diving into the code, here's where to look:

```
app.R structure:
├── Lines 1-6:     Library imports
├── Lines 8-75:    UI definition
│   ├── Sidebar (controls)
│   └── Main panel (tabs)
├── Lines 77-303:  Server logic
│   ├── Data loading (reactive)
│   ├── Variable updates (observers)
│   ├── Main plot (renderPlotly)
│   ├── XAI analysis (renderPrint)
│   ├── Feature importance (renderPlot)
│   └── Data table (renderTable)
└── Line 303:      shinyApp() call
```

## 💡 Pro Tips

1. **New to Shiny?** Start with README.md, then run the app to see it in action
2. **Want to customize?** Read CONTRIBUTING.md for code guidelines
3. **Deploying?** DEPLOYMENT.md has everything you need
4. **Stuck?** Check QUICKSTART.md troubleshooting section
5. **Adding features?** Look at CONTRIBUTING.md examples section

## 📖 Reading Order by Role

### End User (Just Want to Use It)
1. README.md
2. QUICKSTART.md
3. EXAMPLES.md
4. Run the app!

### Developer (Want to Extend It)
1. README.md
2. CONTRIBUTING.md
3. app.R (read the code)
4. PROJECT_SUMMARY.md

### DevOps (Want to Deploy It)
1. README.md
2. DEPLOYMENT.md
3. Check DESCRIPTION for dependencies
4. Review .Rprofile for settings

### Researcher (Want to Understand XAI)
1. README.md (XAI section)
2. EXAMPLES.md (XAI examples)
3. app.R (XAI analysis code)
4. Try it with different datasets!

---

**Need More Help?**
- All files are well-commented
- Each major file has a clear purpose
- Documentation is comprehensive

Start with README.md and follow the links! 🚀
