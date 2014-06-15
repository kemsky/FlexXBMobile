/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2012 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.annotation.contract
{
    import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
    import com.googlecode.flexxb.error.DescriptorParsingError;

    import mx.utils.StringUtil;

    /**
     * Defines a member of an XmlClass, that is, a field of the class definition.
     * The XmlMember is base for XmlAttribute and XmlElement since field values can
     * be rendered as XML in the form of attributes or elements.
     * <p/>A member's alias can define "virtual paths". Virtual paths allow definition
     * of complex xml structures for a field without complicating the model design. Thus,
     * structures can be present in the xml just by adding vistual paths in the alias
     * definition of a member.
     * <p/>Example: Lets assume the xml representation looks like:
     * <p/><code><pre>
     * &lt;myPathTester&gt;
     *      &lt;anotherSub attTest="Thu Mar 19 15:49:32 GMT+0200 2009"/&gt;
     *      This is Default!!!
     *      &lt;subObject&gt;
     *        &lt;id&gt;
     *          2
     *        &lt;/id&gt;
     *        &lt;subSubObj&gt;
     *          &lt;ref&gt;
     *            ReferenceTo
     *          &lt;/ref&gt;
     *        &lt;/subSubObj&gt;
     *      &lt;/subObject&gt;
     *    &lt;/myPathTester&gt;
     * </pre></code>
     * <p/>This would normally translate itself in about 4 model classes. Using virtual paths, one can describe it in just one model class:
     * <p/><code><pre>
     * [XmlClass(alias="myPathTester", defaultValueField="defaultTest")]
     *    public class XmlPathObject
     *    {
	 *		[XmlElement(alias="subObject/id")]
	 *		public var identity : Number = 2;
	 *		[XmlElement(alias="subObject/subSubObj/ref")]
	 *		public var reference : String = "ReferenceTo";
	 *		[XmlArray(alias="subObject/list")]
	 *		public var list : Array;
	 *		[XmlAttribute(alias="anotherSub/attTest")]
	 *		public var test : Date = new Date();
	 *		[XmlElement()]
	 *		public var defaultTest : String = "This is Default!!!"
	 *
	 *		public function XmlPathObject()
	 *		{
	 *		}
	 *	}
     * </pre></code>
     * @author aCiobanu
     *
     */
    public class XmlMember extends Annotation implements IMemberAnnotation
    {
        public var ignoreOn:Stage;

        public var order:Number;

        public var classAnnotation:XmlClass;

        public var ownerClass:XmlClass;

        public var accessor:AccessorType;

        public var defaultSetValue:String;

        public var isIDRef:Boolean;

        public var hasNamespaceRef:Boolean;

        public var readOnly:Boolean;

        public var writeOnly:Boolean;

        public var isRequired:Boolean;

        public var isDefaultValue:Boolean;

        /**
         * Constructor
         * @param descriptor xml descriptor of the class field
         * @param _class owner XmlClass entity
         *
         */
        public function XmlMember(descriptor:MetaDescriptor = null)
        {
            super(descriptor);
        }

        protected override function parse(descriptor:MetaDescriptor):void
        {
            classAnnotation = descriptor.owner as XmlClass;
            isDefaultValue =  classAnnotation && classAnnotation.valueField == this;
            ownerClass = descriptor.owner as XmlClass;
            super.parse(descriptor);
            accessor = descriptor.fieldAccess;
            readOnly = accessor.isReadOnly();
            writeOnly = accessor.isWriteOnly();
            hasNamespaceRef = namespaceRef && StringUtil.trim(namespaceRef).length > 0;
            ignoreOn = Stage.fromString(descriptor.attributes[Constants.IGNORE_ON]);
            setOrder(descriptor.attributes[Constants.ORDER]);
            defaultSetValue = descriptor.attributes[Constants.DEFAULT];
            isIDRef = descriptor.getBoolean(Constants.IDREF);
            isRequired = descriptor.getBoolean(Constants.REQUIRED);
        }

        protected override function setAlias(value:String):void
        {
            super.setAlias(value);
            if (classAnnotation && classAnnotation.isPath)
            {
                var path:Array = classAnnotation.qualifiedPathElements;
                if (!qualifiedPathElements)
                {
                    qualifiedPathElements = [];
                }
                qualifiedPathElements.unshift(classAnnotation.xmlName);
                for (var i:int = path.length - 1; i > 0; i--)
                {
                    qualifiedPathElements.unshift(path[i]);
                }
            }
        }

        protected function setOrder(value:String):void
        {
            if (value)
            {
                var nr:Number;
                try
                {
                    nr = Number(value);
                } catch (error:Error)
                {
                    throw new DescriptorParsingError(ownerClass.type, name.localName, "The order attribute of the annotation is invalid as number");
                }
                order = nr;
            }
        }
    }
}