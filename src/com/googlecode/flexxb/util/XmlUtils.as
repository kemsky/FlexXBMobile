package com.googlecode.flexxb.util
{
    import com.googlecode.flexxb.annotation.contract.Annotation;

    public final class XmlUtils
    {
        public static const template:XML = new XML("<xml/>");

        public static const xsiNamespace:Namespace = new Namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance");
        /**
         * Qualified name of the xml schema type attribute
         */
        public static const xsiType:QName = new QName(xsiNamespace, "type");
        /**
         * Qualified name of the xml schema nil attribute
         */
        public static const xsiNil:QName = new QName(xsiNamespace, "nil");

        /**
         *
         * @param ns
         * @param xml
         * @return
         *
         */
        public static function mustAddNamespace(ns:Namespace, xml:XML):Boolean
        {
            var inScopeNs:Array = xml.inScopeNamespaces();
            for each(var inNs:Namespace in inScopeNs)
            {
                if (inNs.uri == ns.uri)
                {
                    return false;
                }
            }
            return true;
        }

        /**
         *
         * @param element
         * @param xmlData
         * @return
         *
         */
        public static function getPathElement(element:Annotation, xmlData:XML):XML
        {
            var xmlElement:XML;
            var list:XMLList;
            var pathElement:QName;
            for (var i:int = 0; i < element.qualifiedPathElements.length; i++)
            {
                pathElement = element.qualifiedPathElements[i];
                if (!xmlElement)
                {
                    list = xmlData.child(pathElement);
                }
                else
                {
                    list = xmlElement.child(pathElement);
                }
                if (list.length() > 0)
                {
                    xmlElement = list[0];
                }
                else
                {
                    xmlElement = null;
                    break;
                }
            }
            return xmlElement;
        }

        /**
         *
         * @param element
         * @param xmlParent
         * @param serializedChild
         * @return
         *
         */
        public static function setPathElement(element:Annotation, xmlParent:XML):XML
        {
            var cursor:XML = xmlParent;
            for each (var pathElement:QName in element.qualifiedPathElements)
            {
                var path:XMLList = cursor.child(pathElement);
                if (path.length() > 0)
                {
                    cursor = path[0];
                }
                else
                {
                    var pathItem:XML = XmlUtils.template.copy();
                    pathItem.setName(pathElement);
                    cursor.appendChild(pathItem);
                    cursor = pathItem;
                }
            }
            return cursor;
        }

        public function XmlUtils()
        {
            throw new Error("Use static members");
        }
    }
}