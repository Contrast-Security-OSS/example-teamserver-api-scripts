# Contrast Scripts

This repository holds a few example Python scripts that use Contrast's REST APIs.

## Requirements
- Python 3.10 (other versions _may_ work but are untested)
- Ability to install Python libraries from `requirements.txt`

## Setup
You can run these scripts locally with a Python install, or, in a container with the provided `Dockerfile`

### Container use
```bash
docker build . --tag contrast-scripts # Build the container
docker run -it contrast-scripts --env-file=contrast.env -v $PWD/output:/usr/src/app/output python <script.py> <...args...> # Run the container
```

### Local use
Use of a virtual environment is encouraged
```bash
python3 -m venv venv # Create the virtual environment
. venv/bin/activate # Activate the virtual environment
pip3 install -r requirements.txt # Install dependencies
. contrast.env # Setup environment
python3 <script.py> <args> # Run scripts
```

## Usage of available scripts

Each script **requires** the following environment variables at minimum:
- `CONTRAST__API__API_URL` - the URL to your Contast instance, e.g.: `https://contrast_instance.your_domain.tld/Contrast`
- `CONTRAST__API__API_KEY` - an API key with permission to access that instance
- `CONTRAST__API__AUTH_HEADER` - authorization header for a user with permission to access that instance (base 64 of `username:service_key`)

### Create application [`contrast_create_application.py`](contrast_create_application.py)

Creates an application with the specified name and language.

Note, it is not required to create an application up-front, as the agents will do that when loaded into a new application, however, it may be beneficial to create custom named applications, e.g. when merging. See [Knowledge Base](https://support.contrastsecurity.com/hc/en-us/articles/360060719052-How-to-create-a-custom-name-for-a-merged-group-of-Applications).

Requires additional options:
- Application name
- Language of application
- Organization ID

Full usage information:

```
usage: contrast_create_application.py [-h] -n APP_NAME -l {DOTNET,DOTNET_CORE,GO,JAVA,NODE,PHP,PYTHON,RUBY} -o ORG_ID [-c CODE] [-g [GROUPS ...]] [-m METADATA] [-t [TAGS ...]]

Create an application on Contrast.

options:
  -h, --help            show this help message and exit
  -n APP_NAME, --app-name APP_NAME, --application-name APP_NAME
                        Name of the application you want to create.
  -l {DOTNET,DOTNET_CORE,GO,JAVA,NODE,PHP,PYTHON,RUBY}, -language {DOTNET,DOTNET_CORE,GO,JAVA,NODE,PHP,PYTHON,RUBY}
                        Agent language for the application you want to create.
  -o ORG_ID, --org-id ORG_ID, --organization-id ORG_ID
                        ID of the organization to create this application in.
  -c CODE, --code CODE, --app-code CODE, --application-code CODE
                        Optional 'application code' / 'short name' for this application.
  -g [GROUPS ...], --groups [GROUPS ...]
                        Optional list of application access groups to add this application to. Group(s) must exist prior to the application for this to work.
  -m METADATA, --metadata METADATA
                        Optional key/value pairs of application metadata / custom fields to set on this application.
  -t [TAGS ...], --tags [TAGS ...]
                        Optional list of tags to add to this application.
```

### List applications to CSV [`contrast_applications_to_csv.py`](contrast_applications_to_csv.py)

Given a superadmin set of credentials, this script will loop through all organizations accessible on the TeamServer, listing applications and outputting a CSV file with the following information:

|application\_name   |application\_id     |application\_code   |parent\_application\_id|archived            |metadata\_appname   |metadata\_parentictoid|metadata\_appictoid |license             |score               |organization\_id    |organization\_name  |language            |created             |last\_seen          |tags                |total\_modules      |routes\_discovered  |routes\_exercised   |
|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
|WebGoat             |46da4e47\-d8f9\-404d\-abe7\-29a2baf22a80|                    |                    |False               |webgoat             |12345               |54321               |Licensed            |F                   |2139f92a\-c115\-4e05\-8b49\-c1f52df33a5d|Demo                |Java                |2022\-03\-02T16:08:00|2022\-03\-02T16:08:00|webgoat,demo,lab,intentionally-vulnerable|1                   |79                  |46                  |



### List vulnerabilities (traces) to CSV [`contrast_traces_to_csv.py`](contrast_traces_to_csv.py)

Given a superadmin set of credentials, this script will loop through all organizations accessible on the TeamServer, listing vulnerabilities and outputtting a CSV file with the following information:

|application\_name   |application\_id     |organization\_id    |organization\_name  |vuln\_uuid          |title               |type                |severity            |confidence          |impact              |status              |first\_time\_seen   |last\_time\_seen    |closed\_time        |
|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
|WebGoat      |46da4e47\-d8f9\-404d\-abe7\-29a2baf22a80|2139f92a\-c115\-4e05\-8b49\-c1f52df33a5d|Demo                |K3PU\-B3SN\-RY4O\-OOK0|SQL Injection from "account\_name" Parameter on "/WebGoat/attack" page|SQL Injection       |Critical            |High                |High                |Reported            |2022\-02\-18T11:21:00|2022\-03\-02T10:58:00|                    |

## Development Setup
Various tools enforce code standards, and are run as a pre-commit hook. This must be setup before committing changes with the following commands:
```bash
python3 -m venv venv # setup a virtual environment
. venv/bin/activate # activate the virtual environment
pip3 install -r requirements-dev.txt # install development dependencies (will also include app dependencies)
pre-commit install # setup the pre-commit hook which handles formatting
```
