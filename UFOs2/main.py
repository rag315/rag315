# Script to analyze a 2016 dataset from the National UFO Reporting Center
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from PIL import Image
from wordcloud import WordCloud
import geopandas as gpd
import geoplot as gplt
import geoplot.crs as gcrs
from shapely.geometry import Point
from geopandas import GeoDataFrame

# Data Import
table = pd.DataFrame(pd.read_excel('UFOs_coord.xlsx'))

# Split Date / Time
# Convert to datetime as formatting for each Date is different
table['Date / Time'] = pd.to_datetime(table['Date / Time'])
table['Date'] = [d.date() for d in table['Date / Time']]
table['Time'] = [d.time() for d in table['Date / Time']]
# Convert Date Time to String
table['Date'] = table['Date'].astype('str')
table['Time'] = table['Time'].astype('str')
# Splitting Date Time
table[['Hour', 'Minute', 'Second']] = table['Time'].str.split(':', expand=True)
table[['Year', 'Month', 'Day']] = table['Date'].str.split('-', expand=True)
# Dropping columns
table = table.drop(columns=['Date / Time', 'Time', 'Date'])
#-------------------------------------------------------------#
# Plots
#-------------------------------------------------------------#
# Count by Hour
fig1, ax = plt.subplots(figsize=(10, 6))
ax.set_title('Number of Sightings per Hour of Day')
ax.set_ylabel("Hour of Day")
ax.set_xlabel("Number of Sightings")
table['Hour'].value_counts().sort_index().plot(kind='barh', edgecolor="white")
plt.show()

# Count by Day
fig2, ax = plt.subplots(figsize=(10, 6))
ax.set_title('Number of Sightings per Day')
ax.set_ylabel("Day of the Month")
ax.set_xlabel("Number of Sightings")
table['Day'].value_counts().sort_index().plot(kind='barh')
plt.show()

# Count by Month
fig3, ax = plt.subplots(figsize=(10, 6))
ax.set_title('Number of Sightings per Month')
ax.set_ylabel("Month")
ax.set_xlabel("Number of Sightings")
table['Month'].value_counts().sort_index().plot(kind='barh')
plt.show()

# Scatter of Day/Month
count = table.groupby(['Month','Day']).size().to_frame(name= 'Count').reset_index()
s = count.Count
fig4, ax = plt.subplots(figsize=(10, 6))
ax.set_title('Number of Sightings per Day of the Month')
ax.set_ylabel("Day")
ax.set_xlabel("Month")
count.plot(x='Month', y='Day', kind='scatter', ax=ax, s=s, c=s, colormap='viridis')
plt.show()

# Count by Encounter Shape
fig5, ax = plt.subplots(figsize=(10, 6))
ax.set_title('Number of Sightings per UFO Shape')
ax.set_ylabel("Shape")
ax.set_xlabel("Number of Sightings")
table['Shape'].value_counts().sort_index().plot(kind='barh')
plt.show()

# Word Cloud: Summary
text = " ".join(review for review in table.Summary.astype(str))
print("There are {} words in the combination of all cells in column Summary.".format(len(text)))
stopwords1 = set("a")
stopwords1.update(["the", "an", "in", "I", "((anonymous report))", "and", "at", "it", "of", "then", "on", "from", "when",
                  "it", "like", "anonymous", "report", "with", "over", "Note", "to", "for", "no", "my", "NUFORC", "not",
                   "or", "but"])
# Image Mask
UFO_mask = np.array(Image.open("UFO.jpg"))

wordcloud1 = WordCloud(stopwords=stopwords1, background_color="white", max_words=100,
                           mask=UFO_mask, contour_width=1, contour_color='white')
wordcloud1.generate(text)
#wordcloud1.to_file("UFO3.png")
# Plot
plt.axis("off")
plt.tight_layout(pad=0)
plt.title("Word Cloud of Sighting Summaries")
plt.imshow(wordcloud1, interpolation='bilinear')
plt.show()

# Word Cloud: Shapes
text = " ".join(review for review in table.Shape.astype(str))
print("There are {} words in the combination of all cells in column Summary.".format(len(text)))
stopwords2 = set("Other")
wordcloud2 = WordCloud(stopwords=stopwords2, background_color="white", width=800, height=400).generate(text)
# Plot
plt.axis("off")
plt.tight_layout(pad=0)
plt.title("Word Cloud of UFO Shapes")
plt.imshow(wordcloud2, interpolation='bilinear')
plt.show()

# Count by City/Location (Density on a map)
gdf = GeoDataFrame(table, geometry=[Point(xy) for xy in zip ( table["lng"], table["lat"])])
# Map
world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
NA = world.query('continent == "North America"')
# Plot
gdf.plot(ax=NA.plot(), marker='.', color='red', markersize=5, alpha=0.5)
plt.show()
