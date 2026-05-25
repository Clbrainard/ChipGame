import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
# Read the CSV file
df = pd.read_csv('staticTest/staticResults.csv')


plt.figure(figsize=(10, 6))
plt.plot(df['betSize'].values, df['winRate'].values, marker='o', linewidth=2, markersize=6)

plt.xlabel('Bet Size')
plt.ylabel('Win Rate')
plt.title('Win Rate vs Bet Size')
plt.xscale('log')
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()