import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Read the CSV file
df = pd.read_csv('ratioTest/ratioResults.csv')

# Pivot to create matrix (R values as rows, dR values as columns, winRate as values)
heatmap_data = df.pivot(index='R', columns='dR', values='winRate')

# Create the heatmap
plt.figure(figsize=(10, 6))
sns.heatmap(heatmap_data, annot=True, fmt='.3f', cmap='RdYlGn', cbar_kws={'label': 'Win Rate'})

plt.title('Win Rate Heatmap')
plt.xlabel('dR (Rate of Change)')
plt.ylabel('R (Base Bet Ratio)')
plt.tight_layout()
plt.savefig('heatmap.png', dpi=300)
plt.show()