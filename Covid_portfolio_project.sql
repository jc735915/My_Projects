select * 
from CovidDeaths$
where continent is not null
order by 3,4

select * 
from CovidVaccinations$
order by 3,4

-- getting data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 3,4

--Looking at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from CovidDeaths$
order by 1,2

-- looking at total cases vs total population

select location, date, total_cases, population, (total_cases/population)*100 as population_infected_percentage
from CovidDeaths$
order by 1,2

--looking at countries with highest infection rate compared to population

select location, Max(total_cases) as highest_infection_count, population, Max((total_cases/population))*100 as population_infected_percentage
from CovidDeaths$
group by location, population
order by population_infected_percentage desc

-- showing countries with highest death count per population

select location, MAX(cast(total_deaths as int)) as total_death_count
from CovidDeaths$
where continent is not null
group by location
order by total_death_count desc

-- let's break things down by continent

-- showing continents with the highest death count per population 

select continent, MAX(cast(total_deaths as int)) as total_death_count
from CovidDeaths$
where continent is not null
group by continent
order by total_death_count desc

-- Global numbers 

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) 
as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from CovidDeaths$
where continent is not null 
--Group by date
order by 1,2

-- Looking at Total Population vs vaccinations 

with PopvsVac( Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinate0d/population)*100
from CovidDeaths$ as d
join CovidVaccinations$ as v 
on d.location = v.location and 
d.date = v.date 
where d.continent is not null 
--order by 2,3
)

select *, (Rollingpeoplevaccinated/Population)*100 from PopvsVac

-- Temp Table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinate0d/population)*100
from CovidDeaths$ as d
join CovidVaccinations$ as v 
on d.location = v.location and 
d.date = v.date 
where d.continent is not null 

select *, (Rollingpeoplevaccinated/Population)*100 
from #PercentPopulationVaccinated

-- creating view to store data for later visualizations 

create view PercentPopulationVaccinated as 
select d.continent, d.location, d.date, d.population, v. new_vaccinations, 
SUM(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinate0d/population)*100
from CovidDeaths$ as d
join CovidVaccinations$ as v 
on d.location = v.location and 
d.date = v.date 
where d.continent is not null 

select * from PercentPopulationVaccinated



















p




