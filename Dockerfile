# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements-docker.txt
RUN pip install --no-cache-dir -r requirements-docker.txt

# Expose port 8000 for the API
EXPOSE 8000

# Run the API when the container launches
CMD ["uvicorn", "src.api:app", "--host", "0.0.0.0", "--port", "8000"]
