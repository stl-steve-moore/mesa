//
//        Copyright (C) 1999, 2000, HIMSS, RSNA and Washington University
//
//        The MESA test tools software and supporting documentation were
//        developed for the Integrating the Healthcare Enterprise (IHE)
//        initiative Year 1 (1999-2000), under the sponsorship of the
//        Healthcare Information and Management Systems Society (HIMSS)
//        and the Radiological Society of North America (RSNA) by:
//                Electronic Radiology Laboratory
//                Mallinckrodt Institute of Radiology
//                Washington University School of Medicine
//                510 S. Kingshighway Blvd.
//                St. Louis, MO 63110
//        
//        THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER HIMSS, RSNA NOR
//        WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
//        PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
//        USE, FREEDOM FROM ANY DEFECTS OR COMPUTER DISEASES OR ITS CONFORMITY 
//        TO ANY SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
//        THE SOFTWARE IS WITH THE USER.
//
//        Copyright of the software and supporting documentation is
//        jointly owned by HIMSS, RSNA and Washington University, and free
//        access is hereby granted as a license to use this software, copy
//        this software and prepare derivative works based upon this software.
//        However, any distribution of this software source code or supporting
//        documentation or derivative works (source code and supporting
//        documentation) must include the three paragraphs of this copyright
//        notice.

#include "ctn_os.h"
#include "MESA.hpp"
#include "MFileOperations.hpp"

#include "ctn_api.h"

#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/types.h>
#ifdef _WIN32
#include <io.h>
#else
#include <dirent.h>
#include <unistd.h>
#endif

#include <fstream>

static char rcsid[] = "$Id: MFileOperations.cpp,v 1.28 2006/05/19 18:44:24 smm Exp $";

MFileOperations::MFileOperations()
{
}

MFileOperations::MFileOperations(const MFileOperations& cpy)
{
}

MFileOperations::~MFileOperations()
{
}

void
MFileOperations::printOn(ostream& s) const
{
  s << "MFileOperations";
}

void
MFileOperations::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler plate methods follow

int
MFileOperations::createDirectory(const MString& prefix,
				 const MString& directory)
{
  int rslt;

  char fullPath[512];

  rslt = this->expandPath(fullPath, prefix, directory);
  if (rslt != 0)
    return rslt;

  CONDITION cond = ::UTL_VerifyCreatePath(fullPath);
  if (cond != UTL_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  return 0;
}
int
MFileOperations::createDirectory(const MString& directory)
{
  char s[1024];
  directory.safeExport(s, sizeof(s));

  CONDITION cond = ::UTL_VerifyCreatePath(s);
  if (cond != UTL_NORMAL) {
    ::COND_DumpConditions();
    exit(1);
  }

  return 0;
}

MString
MFileOperations::uniqueFile(const MString& prefix, const MString& directory,
			    const MString& extension)
{
  this->createDirectory(prefix, directory);

  char dateString[20];
  char timeString[20];

  ::UTL_GetDicomDate(dateString);
  ::UTL_GetDicomTime(timeString);
  timeString[6] = '\0';

  char directoryPath[512];
  this->expandPath(directoryPath, prefix, directory);

  int done = 0;
  int incrementValue = 1;
  MString s;
  char extString[128];
  extension.safeExport(extString, sizeof(extString));

  while (!done) {
    char candidateFile[512];
    ::sprintf(candidateFile, "%s/%s-%s-%02d.%s",
	      directoryPath,
	      dateString,
	      timeString,
	      incrementValue,
	      extString);
    if (!this->fileExists(candidateFile)) {
      s = candidateFile;
      done = 1;
    } else {
      incrementValue++;
    }
  }

  return s;
}

MString
MFileOperations::uniqueFile(const MString& directory,
			    const MString& extension)
{
  char dateString[20];
  char timeString[20];

  ::UTL_GetDicomDate(dateString);
  ::UTL_GetDicomTime(timeString);
  timeString[6] = '\0';

  int done = 0;
  int incrementValue = 1;
  MString s;
  char extString[128];
  extension.safeExport(extString, sizeof(extString));

  while (!done) {
    char candidateFile[512];
    ::sprintf(candidateFile, "%s/%s-%s-%02d.%s",
	      directory.strData(),
	      dateString,
	      timeString,
	      incrementValue,
	      extString);
    if (!this->fileExists(candidateFile)) {
      s = candidateFile;
      done = 1;
    } else {
      incrementValue++;
    }
  }

  return s;
}

int
MFileOperations::expandPath(char* result, const MString& prefix,
			    const MString& directory)
{
  char prefixValue[256];

  prefix.safeExport(prefixValue, sizeof(prefixValue));

  char* xlate = ::getenv(prefixValue);

  if (xlate == 0)
    return -1;

  char fullPath[512];
  strcpy(fullPath, xlate);
  strcat(fullPath, "/");

  int len = ::strlen(fullPath);
  directory.safeExport(&fullPath[len], sizeof(fullPath) - len);

  strcpy(result, fullPath);
  return 0;
}

int
MFileOperations::rename(const MString& source, const MString& target)
{
  char* s = source.strData();
  char* t = target.strData();

  int status = ::rename(s, t);
  if (status != 0) {
    cerr << "Could not rename: " << source << " " << target << endl;
    ::perror(t);
    ::exit(1);
  }
	return 0;
}

int
MFileOperations::readParamsMap(const MString& path, MStringMap& m,
	char substitute)
{
  char* p = path.strData();

  ifstream f(p);
  if (!f) {
    delete []p;
    return -1;
  }
  char buffer[1024];
  while (f.getline(buffer, sizeof(buffer))) {
    if (buffer[0] == '#') continue;
    if (buffer[0] == '\r') continue;
    if (buffer[0] == '\n') continue;

    char* tok1 = ::strtok(buffer, "= \t");
    if (tok1 == 0)
      continue;
    char* tok2 = ::strtok(0, "= \t");
    if (tok2 == 0)
      continue;
    MString s(tok2);
    if (substitute != ' ')
      s.substitute(substitute, ' ');
    m[tok1] = s;
  }

  delete []p;
  return 0;
}

char*
MFileOperations::readAllText(const MString& path)
{
  char tmp[1024];
  path.safeExport(tmp, sizeof(tmp));

  U32 fileLength = 0;

  CONDITION cond;
  cond = ::UTL_FileSize(tmp, &fileLength);
  if (cond != UTL_NORMAL)
    return 0;

  char* txt = new char[fileLength + 1];
  if (txt == 0)
    return 0;

  int fd;
#ifdef _WIN32
  fd = ::open(tmp, O_RDONLY | O_BINARY);
#else
  fd = ::open(tmp, O_RDONLY);
#endif

  if (fd < 0)
    return 0;

#ifdef _WIN32
  int bytesRead;
#else
  ssize_t bytesRead;
#endif

  char* p = txt;
  while (fileLength > 0) {
    bytesRead = ::read(fd, p, fileLength);
    if (bytesRead <= 0) {
      delete[] txt;
      return 0;
    }
    fileLength -= bytesRead;
    p += bytesRead;
  }

  *p = '\0';
  return txt;
}

int
MFileOperations::fileExists(const char* path)
{
  int status;
  struct stat im_stat;

  status = ::stat(path, &im_stat);

  if (status == 0)
    return 1;
  else
    return 0;
}

int
MFileOperations::fileExists(const MString& path)
{
  char buf[2048];
  path.safeExport(buf, sizeof(buf));
  return MFileOperations::fileExists(buf);
}

long
MFileOperations::fileLength(const char* path)
{
  int status;
  struct stat im_stat;
  long rtnLength = 0;

  status = stat(path, &im_stat);
  if (status < 0) {
    ; // Nothing to do
  } else {
    rtnLength = im_stat.st_size;
  }
  return rtnLength;
}

// Private methods below


int
MFileOperations::scanDirectory(const MString& directory)
{

  while (!mFileVector.empty())
    mFileVector.pop_back();

  char directoryText[1024];
  directory.safeExport(directoryText, sizeof(directoryText));

#ifdef _WIN32
  struct _finddata_t fileInfo;
  long hFile;

  ::strcat(directoryText, "/*");
  if( (hFile = _findfirst(directoryText, &fileInfo)) == -1L)
    return 1;

  do {
    MString s(fileInfo.name);
    if (s != "." && s != "..") {
      mFileVector.push_back(s);
    }
  } while (_findnext(hFile, &fileInfo) == 0);

  _findclose(hFile);

#else
  DIR* dirp;
  dirp = ::opendir(directoryText);
  if (dirp == 0)
    return 1;

  struct dirent* dp;

  while ((dp = ::readdir(dirp)) != NULL) {
    MString s(dp->d_name);
    if (s != "." && s != "..")
      mFileVector.push_back(s);
  }
  ::closedir(dirp);
#endif
  return 0;
}

int
MFileOperations::scanDirectorySuffix(const MString& directory, const MString& suffix)
{
  while (!mFileVector.empty())
    mFileVector.pop_back();

  MFileOperations f;

  int rslt = f.scanDirectory(directory);
  if (rslt != 0)
    return rslt;

  int idx = 0;
  int count = f.filesInDirectory();
  MString s;
  int suffixLength = suffix.size();
  for (idx = 0; idx < count; idx++) {
    s = f.fileName(idx);
    int len = s.size();
    if (len < suffixLength) {
      continue;
    }

    MString t = s.subString(len - suffixLength);
    if (t == suffix) {
      mFileVector.push_back(s);
    }
  }
  return 0;
}

int
MFileOperations::filesInDirectory() const
{
  return mFileVector.size();
}


MString
MFileOperations::fileName(int index) const
{
  if (index < 0 || index >= mFileVector.size())
    return "";
  else
    return mFileVector[index];
}

int
MFileOperations::isDirectory(const MString& path)
{
  char f[1024];

  path.safeExport(f, sizeof(f));

  int status;
  struct stat im_stat;

  status = ::stat(f, &im_stat);

  if (status != 0)
    return -1;

#ifdef _WIN32
  if (im_stat.st_mode & S_IFDIR)
    return 1;
  else
    return 0;

#else
  if (S_ISDIR(im_stat.st_mode))
    return 1;
  else
    return 0;
#endif
}

int
MFileOperations::unlink(const MString& dirName, const MString& fileName)
{
  MString s = dirName + "/" + fileName;

  return this->unlink(s);
}

int
MFileOperations::unlink(const MString& path)
{
  char txt[512];

  path.safeExport(txt, sizeof(txt));

  int rslt = ::unlink(txt);

  if (rslt == 0)
    return 0;
  else
    return -1;
}

int
MFileOperations::timeLastModified(const MString& path, time_t& t)
{
  char txt[512];
  path.safeExport(txt, sizeof txt);

  int status;
  struct stat im_stat;

  status = ::stat(txt, &im_stat);

  if (status != 0)
    return -1;

  t = im_stat.st_mtime;
  return 0;
}

