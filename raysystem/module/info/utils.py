from urllib.parse import urlparse


def info_extract_host_from_url(url: str) -> str:
    """
    从 url 中提取 host，并去除 'www.' 前缀
    """
    parsed_url = urlparse(url)
    host = parsed_url.hostname

    if host is None:
        # Exception: Invalid url: /dict/search?q=flutter&FORM=BDVSP2&qpvt=flutter
        raise Exception("Invalid url: " + url)

    host = str(host)

    # 如果 host 以 'www.' 开头，则去除这个前缀
    if host.startswith("www."):
        host = host[4:]

    return host