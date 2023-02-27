#%%
# Install IPyKernel. The IPython kernel is the Python execution backend for Jupyter
import pandas as pd

#%%
# # For debugging purpose
# To load an xlsx file in Python, you need to install also the package: openpyxl
dataset = pd.read_excel (r'C:\Users\LucaZavarella\OneDrive\MVP\Speaker\2023 - Data Saturday Pordenone\Demo 1\Users.xlsx', engine='openpyxl')

df = dataset
df

#%%
regex_local_part = r'([^<>()[\]\\.,;:\s@\""]+(\.[^<>()[\]\\.,;:\s@\""]+)*)|(\"".+\"")'
regex_domain_name = r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,})'
regex_domain_ip_address = r'(\[?[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\]?)'

pattern = r'^({0})@({1}|{2})$'.format(regex_local_part, regex_domain_name, regex_domain_ip_address)

df['isEmailValidFromRegex'] = df['Email'].str.match(pattern).astype(int)
df

# %%
