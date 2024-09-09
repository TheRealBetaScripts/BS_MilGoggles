🚪💥 **Beta Scripts - The Home of Beta Scripts**  
Discover and discuss innovative scripts like *Door Ding* and more. Join our community today:  
👉 [Join Beta Scripts on Discord](https://discord.gg/D36ZXnKr2H)  


# BS_MilGoggles by Beta Scripts

![License](https://img.shields.io/badge/license-MIT-blue.svg)

A versatile script that allows players to equip customizable military goggles with night and heat vision features.

## UPDATES

 Update Log for BS_MilGoggles 

We’re excited to bring you the latest improvements to BS_MilGoggles! Here’s what’s new:

    Helmet Integration: Natively checks for configured helmets, ensuring seamless integration.
    Helmet Removal Detection: Now natively detects when a helmet is removed for a smoother experience.
    SkinChangeFunction Example: Added a simple example using Illenium to simplify customization.
    Overlay Retention: Keeps the current overlay active when entering a vehicle, maintaining consistency.
    Helmet Reapplication Option: Added an option to allow putting the helmet back on automatically when entering a vehicle.

Make sure to update your script to enjoy these new features and improvements!

## 🌟 Features

- **Configurable Goggles**: Add clothing items as military goggles, fully customizable through the config.
- **Custom Key Bindings**: Set up key bindings to trigger night and heat vision actions.
- **Synced Emotes**: Ensure emotes are fully synchronized between players for a seamless experience.
- **Skin System Integration**: Easily integrate with existing skin systems by modifying `Config.SkinChangeFunction`.
- **Quick Action Exports**: Use simple exports to equip or remove goggles.

## 📦 Installation

1. Clone this repository into your server's `resources` folder.
2. Add `ensure bs_milgoggles` to your `server.cfg` file.
3. Edit the `config.lua` to customize your setup.
4. Restart your server.

## ⚙️ Configuration

To integrate the goggles with your clothing system, use the following `Config.SkinChangeFunction`:

```lua
Config.SkinChangeFunction = function(value, gogglesOn) -- Hat/Helmet Skin ID, Goggles On Check
    -- Works with OUR fivem-appearance/inventory/metadata clothes system
    TriggerEvent('skinchanger:getSkin', function(skin)
        local compIndex
        for i = 1, #skin.props do 
            if skin.props[i].prop_id and skin.props[i].prop_id == 0 then 
                compIndex = i 
                break 
            end 
        end
        if not compIndex then compIndex = 1 end
        local updatedClothes = {["helmet_1"] = value, ["helmet_2"] = 0}
        skin.props[compIndex].drawable = value
        skin.props[compIndex].texture = 0
        TriggerEvent('skinchanger:loadClothes', skin, updatedClothes)
        TriggerServerEvent('fivem-appearance:save', skin)
    end)
    -- Probably will need to be changed for your clothes system
end
```

Example exports to use the goggles:

- **Equip Goggles**: `exports["BS_MilGoggles"]:PutGogglesOn(Config.Clothing.Gender.goggles[gogglesKey], true)`
- **Remove Goggles**: `exports["BS_MilGoggles"]:TakeGogglesOff()`

## 🎮 Usage

Players can equip and use military goggles in-game:

1. Add the goggles item to their inventory.
2. Use the configured keys to toggle night or heat vision.
3. Enjoy synchronized emotes with other players.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 👏 Show your support

Give a ⭐️ if you found this script helpful!
