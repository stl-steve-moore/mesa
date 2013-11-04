
//***********************************************************
// Phillip DiCorpo
// Electronic Radiology Lab
// Washington University School of Medicine
// February, 2001
//
//  buildTree.js  (JavaScript)
//***********************************************************

//This buildTree Function will be used recursively to build
//the DICOM object tree from an XML doc

function buildTree(xmlNode, parentRef)
{
  for(var i=0; xmlNode.childNodes(i)!=null; i++){
    
    // Current node is element with single child of node type TEXT_NODE
    // (ie this is a DICOM attribute/value pair
    if(xmlNode.childNodes(i).hasChildNodes() &&
      (xmlNode.childNodes(i).childNodes(0).nodeType == 3)){
	//var childRef = insFld(parentRef, gFld(xmlNode.childNodes(i).nodeName, xmlNode.childNodes(i).text));
	//buildTree(xmlNode.childNodes(i), childRef);
 	insDoc(parentRef, gLnk(2, xmlNode.childNodes(i).nodeName, xmlNode.childNodes(i).text));
    }
    // There is a DICOM sequence
    else{
	var childRef = insFld(parentRef, gFld(xmlNode.childNodes(i).nodeName, ""));
	buildTree(xmlNode.childNodes(i), childRef);
	//insDoc(parentRef, gLnk(2, xmlNode.childNodes(i).nodeName, xmlNode.childNodes(i).text));
    }
  }	
}


//This function does the loading of the user selected file
//and directs script output to the viewer frame
// (top.doc = parent.frames.viewer.document)

function loadDoc(){

  //Reinitialize all our global data
  top.indexOfEntries = new Array
  top.USETEXTLINKS = 0 
  top.nEntries = 0 
  top.doc = 0 
  top.browserVersion = 0 
  top.selectedFolder=0
  topxmlDoc=0
  top.foldersTree = 0

  top.doc = parent.frames.viewer.document;
  top.doc.open();
  top.doc.close();
  if(parent.frames.input.document.FileForm.InputFile.value != ""){
    top.xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    top.xmlDoc.async="false";
    top.xmlDoc.load(parent.frames.input.document.FileForm.InputFile.value);

    rootNode = top.xmlDoc.childNodes(1);
    top.foldersTree = gFld(top.xmlDoc.childNodes(1).nodeName, parent.frames.input.document.FileForm.InputFile.value);
    buildTree(rootNode, top.foldersTree);
  }
  else
     {parent.frames.viewer.document.write("<b>Please select a DICOM file to view</b><br>")}
}

//Global Variables
//xmlDoc = 0;
