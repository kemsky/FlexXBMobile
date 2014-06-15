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
    import avmplus.RMember;
    import avmplus.RMeta;
    import avmplus.RValue;
    import avmplus.RObject;
    import com.googlecode.flexxb.api.AccessorTypeConverter;
    import com.googlecode.flexxb.api.FxApiWrapper;
    import com.googlecode.flexxb.api.FxClass;
    import com.googlecode.flexxb.api.FxConstructorArgument;
    import com.googlecode.flexxb.api.FxMember;
    import com.googlecode.flexxb.api.IFlexXBApi;
    import com.googlecode.flexxb.api.IFxMetaProvider;
    import com.googlecode.flexxb.api.StageXmlConverter;
    import avmplus.Types;

    import flash.utils.Dictionary;

    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     *
     * @author Alexutz
     * @private
     */
    internal final class FlexXBApi implements IFlexXBApi
    {
        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.core.FlexXBApi");

        private var core:FlexXBCore;
        private var store:DescriptorStore;

        /**
         * Constructor
         * @param core the xml serialization core
         * @param store
         *
         */
        public function FlexXBApi(core:FlexXBCore)
        {
            this.core = core;
            this.store = core.store;
            core.context.registerSimpleTypeConverter(new StageXmlConverter());
            core.context.registerSimpleTypeConverter(new AccessorTypeConverter());
            core.processTypes(FxConstructorArgument);
        }

        public function processTypeDescriptor(apiDescriptor:FxClass):void
        {
            if (apiDescriptor)
            {
                var type:Class = apiDescriptor.type;
                store.registerDescriptor(buildTypeDescriptor(apiDescriptor), type);
            }
        }

        public function processDescriptorsFromXml(xml:XML):void
        {
            if (xml)
            {
                var apiWrapper:FxApiWrapper = core.deserialize(xml, FxApiWrapper);
                if (apiWrapper)
                {
                    for each (var classDescriptor:FxClass in apiWrapper.descriptors)
                    {
                        if (classDescriptor)
                        {
                            if (Log.isDebug())
                            {
                                LOG.debug("Processing class {0}", classDescriptor.type);
                            }
                            processTypeDescriptor(classDescriptor);
                        }
                    }
                }
            }
        }

        public function buildTypeDescriptor(apiClass:FxClass):RObject
        {
            var xml:RObject = new RObject();
            xml.name = Types.getQualifiedClassName(apiClass.type);
            if (apiClass.constructorArguments)
            {
                for (var i:int = apiClass.constructorArguments.length - 1; i >= 0; i--)
                {
                    var fxConstructorArgument:FxConstructorArgument = apiClass.constructorArguments[i] as FxConstructorArgument;
                    xml.traits.metadata.push(buildMetadataDescriptor(fxConstructorArgument));
                }
            }
            var globals:Array = apiClass.getGlobalAnnotations();
            for each(var global:IFxMetaProvider in globals)
            {
                xml.traits.metadata.push(buildMetadataDescriptor(global));
            }
            xml.traits.metadata.push(buildMetadataDescriptor(apiClass));
            for each (var member:FxMember in apiClass.members)
            {
                var m:RMember = buildFieldDescriptor(member);
                xml.traits.variables.push(m);
            }
            return xml;
        }

        public function buildFieldDescriptor(member:FxMember):RMember
        {
            var xml:RMember = new RMember(member.field.name, Types.getQualifiedClassName(member.field.type), member.field.accessType.toString(), null, null);
            xml.metadata.push(buildMetadataDescriptor(member));
            return xml;
        }

        private function buildMetadataDescriptor(meta:IFxMetaProvider):RMeta
        {
            var xml:RMeta = new RMeta(meta.getMetadataName());
            var values:Dictionary = meta.getMappingValues();
            for (var key:* in values)
            {
                if (values[key] != null)
                {
                    xml.value.push(new RValue(key, values[key]));
                }
            }
            return xml;
        }
    }
}