//=============================================================================
// ListElement
//
// G-Flex: Generic doubly-linked list class
//=============================================================================
class ListElement extends ExtensionObject;

var	travel ListElement Next;
var travel ListElement Previous;
var        Object      Contents;

//G-Flex: add a new element to the list
function ListElement AddContents(Object newContents, optional bool bAllowDuplicates)
{
	local ListElement element, prev;
	if (!bAllowDuplicates)
	{
		element = GetContents(newContents);
		if (element != None)
			return element;
	}
	element = Self;
	while (element != None)
	{
		//G-Flex: in case a referenced actor is destroyed
		if (element.Contents == None)
		{
			element.Contents = newContents;
			return element;
		}
		prev = element;
		element = element.Next;
	}
	//G-Flex: at the end of the list
	element = new (None) class'ListElement';
	if (element != None)
	{
		prev.Next = element;
		element.Contents = newContents;
		element.Previous = prev;
		return element;
	}
	
	return None;
}

//G-Flex: find an element containing a specific object
function ListElement GetContents(Object checkContents)
{
	local ListElement element;
	element = Self;
	while (element != None)
	{
		if (element.Contents == checkContents)
			return element;
		element = element.Next;
	}
	return None;	
}

//G-Flex: remove an element containing a specific object
//G-Flex: returns the element now occupying its position
function ListElement DeleteContents(Object checkContents)
{
	local ListElement element, replacement;
	element = GetContents(checkContents);
	replacement = None;
	if (element != None)
		replacement = Delete(element);
	return replacement;
}

//G-Flex: unlinks an element from the list and deletes it
//G-Flex: returns the element now occupying its position
function ListElement Delete(ListElement element)
{
	local ListElement replacement;

	element.Contents = None;
	if (element.Previous != None)
		element.Previous.Next = element.Next;
	if (element.Next != None)
	{
		replacement = element.Next;
		element.Next.Previous = element.Previous;
	}
	CriticalDelete(element);
	return replacement;
}

//G-Flex: clears contents, deletes all elements but first
function ClearList()
{
	local ListElement element;
	element = Next;
	while (element != None)
		element = Delete(element);
	Contents = None;
	Next = None;
	Previous = None;
}

//G-Flex: debug function for listing all elements in the list
function string ListValues()
{
	local ListElement element;
	local string str;
	element = Self;
	if (element.Contents != None)
		str = String(element.Contents.Name);
	else
		str = "None";
	element = element.Next;
	while (element != None)
	{
		if (element.Contents != None)
			str = str $ ", " $ element.Contents.Name;
		else
			str = str $ ", " $ "None";
		element = element.Next;
	}
	return str;
}

defaultproperties
{
}
