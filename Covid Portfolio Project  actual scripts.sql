-- selecting data that we are going to be using

select location, date, total_cases, total_deaths, population
from CovidDeaths
order by 1,2

-- loking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeatPercentage
from CovidDeaths
where location like '%states%' and continent is not null
order by 1,2


-- Looking at the total cases vs Population 
-- show what percentage of population got covid in Azerbaijan
select location, date, total_cases, population, (total_cases/population)*100 as	PercentPopulationinfected
from CovidDeaths
where location like '%azerbaijan%' and continent is not null
order by 1,2



--looking at countries with higehst infection rate compared to population
select location, max(total_cases) as higehstInfectionCount, population, Max((total_cases/population)*100) as PercentPopulationInfected
from CovidDeaths
--where location like '%states%'
group by population, location
order by 1,2

-- Showing the countries with the higehst count per population
select location,  max(cast(Total_deaths as int)) as totalDDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by totalDDeathCount desc


--let's break things down by continent

select location, max(cast(Total_deaths as int)) as totalDDeathCount
from CovidDeaths
where continent is  null
group by location
order by totalDDeathCount desc


--showing the continent with the highest death count
select continent, max(cast(Total_deaths as int)) as totalDDeathCount
from CovidDeaths
where continent is not null
group by continent
order by totalDDeathCount desc





--Gl0bal Numbers


select  date, Sum(new_cases)as totalcases, Sum(cast (new_deaths as int))as totaldeaths, Sum(cast(new_deaths as int ))/sum(new_cases)*100 as DeatPercentage
from CovidDeaths
--where location like '%states%' 
where  continent is not null
group by date
order by 1,2


--use cte

with PopulationvsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated) 
as 
(
select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations ))  over (partition by dea.location order by dea.location , 
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.Location=vac.Location
and dea.date=vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100
from  PopulationvsVac


--temp table


Create table #PercentPopulationVaccinated
( 
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
 
 insert into #PercentPopulationVaccinated
 select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations ))  over (partition by dea.location order by dea.location , 
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.Location=vac.Location
and dea.date=vac.date
where dea.continent is not null
select *, (RollingPeopleVaccinated/Population)*100
from  #PercentPopulationVaccinated




--creating view to store data for later visualiations

create view PercentPopulationVaccinated as
  select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations ))  over (partition by dea.location order by dea.location , 
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.Location=vac.Location
and dea.date=vac.date
where dea.continent is not null


