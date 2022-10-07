import pandas as pd
import numpy as np
from Category_index import Category


def read_csv():
    df = pd.read_csv(r'test.csv', parse_dates=['Date'], index_col=False)
    df = pd.DataFrame(df, columns=['Product_id', 'Product_name', 'Category_num', 'Date', 'Qty_sold_last_week'])
    return df


def prepare_data(df):
    df['Sold_avg'] = df['Qty_sold_last_week'] / 7
    df = df.round({'Sold_avg': 0})
    df = df[df['Sold_avg'] > 40]
    df['Month'] = df['Date'].dt.month
    df['season'] = np.where(df['Month'] <= 6, 'H1', 'H2')
    return df

def generate_new(df):
    category = Category()
    for i in category.category_num.keys():
        if category.category_num[i] == 'Meat':
            df = df.loc[df['Category_num'] != int(i)]
            return df



def export_csv(df):
    df = pd.DataFrame(df)
    df.to_csv('export.csv',index=False)



def main():
    df_new = read_csv()
    df_new = prepare_data(df_new)
    df_new = generate_new(df_new)
    export_csv(df_new)




if __name__ == "__main__":
    main()


