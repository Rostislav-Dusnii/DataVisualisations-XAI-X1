# Deployment Options for Data Visualizations XAI Application

## Local Deployment

### Option 1: RStudio
1. Open `app.R` in RStudio
2. Click "Run App" button
3. Application will open in viewer pane or browser

### Option 2: R Console
```r
shiny::runApp()
```

### Option 3: Command Line
```bash
Rscript run_app.R
```

## Remote Deployment

### Shinyapps.io (Cloud)

1. **Install rsconnect package**:
```r
install.packages("rsconnect")
```

2. **Configure your account**:
```r
library(rsconnect)
rsconnect::setAccountInfo(
  name = "your-account-name",
  token = "your-token",
  secret = "your-secret"
)
```

3. **Deploy the app**:
```r
rsconnect::deployApp(appDir = ".")
```

### Shiny Server (Self-hosted)

1. **Install Shiny Server** on your Linux server
2. **Copy app files** to `/srv/shiny-server/your-app-name/`
3. **Access** via `http://your-server:3838/your-app-name/`

Configuration file (`/etc/shiny-server/shiny-server.conf`):
```
server {
  listen 3838;

  location /xai-visualizations {
    app_dir /srv/shiny-server/xai-visualizations;
    log_dir /var/log/shiny-server;
  }
}
```

### Docker Deployment

Create a `Dockerfile`:
```dockerfile
FROM rocker/shiny:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev

# Install R packages
RUN R -e "install.packages(c('shiny', 'ggplot2', 'plotly'), repos='https://cran.rstudio.com/')"

# Copy app files
COPY app.R /srv/shiny-server/
COPY data/ /srv/shiny-server/data/

# Expose port
EXPOSE 3838

# Run app
CMD ["/usr/bin/shiny-server"]
```

Build and run:
```bash
docker build -t xai-visualizations .
docker run -p 3838:3838 xai-visualizations
```

## Environment Variables

You can configure the app using environment variables:

```r
# In app.R, add at the top:
port <- Sys.getenv("SHINY_PORT", "3838")
host <- Sys.getenv("SHINY_HOST", "0.0.0.0")
```

## Performance Optimization

For large datasets:
- Use data sampling (already implemented for diamonds dataset)
- Enable caching with `bindCache()`
- Use `reactiveVal()` instead of `reactive()` where appropriate
- Consider using `plotly_build()` for complex plots

## Security Considerations

When deploying publicly:
1. Use HTTPS/SSL certificates
2. Implement authentication if needed (e.g., `shinymanager` package)
3. Limit file upload sizes
4. Sanitize user inputs
5. Regular updates of dependencies

## Monitoring

Monitor your app with:
- Shiny Server logs: `/var/log/shiny-server/`
- Application logs within the app
- Server resource usage (CPU, RAM)
- Response times and user activity

## Scaling

For high traffic:
1. Use load balancers
2. Deploy multiple instances
3. Use RStudio Connect or Shiny Proxy
4. Optimize reactive expressions
5. Use `req()` to prevent unnecessary calculations
