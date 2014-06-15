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
package com.googlecode.flexxb.annotation
{
    import avmplus.R;
    import avmplus.RObject;

    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import com.googlecode.flexxb.annotation.contract.Constants;
    import com.googlecode.flexxb.annotation.contract.ConstructorArgument;
    import com.googlecode.flexxb.annotation.parser.MetaParser;
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.flexxb.annotation.contract.Annotation;
    import com.googlecode.flexxb.annotation.contract.XmlArray;
    import com.googlecode.flexxb.annotation.contract.XmlAttribute;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlConstants;
    import com.googlecode.flexxb.annotation.contract.XmlElement;
    import com.googlecode.flexxb.annotation.contract.XmlNamespace;
    import com.googlecode.flexxb.serializer.XmlArraySerializer;
    import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
    import com.googlecode.flexxb.serializer.XmlClassSerializer;
    import com.googlecode.flexxb.serializer.XmlElementSerializer;
    import com.googlecode.testData.ConstructorRefObj;
    import com.googlecode.testData.Mock;

    import flash.utils.describeType;

    import org.flexunit.Assert;

    public class XmlClassTest extends AnnotationTest
    {

        [Test]
        public function testConstructorParameters():void
        {
            var target:ConstructorRefObj = new ConstructorRefObj("test", 1, true);
            FxBEngine.instance.getXmlSerializer().serialize(null);
            var parser:MetaParser = new MetaParser(factory);
            var descriptor:XML = describeType(ConstructorRefObj);
            var json:RObject = R.describeFromXML(descriptor, R.VARIABLES | R.TRAITS | R.METADATA | R.METHODS | R.ACCESSORS | R.BASES | R.CONSTRUCTOR);
            var cls:XmlClass = parser.parseDescriptor(json)[0];
            Assert.assertFalse("Class constructor should not be default", cls.constructor.isDefault);
            Assert.assertNotNull("ParameterFields is Null", cls.constructor.parameterFields);
            Assert.assertEquals("There are more or less than 3 parameters", 3, cls.constructor.parameterFields.length);
        }

        private var factory:AnnotationFactory;

        [Before]
        public function before():void
        {
            factory = FxBEngine.instance.getXmlSerializer().factory;
            factory.registerAnnotation(ConstructorArgument.ANNOTATION_CONSTRUCTOR_ARGUMENT, ConstructorArgument, null, null);
            factory.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer, null);
            factory.registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer, null);
            factory.registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer, null);
            factory.registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer, null);
            factory.registerAnnotation(XmlConstants.ANNOTATION_NAMESPACE, XmlNamespace, null, null);
        }

        protected override function runTest(descriptor:RObject):void
        {
            var parser:MetaParser = new MetaParser(factory);
            var clss:Array = parser.parseDescriptor(descriptor);
            var a:XmlClass = clss[0];
            if (a.version == "v2")
            {
                validate(a, "Mock", Mock, "V2", "ulala", "www.me.com");
            }
            else
            {
                validate(a, "Mock", Mock, "MyClass", "test", "http://www.test.com/xmlns/pp/v1");
            }
            a = clss[1];
            if (a.version == "v2")
            {
                validate(a, "Mock", Mock, "V2", "ulala", "www.me.com");
            }
            else
            {
                validate(a, "Mock", Mock, "MyClass", "test", "http://www.test.com/xmlns/pp/v1");
            }
        }

        protected override function customValidate(annotation:Annotation, ...args):void
        {
            Assert.assertEquals("Namespace prefix is incorrect", args[3], annotation.nameSpace.prefix);
            Assert.assertEquals("Namespace uri is incorrect", args[4], annotation.nameSpace.uri);
        }
    }
}