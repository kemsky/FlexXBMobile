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
    import com.googlecode.flexxb.api.IFlexXBApi;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * Entry point for AS3-? (de)serialization. Allows new annotation registration.
     * The main access point consist of two methods: <code>serialize()</code> and <code>deserialize</code>, each corresponding to the specific stage in the conversion process.
     * By default it registeres the built-in xml handling annotations through the xml description context.
     *
     * @author aCiobanu
     *
     */
    public final class FxBEngine
    {
        private static var _instance:FxBEngine;

        private static const LOG:ILogger = Log.getLogger("com.googlecode.flexxb.core.FxBEngine");

        private var _api:IFlexXBApi;

        private var contextMap:Object;

        /**
         * Not a singleton, but an easy access instance.
         * @return instance of FlexXBEngine
         *
         */
        public static function get instance():FxBEngine
        {
            if (!_instance)
            {
                _instance = new FxBEngine();
            }
            return _instance;
        }

        /**
         * Constructor
         *
         */
        public function FxBEngine()
        {
            contextMap = {};
            registerDescriptionContext("XML", new XmlDescriptionContext());
        }

        /**
         * Get a reference to the api object
         * @return instance of type <code>com.googlecode.flexxb.api.IFlexXBApi</code>
         *
         */
        public function get api():IFlexXBApi
        {
            if (!_api)
            {
                _api = new FlexXBApi(getXmlSerializer() as FlexXBCore);
            }
            return _api;
        }

        /**
         *
         * @param name
         * @param context
         *
         */
        public function registerDescriptionContext(name:String, context:XmlDescriptionContext):void
        {
            if (!name || !context)
            {
                throw new Error();
            }
            if (contextMap[name])
            {
                throw new Error();
            }
            contextMap[name] = {context: context, core: null};
        }

        /**
         *
         * @param name
         * @return
         *
         */
        public function getSerializer(name:String):IFlexXB
        {
            var item:Object = contextMap[name];
            if (item)
            {
                if (!item.core)
                {
                    item.core = new FlexXBCore(item.context);
                }
                return item.core as IFlexXB;
            }
            return null;
        }

        /**
         *
         * @return
         *
         */
        public function getXmlSerializer():IFlexXB
        {
            return getSerializer("XML");
        }
    }
}