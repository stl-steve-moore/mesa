package MESA.Servlet;

import java.io.*;                       
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import DICOM.DICOMWrapper;

public class StorageManager extends HttpServlet {
  private String mRoot = null;
 
  public void init() throws ServletException {
    mRoot = getInitParameter("StorageRoot");
  }

    
  public void doGet (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	
    res.setContentType ("text/html");
    PrintWriter out = res.getWriter();
    out.println("<BODY BGCOLOR='#FFFFFF'>");
    if (mRoot == null) {
      out.println("Initialization failed to get initial parameter StorageRoot");
      out.println("<br>Check the web.xml file for proper configuration");
      out.println ("</BODY></HTML>");
      return;
    }

    String action = req.getParameter("action");
    String key = req.getParameter("key");
    String path = req.getParameter("path");

    if (action == null || action.equals("")) {
      this.printStartPage(out, mRoot);
    } else if (action.equals("ListStudies")) {
      this.listStudies(out, path, key);
    } else if (action.equals("ListSeries")) {
      this.listSeries(out, path, key);
    }

    out.println ("</BODY></HTML>");
  }

  private void printStartPage(PrintWriter out, String root) {

    java.io.File f = new java.io.File(root);
    if (f == null) {
      System.out.println("Unable to find root directory: " + root);
      return;
    }

    if (!f.isDirectory()) {
      System.out.println("Path is not a directory: " + root);
      return;
    }

    String[] storageTitles = f.list();
    this.printAETable(out, root, storageTitles);
  }

  private void printAETable(PrintWriter out, String root,
	String[] storageTitles) {
    out.println("<P><TABLE BORDER cellspacing=0 cellpadding=5>");
    out.println("<TR><TH>Title<TH>Study Count</TR>");

    int idxAE = 0;
    for (idxAE = 0; idxAE < storageTitles.length; idxAE++) {
      int studyCount = this.countDirectories(root + "/" + storageTitles[idxAE]);
      String ref1 = "path=" + root;
      String ref2 = "&action=ListStudies";
      String ref3 = "&key=" + storageTitles[idxAE];

      out.println("<TR><TD ALIGN=CENTER><a href=StorageManager?"
	+ ref1 + ref2 + ref3 + ">" + storageTitles[idxAE]);
      out.println("    <TD ALIGN=CENTER>" + studyCount);
      out.println("</TR>");
    }

    out.println("</TABLE>");
  }

  private void listStudies(PrintWriter out, String path, String title) {

    String root = path + "/" + title;
    java.io.File f = new java.io.File(root);
    if (f == null) {
      System.out.println("Unable to find root directory: " + root);
      return;
    }

    if (!f.isDirectory()) {
      System.out.println("Path is not a directory: " + root);
      return;
    }

    String[] studyUIDs = f.list();
    this.printStudyTable(out, path + "/" + title, studyUIDs);
  }

  private void printStudyTable(PrintWriter out, String root,
	String[] studyUIDs) {

    out.println("<P><TABLE BORDER cellspacing=0 cellpadding=5>");
    out.println("<TR><TH>Name");
    out.println("    <TH>Pat ID");
    out.println("    <TH>DOB");
    out.println("    <TH>Acc #");
    out.println("    <TH>Study Date");
    out.println("    <TH>Mod");
    out.println("    <TH>Series");
    out.println("    <TH>Objects");

    int idxAE = 0;
    for (idxAE = 0; idxAE < studyUIDs.length; idxAE++) {
      String path = root + "/" + studyUIDs[idxAE];

      DICOM.DICOMWrapper w = this.getWrapperFromStudy(path);
      if (w != null) {
        out.println("<TR>");
	String s = (w.getString(0x00100010)).trim();	// Name
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	s = (w.getString(0x00100020)).trim();	// Patient ID
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	s = (w.getString(0x00100030)).trim();	// DOB
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	String ref1 = "path=" + root;
	String ref2 = "&action=ListSeries";
	String ref3 = "&key=" + studyUIDs[idxAE];

	s = (w.getString(0x00080050)).trim();	// Accession Number
	if (s.equals("")) {
	  s = "----";
	}
        out.println("<TD ALIGN=CENTER><a href=StorageManager?"
	  + ref1 + ref2 + ref3 + ">" + s);

	s = (w.getString(0x00080020)).trim();	// Study Date
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD ALIGN=CENTER>" + s);

	s = (w.getString(0x00080060)).trim();	// Modality
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD ALIGN=CENTER>" + s);

        int seriesCount = this.countDirectories(path);
	out.println("<TD ALIGN=CENTER>" + seriesCount);	// Series Count

	int objectCount = this.countObjectsInStudy(path);
	out.println("<TD ALIGN=CENTER>" + objectCount);	// Object Count
        out.println("</TR>");
      }
    }

    out.println("</TABLE>");
  }

  private void listSeries(PrintWriter out, String path, String title) {

    String root = path + "/" + title;
    java.io.File f = new java.io.File(root);
    if (f == null) {
      System.out.println("Unable to find root directory: " + root);
      return;
    }

    if (!f.isDirectory()) {
      System.out.println("Path is not a directory: " + root);
      return;
    }

    String[] seriesUIDs = f.list();
    this.printSeriesTable(out, path + "/" + title, seriesUIDs);
  }

  private void printSeriesTable(PrintWriter out, String root,
	String[] seriesUIDs) {

    out.println("<P><TABLE BORDER cellspacing=0 cellpadding=5>");
    out.println("<TR><TH>Series #");
    out.println("    <TH>Mod");
    out.println("    <TH>Ser Date");
    out.println("    <TH>Objects");
    out.println("    <TH>Ser Desc");

    int idxSeries = 0;
    for (idxSeries = 0; idxSeries < seriesUIDs.length; idxSeries++) {
      String path = root + "/" + seriesUIDs[idxSeries];

      DICOM.DICOMWrapper w = this.getWrapperFromSeries(path);
      if (w != null) {
        out.println("<TR>");
	String s = (w.getString(0x00200011)).trim();	// Series Num
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	s = (w.getString(0x00080060)).trim();	// Modality
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	s = (w.getString(0x00080021)).trim();	// Series Date
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	int sopCount = this.countDirectories(root + "/" + seriesUIDs[idxSeries]);
	out.println("<TD>" + sopCount);		// Object Count

	s = (w.getString(0x0008103e)).trim();	// Series Description
	if (s.equals("")) {
	  s = "----";
	}
	out.println("<TD>" + s);

	out.println("</TR>");
      }
    }

    out.println("</TABLE>");
  }

  private int countDirectories(String path) {
    java.io.File f = new java.io.File(path);
    if (f == null) {
      return 0;
    }

    String[] dirNames=f.list();
    return dirNames.length;
  }

  private int countObjectsInStudy(String path) {
    int count = 0;
    java.io.File f = new java.io.File(path);
    if (f == null) {
      return 0;
    }

    String[] dirNames=f.list();
    if (dirNames == null || dirNames.length == 0) {
      return 0;
    }

    int idxSeries = 0;
    for (idxSeries = 0; idxSeries < dirNames.length; idxSeries++) {
      java.io.File sopDir = new java.io.File (path + "/" + dirNames[idxSeries]);
      if (sopDir != null) {
	String[] sopNames = sopDir.list();
	if (sopNames != null) {
	  count += sopNames.length;
	}
      }
    }
    return count;
  }

  DICOM.DICOMWrapper getWrapperFromStudy(String path) {
    java.io.File f = new java.io.File(path);
    if (f == null) {
      return null;
    }

    String[] seriesUIDs = f.list();
    if (seriesUIDs == null || seriesUIDs.length == 0) {
      return null;
    }

    String seriesPath = path + "/" + seriesUIDs[0];

    java.io.File seriesDir = new java.io.File(seriesPath);
    if (seriesDir == null) {
      return null;
    }

    String[] sopUIDs = seriesDir.list();
    if (sopUIDs == null || sopUIDs.length == 0) {
      return null;
    }

    String sopPath = seriesPath + "/" + sopUIDs[0];

    DICOM.DICOMWrapper w = new DICOM.DICOMWrapper(sopPath);

    return w;
  }

  DICOM.DICOMWrapper getWrapperFromSeries(String seriesPath) {
    java.io.File seriesDir = new java.io.File(seriesPath);
    if (seriesDir == null) {
      return null;
    }

    String[] sopUIDs = seriesDir.list();
    if (sopUIDs == null || sopUIDs.length == 0) {
      return null;
    }

    String sopPath = seriesPath + "/" + sopUIDs[0];

    DICOM.DICOMWrapper w = new DICOM.DICOMWrapper(sopPath);

    return w;
  }
}
