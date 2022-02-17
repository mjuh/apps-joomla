#!/usr/bin/env python3
# http://selenium-python.readthedocs.io/

from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By
import base64
import os
import re
import shutil
import time

VERSION = "4.1.0"
ARCHIVE_PATH = "/joomla-{}.tgz".format(VERSION)
INSTALLER_URL = "http://{}/installation/index.php".format(os.environ["DOMAIN_NAME"])
APP_LOCALE = os.environ.get("APP_LOCALE") or "ru-RU"
APP_LANG_NAME = {"ru-RU": "Russian",
                 "en-US": "United States",
                 "null": "Russian"}[APP_LOCALE.replace("_", "-")]
APP_TITLE = os.environ["APP_TITLE"]
ADMIN_EMAIL = os.environ["ADMIN_EMAIL"]
ADMIN_USERNAME = os.environ["ADMIN_USERNAME"]
ADMIN_PASSWORD = os.environ["ADMIN_PASSWORD"]
DB_HOST = os.environ["DB_HOST"]
DB_USER = os.environ["DB_USER"]
DB_PASSWORD = os.environ["DB_PASSWORD"]
DB_NAME = os.environ["DB_NAME"]
# xpath could be obtained from web browser's development tools
XPATHS = {"lang_table": "/html/body/div/div/div/div/main/div/div[3]/div/fieldset[2]/div/form/table/tbody", # really fragile test before update
          "finish": '/html/body/div/div/div/div/main/div/div[3]/div/div/div/div/button[1]'}



def unpack_joomla_to_workdir():
    print("Unpacking Joomla {}".format(VERSION))
    shutil.rmtree("installation", ignore_errors=True)
    if os.path.exists("configuration.php"): os.unlink("configuration.php")
    shutil.unpack_archive(ARCHIVE_PATH)


def setup_joomla():
    try:
        d = webdriver.PhantomJS()
        Wait = WebDriverWait(d, 60)

        d.get(INSTALLER_URL)
        # main configuration page
        print("Submitting form")
        d.save_screenshot("test.png")
        Wait.until(EC.element_to_be_clickable((By.ID, "jform_site_name")))
        d.find_element_by_id("jform_site_name").send_keys(APP_TITLE)
        d.find_element_by_id("step1").click()

        Wait.until(EC.element_to_be_clickable((By.ID, "jform_admin_user")))
        d.find_element_by_id("jform_admin_user").send_keys(ADMIN_USERNAME)
        d.find_element_by_id("jform_admin_username").send_keys(ADMIN_USERNAME)
        d.find_element_by_id("jform_admin_password").send_keys(ADMIN_PASSWORD)
        d.find_element_by_id("jform_admin_email").send_keys(ADMIN_EMAIL)
        d.find_element_by_id("step2").click()

        Wait.until(EC.element_to_be_clickable((By.ID, "jform_db_host")))
        db_host_field = d.find_element_by_id("jform_db_host")
        db_host_field.clear()   # Joomla installer sets 'localhost' here by default
        db_host_field.send_keys(DB_HOST)
        d.find_element_by_id("jform_db_user").send_keys(DB_USER)
        d.find_element_by_id("jform_db_pass").send_keys(DB_PASSWORD)
        db_name_field = d.find_element_by_id("jform_db_name")  # Joomla installer sets 'joomla_db' here by default
        db_name_field.clear()
        db_name_field.send_keys(DB_NAME)
        d.find_element_by_id("setupButton").click()

        # page with installing additional lang
        print("Installing language pack by name: {}".format(APP_LANG_NAME))
        Wait.until(EC.visibility_of_element_located((By.ID, "installAddFeatures")))
        d.find_element_by_id("installAddFeatures").click()
        # page with lang selection
        Wait.until(EC.visibility_of_element_located((By.XPATH, XPATHS["lang_table"])))
        checkbox_id = next((e.get_attribute("for") for e in d.find_elements_by_tag_name("label")
                            if APP_LANG_NAME in e.text
                            ))
        d.find_element_by_id(checkbox_id).click()
        d.find_element_by_id("installLanguagesButton").click()

        # page with default lang
        Wait.until(EC.visibility_of_element_located((By.ID, "defaultlanguage")))
        lang_id = next((e.get_attribute("for") for e in d.find_elements_by_tag_name("label")
                            if APP_LANG_NAME in e.text
                        ))[-1] # if think that we have only Russian and English, then one last symbol for identification is more then enough
        d.find_element_by_id("admin-language-cb" + lang_id).click()
        d.find_element_by_id("site-language-cb" + lang_id).click()
        d.find_element_by_id("defaultLanguagesButton").click()

        d.find_element_by_xpath(XPATHS["finish"]).click()

        d.quit()
    except Exception as e:
        if hasattr(e, "screen") and e.screen is not None:
            with open("error.png", "wb") as f:
                f.write(base64.decodebytes(e.screen.encode()))
        else:
            with open("error.html", "w") as f:
                f.write(d.page_source)
        raise


def main():
    unpack_joomla_to_workdir()
    setup_joomla()



if __name__ == "__main__":
    main()

