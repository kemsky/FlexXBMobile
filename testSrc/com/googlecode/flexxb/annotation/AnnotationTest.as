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
    import avmplus.RMember;
    import avmplus.R;
    import avmplus.RObject;

    import com.googlecode.flexxb.annotation.contract.Annotation;
    import com.googlecode.testData.Mock;

    import flash.utils.describeType;

    import org.flexunit.Assert;

    /**
     *
     * @author Alexutz
     *
     */
    public class AnnotationTest
    {

        protected function getTestObject():Object
        {
            return new Mock();
        }

        /**
         * Method that handles annotation validation. It tests the annotation against a
         * value list received as a list of parameters. The list is as follows:
         *  <ul>
         *         <li>- Field Name</li>
         *      <li>- Field Type</li>
         *      <li>- Name (as given in the objects' annotation)</li>
         *      <li>- Custom parameters handles in overrides of the customValidate method</li>
         * </ul>
         * @param annotation annotation to be validated
         * @param args values List
         *
         */
        protected final function validate(annotation:Annotation, ...args):void
        {
            Assert.assertNotNull("Null annotation", annotation);
            Assert.assertNotNull("Validation arguments are missing", args);
            Assert.assertNotNull("Null name", annotation.name);
            Assert.assertEquals("Field Name is incorrect", args[0], annotation.name.localName);
            Assert.assertEquals("Field Type is incorrect", args[1], annotation.type);
            Assert.assertEquals("Alias is incorrect", args[2], annotation.alias);
            customValidate.apply(this, [annotation].concat(args));
        }

        /**
         *
         * @param annotation
         * @param args
         *
         */
        protected function customValidate(annotation:Annotation, ...args):void
        {
        }

        /**
         *
         * @param descriptor
         *
         */
        protected function runTest(descriptor:RObject):void
        {
        }

        /**
         *
         * @param fieldName
         * @param descriptor
         * @return
         *
         */
        protected final function getFieldDescriptor(fieldName:String, descriptor:RObject):RMember
        {
            var m:RMember;
            for each (m in descriptor.traits.variables)
            {
                if(m.name == fieldName)
                {
                    return m;
                }
            }

            for each (m in descriptor.traits.accessors)
            {
                if(m.name == fieldName)
                {
                    return m;
                }
            }

            return null;
        }

        [Test]
        public function testAnnotation():void
        {
            var descriptor:RObject = R.describeFromXML(describeType(getTestObject()), R.VARIABLES | R.TRAITS | R.METADATA | R.METHODS | R.ACCESSORS | R.BASES | R.CONSTRUCTOR);
            runTest(descriptor);
        }
    }
}