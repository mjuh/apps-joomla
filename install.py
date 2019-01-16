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

VERSION = "3.9.2"
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
XPATHS = {"database_error":     '//*[@id="system-message-container"]/div[2]/div',
          "next_button":        '//*[@id="adminForm"]/div[3]/div/div/a',
          "install_button":     '//*[@id="adminForm"]/div[7]/div/div/a[2]',
          "remove_inst_folder": '//*[@id="adminForm"]/div[3]/input'}


def main():
    print("Unpacking Joomla {}".format(VERSION))
    shutil.rmtree("installation", ignore_errors=True)
    if os.path.exists("configuration.php"): os.unlink("configuration.php")
    shutil.unpack_archive(ARCHIVE_PATH)

    try:
        d = webdriver.PhantomJS()
        d.get(INSTALLER_URL)

        print("Submitting 'Configufation' form")
        d.find_element_by_id("jform_site_name").send_keys(APP_TITLE)
        d.find_element_by_id("jform_admin_email").send_keys(ADMIN_EMAIL)
        d.find_element_by_id("jform_admin_user").send_keys(ADMIN_USERNAME)
        d.find_element_by_id("jform_admin_password").send_keys(ADMIN_PASSWORD)
        d.find_element_by_id("jform_admin_password2").send_keys(ADMIN_PASSWORD)
        d.find_element_by_xpath(XPATHS["next_button"]).click()

        XPATHS["next_button"] = '//*[@id="adminForm"]/div[9]/div/div/a[2]'

        print("Submitting 'Database' form")
        WebDriverWait(d, 60).until(EC.element_to_be_clickable((By.ID, "jform_db_name")))
        db_host_field = d.find_element_by_id("jform_db_host")
        db_host_field.clear()   # Joomla installer sets 'localhost' here by default
        db_host_field.send_keys(DB_HOST)
        d.find_element_by_id("jform_db_user").send_keys(DB_USER)
        d.find_element_by_id("jform_db_pass").send_keys(DB_PASSWORD)
        d.find_element_by_id("jform_db_name").send_keys(DB_NAME)
        d.find_element_by_xpath(XPATHS["next_button"]).click()

        # When database host name differs from 'localhost', Joomla installer
        # displays error message with file name like "_JoomlaheyDj35lRLgCAjsZmWoD0.txt"
        # we need to delete this file from installation/ directory to proceed
        print("Confirming website ownership")
        WebDriverWait(d, 60).until(EC.presence_of_element_located((By.XPATH, XPATHS["database_error"])))
        database_error_text = d.find_element_by_xpath(XPATHS["database_error"]).text
        file_to_delete = re.match(".+(?P<filename>_[A-z0-9]+\.txt).+",
                                database_error_text).groupdict().get("filename")
        assert file_to_delete, "Failed to extract file name from message: {}".format(database_error_text)
        print("Deleting {} file from installation dir".format(file_to_delete))
        os.unlink("installation/{}".format(file_to_delete))
        WebDriverWait(d, 60).until(EC.invisibility_of_element_located((By.ID, "loading-logo")))
        d.find_element_by_xpath(XPATHS["next_button"]).click()
        print("Try to set jform_db_pass again! ")
        time.sleep(1)
        WebDriverWait(d, 5).until(EC.element_to_be_clickable((By.ID, "jform_db_pass")))
        d.find_element_by_id("jform_db_pass").click()
        d.find_element_by_id("jform_db_pass").send_keys(DB_PASSWORD)
        d.find_element_by_xpath(XPATHS["next_button"]).click()
        print("Finishing installation")
        WebDriverWait(d, 60).until(EC.visibility_of_element_located((By.ID, "jform_sample_file")))
        d.find_element_by_xpath(XPATHS["install_button"]).click()

        print("Installing language pack by name: {}".format(APP_LANG_NAME))
        WebDriverWait(d, 120).until(EC.element_to_be_clickable((By.ID, "instLangs")))
        d.find_element_by_id("instLangs").click()

        XPATHS["next_button"] = '//*[@id="adminForm"]/div[3]/div/div/a[2]'

        WebDriverWait(d, 60).until(EC.visibility_of_element_located((By.ID, "defaultlanguage")))
        checkbox_id = next((e.get_attribute("for") for e in d.find_elements_by_tag_name("label")
                            if APP_LANG_NAME in e.text))
        d.find_element_by_id(checkbox_id).click()
        d.find_element_by_xpath(XPATHS["next_button"]).click()

        XPATHS["next_button"] = '//*[@id="adminForm"]/div[4]/div/div/a[2]'

        print("Selecting default locale: {}".format(APP_LOCALE))
        WebDriverWait(d, 60).until(EC.visibility_of_element_located((By.ID, "multilanguageOptions")))
        for each in d.find_elements_by_tag_name("input"):
            if each.get_attribute("value") == APP_LOCALE: each.click()
        d.find_element_by_xpath(XPATHS["next_button"]).click()

        print("Removing installation dir")
        WebDriverWait(d, 60).until(EC.element_to_be_clickable((By.XPATH, XPATHS["remove_inst_folder"])))
        d.find_element_by_xpath(XPATHS["remove_inst_folder"]).click()

        d.quit()
    except Exception as e:
        if hasattr(e, "screen"):
            with open("error.png", "wb") as f:
                f.write(base64.decodebytes(e.screen.encode()))
        raise

if __name__ == "__main__":
    main()
