/**
 *  Copyright (c) 2010 Axway Inc. All Rights Reserved.
 *  Please refer to the file "LICENSE" for further important copyright
 *  and licensing information.  Please also refer to the documentation
 *  for additional copyright notices.
 *
 *  @author aciobanu
 */
package com.googlecode.testData
{
    import com.googlecode.flexxb.cache.IPooledObject;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     *
     */
    [Event(name="clear", type="flash.events.Event")]
    /**
     *
     * @author aciobanu
     *
     */
    public class Mock4 extends EventDispatcher implements IPooledObject
    {
        public static const CLEAR:String = "clear";

        public function Mock4(target:IEventDispatcher = null)
        {
            super(target);
        }

        public function get type():Object
        {
            return Mock4;
        }

        public function clear():void
        {
            dispatchEvent(new Event(CLEAR));
        }
    }
}