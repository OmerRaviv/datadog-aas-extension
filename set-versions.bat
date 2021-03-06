
REM Set these version variables and run the script to change all the files which need version updates

REM The site extension version
set major=0
set minor=3
set patch=2
set version_postfix=-prerelease

REM The agent version
set agent_version=7.18.1

REM The dotnet tracer version
set tracer_version=1.17.0

REM *************************************************************
REM All of the below code updates versions in files, do not touch
REM *************************************************************

set gitlab_yml=.gitlab-ci.yml
set version_regex=[0-9]+\.[0-9]+\.[0-9]+[\-a-zA-Z]*
powershell -Command "(gc .\%gitlab_yml%) -replace '%version_regex%.+windows-tracer-home.zip', '%tracer_version%/windows-tracer-home.zip' | Out-File -encoding ASCII .\%gitlab_yml%"
set version_regex=[0-9]+\.[0-9]+\.[0-9]+[\-\.a-zA-Z0-9]*
powershell -Command "(gc .\%gitlab_yml%) -replace 'agent-binaries-%version_regex%-1-x86_64.zip', 'agent-binaries-%agent_version%-1-x86_64.zip' | Out-File -encoding ASCII .\%gitlab_yml%"

set nuget_replacement=%major%.%minor%.%patch%%version_postfix%

set nuget_files=Datadog.Development.AzureAppServices.nuspec Datadog.AzureAppServices.nuspec

(for %%f in (%nuget_files%) do (
	powershell -Command "(gc .\%%f) -replace '%version_regex%', '%nuget_replacement%' | Out-File -encoding ASCII .\%%f"
   echo/
)) > set-versions-log.txt

set path_regex=[0-9]+_[0-9]+_[0-9]+
set path_replacement=%major%_%minor%_%patch%

set path_files=content\applicationHost.xdt content\install.cmd content\Agent\datadog.yaml content\Agent\dogstatsd.yaml

(for %%f in (%path_files%) do (
	powershell -Command "(gc .\%%f) -replace '%path_regex%', '%path_replacement%' | Out-File -encoding ASCII .\%%f"
   echo/
)) > set-versions-log.txt
