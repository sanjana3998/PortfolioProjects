select *
 From PortfolioProject..covidDeaths
 where continent is not null
 order by 3,4

 --select *
 --From PortfolioProject..CovidVaccinations
 --order by 3,4

 select location, date, total_cases, new_cases, total_deaths, population 
 From PortfolioProject..covidDeaths
 where continent is not null
 order by 1, 2

 select location, date, total_cases,  total_deaths, (total_cases/total_deaths)*100 as deathpercentage
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
  order by 1, 2

  -- total_cases vs population

  select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
  order by 1, 2

  -- countries with highest infected rate compared to population

 select location,population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as
  PercentPopulationInfected
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
 group by location, population
 order by PercentPopulationInfected desc


 -- countries with highest death count per population

 select location, MAX(cast(total_deaths as int)) as totaldeathCount
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
 group by location
 order by totaldeathCount desc


 -- break things by continents

 select continent, MAX(cast(total_deaths as int)) as totaldeathCount
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
 group by continent
 order by totaldeathCount desc

 --continent with highest deathcount

 select continent, MAX(cast(total_deaths as int)) as totaldeathCount
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
 group by continent
 order by totaldeathCount desc

 --global numbers

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
 From PortfolioProject..covidDeaths
 --where location like '%india%'
 where continent is not null
-- group by date
  order by 1, 2

--TOTAL POPULATION VS VACCINATIONS

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
From portfolioProject..CovidDeaths dea
Join portfolioProject..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
  where dea.continent is not null
  ORDER by 2,3



 
 
 with popvsvac ( continent,date,population,location , new_vaccinations, rollingpeoplevaccinated)
  as
(
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
From portfolioProject..CovidDeaths dea
Join portfolioProject..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
  where dea.continent is not null
--  ORDER by 2,3
  )
  select * ,(rollingpeoplevaccinated/population) *100
  from popvsvac


  --TEMP TABLE

DROP TABLE if exists #percentpopulationvaccinated
 CREATE table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )
 
 INSERT INTO #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
From portfolioProject..CovidDeaths dea
Join portfolioProject..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
 -- where dea.continent is not null
--  ORDER by 2,3

select * ,(rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


-- view to store data for visualizatioN


Create View percentpopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date)as rollingpeoplevaccinated
From portfolioProject..CovidDeaths dea
Join portfolioProject..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
  where dea.continent is not null
--ORDER by 2,3

select *
from percentpopulationvaccinated