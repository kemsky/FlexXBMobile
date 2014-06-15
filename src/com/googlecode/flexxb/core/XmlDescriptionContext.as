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
package com.googlecode.flexxb.core
{
    import com.googlecode.flexxb.annotation.contract.XmlArray;
    import com.googlecode.flexxb.annotation.contract.XmlAttribute;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlConstants;
    import com.googlecode.flexxb.annotation.contract.XmlElement;
    import com.googlecode.flexxb.annotation.contract.XmlNamespace;
    import com.googlecode.flexxb.annotation.contract.Constants;
    import com.googlecode.flexxb.annotation.contract.ConstructorArgument;
    import com.googlecode.flexxb.api.XmlApiArray;
    import com.googlecode.flexxb.api.XmlApiAttribute;
    import com.googlecode.flexxb.api.XmlApiClass;
    import com.googlecode.flexxb.api.XmlApiElement;
    import com.googlecode.flexxb.api.XmlApiNamespace;
    import com.googlecode.flexxb.converter.ClassTypeConverter;
    import com.googlecode.flexxb.converter.IConverter;
    import com.googlecode.flexxb.converter.XmlConverter;
    import com.googlecode.flexxb.serializer.XmlArraySerializer;
    import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
    import com.googlecode.flexxb.serializer.XmlClassSerializer;
    import com.googlecode.flexxb.serializer.XmlElementSerializer;
    import com.googlecode.flexxb.util.XmlUtils;

    import flash.utils.Dictionary;

    /**
     *
     * @author Alexutz
     *
     */
    public final class XmlDescriptionContext
    {
        public var store:DescriptorStore;
        public var serializer:SerializationCore;
        private var classNamespaceMap:Dictionary = new Dictionary();

        public var configuration:Configuration;

        public function XmlDescriptionContext()
        {
            configuration = new Configuration();
        }

        public final function initializeContext(descriptorStore:DescriptorStore, core:SerializationCore):void
        {
            this.store = descriptorStore;
            this.serializer = core;

            registerSimpleTypeConverter(new ClassTypeConverter());
            registerSimpleTypeConverter(new XmlConverter());

            //register the annotations we know must always exist
            registerAnnotation(ConstructorArgument.ANNOTATION_CONSTRUCTOR_ARGUMENT, ConstructorArgument, null);
            registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
            registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer);
            registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer);
            registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer);
            registerAnnotation(XmlConstants.ANNOTATION_NAMESPACE, XmlNamespace, null);

            setApiClasses(XmlApiClass, XmlApiArray, XmlApiAttribute, XmlApiElement, XmlApiNamespace);
        }


        public function handleDescriptors(descriptors:Array):void
        {
            for each(var classDescriptor:XmlClass in descriptors)
            {
                //if the class descriptor defines a namespace, register it in the namespace map
                if (classDescriptor.nameSpace)
                {
                    classNamespaceMap[classDescriptor.nameSpace.uri] = classDescriptor.type;
                }
            }
        }

        /**
         *
         * @param object
         * @return
         *
         */
        public function getNamespace(object:Object, version:String = ""):Namespace
        {
            if (object)
            {
                var desc:XmlClass = store.getDescriptor(object, version) as XmlClass;
                if (desc)
                {
                    return desc.nameSpace;
                }
            }
            return null;
        }

        /**
         *
         * @param object
         * @return
         *
         */
        public function getXmlName(object:Object, version:String = ""):QName
        {
            if (object != null)
            {
                var classDescriptor:XmlClass = store.getDescriptor(object, version);
                if (classDescriptor)
                {
                    return classDescriptor.xmlName;
                }
            }
            return null;
        }


        public function getIncomingType(source:Object):Class
        {
            var incomingXML:XML = source as XML;
            if (incomingXML)
            {
                if (configuration.getResponseTypeByXsiType)
                {
                    var xsiType:String = incomingXML.attribute(XmlUtils.xsiType).toString();
                    if (xsiType)
                    {
                        //check if xsiType contains a qualified reference (e.g. xsi:type="a:Item")
                        if (xsiType.indexOf(":") != -1)
                        {
                            //this will return the first XMLCLass alias match irrespective of namespace.
                            //In order to check more accurately (e.g. match by xmlName) descriptorStore.getClassReferenceByCriteria
                            //would need to support values other than strings
                            xsiType = xsiType.split(":")[1];
                        }
                        clasz = store.getClassReferenceByCriteria("alias", xsiType, "");
                        if (clasz)
                        {
                            return clasz;
                        }
                    }
                }
                if (configuration.getResponseTypeByTagName)
                {
                    var tagName:QName = incomingXML.name() as QName;
                    if (tagName)
                    {
                        var clasz:Class = store.getClassReferenceByCriteria("alias", tagName.localName, "");
                        if (clasz)
                        {
                            return clasz;
                        }
                    }
                }
                if (configuration.getResponseTypeByNamespace)
                {
                    if (incomingXML.namespaceDeclarations().length > 0)
                    {
                        var _namespace:String = (incomingXML.namespaceDeclarations()[0] as Namespace).uri;
                        return classNamespaceMap[_namespace];
                    }
                }
            }
            return null;
        }

        /**
         * Register a converter instance for a specific type
         * @param converter converter instance
         * @param overrideExisting override existing registrations under the same class type
         * @return
         *
         */
        public final function registerSimpleTypeConverter(converter:IConverter, overrideExisting:Boolean = false):Boolean
        {
            return serializer.registerSimpleTypeConverter(converter, overrideExisting);
        }

        public final function getSimpleTypes():Dictionary
        {
            return serializer.simpleTypes;
        }

        /**
         * Register a new annotation and its serializer. If it finds a registration with the
         * same name and <code>overrideExisting </code> is set to <code>false</code>, it will disregard the current attempt and keep the old value.
         * @param name the name of the annotation to be registered
         * @param annotationClazz annotation class type
         * @param serializerInstance instance of the serializer that will handle this annotation
         * @param overrideExisting override existing registrations under the same name
         *
         */
        public final function registerAnnotation(name:String, annotationClazz:Class, serializer:Class, overrideExisting:Boolean = false):void
        {
            store.factory.registerAnnotation(name, annotationClazz, serializer, this, overrideExisting);
        }

        /**
         * Specify api classes that reflect the defined annotations.
         * @param args
         */
        public final function setApiClasses(...args):void
        {
            for each(var type:Class in args)
            {
                if (type is Class)
                {
                    store.getDescriptor(type);
                }
            }
        }
    }
}