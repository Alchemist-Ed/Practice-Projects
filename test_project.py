import pytest
import pandas as pd
import project_main
from project_main import prepare_data
from project_main import read_csv
from project_main import generate_new

@pytest.fixture(scope='session')
def df():
    return pd.read_csv('test.csv')

def test_read_csv():
    df1 = read_csv()
    df1 = df1[['Product_id','Category_num']]
    read = {'Product_id':[1,2,3,1,2,3,1,2,3,1,2], 'Category_num':[101,102,103,101,102,103,101,102,103,101,102]}
    test_read = pd.DataFrame(data = read)
    print(df1)
    print(test_read)
    assert df1.equals(test_read)

def test_prepare_data(df):
    df2 = read_csv()
    df2 = prepare_data(df2)
    df2 = df2.columns.values.tolist()

    test_columns = ['Product_id', 'Product_name', 'Category_num', 'Date',
                    'Qty_sold_last_week', 'Sold_avg', 'Month', 'season']
    assert df2 == test_columns

def test_generate_new(df):
    df3 = read_csv()
    df3 = prepare_data(df3)
    df3 = generate_new(df3)
    data = {'Product_id':[1,1,1,1], 'Product_name':['AAA', 'AAA', 'AAA', 'AAA'], 'Category_num':[101,101,101,101], 'Date':['2022-09-01 00:00:00', '2022-06-01 00:00:00', '2022-03-01 00:00:00', '2021-12-01 00:00:00'], 'Qty_sold_last_week':[300,300,300,300], 'Sold_avg':[43.0,43.0,43.0,43.0], 'Month':[9,6,3,12],'season':['H2','H1','H1','H2']}
    data['Date'] = pd.to_datetime(data['Date'])
    test_data = pd.DataFrame(data=data, index=[0,3,6,9])
    assert df3.equals(test_data)


