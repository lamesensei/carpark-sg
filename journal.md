## Day 1

### Docker

Decided to start work by figuring out how to use docker. Found a handle guide at https://dev.to/hlappa/development-environment-for-elixir-phoenix-with-docker-and-docker-compose-2g17.

### Phoenix new

Following the guide, was wondering if I should go for --no-webpack, --no-html or just use the default. Went for the default -- thinking that I might expand the API in the future.

### Importing hdb carpark information

First batch of information is a static csv from https://data.gov.sg/dataset/hdb-carpark-information.

Created a Context & schema with mix phx.gen.json. Naming was abit weird.

- Context: Carparks
- Schema: Information (phoenix wouldnt let me use carpark for some reason)
- Table: carparks

For the fields, decided to mirror the columns/headers of the CSV. Added to addtional fields `lat` & `lon` to handle lat lon distance calculations later.

### seed.exs

Add csv dep, and tried to use Repo.insert_all (had used this in a prior project). Couldn't figure out how to insert_all with changeset. Gave up and used single insert instead.

### svy21

Had to convert the x and y coord fields provided in the csv from svy21 to WGS84. Used HTTPPoison to perform request to onemap api and used their converter.

### Availability

Now moving on to carpark availability on another gov api which updates every minute.

Decided to seperate the availability information on a seperate table.

- Context: Carparks
- Schema: Availability
- Table: carpark_availability

Once again, fields mirroring the response from the API, storing the entire carpark_info as a :array of :maps -- though that I would process the information (lots) when retrieving.

Noted a common key - car_park_no. Used that a foreign key to use Phoenix has_one and belongs_to relationship.

### mix task

Since updating the availability is more of real time thing -- decided to create a mix task to execute it. Copied most of the code from the hdb seeder. Fix a problem with the task stating that it couldnt find Repo as it has not started. https://elixirforum.com/t/create-mix-tasks-that-invoke-existing-modules-which-use-ecto/18232 solved my issue adding Mix.Task.run("app.start")

### foreign key woes

Inserting the availability data was not as smooth as the tutorials. Using a string foreign key meant that the defaults provided by belongs_to and has_one were invalid. Tinkered quite awhile with this until I stumbled upon https://elixirforum.com/t/help-with-using-string-foreign-keys/27429/2

Added a bunch of config atoms to the reference field in the migration until it worked. (still not sure which one did the trick)

> Note: docker setup has been very useful for reseting my DB or configs by restarting the container. Used to face many annoyance with modifying migrations during development. Docker has made that problem go away.

### Distance calculation

With both carpark information and availability data secured. Worked on calcing distance by using geo_calc dep. It has a simple distance_between function which compared two pairs of lat/lon values and produces a distance value. Having stored lat/lon value previously made calculating the distance easy. Followed with a enum_sort and now my carparks are sorted by nearest distance.

## Day 2

## Pagination

With the core functionaility of the api mostly in place, decided to work on pagination. I had used pagination in frameworks like laravel which provided it out of the box. A simple google search revealed that Phoenix doesnt have pagination baked in.

Thought it wouldnt be hard, just apply limit = page_page, offset = page. Nope. since availability data would change in realtime (if scheduled). The result page by offset would be totally wrong.

Took a look at scrinever_ecto and realised that pagination occured at query level. Implication -> sorting/filtering must happen at query level and not after data has been retrieved

### PostGIS

Search for how to sort sql by lat/lon and was presented with PostGIS. Seems like its the solution as it provided query functions for comparing distance between geographic points and more.

Thankfully there were hex packages for handling postgis (geo, geo_postgis).
Added the migration for adding the POSTgis extension.

Realised that I would need to change my postgres container. No issue, change db in docker-compose to use the latest postgis/postgis.

The transition wasn't smooth, my previous pg data was still present on the container -- the new postgres was complaining that there was a version mismatch. Modified the image to use postgis:12-master. Work liked a charm. I love docker.

Faced some issue adding the new postgrestypes for Geo.point but solved it eventually. adding new col geom to handle to sorting via sql.

### query

scrinever_ecto required a Ecto query. So now I could'nt use the the more simplified Repo/Schema methods. I've work with raw statements before -> just needed to understand syntax for Ecto.query

Managed to get the query right, retrieving Availablity joined to Information and ordering by Informations geom.point st_distance from input.

Since I was sorting via query, decided to add total_lots and available_lots as columns to Availability since I would using query to filter out lots == 0 instead of using code.

### Pagination II

With the query made, it was a simple process of converting query params into the Context method to use scrinever's paginate method. Also needed to modify the view files to handle the new data structure.

### Validate params.

Headache. Couldn't find any recommended way to validate query params. Firstly - most of validation guide on the docs occured on CRUD actions using Repo.insert/update functions and changeset.

Secondly - params were all strings. It was like some kind of chicken and egg problem trying to verify if the numbers were valid and present (when they are strings). Do I convert them first? Or do I do a two stage verification -- verify string -> verify numbers.

> I knew that had to use changesets somehow but my weak understanding of pattern matching prevented me from figuring out how to do so at that time.

After googling forever, found this stack overflow on using plug function validate: https://stackoverflow.com/questions/42277642/phoenix-plug-to-check-for-required-query-param

While not exactly what I used in the end, I think finally understood how to use case and pattern matching with the changeset for verification.

Armed with this new knowledge - used mix phx.gen.embedded to generate my validation schema.

Still was facing my string/number problem. Decided to use create custom validations to validate string as float/number. Experimented with the parse methods but did not understand how to handle the result tuple. Decided to go with String.to_integer/float to handle numeric check. Wrapped the function in a try rescue, and hopefully this handles invalid params and allows parsable params to be validated with more specific requirement (valid latitude etc.)

## Day 3

### with Pattern Matching

Realise that my validation code was still failing. After staring at the docs for float parse for abit. Suddenly had a ephipany regarding tuples and result.

> I was using {float, binary} -> if bytesize(binary) > 0 to check for valid float or breaking the string into charlist and enum.each (not is_float)

Decided to first extract the string_is checkers from being custom validation, created a Float/Integer.Parse wrapper and case statements to return exactly what I wanted, and to handle the error without the use of try rescue.

Chained the function in my validator under a with structure. Validator works and looks cleaner.

### remove webpack/html

Now that the API is mostly complete. I was about to begin final optimizations and testing. I was using docker-compose drop db migrate etc. Removing webpack seem like a good step to make the docker-compose up flow faster.

### bulk_insert

While my seeders were working as is. I felt that my update availability was sub optimal. It was deleting all entries before populating -> essentially eliminating any weird insert conflicts. But deleting was kinda overkill if you are updating every minute (if scheduled.)

Decided to figure out insert_all again. Now that I understood how pattern matching and changeset works -- I could use it to validate and extract the valid rows from the API.

Had to add unique_index to the migration to handle conflict_target for the foreign key but otherwise insert_all worked for update.avail task. (Also had to filter out dupes)

Once the code was stable, refactored the seeder for Information as well to use insert_all.

### testing

I didn't do TDD so now I'm stuck with a bunch of preconfigured tests that don't work T.T
