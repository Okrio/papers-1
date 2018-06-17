#!/usr/bin/python

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

plt.rc('text', usetex=True)
font = {"family": "sans-serif", "size": 17}
plt.rc("font", **font)


fig = plt.figure()
ax = fig.add_subplot(111, aspect = 'equal')

def label(xy, text):
    # shift x and y-value for label so that it's below right the artist
    plt.text(xy[0] + 0.1, xy[1] - 0.3, text, ha="center", family='sans-serif', size=14)

rect = mpatches.Rectangle(
      (0.0, 0.0),
      4.9,
      3.8,
      clip_on=False,
      edgecolor='black',
      facecolor='#c0c0ff',
      fill=True,     # remove background
      linewidth=4,
)

ax.add_patch(rect)

#ax.grid(linestyle="--", linewidth=1)
plt.plot(clip_on=False)

microphone_pos = np.array([1.5, 1.9])


x = np.linspace(1.5, 1.5, 10)
y = np.linspace(0.0, 1.9, 10)
plt.plot(x, y, '--', linewidth=2, color='k')

x = np.linspace(0.0, 1.5, 10)
y = np.linspace(1.9, 1.9, 10)
plt.plot(x, y, '--', linewidth=2, color='k')


#angle_rad = np.deg2rad(30.0)
angle_rad = np.deg2rad(0.0)
dist_meters = 2.0
target_pos = (microphone_pos +
             dist_meters * np.array([np.cos(angle_rad), np.sin(angle_rad)]))

#angle_rad = np.deg2rad(75.0)
angle_rad = np.deg2rad(45.0)
dist_meters = 2.0
noise_pos = (microphone_pos +
             dist_meters * np.array([np.cos(angle_rad), np.sin(angle_rad)]))


circle = mpatches.Circle(target_pos, 0.1, color="black")
ax.add_patch(circle)
label(target_pos, 'Target')

circle = mpatches.Circle(noise_pos, 0.1, edgecolor='black',
                         facecolor="gray", linewidth=2)
ax.add_patch(circle)
label(noise_pos, 'Noise')

circle = mpatches.Circle(noise_pos, 0.1, edgecolor='black',
                         facecolor="gray", linewidth=2)
ax.add_patch(circle)
plt.text(microphone_pos[0] - 0.5, microphone_pos[1] - 0.2,
         "Mic. array", ha="center", family='sans-serif', size=14)


coordsA = "data"
coordsB = "data"
con = mpatches.ConnectionPatch(microphone_pos, target_pos, coordsA,
                               coordsB, arrowstyle="->", shrinkA=7,
                               shrinkB=7, mutation_scale=40, fc="black",
                               linestyle='dashed', linewidth=2)

#text_position = (microphone_pos + target_pos) / 2.0 + np.array([0.2, 0.0])
#plt.text(text_position[0], text_position[1],
#         "d = 1.5 meters", ha="left", family='sans-serif', size=14)



ax.add_artist(con)

#wedge = mpatches.Wedge(microphone_pos, 0.5, 0, 30, width=0.02, color='black')
#ax.add_artist(wedge)

ax.annotate(r'$d_{mn} = 2.0 \; m$',
            xy=((microphone_pos + noise_pos) / 2.0), xycoords='data',
            xytext=(-100, 30), textcoords='offset points',
            arrowprops=dict(arrowstyle="->",
                            connectionstyle="arc3,rad=0.2"))
ax.annotate(r'$\theta_{tn} = 45^o$',
  xy=microphone_pos + np.array([0.55, 0.2]), xycoords='data',
  xytext=(30, 30), textcoords='offset points',
  arrowprops=dict(arrowstyle="->",
                  connectionstyle="arc3,rad=0.3"))

wedge = mpatches.Wedge(microphone_pos, 0.6, 0, 45, width=0.02, color='black')
ax.add_artist(wedge)

#ax.annotate(r'$\theta_t = 30^o$',
#             xy=microphone_pos + np.array([0.5, 0.1]), xycoords='data',
#             xytext=(30, -30), textcoords='offset points',
#             arrowprops=dict(arrowstyle="->",
#                            connectionstyle="arc3,rad=0.3"))
ax.annotate(r'$d_{mt} = 2.0 \; m$',
            xy=((microphone_pos + target_pos) / 2.0), xycoords='data',
            xytext=(10, -60), textcoords='offset points',
            arrowprops=dict(arrowstyle="->",
                            connectionstyle="arc3,rad=0.2"))



con = mpatches.ConnectionPatch(microphone_pos, noise_pos, coordsA,
                               coordsB, arrowstyle="->", shrinkA=7,
                               shrinkB=7, mutation_scale=40, fc="black",
                               linestyle='dashed', linewidth=2)

ax.add_artist(con)

#text_position = (microphone_pos + noise_pos) / 2.0
#plt.text(text_position[0] + 0.2, text_position[1],
#         "d = 1.5 meters", ha="left", family='sans-serif', size=14)

# Draw the microphone array
angle_rad = np.deg2rad(90.0)
dist_meters = 0.6
mic_end1 = (microphone_pos +
            dist_meters * np.array([np.cos(angle_rad), np.sin(angle_rad)]))
mic_end2 = (microphone_pos -
            dist_meters * np.array([np.cos(angle_rad), np.sin(angle_rad)]))

#array_style = mpatches.ArrowStyle("CurveAB", head_length=.4, head_width=.4, tail_width=.4)
con = mpatches.ConnectionPatch(mic_end1, mic_end2, coordsA,
                               coordsB, arrowstyle="<->", shrinkA=7,
                               shrinkB=7, mutation_scale=40, fc="black",
                               linestyle='solid', linewidth=3)

ax.add_artist(con)

rect = mpatches.Rectangle(
      microphone_pos,
      0.2,
      0.2,
#      angle=30.0,
      angle=-90.0,
      clip_on=False,
      edgecolor='black',
   #   facecolor='#c0c0ff',
      fill=False,     # remove background
      linewidth=2,

)

ax.add_patch(rect)

plt.xlabel('x (meters)')
plt.ylabel('y (meters)')

ax.set_xticks([0.0, 1.0, 2.0, 1.5, 3.0, 4.0, 4.9, 5.0])
ax.set_xticklabels(['0.0', '', '', '1.5 m', '', '', '4.9 m \n Width', ''])

ax.set_yticks([0.0, 1.0, 1.9, 2.0, 3.0, 3.8, 4.0])
ax.set_yticklabels(['', '', '1.9 m', '', '', 'Length \n 3.8 m',''], rotation='vertical')
#ax.set_yticklabels(['', '', '1.9 m', '', '', 'Width (3.8 m)',''])

fig = plt.gcf()
fig.savefig('plot_mic_source_target_2d_symmetric.eps')




