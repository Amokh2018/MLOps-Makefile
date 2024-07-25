
# Environment Setup ------------------------------
install:
	@echo "install requirements in MLOps-env";\
    . start.sh; \
    pip install -r requirements.txt;
init:
	@echo "Creating Python virtual environment 'MLOps-env"; \
	python3 -m venv ../ENVS/MLOps-env; \
	@echo "Activating Python virtual environment 'MLOps-env"; \
	. start.sh; 
	@echo "Installing requirements"; \
	pip3 install -r requirements.txt; \
	echo "Initialization complete"


# Data Management ------------------------------
download_data:
	python $(SRC_DIR)/download_data.py --output $(DATA_DIR)

preprocess_data: download_data
	python $(SRC_DIR)/preprocess_data.py --input $(DATA_DIR) --output $(DATA_DIR)/processed
	
# Model Training ------------------------------
train_model: preprocess_data
	python $(SRC_DIR)/train_model.py --data $(DATA_DIR)/processed --output $(MODELS_DIR)

evaluate_model: train_model
	python $(SRC_DIR)/evaluate_model.py --model $(MODELS_DIR) --data $(DATA_DIR)/processed

# Cleaning up ------------------------------
# Clean Intermediate Files:
clean:
	rm -rf $(DATA_DIR)/processed
	rm -rf $(MODELS_DIR)



# Model Deployment ------------------------------
# Run FastAPI Application:
run_api:
	uvicorn $(SRC_DIR).api:app --host 0.0.0.0 --port 8000

# Build Docker Image:
build_docker:
	docker build -t $(PROJECT_NAME):latest .
# Run Docker Container:
run_docker:
	docker run -p 8000:8000 $(PROJECT_NAME):latest

# Run full workflow
all: init preprocess_data train_model evaluate_model build_docker run_docker

