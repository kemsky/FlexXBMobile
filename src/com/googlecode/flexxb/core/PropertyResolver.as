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
package com.googlecode.flexxb.core
{
    import flash.utils.Dictionary;

    import mx.collections.IList;
    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * @private
     * @author Alexutzutz
     *
     */
    internal final class PropertyResolver
    {
        private static const log:ILogger = Log.getLogger("com.googlecode.flexxb.core.Resolver");

        private var idMap:Dictionary = new Dictionary();

        [ArrayElementType("ResolverTask")]
        private var taskList:Array = [];

        public function PropertyResolver()
        {
        }

        public function bind(id:String, item:Object):void
        {
            idMap[id] = item;
        }

        public function beginDocument():void
        {
        }

        public function addResolutionTask(item:Object, field:QName, id:String):void
        {
            taskList.push(new ResolverTask(item, field, id));
        }

        public function endDocument():void
        {
            var resolved:Object;
            for each(var task:ResolverTask in taskList)
            {
                resolved = idMap[task.id];
                if (task.object is Array)
                {
                    (task.object as Array).push(resolved);
                }
                else if (task.object is IList)
                {
                    (task.object as IList).addItem(resolved);
                }
                else if (task.object != null && task.object.hasOwnProperty(task.field.toString()))
                {
                    task.object[task.field] = resolved;
                }
                else
                {
                    log.warn("incorrect type: {0} or property: {1}", task.object, task.field)
                }
            }

            clear();
        }


        private function clear():void
        {
            for (var key:* in idMap)
            {
                delete idMap[key];
            }

            var task:ResolverTask;
            var length:uint = taskList.length;
            for (var i:uint = 0; i < length; i++)
            {
                task = taskList[i];
                task.clear();
            }
            task = null;
            taskList.length = 0;
        }
    }
}

class ResolverTask
{
    public var object:Object;
    public var field:QName;
    public var id:String;

    public function ResolverTask(object:Object, field:QName, id:String)
    {
        this.object = object;
        this.field = field;
        this.id = id;
    }

    public function clear():void
    {
        object = null;
        field = null;
        id = null;
    }
}