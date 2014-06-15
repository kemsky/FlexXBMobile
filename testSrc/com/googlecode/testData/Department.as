package com.googlecode.testData
{
    import com.googlecode.flexxb.interfaces.ICycleRecoverable;

    import flash.events.Event;
    import flash.events.EventDispatcher;

    [XmlClass(idField="id")]
    public final class Department extends EventDispatcher implements ICycleRecoverable
    {
        public static const CYCLE_DETECTED:String = "CycleDetectedEvent";

        [XmlAttribute]
        public var id:Number;

        [XmlAttribute]
        public var name:String;

        [XmlArray]
        public var employees:Array;

        public function Department()
        {
        }

        public function onCycleDetected(parentCaller:Object):Object
        {
            var copy:Department = new Department();
            copy.id = id;
            dispatchEvent(new Event(CYCLE_DETECTED));
            return copy;
        }
    }
}