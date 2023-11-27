use [Portfolio_project] EXEC sp_changedbowner 'sa'
Select *
From Portfolio_project.dbo.CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From Portfolio_project.dbo.CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio_project.dbo.CovidDeaths
order by 1,2

--Lokking at total cases vs total deaths
--Shows Likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_project.dbo.CovidDeaths
Where location LIKE '%kingdom%'
order by 1,2

-- Looking at total cases vs population
Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From Portfolio_project.dbo.CovidDeaths
--Where location LIKE '%kingdom%'
order by 1,2

--Looking at countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPoulationInfected
From Portfolio_project.dbo.CovidDeaths
--Where location LIKE '%kingdom%'
Group by population, location
order by PercentPoulationInfected desc

--Looking at the number of deaths
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio_project.dbo.CovidDeaths
Where continent is not null
--Where location LIKE '%kingdom%'
Group by  location
order by TotalDeathCount desc

--Deaths by continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio_project.dbo.CovidDeaths
Where continent is not null
--Where location LIKE '%kingdom%'
Group by  continent
order by TotalDeathCount desc

--Showing continets with highest death counts
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio_project.dbo.CovidDeaths
Where continent is not null
--Where location LIKE '%kingdom%'
Group by  continent
order by TotalDeathCount desc

--Global Numbers
Select  date, SUM(new_cases), SUM(cast(new_deaths as int)), (SUM(cast(new_deaths as int))/ SUM(new_cases))*100 as DeathPercentage
From Portfolio_project.dbo.CovidDeaths
where continent is not null
Group By date
order by 1,2

--Total pop v Vaccinations

SELECT dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations, 
SUM(cast(dea.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, dea.date) as RolllingPeopleVaccinated,

FROM Portfolio_project.dbo.CovidVaccinations dea
JOIN Portfolio_project.dbo.CovidDeaths vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2,3


--USE CTE
With PopvsVac (Continent, Lovation, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations, 
SUM(cast(dea.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, dea.date) as RolllingPeopleVaccinated,

FROM Portfolio_project.dbo.CovidVaccinations dea
JOIN Portfolio_project.dbo.CovidDeaths vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
SELECT *
From PopvsVac

--TEMP Table
Create Table ~PercentPopulationVaccinated
(
Continent

--Creating view for later visualizations
CREATE VIEW TotalDeceasedED as
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio_project.dbo.CovidDeaths
Where continent is not null
--Where location LIKE '%kingdom%'
Group by  continent
--order by TotalDeathCount desc

SELECT *
FROM TotalDeceasedED