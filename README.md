# nPose-Docardif-plugin
Allows us to make a decision inside a notecard based upon conditions of UDPBOOL and MACROs.
Added a built in set of UDPBOOL entries which track which seats are occupied (filled) and which are not.

Usage requires the implementation of `PLUGINCOMMAND|DOCARDIF|-3500` within the .init card.

The syntax is as follows:
  * `DOCARDIF|expression to evaluate|card name to run if true[|card name to run if false]`

The DOCARDIF comes in very handy when the need to evaluate the state of multiple UDPBOOLs in order to make a decision.
One example might be when a build is set up to allow multiple couples.  In this situation we currently cannot change a pose set if both members of a couple stand, we could only wait until all sitters stand to revert back to a known state (default card).
With the use of DOCARDIF, we can now test to see if both of the couple seats are empty and then change to a sub set of the default card using SCHMOE.  When new sitters come along and use these seats associated with this couple, they are not forced into the last pose set but rather a neutral pose set instead.

In this example when one of the sitters in a seat used for couples stands, we can test if the other seat is also empty.

  `ON_UNSIT|3|DOCARDIF|!seatfilled3 & !seatfilled4|SET:Cpl2:BasePoseSet`     
  `ON_UNSIT|4|DOCARDIF|!seatfilled3 & !seatfilled4|SET:Cpl2:BasePoseSet`


When sitter in seat 3 stands, we are able to test if seat 4 is filled as well.  If both are not filled, nPose will run 'SET:Cpl2:BasePoseSet' card.
When sitter in seat 4 stands, we are able to test if seat 3 is filled as well.  If both are not filled, nPose will run 'SET:Cpl2:BasePoseSet' card.

The above example is using the UDPBOOLS the script is making for you.  It is also possible to use your custom made UDPBOOLs or MACROs to make other decisions.

These built in UDPBOOLs are also broadcast out to all other nPose scripts so that they are able to use them also.  Meaning you can use these built in UDPBOOLs in Button Permissions.
