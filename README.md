# DataVisualisations-XAI-X1 project

A modular service designed for users who want to explore performance of different AI models with custom datasets. 
At current state the service allows you to:

1. Import your custom dataset of popular tabular formats (or use a default one to study the service)
2. Modify the column types of the dataset and review it in different formats
3. Define target and feature columns
4. Explore the imported dataset with different visualisations to get insights about it's patterns before machine learning
5. Train a list of supported models of different frameworks like h2o and mlr with the dataset
6. Review the predictions and metrics comparison between the trained models
7. Save the models locally
8. Explore models internal patterns with different visualisations like feature performance or ceteris paribus graphs
9. Talk to chat bot assistant to get human readable specific explanations of all the processes

Every listed above functionality - is a particular section of the app. Combined they form a pipeline, that is designed to answer questions, like:
- Which model performs the best under certain circumstance?
- How the model internally produces the result, what are its' main leverages?
- Can I recieve non-technical or specific explanations depending on my questions about the process?

# Run the service

At first, ensure you have:
* **R** installed
* **renv** installed (`install.packages("renv")`)
* **make** package available on your system

## Shortcut

1. Clone the repository

!!Note - For Unix-based system run the commands from project root, for windows run them from "windows_makefile" folder

2. Add ".env" file by copying the [example.env](example.env) and inserting your values.

3. Restore dependencies:

   ```bash
   make restore
   ```
4. Run entry script:

   ```bash
   make run_shiny script=app/entry.R
   ```
5. Open [localhost](http://127.0.0.1:8000) in your browser

---

For alternative ways to run the app or documentation of the commands read the [setup and configurations docs](documentation/setup_and_configurations.md)

For explanations of the internal data flows in the service proceed to the [data usage documentation](documentation/data_usage.md) 