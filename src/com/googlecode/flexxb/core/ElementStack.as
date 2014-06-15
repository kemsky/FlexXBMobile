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
    internal final class ElementStack
    {
        private var stack:Array = [];

        private var index:int = -1;

        public function ElementStack()
        {
        }

        public function beginDocument():void
        {

        }

        /**
         * Returns a reference to the current object being processed
         * @return
         *
         */
        public function getCurrent():Object
        {
            if (stack.length > 0)
            {
                return stack[stack.length - 1];
            }
            return null;
        }

        /**
         * Returns a reference to the current object's parent.
         * @return
         *
         */
        public function getParent():Object
        {
            if (index > 0)
            {
                return stack[index - 1];
            }
            return null;
        }


        public function push(item:Object):Boolean
        {
            if (stack.indexOf(item) == -1)
            {
                stack[++index] = item;
                return true;
            }
            return false;
        }

        public function pushNoCheck(item:Object):void
        {
            stack[++index] = item;
        }

        public function pop():Object
        {
            index--;
            return stack.pop();
        }

        public function endDocument():void
        {
            stack.length = 0;
            index = -1;
        }
    }
}