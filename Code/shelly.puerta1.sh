#!/usr/bin/python3.7

#   _____          _ __                  _                                _ _           _                                 _______ ______ _____    _    _       _      
#  / ____|        | /_/                 | |                              | | |         | |                               |__   __|  ____/ ____|  | |  | |     (_)     
# | |     ___   __| |_  __ _  ___     __| | ___  ___  __ _ _ __ _ __ ___ | | | __ _  __| | ___    _ __   __ _ _ __ __ _     | |  | |__ | |  __   | |  | |_ __  _ _ __ 
# | |    / _ \ / _` | |/ _` |/ _ \   / _` |/ _ \/ __|/ _` | '__| '__/ _ \| | |/ _` |/ _` |/ _ \  | '_ \ / _` | '__/ _` |    | |  |  __|| | |_ |  | |  | | '_ \| | '__|
# | |___| (_) | (_| | | (_| | (_) | | (_| |  __/\__ \ (_| | |  | | | (_) | | | (_| | (_| | (_) | | |_) | (_| | | | (_| |    | |  | |   | |__| |  | |__| | | | | | |   
#  \_____\___/ \__,_|_|\__, |\___/   \__,_|\___||___/\__,_|_|  |_|  \___/|_|_|\__,_|\__,_|\___/  | .__/ \__,_|_|  \__,_|    |_|  |_|    \_____|   \____/|_| |_|_|_|   
# __     __             __/ |______                         ___   ___ ___  _  _                  | |                                                                  
# \ \   / /            |___/__   __|                       |__ \ / _ \__ \| || |                 |_|                                                                  
#  \ \_/ /_ _  __ _  ___      | | ___  _ __ _ __ ___  ___     ) | | | | ) | || |_                                                                                     
#   \   / _` |/ _` |/ _ \     | |/ _ \| '__| '__/ _ \/ __|   / /| | | |/ /|__   _|                                                                                    
#    | | (_| | (_| | (_) |    | | (_) | |  | | |  __/\__ \  / /_| |_| / /_   | |                                                                                      
#    |_|\__,_|\__, |\___/     |_|\___/|_|  |_|  \___||___/ |____|\___/____|  |_|                                                                                      
#              __/ |                                                                                                                                                  
#             |___/                                                                                                                                                   

curl -X POST https://shelly-38-eu.shelly.cloud/device/relay/control -d "channel=0&turn=on&id=441793A4ADC0&auth_key=MTAzxxx49224"