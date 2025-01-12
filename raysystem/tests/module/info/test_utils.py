import re
import pytest
from module.info.utils import info_extract_host_from_url

def test_info_extract_host_from_url_with_www():
    url = "http://www.example.com"
    expected_host = "example.com"
    assert info_extract_host_from_url(url) == expected_host

def test_info_extract_host_from_url_without_www():
    url = "http://example.com"
    expected_host = "example.com"
    assert info_extract_host_from_url(url) == expected_host

def test_info_extract_host_from_url_with_subdomain():
    url = "http://blog.example.com"
    expected_host = "blog.example.com"
    assert info_extract_host_from_url(url) == expected_host

def test_info_extract_host_from_url_invalid_url():
    url = "/dict/search?q=flutter&FORM=BDVSP2&qpvt=flutter"
    with pytest.raises(Exception, match=re.escape("Invalid url: " + url)):
        info_extract_host_from_url(url)

def test_info_extract_host_from_url_with_https():
    url = "https://www.example.com"
    expected_host = "example.com"
    assert info_extract_host_from_url(url) == expected_host

def test_info_extract_host_from_url_with_port():
    url = "http://www.example.com:8080"
    expected_host = "example.com"
    assert info_extract_host_from_url(url) == expected_host