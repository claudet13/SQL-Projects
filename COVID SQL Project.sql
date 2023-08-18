SELECT *
FROM [ATL Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT *
FROM [ATL Portfolio Project]..CovidVaccinations
ORDER BY 3,4

-- Select the data that we will be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [ATL Portfolio Projects]..CovidDeaths


-- Looking at total cases vs total deaths
-- Likelihood of death
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS death_percentage
FROM [ATL Portfolio Projects]..CovidDeaths
--WHERE location = 'Rwanda'
ORDER BY 1,2


-- Looking at total cases vs population
-- Shows percentage of the population that got infected
SELECT location, date, total_cases, population, ROUND((total_cases/population)*100, 5) AS infection_percentage
FROM [ATL Portfolio Project]..CovidDeaths
WHERE location = 'Rwanda'
ORDER BY 1,2


-- Countries with highest infection rate compared to population
SELECT location, date, MAX(total_cases) AS HighestInfectionCount, population, ROUND(MAX((total_cases/population))*100, 2) AS PopulationPercentageInfected
FROM [ATL Portfolio Projects]..CovidDeaths
--WHERE location = 'Rwanda'
GROUP BY location, population, date
ORDER BY PopulationPercentageInfected DESC


-- Countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [ATL Portfolio Projects]..CovidDeaths
--WHERE location = 'Rwanda'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Let's break things down by continent
-- Showing continents with the highest death count
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [ATL Portfolio Projects]..CovidDeaths
--WHERE location = 'Rwanda'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, 
ROUND((SUM(CAST(new_deaths AS int))/SUM(new_cases)) * 100, 2) AS DeathPercentage
FROM [ATL Portfolio Projects]..CovidDeaths
--WHERE location = 'Rwanda'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


-- Looking at total population vs vaccination
-- Use CTE
WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY death.Location
ORDER BY death.location, death.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [ATL Portfolio Projects]..CovidDeaths death
JOIN [ATL Portfolio Projects]..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopVsVac


-- Using a TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY death.Location
ORDER BY death.location, death.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [ATL Portfolio Project]..CovidDeaths death
JOIN [ATL Portfolio Project]..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
--WHERE death.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- Creating VIEWS to store data for later visualisations
CREATE VIEW PercentPopulationVaccinated AS
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY death.Location
ORDER BY death.location, death.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [ATL Portfolio Project]..CovidDeaths death
JOIN [ATL Portfolio Project]..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL
--ORDER BY 2,3