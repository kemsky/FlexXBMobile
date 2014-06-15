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
package com.googlecode.flexxb.converter
{
    /**
     * Date converter conforming to the W3C standard
     * @author Alexutz
     *
     */
    public final class W3CDateConverter implements IConverter
    {
        /**
         *
         * @see IConverter#type()
         *
         */
        public function get type():Class
        {
            return Date;
        }

        /**
         * Returns a date string formatted according to W3CDTF.
         * @param d
         * @param includeMilliseconds Determines whether to include the
         * milliseconds value (if any) in the formatted string.
         *
         * @returns date string
         */
        public function toString(obj:Object):String
        {
            var d:Date = obj as Date;
            var date:Number = d.getUTCDate();
            var month:Number = d.getUTCMonth();
            var hours:Number = d.getUTCHours();
            var minutes:Number = d.getUTCMinutes();
            var seconds:Number = d.getUTCSeconds();
            var milliseconds:Number = d.getUTCMilliseconds();
            var timeOffset:Number = d.getTimezoneOffset();
            var sb:String = new String();

            sb += d.getUTCFullYear() + "-";

            sb += addLeadingZero(month + 1) + "-";

            sb += addLeadingZero(date);

            sb += "T";

            sb += addLeadingZero(hours) + ":";

            sb += addLeadingZero(minutes) + ":";

            sb += addLeadingZero(seconds);

            if (milliseconds >= 0)
            {
                sb += ".";
                sb += addLeadingZero(milliseconds, 3);
            }

            if (timeOffset < 0)
            {
                sb += "+";
                timeOffset = -timeOffset;
            }
            else
            {
                sb += "-";
            }
            var offsetHour:int = timeOffset / 60;

            sb += addLeadingZero(offsetHour) + ":";

            var offsetMinute:int = timeOffset % 60;

            sb += addLeadingZero(offsetMinute);

            return sb;
        }

        private static function addLeadingZero(value:int, count:int = 2):String
        {
            var val:String = value + "";
            while (val.length < count)
            {
                val = "0" + val;
            }
            return val;
        }

        /**
         * Parses dates that conform to the W3C Date-time Format into Date objects.
         * @param str
         * @returns date object
         *
         */
        public function fromString(str:String):Object
        {
            var finalDate:Date;
            if (str)
            {
                try
                {
                    var dateStr:String = str.substring(0, str.indexOf("T"));
                    var timeStr:String = str.substring(str.indexOf("T") + 1, str.length);
                    var dateArr:Array = dateStr.split("-");
                    var year:Number = Number(dateArr.shift());
                    var month:Number = Number(dateArr.shift());
                    var date:Number = Number(dateArr.shift());

                    var multiplier:Number;
                    var offsetHours:Number;
                    var offsetMinutes:Number;
                    var offsetStr:String;

                    if (timeStr.indexOf("Z") != -1)
                    {
                        multiplier = 1;
                        offsetHours = 0;
                        offsetMinutes = 0;
                        timeStr = timeStr.replace("Z", "");
                    }
                    else if (timeStr.indexOf("+") != -1)
                    {
                        multiplier = 1;
                        offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
                        offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
                        offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
                        timeStr = timeStr.substring(0, timeStr.indexOf("+"));
                    }
                    else if(timeStr.indexOf("-") != -1) // offset is -
                    {
                        multiplier = -1;
                        offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
                        offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
                        offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
                        timeStr = timeStr.substring(0, timeStr.indexOf("-"));
                    }
                    else //date str without offset
                    {
                        multiplier = 1;
                        offsetHours = 0;
                        offsetMinutes = 0;
                    }

                    var timeArr:Array = timeStr.split(":");
                    var hour:Number = Number(timeArr.shift());
                    var minutes:Number = Number(timeArr.shift());
                    var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
                    var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
                    var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
                    var utc:Number = Date.UTC(year, month - 1, date, hour, minutes, seconds, milliseconds);
                    var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
                    finalDate = new Date(utc);
                    //utc-offset?
                    if (finalDate.toString() == "Invalid Date")
                    {
                        throw new Error("This date does not conform to W3CDTF.");
                    }
                } catch (e:Error)
                {
                    var eStr:String = "Unable to parse the string [" + str + "] into a date. ";
                    eStr += "The internal error was: " + e.toString();
                    throw new Error(eStr);
                }
            }
            return finalDate;
        }

    }
}