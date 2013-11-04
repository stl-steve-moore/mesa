//**************************************************************** 
// You are free to copy the "Folder-Tree" script as long as you  
// keep this copyright notice: 
// Script found in: http://www.geocities.com/Paris/LeftBank/2178/ 
// Author: Marcelino Alves Martins (martins@hks.com) December '97. 
//**************************************************************** 
//
// Modified quite a bit by Phil DiCorpo for use by
// Electronoic Radiology Lab, Washington University School of Medicine
// February, 2001
//
//*******************************************************************

//Log of changes: 
//       17 Feb 98 - Fix initialization flashing problem with Netscape
//       
//       27 Jan 98 - Root folder starts open; support for USETEXTLINKS; 
//                   make the ftien4 a js file 
//       
 
 
// Definition of class Folder 
// ***************************************************************** 
 
function Folder(folderDescription, folderValue) //constructor 
{ 
  //constant data 
  this.desc = folderDescription 
  this.hreference = folderValue
  this.value = folderValue 
  this.id = -1   
  this.navObj = 0  
  this.iconImg = 0  
  this.nodeImg = 0  
  this.isLastNode = 0 
 
  //dynamic data 
  this.isOpen = true 
  this.iconSrc = "graphics/ftv2folderopen.gif"   
  this.children = new Array 
  this.nChildren = 0 
 
  //methods 
  this.initialize = initializeFolder 
  this.setState = setStateFolder 
  this.addChild = addChild 
  this.createIndex = createEntryIndex 
  this.hide = hideFolder 
  this.display = display 
  this.renderOb = drawFolder 
  this.totalHeight = totalHeight 
  this.subEntries = folderSubEntries 
  this.outputLink = outputFolderLink 
} 
 
function setStateFolder(isOpen) 
{ 
  var subEntries 
  var totalHeight 
  var fIt = 0 
  var i=0 
 
  if (isOpen == this.isOpen) 
    return 
 
  if (top.browserVersion == 2)  
  { 
    totalHeight = 0 
    for (i=0; i < this.nChildren; i++) 
      totalHeight = totalHeight + this.children[i].navObj.clip.height 
      subEntries = this.subEntries() 
    if (this.isOpen) 
      totalHeight = 0 - totalHeight 
    for (fIt = this.id + subEntries + 1; fIt < top.nEntries; fIt++) 
      top.indexOfEntries[fIt].navObj.moveBy(0, totalHeight) 
  }  
  this.isOpen = isOpen 
  propagateChangesInState(this) 
} 
 
function propagateChangesInState(folder) 
{   
  var i=0 
 
  if (folder.isOpen) 
  { 
    if (folder.nodeImg) 
      if (folder.isLastNode) 
        folder.nodeImg.src = "graphics/ftv2mlastnode.gif" 
      else 
	  folder.nodeImg.src = "graphics/ftv2mnode.gif" 
    folder.iconImg.src = "graphics/ftv2folderopen.gif" 
    for (i=0; i<folder.nChildren; i++) 
      folder.children[i].display() 
  } 
  else 
  { 
    if (folder.nodeImg) 
      if (folder.isLastNode) 
        folder.nodeImg.src = "graphics/ftv2plastnode.gif" 
      else 
	  folder.nodeImg.src = "graphics/ftv2pnode.gif" 
    folder.iconImg.src = "graphics/ftv2folderclosed.gif" 
    for (i=0; i<folder.nChildren; i++) 
      folder.children[i].hide() 
  }  
} 
 
function hideFolder() 
{ 
  if (top.browserVersion == 1) { 
    if (this.navObj.style.display == "none") 
      return 
    this.navObj.style.display = "none" 
  } else { 
    if (this.navObj.visibility == "hiden") 
      return 
    this.navObj.visibility = "hiden" 
  } 
   
  this.setState(0) 
} 
 
function initializeFolder(level, lastNode, leftSide) 
{ 
var j=0 
var i=0 
var numberOfFolders 
var numberOfDocs 
var nc 
      
  nc = this.nChildren 
   
  this.createIndex() 
 
  var auxEv = "" 
 
  if (top.browserVersion > 0) 
    auxEv = "<a href='javascript:clickOnNode("+this.id+")'>" 
  else 
    auxEv = "<a>" 
 
  if (level>0) 
    if (lastNode) //the last 'brother' in the children array 
    { 
      this.renderOb(leftSide + auxEv + "<img name='nodeIcon" + this.id + "' src='graphics/ftv2mlastnode.gif' width=16 height=22 border=0></a>") 
      leftSide = leftSide + "<img src='graphics/ftv2blank.gif' width=16 height=22>"  
      this.isLastNode = 1 
    } 
    else 
    { 
      this.renderOb(leftSide + auxEv + "<img name='nodeIcon" + this.id + "' src='graphics/ftv2mnode.gif' width=16 height=22 border=0></a>") 
      leftSide = leftSide + "<img src='graphics/ftv2vertline.gif' width=16 height=22>" 
      this.isLastNode = 0 
    } 
  else 
    this.renderOb("") 
   
  if (nc > 0) 
  { 
    level = level + 1 
    for (i=0 ; i < this.nChildren; i++)  
    { 
      if (i == this.nChildren-1) 
        this.children[i].initialize(level, 1, leftSide) 
      else 
        this.children[i].initialize(level, 0, leftSide) 
      } 
  } 
} 
 
function drawFolder(leftSide) 
{ 
  if (top.browserVersion == 2) { 
    if (!top.doc.yPos) 
      top.doc.yPos=8 
    top.doc.write("<layer id='folder" + this.id + "' top=" + top.doc.yPos + " visibility=hiden>") 
  } 
   
  top.doc.write("<table ") 
  if (top.browserVersion == 1) 
    top.doc.write(" id='folder" + this.id + "' style='position:block;' ") 
  top.doc.write(" border=0 cellspacing=0 cellpadding=0>") 
  top.doc.write("<tr><td>") 
  top.doc.write(leftSide) 
  this.outputLink() 
  top.doc.write("<img name='folderIcon" + this.id + "' ") 
  top.doc.write("src='" + this.iconSrc+"' border=0></a>") 
  top.doc.write("</td><td valign=middle nowrap>") 
  if (top.USETEXTLINKS) 
  { 
    this.outputLink() 
    top.doc.write(this.desc + "</a>") 
  } 
  else 
    top.doc.write(this.desc+": <b>"+this.value+"</b>") 
  top.doc.write("</td>")  
  top.doc.write("</table>") 
   
  if (top.browserVersion == 2) { 
    top.doc.write("</layer>") 
  } 
 
  if (top.browserVersion == 1) { 
    this.navObj = top.doc.all["folder"+this.id] 
    this.iconImg = top.doc.all["folderIcon"+this.id] 
    this.nodeImg = top.doc.all["nodeIcon"+this.id] 
  } else if (top.browserVersion == 2) { 
    this.navObj = top.doc.layers["folder"+this.id] 
    this.iconImg = this.navObj.document.images["folderIcon"+this.id] 
    this.nodeImg = this.navObj.document.images["nodeIcon"+this.id] 
    top.doc.yPos=top.doc.yPos+this.navObj.clip.height 
  } 
} 
 
function outputFolderLink() 
{ 
  if (this.hreference) 
  { 
    top.doc.write("<a href='" + this.hreference + "' TARGET=\"basefrm\" ") 
    if (top.browserVersion > 0) 
      top.doc.write("onClick='javascript:clickOnFolder("+this.id+")'") 
    top.doc.write(">") 
  } 
  else 
    top.doc.write("<a>") 
//  top.doc.write("<a href='javascript:clickOnFolder("+this.id+")'>")   
} 
 
function addChild(childNode) 
{ 
  this.children[this.nChildren] = childNode 
  this.nChildren++ 
  return childNode 
} 
 
function folderSubEntries() 
{ 
  var i = 0 
  var se = this.nChildren 
 
  for (i=0; i < this.nChildren; i++){ 
    if (this.children[i].children) //is a folder 
      se = se + this.children[i].subEntries() 
  } 
 
  return se 
} 
 
 
// Definition of class Item (a document or link inside a Folder) 
// ************************************************************* 
 
function Item(itemDescription, itemLink) // Constructor 
{ 
  // constant data 
  this.desc = itemDescription 
  this.link = itemLink 
  this.id = -1 //initialized in initalize() 
  this.navObj = 0 //initialized in render() 
  this.iconImg = 0 //initialized in render() 
  //this.iconSrc = "graphics/ftv2doc.gif" 
  this.iconSrc = "graphics/dcmitem.jpg" 

  // methods 
  this.initialize = initializeItem 
  this.createIndex = createEntryIndex 
  this.hide = hideItem 
  this.display = display 
  this.renderOb = drawItem 
  this.totalHeight = totalHeight 
} 
 
function hideItem() 
{ 
  if (top.browserVersion == 1) { 
    if (this.navObj.style.display == "none") 
      return 
    this.navObj.style.display = "none" 
  } else { 
    if (this.navObj.visibility == "hiden") 
      return 
    this.navObj.visibility = "hiden" 
  }     
} 
 
function initializeItem(level, lastNode, leftSide) 
{  
  this.createIndex() 
 
  if (level>0) 
    if (lastNode) //the last 'brother' in the children array 
    { 
      this.renderOb(leftSide + "<img src='graphics/ftv2lastnode.gif' width=16 height=22>") 
      leftSide = leftSide + "<img src='graphics/ftv2blank.gif' width=16 height=22>"  
    } 
    else 
    { 
      this.renderOb(leftSide + "<img src='graphics/ftv2node.gif' width=16 height=22>") 
      leftSide = leftSide + "<img src='graphics/ftv2vertline.gif' width=16 height=22>" 
    } 
  else 
    this.renderOb("")   
} 
 
function drawItem(leftSide) 
{ 
  if (top.browserVersion == 2) 
    top.doc.write("<layer id='item" + this.id + "' top=" + top.doc.yPos + " visibility=hiden>") 
     
  top.doc.write("<table ") 
  if (top.browserVersion == 1) 
    top.doc.write(" id='item" + this.id + "' style='position:block;' ") 
  top.doc.write(" border=0 cellspacing=0 cellpadding=0>") 
  top.doc.write("<tr><td>") 
  top.doc.write(leftSide) 
  //top.doc.write("<a href=" + this.link + ">") 
  top.doc.write("<img id='itemIcon"+this.id+"' ") 
  top.doc.write("src='"+this.iconSrc+"' border=0>") 
  //top.doc.write("</a>") 
  top.doc.write("</td><td valign=middle nowrap>") 
  if (top.USETEXTLINKS) 
    //top.doc.write("<a href=" + this.link + ">" + this.desc + "</a>")
    top.doc.write(this.desc+": <b>"+this.link+"</b>"); 
  else 
    top.doc.write(this.desc+": <b>"+this.link+"</b>") 
  top.doc.write("</table>") 
   
  if (top.browserVersion == 2) 
    top.doc.write("</layer>") 
 
  if (top.browserVersion == 1) { 
    this.navObj = top.doc.all["item"+this.id] 
    this.iconImg = top.doc.all["itemIcon"+this.id] 
  } else if (top.browserVersion == 2) { 
    this.navObj = top.doc.layers["item"+this.id] 
    this.iconImg = this.navObj.document.images["itemIcon"+this.id] 
    top.doc.yPos=top.doc.yPos+this.navObj.clip.height 
  } 
} 
 
 
// Methods common to both objects (pseudo-inheritance) 
// ******************************************************** 
 
function display() 
{ 
  if (top.browserVersion == 1) 
    this.navObj.style.display = "block" 
  else 
    this.navObj.visibility = "show" 
} 
 
function createEntryIndex() 
{ 
  this.id = top.nEntries 
  top.indexOfEntries[top.nEntries] = this 
  top.nEntries++ 
} 
 
// total height of subEntries open 
function totalHeight() //used with top.browserVersion == 2 
{ 
  var h = this.navObj.clip.height 
  var i = 0 
   
  if (this.isOpen) //is a folder and _is_ open 
    for (i=0 ; i < this.nChildren; i++)  
      h = h + this.children[i].totalHeight() 
 
  return h 
} 
 
 
// Events 
// ********************************************************* 
 
function clickOnFolder(folderId) 
{ 
  var clicked = top.indexOfEntries[folderId] 
 
  if (!clicked.isOpen) 
    clickOnNode(folderId) 
 
  return  
 
  if (clicked.isSelected) 
    return 
} 
 
function clickOnNode(folderId) 
{ 
  var clickedFolder = 0 
  var state = 0 
 
  clickedFolder = top.indexOfEntries[folderId] 
  state = clickedFolder.isOpen 
 
  clickedFolder.setState(!state) //open<->close  
} 
 
function initializeDocument() 
{ 
 if(parent.frames.input.document.FileForm.InputFile.value != ""){
  top.doc.write("<head><link rel='stylesheet' href='scripts/buildTree.css'></head><body>");
  top.doc.write("<script src='scripts/buildTreeLib.js'></script><script src='scripts/buildTree.js'></script>");

  if (top.doc.all) 
    top.browserVersion = 1 //IE4   
  else 
    if (top.doc.layers) 
      top.browserVersion = 2 //NS4 
    else 
      top.browserVersion = 0 //other 
 
  top.foldersTree.initialize(0, 1, "") 
  top.foldersTree.display()
  
  if (top.browserVersion > 0) 
  { 
    top.doc.write("<layer top="+top.indexOfEntries[top.nEntries-1].navObj.top+">&nbsp;</layer>") 
 
    // close the whole tree 
    clickOnNode(0) 
    // open the root folder 
    clickOnNode(0) 
  }
  top.doc.write("</body>");
 } 
} 
 
// Auxiliary Functions for Folder-Treee backward compatibility 
// ********************************************************* 
 
//function gFld(description, hreference) 
function gFld(description, value)
{ 
  var folder = new Folder(description, value) 
  return folder 
} 
 
function gLnk(target, description, linkData) 
{ 
  //fullLink = "" 
 
  //if (target==0) 
  //{ 
  //  fullLink = "'"+linkData+"' target=\"basefrm\"" 
  //} 
  //else 
  //{ 
  //  if (target==1) 
  //     fullLink = "'http://"+linkData+"' target=_blank" 
  //  else 
  //     fullLink = "'http://"+linkData+"' target=\"basefrm\"" 
  //} 
 
  //linkItem = new Item(description, fullLink)   
  var linkItem = new Item(description, linkData);
  return linkItem 
} 
 
function insFld(parentFolder, childFolder) 
{ 
  return parentFolder.addChild(childFolder) 
} 
 
function insDoc(parentFolder, document) 
{ 
  parentFolder.addChild(document) 
} 
 
// Global variables 
// **************** 
 
//USETEXTLINKS = 0 
//indexOfEntries = new Array 
//nEntries = 0 
//doc = parent.frames.viewer.document 
//doc = document
//browserVersion = 0 
//selectedFolder=0
