Select * from [Portfolio Project]..CovidDeaths
order by 3,4

Select * from [Portfolio Project]..CovidVaccinations
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population 
from [Portfolio Project]..CovidDeaths
order by 1,2

--Total cases vs. Total Deaths
--Liklihood of dying if you lived in sample country during Covid 2020 to 2021
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Ratio
from [Portfolio Project]..CovidDeaths
where location like '%iran%' 
order by 1,2

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Ratio
from [Portfolio Project]..CovidDeaths
where location like '%Germany%' 
order by 1,2

--Total cases vs. population

Select location, date, total_cases, population,(total_cases/population)*100 as infected_population
from [Portfolio Project]..CovidDeaths
--where location like '%Germany%' 
order by 1,2


--Countries with highest infection rate compared to their population
Select location, population, MAX(total_cases) as Highest_infection_number, MAX((total_cases/population))*100 as Highest_infection_rate
From [Portfolio Project]..CovidDeaths
group by location, population
order by Highest_infection_rate desc


--Highest death count compare to population
Select location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as HighestDeathRate
From [Portfolio Project]..CovidDeaths
group by location, population
order by HighestDeathRate desc


--Highest death count based on country
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Group by location
order by TotalDeathCount desc

--Highest death count based on continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Group by continent
order by TotalDeathCount desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is Null
Group by location
order by TotalDeathCount desc

--Continents With the highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX((total_deaths/population))*100 as HighestDeathRate
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Group by continent
order by HighestDeathRate desc

--Global Info
Select sum(new_cases) as SumOfNewCases , sum(cast(new_deaths as int)) as SumOfDeaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as TotalDeaths
From [Portfolio Project]..CovidDeaths
Where continent is not Null
--Group by date
order by 1,2

Select sum(new_cases) as SumOfNewCases , sum(cast(new_deaths as int)) as SumOfDeaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as TotalDeaths
From [Portfolio Project]..CovidDeaths
Where continent is not Null



 --Join tow tables
 Select *
 from [Portfolio Project]..CovidDeaths dea
 join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date

-- Total population vs. vaccination
 Select dea.date, dea.continent, dea.location, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location, dea.date) as TotalVaccination,
-- TotalVaccination/dea.population
 from [Portfolio Project]..CovidDeaths dea
 join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not Null
order by 2,3


--Using CTE
With PopvsVacc (Continent, location, date,population, new_vaccinations, TotalVaccination)
as
(
-- Total population vs. vaccination
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location, dea.date) as TotalVaccination
-- TotalVaccination/dea.population
 from [Portfolio Project]..CovidDeaths dea
 join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not Null)
Select *, (TotalVaccination/population)*100 as Ratio
from PopvsVacc









Select location, date, SUM(cast(total_vaccinations as int)) as sumOf
from [Portfolio Project]..CovidVaccinations
Where continent is not null
Group by location, date

--Creating View for visualization
Create View XYZ as
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location, dea.date) as TotalVaccination
-- TotalVaccination/dea.population
 from [Portfolio Project]..CovidDeaths dea
 join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not Null
