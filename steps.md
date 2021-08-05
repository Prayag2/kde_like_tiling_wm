# Steps:
+ Install
  - Virtual Desktop Bar
  - afetch
  - Krohnkite
  - gtk3-nocsd
  - breeze-gtk
  - konsave
  - Breeze Chameleon Icon Pack
  - Widgets:
    - Better Inline Clock
    - Global Menu
    - Latte Separator
+ Konsave Import
+ Change
  - Colour Scheme
  - Window Decorations
  - Konsole colour scheme
  - Keyboard shortcuts
  - GTK Theme
  - Window Behaviour > Advanced > Window Placement: Center
  - Enable Kwin Scripts
    - Krohnkit  
      - Change layout
      - Change gaps
      - Change directional keys behaviour
      - Add `plasma.emojier` to float window if you use the emoji selector
      - Prevent windows from minimizing
  - Virtual Desktop Bar
    - Enable Dynamic Virtual Desktops (Optional)
    - Change appearance
      - Custom Font (Monospace)
      - Style: Edge Line (or anything)
      - Custom colour for idle and ocupied idle desktops (No colour)
+ Fixes
  - All apps won't have the window decoration enabled so do this:
    - Settings > Window Management > Window Rules > Add New
    - Window class: Unimportant
    - Window Type: Normal Window
    - Add Property > Minimum Size > Set it to "Force" and then 0x0
    - Add Property > No titlebar and frame > Set it to "Force" and "No"
+ Optional Stuff
  - Enable Desktop Effects:
    - Translucency
    - Blur
  - Disable Animations
  - Force Blur
  - Enable blur in Dolphin:
    - Install force-blur kwin script. Enable Dolphin in the script settings.
    - Add window rule in Dolphin and set opacity to 90%
  
Finally, reboot to see the changes. 
