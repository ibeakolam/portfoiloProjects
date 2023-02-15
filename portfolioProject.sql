select *
from portfolioProject..CovidDeaths$
order by 3,4

--select *
--from portfolioProject..CovidDeaths$
--order by 3,4


select location,date, total_cases, new_cases, total_deaths, population
from portfolioProject..CovidDeaths$


select location,date, total_cases, new_cases, total_deaths, population
from portfolioProject..CovidDeaths$
order by 1,2

--looking at Total cases vs Total death

--Shows the likelyhood of di

select location,date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from portfolioProject..CovidDeaths$
--where location like '%state%'
order by 1,2

--Looking at Total Cases vs Poupulation
--shows what percentage of population got covid

select location,date, total_cases,  population, (total_cases/population)*100 as deathpercentage
from portfolioProject..CovidDeaths$
where location like '%state%'
order by 1,2


--Looking at countries with the Highest infection Rate compared to popultion

select location, Max(total_cases) As HigestinfectonCount, Max(((total_cases/population)))*100 as percentPopulationInfected
from portfolioProject..CovidDeaths$
group by population,Location
order by percentPopulationInfected desc


 --Showing countries with the Highest Death count

select location, Max(cast(total_deaths as int)) As TotalDeathCount
from portfolioProject..CovidDeaths$
group by Location
order by TotalDeathCount desc

select *
from portfolioProject..CovidDeaths$
where continent is not Null
order by 3,4

	--BREAK THINGS DOWN BY CONTINENT

select location, Max(cast(total_deaths as int)) As TotalDeathCount
from portfolioProject..CovidDeaths$
WHERE continent is null
group by Location
order by TotalDeathCount desc

--Showing the continent with the Highest death count per population

select continent, Max(cast(total_deaths as int)) As TotalDeathCount
from portfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

select date, sum (new_cases), sum(cast (new_deaths as int)) 
from portfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
group by date
order by 1,2


select date, sum (new_cases) as total_cases, sum(cast (new_deaths as int)) As  total_deaths, sum(cast (new_deaths as int)) /SUM
(new_cases) * 100 as Deathpercentage
from portfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
group by date
order by 1,2


select sum (new_cases)as total_cases, sum(cast (new_deaths as int)) As  total_deaths, sum(cast (new_deaths as int)) /SUM
(new_cases) * 100 as Deathpercentage
from portfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Vaccinations


select *
from portfolioproject..CovidDeaths$ dea
join portfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject..CovidDeaths$ dea
join portfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--  (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths$ dea
join portfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is null
order by 2,3

-- Use CTE
with popvsVac (Cotinent, Location, Date, Population, new_vaccinations, RollingPepoleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--  (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths$ dea
join portfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is null
--order by 2,3
)
select *, (RollingPepoleVaccinated/population)*100
from popvsVac






--TEMP TABLE

create table #PercentagePopulationVaccinated
(
continent nvarchar (255),
locaion nvarchar(255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #percentPopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--  (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths$ dea
join portfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is null
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100
from #percentPopulationvaccinated


--Creating View to store Data for later Vizualizations

create view  percentagepopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--  (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths$ dea
join portfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is null
--order by 2,3

select *
from percentagepopulationvaccinated