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
package com.googlecode.flexxb.xml.api
{
    import avmplus.RMember;
    import avmplus.R;
    import avmplus.RObject;

    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import com.googlecode.flexxb.annotation.contract.AccessorType;
    import com.googlecode.flexxb.annotation.contract.Constants;
    import com.googlecode.flexxb.annotation.contract.ConstructorArgument;
    import com.googlecode.flexxb.annotation.contract.Stage;
    import com.googlecode.flexxb.annotation.parser.MetaParser;
    import com.googlecode.flexxb.api.FxApiWrapper;
    import com.googlecode.flexxb.api.XmlApiArray;
    import com.googlecode.flexxb.api.XmlApiAttribute;
    import com.googlecode.flexxb.api.XmlApiClass;
    import com.googlecode.flexxb.api.XmlApiElement;
    import com.googlecode.flexxb.api.XmlApiMember;
    import com.googlecode.flexxb.api.flexxb_api_internal;
    import com.googlecode.flexxb.converter.W3CDateConverter;
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.flexxb.annotation.contract.XmlArray;
    import com.googlecode.flexxb.annotation.contract.XmlAttribute;
    import com.googlecode.flexxb.annotation.contract.XmlClass;
    import com.googlecode.flexxb.annotation.contract.XmlConstants;
    import com.googlecode.flexxb.annotation.contract.XmlElement;
    import com.googlecode.flexxb.annotation.contract.XmlMember;
    import com.googlecode.flexxb.annotation.contract.XmlNamespace;
    import com.googlecode.flexxb.serializer.XmlArraySerializer;
    import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
    import com.googlecode.flexxb.serializer.XmlClassSerializer;
    import com.googlecode.flexxb.serializer.XmlElementSerializer;
    import com.googlecode.testData.APITestObject;
    import com.googlecode.testData.Address;
    import com.googlecode.testData.Mock;
    import com.googlecode.testData.Person;
    import com.googlecode.testData.PhoneNumber;

    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;

    import org.flexunit.Assert;

    /**
     *
     * @author Alexutz
     *
     */
    public class FxApiComponentTest
    {

        private var factory:AnnotationFactory;

        public function FxApiComponentTest()
        {
            new PhoneNumber();
            new Person();
            new Address();
            FxBEngine.instance.api.processTypeDescriptor(null);
            factory = FxBEngine.instance.getXmlSerializer().factory;
            factory.registerAnnotation(ConstructorArgument.ANNOTATION_CONSTRUCTOR_ARGUMENT, ConstructorArgument, null, null);
            factory.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer, null);
            factory.registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer, null);
            factory.registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer, null);
            factory.registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer, null);
            factory.registerAnnotation(XmlConstants.ANNOTATION_NAMESPACE, XmlNamespace, null, null);
        }

        [Test]
        public function testFxAttribute():void
        {
            var api:XmlApiAttribute = XmlApiAttribute.create("testAtt", String, null, 'aliasAttTest');
            var descriptor:RMember = FxBEngine.instance.api.buildFieldDescriptor(api);
            var att:XmlAttribute = new XmlAttribute(new MetaParser(factory).parseField(descriptor)[0]);
            doMemberAssertion(api, att);
        }

        [Test]
        public function testFxElement():void
        {
            var api:XmlApiElement = XmlApiElement.create("testAtt", String, null, 'aliasAttTest');
            var descriptor:RMember = FxBEngine.instance.api.buildFieldDescriptor(api);
            var att:XmlElement = new XmlElement(new MetaParser(factory).parseField(descriptor)[0]);
            doElementAssertion(api, att);
        }

        [Test]
        public function testFxArray():void
        {
            var api:XmlApiArray = XmlApiArray.create("testAtt", String, null, 'aliasAttTest');
            var descriptor:RMember = FxBEngine.instance.api.buildFieldDescriptor(api);
            var att:XmlArray = new XmlArray(new MetaParser(factory).parseField(descriptor)[0]);
            doArrayAssertion(api, att);
        }

        [Test]
        public function testFxClass():void
        {
            var parser:MetaParser = new MetaParser(factory);
            var cls:XmlApiClass = buildDescriptor();
            var descriptor:RObject = FxBEngine.instance.api.buildTypeDescriptor(cls);
            var xmlCls:XmlClass = parser.parseDescriptor(descriptor)[0];
            Assert.assertEquals("wrong type", cls.type, xmlCls.type);
            Assert.assertEquals("wrong alias", cls.alias, xmlCls.alias);
            Assert.assertEquals("wrong prefix", cls.prefix, xmlCls.nameSpace.prefix);
            Assert.assertEquals("wrong uri", cls.uri, xmlCls.nameSpace.uri);
            Assert.assertEquals("wrong member count", 4, xmlCls.members.length);
            Assert.assertEquals("wrong constructor argument count", 2, xmlCls.constructor.parameterFields.length);
        }

        private function buildDescriptor():XmlApiClass
        {
            var cls:XmlApiClass = new XmlApiClass(Person, "APerson");
            cls.prefix = "test";
            cls.uri = "http://www.axway.com/xmlns/passport/v1";
            cls.addAttribute("firstName", String, null, "FirstName");
            cls.addAttribute("lastName", String, null, "LastName");
            cls.addElement("birthDate", Date, null, "BirthDate");
            cls.addElement("age", Number, null, "Age").ignoreOn = Stage.SERIALIZE;
            cls.addArgument("firstName");
            cls.addArgument("lastName");
            return cls;
        }

        [Test]
        public function testSerializationWithApiDescriptor():void
        {
            var cls:XmlApiClass = buildDescriptor();
            FxBEngine.instance.api.processTypeDescriptor(cls);
            var person:Person = new Person();
            person.firstName = "John";
            person.lastName = "Doe";
            person.birthDate = new Date();
            person.age = 34;
            var xml:XML = FxBEngine.instance.getXmlSerializer().serialize(person) as XML;
            var copy:Person = FxBEngine.instance.getXmlSerializer().deserialize(xml, Person);
            Assert.assertEquals("Wrong firstName", person.firstName, copy.firstName);
            Assert.assertEquals("Wrong lastName", person.lastName, copy.lastName);
            Assert.assertEquals("Wrong birthDate", person.birthDate.toString(), copy.birthDate.toString());
            Assert.assertEquals("Wrong age", 0, copy.age);
        }

        [Test]
        public function testFileDescriptorProcessing():void
        {
            var xml:XML = getXmlDescriptor();
            FxBEngine.instance.api;
            var wrapper:FxApiWrapper = FxBEngine.instance.getXmlSerializer().deserialize(xml, FxApiWrapper);
            Assert.assertEquals("Wrong number of classes parsed", 3, wrapper.descriptors.length);
            Assert.assertEquals("Wrong version", 1, wrapper.version);
            Assert.assertEquals("Wrong member count for first class", 4, XmlApiClass(wrapper.descriptors[0]).members.length);
            Assert.assertEquals("Wrong constructor argument count for second class", 2, XmlApiClass(wrapper.descriptors[1]).constructorArguments.length);
        }

        private function doArrayAssertion(apiMember:XmlApiArray, xmlArray:XmlArray):void
        {
            doElementAssertion(apiMember, xmlArray);
            Assert.assertEquals("Wrong memberName", apiMember.memberName, xmlArray.memberName);
            Assert.assertEquals("Wrong memberType", apiMember.memberType, xmlArray.memberType);
        }

        private function doElementAssertion(apiMember:XmlApiElement, xmlElement:XmlElement):void
        {
            doMemberAssertion(apiMember, xmlElement);
            Assert.assertEquals("Wrong getFromCache", apiMember.getFromCache, xmlElement.getFromCache);
            Assert.assertEquals("Wrong serializePartialElement", apiMember.serializePartialElement, xmlElement.serializePartialElement);
            Assert.assertEquals("Wrong nillable", apiMember.nillable, xmlElement.nillable);
        }

        private function doMemberAssertion(apiMember:XmlApiMember, xmlMember:XmlMember):void
        {
            Assert.assertEquals("Wrong field name", apiMember.fieldName, xmlMember.name);
            Assert.assertEquals("Wrong field type", apiMember.fieldType, xmlMember.type);
            Assert.assertEquals("Field access type is wrong for writeOnly", apiMember.fieldAccessType == AccessorType.WRITE_ONLY, xmlMember.writeOnly);
            Assert.assertEquals("Field access type is wrong for readOnly", apiMember.fieldAccessType == AccessorType.READ_ONLY, xmlMember.readOnly);
            Assert.assertEquals("Wrong ignoreOn", apiMember.ignoreOn, xmlMember.ignoreOn);
            Assert.assertEquals("Wrong alias", apiMember.alias, xmlMember.alias);
            Assert.assertEquals("Wrong required", apiMember.isRequired, xmlMember.isRequired);
        }

        [Test]
        public function testMultipleNamespace():void
        {
            FxBEngine.instance.api;
            var cls:XmlApiClass = new XmlApiClass(Mock);
            var member:XmlApiMember = cls.addAttribute("version", Number, null, "Version");
            member.setNamespace(new Namespace("me", "www.me.com"));
            member = cls.addElement("tester", String);
            member.setNamespace(new Namespace("us", "www.us.com"));
            member = cls.addAttribute("uue", String);
            member = cls.addAttribute("uueedr", String);
            member.setNamespace(new Namespace("me", "www.me.com"));
            Assert.assertEquals("Wrong number of registered namespaces upon programatic build", 2, count(cls.flexxb_api_internal::namespaces));
            var xml:XML = getXmlDescriptor();
            var wrapper:FxApiWrapper = FxBEngine.instance.getXmlSerializer().deserialize(xml, FxApiWrapper);
            Assert.assertEquals("Wrong number of registered namespaces upon deserialization", 2, count(XmlApiClass(wrapper.descriptors[0]).flexxb_api_internal::namespaces));
        }

        [Test]
        public function testFullAPIProcessing():void
        {
            FxBEngine.instance.getXmlSerializer().context.registerSimpleTypeConverter(new W3CDateConverter());
            var cls:XmlApiClass = new XmlApiClass(APITestObject, "ATO");
            cls.prefix = "apitest";
            cls.uri = "http://www.apitest.com/api/test";
            cls.addAttribute("id", Number);
            cls.addArgument("id", false);
            var member:XmlApiMember = cls.addAttribute("name", String, AccessorType.READ_WRITE, "meta/objName");
            member.setNamespace(new Namespace("pref1", "http://www.p.r.com"));
            cls.addElement("version", Number, null, "meta/objVersion");
            member = cls.addElement("currentDate", Date, null, "todayIs");
            member.setNamespace(new Namespace("pref1", "http://www.p.r.com"));
            member = cls.addElement("xmlData", XML, null, "data");
            member.setNamespace(new Namespace("pref2", "http://www.p3.r2.com"));
            cls.addAttribute("xmlAtts", XML, null, "attributes");
            var array:XmlApiArray = cls.addArray("results", ArrayCollection, null, "Results");
            array.memberName = "resultItem";
            array.memberType = String;
            FxBEngine.instance.api.processTypeDescriptor(cls);
            var target:APITestObject = new APITestObject(1234);
            target.currentDate = new Date();
            target.name = "MyName";
            target.results = new ArrayCollection(["me", "you", "us"]);
            target.version = 3;
            target.xmlAtts = <atts>
                <att index="0"/>
                <att index="1"/>
                <att index="2"/>
            </atts>;
            target.xmlData = <data id="34">
                <result value="one"/>
            </data>;
            var xml:XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
            var copy:APITestObject = FxBEngine.instance.getXmlSerializer().deserialize(xml, APITestObject);

            Assert.assertEquals("Id is wrong", target.id, copy.id);
            Assert.assertEquals("Name is wrong", target.name, copy.name);
            Assert.assertEquals("Version is wrong", target.version, copy.version);
            Assert.assertEquals("XmlAtts is wrong", target.xmlAtts.toXMLString(), copy.xmlAtts.toXMLString());
            Assert.assertEquals("XmlData is wrong", target.xmlData.toXMLString(), copy.xmlData.toXMLString());
            Assert.assertEquals("Results count is wrong", target.results.length, copy.results.length);
            for (var i:int = 0; i < target.results.length; i++)
            {
                Assert.assertEquals("Results memeber indexed " + i + " is wrong", target.results[i], copy.results[i]);
            }
            Assert.assertEquals("Current date is wrong", target.currentDate.time, copy.currentDate.time);
        }

        private function count(map:Dictionary):int
        {
            var size:int = 0;
            for (var key:* in map)
            {
                size++;
            }
            return size;
        }

        private function getXmlDescriptor():XML
        {
            var xml:XML = <FlexXBAPI version="1">
                <Descriptors>
                    <XmlClass type="com.googlecode.testData.PhoneNumber" alias="TelephoneNumber" prefix="number" uri="http://www.aciobanu.com/schema/v1/phone" ordered="true">
                        <Members>
                            <XmlAttribute order="1">
                                <Field name="countryCode" type="String"/>
                                <Namespace prefix="test" uri="http://www.test.org" />
                            </XmlAttribute>
                            <XmlAttribute order="2">
                                <Field name="areaCode" type="String" access="readwrite"/>
                            </XmlAttribute>
                            <XmlAttribute alias="phoneNumber" order="3">
                                <Field name="number" type="String"/>
                                <Namespace prefix="test" uri="http://www.test.org" />
                            </XmlAttribute>
                            <XmlAttribute order="4">
                                <Field name="interior" type="String"/>
                                <Namespace prefix="ns2" uri="http://www.test.org/ns/2" />
                            </XmlAttribute>
                        </Members>
                    </XmlClass>
                    <XmlClass type="com.googlecode.testData.Person" alias="Person" prefix="person" uri="http://www.aciobanu.com/schema/v1/person">
                        <ConstructorArguments>
                            <Argument reference="firstName" optional="true"/>
                            <Argument reference="lastName" />
                        </ConstructorArguments>
                        <Members>
                            <XmlElement alias="BirthDate">
                                <Field name="birthDate" type="Date"/>
                            </XmlElement>
                            <XmlElement alias="Age" ignoreOn="serialize">
                                <Field name="birthDate" type="Date"/>
                            </XmlElement>
                            <XmlAttribute>
                                <Field name="firstName" type="String"/>
                            </XmlAttribute>
                            <XmlAttribute>
                                <Field name="lastName" type="String"/>
                            </XmlAttribute>
                        </Members>
                    </XmlClass>
                    <XmlClass type="com.googlecode.testData.Address" alias="PersonAddress" prefix="add" uri="http://www.aciobanu.com/schema/v1/address" ordered="false">
                        <Members>
                            <XmlElement getFromCache="true">
                                <Field name="person" type="com.googlecode.testData.Person"/>
                            </XmlElement>
                            <XmlElement>
                                <Field name="emailAddress" type="String"/>
                            </XmlElement>
                            <XmlAttribute>
                                <Field name="street" type="String" accessType="readwrite"/>
                            </XmlAttribute>
                            <XmlAttribute>
                                <Field name="number" type="String"/>
                            </XmlAttribute>
                            <XmlAttribute>
                                <Field name="city" type="String"/>
                            </XmlAttribute>
                            <XmlAttribute>
                                <Field name="country" type="String"/>
                            </XmlAttribute>
                            <XmlArray alias="numbers" memberName="" memberType="com.googlecode.testData.PhoneNumber" getFromCache="false" serializePartialElement="false" order="3">
                                <Field name="telephoneNumbers" type="Array" accessType="readwrite"/>
                            </XmlArray>
                        </Members>
                    </XmlClass>
                </Descriptors>
            </FlexXBAPI>;
            return xml;
        }
    }
}