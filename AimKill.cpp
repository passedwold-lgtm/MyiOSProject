#include "Includes.h"
#include <stdint.h>
#include <vector>
#include <ctime>   // 👈 เพิ่ม
#include "MethodObfuscation.h"
#include "Vector3.h"

// ================= BASIC =================

void* PlayerWeaponOnHand(void* Player){
    void*(*WeaponOnHand)(void*) = (void*(*)(void*))getRealOffset(ENCRYPTOFFSET("0x1056EA1D8"));
    return WeaponOnHand(Player);
}

Vector3 CameraPosition(void* Player){ 
    Vector3 Position = Vector3::zero();
    void(*PositionInjected)(void*,Vector3*) = (void(*)(void*,Vector3*))getRealOffset(ENCRYPTOFFSET("0x1063ABA4C"));
    PositionInjected(*(void**)((uintptr_t) Player + 0x1C8), &Position);
    return Position;
}

// 🔥 เปลี่ยน uint → int
void* PlayerTakeDamageReal(void* Player, void* DamageInfo, void* DamagerWeaponDynamicInfo, void* CheckParams, int DamagerVehicleID){
    void*(*TakeDamage)(void*,void*,void*,void*,int) =
    (void*(*)(void*,void*,void*,void*,int))getRealOffset(ENCRYPTOFFSET("0x105742774"));

    return TakeDamage(Player, DamageInfo, DamagerWeaponDynamicInfo, CheckParams, DamagerVehicleID);
}

void PlayerNetworkStartWholeBodyFiring(void* Player, void* WeaponOnHand){
    void(*StartWholeBodyFiring)(void*,void*) =
    (void(*)(void*,void*))getRealOffset(ENCRYPTOFFSET("0x105874570"));

    StartWholeBodyFiring(Player, WeaponOnHand);
}

void PlayerNetworkStopFire(void* Player, void* WeaponOnHand){
    void(*StopFire)(void*,void*) =
    (void(*)(void*,void*))getRealOffset(ENCRYPTOFFSET("0x105874BE8"));

    StopFire(Player, WeaponOnHand);
}

void* GameFacadeCurrentLocalPlayer(){
    void*(*CurrentLocalPlayer)(void*) =
    (void*(*)(void*))getRealOffset(ENCRYPTOFFSET("0x1025F16C0"));

    return CurrentLocalPlayer(nullptr); // ✅ แก้แล้ว
}

Vector3 PlayerHeadPosition(void* Player){
    void*(*HeadPosition)(void*) =
    (void*(*)(void*))getRealOffset(ENCRYPTOFFSET("0x10575A2E8"));

    Vector3 Position = Vector3::zero();

    void(*PositionInjected)(void*,Vector3*) =
    (void(*)(void*,Vector3*))getRealOffset(ENCRYPTOFFSET("0x1063ABA4C"));

    PositionInjected(HeadPosition(Player), &Position);
    return Position;
}

// ================= AIM =================

namespace Save {
    void* DamageInfo;
    clock_t AimDelay;
    int AimFPS = (1000000 / 15);
}

void (*DamageInfoHookPtr)(void*);
void DamageInfoHook(void* Player){
    Save::DamageInfo = Player;
}

// 🔥 เปลี่ยนชื่อ (กันชน)
void AimKillPlayer(void* ClosestEnemy){
    void* CurrentMatch = CurentMatch();
    void* LocalPlayer = GameFacadeCurrentLocalPlayer();

    if (!Camera_main() || !CurrentMatch || CurrentMatch == nullptr ||
        LocalPlayer == nullptr || get_IsDieing(LocalPlayer) || !get_isLiving(LocalPlayer))
        return;

    if (Save::DamageInfo != nullptr && clock() > Save::AimDelay){
        Save::AimDelay = clock() + Save::AimFPS;

        void* WeaponOnHand = PlayerWeaponOnHand(LocalPlayer);

        if (WeaponOnHand != nullptr){
            *(void**)((uintptr_t)Save::DamageInfo + 0x28) = *(void**)((uintptr_t)LocalPlayer + 0x1E8);
            *(void**)((uintptr_t)Save::DamageInfo + 0x40) = WeaponOnHand;
            *(Vector3*)((uintptr_t)Save::DamageInfo + 0x4C) = CameraPosition(LocalPlayer);
            *(Vector3*)((uintptr_t)Save::DamageInfo + 0x58) = PlayerHeadPosition(ClosestEnemy);

            PlayerNetworkStartWholeBodyFiring(LocalPlayer, WeaponOnHand);

            PlayerTakeDamageReal(ClosestEnemy, Save::DamageInfo, nullptr,
                *(void**)((uintptr_t)ClosestEnemy + 0xCD0), 0);

            PlayerNetworkStopFire(LocalPlayer, WeaponOnHand);
        }
    }
}
