FlexXB Mobile
======

FlexXB fork, optimized for mobile applications

See https://code.google.com/p/flexxb/

Optimized XML serializer/deserializer, few times faster than original version:
* faster [reflection] (https://github.com/kemsky/RObject)
* using variables instead of accessor functions
* faster XML creation via copy()
* other minor optimizations (cache etc.)

You can add metadata validation to Intellij Idea using KnownMetaData.dtd file.
Open `Preferences > Schemas and DTDs > Add` KnownMetaData.dtd with URI `urn:Flex:Meta`.