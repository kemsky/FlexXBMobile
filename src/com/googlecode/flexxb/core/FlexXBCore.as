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
    import com.googlecode.flexxb.annotation.contract.AnnotationFactory;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * @private
     * @author Alexutz
     *
     */
    internal final class FlexXBCore implements IFlexXB
    {
        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.core.FlexXBCore");

        private var core:SerializationCore;

        private var _context:XmlDescriptionContext;

        private var _configuration:Configuration;
        private var _descriptorStore:DescriptorStore;
        private var _factory:AnnotationFactory;

        public function FlexXBCore(context:XmlDescriptionContext)
        {
            this._context = context;
            _factory = new AnnotationFactory();
            _descriptorStore = new DescriptorStore(_factory);
            _configuration = context.configuration;
            core = new SerializationCore(context, _descriptorStore);
            _context.initializeContext(_descriptorStore, core);
        }

        public function get context():XmlDescriptionContext
        {
            return _context;
        }

        public function get configuration():Configuration
        {
            return _configuration;
        }

        public function processTypes(...args):void
        {
            if (args && args.length > 0)
            {
                for each (var item:Object in args)
                {
                    if (item is Class)
                    {
                        _descriptorStore.getDescriptor(item);
                    }
                    else
                    {
                        LOG.error("Excluded from processing because it is not a class: {0}", item);
                    }
                }
            }
        }

        public function addEventListener(type:String, listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
        {
            core.addEventListener(type, listener, false, priority, useWeakReference);
        }

        public function removeEventListener(type:String, listener:Function):void
        {
            core.removeEventListener(type, listener, false);
        }

        public function serialize(object:*, partial:Boolean = false, version:String = ""):XML
        {
            core.beginSerialize();
            var data:XML = core.serialize(object, partial, version);
            core.endSerialize();
            return data;
        }

        public function deserialize(source:XML, objectClass:Class = null, getFromCache:Boolean = false, version:String = ""):*
        {
            core.beginDeserialise();
            //determine the source document version
            if (!version && configuration.autoDetectVersion)
            {
                version = configuration.versionExtractor.getVersion(source);
            }
            var object:Object = core.deserialize(source, objectClass, getFromCache, version);
            core.endDeserialise();
            return object;
        }


        public function get factory():AnnotationFactory
        {
            return _factory;
        }

        public function get store():DescriptorStore
        {
            return _descriptorStore;
        }
    }
}