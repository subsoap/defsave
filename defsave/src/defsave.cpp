// Extension lib defines
#define LIB_NAME "Defsave"
#define MODULE_NAME "defsave_ext"

#include <dmsdk/sdk.h>
#include <dmsdk/dlib/crypt.h>
#include <string.h>
#include <stdlib.h>


//https://github.com/defold/extension-crypt/blob/master/crypt/src/crypt.cpp
static int Base64Encode(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);

    size_t srclen;
    const char* src = luaL_checklstring(L, 1, &srclen);

    // 4 characters to represent every 3 bytes with padding applied
    // for binary data which isn't an exact multiple of 3 bytes.
    // https://stackoverflow.com/a/7609180/1266551
    uint32_t dstlen = srclen * 4 / 3 + 4;
    uint8_t* dst = (uint8_t*)malloc(dstlen);

    if (dmCrypt::Base64Encode((const uint8_t*)src, srclen, dst, &dstlen))
    {
        lua_pushlstring(L, (char*)dst, dstlen);
    }
    else
    {
        lua_pushnil(L);
    }
    free(dst);
    return 1;
}

static int Base64Decode(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);

    size_t srclen;
    const char* src = luaL_checklstring(L, 1, &srclen);

    uint32_t dstlen = srclen * 3 / 4;
    uint8_t* dst = (uint8_t*)malloc(dstlen);

    if (dmCrypt::Base64Decode((const uint8_t*)src, srclen, dst, &dstlen))
    {
        lua_pushlstring(L, (char*)dst, dstlen);
    }
    else
    {
        lua_pushnil(L);
    }
    free(dst);
    return 1;
}

static const luaL_reg Module_methods[] =
{
    {"encode_base64", Base64Encode},
    {"decode_base64", Base64Decode},
    {0, 0}
};

static void LuaInit(lua_State* L)
{
    int top = lua_gettop(L);

    // Register lua names
    luaL_register(L, MODULE_NAME, Module_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

dmExtension::Result InitializeDefsaveExtension(dmExtension::Params* params)
{
    // Init Lua
    LuaInit(params->m_L);
    dmLogInfo("Registered %s Extension\n", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(DefsaveExtension, LIB_NAME, 0, 0, InitializeDefsaveExtension, 0, 0, 0)