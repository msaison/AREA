
var link = document.createElement("a");
link.setAttribute('download', '');
link.href = "/mobile/app-release.apk";
document.body.appendChild(link);
link.click();
link.remove();
