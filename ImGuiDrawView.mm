#include "LoadView/Includes.h"
#import "LoadView/DTTJailbreakDetection.h"
#import "imgui/Il2cpp.h"
#import "Utils/Macros.h"
#import "Utils/hack/Function.h"
#import "Utils/Mem.h"
#include "font.h"
#include "hook/hook.h"
#import "Other/Vector/Vector3.h"
#import "Other/Vector/Vector2.h"
#import "Other/Vector/Quaternion.h"
#import "Other/Vector/Monostring.h"
#include "Other/Icon.h"
#include "Other/iconcpp.h"
ImFont *_espFont;
#import "Esp.h"
#include "Other/AimKill.cpp"
#include "hook/hook.h"

#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]




using namespace IL2Cpp;
@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

UIView *view;
NSString *jail;
NSString *namedv;
NSString *deviceType;
NSString *bundle;
NSString *ver;


UILabel *menuTitle;   

@implementation ImGuiDrawView
bool Guest;
bool Telecar, Telekill;
bool ResetGuest(void *instance){
    if (Guest) return true; Guest = false;
}

bool isFov(Vector3 vec1, Vector3 vec2, int radius) {
    int x = vec1.x;
    int y = vec1.y;

    int x0 = vec2.x;
    int y0 = vec2.y;
    if ((pow(x - x0, 2) + pow(y - y0, 2) ) <= pow(radius, 2)) {
        return true;
    } else {
        return false;
    }
}

void *GetClosestEnemy(void *match) {
    if (!match) {
        return nullptr;
    }
    float shortestDistance = 99999.0f;
    float maxAngle = AimFov;
    void *ClosestEnemy = NULL;
    void *LocalPlayer = GetLocalPlayer(match);
    if (LocalPlayer != nullptr) {
        Dictionary<uint8_t *, void **> *players = *(Dictionary<uint8_t*, void **> **)((long)match + 0x90);
        for(int u = 0; u < players->getNumValues(); u++) {
            void *Player = players->getValues()[u];
            if (Player != NULL && !get_isLocalTeam(Player) && !get_IsDieing(Player) && get_isVisible(Player) && get_MaxHP(Player) && !IsPlayerDead(Player)) {
                Vector3 PlayerPos = GetHipPosition(Player);
                Vector3 LocalPlayerPos = GetHeadPosition(LocalPlayer);
				if (aimStart) {
				if (AimWhen == 1) {
                    Vector3 targetDir = Vector3::Normalized(PlayerPos - LocalPlayerPos);
                    float angle = Vector3::Angle(targetDir, GetForward(Component_GetTransform(Camera_main())))  *100.0;
                    if (angle <= maxAngle) {
						if (IsVisible(Player)) {
                        if (angle < shortestDistance) {
                            shortestDistance = angle;
                            ClosestEnemy = Player;
                            }
                        }
                    }
                } else if (AimWhen == 0) {
                    Vector3 targetDir = Vector3::Normalized(PlayerPos - LocalPlayerPos);
                    float angle = Vector3::Angle(targetDir, GetForward(Component_GetTransform(Camera_main())))  *100.0;
                    if (angle <= maxAngle) {
if (IsVisible(Player)) {
                        if (angle < shortestDistance) {
                            shortestDistance = angle;
                            ClosestEnemy = Player;
						      }
}
							}
							
							}
                        }
                    }
                }
            }
    return ClosestEnemy;
}
void _LateUpdate(void *player) {
  if (player != NULL) {
      void *Match = CurentMatch();
      if (Match != NULL) {
         void *LocalPlayer = GetLocalPlayer(Match);                        
         if (LocalPlayer != NULL) {
             void *ClosestEnemy = GetClosestEnemy(Match);
             if (ClosestEnemy != NULL) {
                                              
tS++;
       if (tS > 1 && autotroca) {
         sID = !sID;
         SwapWeapon(LocalPlayer, sID, true);
           tS = 0;
            }
                 Vector3 EnemyLocation = GetHeadPosition(ClosestEnemy);
                 Vector3 PlayerLocation = CameraMain(LocalPlayer);
                 Quaternion PlayerLook = GetRotationToLocation(EnemyLocation, 0.1f, PlayerLocation);                  
                 
                 Vector3 LocalPlayerPos = GetHeadPosition(LocalPlayer);
                 Vector3 PlayerHeadPos = GetHeadPosition(ClosestEnemy);
                 float distance = Vector3::Distance(LocalPlayerPos, PlayerHeadPos);
            
                 if (AimScope && get_IsSighting(LocalPlayer)) {
                     set_aim(LocalPlayer, PlayerLook);
                 }
                 if (AimFire && get_IsFiring(LocalPlayer)) {
                     set_aim(LocalPlayer, PlayerLook);
                 }
				 
                 if (AimKill) {
                     PlayerTakeDamage(ClosestEnemy);
                 }	
if (Telekill) {
                    void *_MountTF = Component_GetTransform(ClosestEnemy);
                    if (_MountTF != NULL) {
                        Vector3 MountTF =Transform_INTERNAL_GetPosition(_MountTF) -(GetForward(_MountTF) * 0.0f);
                        Transform_INTERNAL_SetPosition(Component_GetTransform(LocalPlayer),Vvector3(MountTF.x+1.4f, MountTF.y + 1.4f, MountTF.z+1.4f));
                    }
                }
             }
         } 
      }
  }
}


void (*Update)(void* gamestartup);
void _Update(void* gamestartup) {
if(Update) {
void* Match = CurentMatch();
if((AimFire || AimScope || AimKill) && Match) {
}
}
}

ImFont *_iconFont;

static bool MenDeal = false;
static bool StreamerMode = false;
static bool hidetoplabel = false;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{

    [self cc];

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
menuTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
	menuTitle.text = [NSString stringWithUTF8String:oxorany("")];
	menuTitle.textColor = UIColorFromHex(0x72FF13);
	menuTitle.font = [UIFont fontWithName:[NSString stringWithUTF8String:oxorany("AppleSDGothicNeo-Light")] size:19.0f];
	menuTitle.textAlignment = NSTextAlignmentCenter;
	[menuTitle sizeToFit]; //make container the same size as the resulting text
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
	menuTitle.center = CGPointMake(CGRectGetMidX(mainWindow.bounds), 20);
	menuTitle.adjustsFontSizeToFitWidth = true;
    [mainWindow addSubview: menuTitle];


    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();

	    ImGui::StyleColorsDark();
        ImGuiStyle& style = ImGui::GetStyle();
        style.WindowRounding = 5.0f;
        style.FrameRounding = 5.0f;
        style.PopupRounding = 5.0f;
        style.ScrollbarRounding = 5.0f;
        style.GrabRounding = 5.0f;
        style.TabRounding = 5.0f;
    NSString *FontPath = @"/System/Library/Fonts/AppFonts/AppleGothic.otf";
    static const ImWchar icons_ranges[] = { 0xf000, 0xf3ff, 0 };
    ImFontConfig icons_config;

    ImFontConfig CustomFont;
    CustomFont.FontDataOwnedByAtlas = false;

 
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;

    io.Fonts->AddFontFromMemoryTTF(const_cast<std::uint8_t*>(Custom), sizeof(Custom), 21.f, &CustomFont);
    _espFont=io.Fonts->AddFontFromMemoryCompressedTTF(font_awesome_data, font_awesome_size, 19.0f, &icons_config, icons_ranges);
    io.Fonts->AddFontDefault();
    ImGui_ImplMetal_Init(_device);
    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

+ (BOOL)isMenuShowing {
    return MenDeal;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

-(void)cc
{

ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:nssoxorany("CFBundleShortVersionString")];

bundle = [[NSBundle mainBundle] bundleIdentifier];

namedv = [[UIDevice currentDevice] name];
deviceType = [[UIDevice currentDevice] model];

if ([DTTJailbreakDetection isJailbroken]) {
jail = nssoxorany("Jailbroken");

}else{
jail = nssoxorany("Not Jailbroken Or Hidden Jailbreak");

}
}

- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    if (!self.mtkView.device) {
        return;
    }
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;



}

- (void)drawInMTKView:(MTKView*)view
{

    hideRecordTextfield.secureTextEntry = StreamerMode;

    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        
        if (MenDeal == true) 
        {
            [self.view setUserInteractionEnabled:YES];
            [self.view.superview setUserInteractionEnabled:YES];
            [menuTouchView setUserInteractionEnabled:YES];
        } 
        else if (MenDeal == false) 
        {
           
            [self.view setUserInteractionEnabled:NO];
            [self.view.superview setUserInteractionEnabled:NO];
            [menuTouchView setUserInteractionEnabled:NO];

        }

Attach();

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:nssoxorany("ImGui Jane")];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();

            ImFont* font = ImGui::GetFont();
    font->Scale = 16.f / font->FontSize;
    CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 380) / 2;
    CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 260) / 2;
    ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);



            
   if (MenDeal == true) {

   char* Gnam = (char*) [[NSString stringWithFormat:nssoxorany("STARK MODE"), ver] cStringUsingEncoding:NSUTF8StringEncoding];
ImGui::Begin(Gnam, &MenDeal, ImGuiWindowFlags_AlwaysAutoResize);
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.55f);

    ImGui::BeginTabBar(oxorany("Bar"), ImGuiTabBarFlags_NoTooltip);

if (ImGui::BeginTabItem(oxorany(ICON_FA_CROSSHAIRS "AimBot"))) {

    ImGui::Checkbox(oxorany("Enable Aimbot"), &aimStart);

    ImGui::Separator();

    ImGui::Checkbox(oxorany("Enable - AimFire"), &AimFire);
    ImGui::Checkbox(oxorany("Enable - AimScope"), &AimScope);

    ImGui::Text(oxorany("Aim Fov"));
    ImGui::SliderFloat(oxorany("##circle"), &AimFov, 0.0f, 360.0f);

    ImGui::Combo(oxorany("Aim Trigger"), &AimWhen, "Always\0Firing\0Aiming\0");

    ImGui::EndTabItem();
}

if (ImGui::BeginTabItem(oxorany(ICON_FA_EYE " Esp"))){
                ImGui::Spacing();
                ImGui::Checkbox(oxorany("Enable Esp"), &ESPEnable);
                ImGui::Separator();
                ImGui::Checkbox(oxorany("Esp - Lines"), &ESPLine);
                ImGui::Checkbox(oxorany("Esp - Boxes"), &ESPBox);

                ImGui::Checkbox(oxorany("Esp - Name"), &ESPName);
                ImGui::Checkbox(oxorany("Esp - Health"), &ESPHealth);
                ImGui::Separator(); 
                ImGui::Spacing();
                ImGui::EndTabItem();
            }
            if (ImGui::BeginTabItem(oxorany(ICON_FA_COGS " Settings"))){
                ImGui::Checkbox(oxorany("Stream Mode"), &StreamerMode);
                ImGui::Spacing();
                ImGui::Checkbox(oxorany("Hide Top Label"), &hidetoplabel);
                
                ImGui::Spacing();
                ImGui::ColorEdit3(oxorany("Color Esp"), &*(float*)colorEsp, ImGuiColorEditFlags_NoInputs);
                ImGui::Spacing();
	                if (ImGui::Combo(oxorany("Color Menu"), &style_idx, "Dark\0Blue\0Red\0Light\0Classic\0"))
	                {
	                    ImGuiStyle& style = ImGui::GetStyle();
	                    switch (style_idx)
	                    {
	                        case 0: // Black (Dark)
                                ImGui::StyleColorsDark();
                                style.Colors[ImGuiCol_WindowBg] = ImVec4(0.00f, 0.00f, 0.00f, 0.94f);
                                style.Colors[ImGuiCol_TitleBg] = ImVec4(0.05f, 0.05f, 0.05f, 1.00f);
                                style.Colors[ImGuiCol_TitleBgActive] = ImVec4(0.10f, 0.10f, 0.10f, 1.00f);
                                style.Colors[ImGuiCol_Header] = ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
                                style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.30f, 0.30f, 0.30f, 1.00f);
                                style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.40f, 0.40f, 0.40f, 1.00f);
                                style.Colors[ImGuiCol_Button] = ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
                                style.Colors[ImGuiCol_ButtonHovered] = ImVec4(0.25f, 0.25f, 0.25f, 1.00f);
                                style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.35f, 0.35f, 0.35f, 1.00f);
                                style.Colors[ImGuiCol_FrameBg] = ImVec4(0.10f, 0.10f, 0.10f, 1.00f);
                                break;
	                        case 1: // Deep Blue
                                ImGui::StyleColorsDark();
                                style.Colors[ImGuiCol_WindowBg] = ImVec4(0.00f, 0.02f, 0.10f, 0.94f);
                                style.Colors[ImGuiCol_TitleBg] = ImVec4(0.00f, 0.05f, 0.20f, 1.00f);
                                style.Colors[ImGuiCol_TitleBgActive] = ImVec4(0.00f, 0.10f, 0.30f, 1.00f);
                                style.Colors[ImGuiCol_Header] = ImVec4(0.00f, 0.20f, 0.50f, 1.00f);
                                style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.00f, 0.30f, 0.70f, 1.00f);
                                style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.00f, 0.40f, 0.90f, 1.00f);
                                style.Colors[ImGuiCol_Button] = ImVec4(0.00f, 0.15f, 0.40f, 1.00f);
                                style.Colors[ImGuiCol_ButtonHovered] = ImVec4(0.00f, 0.25f, 0.60f, 1.00f);
                                style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.00f, 0.35f, 0.80f, 1.00f);
                                style.Colors[ImGuiCol_FrameBg] = ImVec4(0.00f, 0.05f, 0.15f, 1.00f);
                                style.Colors[ImGuiCol_CheckMark] = ImVec4(0.20f, 0.60f, 1.00f, 1.00f);
                                style.Colors[ImGuiCol_SliderGrab] = ImVec4(0.20f, 0.60f, 1.00f, 1.00f);
                                style.Colors[ImGuiCol_SliderGrabActive] = ImVec4(0.40f, 0.80f, 1.00f, 1.00f);
                                break;
	                        case 2: // Deep Red
                                ImGui::StyleColorsDark();
                                style.Colors[ImGuiCol_WindowBg] = ImVec4(0.10f, 0.00f, 0.00f, 0.94f);
                                style.Colors[ImGuiCol_TitleBg] = ImVec4(0.20f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_TitleBgActive] = ImVec4(0.30f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_Header] = ImVec4(0.50f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.70f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.90f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_Button] = ImVec4(0.40f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_ButtonHovered] = ImVec4(0.60f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.80f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_FrameBg] = ImVec4(0.15f, 0.00f, 0.00f, 1.00f);
                                style.Colors[ImGuiCol_CheckMark] = ImVec4(1.00f, 0.20f, 0.20f, 1.00f);
                                style.Colors[ImGuiCol_SliderGrab] = ImVec4(1.00f, 0.20f, 0.20f, 1.00f);
                                style.Colors[ImGuiCol_SliderGrabActive] = ImVec4(1.00f, 0.40f, 0.40f, 1.00f);
                                break;
                            case 3: ImGui::StyleColorsLight(); break;
	                        case 4: ImGui::StyleColorsClassic(); break;
	                    }
	                }
                ImGui::Spacing();
                ImGui::EndTabItem();
            }
	            if (ImGui::BeginTabItem(oxorany(" More"))) {
	                ImGui::Spacing();
	                if(ImGui::Button(oxorany("Reset Guest"))) {Guest = true;}
	                ImGui::Checkbox(oxorany("Telekill Enemy"), &Telekill);
                    
                    ImGui::Separator();
                    ImGui::Text(oxorany("New Functions"));
                    
                    if (ImGui::Button(oxorany(AIMKKILL ? "AIMKKILL [ON]" : "AIMKKILL [OFF]"), ImVec2(-1, 30))) { AIMKKILL = !AIMKKILL; }
                    if (ImGui::Button(oxorany(NINJARUN ? "NINJARUN [ON]" : "NINJARUN [OFF]"), ImVec2(-1, 30))) { NINJARUN = !NINJARUN; }
                    if (ImGui::Button(oxorany(AI_PLAYER ? "AI PLAYER [ON]" : "AI PLAYER [OFF]"), ImVec2(-1, 30))) { AI_PLAYER = !AI_PLAYER; }
                    if (ImGui::Button(oxorany(FLYJUMP ? "FLYJUMP [ON]" : "FLYJUMP [OFF]"), ImVec2(-1, 30))) { FLYJUMP = !FLYJUMP; }
                    if (ImGui::Button(oxorany(AUTOFLY ? "AUTOFLY [ON]" : "AUTOFLY [OFF]"), ImVec2(-1, 30))) { AUTOFLY = !AUTOFLY; }
                    if (ImGui::Button(oxorany(FLYV2 ? "FLYV2 [ON]" : "FLYV2 [OFF]"), ImVec2(-1, 30))) { FLYV2 = !FLYV2; }
                    if (ImGui::Button(oxorany(STOP ? "STOP [ON]" : "STOP [OFF]"), ImVec2(-1, 30))) { STOP = !STOP; }
                    if (ImGui::Button(oxorany(MOVE ? "MOVE [ON]" : "MOVE [OFF]"), ImVec2(-1, 30))) { MOVE = !MOVE; }
                    if (ImGui::Button(oxorany(XMOVE ? "XMOVE [ON]" : "XMOVE [OFF]"), ImVec2(-1, 30))) { XMOVE = !XMOVE; }
                    if (ImGui::Button(oxorany(AIMKILL_0s ? "AIMKILL 0s [ON]" : "AIMKILL 0s [OFF]"), ImVec2(-1, 30))) { AIMKILL_0s = !AIMKILL_0s; }

	                ImGui::EndTabItem();
	}
if (ImGui::BeginTabItem(oxorany(ICON_FA_ADDRESS_CARD "InFo"))) {
ImGui::SeparatorText(oxorany("Contact US"));
ImGui::TextDisabled(oxorany("Developer:"));
ImGui::SameLine();
ImGui::TextLinkOpenURL(oxorany("MRWANX"), oxorany("https://t.me/MRWANX"));
ImGui::TextDisabled(oxorany("CHANNEL:"));
ImGui::SameLine();
ImGui::TextLinkOpenURL(oxorany("MY CHANNEL"), oxorany("https://t.me/MRWANXIOS"));
ImGui::SameLine();
ImGui::TextLinkOpenURL(oxorany("MY Chat"), oxorany("https://t.me/MRWANXIOSCHAT"));
ImGui::Spacing();
ImGui::EndTabItem();
}

            
            ImGui::EndTabBar();
        
        ImGui::Spacing();
        ImGui::Separator();
        ImGui::Spacing();
        
        ImGui::End();
}
DrawEsp();
if(hidetoplabel) {
        menuTitle.hidden = YES;
    } else {
         menuTitle.hidden = NO;
    }

auto Draw = ImGui::GetBackgroundDrawList();
    if (enable_circleFov)
    {
         Draw->AddCircle(ImVec2(kWidth/2, kHeight/2), circleSizeValue, IM_COL32(255, 0, 0, 255), 100, 1.0f);
    }
            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
            
        }
        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

ImDrawList* getDrawList(){
    ImDrawList *drawList;
    drawList = ImGui::GetBackgroundDrawList();
    return drawList;
};
void hooking() {
void* address[] = {
        (void*)getRealOffset(ENCRYPTOFFSET("0x1057358E0")), 
                (void*)getRealOffset(ENCRYPTOFFSET("0x10249B264")),

(void*)getRealOffset(ENCRYPTOFFSET("0x1056D2414")),

(void*)getRealOffset(ENCRYPTOFFSET("0x101AF14C4")),


    };
    void* function[] = {
        (void*)_LateUpdate,
        (void*)ResetGuest,
        (void*)DamageInfoHook,
        (void*)_Update
       
    };
    hook(address, function, 4);


get_transform = (void *(*)(void *))getRealOffset(ENCRYPTOFFSET("0x106366CE8")); 
  
get_transformFF = (void *(*)(void *)) getRealOffset(ENCRYPTOFFSET("0x104ADACD4"));

get_position = (Vector3 (*)(void*)) getRealOffset(ENCRYPTOFFSET("0x1063ABA1C"));

get_camera = (void *(*)()) getRealOffset(ENCRYPTOFFSET("0x106364C78"));

worldToScreen = (Vector3 (*)(void *, Vector3)) getRealOffset(ENCRYPTOFFSET("0x106364580"));

WorldToViewpoint = (Vector3 (*)(void *, Vector3, int ))getRealOffset(ENCRYPTOFFSET("0x106364304"));


}

void *hack_thread(void *) {

    sleep(5);
    hooking();
    pthread_exit(nullptr);
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL); 
}

@end