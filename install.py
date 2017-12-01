#!/usr/bin/env python3
# http://selenium-python.readthedocs.io/

from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By
import os
import re

APP_URL = "http://{}/installation/index.php".format(os.environ["APP_URL"])
APP_LOCALE = os.environ["APP_LOCALE"]
APP_TITLE = os.environ["APP_TITLE"]
ADMIN_EMAIL = os.environ["ADMIN_EMAIL"]
ADMIN_USERNAME = os.environ["ADMIN_USERNAME"]
ADMIN_PASSWORD = os.environ["ADMIN_PASSWORD"]
DB_HOST = os.environ["DB_HOST"]
DB_USER = os.environ["DB_USER"]
DB_PASSWORD = os.environ["DB_PASSWORD"]
DB_NAME = os.environ["DB_NAME"]

def main():
    d = webdriver.PhantomJS()

    d.get(APP_URL)
    d.find_element_by_id("jform_site_name").send_keys(APP_TITLE)
    d.find_element_by_id("jform_admin_email").send_keys(ADMIN_EMAIL)
    d.find_element_by_id("jform_admin_user").send_keys(ADMIN_USERNAME)
    d.find_element_by_id("jform_admin_password").send_keys(ADMIN_PASSWORD)
    d.find_element_by_id("jform_admin_password2").send_keys(ADMIN_PASSWORD)
    d.find_element_by_xpath('//*[@id="adminForm"]/div[3]/div/div/a').click()

    WebDriverWait(d, 10).until(EC.visibility_of_element_located((By.ID, "jform_db_host")))

    db_host_field = d.find_element_by_id("jform_db_host")
    db_host_field.clear()
    db_host_field.send_keys(DB_HOST)
    d.find_element_by_id("jform_db_user").send_keys(DB_USER)
    d.find_element_by_id("jform_db_pass").send_keys(DB_PASSWORD)
    d.find_element_by_id("jform_db_name").send_keys(DB_NAME)
    d.find_element_by_xpath('//*[@id="adminForm"]/div[9]/div/div/a[2]').click()

    WebDriverWait(d, 10).until(EC.visibility_of_element_located((By.XPATH,
                                                                '//*[@id="system-message-container"]/div[2]/div')))
    file_to_delete = re.match(
        ".+(?P<filename>_[A-z0-9]+\.txt).+",
        d.find_element_by_xpath('//*[@id="system-message-container"]/div[2]/div').text
    ).groupdict().get('filename')
    assert file_to_delete
    os.unlink("installation/{}".format(file_to_deletefile_to_delete))
    time.sleep(5)
    d.find_element_by_xpath('//*[@id="adminForm"]/div[9]/div/div/a[2]').click()
    WebDriverWait(d, 10).until(EC.visibility_of_element_located((By.ID, "jform_sample_file")))
    d.find_element_by_xpath('//*[@id="adminForm"]/div[7]/div/div/a[2]').click()
    WebDriverWait(d, 10).until(EC.element_to_be_clickable((By.XPATH, '//*[@id="adminForm"]/div[4]/div/input')))
    d.find_element_by_xpath('//*[@id="adminForm"]/div[4]/div/input').click()

    d.quit()

if __name__ == "__main__":
    main()
