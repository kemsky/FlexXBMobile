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
package com.googlecode.flexxb.cache
{
    import com.googlecode.flexxb.core.FxBEngine;
    import com.googlecode.flexxb.core.IFlexXB;
    import com.googlecode.testData.Mock;
    import com.googlecode.testData.Mock3;
    import com.googlecode.testData.Mock4;

    import flash.events.Event;

    import flexunit.framework.Assert;

    import org.flexunit.assertThat;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;

    public class CacheTest
    {

        private static var objectCache:ObjectCache;
        private static var objectPool:ObjectPool;
        private static var engine:IFlexXB;

        [BeforeClass]
        public static function initialize():void
        {
            objectCache = new ObjectCache();
            objectPool = new ObjectPool();
            engine = new FxBEngine().getXmlSerializer();
        }

        [Test(order="1")]
        public function objectCache_testEmptyCache():void
        {
            objectCache.putObject("id", new Mock());
            Assert.assertTrue("Cache does not contain the object", objectCache.isInCache("id", Mock));
            objectCache.clearCache(Mock);
            Assert.assertNull(objectCache.getFromCache("id", Mock));
        }

        [Test(order="2")]
        public function objectCache_testCache():void
        {
            var obj:Mock3 = new Mock3();
            obj.id = 352;
            obj.attribute = true;
            engine.configuration.setCacheProvider(objectCache);
            var xml:XML = engine.serialize(obj) as XML;
            var copy:Mock3 = engine.deserialize(xml, Mock3);
            Assert.assertEquals(copy.id, obj.id);
            Assert.assertTrue("Deserialized object not cached", objectCache.isInCache(String(copy.id), Mock3));
            Assert.assertEquals("Different instances", copy, objectCache.getFromCache(String(copy.id), Mock3));
        }

        [Test(description="This test covers the object pool functionality. It will test that objects that get released use are then reused when need arises and when all available objects are used, it will create new instances to accomodate needs.")]
        public function testObjectPool():void
        {
            var obj1:Object = objectPool.getNewInstance(Object, null);
            var obj2:Object = objectPool.getNewInstance(Object, null);
            var obj3:Object = objectPool.getNewInstance(Object, null);
            var temp:Object;
            assertThat("Object instances are equal", obj1, not(equalTo(obj2)));
            assertThat("Object instances are equal", obj2, not(equalTo(obj3)));
            assertThat("Object instances are equal", obj3, not(equalTo(obj1)));
            objectPool.releaseInstance(obj2);
            temp = objectPool.getFromCache(null, Object);
            assertThat("Object is not propely released", temp, equalTo(obj2));
            objectPool.clearCache();
            temp = objectPool.getNewInstance(Object, null);
            assertThat("Cleanup not working", temp, not(equalTo(obj1)));
            assertThat("Cleanup not working", temp, not(equalTo(obj2)));
            assertThat("Cleanup not working", temp, not(equalTo(obj3)));
        }

        [Test(description="This test covers the call of the clear method on IPooledObject implementors when they get released")]
        public function objectClearenceOnRelease():void
        {
            clearFlag = false;
            var obj:Mock4 = objectPool.getNewInstance(Mock4, null);
            obj.addEventListener(Mock4.CLEAR, onClearCalled);
            objectPool.releaseInstance(obj);
            obj.removeEventListener(Mock4.CLEAR, onClearCalled);
            assertThat("Clear method not called on object", true, equalTo(clearFlag));
        }

        private var clearFlag:Boolean;

        private function onClearCalled(event:Event):void
        {
            clearFlag = true;
        }

        [AfterClass]
        public static function cleanup():void
        {
            objectCache = null;
            objectPool = null;
        }
    }
}