// ERC721 intefaces
mod erc721_interface;
use erc721_interface::IERC721;

// Base ERC721 implementation
mod erc721_base;
use erc721_base::ERC721; // Import as ERC721 when resolving dependencies


////////////////////////////////
// ERC721 presets
////////////////////////////////
mod presets;

use presets::ERC721MintableBurnable; // Import as ERC721MintableBurnable when resolving dependencies
use presets::ERC721Preset3;
use presets::ERC721Preset2;

////////////////////////////////
// ERC721 tests
////////////////////////////////
mod tests;

mod corelib_extension;