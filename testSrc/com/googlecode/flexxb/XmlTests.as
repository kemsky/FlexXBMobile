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
package com.googlecode.flexxb
{
    import com.googlecode.flexxb.annotation.DefaultValueTest;
    import com.googlecode.flexxb.annotation.VersioningTest;
    import com.googlecode.flexxb.annotation.XmlArrayTest;
    import com.googlecode.flexxb.annotation.XmlAttributeTest;
    import com.googlecode.flexxb.annotation.XmlClassTest;
    import com.googlecode.flexxb.annotation.XmlElementTest;
    import com.googlecode.flexxb.converter.ConverterTest;

    [Suite(description="Run the xml tests")]
    [RunWith("org.flexunit.runners.Suite")]
    public class XmlTests
    {

        public var xmlClass:XmlClassTest;

        public var xmlAttribute:XmlAttributeTest;

        public var xmlElement:XmlElementTest;

        public var xmlArray:XmlArrayTest;

        public var xmlSerializer:XmlSerializerTest;

        public var elementOrder:XmlElementOrderTest;

        public var specialChars:XmlSpecialCharEscapeTest;

        public var defaultValue:DefaultValueTest;

        public var versioning:VersioningTest;

        public var namespaceTest:NamespaceTest;

        public var collisionDetectionTest:CircularReferenceTest;

        public var converter:ConverterTest;
    }
}