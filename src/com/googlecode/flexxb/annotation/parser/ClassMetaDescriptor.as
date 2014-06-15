/**
 *   FlexXB
 *   Copyright (C) 2008-2012 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.googlecode.flexxb.annotation.parser
{
    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import com.googlecode.flexxb.annotation.contract.XmlClass;

    /**
     * @private
     * @author Alexutz
     *
     */
    public final class ClassMetaDescriptor extends MetaDescriptor
    {
        [ArrayElementType("com.googlecode.flexxb.annotation.contract.IGlobalAnnotation")]
        public var config:Array;

        [ArrayElementType("com.googlecode.flexxb.annotation.contract.XmlMember")]
        public var members:Array;

        public function ClassMetaDescriptor(factory:AnnotationFactory)
        {
            super(factory);
            members = [];
            config =[];
        }

        public override function set owner(value:XmlClass):void
        {
            super.owner = value;
            for each(var member:MetaDescriptor in members)
            {
                member.owner = value;
            }
        }

        public function getConfigItemsByName(annotationName:String):Array
        {
            var result:Array = [];
            for each(var descriptor:MetaDescriptor in config)
            {
                if (descriptor.metadataName == annotationName)
                {
                    result.push(descriptor);
                }
            }
            return result;
        }
    }
}