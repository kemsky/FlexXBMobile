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
    import com.googlecode.testData.Mock;
    import com.googlecode.testData.VectoredElement;

    import flash.utils.describeType;

    import org.flexunit.Assert;
    import org.flexunit.assertThat;
    import org.hamcrest.object.equalTo;

    public class XmlArrayTest extends AnnotationTest
    {

        protected override function runTest(descriptor:RObject):void
        {
            var parser:MetaParser = new MetaParser(factory);
            var att1:XmlArray = new XmlArray(parser.parseField(getFieldDescriptor("result", descriptor))[0]);
            validate(att1, "result", Array, "data", null, false, Mock);
        }

        protected override function customValidate(annotation:Annotation, ...args):void
        {
            Assert.assertEquals("IgnoreOn is incorrect", args[3], XmlArray(annotation).ignoreOn);
            Assert.assertEquals("SerializePartialElement is incorrect", args[4], XmlArray(annotation).serializePartialElement);
            Assert.assertEquals("Type is incorrect", args[5], XmlArray(annotation).memberType);
        }

        private var factory:AnnotationFactory;

        [Before]
        public function before():void
        {
            factory = FxBEngine.instance.getXmlSerializer().factory;

            factory.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer, null);
            factory.registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer, null);
            factory.registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer, null);
            factory.registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer, null);
            factory.registerAnnotation(XmlConstants.ANNOTATION_NAMESPACE, XmlNamespace, null, null);
        }

        [Test]
        public function validateVectorSupport():void
        {
            var parser:MetaParser = new MetaParser(factory);
            var descriptor:XML = describeType(VectoredElement);
            var xml:RObject = R.describeFromXML(descriptor, R.VARIABLES | R.TRAITS | R.METADATA | R.METHODS | R.ACCESSORS | R.BASES | R.CONSTRUCTOR);
            var att1:XmlArray = new XmlArray(parser.parseField(xml.traits.variables[0])[0]);
            assertThat(att1.type, equalTo(Vector.<String>));
            assertThat(att1.memberType, equalTo(String));
        }
    }
}