// Entry point for the build script in your package.json
import bootstrap from "bootstrap"
import Blacklight from "blacklight"
import "grenander/search_sources_menu"

import BlacklightRangeLimit from "blacklight-range-limit";
BlacklightRangeLimit.init({onLoadHandler: Blacklight.onLoad });
