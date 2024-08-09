# README

## People

- Group B, Team 5  
- Alex Robertson (roberta1tcd)  
- Finn Wright (CloudyUnity)  
- Kyara (Cosmo) McWilliam (Kya-ra)  
- Mateusz Orlowski (MO1805)  
- Matthew Poole (MPoole1105)  
- Thomas Creagh (ThomasCreagh)

High5ive was the name of the team

## Troubleshooting

- Getting the error "The nested type ApplicationClass cannot hide an enclosing type.":  
    - Delete "sketch.properties" file.  
    - Ensure project directory is named "High5ive".  
 
## About

This was a team project for the "Programming Project" module in Trinity 2023/2024  
We were required to visualise flight path data using Processing, Java and optionally GLSL  

Kyara was in charge of finding and pre-processing the data  
Tom was in charge of the query system   
Alex created the GUI systems  
Matthew and Tom were in charge of designing and setting up the UI  
Finn set up the framework, made the shaders and 3D systems and created the charts  

# Report

The goal of the project was to construct an application to explore data relating to
commercial flights, including methods to load and read data, to select specific queries,
and to present only the chosen queries on the screen. Over the course of this module,
we achieved all these goals, while using a much larger database of flights sourced by
our team. On top of that, we choose to, apart from using more common forms of
presentation such as charts and graphs, to present the data using a 3D model of the
earth.  

Alex created a UI toolkit similar to Windows Forms. This includes an event system where
handlers are added to a Widgets event [button.getClickEvent().addHandler(e ->
ClickEvent());]. This event system simplifies the usage of Widgets, as you simply need
handlers, which are called on the event. All Widgets are derived from the Widget class,
which allows every screen to hold a polymorphic list. Events are raised by the screen
automatically, by iterating through the list of Widgets and checking if they are an
instance of a relevant interface. Widgets used included Button, Textbox, Listbox,
Scrollable dropdown, Checkboxes, and Radio buttons.   

We decided to preprocess the data into raw binary for performance. Cosmo
converted all decimal values to binary equivalents, then used a small processing script
that runs separately from the main body of the project to replace text values with a
numerical key. These keys were stored in a series of lookup tables - one for each of
airports, aircraft and airlines - which stored details like the name or country. This allowed
the database files to be very small and load quickly into processing using Tom’s code,
while still retaining human readability when converted. Cosmo also wrote functions to
access these lookup tables, using native Processing spreadsheet functions. She was
able to find lots of additional data online for larger world-sized datasets using web
scraping techniques, allowing the scope of the program to be expanded.  

The compact dataset allowed Tom to use advanced features for reading like Map
Buffer which can read a file of 2GB (equivalent to apx. 67 million flights) in 2 ms. Tom
serialised this data into a FlightType Object. With this FlightType Object, Tom created
query functions with dynamic enum query typing for: querying by operation, query
between a range and by frequency. He also implemented a function for sorting the
data by a type. Tom was also responsible for the actual design of UI, such as the home
screen and color palette.  

Finn created a 3D flight map to represent connections in a visually engaging way.
Multiple vertex and fragment shaders were written to deal with lighting calculations,
texture blending, specular highlights, normal mapping, texture translation and
post-processing. Normal mapping was done using downsized online earth surface maps
and normal matrices to find the aligned normal vectors. Geometric Spherical Linear
Interpolation was used to create the line segments for the flight connection of great
circle arcs. A standard skysphere was created by forcing the depth buffer value of the
mesh to be infinite. The pie chart was made using the built-in Processing arc() function
to draw sectors of a circle. The scatter plot initially seemed daunting due to poor
performance but he was able to optimise them by using a mesh with vertices to
represent the points and skipping duplicates.  

We decided to attempt to create a 2D flight map with similar capabilities for data
presentation to the 3D map. Mati created the 2D FlightUI and the 2DFM classes, which
included the base image for the map, the UI to interact with the map, and functions to
convert latitude and longitude for our data to a location on the screen. However the
2D map was cut from the final product due to a lack of time.
Matthew’s responsibility was to create the User Querying interface for the 3D map and
charts system.  

He achieved this by creating input fields that took in a user input, then communicating
with the querying system that was made by Tom. This then created an event which
transferred an arrayList of queried flights returned by our flight querying system into the
3D flight map to be rendered. This interface used textboxes, radio buttons and
combined textboxes with dropdowns. This allows users to seamlessly search data from
both our world and US dataset, with the result being displayed accordingly onto our 3D
flight map or Chart screen. A struggle that Matthew came upon when coding was that
not all Querying types were compatible with the world data. To solve this issue he
created a system that would lock off incompatible queries when the world data set
was in focus.  

As seen by the efforts of our team, we strived to go above and beyond the project brief
and we hope that was reflected in the final product. The team came together very
effectively, developing workflows that took advantage of everyone’s strengths in
programming, being able to work collaboratively where it gave the most benefit, while
also being able to develop functions individually, especially at early stages, allowing
rapid progress to be made with the base framework for the program  

![image](https://github.com/user-attachments/assets/7acda786-0eff-4989-84dc-6d200fc35826)
![image](https://github.com/user-attachments/assets/19dbd29a-c345-4ec3-b742-62c82ec23f2f)
![image](https://github.com/user-attachments/assets/4199c91c-6a45-4804-8270-3d7a120101fe)
![image](https://github.com/user-attachments/assets/2ccc23ed-0fa0-4da7-9c10-f4ba9e08c74e)
